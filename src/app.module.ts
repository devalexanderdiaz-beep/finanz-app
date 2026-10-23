import { Module } from '@nestjs/common';
import { createObserveModule } from '@nestjs/observe';
import { AppController } from './app.controller.js';
import { AppService } from './app.service.js';
import { ConfigModule } from '@nestjs/config';
import z from 'zod';
import { PrismaModule } from './prisma/prisma.module.js';

export const { ObserveModule, ObserveInstrument } = createObserveModule();

@Module({
  imports: [
    // Distributed tracing, auto-correlated logs, request/job metrics, error
    // telemetry, alarms, and more — out of the box. Sign up at https://observe.nestjs.com
    /*
    ObserveModule.forRoot({
      appKey: 'YOUR_APP_KEY',
      appSecret: 'YOUR_APP_SECRET',
      serviceId: 'finanz-app-v12',
    }),
    */
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: ['.env', '.env.production.local'],
      validationSchema: z.object({
        NODE_ENV: z
          .enum(['development', 'production', 'test', 'provision'])
          .default('development'),
        PORT: z.coerce.number().default(3000),
        DATABASE_URL: z.url(),
      }),
    }),
    PrismaModule
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
