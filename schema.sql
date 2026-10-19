-- Semester Resource Hub schema. Run once in Supabase → SQL Editor.
create table if not exists subjects (
  id uuid primary key default gen_random_uuid(),
  semester int not null check (semester between 1 and 12),
  name text not null check (char_length(name) between 1 and 120),
  created_by uuid default auth.uid() references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  unique (semester, name)
);
create table if not exists resources (
  id uuid primary key default gen_random_uuid(),
  subject_id uuid not null references subjects(id) on delete cascade,
  exam text not null check (exam in ('Mid','Final','Quiz')),
  kind text not null check (kind in ('drive','yt')),
  title text not null check (char_length(title) between 1 and 200),
  url text not null check (url ~* '^https://'),
  approved boolean not null default false,
  created_by uuid default auth.uid() references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  unique (subject_id, exam, url)
);
create table if not exists semester_status (
  semester int primary key check (semester between 1 and 12),
  done boolean not null default false
);
create table if not exists admins (
  user_id uuid primary key references auth.users(id) on delete cascade
);

create or replace function is_admin() returns boolean
language sql security definer set search_path = public stable as
$$ select exists (select 1 from admins where user_id = auth.uid()) $$;

alter table subjects enable row level security;
alter table resources enable row level security;
alter table semester_status enable row level security;
alter table admins enable row level security;

create policy "subjects read" on subjects for select using (true);
create policy "subjects add" on subjects for insert to authenticated with check (created_by = auth.uid());
create policy "subjects delete" on subjects for delete to authenticated using (created_by = auth.uid() or is_admin());

create policy "resources read" on resources for select
  using (approved or created_by = auth.uid() or is_admin());
create policy "resources add" on resources for insert to authenticated
  with check (created_by = auth.uid() and (approved = false or is_admin()));
create policy "resources approve" on resources for update to authenticated
  using (is_admin()) with check (is_admin());
create policy "resources delete" on resources for delete to authenticated
  using (created_by = auth.uid() or is_admin());

create policy "status read" on semester_status for select using (true);
create policy "status admin write" on semester_status for all to authenticated
  using (is_admin()) with check (is_admin());

create policy "admins read self" on admins for select to authenticated using (user_id = auth.uid());

-- After you sign in once on the site, make yourself admin (replace the email):
-- insert into admins (user_id) select id from auth.users where email = 'you@example.com';
