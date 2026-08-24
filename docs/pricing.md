# Pricing - what needs filling in

Every item in the quote catalogue.

**60 items. 5 priced, 55 waiting.**

The five that have a price are the only figures ever given to me. Nothing was
invented for the rest, because a number nobody decided on can reach a client
without anyone noticing.

Item names are in Hebrew because that is exactly how they appear in the quote
the client receives.

## How to fill it

Two ways, same result:

1. **In the dashboard.** Quote tab -> מחירון button -> type -> save. Writes
   straight to the database.
2. **In this file.** Fill the price column and send it back, and I will write
   them all in one go.

Prices are before VAT. Leaving an item blank is fine, just do not select it
when building a quote.

> To retire an item entirely:
> `update public.quote_items set active = false where name = '...';`

---

## אפיון  (0/4)

| Item | Unit | Price |
|---|---|---|
| שיחת אפיון ומיפוי צרכים | each |  |
| מפת אתר ומבנה עמודים | each |  |
| אפיון מסע לקוח ומשפך המרה | each |  |
| מחקר מתחרים | each |  |

## עיצוב  (0/7)

| Item | Unit | Price |
|---|---|---|
| עיצוב דף בית | each |  |
| עיצוב עמוד פנימי <br><sub>לכל עמוד נוסף</sub> | per page |  |
| עיצוב דף מוצר | each |  |
| התאמת עיצוב למובייל | each |  |
| ספריית רכיבים ומערכת עיצוב <br><sub>למותגים עם הרבה עמודים</sub> | each |  |
| עיצוב מותג: לוגו, צבעים, טיפוגרפיה | each |  |
| באנרים ותמונות ראשיות | each |  |

## תוכן  (0/5)

| Item | Unit | Price |
|---|---|---|
| כתיבת תוכן שיווקי לעמוד | per page |  |
| כתיבת תיאורי מוצר | per product |  |
| צילומי מוצר | each |  |
| עריכת תמונות והסרת רקע | per product |  |
| תרגום לשפה נוספת | per page |  |

## בנייה  (2/13)

| Item | Unit | Price |
|---|---|---|
| הקמת אתר או חנות, בסיס <br><sub>תשתית, ניווט, עמודי ליבה</sub> | each |  |
| העלאת מוצרים וקטגוריות <br><sub>עד 15 מוצרים כלול בבסיס</sub> | per product |  |
| מוצר מעבר ל־15 | per product | **50** |
| דף מוצר מותאם | each |  |
| עגלה ותהליך תשלום | each |  |
| טפסים ואיסוף לידים | each |  |
| בלוג או מרכז מאמרים | each |  |
| חיפוש ופילטרים מתקדמים | each |  |
| אזור אישי והתחברות משתמשים | each |  |
| ריבוי שפות | each |  |
| ריבוי מטבעות | each |  |
| מערכות להגדלת סל: מכירה נוספת ומשלימה | each |  |
| העברה מוויקס או ווקומרס | each | **1,500** |

## פיתוח  (0/7)

| Item | Unit | Price |
|---|---|---|
| רכיב מותאם אישית בקוד <br><sub>מה שהתבניות לא יודעות לעשות</sub> | each |  |
| לוגיקה עסקית או מחשבון | each |  |
| בסיס נתונים ומודל נתונים | each |  |
| ממשק ניהול לצוות | each |  |
| חיבור למערכת חיצונית דרך API | each |  |
| אוטומציות ותהליכים מתוזמנים | each |  |
| שעת פיתוח נוספת <br><sub>לשינויים מחוץ להצעה</sub> | per hour |  |

## אינטגרציות  (0/7)

| Item | Unit | Price |
|---|---|---|
| חיבור סליקה | each |  |
| חיבור מערכת חשבוניות | each |  |
| חיבור חברות משלוחים | each |  |
| חיבור מערכת דיוור | each |  |
| וואטסאפ או צאט באתר | each |  |
| חיבור מערכת ניהול לקוחות | each |  |
| חיבור מערכת מלאי | each |  |

## ביצועים  (0/3)

| Item | Unit | Price |
|---|---|---|
| אופטימיזציית מהירות טעינה | each |  |
| התאמות נגישות והצהרת נגישות | each |  |
| בדיקות דפדפנים ומכשירים | each |  |

## קידום ומדידה  (1/6)

| Item | Unit | Price |
|---|---|---|
| הגדרות טכניות לקידום אורגני | each |  |
| מפת אתר וקובץ רובוטס | each |  |
| חיבור סרץ קונסול וגוגל אנליטיקס | each |  |
| הקמת פיקסלים ומעקב המרות | each |  |
| קריאטיב לפרסום | each | **250** |
| העלאת קמפיין ראשון | each |  |

## השקה  (0/5)

| Item | Unit | Price |
|---|---|---|
| חיבור דומיין והגדרות רשומות | each |  |
| אחסון והעלאה לאוויר | each |  |
| הגדרת אימייל עסקי | each |  |
| תעודת אבטחה וגיבויים | each |  |
| בדיקות לפני עלייה לאוויר | each |  |

## אחרי העלייה  (2/3)

| Item | Unit | Price |
|---|---|---|
| שיחת העברה והדרכה | each |  |
| שבוע ליווי נוסף | per week | **800** |
| ריטיינר חודשי <br><sub>מינימום 3 חודשים</sub> | per month | **2,000** |

---

## Worth deciding before you start

- What is **הקמת אתר או חנות, בסיס** worth? It appears in nearly every quote
  and everything else is priced relative to it.
- Is an internal page priced per page, or is there a bundle rate?
- Is there an hourly rate at all, or does everything close at a project price?
- Do all integrations cost the same, or does a payment gateway differ from a
  mailing list?
- What is included in the base versus charged separately? Accessibility is the
  usual argument.

Anything you consider part of the base price does not need a number here. Mark
it כלול on the item row when building the quote and it prints as included.
