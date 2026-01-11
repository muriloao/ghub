import { IsString, IsNotEmpty } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class StartSteamAuthDto {
    @ApiProperty({ description: 'Client ID' })
    @IsString()
    @IsNotEmpty()
    clientId: string;

    @ApiProperty({ description: 'URL de redirecionamento' })
    @IsString()
    @IsNotEmpty()
    redirectUrl: string;
}

export class SteamCallbackDto {
    @IsString()
    @IsNotEmpty()
    'openid.ns': string;

    @IsString()
    @IsNotEmpty()
    'openid.mode': string;

    @IsString()
    @IsNotEmpty()
    'openid.op_endpoint': string;

    @IsString()
    @IsNotEmpty()
    'openid.claimed_id': string;

    @IsString()
    @IsNotEmpty()
    'openid.identity': string;

    @IsString()
    @IsNotEmpty()
    'openid.return_to': string;

    @IsString()
    @IsNotEmpty()
    'openid.response_nonce': string;

    @IsString()
    @IsNotEmpty()
    'openid.assoc_handle': string;

    @IsString()
    @IsNotEmpty()
    'openid.signed': string;

    @IsString()
    @IsNotEmpty()
    'openid.sig': string;
}
