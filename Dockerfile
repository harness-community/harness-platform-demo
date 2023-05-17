# Step 1: Build Nginx with your site
FROM nginx:1.19.2

COPY index.html /usr/share/nginx/html/
COPY index_files /usr/share/nginx/html/index_files

EXPOSE 80 9113
