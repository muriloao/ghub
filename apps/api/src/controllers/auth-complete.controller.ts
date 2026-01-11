import { Controller, Get, Query, Res } from '@nestjs/common';
import type { Response } from 'express';
import { ApiTags, ApiOperation } from '@nestjs/swagger';

@ApiTags('Auth Complete')
@Controller('auth')
export class AuthCompleteController {
    @Get('complete')
    @ApiOperation({ summary: 'Página visual de conclusão de autenticação' })
    showCompletePage(
        @Res() res: Response,
        @Query('platform') platform: string,
        @Query('status') status: string,
        @Query('session_id') sessionId?: string,
        @Query('error') error?: string,
    ) {
        const html = this.generateCompletePage(platform, status, sessionId, error);
        res.setHeader('Content-Type', 'text/html');
        res.send(html);
    }

    private generateCompletePage(
        platform: string,
        status: string,
        sessionId?: string,
        error?: string,
    ): string {
        const isSuccess = status === 'success';
        const title = isSuccess
            ? `✅ ${platform.charAt(0).toUpperCase() + platform.slice(1)} Conectada!`
            : `❌ Erro na Conexão ${platform.charAt(0).toUpperCase() + platform.slice(1)}`;

        const message = isSuccess
            ? `Sua conta ${platform.charAt(0).toUpperCase() + platform.slice(1)} foi conectada com sucesso!`
            : `Não foi possível conectar sua conta ${platform.charAt(0).toUpperCase() + platform.slice(1)}.`;

        const errorDetails = error
            ? `<p style="color: #666; margin-top: 10px;"><small>Erro: ${error}</small></p>`
            : '';

        return `
      <!DOCTYPE html>
      <html lang="pt-BR">
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${title}</title>
        <style>
          body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            margin: 0;
            padding: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            color: #333;
          }
          .container {
            background: white;
            padding: 40px;
            border-radius: 16px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            text-align: center;
            max-width: 400px;
            width: 100%;
          }
          .icon {
            font-size: 64px;
            margin-bottom: 20px;
          }
          h1 {
            color: ${isSuccess ? '#4CAF50' : '#f44336'};
            margin-bottom: 16px;
            font-size: 24px;
          }
          p {
            color: #666;
            font-size: 16px;
            line-height: 1.5;
            margin-bottom: 20px;
          }
          .session-info {
            background: #f5f5f5;
            padding: 10px;
            border-radius: 8px;
            font-family: monospace;
            font-size: 12px;
            color: #666;
            margin-top: 20px;
          }
          .close-button {
            background: #667eea;
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 20px;
          }
          .close-button:hover {
            background: #5a6fd8;
          }
        </style>
      </head>
      <body>
        <div class="container">
          <div class="icon">${isSuccess ? '🎮' : '⚠️'}</div>
          <h1>${title}</h1>
          <p>${message}</p>
          ${errorDetails}
          
          ${sessionId ? `<div class="session-info">Sessão: ${sessionId}</div>` : ''}
          
          <button class="close-button" onclick="handleClose()">
            ${isSuccess ? 'Voltar ao App' : 'Tentar Novamente'}
          </button>
          
          <script>
            function handleClose() {
              // Tentar fechar a aba/janela
              if (window.opener) {
                window.close();
              } else {
                // Fallback: voltar ou tentar fechar
                if (history.length > 1) {
                  history.back();
                } else {
                  window.close();
                }
              }
            }
            
            // Auto-close em caso de sucesso após 1 segundo
            ${isSuccess ? 'setTimeout(handleClose, 1000);' : ''}
          </script>
        </div>
      </body>
      </html>
    `;
    }
}
