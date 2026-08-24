-- =============================================================================
-- PRICES
--
-- Run once in the SQL editor. Idempotent: re-running just rewrites the same
-- values.
--
-- Generated from docs/pricing.md. Six items were marked כלול rather than given
-- a number, meaning they are always part of the base price. Those get a new
-- default_included flag instead of a price of 0, because a zero would make the
-- quote warn about an unpriced item on every single quote.
-- =============================================================================

alter table public.quote_items
  add column if not exists default_included boolean not null default false;

-- ---- always part of the base price ----
update public.quote_items set price = 0, default_included = true where position = 23;  -- התאמת עיצוב למובייל
update public.quote_items set price = 0, default_included = true where position = 41;  -- העלאת מוצרים וקטגוריות
update public.quote_items set price = 0, default_included = true where position = 82;  -- בדיקות דפדפנים ומכשירים
update public.quote_items set price = 0, default_included = true where position = 91;  -- מפת אתר וקובץ רובוטס
update public.quote_items set price = 0, default_included = true where position = 104;  -- בדיקות לפני עלייה לאוויר
update public.quote_items set price = 0, default_included = true where position = 110;  -- שיחת העברה והדרכה

-- ---- priced items ----
update public.quote_items set price = 750, default_included = false where position = 10;  -- שיחת אפיון ומיפוי צרכים
update public.quote_items set price = 450, default_included = false where position = 11;  -- מפת אתר ומבנה עמודים
update public.quote_items set price = 650, default_included = false where position = 12;  -- אפיון מסע לקוח ומשפך המרה
update public.quote_items set price = 450, default_included = false where position = 13;  -- מחקר מתחרים
update public.quote_items set price = 1400, default_included = false where position = 20;  -- עיצוב דף בית
update public.quote_items set price = 450, default_included = false where position = 21;  -- עיצוב עמוד פנימי
update public.quote_items set price = 750, default_included = false where position = 22;  -- עיצוב דף מוצר
update public.quote_items set price = 1500, default_included = false where position = 24;  -- ספריית רכיבים ומערכת עיצוב
update public.quote_items set price = 1800, default_included = false where position = 25;  -- עיצוב מותג: לוגו, צבעים, טיפוגרפיה
update public.quote_items set price = 350, default_included = false where position = 26;  -- באנרים ותמונות ראשיות
update public.quote_items set price = 450, default_included = false where position = 30;  -- כתיבת תוכן שיווקי לעמוד
update public.quote_items set price = 35, default_included = false where position = 31;  -- כתיבת תיאורי מוצר
update public.quote_items set price = 150, default_included = false where position = 32;  -- צילומי מוצר
update public.quote_items set price = 15, default_included = false where position = 33;  -- עריכת תמונות והסרת רקע
update public.quote_items set price = 350, default_included = false where position = 34;  -- תרגום לשפה נוספת
update public.quote_items set price = 2800, default_included = false where position = 40;  -- הקמת אתר או חנות, בסיס
update public.quote_items set price = 50, default_included = false where position = 42;  -- מוצר מעבר ל־15
update public.quote_items set price = 900, default_included = false where position = 43;  -- דף מוצר מותאם
update public.quote_items set price = 700, default_included = false where position = 44;  -- עגלה ותהליך תשלום
update public.quote_items set price = 400, default_included = false where position = 45;  -- טפסים ואיסוף לידים
update public.quote_items set price = 800, default_included = false where position = 46;  -- בלוג או מרכז מאמרים
update public.quote_items set price = 1200, default_included = false where position = 47;  -- חיפוש ופילטרים מתקדמים
update public.quote_items set price = 2500, default_included = false where position = 48;  -- אזור אישי והתחברות משתמשים
update public.quote_items set price = 1500, default_included = false where position = 49;  -- ריבוי שפות
update public.quote_items set price = 500, default_included = false where position = 50;  -- ריבוי מטבעות
update public.quote_items set price = 700, default_included = false where position = 51;  -- מערכות להגדלת סל: מכירה נוספת ומשלימה
update public.quote_items set price = 1500, default_included = false where position = 52;  -- העברה מוויקס או ווקומרס
update public.quote_items set price = 1200, default_included = false where position = 60;  -- רכיב מותאם אישית בקוד
update public.quote_items set price = 2000, default_included = false where position = 61;  -- לוגיקה עסקית או מחשבון
update public.quote_items set price = 2500, default_included = false where position = 62;  -- בסיס נתונים ומודל נתונים
update public.quote_items set price = 3500, default_included = false where position = 63;  -- ממשק ניהול לצוות
update public.quote_items set price = 1800, default_included = false where position = 64;  -- חיבור למערכת חיצונית דרך API
update public.quote_items set price = 1200, default_included = false where position = 65;  -- אוטומציות ותהליכים מתוזמנים
update public.quote_items set price = 250, default_included = false where position = 66;  -- שעת פיתוח נוספת
update public.quote_items set price = 650, default_included = false where position = 70;  -- חיבור סליקה
update public.quote_items set price = 450, default_included = false where position = 71;  -- חיבור מערכת חשבוניות
update public.quote_items set price = 550, default_included = false where position = 72;  -- חיבור חברות משלוחים
update public.quote_items set price = 400, default_included = false where position = 73;  -- חיבור מערכת דיוור
update public.quote_items set price = 250, default_included = false where position = 74;  -- וואטסאפ או צאט באתר
update public.quote_items set price = 700, default_included = false where position = 75;  -- חיבור מערכת ניהול לקוחות
update public.quote_items set price = 900, default_included = false where position = 76;  -- חיבור מערכת מלאי
update public.quote_items set price = 800, default_included = false where position = 80;  -- אופטימיזציית מהירות טעינה
update public.quote_items set price = 1200, default_included = false where position = 81;  -- התאמות נגישות והצהרת נגישות
update public.quote_items set price = 700, default_included = false where position = 90;  -- הגדרות טכניות לקידום אורגני
update public.quote_items set price = 350, default_included = false where position = 92;  -- חיבור סרץ קונסול וגוגל אנליטיקס
update public.quote_items set price = 850, default_included = false where position = 93;  -- הקמת פיקסלים ומעקב המרות
update public.quote_items set price = 250, default_included = false where position = 94;  -- קריאטיב לפרסום
update public.quote_items set price = 1200, default_included = false where position = 95;  -- העלאת קמפיין ראשון
update public.quote_items set price = 350, default_included = false where position = 100;  -- חיבור דומיין והגדרות רשומות
update public.quote_items set price = 400, default_included = false where position = 101;  -- אחסון והעלאה לאוויר
update public.quote_items set price = 300, default_included = false where position = 102;  -- הגדרת אימייל עסקי
update public.quote_items set price = 300, default_included = false where position = 103;  -- תעודת אבטחה וגיבויים
update public.quote_items set price = 800, default_included = false where position = 111;  -- שבוע ליווי נוסף
update public.quote_items set price = 2000, default_included = false where position = 112;  -- ריטיינר חודשי
