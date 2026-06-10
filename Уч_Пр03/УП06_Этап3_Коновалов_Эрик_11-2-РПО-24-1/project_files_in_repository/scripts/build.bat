@echo off
chcp 65001 > nul
cd /d "%~dp0\.."

echo ========================================
echo  VetCare: Сборка проекта
echo ========================================
echo.

echo [1/3] Проверка синтаксиса Python...
python -m compileall -q .
if errorlevel 1 (
    echo [ОШИБКА] Ошибки компиляции
    pause
    exit /b 1
)
echo [OK] Синтаксис корректен
echo.

echo [2/3] Проверка зависимостей...
pip list --format=columns | findstr "Flask SQLAlchemy Login"
echo.

echo [3/3] Создание архива релиза...
if not exist release mkdir release
tar -czf release\vetcare-2.1.1.tar.gz --exclude=__pycache__ --exclude=.git --exclude=.venv --exclude=release --exclude=*.db --exclude=.env* .
echo [OK] Архив создан: release\vetcare-2.1.1.tar.gz
echo.

echo ========================================
echo  Сборка завершена!
echo ========================================
pause