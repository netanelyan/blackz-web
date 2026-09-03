# Fill-in sheet

One value on the live site is still unwritten, in `index.html`. It renders
inside a dashed amber outline, so an unfilled value is visible to every visitor
rather than shipping as a silent blank.

Write your answer on the `Answer:` line below, then hand the file back and
the value gets pasted into the page. Or paste it straight into the HTML
yourself: search the file for the quoted `[[FILL: ...]]` string, and replace
the whole `<span class="ph">...</span>` element - including the `<span>`
tags - with the plain text. Leaving the `<span class="ph">` in place keeps the
amber outline on a value that is no longer a placeholder.

**Answers are page copy, so write them in Hebrew.** Wrap bare numerals in
`<span class="num">` the way the surrounding lines already do.

Skip it if you do not have it. An honest amber gap is better than a number that
is not true; that is the whole reason it is marked instead of guessed.

Thirteen values that used to be on this sheet are now written - see
[Already filled](#already-filled) at the bottom.

---

## Case study - חנות השופט

### 1. Campaign detail - step 03

Search: `[[FILL: פירוט הקמפיינים`
Renders as: `ערוצים, תקציב יומי והיקף הקריאטיבים: ___.`

Channels, daily budget and how many creatives ran. The paragraph above already
says Meta and TikTok, so this is the concrete version of that.

Only you have the budget and creative counts. If you would rather not publish a
daily budget - plenty of shops do not - the honest move is to cut the sentence
entirely rather than leave it vague. Say the word and I will remove it.

Answer:

---

## Already filled

Nothing to do here - kept as a record of where each value came from.

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

The two case-study figures come from the public `/products.json` feed at
hashofet.com. They are derived from `published_at`, which moves if a product is
unpublished and republished, so correct them if the real dates differ. The same
feed reports 366 products and 3,929 variants live today.

**The conformance level does not claim a certified standard, on purpose.** It
says the page was *built to* WCAG 2.1 AA and that only an internal check has
been run. Upgrading that to a compliance claim needs a real audit by a licensed
accessibility expert; a wrong claim there is worse than an honest gap.

## Not on this sheet

The four venture screenshots under `shots/` also have `.ph` fallback text, but
those are not values to write - they are the message shown if an image fails to
load. `.github/workflows/screenshots.yml` regenerates the images weekly.

`og.jpg` (1200x630) is still missing from the site root. It is not a
placeholder, so nothing on the page shows amber, but until it exists every
shared link previews as text with no image.
