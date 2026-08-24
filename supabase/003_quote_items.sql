-- =============================================================================
-- QUOTE CATALOGUE
--
-- Run once in the SQL editor. Safe to re-run: the seed only fires on an empty
-- table.
--
-- Replaces fixed package pricing with line items, so a quote can describe the
-- actual scope of a build instead of picking one of three numbers.
--
-- IMPORTANT ABOUT PRICES
-- Every seeded price is 0 except the five figures that were given directly:
-- extra product 50, extra creative 250, extra support week 800, migration 1500,
-- monthly retainer 2000. Everything else is deliberately unpriced, because
-- inventing a number for it would put a figure in front of a client that nobody
-- decided. Price them in the dashboard under מחירון before quoting.
--
-- unit values, used only for the label next to the quantity:
--   unit     a single thing
--   page     per page
--   product  per product
--   week     per week
--   month    per month
--   hour     per hour
-- =============================================================================

create table if not exists public.quote_items (
  id         uuid primary key default gen_random_uuid(),
  position   int  not null default 0,
  category   text not null default '',
  name       text not null default '',
  note       text not null default '',
  price      numeric(10,2) not null default 0,
  unit       text not null default 'unit',
  active     boolean not null default true,
  created_at timestamptz not null default now()
);

create index if not exists quote_items_pos_idx on public.quote_items (position);

alter table public.quote_items enable row level security;

drop policy if exists quote_items_admin_all on public.quote_items;
create policy quote_items_admin_all on public.quote_items
  for all to authenticated
  using (public.is_admin()) with check (public.is_admin());

insert into public.quote_items (position, category, name, note, price, unit)
select * from (values

  -- אפיון
  (10,  'אפיון', 'שיחת אפיון ומיפוי צרכים', '', 0, 'unit'),
  (11,  'אפיון', 'מפת אתר ומבנה עמודים', '', 0, 'unit'),
  (12,  'אפיון', 'אפיון מסע לקוח ומשפך המרה', '', 0, 'unit'),
  (13,  'אפיון', 'מחקר מתחרים', '', 0, 'unit'),

  -- עיצוב
  (20,  'עיצוב', 'עיצוב דף בית', '', 0, 'unit'),
  (21,  'עיצוב', 'עיצוב עמוד פנימי', 'לכל עמוד נוסף', 0, 'page'),
  (22,  'עיצוב', 'עיצוב דף מוצר', '', 0, 'unit'),
  (23,  'עיצוב', 'התאמת עיצוב למובייל', '', 0, 'unit'),
  (24,  'עיצוב', 'ספריית רכיבים ומערכת עיצוב', 'למותגים עם הרבה עמודים', 0, 'unit'),
  (25,  'עיצוב', 'עיצוב מותג: לוגו, צבעים, טיפוגרפיה', '', 0, 'unit'),
  (26,  'עיצוב', 'באנרים ותמונות ראשיות', '', 0, 'unit'),

  -- תוכן
  (30,  'תוכן', 'כתיבת תוכן שיווקי לעמוד', '', 0, 'page'),
  (31,  'תוכן', 'כתיבת תיאורי מוצר', '', 0, 'product'),
  (32,  'תוכן', 'צילומי מוצר', '', 0, 'unit'),
  (33,  'תוכן', 'עריכת תמונות והסרת רקע', '', 0, 'product'),
  (34,  'תוכן', 'תרגום לשפה נוספת', '', 0, 'page'),

  -- בנייה
  (40,  'בנייה', 'הקמת אתר או חנות, בסיס', 'תשתית, ניווט, עמודי ליבה', 0, 'unit'),
  (41,  'בנייה', 'העלאת מוצרים וקטגוריות', 'עד 15 מוצרים כלול בבסיס', 0, 'product'),
  (42,  'בנייה', 'מוצר מעבר ל־15', '', 50, 'product'),
  (43,  'בנייה', 'דף מוצר מותאם', '', 0, 'unit'),
  (44,  'בנייה', 'עגלה ותהליך תשלום', '', 0, 'unit'),
  (45,  'בנייה', 'טפסים ואיסוף לידים', '', 0, 'unit'),
  (46,  'בנייה', 'בלוג או מרכז מאמרים', '', 0, 'unit'),
  (47,  'בנייה', 'חיפוש ופילטרים מתקדמים', '', 0, 'unit'),
  (48,  'בנייה', 'אזור אישי והתחברות משתמשים', '', 0, 'unit'),
  (49,  'בנייה', 'ריבוי שפות', '', 0, 'unit'),
  (50,  'בנייה', 'ריבוי מטבעות', '', 0, 'unit'),
  (51,  'בנייה', 'מערכות להגדלת סל: מכירה נוספת ומשלימה', '', 0, 'unit'),
  (52,  'בנייה', 'העברה מוויקס או ווקומרס', '', 1500, 'unit'),

  -- פיתוח
  (60,  'פיתוח', 'רכיב מותאם אישית בקוד', 'מה שהתבניות לא יודעות לעשות', 0, 'unit'),
  (61,  'פיתוח', 'לוגיקה עסקית או מחשבון', '', 0, 'unit'),
  (62,  'פיתוח', 'בסיס נתונים ומודל נתונים', '', 0, 'unit'),
  (63,  'פיתוח', 'ממשק ניהול לצוות', '', 0, 'unit'),
  (64,  'פיתוח', 'חיבור למערכת חיצונית דרך API', '', 0, 'unit'),
  (65,  'פיתוח', 'אוטומציות ותהליכים מתוזמנים', '', 0, 'unit'),
  (66,  'פיתוח', 'שעת פיתוח נוספת', 'לשינויים מחוץ להצעה', 0, 'hour'),

  -- אינטגרציות
  (70,  'אינטגרציות', 'חיבור סליקה', '', 0, 'unit'),
  (71,  'אינטגרציות', 'חיבור מערכת חשבוניות', '', 0, 'unit'),
  (72,  'אינטגרציות', 'חיבור חברות משלוחים', '', 0, 'unit'),
  (73,  'אינטגרציות', 'חיבור מערכת דיוור', '', 0, 'unit'),
  (74,  'אינטגרציות', 'וואטסאפ או צאט באתר', '', 0, 'unit'),
  (75,  'אינטגרציות', 'חיבור מערכת ניהול לקוחות', '', 0, 'unit'),
  (76,  'אינטגרציות', 'חיבור מערכת מלאי', '', 0, 'unit'),

  -- ביצועים
  (80,  'ביצועים', 'אופטימיזציית מהירות טעינה', '', 0, 'unit'),
  (81,  'ביצועים', 'התאמות נגישות והצהרת נגישות', '', 0, 'unit'),
  (82,  'ביצועים', 'בדיקות דפדפנים ומכשירים', '', 0, 'unit'),

  -- קידום ומדידה
  (90,  'קידום ומדידה', 'הגדרות טכניות לקידום אורגני', '', 0, 'unit'),
  (91,  'קידום ומדידה', 'מפת אתר וקובץ רובוטס', '', 0, 'unit'),
  (92,  'קידום ומדידה', 'חיבור סרץ קונסול וגוגל אנליטיקס', '', 0, 'unit'),
  (93,  'קידום ומדידה', 'הקמת פיקסלים ומעקב המרות', '', 0, 'unit'),
  (94,  'קידום ומדידה', 'קריאטיב לפרסום', '', 250, 'unit'),
  (95,  'קידום ומדידה', 'העלאת קמפיין ראשון', '', 0, 'unit'),

  -- השקה
  (100, 'השקה', 'חיבור דומיין והגדרות רשומות', '', 0, 'unit'),
  (101, 'השקה', 'אחסון והעלאה לאוויר', '', 0, 'unit'),
  (102, 'השקה', 'הגדרת אימייל עסקי', '', 0, 'unit'),
  (103, 'השקה', 'תעודת אבטחה וגיבויים', '', 0, 'unit'),
  (104, 'השקה', 'בדיקות לפני עלייה לאוויר', '', 0, 'unit'),

  -- אחרי העלייה
  (110, 'אחרי העלייה', 'שיחת העברה והדרכה', '', 0, 'unit'),
  (111, 'אחרי העלייה', 'שבוע ליווי נוסף', '', 800, 'week'),
  (112, 'אחרי העלייה', 'ריטיינר חודשי', 'מינימום 3 חודשים', 2000, 'month')

) as seed(position, category, name, note, price, unit)
where not exists (select 1 from public.quote_items);
