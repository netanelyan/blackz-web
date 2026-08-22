/**
 * Automatic screenshots of the ventures.
 *
 * Runs weekly in GitHub Actions (see .github/workflows/screenshots.yml),
 * captures the four sites and writes them to shots/, so the browser windows
 * on the page always show the current version of each site.
 *
 * Run locally:
 *   npm install playwright
 *   npx playwright install chromium
 *   node scripts/shoot.js
 */

const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

/* ------------------------------------------------------------------
   [Add or remove ventures here]
   file = the filename used in the <img> src in index.html
   hide = extra selectors to hide before the shot (optional)
   ------------------------------------------------------------------ */
const SITES = [
  { file: 'hashofet.jpg',    url: 'https://hashofet.com',    hide: [] },
  { file: 'clutchstore.jpg', url: 'https://clutchstore.net', hide: [] },
  { file: 'tiyulplus.jpg',   url: 'https://tiyulplus.com',   hide: [] },
  { file: 'brickdealil.jpg', url: 'https://brickdealil.com', hide: [] },
];

const WIDTH = 1600;
const HEIGHT = 1000;          // 16:10 - matches the portal aspect-ratio on the page
const OUT_DIR = path.join(__dirname, '..', 'shots');

/* Common popup patterns on Shopify stores and Israeli sites.
   Hidden on every site before the shot is taken. */
const COMMON_POPUPS = [
  '[role="dialog"]',
  '.modal, .Modal, .popup, .Popup',
  '#shopify-section-popup, .shopify-section--popup',
  '.klaviyo-form, .needsclick[class*="kl-"]',
  '[id*="privy"], [class*="privy"]',
  '[class*="newsletter-popup"], [class*="cookie"], [id*="cookie"]',
  '[class*="accessibility"], [id*="accessibility"]',
];

async function shoot(context, site) {
  const page = await context.newPage();
  try {
    await page.goto(site.url, { waitUntil: 'load', timeout: 60000 });

    /* Let images and fonts settle, without hanging on third-party scripts */
    await page.waitForLoadState('networkidle', { timeout: 20000 }).catch(() => {});

    /* Short scroll down and back - triggers lazy-loading above the fold */
    await page.evaluate(() => window.scrollTo(0, 600));
    await page.waitForTimeout(1200);
    await page.evaluate(() => window.scrollTo(0, 0));
    await page.waitForTimeout(800);

    /* Dismiss popups: Escape first, then hide them outright via CSS */
    await page.keyboard.press('Escape').catch(() => {});
    const selectors = COMMON_POPUPS.concat(site.hide || []);
    await page.addStyleTag({
      content: selectors.join(',') + '{display:none !important;visibility:hidden !important}',
    }).catch(() => {});

    /* Freeze animations so the capture is stable */
    await page.addStyleTag({
      content: '*,*::before,*::after{animation:none !important;transition:none !important}',
    }).catch(() => {});

    await page.waitForTimeout(600);

    await page.screenshot({
      path: path.join(OUT_DIR, site.file),
      type: 'jpeg',
      quality: 82,
    });

    console.log('  ok   ' + site.file + '  <-  ' + site.url);
    return true;
  } catch (err) {
    console.error('  FAIL ' + site.url + '  -  ' + err.message);
    return false;
  } finally {
    await page.close().catch(() => {});
  }
}

(async () => {
  fs.mkdirSync(OUT_DIR, { recursive: true });

  const browser = await chromium.launch();
  const context = await browser.newContext({
    viewport: { width: WIDTH, height: HEIGHT },
    deviceScaleFactor: 1,
    locale: 'he-IL',
    timezoneId: 'Asia/Jerusalem',
    userAgent:
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 ' +
      '(KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36',
  });

  console.log('Capturing ' + SITES.length + ' sites at ' + WIDTH + 'x' + HEIGHT + ':');

  let ok = 0;
  for (const site of SITES) {
    if (await shoot(context, site)) ok++;
  }

  await context.close();
  await browser.close();

  console.log('Done: ' + ok + '/' + SITES.length + ' succeeded.');

  /* Only fail the run if every site failed. A single failure keeps the old
     file in shots/, and the page keeps showing it. */
  if (ok === 0) process.exit(1);
})();
