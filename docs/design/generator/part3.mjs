// Screens 12-18: sell, bins, points, profile, orders, trades, donate
import { sb, NAV, icons, avatar, P, doc } from './helpers.mjs';

const ab = (t, back = '/home', extra = '<span class="sp"></span>') =>
`<div class="ab"><button class="ic" data-to="${back}">${icons.left(19)}</button><span class="ttl">${t}</span>${extra}</div>`;

/* ---------- 12. SELL ---------- */
const fld = (label, inner, tall = false) => `<div class="fld"><label>${label}</label><div class="box${tall ? ' tall' : ''}">${inner}</div></div>`;
const sell = doc('sell', 'ReCircle - Sell Item', `${sb()}
<div class="scroll" style="display:flex;flex-direction:column;gap:10px;padding-bottom:100px">
${ab('Sell Item', '/home', `<button class="ic">${icons.doc(17)}</button>`)}
<div style="margin:0 20px;height:88px;border-radius:18px;border:2px dashed var(--mint-2);background:#fff;display:flex;flex-direction:column;align-items:center;justify-content:center;gap:6px;color:var(--ink-3)">
<span style="width:38px;height:38px;border-radius:12px;background:var(--mint);display:flex;align-items:center;justify-content:center;color:var(--green-d)">${icons.cam(20)}</span>
<b style="font-size:12.5px;color:var(--ink-2)">Add Photos</b></div>
<div style="padding:0 20px;display:flex;flex-direction:column;gap:10px">
${fld('Item Name', `<span class="ph">e.g. Plastic Bottles</span>`)}
${fld('Category', `<span class="ph">Select Category</span><span style="color:var(--ink-3)">${icons.right(16)}</span>`)}
<div style="display:flex;gap:12px">
<div class="fld" style="flex:1"><label>Price (EGP)</label><div class="box"><span class="ph">Enter price</span></div></div>
<div class="fld" style="flex:1"><label>Quantity</label><div class="box"><span class="ph">1</span></div></div></div>
${fld('Condition', `<div style="display:flex;gap:6px;width:100%"><span class="chip on" style="height:30px;font-size:11.5px;padding:0 12px">Like New</span><span class="chip" style="height:30px;font-size:11.5px;padding:0 12px">Good</span><span class="chip" style="height:30px;font-size:11.5px;padding:0 12px">Used</span></div>`)}
${fld('Description', `<span class="ph">Enter description...</span>`, true).replace('tall"', 'tall" style="height:74px"')}
<button class="btn sm" data-to="/marketplace" style="margin-top:2px">Publish Item</button></div>
</div>${NAV('market')}`);

/* ---------- 13. SMART BINS ---------- */
const pinM = (x, y, c, big = false) => `<div style="position:absolute;left:${x}%;top:${y}%;transform:translate(-50%,-100%)">
<svg width="${big ? 40 : 30}" height="${big ? 46 : 35}" viewBox="0 0 30 36"><path d="M15 1C7.8 1 2 6.8 2 14c0 9.5 13 21 13 21s13-11.5 13-21C28 6.8 22.2 1 15 1Z" fill="${c}"/><circle cx="15" cy="14" r="5.5" fill="#fff"/></svg></div>`;
const bins = doc('bins', 'ReCircle - Smart Bins', `${sb()}
<div class="scroll" style="position:relative">
<div style="position:absolute;inset:0;background:#E6EFE8">
<svg width="390" height="844" viewBox="0 0 390 844" style="position:absolute;inset:0">
<path d="M-20 200 C120 170 260 240 410 190" stroke="#fff" stroke-width="26" fill="none"/>
<path d="M-20 430 C140 400 240 500 410 440" stroke="#fff" stroke-width="34" fill="none"/>
<path d="M120 -20 C140 200 90 500 150 864" stroke="#fff" stroke-width="22" fill="none"/>
<path d="M300 -20 C280 260 330 560 290 864" stroke="#fff" stroke-width="18" fill="none"/>
<circle cx="70" cy="300" r="46" fill="#CFE7D4"/><circle cx="330" cy="620" r="58" fill="#CFE7D4"/>
<circle cx="240" cy="120" r="30" fill="#D9EDDE"/>
<path d="M-20 200 C120 170 260 240 410 190" stroke="#D5E2D8" stroke-width="2" fill="none" stroke-dasharray="10 8"/>
<path d="M-20 430 C140 400 240 500 410 440" stroke="#D5E2D8" stroke-width="2" fill="none" stroke-dasharray="10 8"/></svg>
${pinM(32, 24, '#1E9E57')}${pinM(66, 34, '#F2994A')}${pinM(48, 52, '#E2574C')}${pinM(76, 62, '#1E9E57')}${pinM(24, 68, '#F2994A')}
<div style="position:absolute;left:56%;top:40%;transform:translate(-50%,-100%)">${pinM(0, 0, '#0F7A40', true)}</div></div>
<div style="position:absolute;top:52px;left:0;right:0;display:flex;align-items:center;padding:0 20px;z-index:5">
<button class="ic" data-to="/home" style="box-shadow:var(--sh)">${icons.left(19)}</button>
<span class="ttl" style="flex:1;text-align:center;font-size:16.5px;font-weight:800">Smart Bins</span>
<button class="ic" style="box-shadow:var(--sh)">${icons.search(17)}</button></div>
<div class="card" style="position:absolute;left:16px;right:16px;bottom:104px;padding:16px;z-index:6">
<div style="display:flex;gap:13px;align-items:center">
<div style="width:52px;height:52px;border-radius:15px;background:var(--mint);display:flex;align-items:center;justify-content:center;color:var(--green-d);flex:none">
<svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9"><path d="M5 8h14l-1.4 12a2 2 0 0 1-2 1.8H8.4a2 2 0 0 1-2-1.8L5 8Z"/><path d="M3.5 8h17M9 8V5.5A1.5 1.5 0 0 1 10.5 4h3A1.5 1.5 0 0 1 15 5.5V8"/><path d="M12 12l-2 3h2l-.8 3 2.8-3.6h-2l1-2.4" stroke-linecap="round" stroke-linejoin="round"/></svg></div>
<div style="flex:1"><div style="display:flex;align-items:center;gap:8px"><b style="font-size:15.5px">Bin #102</b>
<span style="background:var(--orange-bg);color:#B36A1E;font-size:10px;font-weight:800;padding:3px 8px;border-radius:999px">60% Full</span></div>
<div style="font-size:12px;color:var(--ink-2);margin-top:3px">Engineering Campus, Cairo University</div>
<div style="font-size:11px;color:var(--ink-3);margin-top:2px">350 m away · Accepts plastic, paper</div></div></div>
<div style="height:6px;border-radius:3px;background:var(--mint-2);margin:12px 0"><div style="width:60%;height:100%;border-radius:3px;background:linear-gradient(90deg,#F2B36A,#F2994A)"></div></div>
<button class="btn sm" data-to="/result">${icons.pin(16)} Get Directions</button></div>
<div class="card" style="position:absolute;top:104px;right:20px;z-index:5;padding:9px 12px;display:flex;flex-direction:column;gap:6px;font-size:10.5px;font-weight:700;color:var(--ink-2)">
<span style="display:flex;align-items:center;gap:6px"><i style="width:9px;height:9px;border-radius:50%;background:#1E9E57"></i>Available</span>
<span style="display:flex;align-items:center;gap:6px"><i style="width:9px;height:9px;border-radius:50%;background:#F2994A"></i>Filling Up</span>
<span style="display:flex;align-items:center;gap:6px"><i style="width:9px;height:9px;border-radius:50%;background:#E2574C"></i>Full</span></div>
</div>${NAV('bins')}`);

/* ---------- 14. ECO POINTS ---------- */
const his = (ic, bg, col, t, s, v, neg = false) => `<div style="display:flex;align-items:center;gap:12px;padding:11px 0;border-top:1px solid var(--line)">
<div style="width:38px;height:38px;border-radius:12px;background:${bg};color:${col};display:flex;align-items:center;justify-content:center;flex:none">${ic}</div>
<div style="flex:1"><div style="font-size:13.5px;font-weight:700">${t}</div><div style="font-size:11px;color:var(--ink-3);margin-top:2px">${s}</div></div>
<b style="font-size:13.5px;color:${neg ? 'var(--red)' : 'var(--green)'}">${v}</b></div>`;
const points = doc('points', 'ReCircle - Eco Points', `${sb()}
<div class="scroll" style="display:flex;flex-direction:column;gap:14px;padding-bottom:104px">
${ab('Eco Points', '/home', `<button class="ic">${icons.clock(17)}</button>`)}
<div style="margin:0 20px;border-radius:22px;padding:20px;background:linear-gradient(140deg,#1C9E58,#0B6B38);color:#fff;position:relative;overflow:hidden;box-shadow:0 16px 30px rgba(15,122,64,.35)">
<div style="position:absolute;right:-30px;top:-40px;width:150px;height:150px;border-radius:50%;background:rgba(255,255,255,.10)"></div>
<div style="font-size:12px;opacity:.85;font-weight:600">Your Balance</div>
<div style="display:flex;align-items:flex-end;gap:8px;margin-top:4px"><span style="font-size:40px;font-weight:800;letter-spacing:-.02em;line-height:1">320</span><span style="font-size:13px;font-weight:600;opacity:.9;padding-bottom:5px">Eco Points</span></div>
<div style="display:flex;align-items:center;gap:8px;margin-top:12px;font-size:11.5px"><span style="background:rgba(255,255,255,.16);border-radius:999px;padding:5px 11px;font-weight:700">Level: Green Hero</span>
<span style="opacity:.85">80 pts to next reward</span></div>
<div style="position:absolute;right:18px;top:20px;width:52px;height:52px;border-radius:50%;background:rgba(255,255,255,.16);display:flex;align-items:center;justify-content:center">${icons.leaf(26)}</div></div>
<div style="display:flex;gap:8px;padding:0 20px">
<span class="chip on" style="flex:1;justify-content:center;height:40px">History</span>
<span class="chip" style="flex:1;justify-content:center;height:40px">Rewards</span></div>
<div class="card" style="margin:0 20px;padding:4px 16px 8px">
<div style="display:flex;align-items:center;gap:12px;padding:11px 0">
<div style="width:38px;height:38px;border-radius:12px;background:var(--mint);color:var(--green-d);display:flex;align-items:center;justify-content:center;flex:none">${icons.recycle(18)}</div>
<div style="flex:1"><div style="font-size:13.5px;font-weight:700">Recycled Plastic Bottle</div><div style="font-size:11px;color:var(--ink-3);margin-top:2px">Today, 10:30 AM</div></div>
<b style="font-size:13.5px;color:var(--green)">+10</b></div>
${his(icons.gift(18), 'var(--orange-bg)', 'var(--orange)', 'Donated Old Clothes', 'Yesterday, 5:12 PM', '+50')}
${his(icons.box(18), 'var(--mint)', 'var(--green-d)', 'Sold Cardboard', 'Mar 10, 2026', '+20')}
${his(icons.tag(18), 'var(--red-bg)', 'var(--red)', 'Used for Discount', 'Mar 8, 2026', '-30', true)}
</div>
<div style="margin:0 20px;background:#fff;border-radius:18px;border:1.5px dashed var(--mint-2);padding:13px 15px;display:flex;align-items:center;gap:11px">
<span style="color:var(--green-d)">${icons.gift(20)}</span>
<div style="flex:1;font-size:12px;color:var(--ink-2)"><b style="color:var(--ink);font-size:12.5px">Next reward: EGP 20 voucher</b><br>Keep recycling to unlock it.</div>
<b style="color:var(--green);font-size:12px">80 pts left</b></div>
</div>${NAV('home')}`);

/* ---------- 15. PROFILE ---------- */
const mrow = (ic, t, to, col = 'var(--ink-2)') => `<button data-to="${to}" style="display:flex;align-items:center;gap:12px;width:100%;padding:13px 0;border-top:1px solid var(--line);text-align:left">
<span style="color:${col};display:flex">${ic}</span><b style="flex:1;font-size:14px;font-weight:600;color:var(--ink)">${t}</b>
<span style="color:var(--ink-3)">${icons.right(16)}</span></button>`;
const profile = doc('profile', 'ReCircle - Profile', `${sb()}
<div class="scroll" style="display:flex;flex-direction:column;gap:14px;padding-bottom:104px">
${ab('Profile', '/home', `<button class="ic">${icons.bell(17)}</button>`)}
<div style="display:flex;flex-direction:column;align-items:center;gap:9px">
<div style="position:relative">${avatar('AA', 86, 'linear-gradient(150deg,#27B266,#0E7C42)')}
<span style="position:absolute;bottom:0;right:0;width:26px;height:26px;border-radius:50%;background:var(--green);border:3px solid var(--bg);display:flex;align-items:center;justify-content:center;color:#fff">${icons.check(11)}</span></div>
<b style="font-size:19px;letter-spacing:-.01em">Amr Abdelbaki</b>
<span style="font-size:12.5px;color:var(--ink-2)">amr@recircle.app</span>
<span style="background:var(--mint);color:var(--green-d);font-size:12px;font-weight:800;padding:7px 14px;border-radius:999px;display:flex;gap:6px;align-items:center" data-to="/points">${icons.leaf(14)} 320 Eco Points</span></div>
<div style="display:flex;gap:10px;padding:0 20px">
${[['12', 'Listings'], ['5', 'Trades'], ['8', 'Donations']].map(([n, l]) => `<div class="card" style="flex:1;padding:12px 0;text-align:center"><b style="font-size:17px;color:var(--green-d)">${n}</b><div style="font-size:10.5px;color:var(--ink-3);font-weight:600;margin-top:2px">${l}</div></div>`).join('')}</div>
<div class="card" style="margin:0 20px;padding:4px 16px 6px">
${mrow(icons.box(18), 'My Items', '/marketplace')}
${mrow(icons.cart(18), 'My Orders', '/orders')}
${mrow(icons.swap(18), 'My Trades', '/trades')}
${mrow(icons.gift(18), 'My Donations', '/donate')}
${mrow(icons.gear(18), 'Settings', '/profile')}
${mrow(icons.help(18), 'Help &amp; Support', '/profile')}
</div>
<div style="padding:0 20px"><button class="btn sm" data-to="/login" style="background:var(--red-bg);color:var(--red);box-shadow:none">${icons.out(17)} Logout</button></div>
</div>${NAV('profile')}`);

/* ---------- 16. ORDERS ---------- */
const orow = (img, bg, t, price, st, stc, stbg, date) => `<div style="display:flex;align-items:center;gap:12px;padding:12px 0;border-top:1px solid var(--line)">
<div style="width:58px;height:58px;border-radius:14px;background:${bg};display:flex;align-items:center;justify-content:center;flex:none">${img}</div>
<div style="flex:1"><b style="font-size:13.5px">${t}</b><div style="font-size:11.5px;color:var(--ink-3);margin-top:3px">${price} · ${date}</div></div>
<span style="background:${stbg};color:${stc};font-size:10.5px;font-weight:800;padding:5px 10px;border-radius:999px">${st}</span></div>`;
const orders = doc('orders', 'ReCircle - My Orders', `${sb()}
<div class="scroll" style="display:flex;flex-direction:column;gap:13px;padding-bottom:104px">
${ab('My Orders', '/profile')}
<div style="display:flex;gap:8px;padding:0 20px">
<span class="chip on" style="flex:1;justify-content:center;height:40px">Buying</span>
<span class="chip" style="flex:1;justify-content:center;height:40px">Selling</span></div>
<div class="card" style="margin:0 20px;padding:4px 16px 8px">
<div style="display:flex;align-items:center;gap:12px;padding:12px 0">
<div style="width:58px;height:58px;border-radius:14px;background:#EAF4FB;display:flex;align-items:center;justify-content:center;flex:none">${P.bottle(38)}</div>
<div style="flex:1"><b style="font-size:13.5px">Plastic Bottles (10)</b><div style="font-size:11.5px;color:var(--ink-3);margin-top:3px">EGP 10 · Mar 12, 2026</div></div>
<span style="background:#E8F0FE;color:#2B5FC7;font-size:10.5px;font-weight:800;padding:5px 10px;border-radius:999px">On the way</span></div>
${orow(P.box(40), '#FBF3E8', 'Cardboard Box', 'EGP 15', 'Completed', 'var(--green-d)', 'var(--mint)', 'Mar 10, 2026')}
${orow(P.jar(38), '#EDF6F0', 'Glass Jars Set', 'EGP 20', 'Completed', 'var(--green-d)', 'var(--mint)', 'Mar 4, 2026')}
${orow(P.can(38), '#EFF2F5', 'Aluminum Cans', 'EGP 25', 'Cancelled', 'var(--red)', 'var(--red-bg)', 'Feb 26, 2026')}
</div>
<div style="margin:0 20px;background:var(--mint);border-radius:16px;padding:12px 14px;font-size:12px;color:#14532D;display:flex;gap:9px;align-items:center"><span style="color:var(--green-d)">${icons.truck(18)}</span>Your bottles arrive today before 6 PM. +10 points on delivery.</div>
</div>${NAV('profile')}`);

/* ---------- 17. TRADES ---------- */
const trow = (a, b, ta, tb, who) => `<div class="card" style="padding:13px 14px;display:flex;align-items:center;gap:10px">
<div style="flex:1;text-align:center"><div style="background:#FBF3E8;border-radius:13px;padding:9px 0;display:flex;justify-content:center">${a}</div><b style="font-size:11.5px;display:block;margin-top:6px">${ta}</b></div>
<span style="color:var(--green);flex:none">${icons.swap(22)}</span>
<div style="flex:1;text-align:center"><div style="background:#EFF2F5;border-radius:13px;padding:9px 0;display:flex;justify-content:center">${b}</div><b style="font-size:11.5px;display:block;margin-top:6px">${tb}</b></div></div>`;
const trades = doc('trades', 'ReCircle - Trade', `${sb()}
<div class="scroll" style="display:flex;flex-direction:column;gap:13px;padding-bottom:104px">
${ab('Trade', '/home')}
<div style="display:flex;gap:8px;padding:0 20px">
<span class="chip on" style="flex:1;justify-content:center;height:40px">Available</span>
<span class="chip" style="flex:1;justify-content:center;height:40px">My Trades</span></div>
<div style="padding:0 20px;display:flex;flex-direction:column;gap:12px">
${trow(P.box(46), P.can(46), 'Cardboard Box', 'Aluminum Cans')}
<div style="display:flex;align-items:center;gap:9px;margin-top:-4px">${avatar('OK', 30, 'linear-gradient(150deg,#3B82C4,#8B5CF6)')}<span style="font-size:12px;color:var(--ink-2)"><b>Omar Khaled</b> · 1.2 km away</span><span style="flex:1"></span>
<button class="btn sm" style="width:auto;height:38px;padding:0 16px;font-size:12.5px" data-to="/item">Propose Trade</button></div>
${trow(P.jar(44), P.bottle(44), 'Glass Jars Set', 'Plastic Bottles')}
<div style="display:flex;align-items:center;gap:9px;margin-top:-4px">${avatar('LH', 30, 'linear-gradient(150deg,#F2994A,#E2574C)')}<span style="font-size:12px;color:var(--ink-2)"><b>Laila Hassan</b> · 2.8 km away</span><span style="flex:1"></span>
<button class="btn sm" style="width:auto;height:38px;padding:0 16px;font-size:12.5px" data-to="/item">Propose Trade</button></div>
</div>
<div style="margin:0 20px;background:var(--mint);border-radius:16px;padding:12px 14px;font-size:12px;color:#14532D;display:flex;gap:9px;align-items:center"><span style="color:var(--green-d)">${icons.swap(17)}</span>Successful trades earn +25 points for both sides.</div>
</div>${NAV('profile')}`);

/* ---------- 18. DONATE ---------- */
const ngo = (ini, g, name, cause, need) => `<div class="card" style="padding:13px 14px;display:flex;align-items:center;gap:12px">
${avatar(ini, 46, g)}
<div style="flex:1"><b style="font-size:14px">${name}</b><div style="font-size:11.5px;color:var(--ink-2);margin-top:2px">${cause}</div>
<div style="font-size:10.5px;color:var(--green-d);font-weight:700;margin-top:3px">Needs: ${need}</div></div>
<button class="btn sm" style="width:auto;height:38px;padding:0 14px;font-size:12px" data-to="/points">Donate</button></div>`;
const donate = doc('donate', 'ReCircle - Donate', `${sb()}
<div class="scroll" style="display:flex;flex-direction:column;gap:14px;padding-bottom:104px">
${ab('Donate', '/home')}
<div style="margin:0 20px;border-radius:22px;padding:18px;background:linear-gradient(140deg,#1C9E58,#0B6B38);color:#fff;position:relative;overflow:hidden">
<div style="position:absolute;right:-24px;top:-30px;width:120px;height:120px;border-radius:50%;background:rgba(255,255,255,.10)"></div>
<div style="display:flex;align-items:center;gap:12px">
<span style="width:46px;height:46px;border-radius:15px;background:rgba(255,255,255,.16);display:flex;align-items:center;justify-content:center;flex:none">${icons.gift(24)}</span>
<div><b style="font-size:16.5px">Support NGOs</b><div style="font-size:12px;opacity:.9;margin-top:3px">Donate reusable items to help communities.</div></div></div></div>
<div style="display:flex;gap:8px;padding:0 20px">
<span class="chip on" style="height:34px;font-size:12px">All</span><span class="chip" style="height:34px;font-size:12px">Clothes</span><span class="chip" style="height:34px;font-size:12px">Food</span><span class="chip" style="height:34px;font-size:12px">Furniture</span></div>
<div style="padding:0 20px;display:flex;flex-direction:column;gap:11px">
${ngo('RS', 'linear-gradient(150deg,#27B266,#0E7C42)', 'Resala Charity', 'Clothes and household items for families in need.', 'Clothes, shoes')}
${ngo('EF', 'linear-gradient(150deg,#F2994A,#E2574C)', 'Egyptian Food Bank', 'Fighting hunger across Egypt since 2006.', 'Canned food')}
${ngo('BC', 'linear-gradient(150deg,#3B82C4,#8B5CF6)', 'Banati Foundation', 'Supporting children with school supplies.', 'Books, bags')}
</div>
<div style="margin:0 20px;background:var(--mint);border-radius:16px;padding:12px 14px;font-size:12px;color:#14532D;display:flex;gap:9px;align-items:center"><span style="color:var(--green-d)">${icons.leaf(17)}</span>Every donation earns +50 points and a thank-you badge.</div>
</div>${NAV('profile')}`);

export default [
{ key: 'sell', label: 'Sell Item', route: '/sell', body: sell },
{ key: 'bins', label: 'Smart Bin Map', route: '/bins', body: bins },
{ key: 'points', label: 'Eco Points', route: '/points', body: points },
{ key: 'profile', label: 'Profile', route: '/profile', body: profile },
{ key: 'orders', label: 'Orders', route: '/orders', body: orders },
{ key: 'trades', label: 'Trades', route: '/trades', body: trades },
{ key: 'donate', label: 'Donate', route: '/donate', body: donate },
];
