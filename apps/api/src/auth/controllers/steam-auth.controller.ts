import {
    Controller,
    Post,
    Get,
    Param,
    Query,
    Res,
    HttpCode,
    HttpStatus,
    Logger
} from '@nestjs/common';
import type { Response } from 'express';
import { SteamAuthService } from '../services';
import { SteamUrlResponseDto, SteamCallbackResponseDto } from '../dto';

@Controller('auth/steam')
export class SteamAuthController {
    private readonly logger = new Logger(SteamAuthController.name);

    constructor(private readonly steamAuthService: SteamAuthService) { }

    @Post('url')
    @HttpCode(HttpStatus.OK)
    async getSteamLoginUrl(): Promise<SteamUrlResponseDto> {
        this.logger.log('Steam login URL requested');
        return await this.steamAuthService.createSteamLoginUrl();
    }

    @Get('callback/:sessionId')
    @HttpCode(HttpStatus.OK)
    async checkSteamAuthStatus(
        @Param('sessionId') sessionId: string
    ): Promise<SteamCallbackResponseDto> {
        this.logger.log(`Steam auth status check for session: ${sessionId}`);
        return await this.steamAuthService.checkAuthenticationStatus(sessionId);
    }

    @Get('return/:sessionId')
    async handleSteamReturn(
        @Param('sessionId') sessionId: string,
        @Query() query: any,
        @Res() res: Response
    ): Promise<void> {
        this.logger.log(`Steam return callback for session: ${sessionId}`);

        try {
            await this.steamAuthService.handleSteamReturn(sessionId, query);

            // Redirecionar para uma página de sucesso ou fechar a janela
            res.send(`
        <html>
          <head>
            <title>Steam Login - Sucesso</title>
            <style>
              body {
                font-family: Arial, sans-serif;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
                background-color: #1e2328;
                color: white;
              }
              .container {
                text-align: center;
                padding: 2rem;
                border-radius: 8px;
                background-color: #2a2d31;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
              }
              .success-icon {
                font-size: 4rem;
                color: #4caf50;
                margin-bottom: 1rem;
              }
              h1 {
                color: #4caf50;
                margin-bottom: 1rem;
              }
              p {
                margin-bottom: 1.5rem;
                opacity: 0.8;
              }
            </style>
          </head>
          <body>
            <div class="container">
              <div class="success-icon">✅</div>
              <h1>Login Steam Realizado com Sucesso!</h1>
              <p>Você pode fechar esta janela e voltar para o aplicativo.</p>
            </div>
            <script>
              // Tentar fechar a janela automaticamente após 3 segundos
              setTimeout(() => {
                try {
                  window.close();
                } catch (e) {
                  console.log('Não foi possível fechar a janela automaticamente');
                }
              }, 3000);
            </script>
          </body>
        </html>
      `);
        } catch (error) {
            this.logger.error(`Steam return error for session ${sessionId}:`, error);

            res.status(400).send(`
        <html>
          <head>
            <title>Steam Login - Erro</title>
            <style>
              body {
                font-family: Arial, sans-serif;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
                background-color: #1e2328;
                color: white;
              }
              .container {
                text-align: center;
                padding: 2rem;
                border-radius: 8px;
                background-color: #2a2d31;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
              }
              .error-icon {
                font-size: 4rem;
                color: #f44336;
                margin-bottom: 1rem;
              }
              h1 {
                color: #f44336;
                margin-bottom: 1rem;
              }
              p {
                margin-bottom: 1.5rem;
                opacity: 0.8;
              }
            </style>
          </head>
          <body>
            <div class="container">
              <div class="error-icon">❌</div>
              <h1>Erro no Login Steam</h1>
              <p>Ocorreu um erro durante a autenticação. Tente novamente.</p>
              <p><strong>Erro:</strong> ${error.message}</p>
            </div>
            <script>
              setTimeout(() => {
                try {
                  window.close();
                } catch (e) {
                  console.log('Não foi possível fechar a janela automaticamente');
                }
              }, 5000);
            </script>
          </body>
        </html>
      `);
        }
    }
}