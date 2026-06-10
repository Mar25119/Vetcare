```markdown
# 🚀 DEPLOYMENT.md — Инструкция по развертыванию VetCare

## 1. Где развернут проект

**Вариант:** Локальный demo-стенд через Docker  
**Адрес:** http://127.0.0.1:5000  
**Контейнер:** vetcare-prod

## 2. Требования

- **ОС:** Windows 10/11, macOS, Linux
- **Docker:** 20.10+
- **Docker Compose:** 2.0+
- **Порты:** 5000 (свободен)
- **База данных:** SQLite (встроенная, создаётся автоматически)
- **WSGI-сервер:** Gunicorn (для production)

## 3. Переменные окружения

| Переменная | Описание | По умолчанию |
|------------|----------|--------------|
| `FLASK_ENV` | Режим работы | `production` |
| `FLASK_DEBUG` | Режим отладки | `0` (выключен) |
| `SECRET_KEY` | Секретный ключ | должен быть изменён |
| `DATABASE_URL` | Путь к БД | `sqlite:////app/instance/vetcare.db` |
| `GUNICORN_WORKERS` | Количество воркеров | `4` |

Файл `.env.production.example` содержит все переменные без реальных секретов.

## 4. Команды развертывания

### Быстрый старт (через BAT-скрипт)

```bash
# Windows
scripts\deploy.bat

# Проверка статуса
scripts\check_deploy.bat

# Перезапуск
scripts\restart.bat
```

### Ручное развертывание

```bash
# 1. Клонирование проекта
git clone https://github.com/Mar25119/Vetcare.git
cd Vetcare

# 2. Создание production-конфигурации
cp .env.production.example .env.production

# 3. Сборка и запуск
docker compose -f docker-compose.prod.yml up --build -d

# 4. Проверка статуса
docker compose -f docker-compose.prod.yml ps

# 5. Просмотр логов
docker compose -f docker-compose.prod.yml logs -f
```

## 5. Проверка развертывания

### Адрес приложения
```
http://127.0.0.1:5000
```

### Команда просмотра логов
```bash
docker compose -f docker-compose.prod.yml logs -f
```

### Команда перезапуска
```bash
docker compose -f docker-compose.prod.yml restart
```

### Основной сценарий проверки
1. Открыть http://127.0.0.1:5000
2. Войти: логин `admin`, пароль `admin123`
3. Создать нового клиента
4. Добавить питомца
5. Создать запись на приём
6. Проверить календарь приёмов

## 6. Остановка и перезапуск

### Остановка
```bash
docker compose -f docker-compose.prod.yml down
```

### Перезапуск
```bash
docker compose -f docker-compose.prod.yml down
docker compose -f docker-compose.prod.yml up --build -d
```

### Полная очистка (с удалением БД)
```bash
docker compose -f docker-compose.prod.yml down -v
docker compose -f docker-compose.prod.yml up --build -d
```

## 7. Отличия от локальной разработки

| Параметр | Development | Production |
|----------|-------------|------------|
| Сервер | Flask dev server | Gunicorn |
| Debug | Включён | Выключен |
| Workers | 1 | 4 |
| Hot reload | Да | Нет |
| Логи | Console | File + Console |

## 8. Troubleshooting

### Проблема: Порт 5000 занят
**Решение:** Измените порт в `docker-compose.prod.yml`:
```yaml
ports:
  - "8080:5000"
```
Откройте http://127.0.0.1:8080

### Проблема: БД не создаётся
**Решение:** Проверьте права на volumes:
```bash
docker compose -f docker-compose.prod.yml logs app
```

### Проблема: Контейнер не стартует
**Решение:** Посмотрите логи:
```bash
docker compose -f docker-compose.prod.yml logs --tail=100
```
```