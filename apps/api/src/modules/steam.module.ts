import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { JwtModule } from '@nestjs/jwt';
import { SteamController } from '../controllers/steam-integration.controller';
import { SteamService } from '../services/steam.service';
import { SessionCleanupService } from '../services/session-cleanup.service';

@Module({
    imports: [
        ConfigModule,
        JwtModule.register({
            secret: process.env.JWT_SECRET || 'your-secret-key',
            signOptions: { expiresIn: '1h' },
        }),
    ],
    controllers: [SteamController],
    providers: [SteamService, SessionCleanupService],
    exports: [SteamService],
})
export class SteamModule { }