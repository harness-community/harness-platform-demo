# Step 1: Build Nginx with your site
FROM nginx:1.19.2 AS build

COPY index.html /usr/share/nginx/html/
COPY index_files /usr/share/nginx/html/index_files

EXPOSE 80

# Step 2: Build Nginx Prometheus Exporter
FROM nginx/nginx-prometheus-exporter:0.8.0 AS exporter

# Step 3: Final Docker Image
FROM debian:buster-slim

# Copy Nginx from build to final image
COPY --from=build /etc/nginx /etc/nginx
COPY --from=build /usr/share/nginx /usr/share/nginx
COPY --from=build /var/log/nginx /var/log/nginx

# Copy Nginx Prometheus Exporter from exporter to final image
COPY --from=exporter /usr/bin/exporter /usr/bin/exporter

# Start Nginx and Nginx Prometheus Exporter
CMD service nginx start && /usr/bin/exporter -nginx.scrape-uri=http://localhost/nginx_status

EXPOSE 80 9113
