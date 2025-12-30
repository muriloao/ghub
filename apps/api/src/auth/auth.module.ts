import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { HttpModule } from '@nestjs/axios';
import { SteamAuthController } from './controllers';
import { SteamAuthService } from './services';

@Module({
    imports: [
        ConfigModule.forRoot({
            isGlobal: true,
        }),
        HttpModule,
    ],
    controllers: [SteamAuthController],
    providers: [SteamAuthService],
    exports: [SteamAuthService],
})
export class AuthModule { }