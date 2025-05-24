FROM golang:1.24-bookworm AS dev

WORKDIR /app
COPY src/api/go.mod src/api/go.sum ./
RUN go mod download

# Устанавливаем Delve (дебаггер для Go)
RUN go install github.com/go-delve/delve/cmd/dlv@latest

# Копируем исходный код
COPY src/api/ .

# Собираем с отладочной информацией
RUN go build -gcflags="all=-N -l" -o /flower-shop-api

# Запускаем дебаггер
EXPOSE 40000 8080
CMD ["/go/bin/dlv", "exec", "/flower-shop-api", "--headless", "--listen=:40000", "--api-version=2", "--accept-multiclient"]