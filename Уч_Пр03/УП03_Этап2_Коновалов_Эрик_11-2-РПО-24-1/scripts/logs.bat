@echo off
chcp 65001 > nul
cd /d "%~dp0\.."

echo ========================================
echo  VetCare: Просмотр логов
echo ========================================
echo.
echo Для выхода нажмите Ctrl+C
echo ========================================
echo.

docker compose logs -f