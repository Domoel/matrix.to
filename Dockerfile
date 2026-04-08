# Stage 1: Build
FROM node:20.2-alpine AS build
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install
COPY . .
RUN cp main.css src/static/styles/main.css || true
RUN cp client.css src/static/styles/client.css || true
RUN yarn build

# Stage 2: Production (bleibt gleich)
FROM nginx:alpine
WORKDIR /etc/nginx
COPY ./nginx.conf /etc/nginx/nginx.conf
WORKDIR /usr/share/nginx/html
COPY --from=build /app/build .

EXPOSE 80
HEALTHCHECK CMD curl --fail http://localhost:80 || exit 1
CMD ["nginx", "-g", "daemon off;"]
