# blackz-web

The BlackZ site and system. Three parts in one repo:

| | What it is | Who gets in |
|---|---|---|
| **The public site** | `index.html` - single page, Hebrew RTL | everyone |
| **The dashboard** | `app/dashboard.html` - project management, quote builder, objection answers, call questions | you, plus clients who see only their own project |
| **Manual status page** | `c/_template.html` - a template for a client with no account | whoever has the link |

No build step and no dependencies. Every HTML file stands on its own, with its
CSS and JS inside it. The data lives in Supabase, the site is hosted on Vercel.

> `internal/sales.html` is an internal sales page with no login, so it is
> **not deployed** (see `.vercelignore`). Its content moved into the dashboard.

---

## Repo layout

```
index.html              the public site
accessibility.html      accessibility statement. Standalone page, linked from the widget and the footer
takanon.html            terms of service. Standalone page, built from the same shell as the statement
osek-murshe.pdf         Osek Murshe certificate. Linked from the "business and terms" section
robots.txt              crawling is allowed everywhere. Private paths are noindexed by header, not by a Disallow
sitemap.xml             the three public pages. Domain is literal, keep it in sync with BLACKZ.DOMAIN
FILL-IN.md              record of every value that was unwritten on the site, and where each came from
app/dashboard.html      the dashboard. Admin and client in one file, by role
c/_template.html        status-page template. Copy it per account-less client
internal/sales.html     internal price list and call script. Not deployed
supabase/               schema and migrations. Run them by hand in the SQL editor
  schema.sql            tables, RLS, triggers
  002..006_*.sql        migrations, in order
  functions/create-client/  Edge Function that creates a client account
docs/
  deploy.md             setup from scratch: Supabase, then Vercel
  pricing.md            snapshot of the price list
  todo.md               what is left to do
scripts/shoot.js        automated screenshots of the ventures
shots/*.jpg             the results. They refresh themselves weekly
```

**Setting up from scratch:** [docs/deploy.md](docs/deploy.md). That is the full
guide, step by step.

---

## How it works

### Permissions

Authorization is enforced in the database, not in the page. Every table is
protected by Row Level Security:

- **Admin** sees and edits everything.
- **Client** sees only the project linked to them, read-only.

That is why the key embedded in `app/dashboard.html` is the publishable key and
is safe to ship - on its own it grants nothing. **Never embed the secret key.**
It bypasses every policy.

Clients do not sign themselves up. You create each account, and self-signup is
turned off.

### Why there is an Edge Function

Creating a user requires the secret key, which must never reach the browser. So
`create-client` runs server-side: it verifies the caller is a signed-in admin,
creates the user and the project, and if anything fails midway it deletes the
user again - so no account is left without a project.

---

## Routine tasks

### Changing a price

Dashboard -> quote tab -> **price list** -> edit -> save. It writes straight to
the database. `docs/pricing.md` is a read-only snapshot, worth updating too.

**Included** means the item is always part of the base price. It prints on the
quote as "included", adds nothing to the total, and does not trigger the warning
about an item with no price.

### Adding a client

Dashboard -> **new client**. Fill in email, temporary password, name and dates,
and optionally attach a quote file. The account, the project, the four stages
and the materials are all created at once.

Give the client the dashboard address, the email and the temporary password.

> For a client you do not want to open an account for: copy `c/_template.html`
> to a new name under `c/`, fill in the CONFIG block at the top of the file, and
> send the link. The template itself is not deployed - only the copies you make.

### Updating a client's status

In the dashboard, phone included. Open a project, edit, save. Four parts are
editable:

| Part | What you can do |
|---|---|
| **Progress map** | change the state of any stage |
| **What we need from the client** | add an item, reword it, reorder, delete |
| **Payment** | one row per payment: amount, state, date and invoice number |
| **Project board** | cards you add to the project |

### Payment

Not a single boolean but **one row per payment**, in the `payments` table. Each
row can be marked paid on its own, so the balance can be tracked and not just
the advance. A new project is born with two rows (advance and balance), and you
can add more - milestones, a retainer, whatever is needed - with no further
migration.

> **A tax invoice is recorded here, not issued here.** A tax invoice requires
> sequential numbering from an authorized system. The fields here store the
> number, date, amount and file from whatever issued it.

### The project board

Cards you add to a project, in six types: note, link, file, tax invoice,
checklist and payment summary. Each card has a color, can be pinned to the top,
and can be reordered.

> **A new card is internal by default.** It reaches the client only after the
> "shown to client" flag is explicitly ticked. That rule is enforced in RLS, not
> in the page: the client holds a real token and can call the API directly, so
> hiding a card in JavaScript alone would leave an internal card one request
> away.

Files are stored in a private bucket named `files`, in a folder per project, and
are opened through a signed link that expires. A client can read a file only if
it is in their project **and** the card pointing at it is shared with them.

The **last updated** field is written by hand on purpose. An automatic date
would present the page as current on a day nobody checked anything.

### Deploying a code change

`git push` to `main`. Vercel deploys on its own.

> The screenshot bot pushes to `main` once a week. So **always `git fetch`
> before pushing**, and rebase rather than forcing if the push is rejected.

---

## Domain, email and WhatsApp number

All three live in one block at the top of the `<head>` in `index.html`:

```js
var BLACKZ = {
  DOMAIN:    'https://getblackz.com',
  EMAIL:     'natikyan153@gmail.com',
  WA_NUMBER: '972515310498'
};
```

The WhatsApp number is in international format, with no `+` and no hyphens.
`050-1234567` becomes `972501234567`.

**Every** WhatsApp button, **every** mailto link (including its visible text)
and the JSON-LD block are built from that block. Changing it changes all of them.

> **One exception.** Four tags sit directly beneath the block with the domain as
> literal text: `canonical`, `og:url`, `og:image` and `twitter:image`. The
> crawlers that read them - WhatsApp, Facebook and iMessage - do not run
> JavaScript, so they cannot be generated from the config. They are marked with
> a comment, and the page prints a console warning if they and the config
> disagree about the domain.
>
> Still missing: a 1200x630 `og.jpg` at the site root. Without it every share
> renders as text only.

On the client status page the number sits separately, inside that file's own
CONFIG block.

---

## Accessibility

A round button in the bottom corner (on the start side, meaning the right in
RTL) opens a settings menu: text size, high contrast, greyscale, link underline
and emphasis, spacing, enlarged cursor and stopped animations.

The code is split in two, like the module and the component that uses it:

| Where | What |
|---|---|
| `BlackZA11y` at the top of the `<head>` | load, save and apply. Runs **before** first paint |
| the component at the bottom of the file | UI only: reads from the object and writes to it |

Settings are saved in localStorage under `blackz-a11y`, and applied as classes
on `<html>` (`a11y-contrast`, `a11y-grayscale` and so on). That way they apply
immediately on a reload, with no flash - the same reason the color scheme lives
there.

Three things that are easy to break:

- **Contrast** works by overriding the same CSS variables the whole page reads,
  so it reaches every component at once. No per-component override is needed.
- **Greyscale** is painted as a fixed `backdrop-filter` layer, not as a `filter`
  on `<html>`. A `filter` on an element makes it the containing block for
  `position: fixed` descendants, which would break the sticky header, the
  WhatsApp bar and the widget itself.
- **Stopping animations** must also reveal the content. The rule
  `html.a11y-nomotion .rv` overrides the hidden state; otherwise stopping the
  animation would freeze sections while they are still transparent.

The widget sits in both `index.html` and `accessibility.html`, so three blocks
are duplicated between the two files and marked
`[KEEP IN SYNC WITH index.html]`: the `BlackZA11y` module, the CSS for the
states, and the UI logic. The first two are duplicated **byte for byte** on
purpose, so a plain comparison can verify it:

```bash
node -e "const f=require('fs'),g=(s)=>{const i=s.indexOf('var BlackZA11y');return s.slice(i,s.indexOf('})();',i))};
console.log(g(f.readFileSync('index.html','utf8'))===g(f.readFileSync('accessibility.html','utf8')))"
```

`accessibility.html` also carries its own `CONFIG` block with the email address,
like `c/_template.html`. That is the price of having no build step: changing the
email address is a two-file edit, and both are marked.

The legal declarations on that page - conformance level, limitations,
accessibility coordinator and date - are written. The conformance line says the
page was **built to** WCAG 2.1 AA and that only an internal check has been run;
it does not claim a certified standard, because no licensed accessibility
expert has audited it. Do not upgrade that wording without one.

The one limitation it declares is `osek-murshe.pdf`, which is untagged and so
not accessible. Every field in it is also plain text in the "business and
terms" section of `index.html`, which is the accessible equivalent. Replace the
PDF with a tagged one and that sentence can go.

---

## Design and branding

Every color, font and spacing value is a CSS variable at the top of each file,
inside `:root`. To change the brand color, change one value: `--c-accent`.

> The tokens are copied into each file rather than shared, because there is no
> build step and each page has to stand alone. A brand color change has to pass
> through `index.html`, `app/dashboard.html`, `c/_template.html` and
> `internal/sales.html`.

**The logo** appears in three places, all from the same vector:

| File | Use |
|---|---|
| `logo.svg` | the standalone logo file, white on transparent |
| `favicon.svg` | the browser-tab icon - transparent, inverts with the color scheme |
| `index.html` | embedded as `<symbol id="blackz-mark">` at the top of the `<body>` |

Inside the page the logo is drawn in `currentColor`, so it wears the header's
text color and takes the brand color on hover. To change the logo color, change
`.logo__mark`.

> Replaced the logo? Update the `<symbol>` inside `index.html` and both SVG
> files. They are not synced automatically.

### Font

The public site uses [Arimo](https://fonts.google.com/specimen/Arimo), embedded
as base64: two subsets (Hebrew and Latin), a variable font at weights 400-700,
about 31KB. No network request - the font loads immediately, offline included.
License: Apache License 2.0.

To replace it: delete the two `@font-face` declarations at the top of the
`<style>` block and update `--f-sans`.

> Arimo only goes up to weight 700, which is why `--fw-black` is set to 700 and
> not 900.

**The dashboard and the client page do not embed the font** and use the system
font instead. Those are tools that need to open instantly on a phone, and 31KB
in every copy of a client page is waste.

---

## Venture screenshots

The venture cards are built as browser windows, and each one expects a file:

```
shots/hashofet.jpg   shots/clutchstore.jpg
shots/tiyulplus.jpg  shots/brickdealil.jpg
```

16:10 ratio, 1200px wide or more. As long as a file is missing, a styled
placeholder shows and nothing breaks.

**Do not edit them by hand.** `.github/workflows/screenshots.yml` runs
`scripts/shoot.js` every Monday and pushes the result. To add a venture: add a
row to the `SITES` array in `scripts/shoot.js` and duplicate an
`<article class="venture">` block in `index.html`.

---

## Contact form

By default the form opens a WhatsApp conversation with the details that were
filled in - it works immediately, with no server. To switch to sending by email:
the full instructions are in the comment next to the form in the file.

---

## Running locally

```bash
python -m http.server 8000
```

`http://localhost:8000` for the site, `/app/dashboard.html` for the dashboard.
The dashboard talks to the real Supabase even locally, so a change saved locally
is a real change.

---

## Unwritten values

None. Every value on the site is written and sourced, and
[FILL-IN.md](FILL-IN.md) records where each one came from.

The machinery stays, because the next unknown will need it. A value nobody has
yet gets the `.ph` class and a `[[FILL: ...]]` marker, which renders inside a
dashed amber outline so it cannot ship unnoticed, plus a line in the
PLACEHOLDER INDEX at the bottom of `index.html` saying what it is waiting on.

The rule that produced it is the one in CLAUDE.md: never invent a figure. When
the campaign detail in the case study turned out to have no publishable answer,
the sentence was cut rather than softened into something vague.

---

## Working rules for the code

Spelled out in [CLAUDE.md](CLAUDE.md). In short: comments and commits in
English, anything a visitor reads in Hebrew, no long dashes, and logical CSS
properties instead of `left` / `right`.
