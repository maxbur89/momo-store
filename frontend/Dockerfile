FROM alpine:3.16.0 AS builder

WORKDIR /usr/src/app
COPY package*.json ./
RUN apk add --no-cache npm==8.10.0-r0 \
    && npm install
COPY . .

ENV NODE_ENV=production
ENV VUE_APP_API_URL=https://momo-store.digibi.ru

RUN npm run build

FROM nginx:1.22.0-alpine

RUN mkdir /usr/share/nginx/html/momo-store
COPY --from=builder /usr/src/app/dist /usr/share/nginx/html/momo-store

CMD ["nginx", "-g", "daemon off;"]

EXPOSE 80
