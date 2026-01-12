import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { SteamModule } from './modules/steam.module';
import { GamingPlatformModule } from './modules/gaming-platform.module';
import { AuthCompleteController } from './controllers/auth-complete.controller';
import { EpicModule } from './modules/epic.module';

@Module({
    imports: [
        ConfigModule.forRoot({
            isGlobal: true,
            envFilePath: '.env',
        }),
        SteamModule,
        EpicModule,
        GamingPlatformModule,
    ],
    controllers: [AppController, AuthCompleteController],
    providers: [AppService],
})
export class AppModule {}
