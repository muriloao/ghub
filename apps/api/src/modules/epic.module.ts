import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { JwtModule } from '@nestjs/jwt';
import { EpicController } from '../controllers/epic-integration.controller';
import { EpicService } from '../services/epic.service';

@Module({
    imports: [
        ConfigModule,
        JwtModule.register({
            secret: process.env.JWT_SECRET || 'your-secret-key',
            signOptions: { expiresIn: '1h' },
        }),
    ],
    controllers: [EpicController],
    providers: [EpicService],
    exports: [EpicService],
})
export class EpicModule {}
