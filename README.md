# Interiors by Sarkinmota

Static site for **Interiors by Sarkinmota** with localized Nigerian content (contact info, testimonials, projects, blog posts). Design, layout, and animations are preserved.

## Project structure
- `/Interiors By Sarkinmota/` – site HTML
- `/cdn.prod.website-files.com/` – CSS/JS/assets
- `/d3e54v103j8qbb.cloudfront.net/` – supporting assets
- `/index.html` – redirects to `/interiora.webflow.io/` when serving from repo root

## Local preview
```bash
# From repo root
npx -y serve -p 8080 .
# open http://localhost:8080 (auto-redirects to /Interiors%20By%20Sarkinmota/)
```

Or serve the site folder directly:
```bash
cd "Interiors By Sarkinmota"
npx -y serve -p 8080 .
# open http://localhost:8080
```

## Deploying to Vercel
1) Create a new Vercel project from this repo.
2) Framework Preset: **Other**.
3) Root Directory: `Interiors By Sarkinmota` (recommended). If you keep the root at repo root, `index.html` redirects to that folder.
4) Build Command: _none_ (static site). Output Directory: leave blank.
5) Deploy.

## Notes
- Shop/cart UI is hidden; currency set to NGN.
- Logos updated to the new brand wordmark.

## Quick check
Verify navbar logo, hero text, contact info, and a blog post to confirm the brand and Nigerian context are visible throughout.
