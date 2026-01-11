import { Injectable, Logger, OnModuleInit } from '@nestjs/common';
import { SteamService } from '../services/steam.service';

@Injectable()
export class SessionCleanupService implements OnModuleInit {
    private readonly logger = new Logger(SessionCleanupService.name);

    constructor(private readonly steamService: SteamService) {}

    onModuleInit() {
        // Limpar sessões expiradas a cada 5 minutos
        setInterval(
            () => {
                this.steamService.cleanExpiredSessions();
                this.logger.debug('Expired sessions cleaned');
            },
            5 * 60 * 1000,
        );

        this.logger.log('Session cleanup service initialized');
    }
}
