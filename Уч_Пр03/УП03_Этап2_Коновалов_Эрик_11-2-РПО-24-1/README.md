```markdown
# 🐾 VetCare — Информационная система управления ветеринарной клиникой

Веб-приложение для автоматизации работы ветеринарной клиники: учёт клиентов, питомцев, записей на приём, электронные медицинские карты, управление расписанием врачей.

## 🚀 Быстрый старт

### Локальный запуск (Windows)

```bash
# 1. Установка зависимостей
scripts\setup.bat

# 2. Запуск приложения
scripts\run.bat

# 3. Открыть в браузере
http://127.0.0.1:5000
```

**Вход:** `admin` / `admin123`

### Запуск через Makefile (Linux/macOS/Windows с Make)

```bash
make setup    # Установка зависимостей
make run      # Запуск приложения
make check    # Проверка кода
make format   # Форматирование
make help     # Список всех команд
```

### Запуск через Docker

```bash
# Сборка и запуск
docker compose up --build

# Или через Make
make docker-up

# Остановка
docker compose down

# Просмотр логов
docker compose logs -f
```

Приложение будет доступно: **http://127.0.0.1:5000**

## 🛠️ Инструменты качества

| Инструмент | Назначение | Команда |
|------------|------------|---------|
| **Ruff** | Линтер Python | `ruff check app/` |
| **Black** | Форматтер кода | `black app/` |
| **pytest** | Модульные тесты | `pytest tests/ -v` |

### Быстрая проверка качества

```bash
# Windows
scripts\check.bat
scripts\format.bat

# Linux/macOS
make check
make format
```

## 📦 Структура проекта

```
vetcare/
├── app/
│   ├── run.py              # Точка входа
│   ├── __init__.py         # Инициализация Flask
│   ├── models.py           # ORM-модели
│   ├── routes.py           # Маршруты
│   ├── utils.py            # Утилиты
│   └── templates/          # HTML-шаблоны
├── scripts/                # BAT-скрипты для Windows
├── tests/                  # Модульные тесты
├── config.py               # Конфигурация
├── Dockerfile              # Docker-образ
├── docker-compose.yml      # Docker Compose
├── Makefile                # Команды Make
├── requirements.txt        # Зависимости Python
├── pyproject.toml          # Настройки линтера/форматтера
└── .env.example            # Пример конфигурации
```

## 📋 Требования

- Python 3.9+
- pip
- Docker (опционально, для контейнеризации)
- Make (опционально)

## 👥 Роли пользователей

- **Администратор** — управление клиентами, расписанием, пользователями
- **Врач** — медицинские карты, приёмы, диагнозы