/**
 * Builds og.jpg - the 1200x630 share-preview card at the site root.
 *
 * index.html points og:image and twitter:image at /og.jpg. Without the file,
 * every shared link previews as text with no image.
 *
 * The card is not hand-drawn. It is rendered from index.html's own assets, so
 * it cannot drift from the page: the two Arimo @font-face rules are lifted out
 * of the style block, the brand mark comes from logo.svg, and the colors are
 * the same token values as :root. Rebranding the page and re-running this
 * script rebrands the card.
 *
 * Run:
 *   npm install playwright
 *   npx playwright install chromium
 *   node scripts/og.js
 */

const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

const ROOT = path.join(__dirname, '..');
const OUT = path.join(ROOT, 'og.jpg');

const WIDTH = 1200;
const HEIGHT = 630;           // the size og:image:width / og:image:height declare

/* ------------------------------------------------------------------
   Design tokens. These mirror the :root block in index.html - keep the
   two in step, or the card stops looking like the page it links to.
   ------------------------------------------------------------------ */
const T = {
  bg:       '#0A0A0C',
  surface:  '#15151B',
  line:     '#262630',
  text:     '#F6F6F9',
  textDim:  '#ADADBD',
  accent:   '#B8F135',
  accentInk:'#0A0A0C',
  spot:     'rgba(184,241,53,.16)',
  spot2:    'rgba(184,241,53,.05)',
};

/* ------------------------------------------------------------------
   Card copy. Kept equal to the og:title / og:description meta tags, so
   the image and the text preview say the same thing.
   ------------------------------------------------------------------ */
const KICKER = 'אתרים · חנויות אונליין · פרסום ממומן';
const TITLE_A = 'בונים מותגים';
const TITLE_B = 'באינטרנט';
const SUB = 'חנויות ומוצרים דיגיטליים שאנחנו מריצים בעצמנו,\nואת אותו הדבר אנחנו בונים לכם.';
/* Bare numerals get .num, the same isolation the page uses - without it the
   digit sits at the edge of an RTL line and swaps sides. */
const CHIPS = [
  'בנייה מלאה מאפס',
  'קמפיין ראשון במטא ובטיקטוק',
  '<span class="num">4</span> שבועות',
];

/**
 * Lifts the embedded Arimo @font-face rules out of index.html.
 *
 * They carry the font as base64, so the card renders with the page's own
 * Hebrew face and needs no network. Two rules: the Hebrew subset and the
 * Latin one.
 */
function readFontFaces() {
  const html = fs.readFileSync(path.join(ROOT, 'index.html'), 'utf8');
  const faces = html.match(/@font-face\{[^}]*\}/g) || [];
  const arimo = faces.filter((f) => /font-family:'Arimo'/.test(f));
  if (arimo.length < 2) {
    throw new Error(
      'Expected two Arimo @font-face rules in index.html, found ' + arimo.length +
      '. The card would fall back to a system Hebrew face.'
    );
  }
  return arimo.join('\n');
}

/** The brand mark, as a data URI so the page has no file dependency. */
function readMark() {
  const svg = fs.readFileSync(path.join(ROOT, 'logo.svg'), 'utf8');
  return 'data:image/svg+xml;base64,' + Buffer.from(svg, 'utf8').toString('base64');
}

function buildHtml() {
  const domain = 'getblackz.com';
  const mark = readMark();

  return `<!doctype html>
<html lang="he" dir="rtl"><head><meta charset="utf-8">
<style>
${readFontFaces()}

*{margin:0;padding:0;box-sizing:border-box}

/* Bidi isolation, copied from index.html. Latin text and numerals that land
   at the edge of an RTL line render in the wrong order without it. */
.ltr{direction:ltr;unicode-bidi:isolate}
.num{direction:ltr;unicode-bidi:isolate;font-variant-numeric:tabular-nums}

html,body{width:${WIDTH}px;height:${HEIGHT}px}

body{
  background:${T.bg};
  color:${T.text};
  font-family:'Arimo',Arial,sans-serif;
  font-feature-settings:'kern' 1;
  -webkit-font-smoothing:antialiased;
  overflow:hidden;
  position:relative;
}

/* Everything decorative lives in here. It clips, because both the glow and
   the watermark hang off the edges - and in an RTL document, overflow past
   the inline-end edge grows the scroll area and shunts the whole card over. */
.deco{position:absolute;inset:0;overflow:hidden;pointer-events:none}

/* Brand glow, top-inline-start. Same two spot colors the hero uses. */
.spot{
  position:absolute;
  inset-inline-start:-160px;
  top:-260px;
  width:820px;
  height:820px;
  border-radius:50%;
  background:radial-gradient(circle,${T.spot} 0%,${T.spot2} 45%,transparent 70%);
  pointer-events:none;
}

/* Oversized mark on the inline-end side, the same watermark the hero runs.
   It is what fills the half of the card the RTL text leaves empty. */
.watermark{
  position:absolute;
  inset-inline-end:-70px;
  top:50%;
  transform:translateY(-50%);
  width:520px;
  height:auto;
  opacity:.07;
  pointer-events:none;
}

/* Hairline frame, so the card reads as a card on a white chat background */
.edge{
  position:absolute;
  inset:0;
  border:1px solid ${T.line};
  pointer-events:none;
}

/* The accent rule along the bottom edge */
.rule{
  position:absolute;
  inset-inline:0;
  bottom:0;
  height:6px;
  background:linear-gradient(to left,${T.accent},${T.accent} 38%,${T.line} 38%);
}

.card{
  position:relative;
  height:100%;
  padding:64px 72px 76px;
  display:flex;
  flex-direction:column;
}

/* ---------- Brand line ---------- */
.brand{display:flex;align-items:center;gap:18px}
.brand img{width:64px;height:auto;display:block}
.brand b{
  font-size:40px;
  font-weight:700;
  letter-spacing:-.03em;
}

.kicker{
  margin-top:34px;
  color:${T.accent};
  font-size:23px;
  font-weight:600;
  letter-spacing:.16em;
}

h1{
  margin-top:20px;
  font-size:88px;
  font-weight:700;
  line-height:1.1;
  letter-spacing:-.03em;
}
h1 span{color:${T.accent}}

.sub{
  margin-top:24px;
  color:${T.textDim};
  font-size:29px;
  line-height:1.45;
  white-space:pre-line;
  max-width:44ch;
}

/* ---------- Footer ---------- */
.foot{
  margin-top:auto;
  display:flex;
  align-items:center;
  justify-content:space-between;
  gap:24px;
}

.chips{display:flex;gap:12px;list-style:none}
.chips li{
  background:${T.surface};
  border:1px solid ${T.line};
  border-radius:999px;
  padding:11px 20px;
  font-size:21px;
  color:${T.textDim};
  white-space:nowrap;
}

.domain{
  direction:ltr;
  unicode-bidi:isolate;
  font-size:26px;
  font-weight:700;
  color:${T.accentInk};
  background:${T.accent};
  border-radius:999px;
  padding:11px 22px;
  white-space:nowrap;
}
</style></head>
<body>
  <div class="deco">
    <div class="spot"></div>
    <img class="watermark" src="${mark}" alt="">
  </div>

  <div class="card">
    <div class="brand">
      <img src="${mark}" alt="">
      <b>בלאקזי</b>
    </div>

    <p class="kicker">${KICKER}</p>

    <h1>${TITLE_A}<br><span>${TITLE_B}</span></h1>

    <p class="sub">${SUB}</p>

    <div class="foot">
      <ul class="chips">${CHIPS.map((c) => '<li>' + c + '</li>').join('')}</ul>
      <span class="domain">${domain}</span>
    </div>
  </div>

  <div class="rule"></div>
  <div class="edge"></div>
</body></html>`;
}

async function main() {
  const browser = await chromium.launch();
  const page = await browser.newPage({
    viewport: { width: WIDTH, height: HEIGHT },
    deviceScaleFactor: 2,     // render at 2x, then downscale - crisper Hebrew
    locale: 'he-IL',
  });

  await page.setContent(buildHtml(), { waitUntil: 'load' });
  await page.evaluate(() => document.fonts.ready);
  await page.waitForTimeout(300);

  const shot = await page.screenshot({ type: 'png' });

  /* Screenshot at 2x, then resize back to the declared 1200x630. Chromium
     has no downscale-on-save, so the resize happens in a second page. */
  const resizer = await browser.newPage({ viewport: { width: WIDTH, height: HEIGHT } });
  await resizer.setContent(
    '<style>*{margin:0}body{width:' + WIDTH + 'px;height:' + HEIGHT + 'px;overflow:hidden}' +
    'img{width:' + WIDTH + 'px;height:' + HEIGHT + 'px;display:block}</style>' +
    '<img src="data:image/png;base64,' + shot.toString('base64') + '">',
    { waitUntil: 'load' }
  );
  await resizer.screenshot({ path: OUT, type: 'jpeg', quality: 90 });

  await browser.close();

  const kb = Math.round(fs.statSync(OUT).size / 1024);
  console.log('Wrote og.jpg  ' + WIDTH + 'x' + HEIGHT + '  ' + kb + ' KB');
}

/* Exported so the card can be opened in a browser and inspected without
   rendering it. Only runs the capture when invoked directly. */
module.exports = { buildHtml, WIDTH, HEIGHT };

if (require.main === module) main();
