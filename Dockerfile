# Step 1: Build Nginx with your site
FROM nginx:1.19.2 AS build

COPY index.html /usr/share/nginx/html/
COPY index_files /usr/share/nginx/html/index_files

# Step 2: Build Nginx Prometheus Exporter
FROM nginx/nginx-prometheus-exporter:0.8.0

# Copy Nginx and your site from build to final image
COPY --from=build /etc/nginx /etc/nginx
COPY --from=build /usr/share/nginx/html/index.html /usr/share/nginx/html/
COPY --from=build /usr/share/nginx/html/index_files /usr/share/nginx/html/index_files

EXPOSE 80 9113

# Start Nginx and Nginx Prometheus Exporter
CMD /usr/sbin/nginx && /bin/exporter -nginx.scrape-uri=http://localhost/nginx_status
