import { Injectable, InternalServerErrorException, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import axios from 'axios';

interface SessionData {
    sessionId: string;
    state: string;
    status: 'pending' | 'success' | 'error';
    timestamp: number;
    expiresAt: number;
    error?: string;
    epicAccountId?: string;
    userData?: {
        displayName: string;
        email: string;
        avatar?: string;
        locale: string;
    };
}

@Injectable()
export class EpicService {
    private readonly logger = new Logger(EpicService.name);
    private readonly sessions = new Map<string, SessionData>();

    private readonly EPIC_API_URL = 'https://api.epicgames.dev';
    private readonly EPIC_AUTH_URL = 'https://www.epicgames.com/id/authorize';
    private readonly SESSION_TTL = 10 * 60 * 1000; // 10 minutos

    constructor(
        private readonly configService: ConfigService,
        private readonly jwtService: JwtService,
    ) {
        // Cleanup expired sessions every 5 minutes
        setInterval(() => {
            this.cleanupExpiredSessions();
        }, 5 * 60 * 1000);
    }

    /**
     * Inicia processo de conexão Epic Games - Endpoint: GET /auth/epic/start
     */
    startEpicConnection(): { sessionId: string; authUrl: string } {
        const sessionId = this.generateSessionId();
        const state = this.generateSecureState();
        const clientId: string | undefined =
            this.configService.get<string>('EPIC_CLIENT_ID');
        const redirectUri: string | undefined =
            this.configService.get<string>('EPIC_CALLBACK_URL');

        if (!clientId) {
            throw new InternalServerErrorException('Epic Games Client ID is not configured');
        }

        if (!redirectUri) {
            throw new InternalServerErrorException('Epic Games callback URL is not configured');
        }

        // Criar sessão temporária
        const sessionData: SessionData = {
            sessionId,
            state,
            status: 'pending',
            timestamp: Date.now(),
            expiresAt: Date.now() + this.SESSION_TTL,
        };

        this.sessions.set(sessionId, sessionData);

        // Construir URL Epic Games OAuth
        const params = new URLSearchParams({
            client_id: clientId,
            redirect_uri: redirectUri,
            response_type: 'code',
            scope: 'basic_profile',
            state: `${sessionId}:${state}`,
        });

        const authUrl = `${this.EPIC_AUTH_URL}?${params.toString()}`;

        this.logger.log(`Epic connection started for session: ${sessionId}`);

        return {
            sessionId,
            authUrl,
        };
    }

    /**
     * Processa callback Epic Games - Endpoint: GET /auth/epic/callback
     */
    async processEpicCallback(callbackData: any): Promise<{ redirectUrl: string }> {
        const { code, state: stateParam, error } = callbackData;

        // Extrair sessionId e state do parâmetro state
        const [sessionId, expectedState] = stateParam?.split(':') || [];

        if (!sessionId || !expectedState) {
            throw new InternalServerErrorException('Invalid state parameter');
        }

        const sessionData = this.sessions.get(sessionId);
        if (!sessionData) {
            throw new InternalServerErrorException('Session not found or expired');
        }

        // Verificar state para prevenir CSRF
        if (expectedState !== sessionData.state) {
            this.updateSessionError(sessionId, 'Invalid state - possible CSRF attack');
            throw new InternalServerErrorException('Invalid state parameter');
        }

        // Verificar se houve erro na autorização
        if (error) {
            const errorMessage = `Epic authorization error: ${error}`;
            this.updateSessionError(sessionId, errorMessage);
            return { redirectUrl: this.getAppRedirectUrl('error', errorMessage) };
        }

        if (!code) {
            const errorMessage = 'No authorization code received from Epic Games';
            this.updateSessionError(sessionId, errorMessage);
            return { redirectUrl: this.getAppRedirectUrl('error', errorMessage) };
        }

        try {
            // Trocar authorization code por access token
            const tokenData = await this.exchangeCodeForToken(code);

            // Buscar dados do usuário
            const userData = await this.fetchEpicUserData(tokenData.access_token);

            // Atualizar sessão com sucesso
            this.updateSessionSuccess(sessionId, userData.account_id, userData);

            this.logger.log(`Epic connection successful for user: ${userData.displayName}`);

            return { redirectUrl: this.getAppRedirectUrl('success') };
        } catch (error) {
            const errorMessage = `Failed to complete Epic authentication: ${error.message}`;
            this.updateSessionError(sessionId, errorMessage);
            return { redirectUrl: this.getAppRedirectUrl('error', errorMessage) };
        }
    }

    /**
     * Consulta status da sessão - Endpoint: GET /auth/status/{session_id}
     */
    getSessionStatus(sessionId: string): {
        platform: string;
        status: 'pending' | 'success' | 'error';
        epicAccountId?: string;
        userData?: {
            displayName: string;
            email: string;
            avatar?: string;
            locale: string;
        };
        error?: string;
    } {
        const sessionData = this.sessions.get(sessionId);

        if (!sessionData) {
            return {
                platform: 'epic',
                status: 'error',
                error: 'Session not found or expired',
            };
        }

        // Verificar expiração
        if (Date.now() > sessionData.expiresAt) {
            this.sessions.delete(sessionId);
            return {
                platform: 'epic',
                status: 'error',
                error: 'Session expired',
            };
        }

        const response: {
            platform: string;
            status: 'pending' | 'success' | 'error';
            epicAccountId?: string;
            userData?: {
                displayName: string;
                email: string;
                avatar?: string;
                locale: string;
            };
            error?: string;
        } = {
            platform: 'epic',
            status: sessionData.status,
        };

        if (sessionData.status === 'success' && sessionData.userData) {
            response.epicAccountId = sessionData.epicAccountId;
            response.userData = sessionData.userData;
        }

        if (sessionData.status === 'error') {
            response.error = sessionData.error;
        }

        return response;
    }

    /**
     * Troca authorization code por access token
     */
    private async exchangeCodeForToken(code: string): Promise<any> {
        const clientId = this.configService.get<string>('EPIC_CLIENT_ID');
        const clientSecret = this.configService.get<string>('EPIC_CLIENT_SECRET');
        const redirectUri = this.configService.get<string>('EPIC_CALLBACK_URL');

        const tokenEndpoint = `${this.EPIC_API_URL}/epic/oauth/v1/token`;
        if (!clientId || !clientSecret || !redirectUri) {
            throw new Error('Epic Games OAuth configuration missing');
        }
        const data = new URLSearchParams({
            grant_type: 'authorization_code',
            code: code,
            client_id: clientId,
            client_secret: clientSecret,
            redirect_uri: redirectUri,
        });

        try {
            const response = await axios.post(tokenEndpoint, data, {
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
            });

            return response.data;
        } catch (error) {
            this.logger.error(`Failed to exchange Epic code for token: ${error.message}`);
            throw new Error(`Token exchange failed: ${error.response?.data?.error_description || error.message}`);
        }
    }

    /**
     * Busca dados do usuário Epic Games
     */
    private async fetchEpicUserData(accessToken: string): Promise<any> {
        const userEndpoint = `${this.EPIC_API_URL}/epic/id/v1/accounts`;

        try {
            const response = await axios.get(userEndpoint, {
                headers: {
                    'Authorization': `Bearer ${accessToken}`,
                },
            });

            // Epic retorna um array, pegamos o primeiro (usuário atual)
            const userData = response.data[0];

            return {
                account_id: userData.id,
                displayName: userData.displayName,
                email: userData.email,
                locale: userData.preferredLanguage || 'en',
                // Epic não fornece avatar diretamente na API básica
                avatar: null,
            };
        } catch (error) {
            this.logger.error(`Failed to fetch Epic user data: ${error.message}`);
            throw new Error(`User data fetch failed: ${error.response?.data?.error_description || error.message}`);
        }
    }

    private updateSessionSuccess(sessionId: string, epicAccountId: string, userData: any): void {
        const session = this.sessions.get(sessionId);
        if (session) {
            session.status = 'success';
            session.epicAccountId = epicAccountId;
            session.userData = {
                displayName: userData.displayName,
                email: userData.email,
                avatar: userData.avatar,
                locale: userData.locale,
            };
        }
    }

    private updateSessionError(sessionId: string, error: string): void {
        const session = this.sessions.get(sessionId);
        if (session) {
            session.status = 'error';
            session.error = error;
        }
    }

    private getAppRedirectUrl(status: 'success' | 'error', error?: string): string {
        const baseUrl = 'ghub://epic-auth';
        if (status === 'error') {
            return `${baseUrl}?status=error&error=${encodeURIComponent(error || 'Unknown error')}`;
        }
        return `${baseUrl}?status=success`;
    }

    private generateSessionId(): string {
        return Math.random().toString(36).substring(2, 15) +
            Math.random().toString(36).substring(2, 15);
    }

    private generateSecureState(): string {
        return Math.random().toString(36).substring(2, 15) +
            Math.random().toString(36).substring(2, 15);
    }

    private cleanupExpiredSessions(): void {
        const now = Date.now();
        for (const [sessionId, session] of this.sessions.entries()) {
            if (now > session.expiresAt) {
                this.sessions.delete(sessionId);
            }
        }
    }
}