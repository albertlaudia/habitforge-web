# HabitForge web surfaces

Privacy policy, terms of service, support, and landing page for HabitForge.

**Live at:** <https://app.positiveness.club/habitforge/>

| Path | Purpose |
|------|---------|
| `/habitforge/` | Brand landing page |
| `/habitforge/privacy` | Privacy Policy |
| `/habitforge/terms` | Terms of Use |
| `/habitforge/support` | Support + FAQ |

## Stack

Plain HTML + CSS. No JavaScript framework, no build step. Served by `nginx:1.27-alpine` from a Dokploy compose in the `Sites` project. Fronted by Cloudflare on `app.positiveness.club`.

## Local development

```bash
docker build -t habitforge-web:dev .
docker run --rm -p 8080:80 habitforge-web:dev
# Open http://localhost:8080
```

## Deploying a content change

1. Edit the HTML in this repo.
2. Push to `main`.
3. In Dokploy, open the `habitforge-web` compose and click **Redeploy**.

Cloudflare's cache typically clears within minutes for HTML responses. Bump a `?v=YYYY-MM-DD` query string if you need an instant cache bust on a long-cached asset.

## File map

| File | Purpose |
|------|---------|
| `index.html` | Landing page — brand pitch + link cards |
| `privacy.html` | Privacy Policy (10 sections) |
| `terms.html` | Terms of Use (12 sections) |
| `support.html` | Support + FAQ + contact tiles |
| `favicon.svg` | Pastel Play brand mark |
| `nginx.conf` | nginx config — pretty paths, security headers, gzip |
| `Dockerfile` | nginx image with HTML files baked in |
| `docker-compose.yml` | Dokploy compose — single service on `dokploy-network` |

## Brand

Pastel Play palette — cream `#FAF5EF`, coral `#FFB5A7`, teal `#80CBC4`, yellow `#FFE082`, purple `#B39DDB`, mint `#A5D6A7`. Type stack uses the system sans (-apple-system / Segoe UI / Nunito) for fast first paint.

## Privacy posture

No analytics. No third-party scripts. No cookies. No external fonts or images. CSP locked to `default-src 'self'` — see `nginx.conf`.

## Related

- Mobile app: <https://github.com/albertlaudia/habitforge-app>
- Strategic pack: `/workspace/habitforge-deliverables/`
