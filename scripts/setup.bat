@echo off
chcp 65001 > nul
cd /d "%~dp0\.."

echo ========================================
echo  VetCare: Установка зависимостей
echo ========================================
echo.

REM Проверка Python
python --version >nul 2>&1
if errorlevel 1 (
    echo [ОШИБКА] Python не найден. Установите Python 3.9+ с https://python.org
    pause
    exit /b 1
)

echo [1/3] Обновление pip...
python -m pip install --upgrade pip

echo.
echo [2/3] Установка зависимостей из requirements.txt...
pip install -r requirements.txt

echo.
echo [3/3] Проверка установки...
pip list | findstr "Flask SQLAlchemy Login Werkzeug ruff black pytest"

echo.
echo ========================================
echo  Установка завершена успешно!
echo ========================================
pause