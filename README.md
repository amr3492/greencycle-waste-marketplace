# GreenCycle — Green E-commerce Mobile Application for Wastes

> Towards a Sustainable World

Graduation project implementation: a cross-platform mobile app that connects
smart waste bins (automated AI segregation) with a real-time marketplace for
recyclable materials, rewarding citizens with redeemable eco-points.

**MTI University — Faculty of Computers & Artificial Intelligence**
Academic year 2025/2026

| Role | Name |
| --- | --- |
| Academic supervisor | Prof. Dr. Abdelmonem Fouda |
| Teaching assistants | Eng. Zahra Soliman, Eng. Ahmed Gamal |
| Team | Malak Ehab, Hana Hassan, Marwan Hany, Mohamed Mohamed, Abdallah Ahmed, Omar Salah, Nill Ibrahim, Amr Abdelbaqi |

---

## What the app does

1. **Citizens** throw recyclables into a smart bin, scan its QR code, and
   instantly receive **eco-points** in a digital wallet.
2. The **smart bin** captures, classifies (Plastic / Metal / Paper / Other)
   and physically sorts each item, and publishes the sorted inventory.
3. **Buyers and recyclers** browse verified, pre-sorted materials (and
   pre-loved upcycled products) on the **marketplace**, and pay cash or by
   card.
4. **Employees** collect bin waste and deliver marketplace orders.
5. **Admins** manage catalog pricing and monitor the bin fleet.

## Tech stack and why

| Layer | Choice | Rationale |
| --- | --- | --- |
| Mobile app | **Flutter (Dart)** | Single codebase for Android, iOS and web — the deck criticises Android-only predecessors. Flutter is also the stack used by two of the reviewed papers (AppCycle, ScrapDig). |
| State management | `ChangeNotifier` + `InheritedWidget` (`AppScope`) | Zero extra packages; every screen rebuilds from one observable `AppState`. |
| Backend | Repository pattern with a **mock backend** (`MockBackend`) + optional **Node mock API** (`server/server.js`, zero dependencies) | Mirrors the deck's 3-tier block diagram; the app demos fully offline, or against the API for the "real server" story. Swapping the mock for HTTP calls touches one class only. |
| Payment | Simulated gateway (`authorizeCard`) | Implements the deck's Payment Gateway sequence: card verification, success token, or "Try Another Card". |
| Hardware (ESP32, camera, servo) | **Software simulation** in the Recycle flow | Same approach the deck itself takes for its AI slide: capture → classify → servo countdown → deposit, with confidence score and sorting stats. |

## Project structure

```
lib/
  main.dart                     App entry point
  app.dart                      Theme, auth gate, 4-page shell + role pages
  core/
    models.dart                 Domain models (mirrors the Class Diagram slide)
    mock_backend.dart           Simulated Tier-2 services + seed data
    app_state.dart              Observable app state + all user actions
    theme.dart                  GreenCycle branding (Material 3)
  features/
    auth/                       Sign in / register (Citizen, Business)
    home/                       Home: points, stats, nearby bins
    recycle/                    Smart-bin scan + AI sorting simulation
    market/                     Marketplace, cart, checkout, order tracking
    wallet/                     Wallet, history, cash-out, sponsor vouchers
    profile/                    Profile, recycling stats, recent activity
    employee/                   Route: bin collections + deliveries
    admin/                      Catalog pricing + bin fleet status
server/
  server.js                     Zero-dependency Node mock REST API
test/                           26 unit, state and widget tests
```

## Feature walkthrough, mapped to the deck

| Deck slide | Where it lives in the app |
| --- | --- |
| System Overview (end-to-end disposal → sorting → marketplace) | Whole app; the Recycle flow demos the loop end-to-end |
| Use Case Diagram (Citizen, Business, Employee, Admin, SmartBin actors) | Role-based sign-in; Employee gets a "Route" tab, Admin an "Admin" tab |
| Activity Diagram — Authentication (email uniqueness, hashed passwords, sessions) | `auth_screens.dart` + `MockBackend.login/register` (FNV-1a demo hash, never plain text) |
| Activity Diagram — E-commerce & rewards (checkout, payment verification, order tracking, redemption) | Marketplace checkout, order timeline, wallet cash-out and vouchers |
| Class Diagram (User hierarchy, SmartBin, QRCode, WasteRecord, Order, Item, Wallet, Payment: Cash & Visa, Voucher, Sponsor) | `lib/core/models.dart` |
| Block Diagram (3 tiers) | Presentation: Flutter UI. Application: `MockBackend` / `server.js`. Data: seeded repositories (PostgreSQL in the full system) |
| Sequence — IoT Smart Bin loop (capture → AI classify → servo actuate → QR → instant wallet points) | Recycle flow: bin picker → waste type → QR scan → classification with confidence → servo countdown → points |
| Sequence — Payment Gateway ("Payment Successful" token / "Try Another Card") | Visa checkout against the simulated gateway |
| Demo App pages (Home, Recycle, Marketplace, Profile) | The four bottom-navigation pages, same names and content |
| Business Model (sponsor vouchers, marketplace commission) | Rewards screen: sponsor-branded vouchers redeemed with points |

## Run it

### Prerequisites
- Flutter SDK 3.27+ (`flutter doctor`)
- Optional: Node 18+ for the mock API

### Mobile / desktop / web
```bash
flutter pub get
flutter run                 # pick a device
flutter run -d chrome       # run in a browser
flutter build web           # static build in build/web
```

### Optional mock API
```bash
node server/server.js       # http://localhost:8080
curl http://localhost:8080/api/health
```

### Tests
```bash
flutter test                # 26 tests: auth, AI loop, payment, orders, UI flows
```

## Demo script for the presentation

1. **Sign in** as `amr@greencycle.app` / `demo123` (Citizen). A 120-point
   welcome bonus lands in the wallet.
2. **Home**: eco-points card, total recycled weight, CO2 saved, and nearby
   smart bins with live fill levels (note Maadi Corniche = full, New Cairo =
   maintenance; only online bins accept deposits).
3. **Recycle**: pick *MTI Campus Gate A* → *Plastic* → **Simulate scan**
   (QR code `GC-BIN-01`) → watch the AI classify with a confidence score and
   the servo countdown → **+10 eco-points** instantly, sorting stats update.
4. **Wallet** (tap the points card): history, convert points to cash
   (100 pts = EGP 10), redeem a sponsor voucher.
5. **Marketplace**: open *Shredded PET Plastic*, add to cart, checkout with
   **Cash** → order placed → tracking timeline. Re-order and pay with **Visa**
   using `4242 4242 4242 4242` (any expiry `12/27`, CVV `123`). A card ending
   in `0000` is declined with "Try Another Card".
6. **Employee role**: sign out, sign in as `driver@greencycle.app` — the
   Route tab lists bin collections and the delivery just created; completing
   a collection empties the bin, completing a delivery marks the order
   delivered.
7. **Admin role**: `admin@greencycle.app` — edit catalog prices and watch
   the marketplace update; monitor the whole bin fleet.

### Demo accounts (password: `demo123`)

| Email | Role |
| --- | --- |
| `amr@greencycle.app` | Citizen |
| `buyer@greencycle.app` | Business |
| `driver@greencycle.app` | Employee |
| `admin@greencycle.app` | Admin |

## What is simulated (and how it becomes real)

- **Smart bin hardware** (ESP32 boards, camera, servo flap): the app
  simulates capture/classification/sorting. In the full system the bin calls
  `POST /api/bins/:id/deposit` (already implemented in `server.js`) after its
  on-device model classifies the item.
- **QR scanning**: simulated viewfinder + manual code entry; the real flow
  swaps in a camera scanner plugin — the verification logic
  (`findBinByQr`) is unchanged.
- **Payment gateway**: `authorizeCard` stands in for a real PSP; the
  success/decline contract matches the deck's sequence diagram.
- **Password hashing**: FNV-1a for demo only — use bcrypt/argon2 in
  production.

## License

MIT — see LICENSE. Built by the MTI graduation project team, 2025/2026.
