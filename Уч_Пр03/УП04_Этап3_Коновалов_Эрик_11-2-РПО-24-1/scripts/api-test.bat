@echo off
chcp 65001 > nul
cd /d "%~dp0\.."

echo ========================================
echo  VetCare: API-проверки через curl
echo ========================================
echo.

set BASE_URL=http://127.0.0.1:5000

echo [1/6] GET /login
curl -s -o nul -w "HTTP Status: %%{http_code}\n" %BASE_URL%/login
echo.

echo [2/6] GET / (без авторизации)
curl -s -o nul -w "HTTP Status: %%{http_code}\n" %BASE_URL%/
echo.

echo [3/6] GET /clients (без авторизации)
curl -s -o nul -w "HTTP Status: %%{http_code}\n" %BASE_URL%/clients
echo.

echo [4/6] POST /login с неверным паролем
curl -s -o nul -w "HTTP Status: %%{http_code}\n" -X POST %BASE_URL%/login -d "username=admin&password=wrong"
echo.

echo [5/6] GET /несуществующий_URL
curl -s -o nul -w "HTTP Status: %%{http_code}\n" %BASE_URL%/nonexistent_xyz
echo.

echo [6/6] POST /login с верными данными
curl -s -o nul -w "HTTP Status: %%{http_code}\n" -X POST %BASE_URL%/login -d "username=admin&password=admin123" -c cookies.txt
echo.

echo ========================================
echo  API-проверки завершены
echo ========================================
pause