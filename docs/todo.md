# What is left to do

Ticked items were either verified by an actual request against the live project,
or reported done by the owner. Which one is noted, because the two are not the
same kind of certainty.

---

## Supabase

- [x] **Schema is live.** All four tables exist and RLS is enforcing. Verified:
      an anonymous write is rejected with
      `42501 new row violates row-level security policy`.
- [x] **Migrations run.** `002_objections`, `003_quote_items`, `004_prices`,
      `005_quote_files`, `006_drop_upload_url`. Reported done by the owner, not
      re-verified: the machine this was checked from has no network access.
- [ ] **Deploy `create-client`.** Last confirmed missing: the endpoint returned
      404. Without it the new-client tab cannot create accounts. No CLI needed,
      see [deploy.md](deploy.md) section 6b. **This is the only remaining
      blocker for taking on a first client.**
- [ ] **Admin account.** Authentication -> Users -> Add user, then run the
      `update` statement at the bottom of `supabase/schema.sql`. Unverified.
- [ ] **Turn off self-signup.** Authentication -> Sign In / Providers -> Email ->
      disable Allow new users to sign up. Unverified.

To check the last two in one go, from the SQL editor:

```sql
select u.email, p.role from public.profiles p
join auth.users u on u.id = p.id;
```

One row, role `admin`, is what you want to see.

---

## Public site

- [x] **`og:url` removed.** It pointed at `blackz.example`, which is the
      canonical address every WhatsApp share would have sent people to. Absent,
      the crawler falls back to the real page URL.
- [ ] **Domain on Vercel.** Nothing else on this list can be finished first.
- [ ] **`og:url` and `og:image`.** Both are written out as a ready-to-paste
      block in the head of `index.html`. Needs the domain, plus a 1200x630
      image. Until then every shared link previews as bare text, and that is
      how most people will first meet the page.

---

## Repo health

- [x] **Line endings normalised.** `.gitattributes` added and the tree converted
      to LF. Before this every commit rewrote every file, so `git log` and
      `git blame` were useless. Verified: committed blobs contain zero CRLF.
- [x] **`c/_template.html` kept off the deployment.** It ships with demo data
      and was reachable in production as a project belonging to nobody. Copies
      of it under `c/` still deploy, which is the point.
- [x] **README rewritten** to describe the dashboard, Supabase and Vercel. It
      previously described the project as a single static file, which was about
      half of what exists.
- [x] **`docs/` excluded from the deployment.** No reason to publish the
      internal notes, and `pricing.md` in particular lists every price.

---

## Open decisions

Things raised and never settled. None of them break anything.

- [ ] **No development track in the package tabs.** The commercially significant
      one. The quote catalogue prices databases, admin interfaces, API work and
      custom components, but the public page offers only store, ads, or both. A
      client who wants a coded site sees nothing for himself, and that is the
      work with the least price competition. Adding a fourth tab means deciding
      what it promises, which is why it is sitting here rather than done.
- [ ] **Starting price in the hero.** The line is written and waiting in a
      comment at `index.html`. A page with a number on it closes harder.
- [ ] **`בלאקזי איקומרס` versus `בלאקזי`.** The copyright says the former,
      everything else says the latter. Fine if that is the registered name.
- [ ] **Brand design is not in the package tabs.** Sold as a standalone service
      only. Deliberate, since it also closes the gap between what the packages
      promise and what they cost.
- [ ] **Two Instagram accounts.** The network signature links to
      `@netanel.yan`, the footer to `@blackzecom`. Reasonable if one is the
      owner and one is the brand.

---

## Not started

- [ ] **No client proof anywhere on the site.** Four brands you own, zero client
      work. The `<article class="venture">` block in `#ventures` is already the
      right component: duplicate it, point it at the client's domain, add the
      URL to `scripts/shoot.js`, and the weekly job keeps the screenshot current.
      Works from the first shipped project, and it is the single biggest gap
      between this site and one that closes on its own.

---

## Optional

- **The call questions** are hardcoded in `app/dashboard.html`, unlike the
  objections which are editable from the dashboard. Same treatment available:
  a table, a policy, and a small editor. Worth doing only once the questions
  stop changing after every call.
- **`internal/sales.html`** is redundant. Its quote calculator and call
  questions both moved into the dashboard. Kept in the repo, deliberately not
  deployed, and safe to delete whenever you are sure nothing there is unique.
- **The venture screenshots** refresh themselves weekly. Nothing to do.
