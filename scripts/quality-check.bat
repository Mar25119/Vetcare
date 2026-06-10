@echo off
chcp 65001 > nul
cd /d "%~dp0\.."

echo ========================================
echo  VetCare: Комплексная проверка качества
echo ========================================
echo.

echo [1/4] Линтер Ruff...
ruff check app/
if errorlevel 1 (
    echo [ВНИМАНИЕ] Есть замечания линтера
) else (
    echo [OK] Линтер пройден
)
echo.

echo [2/4] Форматтер Black...
black --check app/
if errorlevel 1 (
    echo [ВНИМАНИЕ] Код не отформатирован
) else (
    echo [OK] Форматирование корректно
)
echo.

echo [3/4] Smoke-тесты...
pytest tests/smoke/ -q
if errorlevel 1 (
    echo [ОШИБКА] Smoke-тесты не пройдены
) else (
    echo [OK] Smoke-тесты пройдены
)
echo.

echo [4/4] API-тесты...
pytest tests/api/ -q
if errorlevel 1 (
    echo [ОШИБКА] API-тесты не пройдены
) else (
    echo [OK] API-тесты пройдены
)
echo.

echo ========================================
echo  Проверка качества завершена
echo ========================================
pause