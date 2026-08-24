-- =============================================================================
-- BlackZ dashboard schema
--
-- Run once, top to bottom, in the Supabase SQL editor.
-- Safe to re-run: every statement is guarded.
--
-- The access rule lives in the database, not in the page. Row Level Security
-- decides what each row-reader may see, so a client cannot reach another
-- client's project even by calling the API directly with their own token.
-- =============================================================================

create extension if not exists "pgcrypto";

-- -----------------------------------------------------------------------------
-- profiles: one row per auth user, carrying the role
-- -----------------------------------------------------------------------------
create table if not exists public.profiles (
  id         uuid primary key references auth.users on delete cascade,
  role       text not null default 'client' check (role in ('admin','client')),
  full_name  text default '',
  created_at timestamptz not null default now()
);

-- Every new signup gets a profile. Default role is client, never admin:
-- admin has to be granted deliberately (see the bottom of this file).
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, full_name)
  values (new.id, coalesce(new.raw_user_meta_data ->> 'full_name', ''))
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- -----------------------------------------------------------------------------
-- projects: one per client engagement
-- -----------------------------------------------------------------------------
create table if not exists public.projects (
  id                  uuid primary key default gen_random_uuid(),
  owner_id            uuid references auth.users on delete set null,
  client_name         text not null default '',
  brand_name          text not null default '',
  start_date          text not null default '',
  target_launch_date  text not null default '',
  last_updated        text not null default '',
  preview_url         text not null default '',
  upload_url          text not null default '',
  deposit_paid        boolean not null default false,
  balance_due         text not null default '',
  wa_number           text not null default '',
  archived            boolean not null default false,
  created_at          timestamptz not null default now()
);

create index if not exists projects_owner_idx on public.projects (owner_id);

-- -----------------------------------------------------------------------------
-- stages: the four-step progress map, ordered by position
-- -----------------------------------------------------------------------------
create table if not exists public.stages (
  id         uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.projects on delete cascade,
  position   int  not null default 0,
  name       text not null default '',
  state      text not null default 'todo' check (state in ('done','active','waiting','todo'))
);

create index if not exists stages_project_idx on public.stages (project_id, position);

-- -----------------------------------------------------------------------------
-- materials: what we are waiting on from the client
-- -----------------------------------------------------------------------------
create table if not exists public.materials (
  id         uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.projects on delete cascade,
  position   int  not null default 0,
  item       text not null default '',
  state      text not null default 'missing' check (state in ('received','missing','skip')),
  since      text not null default ''
);

create index if not exists materials_project_idx on public.materials (project_id, position);

-- =============================================================================
-- ROW LEVEL SECURITY
-- =============================================================================

-- SECURITY DEFINER so this can read profiles without tripping the policy on
-- profiles itself. Without it the profiles policy would call a function that
-- queries profiles, and Postgres would error with infinite recursion.
create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.profiles p
    where p.id = auth.uid() and p.role = 'admin'
  );
$$;

revoke all on function public.is_admin() from public;
grant execute on function public.is_admin() to authenticated;

alter table public.profiles  enable row level security;
alter table public.projects  enable row level security;
alter table public.stages    enable row level security;
alter table public.materials enable row level security;

-- ---- profiles ----
drop policy if exists profiles_select on public.profiles;
create policy profiles_select on public.profiles
  for select to authenticated
  using (id = auth.uid() or public.is_admin());

drop policy if exists profiles_update_own on public.profiles;
create policy profiles_update_own on public.profiles
  for update to authenticated
  using (id = auth.uid())
  with check (id = auth.uid() and role = 'client');   -- nobody self-promotes

drop policy if exists profiles_admin_all on public.profiles;
create policy profiles_admin_all on public.profiles
  for all to authenticated
  using (public.is_admin()) with check (public.is_admin());

-- ---- projects ----
drop policy if exists projects_select on public.projects;
create policy projects_select on public.projects
  for select to authenticated
  using (owner_id = auth.uid() or public.is_admin());

-- clients read only. Everything that changes a project is admin-side.
drop policy if exists projects_admin_write on public.projects;
create policy projects_admin_write on public.projects
  for all to authenticated
  using (public.is_admin()) with check (public.is_admin());

-- ---- stages ----
drop policy if exists stages_select on public.stages;
create policy stages_select on public.stages
  for select to authenticated
  using (
    public.is_admin() or exists (
      select 1 from public.projects p
      where p.id = stages.project_id and p.owner_id = auth.uid()
    )
  );

drop policy if exists stages_admin_write on public.stages;
create policy stages_admin_write on public.stages
  for all to authenticated
  using (public.is_admin()) with check (public.is_admin());

-- ---- materials ----
drop policy if exists materials_select on public.materials;
create policy materials_select on public.materials
  for select to authenticated
  using (
    public.is_admin() or exists (
      select 1 from public.projects p
      where p.id = materials.project_id and p.owner_id = auth.uid()
    )
  );

drop policy if exists materials_admin_write on public.materials;
create policy materials_admin_write on public.materials
  for all to authenticated
  using (public.is_admin()) with check (public.is_admin());

-- =============================================================================
-- SEED HELPERS
-- =============================================================================

-- Creates the four standard stages for a project in one call.
create or replace function public.seed_stages(p_project uuid)
returns void
language sql
security invoker
set search_path = public
as $$
  insert into public.stages (project_id, position, name, state) values
    (p_project, 1, 'שיחה',          'done'),
    (p_project, 2, 'חומרים ואפיון', 'waiting'),
    (p_project, 3, 'בנייה',         'todo'),
    (p_project, 4, 'עולים לאוויר',  'todo');
$$;

-- =============================================================================
-- AFTER RUNNING THIS FILE
--
-- 1. Authentication -> Users -> Add user, using your own email. That is the
--    admin account.
-- 2. Promote it, replacing the address below:
--
--      update public.profiles set role = 'admin'
--      where id = (select id from auth.users where email = 'you@example.com');
--
-- 3. For each client, add a user the same way, then create their project and
--    link it to that user id. Clients never self-register: leave signups
--    disabled under Authentication -> Providers -> Email.
--
-- 4. The dashboard needs only the project URL and the anon key, both from
--    Project Settings -> API. The anon key is safe to ship in the page; it
--    grants nothing on its own because every table is behind RLS. Never put
--    the service_role key in a page - it bypasses RLS entirely.
-- =============================================================================
