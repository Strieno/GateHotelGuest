#!/usr/bin/env bash
set -euo pipefail

BRANCH="full-refactor-and-features"

# create branch
git checkout -b "$BRANCH"

# Create files
cat > README.md <<'EOF'
# GateHotelGuest

Guest Page for Gate Hotel — modern, accessible, and deploy-ready.

## What this change includes

- Full refactor of the site: semantic, accessible index.html
- Responsive stylesheet (styles/styles.css)
- Minimal progressive JS (scripts/main.js)
- PWA manifest and a lightweight service worker (manifest.json, sw.js)
- Docs: README.md, CONTRIBUTING.md, CODE_OF_CONDUCT.md
- LICENSE: MIT
- .gitignore
- GitHub Actions: lint + Pages deploy workflow

## Preview locally

1. Clone the repo and check out the branch:

   git clone https://github.com/Strieno/GateHotelGuest.git
   cd GateHotelGuest
   git checkout full-refactor-and-features

2. Open index.html in a browser (no build required):

   open index.html

## Deploy

This branch includes a GitHub Actions workflow that publishes the repository root to GitHub Pages when merged to `main`.

## Form handling

The contact form in index.html is wired to Formspree by default as a static-friendly option. See the HTML comments in index.html and README for how to configure your own endpoint.

## License

This project is licensed under the MIT License — see LICENSE.

## Contact

Maintainer: Strieno
EOF

cat > LICENSE <<'EOF'
MIT License

Copyright (c) 2026 Strieno

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF

cat > .gitignore <<'EOF'
.DS_Store
node_modules/
.env
.vscode/
.idea/
*.log

# macOS
.DS_Store

# Windows
Thumbs.db

# Packages
node_modules/

# Logs
npm-debug.log*
yarn-debug.log*
yarn-error.log*
EOF

cat > CONTRIBUTING.md <<'EOF'
# Contributing

Thanks for considering contributing! A few guidelines:

- Please open an issue describing the bug or feature you'd like to contribute.
- For code changes, create a branch off `main` named `feature/...` or `fix/...` and open a pull request.
- Keep changes focused and include screenshots or steps to reproduce.

Refer to the CODE_OF_CONDUCT.md for community guidelines.
EOF

cat > CODE_OF_CONDUCT.md <<'EOF'
# Contributor Covenant Code of Conduct

This project follows the Contributor Covenant v2.0. By participating you agree to abide by its terms.

Be kind, inclusive, and respectful. If you have concerns, contact the project maintainers.
EOF

cat > index.html <<'EOF'
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <meta name="theme-color" content="#0a74da">
  <title>Gate Hotel — Guest Page</title>
  <meta name="description" content="Gate Hotel guest information page — rooms, services, and contact form.">
  <link rel="icon" href="/favicon.svg" type="image/svg+xml">
  <meta property="og:title" content="Gate Hotel — Guest Page">
  <meta property="og:description" content="Guest information, contact, and hotel services.">
  <meta property="og:type" content="website">
  <meta property="og:image" content="/social-preview.png">
  <link rel="manifest" href="/manifest.json">
  <link rel="stylesheet" href="/styles/styles.css">
</head>
<body>
  <header class="site-header">
    <div class="container">
      <a class="brand" href="/">Gate Hotel</a>
      <button id="menuToggle" class="menu-toggle" aria-expanded="false" aria-controls="primaryNav">Menu</button>
      <nav id="primaryNav" class="primary-nav" aria-label="Primary">
        <ul>
          <li><a href="#rooms">Rooms</a></li>
          <li><a href="#services">Services</a></li>
          <li><a href="#contact">Contact</a></li>
        </ul>
      </nav>
    </div>
  </header>

  <main class="site-main container">
    <section class="hero" aria-labelledby="hero-heading">
      <h1 id="hero-heading">Welcome to Gate Hotel</h1>
      <p>Your comfort is our priority — find guest information, amenities, and contact details here.</p>
    </section>

    <section id="rooms" class="cards" aria-labelledby="rooms-heading">
      <h2 id="rooms-heading">Rooms</h2>
      <div class="card-grid">
        <article class="card">
          <h3>Standard Room</h3>
          <p>Cozy room with queen bed and city view.</p>
        </article>
        <article class="card">
          <h3>Deluxe Room</h3>
          <p>Spacious room with king bed and complimentary breakfast.</p>
        </article>
      </div>
    </section>

    <section id="services" aria-labelledby="services-heading">
      <h2 id="services-heading">Services</h2>
      <ul>
        <li>24/7 Reception</li>
        <li>Room Service</li>
        <li>Free Wi‑Fi</li>
      </ul>
    </section>

    <section id="contact" aria-labelledby="contact-heading">
      <h2 id="contact-heading">Contact & Requests</h2>
      <!--
        By default this form posts to Formspree (static-friendly). Replace the action value with your
        server endpoint or Formspree form ID. To use Formspree replace '/your-form-endpoint' with
        'https://formspree.io/f/{your-id}' and add your email on their dashboard.
      -->
      <form id="contactForm" class="contact-form" method="POST" action="/your-form-endpoint">
        <div class="field">
          <label for="name">Name</label>
          <input id="name" name="name" type="text" required>
        </div>
        <div class="field">
          <label for="email">Email</label>
          <input id="email" name="email" type="email" required>
        </div>
        <div class="field">
          <label for="message">Message</label>
          <textarea id="message" name="message" rows="4" required></textarea>
        </div>
        <button type="submit">Send Request</button>
        <div id="formStatus" role="status" aria-live="polite"></div>
      </form>
    </section>

  </main>

  <footer class="site-footer">
    <div class="container">
      <p>&copy; 2026 Gate Hotel — Maintained by Strieno</p>
    </div>
  </footer>

  <script src="/scripts/main.js" defer></script>
</body>
</html>
EOF

mkdir -p styles
cat > styles/styles.css <<'EOF'
/* styles/styles.css — mobile-first, minimal variables for easy theming */
:root{
  --bg:#ffffff;
  --text:#0b2545;
  --muted:#6b7280;
  --accent:#0a74da;
  --container-max:1100px;
  --radius:8px;
  --gap:1rem;
  --max-width:900px;
}
*{box-sizing:border-box}
html,body{height:100%}
body{margin:0;font-family:Inter,Segoe UI,Roboto,system-ui,-apple-system,"Helvetica Neue",Arial;line-height:1.5;color:var(--text);background:var(--bg);}
.container{max-width:var(--container-max);margin:0 auto;padding:1rem}
.site-header{border-bottom:1px solid #eef2f7;background:#fff}
.site-header .container{display:flex;align-items:center;justify-content:space-between;gap:1rem}
.brand{font-weight:700;color:var(--accent);text-decoration:none}
.menu-toggle{display:inline-block;background:none;border:1px solid transparent;padding:.5rem;border-radius:6px}
.primary-nav{display:none}
.primary-nav ul{list-style:none;margin:0;padding:0;display:flex;gap:1rem}
.primary-nav a{text-decoration:none;color:var(--text)}
.hero{padding:2rem 0}
.hero h1{margin:.5rem 0;font-size:1.6rem}
.cards{padding:1rem 0}
.card-grid{display:grid;grid-template-columns:1fr;gap:1rem}
.card{padding:1rem;border:1px solid #eef2f7;border-radius:var(--radius);background:#fff}
.contact-form{max-width:var(--max-width)}
.field{margin-bottom:.75rem}
label{display:block;font-weight:600;margin-bottom:.25rem}
input,textarea{width:100%;padding:.6rem;border:1px solid #e6eef8;border-radius:6px}
button[type=submit]{background:var(--accent);color:#fff;border:none;padding:.7rem 1rem;border-radius:6px;cursor:pointer}
.site-footer{border-top:1px solid #eef2f7;padding:1rem 0;margin-top:2rem;color:var(--muted)}

/* Focus styles */
:focus{outline:3px solid color-mix(in srgb, var(--accent) 20%, transparent);outline-offset:2px}

/* Larger screens */
@media(min-width:720px){
  .menu-toggle{display:none}
  .primary-nav{display:block}
  .card-grid{grid-template-columns:repeat(2,1fr)}
  .hero h1{font-size:2rem}
}
EOF

mkdir -p scripts
cat > scripts/main.js <<'EOF'
// scripts/main.js — small progressive enhancements
(function(){
  'use strict';
  const menuToggle = document.getElementById('menuToggle');
  const primaryNav = document.getElementById('primaryNav');
  if(menuToggle && primaryNav){
    menuToggle.addEventListener('click', ()=>{
      const expanded = menuToggle.getAttribute('aria-expanded') === 'true';
      menuToggle.setAttribute('aria-expanded', String(!expanded));
      primaryNav.style.display = expanded ? 'none' : 'block';
    });
  }

  // Simple form handler: show success or error message and prevent double submits
  const form = document.getElementById('contactForm');
  const status = document.getElementById('formStatus');
  if(form){
    form.addEventListener('submit', async (e)=>{
      // Let the browser handle non-JS submissions if action is not configured
      if(!form.action || form.action === '/your-form-endpoint') return;
      e.preventDefault();
      status.textContent = 'Sending...';
      const data = new FormData(form);
      try{
        const res = await fetch(form.action, {method:'POST',body:data});
        if(res.ok){
          status.textContent = 'Message sent — thank you!';
          form.reset();
        } else {
          status.textContent = 'There was an error sending the message.';
        }
      }catch(err){
        status.textContent = 'Network error — please try again.';
      }
    });
  }

  // Register service worker if available
  if('serviceWorker' in navigator){
    window.addEventListener('load', ()=>{
      navigator.serviceWorker.register('/sw.js').catch(()=>{/*fail silently*/});
    });
  }
})();
EOF

cat > manifest.json <<'EOF'
{
  "name": "Gate Hotel Guest Page",
  "short_name": "GateHotel",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#ffffff",
  "theme_color": "#0a74da",
  "icons": [
    {"src":"/favicon-192.png","sizes":"192x192","type":"image/png"},
    {"src":"/favicon-512.png","sizes":"512x512","type":"image/png"}
  ]
}
EOF

cat > sw.js <<'EOF'
// sw.js — very small cache-first service worker for static assets
const CACHE_NAME = 'gatehotel-v1';
const ASSETS = [
  '/',
  '/index.html',
  '/styles/styles.css',
  '/scripts/main.js'
];
self.addEventListener('install', event => {
  event.waitUntil(caches.open(CACHE_NAME).then(c=>c.addAll(ASSETS)));
});
self.addEventListener('activate', event => {
  event.waitUntil(self.clients.claim());
});
self.addEventListener('fetch', event => {
  event.respondWith(caches.match(event.request).then(r=>r||fetch(event.request)));
});
EOF

cat > .htmlhintrc <<'EOF'
{
  "extends": "htmlhint:recommended",
  "rules": {
    "attr-lowercase": true,
    "doctype-first": true,
    "id-unique": true
  }
}
EOF

mkdir -p .github/workflows
cat > .github/workflows/ci-and-pages.yml <<'EOF'
name: CI and Pages

on:
  pull_request:
    branches: [ main ]
  push:
    branches: [ main ]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Install htmlhint
        run: |
          npm install -g htmlhint
      - name: Run HTMLHint
        run: htmlhint index.html

  deploy_pages:
    if: github.event_name == 'push'
    runs-on: ubuntu-latest
    needs: [lint]
    steps:
      - uses: actions/checkout@v4
      - uses: actions/configure-pages@v3
      - name: Upload artifact for Pages
        uses: actions/upload-pages-artifact@v1
        with:
          path: ./
      - name: Deploy to GitHub Pages
        uses: actions/deploy-pages@v1
EOF

# Commit and push
git add .
git commit -m "Full refactor: add docs, modern index.html, styles, scripts, PWA, and CI"
git push -u origin "$BRANCH" || {
  echo "Push failed. If remote branch exists or you lack permission, try:"
  echo "  git pull --rebase origin $BRANCH"
  echo "  git push -u origin $BRANCH"
  exit 1
}

echo "Done. Branch '$BRANCH' pushed. Open a Pull Request on GitHub to merge."
