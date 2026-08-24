-- =============================================================================
-- DROP upload_url
--
-- Run once in the SQL editor. Safe to re-run.
--
-- Files come in over WhatsApp, so the field was never used. Removed from the
-- schema too, and dropping it here keeps an existing database matching a fresh
-- one. No data is lost: nothing ever wrote to it.
-- =============================================================================

alter table public.projects drop column if exists upload_url;
