# Semester Resource Hub

Static web app (no build step) + Supabase (database + email login) + Vercel (hosting).

## 1. Supabase
1. Create a project at supabase.com.
2. SQL Editor → paste `schema.sql` → Run.
3. Authentication → URL Configuration → set **Site URL** to your Vercel URL (add `http://localhost:3000` too if testing locally).
4. Project Settings → API → copy the Project URL and the publishable (anon) key into `config.js`.

## 2. Deploy on Vercel
- Push this folder to GitHub, then Vercel → Add New Project → import the repo (Framework: Other, no build command).
- Or from this folder: `npx vercel --prod`.

## 3. Make yourself admin
Open the site, sign in with your email (magic link), then run in the SQL Editor:
`insert into admins (user_id) select id from auth.users where email = 'you@example.com';`

## How it behaves
- Anyone can browse approved resources. Signed-in users can add subjects and resources.
- New resources from normal users are hidden from others until an admin approves them. Admin uploads are approved instantly.
- Only admins mark a semester finished (plays the sunburst animation).
