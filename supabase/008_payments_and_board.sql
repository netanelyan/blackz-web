-- =============================================================================
-- PAYMENTS and the PROJECT BOARD
--
-- Run once in the SQL editor. Safe to re-run: every statement is guarded and
-- the backfill only fires for projects that have no payment rows yet.
--
-- Two things this fixes and one it adds.
--
-- 1. Payment was a boolean and a string: projects.deposit_paid plus
--    projects.balance_due, which held a free-text note about when the balance
--    fell due. There was no way to mark the second half received, and no
--    amounts anywhere. It is now a row per instalment, so 50/50 today and
--    milestones or a retainer later need no further migration.
--
-- 2. The board. Cards an admin adds to a project: notes, links, files, a
--    recorded tax invoice, checklists, and a payments summary.
--
-- The old projects.deposit_paid and projects.balance_due columns are left in
-- place and are no longer written by the dashboard. They are kept for one
-- release so a rollback does not lose anything; drop them in a later migration
-- once nothing reads them.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- payments: one row per instalment
-- -----------------------------------------------------------------------------
create table if not exists public.payments (
  id           uuid primary key default gen_random_uuid(),
  project_id   uuid not null references public.projects on delete cascade,
  position     int  not null default 0,
  label        text not null default '',
  -- numeric, not float: money must not drift. 0 means "no amount recorded yet",
  -- which is different from a real zero and is rendered as blank.
  amount       numeric(12,2) not null default 0,
  state        text not null default 'pending' check (state in ('pending','paid','void')),
  due_note     text not null default '',   -- free text, e.g. before going live
  paid_on      text not null default '',
  -- The invoice is RECORDED here, never issued here. Israeli tax invoices need
  -- sequential numbering from an authorised system; this stores the reference
  -- and the file from whatever issued it.
  invoice_no   text not null default '',
  invoice_path text not null default '',
  created_at   timestamptz not null default now()
);

create index if not exists payments_project_idx on public.payments (project_id, position);

-- -----------------------------------------------------------------------------
-- blocks: the project board
-- -----------------------------------------------------------------------------
create table if not exists public.blocks (
  id                uuid primary key default gen_random_uuid(),
  project_id        uuid not null references public.projects on delete cascade,
  position          int  not null default 0,
  kind              text not null default 'note'
                    check (kind in ('note','link','file','invoice','checklist','payments')),
  title             text not null default '',
  body              text not null default '',
  -- kind-specific fields: url, file path, invoice number, checklist items
  data              jsonb not null default '{}'::jsonb,
  color             text not null default 'default',
  pinned            boolean not null default false,
  -- Internal by default. A card only reaches the client when this is flipped
  -- on deliberately, so one forgotten toggle cannot leak a private note.
  visible_to_client boolean not null default false,
  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now()
);

create index if not exists blocks_project_idx on public.blocks (project_id, position);

-- =============================================================================
-- ROW LEVEL SECURITY
-- =============================================================================

alter table public.payments enable row level security;
alter table public.blocks   enable row level security;

-- ---- payments ----
drop policy if exists payments_select on public.payments;
create policy payments_select on public.payments
  for select to authenticated
  using (
    public.is_admin() or exists (
      select 1 from public.projects p
      where p.id = payments.project_id and p.owner_id = auth.uid()
    )
  );

drop policy if exists payments_admin_write on public.payments;
create policy payments_admin_write on public.payments
  for all to authenticated
  using (public.is_admin()) with check (public.is_admin());

-- ---- blocks ----
-- visible_to_client is enforced HERE, not in the page. A client holds a real
-- token and can query PostgREST directly, so hiding an internal card in
-- JavaScript would leave it one request away from being read.
drop policy if exists blocks_select on public.blocks;
create policy blocks_select on public.blocks
  for select to authenticated
  using (
    public.is_admin() or (
      visible_to_client = true and exists (
        select 1 from public.projects p
        where p.id = blocks.project_id and p.owner_id = auth.uid()
      )
    )
  );

drop policy if exists blocks_admin_write on public.blocks;
create policy blocks_admin_write on public.blocks
  for all to authenticated
  using (public.is_admin()) with check (public.is_admin());

-- =============================================================================
-- BOARD FILES
--
-- Same shape as the quotes bucket in 005: private, one folder per project, so
-- the first path segment is what the policies check.
-- =============================================================================

insert into storage.buckets (id, name, public)
values ('files', 'files', false)
on conflict (id) do nothing;

drop policy if exists files_admin_all on storage.objects;
create policy files_admin_all on storage.objects
  for all to authenticated
  using (bucket_id = 'files' and public.is_admin())
  with check (bucket_id = 'files' and public.is_admin());

-- A client may read a file only if it sits in a project they own AND the card
-- pointing at it is shared with them. Without the second half, an internal
-- card's attachment would still be readable by guessing the path.
drop policy if exists files_client_read on storage.objects;
create policy files_client_read on storage.objects
  for select to authenticated
  using (
    bucket_id = 'files'
    and exists (
      select 1 from public.projects p
      where p.owner_id = auth.uid()
        and p.id::text = (storage.foldername(name))[1]
    )
    and exists (
      select 1 from public.blocks b
      where b.project_id::text = (storage.foldername(name))[1]
        and b.visible_to_client = true
        and (b.data ->> 'path') = name
    )
  );

-- =============================================================================
-- BACKFILL
--
-- Turns the old two-field model into two rows, preserving what it knew: the
-- deposit's paid state, and whatever balance_due said. Only touches projects
-- that have no payments yet, so re-running this file changes nothing.
-- =============================================================================

insert into public.payments (project_id, position, label, state, due_note)
select p.id, 1, 'מקדמה 50%',
       case when p.deposit_paid then 'paid' else 'pending' end,
       ''
from public.projects p
where not exists (select 1 from public.payments x where x.project_id = p.id);

insert into public.payments (project_id, position, label, state, due_note)
select p.id, 2, 'יתרה 50%', 'pending',
       coalesce(nullif(p.balance_due, ''), 'לפני עלייה לאוויר')
from public.projects p
where not exists (
  select 1 from public.payments x
  where x.project_id = p.id and x.position = 2
);

-- =============================================================================
-- SEED HELPER
--
-- The two standard instalments for a new project, mirroring seed_stages.
-- create-client calls this so a new project starts with the same payment shape
-- every existing one now has.
-- =============================================================================

create or replace function public.seed_payments(p_project uuid)
returns void
language sql
security invoker
set search_path = public
as $$
  insert into public.payments (project_id, position, label, state, due_note) values
    (p_project, 1, 'מקדמה 50%', 'pending', 'לתחילת העבודה'),
    (p_project, 2, 'יתרה 50%',  'pending', 'לפני עלייה לאוויר');
$$;
