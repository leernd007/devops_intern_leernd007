FROM node:18-alpine as BASE_IMAGE


WORKDIR /app

COPY . .

RUN npm install && npm run build

FROM nginx:1.21.4-alpine as NGINX_BASE_IMAGE
COPY --from=BASE_IMAGE /app/dist/frontend /usr/share/nginx/html
COPY --from=BASE_IMAGE /app/nginx.conf /etc/nginx/conf.d/default.conf
