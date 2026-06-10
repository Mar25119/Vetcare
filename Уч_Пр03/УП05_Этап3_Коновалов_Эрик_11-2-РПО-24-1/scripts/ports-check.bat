@echo off
chcp 65001 > nul
cd /d "%~dp0\.."

echo ========================================
echo  VetCare: Проверка портов и сервисов
echo ========================================
echo.

echo [1/3] Docker-контейнеры...
echo ----------------------------------------
docker compose -f docker-compose.prod.yml ps 2>nul
if errorlevel 1 (
    echo [INFO] Docker Compose не запущен
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
)
echo.

echo [2/3] Открытые порты Windows...
echo ----------------------------------------
netstat -ano | findstr LISTENING | findstr :5000
if errorlevel 1 (
    echo [INFO] Порт 5000 не слушается
) else (
    echo [OK] Порт 5000 активен
)
echo.

echo Все слушающие порты:
netstat -ano | findstr LISTENING
echo.

echo [3/3] Проверка доступности приложения...
echo ----------------------------------------
curl -s -o nul -w "HTTP Status: %%{http_code}\n" http://127.0.0.1:5000/
echo.

echo ========================================
echo  Проверка портов завершена
echo ========================================
pause