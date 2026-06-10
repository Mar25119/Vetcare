@echo off
chcp 65001 > nul
cd /d "%~dp0\.."

echo ========================================
echo  VetCare: Проверка производительности
echo ========================================
echo.

set BASE_URL=http://127.0.0.1:5000

echo [1/3] Замер времени ответа главной страницы (5 запросов)...
for /L %%i in (1,1,5) do (
    curl -s -o nul -w "Запрос %%i: %%{time_total} сек\n" %BASE_URL%/ -b cookies.txt
)
echo.

echo [2/3] Замер времени ответа /clients...
for /L %%i in (1,1,3) do (
    curl -s -o nul -w "Запрос %%i: %%{time_total} сек\n" %BASE_URL%/clients -b cookies.txt
)
echo.

echo [3/3] Проверка статуса контейнера...
docker compose -f docker-compose.prod.yml ps
echo.

echo ========================================
echo  Для полного Lighthouse-отчета:
echo  1. Откройте Chrome DevTools (F12)
echo  2. Перейдите во вкладку Lighthouse
echo  3. Нажмите "Analyze page load"
echo ========================================
pause