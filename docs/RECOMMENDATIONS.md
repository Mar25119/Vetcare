# RECOMMENDATIONS.md — Рекомендации по безопасности VetCare

## Краткосрочные (1-2 недели)

### 1. Добавить проверку владельца данных
**Проблема:** Врач может видеть записи других врачей  
**Решение:** В `app/routes.py` добавить проверку:
```python
@app.route('/appointment/<int:appointment_id>')
@login_required
def view_appointment(appointment_id):
    appointment = Appointment.query.get_or_404(appointment_id)
    if appointment.doctor_id != current_user.id and current_user.role != 'admin':
        abort(403)
    return render_template('appointment.html', appointment=appointment)
```

### 2. Настроить pre-commit hook
**Проблема:** Случайный коммит .env  
**Решение:** Создать `.git/hooks/pre-commit`:
```bash
#!/bin/bash
if git diff --cached --name-only | grep -q '\.env$'; then
    echo "ERROR: Нельзя коммитить .env файл!"
    exit 1
fi
```

### 3. Интегрировать Flask-Limiter
**Проблема:** Brute-force на форму входа  
**Решение:**
```bash
pip install flask-limiter
```
```python
from flask_limiter import Limiter
limiter = Limiter(key_func=lambda: request.remote_addr)

@app.route('/login', methods=['POST'])
@limiter.limit("5 per minute")
def login():
    ...
```

## Среднесрочные (1-2 месяца)

### 4. Настроить HTTPS
**Проблема:** Трафик в открытом виде  
**Решение:** Nginx + Let's Encrypt
```nginx
server {
    listen 443 ssl;
    ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
    
    location / {
        proxy_pass http://127.0.0.1:5000;
    }
}
```

### 5. Автоматический backup
**Проблема:** Ручной backup забывается  
**Решение:** Cron-задача (Linux):
```bash
0 2 * * * cd /opt/vetcare && ./scripts/backup.sh
```
Windows Task Scheduler для Windows.

### 6. Интегрировать Sentry
**Проблема:** Неизвестно о падениях  
**Решение:**
```bash
pip install sentry-sdk[flask]
```
```python
import sentry_sdk
sentry_sdk.init(dsn="YOUR_SENTRY_DSN")
```

## Долгосрочные (3-6 месяцев)

### 7. Переход на PostgreSQL
**Проблема:** SQLite не масштабируется  
**Решение:** Миграция на PostgreSQL с connection pooling

### 8. CI/CD с security check
**Проблема:** Уязвимости не проверяются автоматически  
**Решение:** GitHub Actions:
```yaml
name: Security Check
on: [push]
jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run pip-audit
        run: pip-audit
```

### 9. Двухфакторная аутентификация
**Проблема:** Пароль можно украсть  
**Решение:** Интегрировать TOTP (Google Authenticator)

### 10. Аудит логов
**Проблема:** Логи не анализируются  
**Решение:** ELK Stack или Grafana Loki

## Вывод

Проект VetCare готов к demo-использованию. Для production необходимо реализовать рекомендации 1-6 в первую очередь.