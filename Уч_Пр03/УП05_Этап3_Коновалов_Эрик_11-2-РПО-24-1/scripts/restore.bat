@echo off
chcp 65001 > nul
cd /d "%~dp0\.."

echo ========================================
echo  VetCare: Восстановление из backup
echo ========================================
echo.

if "%~1"=="" (
    echo Использование: restore.bat ^<имя_файла_backup^>
    echo.
    echo Доступные backup:
    dir /b backups\*.db 2>nul
    echo.
    pause
    exit /b 1
)

set BACKUP_FILE=%~1

if not exist %BACKUP_FILE% (
    echo [ОШИБКА] Файл %BACKUP_FILE% не найден!
    pause
    exit /b 1
)

echo [1/3] Остановка контейнеров...
docker compose -f docker-compose.prod.yml down 2>nul
echo.

echo [2/3] Восстановление БД из %BACKUP_FILE%...
copy /Y %BACKUP_FILE% vetcare.db
echo.

echo [3/3] Запуск приложения...
docker compose -f docker-compose.prod.yml up -d 2>nul
timeout /t 5 /nobreak > nul
echo.

echo ========================================
echo  Restore завершён!
echo  Откройте http://127.0.0.1:5000
echo  и проверьте данные.
echo ========================================
pause