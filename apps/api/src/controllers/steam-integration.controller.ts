import {
    Controller,
    Get,
    Post,
    Body,
    Query,
    Param,
    Logger,
    HttpCode,
    HttpStatus,
    Res,
    Redirect,
} from '@nestjs/common';
import { Response } from 'express';
import { ApiTags, ApiOperation, ApiResponse, ApiQuery, ApiParam } from '@nestjs/swagger';
import { SteamService } from '../services/steam.service';

@ApiTags('Steam Integration')
@Controller('api/auth/steam')
export class SteamController {
    private readonly logger = new Logger(SteamController.name);

    constructor(private readonly steamService: SteamService) { }

    @Get('start')
    @ApiOperation({ summary: 'Inicia conexão Steam - Redireciona para Steam OpenID' })
    @ApiResponse({
        status: 302,
        description: 'Redirecionamento para Steam OpenID',
    })
    @Redirect()
    async startSteamConnection() {
        this.logger.log('Starting Steam connection');

        const { sessionId, authUrl } = await this.steamService.startSteamConnection();

        this.logger.log(`Redirecting to Steam - Session: ${sessionId}`);

        return { url: authUrl };
    }

    @Get('callback')
    @ApiOperation({ summary: 'Callback Steam OpenID - Processa resposta da Steam' })
    @ApiQuery({ name: 'openid.ns', required: true })
    @ApiQuery({ name: 'openid.mode', required: true })
    @ApiQuery({ name: 'openid.op_endpoint', required: true })
    @ApiQuery({ name: 'openid.claimed_id', required: true })
    @ApiQuery({ name: 'openid.identity', required: true })
    @ApiQuery({ name: 'openid.return_to', required: true })
    @ApiQuery({ name: 'openid.response_nonce', required: true })
    @ApiQuery({ name: 'openid.assoc_handle', required: true })
    @ApiQuery({ name: 'openid.signed', required: true })
    @ApiQuery({ name: 'openid.sig', required: true })
    @ApiResponse({
        status: 302,
        description: 'Redirecionamento para página de conclusão',
    })
    @Redirect()
    async handleSteamCallback(@Query() query: any) {
        this.logger.log('Received Steam callback');

        const { redirectUrl } = await this.steamService.processSteamCallback(query);

        return { url: redirectUrl };
    }

    @Get('status/:sessionId')
    @HttpCode(HttpStatus.OK)
    @ApiOperation({ summary: 'Consulta status da conexão Steam' })
    @ApiParam({
        name: 'sessionId',
        description: 'ID da sessão retornado pelo endpoint /start',
        type: 'string'
    })
    @ApiResponse({
        status: 200,
        description: 'Status da conexão Steam',
        schema: {
            type: 'object',
            properties: {
                platform: { type: 'string', example: 'steam' },
                status: { type: 'string', enum: ['pending', 'success', 'error'] },
                steamId: { type: 'string', example: '76561198000000000' },
                userData: {
                    type: 'object',
                    properties: {
                        name: { type: 'string', example: 'PlayerName' },
                        avatar: { type: 'string', example: 'https://...' },
                        profileUrl: { type: 'string', example: 'https://steamcommunity.com/profiles/...' },
                    },
                },
                error: { type: 'string', example: 'Error message' },
            },
        },
    })
    async getConnectionStatus(@Param('sessionId') sessionId: string) {
        this.logger.log(`Checking status for session: ${sessionId}`);

        return await this.steamService.getSessionStatus(sessionId);
    }
}