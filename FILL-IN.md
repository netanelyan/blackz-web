# Fill-in sheet

Fifteen values on the live site are still unwritten. Each one renders inside a
dashed amber outline, so an unfilled value is visible to every visitor rather
than shipping as a silent blank.

Write your answer on the `Answer:` line of each item below, then hand the file
back and the values get pasted into the pages. Or paste them straight into the
HTML yourself: search the file for the quoted `[[FILL: ...]]` string, and
replace the whole `<span class="ph">...</span>` element - including the
`<span>` tags - with the plain text. Leaving the `<span class="ph">` in place
keeps the amber outline on a value that is no longer a placeholder.

**Answers are page copy, so write them in Hebrew.** Numbers, dates and prices
included - `3,500`, `כ־120`, `אוגוסט 2025`.

Skip anything you do not have. An honest amber gap is better than a number that
is not true; that is the whole reason these are marked instead of guessed.

---

## index.html - the public site

### 1. Starting price - hero

Search: `[[FILL: מחיר התחלתי]]` (first of two occurrences)
Renders as: `פרויקטים מתחילים ב־___ ₪ + מע״מ.`

The number only. No currency sign, no `+ מע״מ` - the page already prints both
around it. **This is the same number as item 8; change the two together or the
page contradicts itself.**

Answer:

---

### 2. The "before" state - case study, step 01

Search: `[[FILL: מה היה קיים לפני`
Renders as: `נקודת הפתיחה: ___.`

What existed before the store went up - an old shop, Instagram only, or no
presence at all. A short phrase, not a sentence; the paragraph continues after it.

Answer:

---

### 3. Catalogue size at launch - case study, step 02

Search: `[[FILL: מספר מוצרים בחנות]]`
Renders as: `היקף הקטלוג בהעלייה לאוויר: ___.`

How many products were live on launch day. An approximation is fine
(`כ־250 מוצרים`) as long as it is real.

Answer:

---

### 4. Campaign detail - case study, step 03

Search: `[[FILL: פירוט הקמפיינים`
Renders as: `ערוצים, תקציב יומי והיקף הקריאטיבים: ___.`

Channels, daily budget and how many creatives ran. The paragraph above already
says Meta and TikTok, so this is the concrete version of that.

Answer:

---

### 5. Launch date - case study, step 04

Search: `[[FILL: תאריך העלייה לאוויר]]`
Renders as: `עלתה לאוויר: ___.`

Month and year is enough.

Answer:

---

### 6. Project duration - case study, step 04

Search: `[[FILL: משך הפרויקט]]`
Renders as: `מהתחלה ועד העלייה לאוויר: ___.`

From kickoff to launch. Weeks or months.

Answer:

---

### 7. Outcome metric - case study, step 04

Search: `[[FILL: מדד תוצאה`
Renders as: `מאז ועד היום: ___.`

One number that shows the store works: order count, sales volume or conversion
rate. Pick whichever you are willing to stand behind in public - this is the
line a prospect will remember.

Answer:

---

### 8. Starting price - services section

Search: `[[FILL: מחיר התחלתי]]` (second of two occurrences)
Renders as: `מתחילים מ־ ___ ₪ + מע״מ`

**The same number as item 1.**

Answer:

---

### 9. Cancellation notice period - business and terms

Search: `[[FILL: תקופת הודעה מוקדמת לביטול]]`
Renders as: `תקופת ההודעה המוקדמת: ___.`

How much written notice either side gives before stopping work. This is a
contractual term that people will hold you to, so write what you actually
intend to honour.

Answer:

---

### 10. What happens to the advance on cancellation - business and terms

Search: `[[FILL: מה קורה למקדמה בביטול]]`
Renders as: `דין המקדמה במקרה של ביטול: ___.`

Refundable, non-refundable, or offset against work already done. Same caveat as
item 9.

Answer:

---

## accessibility.html - the accessibility statement

All five below are legal declarations under the Israeli accessibility
regulations, so each has to be accurate. In particular: **do not state a
conformance level that has not actually been audited.** A wrong claim is worse
than an honest gap.

### 11. Conformance level and standard

Search: `[[FILL: רמת ההנגשה והתקן שלפיו נבדק]]`
Renders as: `רמת ההנגשה של האתר: ___.`

The level reached and the standard it was tested against - for example
WCAG 2.1 AA and Israeli standard 5568. Only if a test was really run.

Answer:

---

### 12. Known limitations

Search: `[[FILL: מגבלות ידועות`
Renders as: `חלקים שטרם הונגשו במלואם: ___.`

Parts of the site that are not yet fully accessible. If there are none you know
of, the honest answer is `לא ידוע על חלקים כאלה`.

Answer:

---

### 13. Accessibility coordinator name

Search: `[[FILL: שם רכז הנגישות]]`
Renders as the `רכז הנגישות:` row.

A named person who receives accessibility complaints.

Answer:

---

### 14. Accessibility contact phone

Search: `[[FILL: טלפון לפניות בנושא נגישות]]`
Renders as the `טלפון:` row.

The email in the row beneath it is filled automatically from the `BLACKZ`
config object, so only the phone number is needed here.

Answer:

---

### 15. Statement date

Search: `[[FILL: תאריך עדכון ההצהרה]]`
Renders as: `תאריך עדכון ההצהרה: ___.`

The date the statement was last reviewed. Update it whenever items 11-14
change.

Answer:

---

## Already filled, for reference

The registered holder, trade name, Osek Murshe number and business address were
filled on 2026-08-29 from the Osek Murshe certificate, and are no longer
placeholders. `osek-murshe.pdf` in the repo root is the source.

## Not on this sheet

The four venture screenshots under `shots/` also have `.ph` fallback text, but
those are not values to write - they are the message shown if an image fails to
load. `.github/workflows/screenshots.yml` regenerates the images weekly.
