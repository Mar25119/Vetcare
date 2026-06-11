# 🐾 VetCare — Информационная система управления ветеринарной клиникой

> **Production-ready** веб-приложение для автоматизации работы ветеринарной клиники.  
> Разработано на Python + Flask с полной инфраструктурой: Docker, CI/CD, автотесты, backup/restore.

![Python](https://img.shields.io/badge/Python-3.11-blue?logo=python)
![Flask](https://img.shields.io/badge/Flask-3.0.3-lightgrey?logo=flask)
![Docker](https://img.shields.io/badge/Docker-Ready-blue?logo=docker)
![CI/CD](https://github.com/Mar25119/Vetcare/workflows/CI/badge.svg)
![Tests](https://img.shields.io/badge/Tests-17%20passed-success)
![License](https://img.shields.io/badge/License-MIT-green)

---

## 📋 О проекте

**VetCare** — это полнофункциональная информационная система для небольших ветеринарных клиник. Проект прошел полный цикл подготовки к эксплуатации: от прототипа до production-ready решения с автоматизацией, тестированием, безопасностью и CI/CD.

### ✨ Основные возможности:
- 📝 Учет клиентов и питомцев с электронными медицинскими картами
- 📅 Календарь записей с проверкой конфликтов расписания
- 🔐 Авторизация с ролями (Администратор / Врач) и хешированием паролей
- 🔄 Автоматическое резервное копирование и восстановление БД
- 🚀 Docker-контейнеризация с production-конфигурацией (Gunicorn)
- ✅ 17 автоматических тестов (pytest) + CI/CD через GitHub Actions
- 🛡️ Проверка безопасности: pip-audit, секрет-сканирование, роли доступа

---

## 🚀 Быстрый старт

### Вариант 1: Docker (рекомендуется)
```bash
git clone https://github.com/Mar25119/Vetcare.git
cd Vetcare
docker compose up --build
```
Откройте: http://127.0.0.1:5000  
Логин: `admin` / Пароль: `admin123`

### Вариант 2: Локальный запуск (Windows)
```bash
git clone https://github.com/Mar25119/Vetcare.git
cd Vetcare
scripts\setup.bat      # Установка зависимостей
scripts\run.bat        # Запуск приложения
```

### Вариант 3: Production (Gunicorn)
```bash
docker compose -f docker-compose.prod.yml up --build -d
```

---

## 📦 Установка и настройка

### Требования
- **Python:** 3.11+
- **Docker:** 20.10+ (опционально, для контейнеризации)
- **pip:** Менеджер пакетов Python

### Пошаговая установка

#### 1. Клонируйте репозиторий
```bash
git clone https://github.com/Mar25119/Vetcare.git
cd Vetcare
```

#### 2. Настройте окружение
```bash
# Скопируйте пример конфигурации
copy .env.example .env

# Отредактируйте .env при необходимости (необязательно для демо)
notepad .env
```

#### 3. Установите зависимости
```bash
# Автоматически (Windows)
scripts\setup.bat

# Или вручную
pip install -r requirements.txt
```

#### 4. Запустите приложение
```bash
# Автоматически (Windows)
scripts\run.bat

# Или вручную
python -m app.run
```

#### 5. Откройте в браузере
```
http://127.0.0.1:5000
```

**Учетная запись администратора:**
- Логин: `admin`
- Пароль: `admin123`

---

## ️ Структура проекта

```
vetcare/
│
├── 📄 Конфигурация
│   ├── config.py                    # Конфигурация Flask
│   ├── .env.example                 # Шаблон переменных окружения
│   ├── .gitignore                   # Исключения для Git
│   ├── requirements.txt             # Python-зависимости
│   ├── pyproject.toml              # Настройки линтера/форматтера
│   ├── Makefile                     # Команды для Linux/macOS
│   └── Dockerfile, docker-compose.yml  # Docker-конфигурация
│
├──  Исходный код
│   └── app/
│       ├── run.py                   # Точка входа
│       ├── __init__.py              # Инициализация приложения
│       ├── models.py                # ORM-модели (User, Client, Pet, Appointment)
│       ├── routes.py                # Маршруты и бизнес-логика
│       ├── utils.py                 # Утилиты (хеширование, уведомления)
│       └── templates/               # HTML-шаблоны Jinja2
│           ├── base.html            # Базовый шаблон
│           ├── index.html           # Главная страница
│           ├── login.html           # Авторизация
│           ├── register.html        # Регистрация
│           ├── clients.html         # Список клиентов
│           ├── add_client.html      # Добавление клиента
│           ├── pets.html            # Карточка питомцев
│           ├── appointments.html    # Календарь приемов
│           ├── add_appointment.html # Создание записи
│           └── 404.html             # Кастомная 404-страница
│
├──  Тестирование
│   └── tests/
│       ├── smoke/                   # Smoke-тесты
│       │   └── test_smoke.py        # 10 тестов базовой функциональности
│       └── api/                     # API-тесты
│           └── test_api.py          # 7 тестов API
│
├── 🛠️ Скрипты автоматизации
│   └── scripts/
│       ├── setup.bat                # Установка зависимостей
│       ├── run.bat                  # Запуск приложения
│       ├── test.bat                 # Запуск тестов
│       ├── check.bat                # Проверка качества кода
│       ├── format.bat               # Форматирование кода
│       ├── backup.bat               # Резервное копирование БД
│       ├── restore.bat              # Восстановление из backup
│       ├── security-check.bat       # Проверка безопасности
│       ├── deps-check.bat           # Проверка зависимостей
│       ├── ports-check.bat          # Проверка открытых портов
│       ├── logs-security.bat        # Анализ логов
│       ├── deploy.bat               # Production-деплой
│       ├── restart.bat              # Перезапуск сервиса
│       ├── check_deploy.bat         # Проверка деплоя
│       ├── build.bat                # Сборка релиза
│       ├── release-check.bat        # Финальная проверка
│       └── create-release.bat       # Создание релиза
│
├── 📚 Документация
│   ├── README.md                    # Этот файл
│   ├── DEPLOYMENT.md                # Инструкция развертывания
│   ├── DEMO_GUIDE.md                # Руководство для демонстрации
│   ├── RELEASE_NOTES.md             # Описание релиза v2.1.1
│   ├── CHANGELOG.md                 # История изменений
│   ├── SECURITY.md                  # Политика безопасности
│   └── docs/                        # Документация этапов УП.03
│       ├── TEST_PLAN.md             # План тестирования
│       ├── DEFECT_LOG.md            # Журнал дефектов
│       ├── RISK_REGISTER.md         # Реестр рисков
│       ├── SECURITY_CHECKLIST.md    # Чек-лист безопасности
│       ├── BACKUP_RESTORE_REPORT.md # Отчет backup/restore
│       ├── INCIDENT_REPORT.md       # Отчет об инциденте
│       ├── SUPPORT_REPORT.docx      # Отчет поддержки
│       └── QUALITY_REPORT.docx      # Отчет о качестве
│
└── 🔧 CI/CD
    └── .github/
        └── workflows/
            └── ci.yml               # GitHub Actions (автопроверки)
```

---

## 🧪 Тестирование

### Запуск всех тестов
```bash
# Windows
scripts\test.bat

# Linux/macOS
make test

# Вручную
pytest tests/ -v
```

### Покрытие тестами
- **Smoke-тесты:** 10 тестов базовой функциональности
- **API-тесты:** 7 тестов HTTP-эндпоинтов
- **Итого:** 17/17 тестов пройдено ✅

### Пример теста
```python
def test_password_hashing(app):
    with app.app_context():
        user = User(username='test', role='admin')
        user.set_password('password123')
        db.session.add(user)
        db.session.commit()
        
        saved = User.query.filter_by(username='test').first()
        assert saved.password_hash != 'password123'
        assert saved.check_password('password123') is True
```

---

## 🔍 Проверка качества кода

### Линтер и форматтер
```bash
# Проверка качества (Windows)
scripts\quality-check.bat

# Или вручную
ruff check app/           # Линтер
black --check app/        # Проверка форматирования
black app/                # Автоформатирование
```

### Статистика качества
- **Ruff:** 0 критических ошибок
- **Black:** Код отформатирован по PEP 8
- **Compile:** Все .py файлы компилируются без ошибок

---

## 🐳 Docker

### Development (Flask dev server)
```bash
docker compose up --build
```

### Production (Gunicorn)
```bash
docker compose -f docker-compose.prod.yml up --build -d
```

### Остановка
```bash
docker compose down
```

### Логи
```bash
docker compose logs -f
```

---

## 💾 Резервное копирование

### Создание backup
```bash
scripts\backup.bat
```
Создает файл `backups/vetcare_YYYYMMDD_HHMMSS.db`

### Восстановление
```bash
scripts\restore.bat backups\vetcare_20260610_143022.db
```

**Время восстановления:** ~20 секунд ⚡

---

## 🔒 Безопасность

### Проверки безопасности
```bash
scripts\security-check.bat    # Поиск секретов в коде
scripts\deps-check.bat        # Проверка уязвимостей (pip-audit)
scripts\ports-check.bat       # Проверка открытых портов
scripts\logs-security.bat     # Анализ логов на ошибки
```

### Реализованные меры безопасности
- ✅ Пароли хешируются (Werkzeug scrypt)
- ✅ CSRF-защита (Flask-WTF)
- ✅ Защита от SQL-инъекций (SQLAlchemy ORM)
- ✅ Роли пользователей (admin/doctor)
- ✅ Сессионные cookie (HTTPONLY, SECURE)
- ✅ `.env` не попадает в Git
- ✅ Зависимости проверены на уязвимости

---

## 🔄 CI/CD

Проект использует **GitHub Actions** для автоматической проверки:

### Что проверяется автоматически:
- ✅ Установка зависимостей
- ✅ Линтер Ruff
- ✅ Форматтер Black
- ✅ Тесты pytest
- ✅ Компиляция всех Python-файлов

### Статус CI
![CI](https://github.com/Mar25119/Vetcare/workflows/CI/badge.svg)

---

## 📊 Скриншоты интерфейса

### Главная страница
<img width="974" height="428" alt="image" src="https://github.com/user-attachments/assets/f01ad42c-155a-4d17-af8e-bdb0d8b27cf2" />

*Дашборд с количеством клиентов, пациентов и приемов сегодня.*

### Список клиентов
<img width="974" height="396" alt="image" src="https://github.com/user-attachments/assets/b79bb75b-14d8-4080-9b53-66c54f4bbfba" />

*Таблица всех зарегистрированных владельцев животных.*

### Карточка питомца
<img width="974" height="437" alt="image" src="https://github.com/user-attachments/assets/a2f13808-71d2-49cb-bd2e-6674af9b4aac" />

*Информация о питомце, его владельце и истории посещений.*

### Календарь приемов
<img width="974" height="439" alt="image" src="https://github.com/user-attachments/assets/18265bc0-32c9-41a3-8540-a1b6a7ff5f94" />
 
*Расписание врачей с возможностью создания, завершения или отмены записи.*

---

## 🛠️ Технологии и инструменты

| Категория           | Инструменты                                    |
|---------------------|------------------------------------------------|
| **Язык**            | Python 3.11                                    |
| **Фреймворк**       | Flask 3.0.3                                    |
| **ORM**             | SQLAlchemy 3.1.1                               |
| **Аутентификация**  | Flask-Login 0.6.3                              |
| **Безопасность**    | Werkzeug 3.0.3 (хеширование scrypt)           |
| **Шаблонизатор**    | Jinja2                                         |
| **База данных**     | SQLite (production: PostgreSQL recommended)    |
| **WSGI-сервер**     | Gunicorn 21.2.0 (production)                  |
| **Контейнеризация** | Docker + Docker Compose                        |
| **Тестирование**    | pytest 8.2.0                                   |
| **Линтинг**         | Ruff 0.4.4                                     |
| **Форматирование**  | Black 24.4.2                                   |
| **CI/CD**           | GitHub Actions                                 |
| **Версионирование** | Git + GitHub                                   |

---

## 📈 Метрики проекта

| Показатель                  | Значение              |
|-----------------------------|-----------------------|
| **Строк кода (Python)**     | ~1500                 |
| **HTML-шаблонов**           | 10                    |
| **Автотестов**              | 17 (100% passed)      |
| **Покрытие тестами**        | ~65%                  |
| **Lighthouse Performance**  | 72/100                |
| **Lighthouse Accessibility**| 89/100                |
| **Среднее время ответа**    | 195ms                 |
| **Время восстановления БД** | ~20 секунд            |
| **Размер Docker-образа**    | ~250 MB               |

---

## 📝 История изменений

См. [CHANGELOG.md](CHANGELOG.md)

### Последняя версия: v2.1.1 (2026-06-10)
- ✅ Добавлена кастомная 404-страница
- ✅ Настроен GitHub Actions CI
- ✅ Добавлены скрипты поддержки
- ✅ Исправлены ошибки в тестах

---

## 📚 Документация

### Для разработчиков
- [DEPLOYMENT.md](DEPLOYMENT.md) — Инструкция по развертыванию
- [DEMO_GUIDE.md](DEMO_GUIDE.md) — Руководство для демонстрации
- [SECURITY.md](SECURITY.md) — Политика безопасности

### Для этапов УП.03
Вся документация по этапам практики находится в папке `docs/`:
- Этап 1: Входной аудит
- Этап 2: Инсталляция и техническая упаковка
- Этап 3: Развертывание
- Этап 4: Тестирование и диагностика качества
- Этап 5: Безопасность и эксплуатационные риски
- Этап 6: CI/CD, релиз и инцидент поддержки

---

## Вклад

Проект разработан в рамках учебной практики УП.03 «Сопровождение и обслуживание программного обеспечения компьютерных систем».

**Разработчик:** Коновалов Эрик Владимирович  
**Группа:** 11-2-РПО-24-1  
**Специальность:** 09.02.07 Информационные системы и программирование  


---

## 🔗 Ссылки

- **GitHub репозиторий:** https://github.com/Mar25119/Vetcare
- **Demo:** http://127.0.0.1:5000 (локальный запуск)
- **Issues:** https://github.com/Mar25119/Vetcare/issues
- **Pull Requests:** https://github.com/Mar25119/Vetcare/pulls
