import { Module } from '@nestjs/common';
import { GamingPlatformController } from '../controllers/gaming-platform.controller';
import { GamingPlatformService } from '../services/gaming-platform.service';

@Module({
    controllers: [GamingPlatformController],
    providers: [GamingPlatformService],
    exports: [GamingPlatformService],
})
export class GamingPlatformModule { }