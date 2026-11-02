# Setup Guide — Wisdom Auto Solutions

Node.js + Express + Prisma + PostgreSQL. Follow these steps to run it with a brand-new database.

## 1. Requirements
- Node.js 18+ (`node -v`)
- PostgreSQL (local, or hosted: Neon, Supabase, Railway...)

## 2. Create a NEW empty database
Local Postgres:
```
psql -U postgres -c "CREATE DATABASE wisdom_auto;"
```
Hosted: create a new project/database and copy its connection string.

## 3. Install and configure
```
npm install
cp .env.example .env
```
Edit `.env`: set `DATABASE_URL` to the new database, a new `SESSION_SECRET`, and a new admin password hash (commands are in `.env.example`).

## 4. Create the tables
```
npx prisma migrate dev --name init
```
This creates the `prisma/migrations` folder and all tables in the new database. Commit that folder.
On a production server later use: `npx prisma migrate deploy`.

## 5. Start
```
npm start
```
Open http://localhost:3002 and log in. Do NOT run `npm run seed` for real use (it adds fake sample drivers).

## Company data
Edit `src/config/company.js` — brand name and the Daring Wisdom Unipessoal Lda details used in all contracts.
