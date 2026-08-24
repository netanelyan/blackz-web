# What is left to do

Checked against the live project, not from memory. Anything ticked was verified
by an actual request.

---

## Supabase

- [x] **Schema is live.** All four tables exist and RLS is enforcing. Verified:
      an anonymous write is rejected with
      `42501 new row violates row-level security policy`.
- [x] **Migrations are run.** `objections` and `quote_items` both respond.
- [ ] **Admin account.** If not done yet: Authentication -> Users -> Add user,
      then run the `update` statement at the bottom of `supabase/schema.sql`.
- [ ] **Turn off self-signup.** Authentication -> Sign In / Providers -> Email ->
      disable Allow new users to sign up.
- [ ] **Deploy `create-client`.** Confirmed missing: the endpoint returns 404.
      Without it the new-client tab cannot create accounts. No CLI needed, see
      [deploy.md](deploy.md) section 6b.

---

## Pricing

- [x] **All items priced.** 55 in the catalogue: 49 with a number, 6 always included.
- [ ] **Run `supabase/004_prices.sql`** to write them to the database. Until
      then the dashboard still shows the seeded zeros.
- [ ] **Run `supabase/005_quote_files.sql`** to create the private quotes
      bucket. Until then attaching a quote to a new client fails, though the
      client itself is still created.
- [ ] **Run `supabase/006_drop_upload_url.sql`** to drop the unused column.

Six items were marked כלול rather than given a number, meaning they are always
part of the base price. They carry a `default_included` flag instead of a price
of 0, so they print as included and do not trigger the unpriced warning.

---

## Public site

- [ ] **`og:url`** in `index.html` is still `https://blackz.example`.
- [ ] **`og:image`** is still commented out. Needs a 1200x630 image.

These two decide what the link looks like when it is shared on WhatsApp or
Instagram. Without them the preview is bare text, and that is probably how most
people will first meet the page.

- [ ] **Domain on Vercel.** Once it resolves, update the two fields above.

---

## Open decisions

Things I raised that were never settled. None of them break anything.

- [ ] **Two Instagram accounts in the footer.** The network signature links to
      `@netanel.yan` while the footer links to `@blackzecom`. If `@blackzecom` is
      the one you want people landing on, it is a one-line change.
- [ ] **`בלאקזי איקומרס` versus `בלאקזי`.** The copyright says the former,
      everything else says the latter. Fine if that is the registered name.
- [ ] **Brand design is not in the package tabs.** It is sold as a standalone
      service only.
- [ ] **The package tabs have no development track.** They are store, ads, or
      both. A client buying a developed site does not see themselves there.
- [ ] **Starting price in the hero.** The line is written and waiting in a
      comment in `index.html`. A page with a number on it closes harder.

---

## Now redundant

- **`internal/sales.html`** - its quote calculator and call questions moved into
  the dashboard. Still in the repo but deliberately not deployed to Vercel,
  because it has no login and exposes the floor price.
- **`c/_template.html`** - still useful for a client you do not want to create an
  account for.

---

## Optional

- **The call questions** are still hardcoded, unlike the objections which are
  editable. Same treatment available if you want it.
- **The venture screenshots** refresh themselves weekly. Nothing to do.
