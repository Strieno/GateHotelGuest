# AGENTS.md — The Gate Hotel & Apartments Guest Portal

Static, bilingual (EN/AR) guest portal deployed on GitHub Pages from the root of `main`.

## Structure

- `index.html` — semantic, English-first markup with `data-i18n*` attributes
- `assets/css/style.css` — design system (charcoal / champagne gold / ivory), mobile-first, RTL-ready
- `assets/js/translations.js` — `window.TRANSLATIONS` dictionary (`en`, `ar`)
- `assets/js/app.js` — i18n, Dammam clock, weather (open-meteo), copy actions, facility status, scrollspy
- `assets/images/` — hotel images and logo
- `manifest.webmanifest`, `sw.js`, `favicon.svg`, `apple-touch-icon.png`, `icon-192/512.png`

## Conventions

- Add any new user-visible string to BOTH `en` and `ar` dictionaries (keys must match).
- Use `data-i18n` (text), `data-i18n-html` (inline HTML), `data-i18n-aria` (aria-label) on elements.
- Facility status pills: `data-status="pool|gym|starbucks|restaurant|reception"`; schedules live in `FACILITY_RULES` in `app.js` (Asia/Riyadh time).
- Timezone is always `Asia/Riyadh` (Saudi Arabia is UTC+3, no DST).
- External links must use `target="_blank" rel="noopener noreferrer"`.
- No build step. To preview locally: `python3 -m http.server 8000`.

## Verified hotel facts (do not change without hotel confirmation)

- Wi-Fi: network `GATE WIFI`, username = room number, password `123123`
- Check-in 2:00 PM / Check-out 12:00 PM
- Room phone extensions: 11 (reception), 22 (housekeeping), 33 (room service) — internal only
- Gardena Restaurant: 1st floor, ext. 200 — breakfast 6–10, lunch 11–15, dinner 19–23
- Pool: ground floor, ladies 6–11 AM, gentlemen 11 AM–11 PM; Gym: 1st floor 24/7; Masjid: 1st floor; Starbucks: ground, 8 AM–10 PM
- Saudi emergency: police 911, ambulance 997, civil defense 998

## Needs human verification

- Front-desk mobile number `+966138000000` (tel links) — placeholder carried over from the original site.
- Google Maps link uses a search query (no coordinates available).
