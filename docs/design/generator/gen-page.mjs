// Generate the File project App.tsx from hotspots.json + copy assets
import { readFileSync, writeFileSync, copyFileSync, mkdirSync } from 'fs';

const HS = JSON.parse(readFileSync('/downloads/recircle-design/dist/hotspots.json', 'utf8'));
const ORDER = ['splash', 'onboarding-1', 'onboarding-2', 'onboarding-3', 'login', 'signup', 'home', 'scan', 'result', 'marketplace', 'item', 'sell', 'bins', 'points', 'profile', 'orders', 'trades', 'donate', 'admin', 'responsive'];
const PHOTOS = '/downloads/recircle-v2/src/photos';
mkdirSync(PHOTOS, { recursive: true });

const imports = [], entries = [];
ORDER.forEach((k, i) => {
  const s = HS[k];
  copyFileSync(`/downloads/recircle-design/dist/${k}.png`, `${PHOTOS}/${k}.png`);
  imports.push(`import img${i} from './photos/${k}.png';`);
  entries.push(`{key:'${k}',path:'${s.route}',label:'${s.label}',img:img${i},wide:${s.wide},hs:${JSON.stringify(s.hs)}}`);
});
copyFileSync('/downloads/recircle-design/dist/preview-hero.png', `${PHOTOS}/preview.png`);

const tsx = `import React from 'react';
import { Closing, FileCard, Group, Header, Link, Route, Routes } from '@instinct/files';
${imports.join('\n')}

type Spot = { to: string; x: number; y: number; w: number; h: number };
type Screen = { key: string; path: string; label: string; img: string; wide: boolean; hs: Spot[] };

const SCREENS: Screen[] = [
${entries.join(',\n')},
];

function Stage({ s }: { s: Screen }) {
    return <div className="rc-stage"><div className={s.wide ? 'rc-phone rc-wide' : 'rc-phone'}>
        <img src={s.img} alt={'ReCircle ' + s.label + ' screen'} />
        {s.hs.map((h, i) => <Link key={i} to={h.to} className="rc-hot" aria-label={'Go to ' + h.to} style={{ left: h.x + '%', top: h.y + '%', width: h.w + '%', height: h.h + '%' }} />)}
    </div>
    <p className="rc-hint">{s.wide ? 'Desktop view, shown smaller here.' : 'Tap the controls: buttons, cards and bottom tabs all navigate.'}</p>
    <Link className="file-button is-compact" data-variant="secondary" to="/">All 20 screens</Link>
    </div>;
}

function ScreenPage({ s }: { s: Screen }) {
    return <Group label={s.label} heading><Stage s={s} /></Group>;
}

const FLOWS = [
    { name: 'First run', detail: 'Splash, Onboarding 1-3, Login or Sign Up, Home.' },
    { name: 'Recycle an item', detail: 'Home, Scan Waste, Scan Result, Find Smart Bin.' },
    { name: 'Shop the marketplace', detail: 'Home, Marketplace, Item Details, Buy Now lands in Orders.' },
    { name: 'Sell, trade, donate', detail: 'Quick actions on Home: Sell Item, Trade board, Donate to NGOs.' },
    { name: 'Track eco points', detail: 'Home, Eco Points: balance, level, history and next reward.' },
    { name: 'Admin', detail: 'Dashboard with users, items, waste stats and bin status, plus the responsive preview.' },
];

function Overview() {
    return <>
        <Group label="The flows" heading>
            <ul className="rc-flows">{FLOWS.map((f, i) => <li key={f.name}><b>{i + 1}. {f.name}.</b> {f.detail}</li>)}</ul>
        </Group>
        <Group label="All 20 screens" heading>
            <div className="rc-grid">
                {SCREENS.map((s, i) => <Link key={s.key} to={s.path} className={s.wide ? 'rc-thumb rc-thumbw' : 'rc-thumb'}><img src={s.img} alt={s.label} /><span className="rc-tlabel">{i + 1}. {s.label}</span></Link>)}
            </div>
        </Group>
    </>;
}

export function App() {
    return <FileCard>
        <Header title="ReCircle: 20-screen app prototype" fact="iPhone 15, 390x844, plus admin" intro="The full ReCircle concept, the green e-commerce and smart waste app: splash and onboarding, login, AI waste scan, smart bin map, eco points, marketplace, sell, trades, donations, orders, profile, and an admin dashboard. Open a screen and tap through the flows." />
        <Routes>
            <Route path="/" element={<Overview />} />
            {SCREENS.map(s => <Route key={s.key} path={s.path} element={<ScreenPage s={s} />} />)}
        </Routes>
        <Closing>All products, sellers, NGOs, points and bin data are illustrative sample content for the graduation project, not real listings.</Closing>
    </FileCard>;
}
`;
writeFileSync('/downloads/recircle-v2/src/App.tsx', tsx);
console.log('App.tsx written,', ORDER.length, 'screens');
