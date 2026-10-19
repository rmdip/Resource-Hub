-- Run once in Supabase -> SQL Editor. Makes the hub work without login.
-- Visitors can read everything and add subjects/resources. No update/delete from the site.
drop policy if exists "subjects add" on public.subjects;
drop policy if exists "subjects delete" on public.subjects;
drop policy if exists "subjects read" on public.subjects;
drop policy if exists "resources add" on public.resources;
drop policy if exists "resources approve" on public.resources;
drop policy if exists "resources delete" on public.resources;
drop policy if exists "resources read" on public.resources;
drop policy if exists "status admin write" on public.semester_status;
drop policy if exists "status read" on public.semester_status;

create policy "subjects read" on public.subjects for select to anon, authenticated using (true);
create policy "subjects add" on public.subjects for insert to anon, authenticated with check (true);
create policy "resources read" on public.resources for select to anon, authenticated using (true);
create policy "resources add" on public.resources for insert to anon, authenticated with check (approved = true);
create policy "status read" on public.semester_status for select to anon, authenticated using (true);
