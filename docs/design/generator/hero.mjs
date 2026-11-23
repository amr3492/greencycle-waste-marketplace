import { writeFileSync } from 'fs';
import { readFileSync } from 'fs';
const b64 = (f) => 'data:image/png;base64,' + readFileSync(`/downloads/recircle-design/dist/${f}.png`).toString('base64');
const html = `<!doctype html><html><body style="margin:0;width:1200px;height:630px;background:linear-gradient(135deg,#0B6B38,#1C9E58);display:flex;align-items:center;justify-content:center;gap:34px;overflow:hidden;font-family:Inter,sans-serif">
<img src="${b64('splash')}" style="width:218px;border-radius:26px;box-shadow:0 24px 60px rgba(0,0,0,.35);transform:rotate(-5deg) translateY(24px)">
<img src="${b64('home')}" style="width:250px;border-radius:28px;box-shadow:0 28px 70px rgba(0,0,0,.4)">
<img src="${b64('result')}" style="width:218px;border-radius:26px;box-shadow:0 24px 60px rgba(0,0,0,.35);transform:rotate(5deg) translateY(24px)">
</body></html>`;
writeFileSync('/tmp/hero.html', html);
const { chromium } = await import('/home/sandbox/.npm/_npx/e41f203b7505f1fb/node_modules/playwright/index.mjs');
const b = await chromium.launch({ channel: 'chrome', headless: true });
const p = await b.newPage({ viewport: { width: 1200, height: 630 }, deviceScaleFactor: 1.5 });
await p.goto('file:///tmp/hero.html'); await p.waitForTimeout(600);
await p.screenshot({ path: '/downloads/recircle-design/dist/preview-hero.png' });
await b.close(); console.log('hero done');
