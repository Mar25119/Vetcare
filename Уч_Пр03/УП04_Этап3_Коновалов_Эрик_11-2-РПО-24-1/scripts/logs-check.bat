@echo off
chcp 65001 > nul
cd /d "%~dp0\.."

echo ========================================
echo  VetCare: Проверка логов
echo ========================================
echo.

echo [1/3] Последние 50 строк логов:
echo ----------------------------------------
docker compose -f docker-compose.prod.yml logs --tail=50
echo.

echo [2/3] Поиск критических ошибок (500, ERROR, Traceback):
echo ----------------------------------------
docker compose -f docker-compose.prod.yml logs | findstr /I "500 ERROR Traceback"
if errorlevel 1 (
    echo [OK] Критических ошибок не найдено
) else (
    echo [ВНИМАНИЕ] Найдены критические ошибки - см. DEFECT_LOG.md
)
echo.

echo [3/3] Статус контейнера:
docker compose -f docker-compose.prod.yml ps
echo.

echo ========================================
echo  Проверка логов завершена
echo ========================================
pause