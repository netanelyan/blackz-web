# Fill-in sheet

Five values on the live site are still unwritten, all of them in `index.html`.
Each one renders inside a dashed amber outline, so an unfilled value is visible
to every visitor rather than shipping as a silent blank.

Write your answer on the `Answer:` line of each item below, then hand the file
back and the values get pasted into the page. Or paste them straight into the
HTML yourself: search the file for the quoted `[[FILL: ...]]` string, and
replace the whole `<span class="ph">...</span>` element - including the
`<span>` tags - with the plain text. Leaving the `<span class="ph">` in place
keeps the amber outline on a value that is no longer a placeholder.

**Answers are page copy, so write them in Hebrew.** Wrap bare numerals in
`<span class="num">` the way the surrounding lines already do.

Skip anything you do not have. An honest amber gap is better than a number that
is not true; that is the whole reason these are marked instead of guessed.

Ten values that used to be on this sheet are now written - see
[Already filled](#already-filled) at the bottom.

---

## Price

Both entries are the same number. They are listed separately only because they
live in two places in the file.

### 1. Starting price - hero

Search: `[[FILL: מחיר התחלתי]]` (first of two occurrences)
Renders as: `פרויקטים מתחילים ב־___ ₪ + מע״מ.`

The number only. No currency sign, no `+ מע״מ` - the page already prints both
around it.

Answer:

---

### 2. Starting price - services section

Search: `[[FILL: מחיר התחלתי]]` (second of two occurrences)
Renders as: `מתחילים מ־ ___ ₪ + מע״מ`

**The same number as item 1.** Change both together or the page contradicts
itself.

Answer:

---

## Case study - חנות השופט

### 3. Campaign detail - step 03

Search: `[[FILL: פירוט הקמפיינים`
Renders as: `ערוצים, תקציב יומי והיקף הקריאטיבים: ___.`

Channels, daily budget and how many creatives ran. The paragraph above already
says Meta and TikTok, so this is the concrete version of that.

Only you have the budget and creative counts. If you would rather not publish a
daily budget - plenty of shops do not - the honest move is to cut the sentence
entirely rather than leave it vague. Say the word and I will remove it.

Answer:

---

### 4. Project duration - step 04

Search: `[[FILL: משך הפרויקט]]`
Renders as: `מהתחלה ועד העלייה לאוויר: ___.`

From kickoff to launch. Weeks or months.

Worth getting right, because the terms section a few screens down commits to
`4 שבועות להקמת חנות`. If your own store took noticeably longer than four
weeks, a visitor will notice the gap and read it as the real timeline. Either
number is fine to publish - they just have to be reconcilable.

Answer:

---

### 5. Outcome metric - step 04

Search: `[[FILL: מדד תוצאה`
Renders as: `מאז ועד היום: ___.`

**Decided: an order count or sales volume**, rather than a conversion rate or
the catalogue-growth figure. That is the strongest line in the case study and
the one a prospect will remember - it just needs the number, which only you
have.

Either shape works: a running total (`מעל 900 הזמנות`) or a period figure
(`ממוצע של 120 הזמנות בחודש`). A running total ages better, because it never
needs revisiting to stay true.

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
