// Screens 19-20: admin dashboard (desktop), responsive preview
import { icons, logo, avatar, doc } from './helpers.mjs';

/* ---------- 19. ADMIN DASHBOARD (1280x844) ---------- */
const side = (ic, t, on = false) => `<div style="display:flex;align-items:center;gap:11px;padding:11px 16px;border-radius:12px;${on ? 'background:rgba(255,255,255,.14);color:#fff;font-weight:700' : 'color:rgba(255,255,255,.72)'};font-size:13.5px">${ic}${t}</div>`;
const stat = (ic, bg, col, label, val, delta, up = true) => `<div style="background:#fff;border-radius:18px;padding:18px;box-shadow:0 8px 20px rgba(18,32,25,.06);flex:1">
<div style="display:flex;align-items:center;gap:12px"><span style="width:44px;height:44px;border-radius:14px;background:${bg};color:${col};display:flex;align-items:center;justify-content:center">${ic}</span>
<div><div style="font-size:12px;color:var(--ink-2);font-weight:600">${label}</div><b style="font-size:24px;letter-spacing:-.02em">${val}</b></div></div>
<div style="margin-top:10px;font-size:11.5px;font-weight:700;color:${up ? 'var(--green)' : 'var(--red)'}">${delta} <span style="color:var(--ink-3);font-weight:500">vs last month</span></div></div>`;
const bar = (label, pct, c) => `<div style="display:flex;align-items:center;gap:10px;font-size:12px;font-weight:600;color:var(--ink-2)">
<span style="width:82px">${label}</span><div style="flex:1;height:9px;border-radius:5px;background:var(--mint-2)"><div style="width:${pct}%;height:100%;border-radius:5px;background:${c}"></div></div><b style="width:36px;text-align:right;color:var(--ink)">${pct}%</b></div>`;
const tr = (u, item, st, stc, stbg, pts) => `<tr style="border-top:1px solid var(--line)">
<td style="padding:10px 4px;font-weight:700;font-size:12.5px">${u}</td><td style="font-size:12.5px;color:var(--ink-2)">${item}</td>
<td><span style="background:${stbg};color:${stc};font-size:10.5px;font-weight:800;padding:4px 9px;border-radius:999px">${st}</span></td>
<td style="text-align:right;font-size:12.5px;font-weight:700;color:var(--green-d)">${pts}</td></tr>`;

const admin = doc('admin', 'ReCircle - Admin Dashboard', `<div style="display:flex;height:844px;background:#F2F6F3">
<div style="width:230px;flex:none;background:linear-gradient(180deg,#0E7C42,#0A5C30);padding:22px 14px;display:flex;flex-direction:column;gap:4px">
<div style="display:flex;align-items:center;gap:10px;padding:0 8px 18px">${logo(36, 11)}<b style="color:#fff;font-size:16.5px">ReCircle</b></div>
${side(icons.grid(18), 'Dashboard', true)}${side(icons.users(18), 'Users')}${side(icons.box(18), 'Items')}${side(icons.pin(18), 'Smart Bins')}${side(icons.gift(18), 'Donations')}${side(icons.doc(18), 'Reports')}${side(icons.gear(18), 'Settings')}
<div style="flex:1"></div>
<div style="background:rgba(255,255,255,.10);border-radius:14px;padding:12px 14px;color:#fff;font-size:11.5px;display:flex;gap:9px;align-items:center">${avatar('AA', 32, 'rgba(255,255,255,.25)')}<div><b style="font-size:12px">Amr Abdelbaki</b><div style="opacity:.75;font-size:10.5px">Super Admin</div></div></div></div>
<div style="flex:1;padding:24px 28px;overflow:hidden">
<div style="display:flex;align-items:center;gap:14px">
<div style="flex:1"><b style="font-size:21px;letter-spacing:-.01em">Dashboard</b><div style="font-size:12px;color:var(--ink-2);margin-top:2px">Welcome back, here is what is happening on ReCircle.</div></div>
<div style="height:40px;width:250px;border-radius:12px;background:#fff;border:1.5px solid var(--line);display:flex;align-items:center;gap:8px;padding:0 13px;color:var(--ink-3);font-size:12.5px">${icons.search(15)} Search...</div>
<button class="card" style="width:40px;height:40px;border-radius:12px;display:flex;align-items:center;justify-content:center;color:var(--ink-2)">${icons.bell(17)}</button>
${avatar('AA', 40, 'linear-gradient(150deg,#27B266,#0E7C42)')}</div>
<div style="display:flex;gap:16px;margin-top:18px">
${stat(icons.users(21), 'var(--mint)', 'var(--green-d)', 'Total Users', '1,240', '+12%')}
${stat(icons.box(21), '#E8F0FE', '#2B5FC7', 'Items Listed', '856', '+8%')}
${stat(icons.recycle(21), 'var(--orange-bg)', 'var(--orange)', 'Recycled Waste', '1.2 Tons', '+21%')}
${stat(icons.pin(21), '#EFE9FD', '#8B5CF6', 'Active Bins', '24', '2 offline', false)}
</div>
<div style="display:flex;gap:16px;margin-top:16px">
<div style="background:#fff;border-radius:18px;padding:18px;flex:1.25;box-shadow:0 8px 20px rgba(18,32,25,.06)">
<b style="font-size:14.5px">Waste by Category</b>
<div style="display:flex;align-items:center;gap:22px;margin-top:12px">
<svg width="150" height="150" viewBox="0 0 42 42"><circle cx="21" cy="21" r="15.9" fill="none" stroke="#E4EBE5" stroke-width="7"/>
<circle cx="21" cy="21" r="15.9" fill="none" stroke="#1E9E57" stroke-width="7" stroke-dasharray="40 60" stroke-dashoffset="25" stroke-linecap="round"/>
<circle cx="21" cy="21" r="15.9" fill="none" stroke="#F2994A" stroke-width="7" stroke-dasharray="25 75" stroke-dashoffset="85" stroke-linecap="round"/>
<circle cx="21" cy="21" r="15.9" fill="none" stroke="#3B82C4" stroke-width="7" stroke-dasharray="20 80" stroke-dashoffset="60" stroke-linecap="round"/>
<circle cx="21" cy="21" r="15.9" fill="none" stroke="#8B5CF6" stroke-width="7" stroke-dasharray="15 85" stroke-dashoffset="40" stroke-linecap="round"/>
<text x="21" y="20" text-anchor="middle" font-size="6.5" font-weight="800" fill="#122019">1.2t</text><text x="21" y="26" text-anchor="middle" font-size="3.4" fill="#5B6B60">total</text></svg>
<div style="display:flex;flex-direction:column;gap:8px;font-size:12px;font-weight:600;color:var(--ink-2)">
${[['#1E9E57', 'Plastic', '40%'], ['#F2994A', 'Paper', '25%'], ['#3B82C4', 'Glass', '20%'], ['#8B5CF6', 'Metal', '15%']].map(([c, l, p]) => `<span style="display:flex;align-items:center;gap:8px"><i style="width:10px;height:10px;border-radius:3px;background:${c}"></i>${l}<b style="color:var(--ink);margin-left:6px">${p}</b></span>`).join('')}</div></div></div>
<div style="background:#fff;border-radius:18px;padding:18px;flex:1;box-shadow:0 8px 20px rgba(18,32,25,.06)">
<b style="font-size:14.5px">Bin Status</b>
<div style="display:flex;flex-direction:column;gap:12px;margin-top:16px">
${bar('Available', 62, '#1E9E57')}${bar('Filling Up', 26, '#F2994A')}${bar('Full', 8, '#E2574C')}${bar('Offline', 4, '#8CA093')}</div>
<div style="margin-top:16px;background:var(--mint);border-radius:13px;padding:10px 13px;font-size:11.5px;color:#14532D;display:flex;gap:8px;align-items:center"><span style="color:var(--green-d)">${icons.zap(15)}</span>3 bins need collection today in Giza district.</div></div></div>
<div style="background:#fff;border-radius:18px;padding:16px 18px;margin-top:16px;box-shadow:0 8px 20px rgba(18,32,25,.06)">
<div style="display:flex;align-items:center;justify-content:space-between"><b style="font-size:14.5px">Recent Activity</b><span style="font-size:11.5px;font-weight:700;color:var(--green)">View all</span></div>
<table style="width:100%;border-collapse:collapse;margin-top:6px">
<tr style="font-size:10.5px;color:var(--ink-3);text-align:left"><th style="padding:6px 4px;font-weight:700">USER</th><th style="font-weight:700">ACTION</th><th style="font-weight:700">STATUS</th><th style="text-align:right;font-weight:700">POINTS</th></tr>
${tr('Sara Ahmed', 'Listed Cardboard Box', 'Approved', 'var(--green-d)', 'var(--mint)', '+15')}
${tr('Omar Khaled', 'Recycled at Bin #102', 'Completed', '#2B5FC7', '#E8F0FE', '+10')}
${tr('Laila Hassan', 'Donation to Resala', 'Pending', '#B36A1E', 'var(--orange-bg)', '+50')}
</table></div></div></div>`, 'wide');

/* ---------- 20. RESPONSIVE PREVIEW (1280x844) ---------- */
const frame = (w, h, label, inner, top) => `<div style="display:flex;flex-direction:column;align-items:center;gap:10px">
<div style="width:${w}px;height:${h}px;border-radius:${w > 500 ? 18 : 26}px;overflow:hidden;background:#fff;border:1px solid var(--line);box-shadow:0 20px 44px rgba(18,32,25,.16);position:relative">${inner}</div>
<b style="font-size:12.5px;color:var(--ink-2)">${label}</b></div>`;

const miniHome = (scale, showSide) => `<div style="transform:scale(${scale});transform-origin:top left;width:390px;background:var(--bg);height:844px">
<div style="display:flex;align-items:center;gap:9px;padding:16px 18px 0">${logo(34, 11)}<b style="font-size:16px">ReCircle</b><span style="flex:1"></span>${avatar('AA', 32, 'linear-gradient(150deg,#27B266,#0E7C42)')}</div>
<div style="margin:12px 18px 0;border-radius:18px;padding:15px;background:linear-gradient(140deg,#1C9E58,#0B6B38);color:#fff">
<div style="font-size:11px;opacity:.85;font-weight:600">Good morning, Amr</div><b style="font-size:15.5px">Together for a Cleaner World</b>
<div style="margin-top:9px;background:rgba(255,255,255,.16);border-radius:999px;padding:5px 11px;font-size:11px;font-weight:700;display:inline-block">320 Eco Points</div></div>
<div style="display:grid;grid-template-columns:1fr 1fr;gap:10px;padding:12px 18px">
<div style="grid-column:1/3;height:46px;border-radius:14px;background:linear-gradient(160deg,#24AE60,#12824A);color:#fff;display:flex;align-items:center;justify-content:center;gap:8px;font-size:14px;font-weight:800">${icons.scan(19)} Scan Waste</div>
${['Smart Bins', 'Marketplace', 'Eco Points', 'My Orders'].map(l => `<div style="background:#fff;border-radius:14px;padding:12px 0;text-align:center;font-size:11px;font-weight:700;box-shadow:var(--sh)">${l}</div>`).join('')}
</div></div>`;

const responsive = doc('responsive', 'ReCircle - Responsive Design', `<div style="width:1280px;height:844px;background:linear-gradient(160deg,#EDF5EF,#DCEEE3);padding:34px 40px;position:relative;overflow:hidden">
<div style="position:absolute;right:-120px;top:-120px;width:340px;height:340px;border-radius:50%;background:rgba(30,158,87,.10)"></div>
<div style="position:absolute;left:-90px;bottom:-140px;width:300px;height:300px;border-radius:50%;background:rgba(30,158,87,.08)"></div>
<div style="display:flex;align-items:center;gap:11px">${logo(38, 12)}<b style="font-size:17px">ReCircle</b>
<span style="background:#fff;border:1px solid var(--line);border-radius:999px;padding:5px 13px;font-size:11.5px;font-weight:700;color:var(--green-d)">Responsive Design</span></div>
<div style="display:flex;align-items:flex-end;gap:36px;margin-top:26px">
${frame(300, 620, 'Mobile · 390px', `<div style="position:absolute;inset:0;overflow:hidden">${miniHome(300 / 390)}</div>`)}
${frame(420, 560, 'Tablet · 768px', `<div style="position:absolute;inset:0">${miniHome(420 / 390)}</div>`)}
${frame(430, 560, 'Desktop · 1280px', `<div style="position:absolute;inset:0;display:flex">
<div style="width:150px;background:linear-gradient(180deg,#0E7C42,#0A5C30);padding:16px 10px;display:flex;flex-direction:column;gap:5px">${logo(28, 9)}
${['Dashboard', 'Users', 'Items', 'Smart Bins'].map((t, i) => `<div style="padding:8px 10px;border-radius:9px;font-size:10.5px;${i === 0 ? 'background:rgba(255,255,255,.14);color:#fff;font-weight:700' : 'color:rgba(255,255,255,.7)'}">${t}</div>`).join('')}</div>
<div style="flex:1;padding:14px"><b style="font-size:13px">Dashboard</b>
<div style="display:flex;gap:8px;margin-top:10px">${[['Users', '1,240'], ['Items', '856'], ['Waste', '1.2t']].map(([l, v]) => `<div style="flex:1;background:#fff;border-radius:11px;padding:9px;box-shadow:var(--sh)"><div style="font-size:8.5px;color:var(--ink-2);font-weight:600">${l}</div><b style="font-size:14px">${v}</b></div>`).join('')}</div>
<div style="margin-top:10px;background:#fff;border-radius:11px;padding:10px;box-shadow:var(--sh)"><b style="font-size:10px">Bin Status</b>
<div style="height:7px;border-radius:4px;background:var(--mint-2);margin-top:8px"><div style="width:62%;height:100%;border-radius:4px;background:#1E9E57"></div></div>
<div style="height:7px;border-radius:4px;background:var(--mint-2);margin-top:6px"><div style="width:26%;height:100%;border-radius:4px;background:#F2994A"></div></div></div></div></div>`)}
</div>
<div style="position:absolute;bottom:26px;left:40px;font-size:12px;color:var(--ink-2)">One design system, every screen size, phone, tablet and desktop admin.</div></div>`, 'wide');

export default [
{ key: 'admin', label: 'Admin Dashboard', route: '/admin', body: admin, wide: true },
{ key: 'responsive', label: 'Responsive Preview', route: '/responsive', body: responsive, wide: true },
];
