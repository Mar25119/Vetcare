@echo off
chcp 65001 > nul
cd /d "%~dp0\.."

echo ========================================
echo  VetCare: Запуск тестов
echo ========================================
echo.

echo [1/3] Линтер Ruff...
ruff check app/
if errorlevel 1 (
    echo [ВНИМАНИЕ] Есть замечания линтера
)
echo.

echo [2/3] Форматтер Black...
black --check app/
if errorlevel 1 (
    echo [ВНИМАНИЕ] Код не отформатирован
)
echo.

echo [3/3] Тесты pytest...
pytest tests/ -v --tb=short
if errorlevel 1 (
    echo [ОШИБКА] Тесты не пройдены
    pause
    exit /b 1
)
echo.

echo ========================================
echo  Все проверки пройдены!
echo ========================================
pause