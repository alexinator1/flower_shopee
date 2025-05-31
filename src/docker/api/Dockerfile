FROM golang:1.23-bullseye AS dev

WORKDIR /app

# Копируем файлы go.mod и go.sum из ./api/
COPY api/go.mod api/go.sum ./
RUN go mod download

# Устанавливаем Delve (отладчик)
RUN go install github.com/go-delve/delve/cmd/dlv@latest

# Копируем весь исходный код из ./api/
COPY api/ .

# Собираем с флагами отладки
RUN go build -gcflags="all=-N -l" -o /flower-shop-api

EXPOSE 40000 8080
CMD ["/go/bin/dlv", "exec", "/flower-shop-api", "--headless", "--listen=:40000", "--api-version=2", "--accept-multiclient"]
