@echo off
chcp 65001 > nul
cd /d "%~dp0\.."

echo ========================================
echo  VetCare: Анализ логов безопасности
echo ========================================
echo.

echo [1/4] Последние 50 строк логов...
echo ----------------------------------------
docker compose -f docker-compose.prod.yml logs --tail=50 2>nul
if errorlevel 1 (
    echo [INFO] Docker Compose не запущен
)
echo.

echo [2/4] Поиск критических ошибок...
echo ----------------------------------------
docker compose -f docker-compose.prod.yml logs 2>nul | findstr /I "ERROR Traceback 500 FATAL"
if errorlevel 1 (
    echo [OK] Критических ошибок не найдено
) else (
    echo [ВНИМАНИЕ] Найдены критические ошибки - см. DEFECT_LOG.md
)
echo.

echo [3/4] Поиск подозрительных запросов...
echo ----------------------------------------
docker compose -f docker-compose.prod.yml logs 2>nul | findstr /I "401 403 404"
if errorlevel 1 (
    echo [OK] Подозрительных запросов не найдено
) else (
    echo [INFO] Найдены запросы с кодами 401/403/404
)
echo.

echo [4/4] Статус контейнера...
echo ----------------------------------------
docker compose -f docker-compose.prod.yml ps 2>nul
echo.

echo ========================================
echo  Анализ логов завершён
echo ========================================
pause