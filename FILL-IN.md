# Fill-in sheet

Eight values on the live site are still unwritten, all of them in `index.html`.
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

Seven values that used to be on this sheet are now filled - see
[Already filled](#already-filled) at the bottom.

---

## Price

### 1. Starting price - hero

Search: `[[FILL: מחיר התחלתי]]` (first of two occurrences)
Renders as: `פרויקטים מתחילים ב־___ ₪ + מע״מ.`

The number only. No currency sign, no `+ מע״מ` - the page already prints both
around it. **This is the same number as item 2; change the two together or the
page contradicts itself.**

Answer:

---

### 2. Starting price - services section

Search: `[[FILL: מחיר התחלתי]]` (second of two occurrences)
Renders as: `מתחילים מ־ ___ ₪ + מע״מ`

**The same number as item 1.**

Answer:

---

## Case study - חנות השופט

### 3. The "before" state - step 01

Search: `[[FILL: מה היה קיים לפני`
Renders as: `נקודת הפתיחה: ___.`

What existed before the store went up - an old shop, Instagram only, or no
presence at all. A short phrase, not a sentence; the paragraph continues after it.

Since חנות השופט is your own venture and not a client's, the likely honest
answer is that there was nothing to begin with. Something like
`אפס נוכחות - המותג נבנה מאפס` fits, if that is in fact what happened. Confirm
it rather than take my word for it: if the Instagram account or a previous shop
predates the store, say so instead.

Answer:

---

### 4. Campaign detail - step 03

Search: `[[FILL: פירוט הקמפיינים`
Renders as: `ערוצים, תקציב יומי והיקף הקריאטיבים: ___.`

Channels, daily budget and how many creatives ran. The paragraph above already
says Meta and TikTok, so this is the concrete version of that.

Only you have the budget and creative counts. If you would rather not publish a
daily budget - plenty of shops do not - the honest move is to cut the sentence
entirely rather than leave it vague.

Answer:

---

### 5. Project duration - step 04

Search: `[[FILL: משך הפרויקט]]`
Renders as: `מהתחלה ועד העלייה לאוויר: ___.`

From kickoff to launch. Weeks or months.

Worth getting right, because the terms section a few screens down commits to
`4 שבועות להקמת חנות`. If your own store took noticeably longer than four
weeks, a visitor will notice the gap and read it as the real timeline. Either
number is fine to publish - they just have to be reconcilable.

Answer:

---

### 6. Outcome metric - step 04

Search: `[[FILL: מדד תוצאה`
Renders as: `מאז ועד היום: ___.`

One number that shows the store works: order count, sales volume or conversion
rate. This is the line a prospect will remember, so pick one you are willing to
stand behind in public.

If you would rather not publish revenue or order counts, there is a real
alternative already sitting in the store: the catalogue grew from 60 products
at launch to 366 products and 3,929 variants today. That is verifiable from the
storefront, which a sales figure is not - but it measures effort rather than
results, so it is the weaker claim. Your call.

Answer:

---

## Contract terms

Both of these are commitments a client can hold you to. Write what you actually
intend to honour, not what sounds generous.

### 7. Cancellation notice period

Search: `[[FILL: תקופת הודעה מוקדמת לביטול]]`
Renders as: `תקופת ההודעה המוקדמת: ___.`

How much written notice either side gives before stopping work.

`14 יום` is the common default for a project of this size, and it lines up with
the 4-week build the terms already promise - long enough to wind down a stage,
short enough that neither side is trapped. `7 ימים` is defensible on a shorter
engagement.

Answer:

---

### 8. What happens to the advance on cancellation

Search: `[[FILL: מה קורה למקדמה בביטול]]`
Renders as: `דין המקדמה במקרה של ביטול: ___.`

Refundable, non-refundable, or offset against work already done.

Offsetting is the fairest of the three and the easiest to defend if it is ever
argued: the advance covers work performed up to the cancellation date, and
anything beyond it is returned. A flatly non-refundable advance is legal but
reads badly right next to the sentence that follows it, which promises that
whatever was built and paid for stays yours.

Answer:

---

## Already filled

Nothing to do here - kept as a record of where each value came from.

| Value | Filled with | Source |
|---|---|---|
| Registered holder, trade name, Osek Murshe number, address | - | `osek-murshe.pdf`, on 2026-08-29 |
| Catalogue size at launch | `כ־60 מוצרים` | 60 products first published across 2024-07-02 and 2024-07-03 |
| Launch date | `יולי 2024` | same feed, earliest publish cluster |
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
