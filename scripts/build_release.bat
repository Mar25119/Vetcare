@echo off
chcp 65001 > nul
cd /d "%~dp0\.."

echo ========================================
echo  VetCare Release Build
echo ========================================
echo.

echo [1/5] Очистка старых артефактов...
if exist release rmdir /s /q release
mkdir release
echo.

echo [2/5] Проверка качества кода...
ruff check app/
black --check app/
if errorlevel 1 (
    echo [ВНИМАНИЕ] Есть проблемы с кодом. Запустите scripts\format.bat
    pause
    exit /b 1
)
echo.

echo [3/5] Запуск тестов...
pytest tests/ -v
if errorlevel 1 (
    echo [ОШИБКА] Тесты не пройдены
    pause
    exit /b 1
)
echo.

echo [4/5] Создание архива проекта...
tar -czf release\vetcare-2.1.0.tar.gz --exclude=__pycache__ --exclude=.git --exclude=.venv --exclude=release --exclude=*.db --exclude=.env* .
echo.

echo [5/5] Копирование документации...
copy DEPLOYMENT.md release\
copy DEMO_GUIDE.md release\
copy RELEASE_NOTES.md release\
copy README.md release\
copy .env.production.example release\
echo.

echo ========================================
echo  Релиз собран!
echo  Файлы в папке release\
echo ========================================
dir release\
echo.

pause