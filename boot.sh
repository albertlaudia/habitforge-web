#!/bin/sh
# HabitForge legal pages — fetch the published HTML at container start, then
# serve it with nginx. The script is mounted read-only from the host so Docker
# Compose never has to interpolate a "$" (which it would blank out).
set -e

RAW=https://raw.githubusercontent.com/albertlaudia/habitforge-web/main
DEST=/srv/www

mkdir -p "$DEST"
cd "$DEST"

echo "HabitForge web: fetching pages from $RAW"

for f in index privacy terms support; do
  if curl -fsSL "$RAW/$f.html" -o "$f.html"; then
    echo "  ok  $f.html ($(wc -c < "$f.html") bytes)"
  else
    echo "  FAIL $f.html"
    exit 1
  fi
done

# nginx serves /usr/share/nginx/html by default; point it at /srv/www instead.
if curl -fsSL "$RAW/favicon.svg" -o favicon.svg; then
  echo "  ok  favicon.svg"
fi

# Extensionless aliases so /privacy and /terms resolve without a try_files rule.
cp privacy.html privacy
cp terms.html terms
cp support.html support

cat > /etc/nginx/conf.d/default.conf <<'NGX'
server {
    listen 80 default_server;
    server_name _;
    root /srv/www;
    index index.html;

    charset utf-8;
    server_tokens off;

    # Keep the pages out of the shared Cloudflare cache so a redeploy is visible
    # immediately; HTML here changes rarely but the cert + routing do.
    add_header Cache-Control "public, max-age=60" always;

    add_header X-Content-Type-Options "nosniff" always;
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    add_header Content-Security-Policy "default-src 'self'; img-src 'self' data:; style-src 'self' 'unsafe-inline'; script-src 'self'; connect-src 'self'; frame-ancestors 'none'; base-uri 'self'; form-action 'self'" always;

    gzip on;
    gzip_vary on;
    gzip_min_length 256;
    gzip_proxied any;
    gzip_types text/plain text/css application/json application/javascript application/xml image/svg+xml;

    location = /healthz {
        access_log off;
        return 200 "ok\n";
        add_header Content-Type text/plain;
    }

    location = /robots.txt {
        return 200 "User-agent: *\nAllow: /\n";
        add_header Content-Type text/plain;
    }

    location / {
        try_files $uri $uri/ =404;
    }
}
NGX

echo "HabitForge web: pages ready, starting nginx"
exec nginx -g 'daemon off;'
