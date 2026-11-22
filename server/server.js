/**
 * GreenCycle mock API server (zero dependencies, Node 18+).
 *
 * Implements the deck's Tier-2 "Core Application Layer" as REST
 * endpoints mirroring the in-app MockBackend: auth, smart bins,
 * wallet/eco-points, marketplace, orders and the simulated payment
 * gateway. Run it to demo "app talks to a real server"; the Flutter app
 * also works fully standalone with its embedded mock backend.
 *
 *   node server/server.js   # listens on http://localhost:8080
 */

const http = require('http');
const { randomUUID } = require('crypto');

const PORT = process.env.PORT || 8080;

// ---------------------------------------------------------------- seed ---
const hashPassword = (password) => {
  let h = 0x811c9dc5;
  for (const c of password) {
    h ^= c.codePointAt(0);
    h = Math.imul(h, 0x01000193) >>> 0;
  }
  return `fnv1a-${h.toString(16)}`;
};

const users = [
  { id: 'user-amr', name: 'Amr Abdelbaqi', email: 'amr@greencycle.app', role: 'citizen', passwordHash: hashPassword('demo123') },
  { id: 'user-biz', name: 'Nile Plastics Co.', email: 'buyer@greencycle.app', role: 'business', passwordHash: hashPassword('demo123') },
  { id: 'user-emp', name: 'Omar Salah', email: 'driver@greencycle.app', role: 'employee', passwordHash: hashPassword('demo123') },
  { id: 'user-admin', name: 'GreenCycle Admin', email: 'admin@greencycle.app', role: 'admin', passwordHash: hashPassword('demo123') },
];

const bins = [
  { id: 'bin-01', name: 'MTI Campus Gate A', area: 'MTI University, Mokattam', qrCode: 'GC-BIN-01', status: 'online', fillLevels: { plastic: 0.45, metal: 0.30, paper: 0.60, other: 0.20 } },
  { id: 'bin-02', name: 'MTI Main Library', area: 'MTI University, Mokattam', qrCode: 'GC-BIN-02', status: 'online', fillLevels: { plastic: 0.70, metal: 0.25, paper: 0.80, other: 0.15 } },
  { id: 'bin-03', name: 'Nasr City Hub', area: 'Abbas El Akkad St.', qrCode: 'GC-BIN-03', status: 'online', fillLevels: { plastic: 0.55, metal: 0.50, paper: 0.40, other: 0.35 } },
  { id: 'bin-04', name: 'Maadi Corniche', area: 'Maadi, Cairo', qrCode: 'GC-BIN-04', status: 'full', fillLevels: { plastic: 0.95, metal: 0.88, paper: 0.92, other: 0.60 } },
  { id: 'bin-05', name: 'New Cairo Point', area: '5th Settlement', qrCode: 'GC-BIN-05', status: 'maintenance', fillLevels: { plastic: 0.10, metal: 0.05, paper: 0.20, other: 0.05 } },
];

const items = [
  { id: 'item-01', title: 'Shredded PET Plastic', category: 'plastic', priceEgp: 12, unit: 'kg', stockKg: 240, sellerName: 'GreenCycle Inventory', area: 'Mokattam, Cairo', isUpcycled: false },
  { id: 'item-02', title: 'Pressed Aluminum Cans', category: 'metal', priceEgp: 45, unit: 'kg', stockKg: 85, sellerName: 'GreenCycle Inventory', area: 'Mokattam, Cairo', isUpcycled: false },
  { id: 'item-03', title: 'Cardboard Bundles', category: 'paper', priceEgp: 6, unit: 'kg', stockKg: 400, sellerName: 'GreenCycle Inventory', area: 'Mokattam, Cairo', isUpcycled: false },
  { id: 'item-04', title: 'Upcycled Tote Bag', category: 'other', priceEgp: 90, unit: 'piece', stockKg: 30, sellerName: 'ReMade Egypt', area: 'Nasr City, Cairo', isUpcycled: true },
  { id: 'item-05', title: 'Bottle Desk Lamp', category: 'other', priceEgp: 150, unit: 'piece', stockKg: 12, sellerName: 'ReMade Egypt', area: 'Maadi, Cairo', isUpcycled: true },
  { id: 'item-06', title: 'HDPE Pellets', category: 'plastic', priceEgp: 18, unit: 'kg', stockKg: 120, sellerName: 'Nile Plastics Co.', area: '10th of Ramadan City', isUpcycled: false },
];

const pointsPerItem = { plastic: 10, metal: 15, paper: 8, other: 3 };
const orders = [];
const wasteRecords = [];

// -------------------------------------------------------------- routing ---
const routes = [];
const route = (method, pattern, handler) =>
  routes.push({ method, regex: new RegExp(`^${pattern}$`), handler });

const json = (res, status, body) => {
  res.writeHead(status, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify(body));
};
const notFound = (res) => json(res, 404, { error: 'not found' });

route('GET', '/api/health', (req, res) => json(res, 200, { status: 'ok', service: 'greencycle-mock-api' }));

route('POST', '/api/auth/login', (req, res, body) => {
  const user = users.find((u) => u.email === String(body.email || '').toLowerCase());
  if (!user || user.passwordHash !== hashPassword(String(body.password || ''))) {
    return json(res, 401, { error: 'Invalid credentials' });
  }
  const { passwordHash, ...safe } = user;
  json(res, 200, { user: safe, sessionToken: `sess_${randomUUID()}` });
});

route('POST', '/api/auth/register', (req, res, body) => {
  const email = String(body.email || '').toLowerCase();
  if (users.some((u) => u.email === email)) {
    return json(res, 409, { error: 'Email already registered' });
  }
  const user = {
    id: `user-${randomUUID().slice(0, 8)}`,
    name: String(body.name || ''),
    email,
    role: body.role === 'business' ? 'business' : 'citizen',
    passwordHash: hashPassword(String(body.password || '')),
  };
  users.push(user);
  const { passwordHash, ...safe } = user;
  json(res, 201, { user: safe, sessionToken: `sess_${randomUUID()}` });
});

route('GET', '/api/bins', (req, res) => json(res, 200, { bins }));

// IoT smart-bin feed: capture -> classify -> sort -> record.
route('POST', '/api/bins/([\\w-]+)/deposit', (req, res, body, binId) => {
  const bin = bins.find((b) => b.id === binId);
  if (!bin) return notFound(res);
  const category = ['plastic', 'metal', 'paper', 'other'].includes(body.category) ? body.category : 'other';
  const confidence = 0.9 + Math.random() * 0.099;
  bin.fillLevels[category] = Math.min(1, bin.fillLevels[category] + 0.02);
  const record = {
    id: `rec-${randomUUID().slice(0, 8)}`,
    binId,
    category,
    confidence: Number(confidence.toFixed(3)),
    pointsEarned: pointsPerItem[category],
    at: new Date().toISOString(),
  };
  wasteRecords.push(record);
  json(res, 201, { record });
});

route('GET', '/api/marketplace', (req, res) => json(res, 200, { items }));

route('POST', '/api/payments/authorize', (req, res, body) => {
  const digits = String(body.cardNumber || '').replace(/\s/g, '');
  if (!/^\d{16}$/.test(digits)) return json(res, 422, { success: false, error: 'Invalid card number.' });
  if (digits.endsWith('0000')) return json(res, 402, { success: false, error: 'Card declined. Please try another card.' });
  json(res, 200, { success: true, token: `pay_tok_${Math.floor(Math.random() * 999999)}` });
});

route('POST', '/api/orders', (req, res, body) => {
  const lines = Array.isArray(body.lines) ? body.lines : [];
  if (!lines.length) return json(res, 422, { error: 'Cart is empty' });
  for (const line of lines) {
    const item = items.find((i) => i.id === line.itemId);
    if (!item || line.qty > item.stockKg) {
      return json(res, 409, { error: `Not enough stock for ${line.itemId}` });
    }
  }
  let total = 0;
  for (const line of lines) {
    const item = items.find((i) => i.id === line.itemId);
    item.stockKg -= line.qty;
    total += item.priceEgp * line.qty;
  }
  const order = {
    id: `ORD-${randomUUID().slice(0, 8).toUpperCase()}`,
    buyerId: body.buyerId,
    lines,
    totalEgp: total,
    paymentMethod: body.paymentMethod === 'visa' ? 'visa' : 'cash',
    status: 'pending',
    placedAt: new Date().toISOString(),
  };
  orders.push(order);
  json(res, 201, { order });
});

route('GET', '/api/orders', (req, res) => json(res, 200, { orders }));

const server = http.createServer((req, res) => {
  const url = new URL(req.url, `http://localhost:${PORT}`);
  for (const r of routes) {
    if (r.method !== req.method) continue;
    const match = url.pathname.match(r.regex);
    if (!match) continue;
    if (req.method === 'POST') {
      let raw = '';
      req.on('data', (chunk) => (raw += chunk));
      req.on('end', () => {
        let body = {};
        try { body = JSON.parse(raw || '{}'); } catch { /* keep {} */ }
        r.handler(req, res, body, ...match.slice(1));
      });
    } else {
      r.handler(req, res, {}, ...match.slice(1));
    }
    return;
  }
  notFound(res);
});

server.listen(PORT, () => {
  console.log(`GreenCycle mock API listening on http://localhost:${PORT}`);
  console.log('Try: curl http://localhost:' + PORT + '/api/health');
});
