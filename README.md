# Interiors by Sarkinmota

Static site for **Interiors by Sarkinmota** with localized Nigerian content (contact info, testimonials, projects, blog posts). Design, layout, and animations are preserved.

## Project structure
- `/` – site HTML (root)
- `/cdn.prod.website-files.com/` – CSS/JS/assets
- `/d3e54v103j8qbb.cloudfront.net/` – supporting assets

## Local preview
```bash
# From repo root
npx -y serve -p 8080 .
# open http://localhost:8080
```

## Deploying to Vercel
1) Create a new Vercel project from this repo.
2) Framework Preset: **Other**.
3) Root Directory: repo root (contains `index.html`).
4) Build Command: _none_ (static site). Output Directory: leave blank.
5) Deploy.

## Notes
- Shop/cart UI is hidden; currency set to NGN.
- Logos updated to the new brand wordmark.

## Quick check
Verify navbar logo, hero text, contact info, and a blog post to confirm the brand and Nigerian context are visible throughout.
