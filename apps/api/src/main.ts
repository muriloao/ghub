import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { NestExpressApplication } from '@nestjs/platform-express';
import { AppModule } from './app.module';
import { join } from 'path';

let cachedServer: NestExpressApplication;

async function createServer() {
    if (cachedServer) {
        return cachedServer;
    }

    const app = await NestFactory.create<NestExpressApplication>(AppModule);

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
    cachedServer = app;

    return app;
}

async function bootstrap() {
    const app = await createServer();
    const port = process.env.PORT || 3000;
    await app.listen(port);

    console.log(`🚀 GHub API running on http://localhost:${port}`);
    console.log(`📚 Swagger docs available at http://localhost:${port}/docs`);
}

// Export handler for Vercel
export default async (req: any, res: any) => {
    const app = await createServer();
    return app.getHttpAdapter().getInstance()(req, res);
};

// Only run bootstrap when not in Vercel environment
if (process.env.NODE_ENV !== 'production' || !process.env.VERCEL) {
    bootstrap().catch(console.error);
}
