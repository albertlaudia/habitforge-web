# HabitForge web — static legal + support + landing pages
# Image: nginx:alpine, with the 4 HTML files + favicon baked in.

FROM nginx:1.27-alpine

# Wipe default nginx content
RUN rm -rf /usr/share/nginx/html/*

# Copy the static site
COPY index.html    /usr/share/nginx/html/index.html
COPY privacy.html  /usr/share/nginx/html/privacy.html
COPY terms.html    /usr/share/nginx/html/terms.html
COPY support.html  /usr/share/nginx/html/support.html
COPY favicon.svg   /usr/share/nginx/html/favicon.svg

# Custom nginx config: pretty paths, security headers, gzip, cache-friendly
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
