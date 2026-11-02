-- CreateTable
CREATE TABLE "Driver" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "phone" TEXT,
    "email" TEXT,
    "iban" TEXT,
    "carOwnership" TEXT,
    "status" TEXT NOT NULL DEFAULT 'ACTIVE',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "portalPasswordHash" TEXT,

    CONSTRAINT "Driver_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CarOwner" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "nif" TEXT,
    "phone" TEXT,

    CONSTRAINT "CarOwner_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Car" (
    "id" TEXT NOT NULL,
    "plate" TEXT NOT NULL,
    "make" TEXT NOT NULL,
    "model" TEXT NOT NULL,
    "fuelType" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'ACTIVE',
    "weeklyRentalCost" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "managerFee" DOUBLE PRECISION NOT NULL DEFAULT 5,
    "ownerId" TEXT,
    "currentDriverId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Car_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AssignmentHistory" (
    "id" TEXT NOT NULL,
    "driverId" TEXT NOT NULL,
    "carId" TEXT NOT NULL,
    "startDate" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "endDate" TIMESTAMP(3),

    CONSTRAINT "AssignmentHistory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WeeklySettlement" (
    "id" TEXT NOT NULL,
    "driverId" TEXT NOT NULL,
    "carId" TEXT,
    "weekStart" TIMESTAMP(3) NOT NULL,
    "weekEnd" TIMESTAMP(3) NOT NULL,
    "uberGross" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "boltGross" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "fleetCharge" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "ivaWithheld" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "fuelElectricCost" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "viaVerde" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "otherDeductions" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "netPaid" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "status" TEXT NOT NULL DEFAULT 'PENDING',
    "paidAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "WeeklySettlement_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "IvaRefund" (
    "id" TEXT NOT NULL,
    "driverId" TEXT NOT NULL,
    "period" TEXT NOT NULL,
    "periodStart" TIMESTAMP(3),
    "periodEnd" TIMESTAMP(3),
    "amount" DOUBLE PRECISION NOT NULL,
    "receiptRef" TEXT,
    "status" TEXT NOT NULL DEFAULT 'WITHHELD',
    "refundedAt" TIMESTAMP(3),

    CONSTRAINT "IvaRefund_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Insurance" (
    "id" TEXT NOT NULL,
    "carId" TEXT NOT NULL,
    "insurer" TEXT NOT NULL,
    "policyNumber" TEXT,
    "cost" DOUBLE PRECISION NOT NULL,
    "billingPeriod" TEXT NOT NULL,
    "paidBy" TEXT NOT NULL DEFAULT 'COMPANY',
    "startDate" TIMESTAMP(3),
    "expiryDate" TIMESTAMP(3) NOT NULL,
    "cartaVerdeEndDate" TIMESTAMP(3),

    CONSTRAINT "Insurance_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MaintenanceLog" (
    "id" TEXT NOT NULL,
    "carId" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "description" TEXT NOT NULL,
    "cost" DOUBLE PRECISION NOT NULL,
    "garage" TEXT,
    "nextServiceDue" TIMESTAMP(3),

    CONSTRAINT "MaintenanceLog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AccidentHistory" (
    "id" TEXT NOT NULL,
    "carId" TEXT NOT NULL,
    "driverId" TEXT,
    "date" TIMESTAMP(3) NOT NULL,
    "place" TEXT,
    "driverNumber" TEXT,
    "opponentDriverNumber" TEXT,
    "opponentCarPlate" TEXT,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AccidentHistory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Expense" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "amount" DOUBLE PRECISION NOT NULL,
    "date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Expense_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CustomPayment" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "amount" DOUBLE PRECISION NOT NULL,
    "date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "CustomPayment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FleetIncomeOverride" (
    "id" TEXT NOT NULL,
    "weekStart" TIMESTAMP(3) NOT NULL,
    "weekEnd" TIMESTAMP(3) NOT NULL,
    "fleetChargeTotal" DOUBLE PRECISION NOT NULL,
    "managerFeeTotal" DOUBLE PRECISION NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "FleetIncomeOverride_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Car_plate_key" ON "Car"("plate");

-- CreateIndex
CREATE UNIQUE INDEX "Car_currentDriverId_key" ON "Car"("currentDriverId");

-- CreateIndex
CREATE UNIQUE INDEX "FleetIncomeOverride_weekStart_weekEnd_key" ON "FleetIncomeOverride"("weekStart", "weekEnd");

-- AddForeignKey
ALTER TABLE "Car" ADD CONSTRAINT "Car_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES "CarOwner"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Car" ADD CONSTRAINT "Car_currentDriverId_fkey" FOREIGN KEY ("currentDriverId") REFERENCES "Driver"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AssignmentHistory" ADD CONSTRAINT "AssignmentHistory_driverId_fkey" FOREIGN KEY ("driverId") REFERENCES "Driver"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AssignmentHistory" ADD CONSTRAINT "AssignmentHistory_carId_fkey" FOREIGN KEY ("carId") REFERENCES "Car"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WeeklySettlement" ADD CONSTRAINT "WeeklySettlement_driverId_fkey" FOREIGN KEY ("driverId") REFERENCES "Driver"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WeeklySettlement" ADD CONSTRAINT "WeeklySettlement_carId_fkey" FOREIGN KEY ("carId") REFERENCES "Car"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "IvaRefund" ADD CONSTRAINT "IvaRefund_driverId_fkey" FOREIGN KEY ("driverId") REFERENCES "Driver"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Insurance" ADD CONSTRAINT "Insurance_carId_fkey" FOREIGN KEY ("carId") REFERENCES "Car"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaintenanceLog" ADD CONSTRAINT "MaintenanceLog_carId_fkey" FOREIGN KEY ("carId") REFERENCES "Car"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AccidentHistory" ADD CONSTRAINT "AccidentHistory_carId_fkey" FOREIGN KEY ("carId") REFERENCES "Car"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AccidentHistory" ADD CONSTRAINT "AccidentHistory_driverId_fkey" FOREIGN KEY ("driverId") REFERENCES "Driver"("id") ON DELETE SET NULL ON UPDATE CASCADE;
