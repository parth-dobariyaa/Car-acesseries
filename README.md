# CARVORA — Bespoke Automotive Enhancements (Flutter)

A luxury, cinematic Flutter application for automotive enhancements and supercar accessories, inspired by modern bespoke atelier design aesthetics.

## Project Overview

**CARVORA** showcases premium vehicle upgrades — from autoclave-cured Toray 3K carbon fiber aero components and valvetronic Grade 5 titanium exhausts to handcrafted starlight roof matrices and monoblock forged wheels. 

The application is architected with a responsive layout (Desktop Navigation Rail & Mobile Navigation Bar), deep obsidian and champagne-gold theme, full reactive state management via **Provider**, and an interactive VIP consultation booking engine.

---

## Key Features

- **Cinematic Dark Theme**: Deep obsidian black (`#090A0E`), carbon slate (`#12151D`), and champagne gold (`#E5B869`) accents.
- **Hero Showcase**: High-impact brand banner with Trustpilot 4.96★ rating metrics, value pillars, and direct quick-action buttons.
- **Curated Catalog**: Search and filter by category (Interior & Cockpit, Carbon & Aero, Optics & Lighting, Performance & Exhaust, Bespoke Tech) with dynamic sorting (Price, Rating, Featured).
- **Custom Vector Visual Art**: High-resolution, zero-dependency `CustomPainter` vector artwork for steering wheels with LED shift lights, titanium blued exhaust pipes, laser headlamps, aero wings, and digital smart keys.
- **Interactive Product Details**: Technical specifications table, craftsmanship highlights, stock badges, quantity adjuster, and instant add-to-order.
- **Curated Wishlist**: Save favorite bespoke enhancements with one-tap transfer to order.
- **Bespoke Order & Checkout**: Quantity adjustments, VIP discount privilege code support (e.g. `CARVORA10` or `VIP`), itemized invoice breakdown, and order dispatch confirmation.
- **VIP Consultation Booking**: Full booking engine with vehicle platform selector (Porsche, BMW M, Mercedes-AMG, Audi RS, Ferrari, Tesla Plaid, Custom), enhancement focus, interactive date picker, time slot chips, client contact validation, and active reservation tracking.
- **Responsive Layout**: Adapts between multi-column grid & side navigation rail on desktop/tablet, and single-column cards with bottom navigation bar on mobile.

---

## Project Structure

```text
lib/
├── main.dart                          # App entrypoint with MultiProvider and dark theme
├── data/
│   └── sample_accessories.dart        # Luxury accessories dataset & categories
├── models/
│   ├── accessory.dart                 # Accessory data model & specifications
│   ├── cart_item.dart                 # Cart item model with quantity tracking
│   └── consultation.dart              # Consultation reservation request model
├── providers/
│   └── carvora_provider.dart          # Central state management (Provider)
├── screens/
│   ├── main_shell_screen.dart         # Responsive navigation shell (Rail/BottomBar)
│   ├── showcase_screen.dart           # Home showcase with hero banner & highlights
│   ├── catalog_screen.dart            # Search, filter, and sorting catalog
│   ├── product_detail_screen.dart     # Comprehensive product specifications
│   ├── wishlist_screen.dart           # Saved accessories collection
│   ├── cart_screen.dart               # Order breakdown, VIP code, and checkout
│   └── consultation_screen.dart       # VIP reservation booking system
├── theme/
│   └── carvora_theme.dart             # Dark luxury theme tokens and styling
└── widgets/
    ├── accessory_card.dart            # Accessory preview card
    ├── accessory_visual.dart          # Custom vector painters for accessories
    ├── category_chips.dart            # Category selector chips
    └── hero_banner.dart               # Cinematic brand hero banner
```

---

## Getting Started

### Prerequisites

- Flutter SDK (3.24+ recommended, tested with Flutter 3.44.4 / Dart 3.12.2)
- Connected device, Chrome browser, or Windows desktop support

### Run the App

1. Fetch dependencies:
   ```bash
   flutter pub get
   ```

2. Run in Google Chrome (Web):
   ```bash
   flutter run -d chrome
   ```

3. Run as Windows Desktop application:
   ```bash
   flutter run -d windows
   ```

### Code Quality & Testing

- Run static analysis:
  ```bash
  flutter analyze
  ```
- Run automated widget tests:
  ```bash
  flutter test
  ```

---

## State Management

State is managed cleanly through the `CarvoraProvider` ([lib/providers/carvora_provider.dart](lib/providers/carvora_provider.dart)), handling:
- Selected categories and search filtering
- Wishlist set and toggle persistence
- Cart item quantities, price calculations, and promo discounts
- Consultation reservation submissions

---

## Authentication and Admin Console

The application starts with the CARVORA registration screen. After registering, customers can sign in to access the storefront.

The authentication screen also includes an **ADMIN LOGIN** entry point.

Demo admin credentials:

```text
Email: admin@carvora.com
Password: admin123
```

The admin console includes:

- Dashboard activity and summary metrics
- Product catalog and inventory editing
- Order overview
- Consultation request overview
- User overview
- Admin logout

The current authentication and admin data are local demo data and reset when the application restarts. A production deployment should replace this with secure backend authentication and persistent storage.

## Web Release

Build the production web version:

```bash
flutter build web --release
```

The generated files are placed in `build/web`.

To preview the release locally:

```bash
cd build/web
python -m http.server 8080
```

Then open [http://localhost:8080](http://localhost:8080).

## Windows Release

Install Visual Studio 2022 with the **Desktop development with C++** workload, including CMake tools and a Windows SDK.

Then build:

```bash
flutter build windows --release
```

The executable is generated under:

```text
build/windows/x64/runner/Release/
```

## Project Status

The project is currently intended for private development and demonstration. Product, order, user, consultation, and inventory information is sample or in-memory data until a backend is connected.
