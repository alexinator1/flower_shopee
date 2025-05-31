# Makefile для Flower Shop API

.PHONY: all build run generate test clean help

# Переменные
GO_MODULE := flower-shop
OAPI_CODEGEN := github.com/deepmap/oapi-codegen/v2
BINARY_NAME := flower-shop-api
SCHEMAS_DIR := schemes
API_DIR := api
GEN_DIR := api/generated

all: build

## build: Собирает проект
build: generate
	@echo "Building $(BINARY_NAME)..."
	@cd $(API_DIR) && go build -o ../bin/$(BINARY_NAME) ./main.go

## run: Запускает сервер в dev-режиме
run: generate
	@echo "Starting server..."
	@cd $(API_DIR) && go run ./main.go

## generate: Генерирует код по OpenAPI спецификациям
generate:
	@echo "Generating code from OpenAPI specs..."
	@mkdir -p $(GEN_DIR)
	@go run $(OAPI_CODEGEN)/cmd/oapi-codegen \
		-generate types,server \
		-package generated \
		$(SCHEMAS_DIR)/openapi.yaml > $(GEN_DIR)/api.gen.go
	@go run golang.org/x/tools/cmd/goimports -w $(GEN_DIR)/*.gen.go
	@echo "Code generation completed!"

## docker-up: Запуск Docker-окружения
up:
	@echo "Starting Docker containers..."
	@docker-compose -f docker-compose.yml up -d --build

## test: Запускает тесты
test:
	@echo "Running tests..."
	@cd $(API_DIR) && go test -v ./...

## install-deps: Устанавливает зависимости
install-deps:
	@echo "Installing dependencies..."
	@cd $(API_DIR) && go mod download
	@go install $(OAPI_CODEGEN)/cmd/oapi-codegen@latest
	@go install golang.org/x/tools/cmd/goimports@latest

## clean: Очищает сгенерированные файлы
clean:
	@echo "Cleaning up..."
	@rm -rf $(GEN_DIR)/*
	@rm -f bin/$(BINARY_NAME)

## help: Выводит справку по командам
help:
	@echo "Доступные команды:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)