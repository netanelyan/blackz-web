# What is left to do

Ticked items were either verified by an actual request against the live project,
or reported done by the owner. Which one is noted, because the two are not the
same kind of certainty.

---

## Supabase

Everything in this section was probed against the live project on 2026-08-27
with the publishable key, from a machine with network access. Each check below
was run alongside a deliberately wrong control (a column that does not exist, a
bucket that does not exist) so that a pass means the endpoint really
discriminates, rather than returning the same answer to everything. The earlier
round of these checks reported `000` on every request, because that machine had
no egress at all. None of those results meant anything and none are reused here.

- [x] **Schema is live and RLS is enforcing.** Verified by request: `profiles`,
      `projects`, `stages`, `materials`, `objections` and `quote_items` all
      answer `200` to an anonymous read, and every one returns zero rows.
      Zero rows on its own would be weak evidence, since an empty table looks
      exactly like a blocked one. It is conclusive on two of them: `002` seeds
      12 objection rows and `003` seeds 55 catalogue rows, both tables are
      governed by `for all to authenticated using (is_admin())`, and both come
      back empty anonymously. Seeded tables returning nothing is RLS filtering,
      not absence of data. On `profiles`, `projects`, `stages` and `materials`
      the empty result is consistent with RLS but not proof, because no client
      account exists yet for them to hold anything.
- [x] **Migrations run.** All five verified by request, each by probing for the
      thing that migration is the only source of:
      - `002_objections` - the `objections` table resolves.
      - `003_quote_items` - the `quote_items` table resolves.
      - `004_prices` - `quote_items.default_included` selects cleanly, where an
        invented column name on the same table returns
        `42703 column does not exist`. This is the one the owner reported as run
        but that had never actually been checked. It is now checked, and it is
        genuinely applied.
      - `005_quote_files` - the `quotes` storage bucket resolves. Requesting a
        missing object inside it returns `NoSuchKey`, while every other bucket
        name tried returns `NoSuchBucket`. Storage resolved the bucket and then
        failed to find the object, which only happens if the bucket is there.
      - `006_drop_upload_url` - `projects.upload_url` is gone: selecting it
        returns `42703`, while `projects.client_name` on the same table returns
        `200`.
- [ ] **Deploy `create-client`.** Still missing, re-confirmed by request:
      `POST /functions/v1/create-client` returns
      `404 {"code":"NOT_FOUND","message":"Requested function was not found"}`,
      byte for byte the same answer as a function name invented for the
      control. Deployment was attempted from the CLI and could not be finished:
      `supabase login` needs a browser sign-in or an access token, neither of
      which was available, and `supabase projects list` refuses with
      `Access token not provided`. Nothing was guessed or half-applied. Use the
      dashboard route in [deploy.md](deploy.md) section 6b, name it exactly
      `create-client`, and leave Verify JWT on. Once deployed the same anonymous
      POST should return `401` rather than `404`, and that is the check to
      re-run. Without it the new-client tab cannot create accounts. **This is
      the only remaining blocker for taking on a first client.**
- [ ] **Admin account.** Authentication -> Users -> Add user, then run the
      `update` statement at the bottom of `supabase/schema.sql`. Still
      unverified, and not checkable from outside: an anonymous read of
      `profiles` returns zero rows whether the admin row exists or not, which
      is RLS working correctly rather than an answer. Needs the SQL editor.
- [ ] **Turn off self-signup.** Authentication -> Sign In / Providers -> Email ->
      disable Allow new users to sign up. Still unverified. Deliberately not
      probed: the only anonymous test is to actually sign a new user up, which
      would create the account it was meant to check for. Needs the dashboard.

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
- [ ] **Domain on Vercel.** `getblackz.com` is bought; it still has to be added
      to the Vercel project and pointed at it. The page already claims that
      address in `canonical` and `og:url`, so until the domain actually resolves
      those tags point somewhere that does not answer.
- [x] **`og:url` written.** Reported by the owner as the bought domain, not
      verified by request: `getblackz.com` did not resolve at the time of
      writing, which is expected before it is pointed at Vercel. Re-check once
      the domain is live.
- [ ] **`og:image`.** The tag is in the head and points at `/og.jpg`, but no
      such file exists in the repo. It has to be a real 1200x630 image at the
      site root. Until it is uploaded every shared link previews as bare text,
      and that is how most people will first meet the page.
- [x] **Domain, email and WhatsApp number pulled into one config.** `BLACKZ` at
      the top of the head in `index.html`. Verified by rendering the page in
      headless Chrome and reading the resulting DOM: all 7 WhatsApp links, all
      3 mailto links and the injected JSON-LD are built from it. The four
      crawler-facing tags still carry the domain literally, because the
      crawlers that read them do not run JavaScript; a startup check warns on
      drift between the two.
- [x] **Sections no longer render as a heading over empty space.** The hidden
      state was `.rv{opacity:0}`, so hidden was the CSS default and visible
      required JS. It is now scoped to `.js-rv`, stamped on `<html>` before
      first paint, and an uncaught error anywhere removes it. Verified in
      headless Chrome by scrolling the whole page at 360x780, 390x844 and
      1280x800, and by re-running both failure modes deliberately: with
      `IntersectionObserver` deleted, and with an uncaught error thrown after
      DOMContentLoaded. Nothing was left hidden in any of the five runs.
- [x] **Case study for Hanut Hashofet.** New `#case` section. Every figure is a
      `[[FILL: ]]` placeholder - see the PLACEHOLDER INDEX comment at the
      bottom of `index.html`. The section states in the markup that Hashofet is
      our own brand rather than a client, because a case study reads as client
      work by default.
- [x] **Business and terms section.** New `#legal` section: registered holder,
      trade name, Osek Murshe number and business address, all taken from the
      certificate supplied on 2026-08-29 and also mirrored into the JSON-LD.
      Plus the 50/50 split, what the 4 weeks assume, and what the 2 weeks of
      support cover. Only the two cancellation terms are still placeholders,
      because they are a policy decision rather than anything the certificate
      records.
- [x] **Accessibility widget.** Ported from a React/Tailwind component supplied
      by the owner into vanilla CSS and JS on the site's own tokens, since
      there is no build step here. Text size, contrast, greyscale, underline
      and highlight links, spacing, big cursor, stop animations, reset.
      Verified by driving all of it in headless Chrome over CDP: 24 checks
      covering every toggle changing the page, a 44px tap target that nothing
      covers, focus moving into the panel and back to the button, Escape,
      persistence across a reload, reset clearing everything, and no
      horizontal overflow at 390px with the panel open.
- [ ] **Accessibility statement declarations.** `accessibility.html` exists and
      describes what is actually implemented, but the five legally required
      declarations are placeholders: conformance level and the standard tested
      against, known limitations, coordinator name, contact phone, and the
      date. **Do not fill the conformance level with a level that has not been
      audited.** Under the Israeli regulations these have to be accurate, and
      a wrong claim is worse than an honest gap.
- [x] **Favicon on every page.** `app/dashboard.html` and `c/_template.html`
      had none and rendered with a blank tab icon.
- [x] **Placeholder brackets no longer mirrored.** `.ph` markers are a
      bracketed mix of Latin and Hebrew; in an RTL line the brackets are
      neutrals and swapped ends, so they rendered as `]]FILL: ...[[`. Fixed
      with `direction:ltr` on `.ph`. Verified by measuring the client rect of
      the opening and closing brackets of all 17 markers.

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

## Payments and the board

- [ ] **Run `008_payments_and_board.sql`.** Creates `payments` and `blocks`,
      the private `files` bucket, and their policies. It backfills two payment
      rows per existing project from `deposit_paid` and `balance_due`, so run
      it before using the new payment section or every project will look like
      it has no instalments. Safe to re-run.
- [ ] **Redeploy `create-client` after 008.** It now seeds the two instalments
      alongside the four stages. Deploying the old copy would create projects
      with an empty payment section. It has never been deployed at all yet, so
      this is the same single deploy either way - just make sure it is the
      current file.
- [ ] **Drop `projects.deposit_paid` and `projects.balance_due`.** Superseded
      by the `payments` table and no longer written by the dashboard. Left in
      place for one release so a rollback loses nothing. Once the new payment
      section has been used for real, a `009` can drop both columns.

---

## Quote catalogue

- [ ] **Run `007_merge_product_page.sql`.** The catalogue priced the product
      page twice: position 22 in the design category and position 43 in the
      build category are one deliverable, and a quote carrying both charged for
      it twice. The migration deactivates 22 and relabels 43 to say the design
      is included. Not yet applied to the live database - run it in the SQL
      editor, or do the same thing from the dashboard price list.
- [ ] **`docs/pricing.md` has drifted from the live catalogue.** Several rows
      were seen at lower prices in the dashboard on 2026-08-29. Only a partial
      view was visible, so nothing in the file was edited to match and the
      differences are noted at the top of it instead. Resync from the dashboard.

---

## Open decisions

Things raised and never settled. None of them break anything.

- [ ] **No development track in the package tabs.** The commercially significant
      one. The quote catalogue prices databases, admin interfaces, API work and
      custom components, but the public page offers only store, ads, or both. A
      client who wants a coded site sees nothing for himself, and that is the
      work with the least price competition. Adding a fourth tab means deciding
      what it promises, which is why it is sitting here rather than done.
- [x] **Starting price in the hero.** Now live in the hero note and again next
      to the CTA in the pricing card, as a `[[FILL: ]]` placeholder in both
      places. The two must carry the same number - noted in the placeholder
      index.
- [x] **`בלאקזי איקומרס` versus `בלאקזי`.** Settled by the Osek Murshe
      certificate: the registered trade name is `בלאקזי איקומרס`, so the
      footer copyright was right all along and the shorter form everywhere
      else is the brand name. Both now appear in `#legal`, where the
      distinction is the point.
- [ ] **Brand design is not in the package tabs.** Sold as a standalone service
      only. Deliberate, since it also closes the gap between what the packages
      promise and what they cost.
- [ ] **Two Instagram accounts.** The network signature links to
      `@netanel.yan`, the footer to `@blackzecom`. Reasonable if one is the
      owner and one is the brand.

---

## Not started

- [ ] **No client proof anywhere on the site.** Four brands you own, zero client
      work. The `#case` section now walks through Hanut Hashofet end to end,
      which is the closest thing available, but it is explicitly labelled as
      our own brand and it is not a reference. The `<article class="venture">`
      block in `#ventures` is still the right component for real client work:
      duplicate it, point it at the client's domain, add the URL to
      `scripts/shoot.js`, and the weekly job keeps the screenshot current.
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
