import { IsString, IsNotEmpty, IsOptional, IsUrl } from 'class-validator';

export class StartSteamAuthDto {
    @IsString()
    @IsNotEmpty()
    clientId: string;

    @IsString()
    @IsUrl()
    @IsOptional()
    redirectUrl?: string;
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