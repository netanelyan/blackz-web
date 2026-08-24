-- =============================================================================
-- QUOTE FILES
--
-- Run once in the SQL editor. Safe to re-run.
--
-- Somewhere to put the signed quote so the client can open it from their own
-- project page instead of digging through WhatsApp for the attachment.
--
-- The bucket is private. A quote carries prices and payment terms, so a public
-- bucket would put every client's terms behind a guessable URL.
-- =============================================================================

alter table public.projects
  add column if not exists quote_path text not null default '';

insert into storage.buckets (id, name, public)
values ('quotes', 'quotes', false)
on conflict (id) do nothing;

-- Files are stored as <project_id>/<filename>, so the first path segment is the
-- key the policies check against.

drop policy if exists quotes_admin_all on storage.objects;
create policy quotes_admin_all on storage.objects
  for all to authenticated
  using (bucket_id = 'quotes' and public.is_admin())
  with check (bucket_id = 'quotes' and public.is_admin());

-- A client may read a file only if the folder it sits in is a project they own.
drop policy if exists quotes_client_read on storage.objects;
create policy quotes_client_read on storage.objects
  for select to authenticated
  using (
    bucket_id = 'quotes'
    and exists (
      select 1 from public.projects p
      where p.owner_id = auth.uid()
        and p.id::text = (storage.foldername(name))[1]
    )
  );
