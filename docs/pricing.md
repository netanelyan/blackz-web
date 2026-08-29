# Pricing

The live quote catalogue. **54 items: 48 priced, 6 always included.**

> **This snapshot has drifted from the live catalogue.** On 2026-08-29 the
> dashboard was showing lower prices than several rows below: the site/store
> base at 1,800 rather than 2,800, product page design at 400 rather than 750,
> the component library at 1,000 rather than 1,500, brand design at 1,400
> rather than 1,800, and banners at 250 rather than 350. Those were read off a
> partial view of the dashboard, so the rest of the file has not been checked
> and nothing here was edited to match. The database is the source of truth.
> Resync this file from the dashboard when there is a moment.

Item names are Hebrew because that is exactly how they print on the quote the
client receives.

## Changing a price

Dashboard -> Quote tab -> מחירון -> type -> save. That writes straight to the
database and is the source of truth. This file is a snapshot for reading away
from the dashboard, so update it here too if you want it to stay accurate.

**כלול** means the item is always part of the base price. It prints on the quote
as included, adds nothing to the total, and is marked automatically. In the
database that is the `default_included` flag, not a price of 0, so it never
triggers the unpriced warning.

> To retire an item: `update public.quote_items set active = false where position = NN;`

The content category (writing, product photography, image editing, translation)
was removed. On the live database those rows still exist with `active = false`,
so they can come back with `update public.quote_items set active = true where
position between 30 and 34;`.

On a database built fresh from `003_quote_items.sql` they never exist at all:
the seed no longer creates them, which makes `004`'s deactivate a no-op there.
Rebuilding from scratch and wanting them back means adding the rows by hand.

---

## אפיון

| Item | Unit | Price |
|---|---|---|
| שיחת אפיון ומיפוי צרכים | each | **750** |
| מפת אתר ומבנה עמודים | each | **450** |
| אפיון מסע לקוח ומשפך המרה | each | **650** |
| מחקר מתחרים | each | **450** |

## עיצוב

| Item | Unit | Price |
|---|---|---|
| עיצוב דף בית | each | **1,400** |
| עיצוב עמוד פנימי <br><sub>לכל עמוד נוסף</sub> | per page | **450** |
| ~~עיצוב דף מוצר~~ <br><sub>retired by `007`, merged into דף מוצר מותאם</sub> | - | - |
| התאמת עיצוב למובייל | each | **כלול** |
| ספריית רכיבים ומערכת עיצוב <br><sub>למותגים עם הרבה עמודים</sub> | each | **1,500** |
| עיצוב מותג: לוגו, צבעים, טיפוגרפיה | each | **1,800** |
| באנרים ותמונות ראשיות | each | **350** |

## בנייה

| Item | Unit | Price |
|---|---|---|
| הקמת אתר או חנות, בסיס <br><sub>תשתית, ניווט, עמודי ליבה</sub> | each | **2,800** |
| העלאת מוצרים וקטגוריות <br><sub>עד 15 מוצרים כלול בבסיס</sub> | per product | **כלול** |
| מוצר מעבר ל־15 | per product | **50** |
| דף מוצר מותאם <br><sub>עיצוב ובנייה של דף המוצר</sub> | each | **900** |
| עגלה ותהליך תשלום | each | **700** |
| טפסים ואיסוף לידים | each | **400** |
| בלוג או מרכז מאמרים | each | **800** |
| חיפוש ופילטרים מתקדמים | each | **1,200** |
| אזור אישי והתחברות משתמשים | each | **2,500** |
| ריבוי שפות | each | **1,500** |
| ריבוי מטבעות | each | **500** |
| מערכות להגדלת סל: מכירה נוספת ומשלימה | each | **700** |
| העברה מוויקס או ווקומרס | each | **1,500** |

## פיתוח

| Item | Unit | Price |
|---|---|---|
| רכיב מותאם אישית בקוד <br><sub>מה שהתבניות לא יודעות לעשות</sub> | each | **1,200** |
| לוגיקה עסקית או מחשבון | each | **2,000** |
| בסיס נתונים ומודל נתונים | each | **2,500** |
| ממשק ניהול לצוות | each | **3,500** |
| חיבור למערכת חיצונית דרך API | each | **1,800** |
| אוטומציות ותהליכים מתוזמנים | each | **1,200** |
| שעת פיתוח נוספת <br><sub>לשינויים מחוץ להצעה</sub> | per hour | **250** |

## אינטגרציות

| Item | Unit | Price |
|---|---|---|
| חיבור סליקה | each | **650** |
| חיבור מערכת חשבוניות | each | **450** |
| חיבור חברות משלוחים | each | **550** |
| חיבור מערכת דיוור | each | **400** |
| וואטסאפ או צאט באתר | each | **250** |
| חיבור מערכת ניהול לקוחות | each | **700** |
| חיבור מערכת מלאי | each | **900** |

## ביצועים

| Item | Unit | Price |
|---|---|---|
| אופטימיזציית מהירות טעינה | each | **800** |
| התאמות נגישות והצהרת נגישות | each | **1,200** |
| בדיקות דפדפנים ומכשירים | each | **כלול** |

## קידום ומדידה

| Item | Unit | Price |
|---|---|---|
| הגדרות טכניות לקידום אורגני | each | **700** |
| מפת אתר וקובץ רובוטס | each | **כלול** |
| חיבור סרץ קונסול וגוגל אנליטיקס | each | **350** |
| הקמת פיקסלים ומעקב המרות | each | **850** |
| קריאטיב לפרסום | each | **250** |
| העלאת קמפיין ראשון | each | **1,200** |

## השקה

| Item | Unit | Price |
|---|---|---|
| חיבור דומיין והגדרות רשומות | each | **350** |
| אחסון והעלאה לאוויר | each | **400** |
| הגדרת אימייל עסקי | each | **300** |
| תעודת אבטחה וגיבויים | each | **300** |
| בדיקות לפני עלייה לאוויר | each | **כלול** |

## אחרי העלייה

| Item | Unit | Price |
|---|---|---|
| שיחת העברה והדרכה | each | **כלול** |
| שבוע ליווי נוסף | per week | **800** |
| ריטיינר חודשי <br><sub>מינימום 3 חודשים</sub> | per month | **2,000** |
