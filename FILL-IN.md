# Fill-in sheet

Nothing is open. Every value on the site is written and sourced, and this file
is now the record of where each one came from.

It stays as a sheet because the next unknown will need one. When a value is not
known yet, do not guess it: mark it, and add an item here.

## How a new placeholder works

Give the value `class="ph"` and a `[[FILL: what it is]]` marker in the HTML. It
renders inside a dashed amber outline, so an unfilled value is visible to every
visitor rather than shipping as a silent blank. Add a line to the PLACEHOLDER
INDEX comment at the bottom of `index.html` saying what it is waiting on, and an
item to this file with an `Answer:` line.

Answers are page copy, so they are written in Hebrew. Bare numerals get
`<span class="num">` the way the surrounding lines already do. Descriptions in
the code and in this file are English, per CLAUDE.md.

To fill one: replace the whole `<span class="ph">...</span>` element, including
the `<span>` tags, with the plain text. Leaving the `<span class="ph">` in place
keeps the amber outline on a value that is no longer a placeholder.

**A value with no honest answer gets cut, not softened.** That is what happened
to the campaign detail below.

## Where each value came from

| Value | Written as | Source |
|---|---|---|
| Registered holder, trade name, Osek Murshe number, address | - | `osek-murshe.pdf`, on 2026-08-29 |
| Catalogue size at launch | `כ־60 מוצרים` | 60 products first published across 2024-07-02 and 2024-07-03 |
| Launch date | `יולי 2024` | same feed, earliest publish cluster |
| The "before" state | `אפס נוכחות - המותג נבנה מאפס` | your call, 2026-09-02 |
| Cancellation notice | `14 יום` | your call; matches the 4-week build the same section promises |
| The advance on cancellation | offset against work performed, remainder returned | your call; agrees with the sentence that follows it |
| Conformance level | built to WCAG 2.1 AA, internally checked, not yet audited | deliberately narrow, see below |
| Known limitations | the untagged certificate PDF | verified: no `StructTreeRoot`, no `MarkInfo` |
| Accessibility coordinator | `יאנצ׳בסקי נתנאל` | the registered holder |
| Accessibility phone | `051-5310498` | `BLACKZ.WA_NUMBER` |
| Statement date | `02.09.2026` | the day it was written |
| Starting price, both places | `2,700` ₪ + מע״מ | your answer on this sheet, 2026-09-03 |
| Project duration | `4 שבועות` | same; agrees with the 4-week build in the terms |
| Outcome metric | `מעל 2,000 הזמנות` | same; written as a running total |

## Cut rather than written

**Campaign detail, case study step 03.** It was going to read
`ערוצים, תקציב יומי והיקף הקריאטיבים: ___`, and the honest version needed a
daily budget and a creative count. A daily budget is not something every shop
publishes, and there was no way to write the sentence without one that was not
vague. The sentence was removed on 2026-09-03. The paragraph above it already
names Meta and TikTok, so nothing factual was lost.

Removed the same day, for the same reason in reverse: the line under the case
study promising that testimonials would appear once clients agreed to be named.
A page does not need to narrate what it does not have.

## Notes on two of the entries

The two case-study figures at the top of the table come from the public
`/products.json` feed at hashofet.com. They are derived from `published_at`,
which moves if a product is unpublished and republished, so correct them if the
real dates differ. The same feed reports 366 products and 3,929 variants live
today.

**The conformance level does not claim a certified standard, on purpose.** It
says the page was *built to* WCAG 2.1 AA and that only an internal check has
been run. Upgrading that to a compliance claim needs a real audit by a licensed
accessibility expert; a wrong claim there is worse than an honest gap.

## Not a placeholder

The four venture screenshots under `shots/` also carry `.ph` fallback text, but
those are not values to write - they are the message shown if an image fails to
load. `.github/workflows/screenshots.yml` regenerates the images weekly.

`og.jpg` (1200x630) is still missing from the site root. It is not a
placeholder, so nothing on the page shows amber, but until it exists every
shared link previews as text with no image.
