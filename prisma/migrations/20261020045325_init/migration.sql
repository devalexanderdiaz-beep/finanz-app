-- CreateEnum
CREATE TYPE "Language" AS ENUM ('es', 'en');

-- CreateEnum
CREATE TYPE "Frequency" AS ENUM ('DIARIO', 'SEMANAL', 'QUINCENAL', 'MENSUAL', 'ANUAL');

-- CreateEnum
CREATE TYPE "weekDay" AS ENUM ('LUNES', 'MARTES', 'MIERCOLES', 'JUEVES', 'VIERNES', 'SABADO', 'DOMINGO');

-- CreateEnum
CREATE TYPE "monthDay" AS ENUM ('ENERO', 'FEBRERO', 'MARZO', 'ABRIL', 'MAYO', 'JUNIO', 'JULIO', 'AGOSTO', 'SEPTIEMBRE', 'OCTUBRE', 'NOVIEMBRE', 'DICIEMBRE');

-- CreateEnum
CREATE TYPE "TransactionType" AS ENUM ('Ingreso', 'Gasto');

-- CreateTable
CREATE TABLE "role" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(50) NOT NULL,
    "description" VARCHAR(255) NOT NULL,

    CONSTRAINT "role_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user" (
    "id" UUID NOT NULL,
    "name" VARCHAR(50) NOT NULL,
    "first_surname" VARCHAR(50) NOT NULL,
    "second_surname" VARCHAR(50) NOT NULL,
    "email" VARCHAR(150) NOT NULL,
    "username" VARCHAR(10) NOT NULL,
    "password" VARCHAR(255) NOT NULL,
    "language" "Language" NOT NULL DEFAULT 'es',
    "dark_mode" BOOLEAN NOT NULL DEFAULT true,
    "notify_debt" BOOLEAN NOT NULL DEFAULT true,
    "notify_recurring_transaction" BOOLEAN NOT NULL DEFAULT true,
    "avatar" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),
    "id_role" INTEGER NOT NULL,

    CONSTRAINT "user_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "category" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(50) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "icon" VARCHAR(50) NOT NULL,
    "color" VARCHAR(50) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),
    "id_user" UUID NOT NULL,

    CONSTRAINT "category_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payment_reminder" (
    "id" SERIAL NOT NULL,
    "description" VARCHAR(255) NOT NULL,
    "amount" DECIMAL(16,2) NOT NULL,
    "maturity" TIMESTAMP(3) NOT NULL,
    "is_paid" BOOLEAN NOT NULL DEFAULT false,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "notified" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),
    "id_user" UUID NOT NULL,

    CONSTRAINT "payment_reminder_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "transaction" (
    "id" SERIAL NOT NULL,
    "description" VARCHAR(255) NOT NULL,
    "amount" DECIMAL(16,2) NOT NULL,
    "type" "TransactionType" NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),
    "id_user" UUID NOT NULL,
    "id_category" INTEGER NOT NULL,

    CONSTRAINT "transaction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "recurring_transaction" (
    "id" SERIAL NOT NULL,
    "description" VARCHAR(255) NOT NULL,
    "amount" DECIMAL(16,2) NOT NULL,
    "type" "TransactionType" NOT NULL,
    "frequency" "Frequency" NOT NULL,
    "week_day" "weekDay",
    "execution_day" SMALLINT,
    "month_day" "monthDay",
    "last_execution" TIMESTAMP(3),
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),
    "id_user" UUID NOT NULL,
    "id_category" INTEGER NOT NULL,

    CONSTRAINT "recurring_transaction_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "role_name_key" ON "role"("name");

-- CreateIndex
CREATE UNIQUE INDEX "user_email_key" ON "user"("email");

-- CreateIndex
CREATE UNIQUE INDEX "user_username_key" ON "user"("username");

-- AddForeignKey
ALTER TABLE "user" ADD CONSTRAINT "user_id_role_fkey" FOREIGN KEY ("id_role") REFERENCES "role"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "category" ADD CONSTRAINT "category_id_user_fkey" FOREIGN KEY ("id_user") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_reminder" ADD CONSTRAINT "payment_reminder_id_user_fkey" FOREIGN KEY ("id_user") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "transaction" ADD CONSTRAINT "transaction_id_user_fkey" FOREIGN KEY ("id_user") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "transaction" ADD CONSTRAINT "transaction_id_category_fkey" FOREIGN KEY ("id_category") REFERENCES "category"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "recurring_transaction" ADD CONSTRAINT "recurring_transaction_id_user_fkey" FOREIGN KEY ("id_user") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "recurring_transaction" ADD CONSTRAINT "recurring_transaction_id_category_fkey" FOREIGN KEY ("id_category") REFERENCES "category"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
