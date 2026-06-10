.PHONY: setup run check format docker-build docker-up docker-down logs clean help

help:
	@echo "========================================"
	@echo " VetCare - Команды Makefile"
	@echo "========================================"
	@echo "  make setup       - Установка зависимостей"
	@echo "  make run         - Запуск приложения локально"
	@echo "  make check       - Проверка кода (линтер + тесты)"
	@echo "  make format      - Форматирование кода"
	@echo "  make docker-build- Сборка Docker-образа"
	@echo "  make docker-up   - Запуск в Docker"
	@echo "  make docker-down - Остановка Docker"
	@echo "  make logs        - Просмотр логов Docker"
	@echo "  make clean       - Очистка временных файлов"
	@echo "========================================"

setup:
	@echo ">>> Установка зависимостей..."
	python -m pip install --upgrade pip
	pip install -r requirements.txt
	@echo ">>> Установка завершена"

run:
	@echo ">>> Запуск приложения на http://127.0.0.1:5000"
	python -m app.run

check:
	@echo ">>> Запуск линтера Ruff..."
	ruff check app/
	@echo ">>> Проверка форматирования Black..."
	black --check app/
	@echo ">>> Запуск тестов..."
	-pytest tests/ -v

format:
	@echo ">>> Форматирование кода..."
	black app/
	ruff check --fix app/
	@echo ">>> Форматирование завершено"

docker-build:
	@echo ">>> Сборка Docker-образа..."
	docker compose build

docker-up:
	@echo ">>> Запуск в Docker..."
	docker compose up --build

docker-down:
	@echo ">>> Остановка Docker-контейнеров..."
	docker compose down

logs:
	docker compose logs -f

clean:
	@echo ">>> Очистка временных файлов..."
	-find . -type d -name "__pycache__" -exec rm -rf {} +
	-find . -type f -name "*.pyc" -delete
	-find . -type f -name "*.pyo" -delete
	-rm -rf .pytest_cache
	-rm -rf .ruff_cache
	@echo ">>> Очистка завершена"

# ==================================
# Этап 4: Тестирование и диагностика
# ==================================

test:
	@echo ">>> Запуск smoke-тестов..."
	pytest tests/smoke/ -v
	@echo ">>> Запуск API-тестов..."
	pytest tests/api/ -v

api-test:
	@echo ">>> API-проверки через curl..."
	curl -s -o nul -w "GET /login: %{http_code}\n" http://127.0.0.1:5000/login
	curl -s -o nul -w "GET /: %{http_code}\n" http://127.0.0.1:5000/
	curl -s -o nul -w "GET /clients: %{http_code}\n" http://127.0.0.1:5000/clients

quality-check:
	@echo ">>> Линтер Ruff..."
	ruff check app/
	@echo ">>> Форматтер Black..."
	black --check app/
	@echo ">>> Smoke-тесты..."
	pytest tests/smoke/ -q
	@echo ">>> API-тесты..."
	pytest tests/api/ -q

performance:
	@echo ">>> Замеры времени ответа..."
	@curl -s -o nul -w "GET /: %{time_total}s\n" http://127.0.0.1:5000/ -b cookies.txt
	@curl -s -o nul -w "GET /clients: %{time_total}s\n" http://127.0.0.1:5000/clients -b cookies.txt

logs-check:
	@echo ">>> Логи контейнера (последние 50 строк):"
	docker compose -f docker-compose.prod.yml logs --tail=50