-- =============================================================================
-- MERGE the two product-page items into one
--
-- Run once in the SQL editor. Safe to re-run.
--
-- The catalogue priced the product page twice:
--
--   position 22, category design  - "product page design"
--   position 43, category build   - "custom product page"
--
-- In practice these are one deliverable. A quote that carried both charged a
-- client twice for the same page and inflated the total, which is exactly the
-- kind of line a prospect reads as padding.
--
-- The build item survives, because that is where the work actually sits and it
-- is what the public page already promises. Its note now says the design is
-- part of it, so nothing is silently dropped from the printed quote.
--
-- The design item is deactivated rather than deleted, following the same
-- convention as the retired content category in 004: existing quotes that
-- already reference the row keep resolving it.
--
-- No price is changed here. The surviving line keeps whatever it is currently
-- set to; adjust that from the dashboard if the merged item should cost more
-- than the build item did on its own.
-- =============================================================================

update public.quote_items
set    active = false
where  position = 22;

update public.quote_items
set    note = 'עיצוב ובנייה של דף המוצר'
where  position = 43;
