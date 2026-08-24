# blackz-web

Single-page static marketing site for BlackZ. Hebrew, RTL, one file.

## Hard rules

### Language: English in the code, Hebrew on the page

- **Code comments are English.** HTML, CSS, JS, YAML - all of them. No Hebrew comments, ever.
- **Git commit messages are English.** Subject and body. Never quote Hebrew strings in a
  commit message; describe them in English instead.
- **Developer-facing strings are English** - `console.log`/`console.warn`, CI output, script logs.
- **User-facing text stays Hebrew.** Everything that renders in the browser: page copy,
  form validation messages, WhatsApp message templates, `alt` text, `aria-label`s, and the
  `[כך]` placeholder markers shown on the page.

Why: Hebrew is RTL and mangles diffs, `git log`, and terminal output, which makes code
review and history genuinely harder to read.

### No em dashes

Use a plain hyphen `-`. Never `—` (em dash) or `–` (en dash). This applies everywhere:
page copy, code comments, docs, and commit messages.

The Hebrew maqaf `־` inside compound words (`יום־אחרי־יום`, `ב־base64`) is correct Hebrew
punctuation, not a dash. It stays.

### Commit and push every time

Finish the work, verify it, then commit and push to `main` without being asked.

Fetch first. The screenshot Action commits to `main` on its own schedule, so a push can
be rejected as out of date. Rebase onto it rather than forcing.

(This replaces an earlier rule to wait for an explicit "commit". The user changed it.)

## Structure

Everything is in `index.html` - inline CSS and JS, no build step, no external requests.

- Design tokens (colors, fonts, spacing) are CSS variables in `:root` at the top of the file.
  Rebranding should be a one-block edit.
- Arimo is embedded as base64 (`@font-face` at the top of the style block). Weights 400-700
  only, so `--fw-black` is 700 - 900 would clamp and flatten the heading hierarchy.
- Page is two labelled parts: **01 המותג** (brand) and **02 השירותים** (services).
- Every WhatsApp button reads from a single `WA_NUMBER` constant at the bottom of the file.
- Anything unknown is marked `[כך]` with `class="ph"`, which renders with a dashed amber
  outline so it is impossible to miss on the page.

## RTL

- Use logical properties (`margin-inline`, `inset-inline-start`, `text-align: start`).
  Never `left` / `right`.
- Wrap Latin text and numbers that sit at a line edge in `<bdi>` or `.ltr` / `.num`.
  Without isolation, price ranges, domains, trailing punctuation and the `+` in `Tiyul+`
  render in the wrong order.
- `tel` / `url` / `email` inputs get `direction: ltr` with `text-align: right`.

## Screenshots

`shots/*.jpg` are the venture screenshots shown inside the browser-window frames.
They are regenerated weekly by `.github/workflows/screenshots.yml` via `scripts/shoot.js`.
Do not hand-edit them.

## Never invent

No testimonials, client names, revenue figures, order counts, or awards. If a section needs
proof that has not been provided, leave a marked placeholder. Verify a URL before linking it -
`brickdeal.com` looked right but turned out to be an unrelated Dutch site.
