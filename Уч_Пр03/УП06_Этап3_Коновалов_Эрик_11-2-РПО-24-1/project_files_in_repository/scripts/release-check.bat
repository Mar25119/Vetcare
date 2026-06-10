@echo off
chcp 65001 > nul
cd /d "%~dp0\.."

echo ========================================
echo  VetCare: Финальная проверка перед релизом
echo ========================================
echo.

echo [1/4] Запуск тестов...
call scripts\test.bat
echo.

echo [2/4] Сборка проекта...
call scripts\build.bat
echo.

echo [3/4] Проверка CHANGELOG...
if exist CHANGELOG.md (
    echo [OK] CHANGELOG.md существует
) else (
    echo [ОШИБКА] CHANGELOG.md не найден!
)
echo.

echo [4/4] Проверка RELEASE_NOTES...
if exist RELEASE_NOTES.md (
    echo [OK] RELEASE_NOTES.md существует
) else (
    echo [ОШИБКА] RELEASE_NOTES.md не найден!
)
echo.

echo ========================================
echo  Релиз готов к публикации!
echo ========================================
pause