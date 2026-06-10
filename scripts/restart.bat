@echo off
chcp 65001 > nul
cd /d "%~dp0\.."

echo ========================================
echo  VetCare PRODUCTION Restart
echo ========================================
echo.

echo [1/3] Остановка контейнеров...
docker compose -f docker-compose.prod.yml down
echo.

echo [2/3] Пересборка образа...
docker compose -f docker-compose.prod.yml build
echo.

echo [3/3] Запуск контейнеров...
docker compose -f docker-compose.prod.yml up -d
echo.

timeout /t 3 /nobreak > nul
docker compose -f docker-compose.prod.yml ps
echo.

echo ========================================
echo  Перезапуск завершён!
echo  http://127.0.0.1:5000
echo ========================================
pause