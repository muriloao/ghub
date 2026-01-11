import {
    Controller,
    Get,
    Post,
    Body,
    Query,
    Logger,
    HttpCode,
    HttpStatus,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiQuery } from '@nestjs/swagger';
import { SteamService } from '../services/steam.service';
import { StartSteamAuthDto } from '../dto/steam.dto';

@ApiTags('Steam Authentication')
@Controller('auth/steam')
export class SteamController {
    private readonly logger = new Logger(SteamController.name);

    constructor(private readonly steamService: SteamService) { }

    @Post('start')
    @HttpCode(HttpStatus.OK)
    @ApiOperation({ summary: 'Inicia processo de autenticação Steam' })
    @ApiResponse({
        status: 200,
        description: 'URL de autenticação gerada com sucesso',
        schema: {
            type: 'object',
            properties: {
                authUrl: { type: 'string' },
                nonce: { type: 'string' },
            },
        },
    })
    async startAuthentication(@Body() startAuthDto: StartSteamAuthDto) {
        this.logger.log(`Starting Steam auth for client: ${startAuthDto.clientId}`);

        return await this.steamService.startAuthentication(
            startAuthDto.clientId,
            startAuthDto.redirectUrl,
        );
    }

    @Get('callback')
    @ApiOperation({ summary: 'Processa callback do Steam OpenID' })
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
        status: 200,
        description: 'Callback processado com sucesso',
        schema: {
            type: 'object',
            properties: {
                success: { type: 'boolean' },
                user: {
                    type: 'object',
                    properties: {
                        id: { type: 'string' },
                        steamId: { type: 'string' },
                        name: { type: 'string' },
                        avatar: { type: 'string' },
                        email: { type: 'string' },
                    },
                },
                tokens: {
                    type: 'object',
                    properties: {
                        access_token: { type: 'string' },
                        refresh_token: { type: 'string' },
                        expires_in: { type: 'number' },
                    },
                },
                error: { type: 'string' },
            },
        },
    })
    async handleCallback(@Query() query: any) {
        this.logger.log('Received Steam callback');

        return await this.steamService.processCallback(query);
    }

    @Get('validate')
    @ApiOperation({ summary: 'Valida token JWT' })
    @ApiQuery({ name: 'token', required: true })
    @ApiResponse({
        status: 200,
        description: 'Token validado',
        schema: {
            type: 'object',
            properties: {
                valid: { type: 'boolean' },
                payload: { type: 'object' },
            },
        },
    })
    async validateToken(@Query('token') token: string) {
        // TODO: Implementar validação de token JWT
        return { valid: false, message: 'Not implemented yet' };
    }
}