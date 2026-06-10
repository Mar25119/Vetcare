# CHANGELOG.md

Все значимые изменения проекта VetCare.

## [2.1.1] - 2026-06-10

### Fixed
- Добавлена кастомная 404-страница вместо стандартной Werkzeug (BUG-02)
- Исправлены ошибки в тестовой инфраструктуре (fixture 'self' not found)
- Исправлен дубликат создания admin в API-тестах

### Added
- GitHub Actions CI для автоматической проверки при push/PR
- Скрипты поддержки: test.bat, build.bat, release-check.bat, create-release.bat
- INCIDENT_REPORT.md для документирования инцидентов
- RELEASE_CHECKLIST.md для финальных проверок

### Changed
- Обновлён Dockerfile.prod с Gunicorn
- Улучшена обработка ошибок валидации в формах

### Verified
- Локальные проверки: scripts\test.bat, scripts\quality-check.bat
- CI: GitHub Actions passed (Python 3.11, Ubuntu)
- Ручная проверка: переход на несуществующий URL показывает кастомную страницу

---

## [2.1.0] - 2026-06-09

### Added
- Production-развёртывание через Docker + Gunicorn
- Резервное копирование и восстановление БД (backup.bat, restore.bat)
- Проверки безопасности (security-check.bat, deps-check.bat)
- Полное тестирование качества (pytest, Lighthouse, DevTools)

### Fixed
- Race condition при создании БД в Gunicorn (уменьшено до 1 worker)
- Проблема с путём к БД в тестах (sqlite:///:memory:)
- Удалены служебные файлы (.vs/, notifications.log) из Git

---

## [2.0.0] - 2026-06-05

### Added
- Полная система управления ветеринарной клиникой
- Модуль авторизации с ролями (admin/doctor)
- CRUD для клиентов, питомцев, приёмов
- Электронные медицинские карты
- Docker-контейнеризация
- Линтеры и форматтеры (Ruff, Black)