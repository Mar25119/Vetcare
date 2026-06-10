@echo off
chcp 65001 > nul
cd /d "%~dp0\.."

echo ========================================
echo  VetCare: Проверка качества кода
echo ========================================
echo.

echo [1/3] Запуск линтера Ruff...
echo ----------------------------------------
ruff check app/
if errorlevel 1 (
    echo [ВНИМАНИЕ] Ruff нашёл ошибки стиля
) else (
    echo [OK] Ruff: ошибок не найдено
)
echo.

echo [2/3] Проверка форматирования Black...
echo ----------------------------------------
black --check app/
if errorlevel 1 (
    echo [ВНИМАНИЕ] Black: код не отформатирован
    echo Запустите scripts\format.bat для исправления
) else (
    echo [OK] Black: форматирование корректно
)
echo.

echo [3/3] Запуск тестов pytest...
echo ----------------------------------------
if exist tests\ (
    pytest tests/ -v
) else (
    echo [ПРОПУСК] Папка tests/ не найдена
)
echo.

echo ========================================
echo  Проверка завершена
echo ========================================
pause