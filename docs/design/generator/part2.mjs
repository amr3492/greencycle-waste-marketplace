// Screens 7-11: home, scanner, result, marketplace, item details
import { sb, NAV, icons, logo, avatar, P, doc } from './helpers.mjs';

/* ---------- 7. HOME ---------- */
const act = (ic, bg, t, s, pts) => `<div style="display:flex;align-items:center;gap:12px;padding:11px 0;border-top:1px solid var(--line)">
<div style="width:38px;height:38px;border-radius:12px;background:${bg};display:flex;align-items:center;justify-content:center;flex:none">${ic}</div>
<div style="flex:1"><div style="font-size:13.5px;font-weight:700">${t}</div><div style="font-size:11px;color:var(--ink-3);margin-top:2px">${s}</div></div>
<b style="color:var(--green);font-size:13.5px">${pts}</b></div>`;

const gbtn = (to, ic, label, tint) => `<button data-to="${to}" class="card" style="display:flex;flex-direction:column;align-items:center;gap:9px;padding:16px 0 14px">
<span style="width:44px;height:44px;border-radius:14px;background:${tint};display:flex;align-items:center;justify-content:center;color:var(--green-d)">${ic}</span>
<span style="font-size:12.5px;font-weight:700">${label}</span></button>`;

const home = doc('home', 'ReCircle - Home', `${sb()}
<div class="scroll" style="display:flex;flex-direction:column;gap:11px;padding-bottom:100px">
<div style="display:flex;align-items:center;gap:10px;padding:4px 20px 0">
${logo(38, 12)}<b style="font-size:18px;letter-spacing:-.02em">ReCircle</b><span style="flex:1"></span>
<button class="card" style="width:38px;height:38px;border-radius:12px;display:flex;align-items:center;justify-content:center;color:var(--ink-2)" data-to="/points">${icons.bell(19)}</button>
<button data-to="/profile">${avatar('AA', 38, 'linear-gradient(150deg,#27B266,#0E7C42)')}</button></div>
<div style="margin:2px 20px 0;border-radius:22px;padding:18px 18px 16px;background:linear-gradient(140deg,#1C9E58,#0B6B38);color:#fff;position:relative;overflow:hidden;box-shadow:0 16px 30px rgba(15,122,64,.35)">
<div style="position:absolute;right:-24px;top:-30px;width:150px;height:150px;border-radius:50%;background:rgba(255,255,255,.10)"></div>
<div style="position:absolute;right:8px;bottom:-46px;width:110px;height:110px;border-radius:50%;background:rgba(255,255,255,.08)"></div>
<div style="font-size:12px;opacity:.85;font-weight:600">Good morning, Amr</div>
<div style="font-size:19px;font-weight:800;margin-top:3px;letter-spacing:-.01em">Together for a Cleaner World</div>
<div style="display:flex;align-items:center;gap:8px;margin-top:12px">
<span style="background:rgba(255,255,255,.16);border:1px solid rgba(255,255,255,.25);border-radius:999px;padding:6px 12px;font-size:12.5px;font-weight:700;display:flex;gap:6px;align-items:center" data-to="/points">${icons.leaf(15)} 320 Eco Points</span>
<span style="font-size:11px;opacity:.8">+45 this week</span></div></div>
<div style="display:grid;grid-template-columns:1fr 1fr;gap:12px;padding:0 20px">
<button data-to="/scan" style="grid-column:1/3;height:56px;border-radius:18px;background:linear-gradient(160deg,#24AE60,#12824A);color:#fff;display:flex;align-items:center;justify-content:center;gap:10px;font-size:16px;font-weight:800;box-shadow:0 14px 26px rgba(20,140,75,.35)">${icons.scan(24)} Scan Waste</button>
${gbtn('/bins', icons.pin(22), 'Smart Bins', 'var(--mint)')}
${gbtn('/marketplace', icons.bag(22), 'Marketplace', 'var(--mint)')}
${gbtn('/points', icons.leaf(22), 'Eco Points', 'var(--mint)')}
${gbtn('/orders', icons.box(22), 'My Orders', 'var(--mint)')}
</div>
<div class="secttl" style="margin-top:4px">Quick Actions</div>
<div style="display:flex;gap:10px;padding:0 20px">
<button class="chip" style="height:42px;flex:1;justify-content:center" data-to="/sell"><span style="color:var(--green)">${icons.tag(16)}</span>Sell</button>
<button class="chip" style="height:42px;flex:1;justify-content:center" data-to="/trades"><span style="color:var(--green)">${icons.swap(16)}</span>Trade</button>
<button class="chip" style="height:42px;flex:1;justify-content:center" data-to="/donate"><span style="color:var(--green)">${icons.gift(16)}</span>Donate</button></div>
<div class="secttl" style="margin-top:4px">Recent Activity <a data-to="/points">See all</a></div>
<div class="card" style="margin:0 20px;padding:4px 16px 6px">
<div style="display:flex;align-items:center;gap:12px;padding:11px 0">
<div style="width:38px;height:38px;border-radius:12px;background:var(--mint);display:flex;align-items:center;justify-content:center;color:var(--green-d);flex:none">${icons.recycle(19)}</div>
<div style="flex:1"><div style="font-size:13.5px;font-weight:700">Recycled Plastic Bottle</div><div style="font-size:11px;color:var(--ink-3);margin-top:2px">Today, 10:30 AM</div></div>
<b style="color:var(--green);font-size:13.5px">+10</b></div>
${act(`<span style="color:var(--orange)">${icons.gift(19)}</span>`, 'var(--orange-bg)', 'Donated Old Clothes', 'Yesterday, 5:12 PM', '+50')}
</div></div>${NAV('home')}`);

/* ---------- 8. SCANNER ---------- */
const scan = doc('scan', 'ReCircle - AI Waste Scanner', `<div class="scroll" style="background:#0C1712;position:relative">
${sb(true)}
<div style="position:absolute;top:52px;left:0;right:0;display:flex;align-items:center;padding:0 20px;z-index:5">
<button style="width:38px;height:38px;border-radius:12px;background:rgba(255,255,255,.14);color:#fff;display:flex;align-items:center;justify-content:center" data-to="/home">${icons.left(20)}</button>
<b style="flex:1;text-align:center;color:#fff;font-size:16px">Scan Waste</b>
<button style="width:38px;height:38px;border-radius:12px;background:rgba(255,255,255,.14);color:#fff;display:flex;align-items:center;justify-content:center">${icons.zap(18)}</button></div>
<div style="position:absolute;inset:0;background:radial-gradient(130% 90% at 50% 30%,#234434 0%,#12241B 55%,#0B1510 100%)"></div>
<div style="position:absolute;left:50%;top:46%;transform:translate(-50%,-50%);opacity:.92">${P.bottle(150)}</div>
<div style="position:absolute;left:50%;top:46%;transform:translate(-50%,-50%);width:252px;height:300px">
${['left:0;top:0;border-left:4px solid #4ADE80;border-top:4px solid #4ADE80;border-radius:18px 0 0 0', 'right:0;top:0;border-right:4px solid #4ADE80;border-top:4px solid #4ADE80;border-radius:0 18px 0 0', 'left:0;bottom:0;border-left:4px solid #4ADE80;border-bottom:4px solid #4ADE80;border-radius:0 0 0 18px', 'right:0;bottom:0;border-right:4px solid #4ADE80;border-bottom:4px solid #4ADE80;border-radius:0 0 18px 0'].map(s => `<span style="position:absolute;${s};width:44px;height:44px"></span>`).join('')}
<div style="position:absolute;left:12px;right:12px;top:46%;height:2px;background:linear-gradient(90deg,transparent,#4ADE80,transparent);box-shadow:0 0 12px #4ADE80"></div></div>
<div style="position:absolute;left:0;right:0;top:64%;text-align:center;color:#E9F5EE;font-size:13.5px;font-weight:600">Align the item within the frame</div>
<div style="position:absolute;left:24px;right:24px;bottom:118px;background:rgba(12,23,18,.72);border:1px solid rgba(255,255,255,.14);border-radius:14px;padding:11px 14px;color:#BFD9CB;font-size:12px;display:flex;gap:8px;align-items:center"><span style="color:#4ADE80">${icons.zap(15)}</span>Tip: Make sure the item is clear and well lit.</div>
<div style="position:absolute;left:0;right:0;bottom:34px;display:flex;align-items:center;justify-content:center;gap:56px">
<button style="width:46px;height:46px;border-radius:50%;background:rgba(255,255,255,.14);color:#fff;display:flex;align-items:center;justify-content:center">${icons.image(21)}</button>
<button data-to="/result" style="width:78px;height:78px;border-radius:50%;border:5px solid #fff;background:linear-gradient(160deg,#24AE60,#12824A);box-shadow:0 10px 26px rgba(0,0,0,.45);display:flex;align-items:center;justify-content:center;color:#fff">${icons.cam(30)}</button>
<button style="width:46px;height:46px;border-radius:50%;background:rgba(255,255,255,.14);color:#fff;display:flex;align-items:center;justify-content:center">${icons.zap(20)}</button></div>
</div><div class="homebar" style="background:rgba(255,255,255,.4)"></div>`);

/* ---------- 9. RESULT ---------- */
const row = (k, v, g = false) => `<div style="display:flex;justify-content:space-between;padding:9px 0;border-top:1px solid var(--line);font-size:13.5px"><span style="color:var(--ink-2)">${k}</span><b style="${g ? 'color:var(--green)' : ''}">${v}</b></div>`;
const result = doc('result', 'ReCircle - Scan Result', `${sb()}
<div class="scroll" style="display:flex;flex-direction:column;gap:14px;padding-bottom:16px">
<div class="ab"><button class="ic" data-to="/scan">${icons.left(19)}</button><span class="ttl">Scan Result</span><span class="sp"></span></div>
<div style="margin:0 20px;border-radius:22px;background:linear-gradient(150deg,#EAF7EF,#DDF0E5);padding:22px;display:flex;justify-content:center;border:1px solid var(--mint-2)">${P.bottle(120)}</div>
<div style="display:flex;align-items:center;gap:10px;padding:0 20px">
<span style="width:34px;height:34px;border-radius:11px;background:var(--mint);display:flex;align-items:center;justify-content:center;color:var(--green-d)">${icons.recycle(18)}</span>
<div style="flex:1"><b style="font-size:19px;letter-spacing:-.01em">Plastic Bottle</b><div style="font-size:11.5px;color:var(--ink-3);margin-top:1px">Confidence 96%</div></div>
<span style="background:var(--mint);color:var(--green-d);font-size:11.5px;font-weight:800;padding:6px 11px;border-radius:999px">Recyclable</span></div>
<div class="card" style="margin:0 20px;padding:8px 16px 10px">
<div style="display:flex;justify-content:space-between;padding:9px 0;font-size:13.5px"><span style="color:var(--ink-2)">Category</span><b>Plastic</b></div>
${row('Eco Points', '+10 points', true)}
${row('Disposal Guide', 'Blue recycling bin')}</div>
<div style="margin:0 20px;background:var(--mint);border-radius:16px;padding:12px 14px;font-size:12.5px;line-height:1.5;color:#14532D;display:flex;gap:9px"><span style="color:var(--green-d);flex:none">${icons.leaf(17)}</span>Rinse the bottle, remove the cap, and place it in the plastic recycling bin.</div>
<div style="padding:0 20px;display:flex;flex-direction:column;gap:10px">
<button class="btn sm" data-to="/bins">${icons.pin(17)} Find Smart Bin</button>
<div style="display:flex;gap:10px"><button class="btn sm ghost" style="flex:1" data-to="/sell">${icons.tag(15)} Sell Item</button>
<button class="btn sm ghost" style="flex:1" data-to="/donate">${icons.gift(15)} Donate</button></div>
<button style="color:var(--green);font-size:13px;font-weight:700;padding:4px" data-to="/scan">Scan Another</button></div>
</div>${NAV('scan')}`);

/* ---------- 10. MARKETPLACE ---------- */
const prod = (to, img, bg, name, price, seller, rate) => `<button class="card" data-to="${to}" style="text-align:left;overflow:hidden">
<div style="background:${bg};display:flex;justify-content:center;padding:8px 0 6px;position:relative">${img}
<span style="position:absolute;top:7px;right:7px;width:26px;height:26px;border-radius:50%;background:#fff;display:flex;align-items:center;justify-content:center;color:var(--ink-3);box-shadow:var(--sh)">${icons.heart(13)}</span></div>
<div style="padding:8px 11px 10px"><b style="font-size:12.5px">${name}</b>
<div style="display:flex;align-items:center;justify-content:space-between;margin-top:4px"><b style="color:var(--green-d);font-size:13px">${price}</b>
<span style="display:flex;align-items:center;gap:3px;font-size:10.5px;color:var(--ink-2);font-weight:600">${icons.star(10)} ${rate}</span></div>
<div style="font-size:10px;color:var(--ink-3);margin-top:2px">${seller}</div></div></button>`;
const marketplace = doc('marketplace', 'ReCircle - Marketplace', `${sb()}
<div class="scroll" style="display:flex;flex-direction:column;gap:13px;padding-bottom:104px">
<div class="ab" style="padding-bottom:0"><span class="ttl" style="text-align:left;font-size:20px;font-weight:800">Marketplace</span>
<button class="ic" data-to="/orders">${icons.cart(18)}</button></div>
<div style="margin:0 20px;height:46px;border-radius:14px;background:#fff;border:1.5px solid var(--line);display:flex;align-items:center;gap:9px;padding:0 14px;color:var(--ink-3)">${icons.search(17)}<span style="font-size:13px">Search for items...</span></div>
<div class="chips" style="padding:0 20px">
<span class="chip t on">All</span><span class="chip t">Plastic</span><span class="chip t">Paper</span><span class="chip t">Glass</span><span class="chip t">Metal</span><span class="chip t">Electronics</span></div>
<div style="display:grid;grid-template-columns:1fr 1fr;gap:12px;padding:0 20px">
${prod('/item', P.bottle(58), '#EAF4FB', 'Plastic Bottles (10)', 'EGP 10', 'Sara Ahmed', '4.8')}
${prod('/item', P.box(60), '#FBF3E8', 'Cardboard Box', 'EGP 15', 'Omar Khaled', '4.5')}
${prod('/item', P.jar(56), '#EDF6F0', 'Glass Jars Set', 'EGP 20', 'Laila Hassan', '4.9')}
${prod('/item', P.can(56), '#EFF2F5', 'Aluminum Cans', 'EGP 25', 'Youssef Ali', '4.6')}
${prod('/item', P.phone(54), '#EFEAFE', 'Old Smartphone', 'EGP 450', 'Karim Adel', '4.7')}
${prod('/item', P.paper(58), '#F8F4EA', 'Paper Stack', 'EGP 5', 'Mona Samy', '4.4')}
</div></div>${NAV('market')}`);

/* ---------- 11. ITEM DETAILS ---------- */
const spec = (k, v) => `<div style="flex:1"><div style="font-size:10.5px;color:var(--ink-3);font-weight:600">${k}</div><b style="font-size:13px">${v}</b></div>`;
const item = doc('item', 'ReCircle - Item Details', `${sb()}
<div class="scroll" style="display:flex;flex-direction:column;gap:13px;padding-bottom:104px">
<div style="position:relative;background:#FBF3E8;margin:0 0;padding:26px 0 20px;display:flex;justify-content:center">
<button class="ic" style="position:absolute;top:8px;left:20px;background:#fff" data-to="/marketplace">${icons.left(19)}</button>
<button class="ic" style="position:absolute;top:8px;right:20px;background:#fff;color:var(--red)">${icons.heart(18)}</button>
${P.box(140)}</div>
<div style="display:flex;align-items:flex-start;gap:10px;padding:0 20px"><div style="flex:1">
<b style="font-size:20px;letter-spacing:-.01em">Cardboard Box</b>
<div style="display:flex;align-items:center;gap:5px;margin-top:5px;font-size:12px;color:var(--ink-2)">${icons.star(12)} <b>4.5</b> (24 reviews)</div></div>
<b style="color:var(--green-d);font-size:20px">EGP 15</b></div>
<div style="display:flex;align-items:center;gap:10px;padding:0 20px">${avatar('SA', 40)}
<div style="flex:1"><b style="font-size:13.5px">Sara Ahmed</b><div style="font-size:11px;color:var(--ink-3);margin-top:1px">Verified seller · Cairo</div></div>
<button class="chip" style="height:34px" data-to="/profile">View</button></div>
<div class="card" style="margin:0 20px;padding:14px 16px">
<div style="font-size:12.5px;line-height:1.55;color:var(--ink-2)">Clean and good condition cardboard boxes, suitable for recycling or reuse. Pickup available from Nasr City.</div>
<div style="display:flex;gap:10px;margin-top:12px;padding-top:12px;border-top:1px solid var(--line)">
${spec('Category', 'Paper')}${spec('Condition', 'Good')}${spec('Quantity', '10 pieces')}</div></div>
<div style="margin:0 20px;background:var(--mint);border-radius:16px;padding:11px 14px;font-size:12px;color:#14532D;display:flex;gap:9px;align-items:center"><span style="color:var(--green-d);flex:none">${icons.leaf(17)}</span><span><b>Eco impact:</b> reusing this saves ~2.4 kg of CO&#8322; and earns +15 points.</span></div>
<div style="padding:0 20px;display:flex;flex-direction:column;gap:10px">
<button class="btn sm" data-to="/orders">Buy Now</button>
<div style="display:flex;gap:10px"><button class="btn sm ghost" style="flex:1" data-to="/trades">${icons.swap(15)} Trade</button>
<button class="btn sm ghost" style="flex:1" data-to="/donate">${icons.gift(15)} Donate</button></div></div>
</div>${NAV('market')}`);

export default [
{ key: 'home', label: 'Home', route: '/home', body: home },
{ key: 'scan', label: 'Waste Scanner', route: '/scan', body: scan },
{ key: 'result', label: 'Scan Result', route: '/result', body: result },
{ key: 'marketplace', label: 'Marketplace', route: '/marketplace', body: marketplace },
{ key: 'item', label: 'Item Details', route: '/item', body: item },
];
