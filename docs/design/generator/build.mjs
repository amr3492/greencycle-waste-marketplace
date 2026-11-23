// Build: write HTML screens, screenshot each, extract hotspots
import { writeFileSync, mkdirSync, copyFileSync } from 'fs';
import p1 from './part1.mjs';
import p2 from './part2.mjs';
import p3 from './part3.mjs';
import p4 from './part4.mjs';

const screens = [...p1, ...p2, ...p3, ...p4];
const DIST = '/downloads/recircle-design/dist';
mkdirSync(DIST, { recursive: true });
copyFileSync(new URL('./style.css', import.meta.url), `${DIST}/style.css`);
for (const s of screens) writeFileSync(`${DIST}/${s.key}.html`, s.body);
console.log('wrote', screens.length, 'screens');

const { chromium } = await import('/home/sandbox/.npm/_npx/e41f203b7505f1fb/node_modules/playwright/index.mjs');
const browser = await chromium.launch({ channel: 'chrome', headless: true });
const out = {};
for (const s of screens) {
  const w = s.wide ? 1280 : 390;
  const page = await browser.newPage({ viewport: { width: w, height: 844 }, deviceScaleFactor: s.wide ? 1.5 : 2 });
  await page.goto(`file://${DIST}/${s.key}.html`);
  await page.waitForTimeout(900);
  await page.screenshot({ path: `${DIST}/${s.key}.png` });
  const spots = await page.$$eval('[data-to]', (els, vw) => els.map(e => {
    const r = e.getBoundingClientRect();
    return { to: e.getAttribute('data-to'), x: +(r.left / vw * 100).toFixed(2), y: +(r.top / 844 * 100).toFixed(2), w: +(r.width / vw * 100).toFixed(2), h: +(r.height / 844 * 100).toFixed(2) };
  }).filter(h => h.w > 0 && h.h > 0), w);
  out[s.key] = { label: s.label, route: s.route, wide: !!s.wide, hs: spots };
  await page.close();
  console.log('shot', s.key, spots.length, 'hotspots');
}
await browser.close();
writeFileSync(`${DIST}/hotspots.json`, JSON.stringify(out, null, 1));
console.log('done');
