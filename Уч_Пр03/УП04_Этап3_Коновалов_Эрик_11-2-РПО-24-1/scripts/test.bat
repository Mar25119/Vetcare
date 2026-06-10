@echo off
chcp 65001 > nul
cd /d "%~dp0\.."

echo ========================================
echo  VetCare: Запуск тестов
echo ========================================
echo.

echo [1/2] Smoke-тесты...
pytest tests/smoke/ -v --tb=short
if errorlevel 1 (
    echo [ОШИБКА] Smoke-тесты не пройдены
    pause
    exit /b 1
)
echo.

echo [2/2] API-тесты...
pytest tests/api/ -v --tb=short
if errorlevel 1 (
    echo [ОШИБКА] API-тесты не пройдены
    pause
    exit /b 1
)
echo.

echo ========================================
echo  Все тесты пройдены!
echo ========================================
pause