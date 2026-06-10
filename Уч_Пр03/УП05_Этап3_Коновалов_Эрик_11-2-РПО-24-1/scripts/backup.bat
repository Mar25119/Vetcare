@echo off
chcp 65001 > nul
cd /d "%~dp0\.."

echo ========================================
echo  VetCare: Создание резервной копии
echo ========================================
echo.

REM Создаём папку backups если её нет
if not exist backups mkdir backups

REM Получаем текущую дату и время
for /f "tokens=1-4 delims=/.: " %%a in ("%date% %time%") do set TS=%%c%%b%%a_%%d%%e

REM Копируем БД
if exist vetcare.db (
    copy vetcare.db backups\vetcare_%TS%.db
    echo Backup создан: backups\vetcare_%TS%.db
    
    REM Показываем размер
    for %%F in (backups\vetcare_%TS%.db) do set SIZE=%%~zF
    echo Размер: %SIZE% байт
) else (
    echo [ОШИБКА] Файл vetcare.db не найден!
    echo Убедитесь, что приложение хотя бы раз запускалось.
)
echo.

echo ========================================
echo  Backup завершён
echo ========================================
pause