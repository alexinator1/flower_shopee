# Билд стадия
FROM node:18-alpine AS builder

WORKDIR /app
COPY . .
RUN npm install
RUN npm run build

# Финальная стадия
FROM nginx:alpine

COPY --from=builder /app/dist /usr/share/nginx/html
COPY ./docker/frontend/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 3000
CMD ["nginx", "-g", "daemon off;"]