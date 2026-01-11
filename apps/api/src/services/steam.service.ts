/* eslint-disable @typescript-eslint/no-unsafe-argument */
/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable @typescript-eslint/no-unsafe-return */
/* eslint-disable @typescript-eslint/no-unsafe-call */

import {
    Injectable,
    Logger,
    BadRequestException,
    UnauthorizedException,
    InternalServerErrorException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import axios from 'axios';
import * as crypto from 'crypto';
import { SteamApiResponse, SteamUserData } from '../interfaces/steam.interface';

interface SessionData {
    sessionId: string;
    state: string;
    status: 'pending' | 'success' | 'error';
    steamId?: string;
    userData?: SteamUserData;
    error?: string;
    timestamp: number;
    expiresAt: number;
}

@Injectable()
export class SteamService {
    private readonly logger = new Logger(SteamService.name);
    private readonly sessions = new Map<string, SessionData>();

    private readonly STEAM_OPENID_URL = 'https://steamcommunity.com/openid';
    private readonly STEAM_API_URL = 'https://api.steampowered.com';
    private readonly OPENID_NS = 'http://specs.openid.net/auth/2.0';
    private readonly SESSION_TTL = 10 * 60 * 1000; // 10 minutos

    constructor(
        private readonly configService: ConfigService,
        private readonly jwtService: JwtService,
    ) {
        // Cleanup sessões expiradas a cada 5 minutos
        setInterval(() => this.cleanExpiredSessions(), 5 * 60 * 1000);
    }

    /**
     * Inicia processo de conexão Steam - Endpoint: GET /auth/steam/start
     */
    startSteamConnection(): { sessionId: string; authUrl: string } {
        const sessionId = this.generateSessionId();
        const state = this.generateSecureState();
        const callbackUrl: string | undefined =
            this.configService.get<string>('STEAM_CALLBACK_URL');
        if (!callbackUrl) {
            throw new InternalServerErrorException('Steam API callback URL is not configured');
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

        // Construir URL Steam OpenID
        const params = new URLSearchParams({
            'openid.ns': this.OPENID_NS,
            'openid.mode': 'checkid_setup',
            'openid.return_to': `${callbackUrl}?state=${state}&session_id=${sessionId}`,
            'openid.realm': callbackUrl.split('/').slice(0, 3).join('/'),
            'openid.identity': 'http://specs.openid.net/auth/2.0/identifier_select',
            'openid.claimed_id': 'http://specs.openid.net/auth/2.0/identifier_select',
        });

        const authUrl = `${this.STEAM_OPENID_URL}/login?${params.toString()}`;

        this.logger.log(`Steam connection started - Session: ${sessionId}`);

        return { sessionId, authUrl };
    }

    /**
     * Processa callback Steam - Endpoint: GET /auth/steam/callback
     */
    async processSteamCallback(callbackData: any): Promise<{ redirectUrl: string }> {
        try {
            this.logger.log('Processing Steam callback', {
                returnTo: callbackData['openid.return_to']?.substring(0, 100),
            });

            // Extrair session_id e state
            const returnTo = callbackData['openid.return_to'];
            const url = new URL(returnTo);
            const sessionId = url.searchParams.get('session_id');
            const state = url.searchParams.get('state');

            if (!sessionId || !this.sessions.has(sessionId)) {
                throw new BadRequestException('Invalid or expired session');
            }

            const sessionData = this.sessions.get(sessionId)!;

            // Validar state
            if (sessionData.state !== state) {
                throw new BadRequestException('Invalid state parameter');
            }

            // Verificar expiração
            if (Date.now() > sessionData.expiresAt) {
                this.sessions.delete(sessionId);
                throw new BadRequestException('Session expired');
            }

            // Validar assinatura OpenID
            const isValid = await this.validateOpenIdSignature(callbackData);
            if (!isValid) {
                sessionData.status = 'error';
                sessionData.error = 'Invalid OpenID signature';
                throw new UnauthorizedException('Invalid OpenID signature');
            }

            // Extrair Steam ID
            const steamId = this.extractSteamId(callbackData['openid.identity']);
            if (!steamId) {
                sessionData.status = 'error';
                sessionData.error = 'Unable to extract Steam ID';
                throw new BadRequestException('Unable to extract Steam ID');
            }

            // Buscar dados do usuário Steam
            const userData = await this.fetchSteamUserData(steamId);

            // Atualizar sessão com sucesso
            sessionData.status = 'success';
            sessionData.steamId = steamId;
            sessionData.userData = userData;

            this.logger.log(
                `Steam connection successful - Session: ${sessionId}, User: ${userData.personaname}`,
            );

            // Redirecionar para página de conclusão
            const completeUrl = this.configService.get('STEAM_COMPLETE_URL');
            if (!completeUrl) {
                throw new InternalServerErrorException('Steam complete URL is not configured');
            }

            return {
                redirectUrl: `${completeUrl}?platform=steam&status=success&session_id=${sessionId}`,
            };
        } catch (error) {
            this.logger.error('Steam callback error', error);

            // Tentar atualizar sessão com erro se possível
            const returnTo = callbackData['openid.return_to'];
            if (returnTo) {
                try {
                    const url = new URL(returnTo);
                    const sessionId = url.searchParams.get('session_id');
                    if (sessionId && this.sessions.has(sessionId)) {
                        const sessionData = this.sessions.get(sessionId)!;
                        sessionData.status = 'error';
                        sessionData.error = error.message;
                    }
                } catch (e: any) {
                    console.error('Error updating session on failure', e);
                }
            }

            const completeUrl =
                this.configService.get('STEAM_COMPLETE_URL') ||
                'http://localhost:3000/auth/complete';

            return {
                redirectUrl: `${completeUrl}?platform=steam&status=error&error=${encodeURIComponent(error.message)}`,
            };
        }
    }

    /**
     * Consulta status da sessão - Endpoint: GET /auth/status/{session_id}
     */
    getSessionStatus(sessionId: string): {
        platform: string;
        status: 'pending' | 'success' | 'error';
        steamId?: string;
        userData?: {
            name: string;
            avatar: string;
            profileUrl: string;
        };
        error?: string;
    } {
        const sessionData = this.sessions.get(sessionId);

        if (!sessionData) {
            return {
                platform: 'steam',
                status: 'error',
                error: 'Session not found or expired',
            };
        }

        // Verificar expiração
        if (Date.now() > sessionData.expiresAt) {
            this.sessions.delete(sessionId);
            return {
                platform: 'steam',
                status: 'error',
                error: 'Session expired',
            };
        }

        const response: {
            platform: string;
            status: 'pending' | 'success' | 'error';
            steamId?: string | undefined;
            userData?: {
                name: string;
                avatar: string;
                profileUrl: string;
            };
            error?: string;
        } = {
            platform: 'steam',
            status: sessionData.status,
        };

        if (sessionData.status === 'success' && sessionData.userData) {
            response.steamId = sessionData.steamId;
            response.userData = {
                name: sessionData.userData.personaname,
                avatar: sessionData.userData.avatarfull,
                profileUrl: sessionData.userData.profileurl,
            };
        }

        if (sessionData.status === 'error') {
            response.error = sessionData.error;
        }

        return response;
    }

    /**
     * Valida a assinatura OpenID do Steam
     */
    private async validateOpenIdSignature(data: any): Promise<boolean> {
        try {
            const validationParams = { ...data };
            validationParams['openid.mode'] = 'check_authentication';

            const response = await axios.post(
                `${this.STEAM_OPENID_URL}/login`,
                new URLSearchParams(validationParams),
                {
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                },
            );

            return response.data.includes('is_valid:true');
        } catch (error) {
            this.logger.error('OpenID validation error', error);
            return false;
        }
    }

    /**
     * Extrai Steam ID da URL de identidade
     */
    private extractSteamId(identity: string): string | null {
        const match = identity.match(/\/id\/(\d+)$/);
        return match ? match[1] : null;
    }

    /**
     * Busca dados do usuário na Steam API
     */
    private async fetchSteamUserData(steamId: string): Promise<SteamUserData> {
        const apiKey = this.configService.get('STEAM_API_KEY');
        if (!apiKey) {
            throw new Error('Steam API key not configured');
        }

        try {
            const response = await axios.get<SteamApiResponse>(
                `${this.STEAM_API_URL}/ISteamUser/GetPlayerSummaries/v0002/`,
                {
                    params: {
                        key: apiKey,
                        steamids: steamId,
                    },
                },
            );

            const players = response.data.response.players;
            if (!players || players.length === 0) {
                throw new Error('Steam user not found');
            }

            return players[0];
        } catch (error) {
            this.logger.error('Steam API error', error);
            throw new Error('Failed to fetch Steam user data');
        }
    }

    /**
     * Gera tokens JWT para o usuário
     */
    private generateTokens(userData: SteamUserData) {
        const payload = {
            sub: userData.steamid,
            username: userData.personaname,
            platform: 'steam',
            avatar: userData.avatarfull,
        };

        const access_token = this.jwtService.sign(payload, { expiresIn: '1h' });
        const refresh_token = this.jwtService.sign(payload, { expiresIn: '7d' });

        return {
            access_token,
            refresh_token,
            expires_in: 3600,
        };
    }

    /**
     * Gera ID único para sessão
     */
    private generateSessionId(): string {
        return crypto.randomBytes(32).toString('hex');
    }

    /**
     * Gera state seguro para validação
     */
    private generateSecureState(): string {
        return crypto.randomBytes(16).toString('hex');
    }

    /**
     * Limpa sessões expiradas (chamado periodicamente)
     */
    cleanExpiredSessions(): void {
        const now = Date.now();
        let cleanedCount = 0;

        for (const [sessionId, sessionData] of this.sessions) {
            if (now > sessionData.expiresAt) {
                this.sessions.delete(sessionId);
                cleanedCount++;
            }
        }

        if (cleanedCount > 0) {
            this.logger.debug(`Cleaned ${cleanedCount} expired sessions`);
        }
    }
}
