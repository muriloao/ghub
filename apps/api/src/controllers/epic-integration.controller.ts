import { Controller, Get, Query, Param } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiQuery, ApiParam } from '@nestjs/swagger';
import { EpicService } from '../services/epic.service';

@ApiTags('Epic Games Integration')
@Controller('auth/epic')
export class EpicController {
    constructor(private readonly epicService: EpicService) { }

    @Get('start')
    @ApiOperation({
        summary: 'Iniciar processo de conexão com Epic Games',
        description: 'Gera uma sessão temporária e retorna URL para autenticação OAuth2 do Epic Games'
    })
    @ApiResponse({
        status: 200,
        description: 'URL de autenticação gerada com sucesso',
        schema: {
            type: 'object',
            properties: {
                sessionId: { type: 'string', example: 'abc123xyz789' },
                authUrl: {
                    type: 'string',
                    example: 'https://www.epicgames.com/id/authorize?client_id=...'
                },
            },
        },
    })
    @ApiResponse({
        status: 500,
        description: 'Erro de configuração do servidor',
        schema: {
            type: 'object',
            properties: {
                error: { type: 'string', example: 'Epic Games Client ID is not configured' },
            },
        },
    })
    startConnection() {
        return this.epicService.startEpicConnection();
    }

    @Get('callback')
    @ApiOperation({
        summary: 'Processar callback do Epic Games OAuth',
        description: 'Endpoint chamado pelo Epic Games após autorização do usuário'
    })
    @ApiQuery({
        name: 'code',
        required: false,
        description: 'Authorization code retornado pelo Epic Games'
    })
    @ApiQuery({
        name: 'state',
        required: false,
        description: 'State parameter para validação CSRF'
    })
    @ApiQuery({
        name: 'error',
        required: false,
        description: 'Erro retornado pelo Epic Games em caso de falha'
    })
    @ApiResponse({
        status: 200,
        description: 'Callback processado com sucesso',
        schema: {
            type: 'object',
            properties: {
                redirectUrl: {
                    type: 'string',
                    example: 'ghub://epic-auth?status=success'
                },
            },
        },
    })
    async processCallback(
        @Query('code') code?: string,
        @Query('state') state?: string,
        @Query('error') error?: string,
    ) {
        return await this.epicService.processEpicCallback({
            code,
            state,
            error,
        });
    }

    @Get('status/:sessionId')
    @ApiOperation({
        summary: 'Consultar status da conexão Epic Games',
        description: 'Verifica o status atual de uma sessão de conexão Epic Games'
    })
    @ApiParam({
        name: 'sessionId',
        description: 'ID da sessão gerada no endpoint /start'
    })
    @ApiResponse({
        status: 200,
        description: 'Status da sessão consultado com sucesso',
        schema: {
            type: 'object',
            properties: {
                platform: { type: 'string', example: 'epic' },
                status: { type: 'string', enum: ['pending', 'success', 'error'] },
                epicAccountId: { type: 'string', example: 'abc123def456' },
                userData: {
                    type: 'object',
                    properties: {
                        displayName: { type: 'string', example: 'PlayerName' },
                        email: { type: 'string', example: 'player@example.com' },
                        avatar: { type: 'string', nullable: true, example: null },
                        locale: { type: 'string', example: 'en' },
                    },
                },
                error: { type: 'string', example: 'Error message' },
            },
        },
    })
    getConnectionStatus(@Param('sessionId') sessionId: string) {
        return this.epicService.getSessionStatus(sessionId);
    }
}