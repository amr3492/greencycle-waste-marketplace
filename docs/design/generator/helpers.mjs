// Shared helpers: status bar, nav, icons, illustrations
export const I = (p, s = 22, w = 1.8) =>
`<svg width="${s}" height="${s}" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="${w}" stroke-linecap="round" stroke-linejoin="round">${p}</svg>`;

export const icons = {
home: s => I('<path d="M3 10.5 12 3l9 7.5"/><path d="M5 9.5V21h14V9.5"/><path d="M9.5 21v-6h5v6"/>', s),
pin: s => I('<path d="M12 21s-7-5.5-7-11a7 7 0 0 1 14 0c0 5.5-7 11-7 11Z"/><circle cx="12" cy="10" r="2.6"/>', s),
scan: s => I('<path d="M4 8V5.5A1.5 1.5 0 0 1 5.5 4H8M16 4h2.5A1.5 1.5 0 0 1 20 5.5V8M20 16v2.5a1.5 1.5 0 0 1-1.5 1.5H16M8 20H5.5A1.5 1.5 0 0 1 4 18.5V16"/><circle cx="12" cy="12" r="3.2"/>', s),
bag: s => I('<path d="M5 8h14l-1.2 12.2a1.8 1.8 0 0 1-1.8 1.8H8a1.8 1.8 0 0 1-1.8-1.8L5 8Z"/><path d="M8.5 10V6.5a3.5 3.5 0 0 1 7 0V10"/>', s),
user: s => I('<circle cx="12" cy="8" r="4"/><path d="M4.5 21a7.5 7.5 0 0 1 15 0"/>', s),
bell: s => I('<path d="M18 9a6 6 0 1 0-12 0c0 6-2.5 7-2.5 7h17S18 15 18 9Z"/><path d="M10 20a2.2 2.2 0 0 0 4 0"/>', s),
left: s => I('<path d="m14.5 6-6 6 6 6"/>', s, 2.2),
right: s => I('<path d="m9.5 6 6 6-6 6"/>', s, 2.2),
zap: s => I('<path d="M13 2 4.5 13.5H11L10 22l8.5-11.5H12L13 2Z"/>', s),
image: s => I('<rect x="3.5" y="4.5" width="17" height="15" rx="2.5"/><circle cx="9" cy="10" r="1.8"/><path d="m4.5 18 5-5 3 3 3.5-3.5 4.5 4.5"/>', s),
search: s => I('<circle cx="11" cy="11" r="6.5"/><path d="m20 20-3.8-3.8"/>', s),
heart: s => I('<path d="M12 20.5S3.5 15.5 3.5 9.7A4.6 4.6 0 0 1 12 7a4.6 4.6 0 0 1 8.5 2.7c0 5.8-8.5 10.8-8.5 10.8Z"/>', s),
star: s => `<svg width="${s}" height="${s}" viewBox="0 0 24 24" fill="#F5B83D"><path d="M12 2.8l2.8 5.9 6.4.8-4.7 4.4 1.2 6.3L12 17l-5.7 3.2 1.2-6.3L2.8 9.5l6.4-.8L12 2.8Z"/></svg>`,
plus: s => I('<path d="M12 5v14M5 12h14"/>', s, 2.2),
box: s => I('<path d="m12 3 8 4.2v9.6L12 21l-8-4.2V7.2L12 3Z"/><path d="M4.2 7.4 12 11.6l7.8-4.2M12 11.6V21"/>', s),
leaf: s => I('<path d="M5 19C5 9 12 4 20 4c0 9-5 15-14 15Z"/><path d="M5 19c3-6 7-9 11-11"/>', s),
gift: s => I('<rect x="4" y="10" width="16" height="4" rx="1"/><path d="M6 14v7h12v-7M12 10v11"/><path d="M12 10c-4 0-5.5-1.4-5.5-3A2 2 0 0 1 8.5 5C11 5 12 8 12 10Zm0 0c4 0 5.5-1.4 5.5-3A2 2 0 0 0 15.5 5C13 5 12 8 12 10Z"/>', s),
swap: s => I('<path d="M7 4 3.5 7.5 7 11M3.5 7.5H17a3.5 3.5 0 0 1 3.5 3.5M17 13l3.5 3.5L17 20M20.5 16.5H7a3.5 3.5 0 0 1-3.5-3.5"/>', s),
tag: s => I('<path d="m3.5 12.5 8.7-8.7a1.4 1.4 0 0 1 1-.4h6.3a1.5 1.5 0 0 1 1.5 1.5v6.3a1.4 1.4 0 0 1-.4 1l-8.7 8.7a1.5 1.5 0 0 1-2.1 0l-6.3-6.3a1.5 1.5 0 0 1 0-2.1Z"/><circle cx="16.5" cy="7.5" r="1.3"/>', s),
gear: s => I('<circle cx="12" cy="12" r="3.2"/><path d="M12 2.8v2.4M12 18.8v2.4M21.2 12h-2.4M5.2 12H2.8M18.5 5.5l-1.7 1.7M7.2 16.8l-1.7 1.7M18.5 18.5l-1.7-1.7M7.2 7.2 5.5 5.5"/>', s),
help: s => I('<circle cx="12" cy="12" r="9"/><path d="M9.5 9.3a2.6 2.6 0 1 1 3.6 2.9c-.8.4-1.1 1-1.1 1.8"/><circle cx="12" cy="17.3" r=".4" fill="currentColor"/>', s),
out: s => I('<path d="M14 4h4.5A1.5 1.5 0 0 1 20 5.5v13a1.5 1.5 0 0 1-1.5 1.5H14M10 8l-4 4 4 4M6 12h10"/>', s),
eye: s => I('<path d="M2.5 12S6 5.5 12 5.5 21.5 12 21.5 12 18 18.5 12 18.5 2.5 12 2.5 12Z"/><circle cx="12" cy="12" r="3"/>', s),
check: s => I('<path d="m5 12.5 4.5 4.5L19 7.5"/>', s, 2.4),
clock: s => I('<circle cx="12" cy="12" r="8.5"/><path d="M12 7.5V12l3 2"/>', s),
truck: s => I('<path d="M2.5 6h12v11h-12zM14.5 10h4l3 3.5V17h-7"/><circle cx="7" cy="18.5" r="1.8"/><circle cx="17.5" cy="18.5" r="1.8"/>', s),
doc: s => I('<path d="M6 3h8l4 4v14H6V3Z"/><path d="M14 3v4h4M9 12h6M9 16h6"/>', s),
users: s => I('<circle cx="9" cy="8.5" r="3.5"/><path d="M2.5 20a6.5 6.5 0 0 1 13 0M16 5.5a3.5 3.5 0 0 1 0 6.4M17.5 13.7a6.5 6.5 0 0 1 4 6.3"/>', s),
chart: s => I('<path d="M4 4v16h16"/><path d="M8 16v-5M12.5 16V8M17 16v-3"/>', s),
grid: s => I('<rect x="4" y="4" width="7" height="7" rx="1.8"/><rect x="13" y="4" width="7" height="7" rx="1.8"/><rect x="4" y="13" width="7" height="7" rx="1.8"/><rect x="13" y="13" width="7" height="7" rx="1.8"/>', s),
cam: s => I('<path d="M4 8h3l1.5-2.5h7L17 8h3a1.5 1.5 0 0 1 1.5 1.5V18a1.5 1.5 0 0 1-1.5 1.5H4A1.5 1.5 0 0 1 2.5 18V9.5A1.5 1.5 0 0 1 4 8Z"/><circle cx="12" cy="13.5" r="3.6"/>', s),
arrowR: s => I('<path d="M4.5 12h15m-6-6 6 6-6 6"/>', s, 2.2),
cart: s => I('<circle cx="9.5" cy="20" r="1.5"/><circle cx="17" cy="20" r="1.5"/><path d="M3 4h2.5l2.2 11h10.4l2-7.5H7"/>', s),
recycle: s => I('<path d="M7.5 19h9M9 7.5 5.8 13M15 7.5 18.2 13M12 4.5 9.7 8.5M12 4.5l2.3 4M5.8 13l-1 3.7M18.2 13l1 3.7M8.6 19l-1.9-2.7M15.4 19l1.9-2.7"/>', s),
};

export const sb = (dark = false) => `<div class="sb${dark ? ' on-dark' : ''}"><span>9:41</span><span class="sbi">
<svg width="17" height="11" viewBox="0 0 17 11" fill="currentColor"><rect x="0" y="7" width="3" height="4" rx=".8"/><rect x="4.5" y="5" width="3" height="6" rx=".8"/><rect x="9" y="2.5" width="3" height="8.5" rx=".8"/><rect x="13.5" y="0" width="3" height="11" rx=".8"/></svg>
<svg width="16" height="11" viewBox="0 0 16 11" fill="currentColor"><path d="M8 9.2 5.6 6.8a3.4 3.4 0 0 1 4.8 0L8 9.2Z"/><path d="M3.4 4.6a6.5 6.5 0 0 1 9.2 0l-1.5 1.5a4.5 4.5 0 0 0-6.2 0L3.4 4.6Z" opacity=".9"/><path d="M.8 2.2a10.2 10.2 0 0 1 14.4 0l-1.5 1.5a8.2 8.2 0 0 0-11.4 0L.8 2.2Z" opacity=".75"/></svg>
<svg width="25" height="12" viewBox="0 0 25 12" fill="none"><rect x=".5" y=".5" width="21" height="11" rx="3.2" stroke="currentColor" opacity=".45"/><rect x="2.3" y="2.3" width="15" height="7.4" rx="1.8" fill="currentColor"/><path d="M23.4 4v4a2.1 2.1 0 0 0 0-4Z" fill="currentColor" opacity=".45"/></svg>
</span></div>`;

export const NAV = (active) => {
const it = (key, ic, label, to) => `<button class="ni${active === key ? ' on' : ''}" data-to="${to}">${ic}<span>${label}</span></button>`;
return `<div class="nav">
${it('home', icons.home(23), 'Home', '/home')}
${it('bins', icons.pin(23), 'Bins', '/bins')}
<button class="ni fabw" data-to="/scan"><span class="fab">${icons.scan(26)}</span><span style="margin-top:2px">Scan</span></button>
${it('market', icons.bag(23), 'Market', '/marketplace')}
${it('profile', icons.user(23), 'Profile', '/profile')}
</div><div class="homebar"></div>`;
};

export const logo = (s = 44, r = 14) => `<div class="logomark" style="width:${s}px;height:${s}px;border-radius:${r}px">
<svg width="${s * .6}" height="${s * .6}" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2.1" stroke-linecap="round" stroke-linejoin="round">
<path d="M4.5 20C4.5 10.5 11 5 20 5c0 9.5-5.5 15-15.5 15Z" fill="rgba(255,255,255,.18)"/>
<path d="M4.5 20c3.2-6.2 7.2-9.5 11.5-11.5"/></svg></div>`;

export const avatar = (t, s = 44, g = 'linear-gradient(150deg,#F2994A,#E2574C)') =>
`<div style="width:${s}px;height:${s}px;border-radius:50%;background:${g};display:flex;align-items:center;justify-content:center;color:#fff;font-weight:800;font-size:${s * .38}px;flex:none">${t}</div>`;

/* product illustrations (soft 3D-ish SVG scenes on tinted grounds) */
export const P = {
bottle: (w = 120) => `<svg width="${w}" height="${w * 1.05}" viewBox="0 0 100 105">
<ellipse cx="50" cy="97" rx="30" ry="6" fill="rgba(18,32,25,.10)"/>
<path d="M41 12h18v8l7 10v55a12 12 0 0 1-12 12H46a12 12 0 0 1-12-12V30l7-10v-8Z" fill="#BFE6F5"/>
<path d="M41 12h18v8l7 10v55a12 12 0 0 1-12 12h-6V20l-7-2v-6Z" fill="#9BD6EE"/>
<rect x="39" y="5" width="22" height="9" rx="2.5" fill="#1E9E57"/>
<path d="M34 44h32v26H34z" fill="#fff" opacity=".85"/>
<path d="M38 51h24M38 57h24M38 63h15" stroke="#7FB3C8" stroke-width="2.4" stroke-linecap="round"/>
<path d="M50 20v-8M45 20v-6" stroke="#8FD0E8" stroke-width="3" stroke-linecap="round"/></svg>`,
box: (w = 120) => `<svg width="${w}" height="${w}" viewBox="0 0 100 100">
<ellipse cx="50" cy="90" rx="34" ry="6" fill="rgba(18,32,25,.10)"/>
<path d="M12 38h76v44a6 6 0 0 1-6 6H18a6 6 0 0 1-6-6V38Z" fill="#D9A25F"/>
<path d="M12 38 4 24h40l6 14H12Z" fill="#E8B878"/>
<path d="M88 38 96 24H56l-6 14h38Z" fill="#C98F4B"/>
<rect x="42" y="44" width="16" height="10" rx="2" fill="#B47A3A" opacity=".55"/>
<path d="M20 50v30M80 50v30" stroke="#C08542" stroke-width="3" opacity=".5"/></svg>`,
jar: (w = 120) => `<svg width="${w}" height="${w * 1.05}" viewBox="0 0 100 105">
<ellipse cx="50" cy="97" rx="28" ry="6" fill="rgba(18,32,25,.10)"/>
<rect x="28" y="22" width="44" height="68" rx="14" fill="#DFF1E6"/>
<rect x="28" y="22" width="16" height="68" rx="8" fill="#C9E7D4"/>
<rect x="25" y="12" width="50" height="14" rx="5" fill="#8FAE97"/>
<rect x="25" y="12" width="50" height="5" rx="2.5" fill="#7A9883"/>
<path d="M36 48h28M36 56h28M36 64h18" stroke="#9DC3A9" stroke-width="3" stroke-linecap="round"/></svg>`,
can: (w = 120) => `<svg width="${w}" height="${w * 1.05}" viewBox="0 0 100 105">
<ellipse cx="50" cy="97" rx="26" ry="5.5" fill="rgba(18,32,25,.10)"/>
<rect x="32" y="16" width="36" height="74" rx="9" fill="#C7CFD6"/>
<rect x="32" y="16" width="13" height="74" rx="6.5" fill="#AEB9C2"/>
<ellipse cx="50" cy="17" rx="18" ry="5" fill="#8E99A4"/>
<ellipse cx="50" cy="17" rx="11" ry="3" fill="#6F7B87"/>
<path d="M40 40h20M40 48h20M40 56h12" stroke="#93A0AB" stroke-width="3" stroke-linecap="round"/></svg>`,
phone: (w = 120) => `<svg width="${w}" height="${w * 1.05}" viewBox="0 0 100 105">
<ellipse cx="50" cy="97" rx="28" ry="5.5" fill="rgba(18,32,25,.10)"/>
<rect x="30" y="10" width="40" height="80" rx="9" fill="#2A3A31"/>
<rect x="34" y="15" width="32" height="64" rx="5" fill="#9FD8B8"/>
<circle cx="50" cy="84" r="2.6" fill="#5B6B60"/>
<path d="M42 24h16M42 30h10" stroke="#fff" stroke-width="2.6" stroke-linecap="round" opacity=".8"/></svg>`,
paper: (w = 120) => `<svg width="${w}" height="${w}" viewBox="0 0 100 100">
<ellipse cx="50" cy="90" rx="32" ry="5.5" fill="rgba(18,32,25,.10)"/>
<path d="M25 20h42l10 10v52H25V20Z" fill="#F2EEDF"/>
<path d="M67 20v10h10" fill="#DED8C2"/>
<path d="M33 40h34M33 48h34M33 56h34M33 64h22" stroke="#C9C2A8" stroke-width="3.4" stroke-linecap="round"/>
<circle cx="70" cy="66" r="12" fill="#1E9E57" opacity=".16"/><path d="m64.5 66 3.5 3.5 7-7.5" stroke="#1E9E57" stroke-width="2.6" fill="none" stroke-linecap="round"/></svg>`,
};

/* big onboarding illustrations */
export const ILL = {
bin: `<svg width="240" height="200" viewBox="0 0 240 200">
<circle cx="120" cy="96" r="86" fill="#E8F5EC"/>
<circle cx="188" cy="42" r="12" fill="#D7EEDF"/><circle cx="52" cy="150" r="9" fill="#D7EEDF"/>
<path d="M86 70h68l-7 96a10 10 0 0 1-10 9H103a10 10 0 0 1-10-9L86 70Z" fill="#1E9E57"/>
<path d="M120 70h34l-7 96a10 10 0 0 1-10 9h-17V70Z" fill="#178A4A"/>
<rect x="78" y="56" width="84" height="16" rx="8" fill="#0F7A40"/>
<rect x="108" y="44" width="24" height="14" rx="6" fill="#0F7A40"/>
<path d="M112 96l-8 12h7l-3 10 12-13h-7l4-9h-5Z" fill="#fff" opacity=".92"/>
<path d="M60 58c8-16 22-22 22-22s-2 16-10 24-16 8-16 8 1-6 4-10Z" fill="#27B266"/>
<path d="M180 64c10-8 24-6 24-6s-6 14-16 17-16-1-16-1 3-6 8-10Z" fill="#7CCB9B"/>
<g transform="translate(36,120) rotate(-18)"><path d="M10 0h12v5l4 7v34a8 8 0 0 1-8 8h-4a8 8 0 0 1-8-8V12l4-7V0Z" fill="#BFE6F5"/><rect x="8" y="-5" width="16" height="6" rx="2" fill="#1E9E57"/></g>
<g transform="translate(186,126) rotate(14)"><path d="M10 0h12v5l4 7v34a8 8 0 0 1-8 8h-4a8 8 0 0 1-8-8V12l4-7V0Z" fill="#DFF1E6"/><rect x="8" y="-5" width="16" height="6" rx="2" fill="#0F7A40"/></g></svg>`,
globe: `<svg width="240" height="200" viewBox="0 0 240 200">
<circle cx="120" cy="88" r="80" fill="#E8F5EC"/>
<circle cx="120" cy="88" r="56" fill="#7CC4EE"/>
<path d="M84 66c10-8 24-6 30 2s4 18-4 22-22 2-26-6-6-13 0-18Z" fill="#4CAF6E"/>
<path d="M132 96c8-4 20-2 24 6s0 16-8 18-18-2-20-10-2-11 4-14Z" fill="#4CAF6E"/>
<path d="M120 32a56 56 0 0 1 0 112" fill="none" stroke="#fff" stroke-width="2.4" opacity=".55"/>
<path d="M64 88h112" stroke="#fff" stroke-width="2.4" opacity=".45"/>
<path d="M76 168c10-16 26-24 44-24s34 8 44 24l-8 10H84l-8-10Z" fill="#F2C89B"/>
<path d="M76 168c6-10 16-17 28-20l4 22-24 8-8-10Z" fill="#E9B483"/>
<path d="M40 60c8-14 20-18 20-18s0 14-8 20-16 6-16 6 1-4 4-8Z" fill="#27B266"/>
<path d="M196 52c10-6 20-4 20-4s-4 12-12 15-14 0-14 0 2-7 6-11Z" fill="#7CCB9B"/>
<g transform="translate(30,150)"><rect width="34" height="24" rx="6" fill="#F2994A"/><path d="M6 12h22" stroke="#fff" stroke-width="3" opacity=".7"/></g></svg>`,
shop: `<svg width="240" height="200" viewBox="0 0 240 200">
<circle cx="120" cy="96" r="86" fill="#E8F5EC"/>
<rect x="66" y="84" width="108" height="72" rx="10" fill="#fff" stroke="#D7EEDF" stroke-width="2"/>
<path d="M58 84l8-26h108l8 26c0 10-10 16-20 12-4 8-16 8-20 0-4 8-16 8-20 0-4 8-16 8-20 0-4 8-16 8-20 0-10-2-14-12Z" fill="#1E9E57"/>
<path d="M92 84c0 8 8 12 14 8V58H74l-8 26c0 8 8 12 13 8 2 4 8 6 13-8Z" fill="#27B266" opacity=".85"/>
<rect x="80" y="106" width="30" height="50" rx="4" fill="#DFF1E6"/>
<rect x="120" y="106" width="40" height="30" rx="4" fill="#BFE6F5"/>
<g transform="translate(160,120)"><rect x="-6" y="14" width="34" height="30" rx="4" fill="#0F7A40"/><rect x="-10" y="6" width="42" height="10" rx="5" fill="#0A5C30"/></g>
<circle cx="52" cy="48" r="9" fill="#D7EEDF"/><circle cx="196" cy="150" r="11" fill="#D7EEDF"/>
<path d="M190 60c9-7 20-5 20-5s-4 12-12 15-13-1-13-1 2-6 5-10Z" fill="#7CCB9B"/></svg>`,
leaves: `<svg width="390" height="230" viewBox="0 0 390 230" style="position:absolute;left:0;bottom:0">
<path d="M0 230V120C60 130 90 170 96 230H0Z" fill="#D7EEDF"/>
<path d="M390 230V100c-70 12-104 58-110 130h110Z" fill="#C4E7D1"/>
<path d="M20 230c0-50 24-84 66-100-6 46-22 82-66 100Z" fill="#A9DDBD"/>
<path d="M370 230c0-56-28-94-74-112 8 52 26 92 74 112Z" fill="#8ED3AA"/>
<path d="M150 230c4-34 22-56 50-66-4 32-18 54-50 66Z" fill="#B9E4C8"/></svg>`,
};

export const doc = (key, title, body, extra = '') => { const wide = extra === 'wide'; return `<!doctype html><html><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="style.css"><title>${title}</title></head>
<body><div class="screen${wide ? ' wide' : ''}" id="scr">${body}</div>${wide ? '' : extra}</body></html>`; };
