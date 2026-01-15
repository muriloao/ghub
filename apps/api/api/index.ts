import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { AppModule } from '../src/app.module';
import { NestExpressApplication } from '@nestjs/platform-express';
import { join } from 'path';

let app: NestExpressApplication;

async function createApp() {
    if (!app) {
        app = await NestFactory.create<NestExpressApplication>(AppModule);

        // Servir arquivos estáticos
        app.useStaticAssets(join(__dirname, '..', 'public'));

        // Global validation pipe
        app.useGlobalPipes(
            new ValidationPipe({
                whitelist: true,
                forbidNonWhitelisted: true,
                transform: true,
            }),
        );

        // Enable CORS
        app.enableCors({
            origin: process.env.CORS_ORIGIN || '*',
            credentials: true,
        });

        // Swagger documentation
        const config = new DocumentBuilder()
            .setTitle('GHub API')
            .setDescription('API for GHub platform integrations')
            .setVersion('1.0')
            .addBearerAuth()
            .build();

        const document = SwaggerModule.createDocument(app, config);
        SwaggerModule.setup('docs', app, document);

        await app.init();
    }
    return app;
}

export default async (req: any, res: any) => {
    const app = await createApp();
    return app.getHttpAdapter().getInstance()(req, res);
};