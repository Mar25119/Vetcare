@echo off
chcp 65001 > nul
cd /d "%~dp0\.."

echo ========================================
echo  VetCare: Проверка безопасности
echo ========================================
echo.

echo [1/4] Поиск подозрительных слов в коде...
echo ----------------------------------------
git grep -n -i -E "password|secret|token|api_key|apikey|jwt|smtp|database_url" -- . ":!docs" ":!screenshots" ":!*.md" ":!.env.example"
if errorlevel 1 (
    echo [OK] Подозрительных слов не найдено
) else (
    echo [ВНИМАНИЕ] Найдены совпадения - проверьте, что это не реальные секреты
)
echo.

echo [2/4] Проверка .gitignore...
echo ----------------------------------------
findstr /C:".env" .gitignore >nul
if errorlevel 1 (
    echo [ОШИБКА] .env не добавлен в .gitignore!
) else (
    echo [OK] .env в .gitignore
)

findstr /C:"*.db" .gitignore >nul
if errorlevel 1 (
    echo [ОШИБКА] *.db не добавлен в .gitignore!
) else (
    echo [OK] *.db в .gitignore
)
echo.

echo [3/4] Проверка наличия .env в репозитории...
echo ----------------------------------------
if exist .env (
    echo [ВНИМАНИЕ] Файл .env существует локально
    git ls-files --error-unmatch .env >nul 2>&1
    if errorlevel 1 (
        echo [OK] .env не отслеживается Git
    ) else (
        echo [ОШИБКА] .env загружен в Git! Немедленно удалите!
    )
) else (
    echo [OK] Файл .env не найден
)
echo.

echo [4/4] Статус Git...
echo ----------------------------------------
git status --short
echo.

echo ========================================
echo  Проверка безопасности завершена
echo ========================================
pause