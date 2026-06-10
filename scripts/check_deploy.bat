@echo off
chcp 65001 > nul
cd /d "%~dp0\.."

echo ========================================
echo  VetCare PRODUCTION Status Check
echo ========================================
echo.

echo [1/4] Статус контейнеров:
docker compose -f docker-compose.prod.yml ps
echo.

echo [2/4] Последние 30 строк логов:
echo ----------------------------------------
docker compose -f docker-compose.prod.yml logs --tail=30
echo.

echo [3/4] Проверка доступности:
curl -s -o nul -w "HTTP Status: %%{http_code}\n" http://127.0.0.1:5000/
echo.

echo [4/4] Использование ресурсов:
docker stats --no-stream vetcare-prod
echo.

echo ========================================
echo  Проверка завершена
echo ========================================
pause