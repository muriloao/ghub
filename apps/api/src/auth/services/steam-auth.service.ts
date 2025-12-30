import { Injectable, Logger, BadRequestException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { HttpService } from '@nestjs/axios';
import { firstValueFrom } from 'rxjs';
import { v4 as uuidv4 } from 'uuid';
import { SteamSession, SteamUserInfo } from '../interfaces';
import { SteamUrlResponseDto, SteamCallbackResponseDto, AuthResultDto } from '../dto';

@Injectable()
export class SteamAuthService {
    private readonly logger = new Logger(SteamAuthService.name);
    private readonly sessions = new Map<string, SteamSession>();
    private readonly STEAM_OPENID_URL = 'https://steamcommunity.com/openid/login';
    private readonly STEAM_API_URL = 'https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v2/';

    constructor(
        private readonly configService: ConfigService,
        private readonly httpService: HttpService,
    ) { }

    async createSteamLoginUrl(): Promise<SteamUrlResponseDto> {
        const sessionId = uuidv4();
        const returnUrl = `${this.configService.get('APP_URL', 'http://localhost:3000')}/auth/steam/return/${sessionId}`;

        // Parâmetros para Steam OpenID
        const params = new URLSearchParams({
            'openid.ns': 'http://specs.openid.net/auth/2.0',
            'openid.mode': 'checkid_setup',
            'openid.return_to': returnUrl,
            'openid.realm': this.configService.get('APP_URL', 'http://localhost:3000'),
            'openid.identity': 'http://specs.openid.net/auth/2.0/identifier_select',
            'openid.claimed_id': 'http://specs.openid.net/auth/2.0/identifier_select',
        });

        const steamLoginUrl = `${this.STEAM_OPENID_URL}?${params.toString()}`;

        // Armazenar sessão temporária
        const session: SteamSession = {
            sessionId,
            returnUrl,
            createdAt: new Date(),
            authenticated: false,
        };

        this.sessions.set(sessionId, session);

        // Limpar sessões antigas (mais de 10 minutos)
        this.cleanExpiredSessions();

        this.logger.log(`Created Steam login session: ${sessionId}`);

        return {
            url: steamLoginUrl,
            sessionId,
        };
    }

    async handleSteamReturn(sessionId: string, query: any): Promise<void> {
        const session = this.sessions.get(sessionId);
        if (!session) {
            this.logger.error(`Steam session not found: ${sessionId}`);
            throw new BadRequestException('Sessão inválida ou expirada');
        }

        try {
            // Verificar resposta do Steam OpenID
            const isValid = await this.verifySteamOpenIdResponse(query);
            if (!isValid) {
                this.logger.error(`Invalid Steam OpenID response for session: ${sessionId}`);
                throw new BadRequestException('Resposta Steam inválida');
            }

            // Extrair Steam ID da resposta
            const steamId = this.extractSteamId(query['openid.claimed_id'] || query['openid.identity']);
            if (!steamId) {
                this.logger.error(`Could not extract Steam ID for session: ${sessionId}`);
                throw new BadRequestException('Não foi possível obter Steam ID');
            }

            // Buscar informações do usuário no Steam API
            const userInfo = await this.fetchSteamUserInfo(steamId);

            // Atualizar sessão
            session.authenticated = true;
            session.steamId = steamId;
            session.userInfo = userInfo;

            this.sessions.set(sessionId, session);

            this.logger.log(`Steam authentication successful for session: ${sessionId}, Steam ID: ${steamId}`);
        } catch (error) {
            this.logger.error(`Steam authentication failed for session: ${sessionId}`, error);
            throw error;
        }
    }

    async checkAuthenticationStatus(sessionId: string): Promise<SteamCallbackResponseDto> {
        const session = this.sessions.get(sessionId);

        if (!session) {
            return {
                authenticated: false,
                message: 'Sessão não encontrada ou expirada',
            };
        }

        if (!session.authenticated) {
            return {
                authenticated: false,
                message: 'Aguardando autenticação Steam',
            };
        }

        try {
            // Criar ou buscar usuário no sistema
            const authResult = await this.createOrUpdateUser(session);

            // Limpar sessão após sucesso
            this.sessions.delete(sessionId);

            return {
                authenticated: true,
                ...authResult,
            };
        } catch (error) {
            this.logger.error(`Failed to create/update user for session: ${sessionId}`, error);
            return {
                authenticated: false,
                message: 'Erro interno do servidor',
            };
        }
    }

    private async verifySteamOpenIdResponse(query: any): Promise<boolean> {
        try {
            // Preparar parâmetros para verificação
            const params = new URLSearchParams();
            Object.keys(query).forEach(key => {
                if (key !== 'openid.mode') {
                    params.append(key, query[key]);
                }
            });
            params.append('openid.mode', 'check_authentication');

            // Fazer requisição para Steam para verificar
            const response = await firstValueFrom(
                this.httpService.post(this.STEAM_OPENID_URL, params.toString(), {
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                })
            );

            return response.data.includes('is_valid:true');
        } catch (error) {
            this.logger.error('Error verifying Steam OpenID response:', error);
            return false;
        }
    }

    private extractSteamId(claimedId: string): string | null {
        const match = claimedId.match(/\/id\/(\d+)$/);
        return match ? match[1] : null;
    }

    private async fetchSteamUserInfo(steamId: string): Promise<SteamUserInfo> {
        const apiKey = this.configService.get('STEAM_API_KEY');
        if (!apiKey) {
            throw new Error('Steam API key não configurada');
        }

        try {
            const response = await firstValueFrom(
                this.httpService.get(this.STEAM_API_URL, {
                    params: {
                        key: apiKey,
                        steamids: steamId,
                    },
                })
            );

            const players = response.data.response?.players;
            if (!players || players.length === 0) {
                throw new Error('Usuário Steam não encontrado');
            }

            return players[0];
        } catch (error) {
            this.logger.error(`Error fetching Steam user info for ${steamId}:`, error);
            throw new Error('Erro ao buscar informações do usuário Steam');
        }
    }

    private async createOrUpdateUser(session: SteamSession): Promise<AuthResultDto> {
        const { steamId, userInfo } = session;

        if (!steamId || !userInfo) {
            throw new Error('Steam ID ou informações do usuário não disponíveis');
        }

        // TODO: Implementar integração com banco de dados
        // Por enquanto, retornando dados mockados
        const userId = `steam_${steamId}`;
        const now = new Date().toISOString();

        // TODO: Gerar tokens JWT reais
        const accessToken = `access_token_${userId}_${Date.now()}`;
        const refreshToken = `refresh_token_${userId}_${Date.now()}`;

        return {
            accessToken,
            refreshToken,
            user: {
                id: userId,
                email: `${steamId}@steam.local`, // Steam não fornece email
                name: userInfo.personaname,
                avatarUrl: userInfo.avatarfull,
                createdAt: now,
                updatedAt: now,
            },
        };
    }

    private cleanExpiredSessions(): void {
        const tenMinutesAgo = new Date(Date.now() - 10 * 60 * 1000);

        for (const [sessionId, session] of this.sessions.entries()) {
            if (session.createdAt < tenMinutesAgo) {
                this.sessions.delete(sessionId);
                this.logger.log(`Cleaned expired session: ${sessionId}`);
            }
        }
    }
}