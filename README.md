# Rohan / Mandala Art

A responsive React + Vite storefront and Express admin API for a small mandala art studio.

## Features
- Editorial-style responsive gallery with animated hero, marquee, reveal-on-scroll cards and hover details.
- Category filtering, artwork detail pages, local favorites and cart.
- Order request form (no payment gateway; requests are sent to the admin inbox).
- Private `/admin` login, artwork CRUD with image uploads, category management, homepage copy editor, enquiry inbox and password change.
- Images uploaded in the admin area are stored in `server/uploads/` and served as static assets with browser caching.
- JSON persistence in `server/data/store.json` (simple starter storage).
- Optional email notifications via SMTP. Without SMTP, new enquiry/order notifications are printed in the server terminal.

## Requirements
- Node.js 20+ recommended
- npm

## Run locally
1. Extract the ZIP.
2. In the project folder, install dependencies:
   ```bash
   npm install
   ```
3. Copy `server/.env.example` to `server/.env`.
4. Change `JWT_SECRET` and `ADMIN_INITIAL_PASSWORD` before exposing the app publicly.
5. Start the frontend and backend:
   ```bash
   npm run dev
   ```
6. Open `http://localhost:5173`. Admin is at `http://localhost:5173/admin`.

### Initial admin login
- Username: `marnerohan10@gmail.com`
- Password: `Rohan@6728`

**Change the initial password immediately** in Admin → Settings. The password is stored as a bcrypt hash.

## Email notifications (optional, no paid API key required)
Configure an SMTP mailbox in `server/.env`:
```env
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-16-character-app-password
NOTIFY_EMAIL=your-email@gmail.com
MAIL_FROM=Rohan Mandala Art <your-email@gmail.com>
```
For Gmail, use a Google App Password (requires 2-Step Verification); never commit `.env`.

## Production build
```bash
npm run build
npm start
```
The client build is generated in `client/dist`. For a production deployment, serve the client build from a static host and deploy the Express API on a Node host; configure the frontend API base/proxy accordingly. Put persistent storage on a disk volume. The starter JSON store is suitable for a small prototype, not concurrent/high-volume production. For a production launch, migrate records to PostgreSQL/Supabase and images to Supabase Storage or Cloudinary.

## Free services / API keys
The core site does not require a paid API key. Email notifications work with SMTP credentials; artwork image uploads are local. Remote sample artwork images are demo placeholders and should be replaced with your own artwork in Admin.
