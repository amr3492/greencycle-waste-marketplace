# ReCircle — UI/UX Design (v2, 20 screens)

Design package for **ReCircle**, the green e-commerce and smart waste management app
(sister design to GreenCycle). Created November 2026 as a high-fidelity, clickable
UI design prototype for the GreenCycle graduation project. This repository addition
contains design artifacts only; it does not integrate the UI into the Flutter app.

**Live clickable prototype:** https://files.instinct.com/wcqwxwsq4mux-recircle-app-ui-8-screen-prototype

**Preview:** [Open the clickable prototype](https://files.instinct.com/wcqwxwsq4mux-recircle-app-ui-8-screen-prototype)

All people, products, NGOs, prices (EGP), points and bin data in the prototype are fictional sample content for the graduation project. The UI and interactions are a design prototype, not a live service, production integration, or validated AI result.

## What's inside

| Folder | Contents |
| --- | --- |
| `screens/` | PNG screen gallery is not included in this repository yet. View all 20 screens in the clickable prototype above. |
| `prototype/` | All 20 screens as standalone HTML, one shared `style.css`, and `hotspots.json` with the tappable areas and routes. |
| `generator/` | The Node scripts that produced everything (`helpers.mjs` design system + icons, `part1-4.mjs` screen markup, `build.mjs` renders PNGs and extracts hotspots, `gen-page.mjs` emits the hosted prototype page). Run `node build.mjs` with Playwright + Chrome to regenerate. |

## The 20 screens

1. **Splash** — logo, "Smarter Waste, Greener Tomorrow"
2–4. **Onboarding 1–3** — Scan & Identify / Earn Eco-Points / Buy, Sell & Trade
5. **Login** · 6. **Sign Up** — email + social, cross-linked
7. **Home** — greeting, eco-points banner, Scan Waste CTA, 4 quick destinations, Sell/Trade/Donate actions, recent activity, bottom nav with center scan FAB
8. **Waste Scanner** — camera UI, scanning frame with laser line, flash/gallery/shutter, tips
9. **Scan Result** — Plastic Bottle, 96% confidence, +10 pts, disposal guide, Find Smart Bin / Sell / Donate / Scan Another
10. **Marketplace** — search, filters (All/Plastic/Paper/Glass/Metal/Electronics), 6 product cards with seller + rating
11. **Item Details** — photo, price, seller card, specs (category/condition/quantity), eco impact, Buy Now / Trade / Donate
12. **Sell Item** — photo upload, name, category, price, quantity, condition, publish
13. **Smart Bin Map** — map with green/orange/red bin pins, legend, Bin #102 card (60% full, distance, directions)
14. **Eco Points** — 320 pts balance card, level, History/Rewards tabs, transaction list, next reward
15. **Profile** — user card, stats (listings/trades/donations), menu, logout
16. **Orders** — Buying/Selling tabs, order statuses (on the way, completed, cancelled)
17. **Trades** — exchange offers with Propose Trade
18. **Donate** — NGO cards (Resala, Egyptian Food Bank, Banati), category filters
19. **Admin Dashboard** (desktop) — KPI cards, waste-by-category donut, bin status bars, recent activity table
20. **Responsive Preview** — mobile / tablet / desktop side by side

## Design system

- **Colors:** primary green `#1E9E57`, deep green `#0F7A40` / `#0A5C30`, mint surfaces `#E8F5EC` / `#D7EEDF`, ink `#122019`, secondary text `#5B6B60`, background `#F4F7F4`; status colors: available `#1E9E57`, filling up `#F2994A`, full `#E2574C`
- **Type:** Inter (400/500/600/700/800), tight tracking on headings
- **Shape:** 20–22px card radii, 14–16px controls, pill chips, soft shadows `0 10px 24px rgba(18,32,25,.08)`
- **Iconography:** 1.8px stroke line icons + custom flat SVG illustrations (no third-party brand or stock assets)

## Prototype flows

- First run: Splash → Onboarding 1–3 → Login / Sign Up → Home
- Recycle: Home → Scan Waste → Scan Result → Find Smart Bin
- Shop: Home → Marketplace → Item Details → Buy Now → Orders
- Sell / Trade / Donate: Home quick actions → Sell Item, Trades, Donate
- Account: Profile → My Orders / My Trades / My Donations / Eco Points

All people, products, NGOs, prices (EGP), points and bin data are fictional sample
content for the graduation project.
