import { ApiProperty } from '@nestjs/swagger';

export class EpicConnectionStartDto {
    @ApiProperty({
        description: 'ID único da sessão de conexão',
        example: 'abc123xyz789',
    })
    sessionId: string;

    @ApiProperty({
        description: 'URL para autenticação OAuth2 do Epic Games',
        example: 'https://www.epicgames.com/id/authorize?client_id=xyz&redirect_uri=...',
    })
    authUrl: string;
}

export class EpicCallbackDto {
    @ApiProperty({
        description: 'Authorization code retornado pelo Epic Games',
        required: false,
    })
    code?: string;

    @ApiProperty({
        description: 'State parameter para validação CSRF',
        required: false,
    })
    state?: string;

    @ApiProperty({
        description: 'Erro retornado pelo Epic Games',
        required: false,
    })
    error?: string;
}

export class EpicUserDataDto {
    @ApiProperty({
        description: 'Nome de exibição do usuário Epic Games',
        example: 'PlayerName',
    })
    displayName: string;

    @ApiProperty({
        description: 'Email do usuário Epic Games',
        example: 'player@example.com',
    })
    email: string;

    @ApiProperty({
        description: 'Avatar do usuário (Epic não fornece na API básica)',
        required: false,
        nullable: true,
    })
    avatar?: string;

    @ApiProperty({
        description: 'Idioma preferido do usuário',
        example: 'en',
    })
    locale: string;
}

export class EpicConnectionStatusDto {
    @ApiProperty({
        description: 'Nome da plataforma',
        example: 'epic',
    })
    platform: string;

    @ApiProperty({
        description: 'Status atual da conexão',
        enum: ['pending', 'success', 'error'],
    })
    status: 'pending' | 'success' | 'error';

    @ApiProperty({
        description: 'Epic Account ID do usuário',
        required: false,
    })
    epicAccountId?: string;

    @ApiProperty({
        description: 'Dados do usuário Epic Games',
        type: EpicUserDataDto,
        required: false,
    })
    userData?: EpicUserDataDto;

    @ApiProperty({
        description: 'Mensagem de erro em caso de falha',
        required: false,
    })
    error?: string;
}
