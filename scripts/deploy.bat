@echo off
chcp 65001 > nul
cd /d "%~dp0\.."

echo ========================================
echo  VetCare PRODUCTION Deployment
echo ========================================
echo.

echo [1/4] Создание production-конфигурации...
if not exist .env.production (
    copy .env.production.example .env.production
    echo Файл .env.production создан
) else (
    echo Файл .env.production уже существует
)
echo.

echo [2/4] Сборка Docker-образа...
docker compose -f docker-compose.prod.yml build
if errorlevel 1 (
    echo [ОШИБКА] Сборка не удалась
    pause
    exit /b 1
)
echo.

echo [3/4] Запуск контейнеров...
docker compose -f docker-compose.prod.yml up -d
if errorlevel 1 (
    echo [ОШИБКА] Запуск не удался
    pause
    exit /b 1
)
echo.

echo [4/4] Проверка статуса...
timeout /t 5 /nobreak > nul
docker compose -f docker-compose.prod.yml ps
echo.

echo ========================================
echo  Развертывание завершено!
echo  Приложение доступно: http://127.0.0.1:5000
echo  Логин: admin
echo  Пароль: admin123
echo ========================================
echo.

pause