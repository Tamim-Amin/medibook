# MediBook — Doctor Appointment Booking System

A fully offline Flutter app for discovering doctors, booking appointments through an automated serial-based scheduling system, and checking diagnostics pricing.

**Course:** Mobile App Development Practice Lab (SWE-422)
**Submitted to:** Md. Zia Uddin Khan, Adjunct Faculty, Dept. of Software Engineering, Metropolitan University, Sylhet
**Submitted by:** Tamim Amin Suhag · ID 232-134-024 · Batch 5th

> 🚧 In development — this README is completed on Day 8 (20 August).

---

## Problem Statement

<!-- Day 8: paste from the project plan -->

## Features

<!-- Day 8: full feature list matching the project plan -->

## Screenshots

<!-- Day 8: 8–12 screenshots from /screenshots in a table -->

## Tech Stack

- **Flutter** / **Dart**
- **Provider** — app-wide state (appointments, favourites, theme, auth)
- **SharedPreferences** — persistent local storage
- **intl** — date and time formatting
- **shimmer** — skeleton loading placeholders

No backend, no internet connection required.

## Folder Structure

```
lib/
├── main.dart
├── models/        # Doctor, Appointment, DiagnosticCenter, PriceItem, AppUser
├── providers/     # Auth, Doctor, Appointment, Favorites, Theme
├── screens/       # One folder per feature area
├── widgets/       # Reusable custom widgets
├── data/          # Local demo data
└── utils/         # Colors, text styles, theme, routes, prefs keys, helpers
```

## Concepts Demonstrated

| Concept | Where |
|---|---|
| Navigation | <!-- Day 8 --> |
| Forms & Validation | |
| Provider | |
| SharedPreferences | |
| Custom Widgets | |

## How to Run

```bash
flutter pub get
flutter run
```

Requires Flutter SDK 3.x and an Android emulator or physical device.

## Demo Video

<!-- Day 8: link -->

## Future Scope

The app currently stores all data locally. The architecture is designed so it can later connect to Firebase Authentication and Firestore for real-time bookings, multi-device sync, and a live doctor/admin dashboard.