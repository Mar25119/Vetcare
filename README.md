# 🐾 VetCare — Информационная система управления ветеринарной клиникой

> Учебный проект по разработке веб-приложения для автоматизации работы ветеринарной клиники.  
> Реализован на Python + Flask с использованием SQLAlchemy, Flask-Login и Jinja2.

![Python](https://img.shields.io/badge/Python-3.9+-blue?logo=python)
![Flask](https://img.shields.io/badge/Flask-3.0-lightgrey?logo=flask)
![SQLite](https://img.shields.io/badge/Database-SQLite-green?logo=sqlite)

---

## О проекте

**VetCare** — это веб-приложение, которое помогает небольшим ветеринарным клиникам вести учет клиентов, питомцев, записей на прием и медицинских карт. Система заменяет бумажные журналы и Excel-таблицы, снижая риск ошибок и экономя время персонала.

### Основные возможности:
- Регистрация клиентов и питомцев
- Электронные медицинские карты (история посещений)
- Календарь записей на прием с проверкой занятости слотов
- Авторизация с ролями: Администратор / Врач
- Валидация данных и защита от дублирования

---

## Скриншоты интерфейса


### Главная страница
<img width="974" height="428" alt="image" src="https://github.com/user-attachments/assets/f01ad42c-155a-4d17-af8e-bdb0d8b27cf2" />

*Дашборд с количеством клиентов, пациентов и приемов сегодня.*

### Список клиентов
<img width="974" height="396" alt="image" src="https://github.com/user-attachments/assets/b79bb75b-14d8-4080-9b53-66c54f4bbfba" />

*Таблица всех зарегистрированных владельцев животных.*

### Карточка питомца
<img width="974" height="437" alt="image" src="https://github.com/user-attachments/assets/a2f13808-71d2-49cb-bd2e-6674af9b4aac" />

*Информация о питомце, его владельце и истории посещений.*

### Календарь приемов
<img width="974" height="439" alt="image" src="https://github.com/user-attachments/assets/18265bc0-32c9-41a3-8540-a1b6a7ff5f94" />
 
*Расписание врачей с возможностью создания, завершения или отмены записи.*



## Установка и запуск

### Требования
- Python 3.9 
- pip 

### Шаги установки

1. Клонируйте репозиторий:
```bash
git clone https://github.com/your-username/vetcare.git
cd vetcare
```

2. Создайте виртуальное окружение (рекомендуется):
```bash
python -m venv .venv
# Windows
.venv\Scripts\activate
# macOS/Linux
source .venv/bin/activate
```

3. Установите зависимости:
```bash
pip install -r requirements.txt
```

4. Запустите приложение:
```bash
python run.py
```

5. Откройте в браузере: [http://localhost:5000](http://localhost:5000)

6. Войдите под учетной записью администратора:
   - Логин: `admin`
   - Пароль: `admin123`

7. *(Опционально)* Зарегистрируйте врача через `/register` (доступно только админу).

---

## Структура проекта

```
vetcare/
│
├── config.py               # Конфигурация (секретные ключи, БД)
├── requirements.txt        # Зависимости проекта
│
└── app/
    ├── run.py              # Точка входа — запускает приложение
    ├── __init__.py         # Инициализация Flask-приложения, создание БД
    ├── models.py           # Модели данных (User, Client, Pet, Appointment)
    ├── routes.py           # Маршруты и бизнес-логика (контроллеры)
    ├── utils.py            # Утилиты: хеширование паролей, уведомления
    │
    └── templates/          # HTML-шаблоны (Jinja2)
        ├── base.html       # Базовый шаблон (хедер, навигация, стили)
        ├── index.html      # Главная страница
        ├── login.html      # Форма входа
        ├── register.html   # Регистрация нового пользователя
        ├── clients.html    # Список клиентов
        ├── add_client.html # Форма добавления клиента
        ├── pets.html       # Карточка питомцев клиента
        ├── appointments.html # Календарь приемов
        └── add_appointment.html # Форма создания записи
```

---

## Описание ключевых модулей

### 1. `app/models.py` — Модели данных
Здесь определены все сущности системы как классы SQLAlchemy ORM.

```python
class User(UserMixin, db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True)
    password_hash = db.Column(db.String(256))
    role = db.Column(db.String(20))  # 'admin' или 'doctor'
    ...
    def set_password(self, password): ...
    def check_password(self, password): ...
```

**Безопасность:** Пароли хранятся в хешированном виде благодаря `werkzeug.security`.

---

### 2. `app/routes.py` — Маршруты и логика
Обрабатывает HTTP-запросы, вызывает модели, рендерит шаблоны.

Пример: создание новой записи на прием

```python
@app.route('/add_appointment', methods=['GET', 'POST'])
@login_required
def add_appointment():
    if request.method == 'POST':
        pet_id = request.form['pet_id']
        doctor_id = request.form['doctor_id']
        date_time_str = request.form['date_time']
        
        try:
            date_time = datetime.strptime(date_time_str, '%Y-%m-%dT%H:%M')
        except ValueError:
            flash('Неверный формат даты!', 'error')
            return redirect(url_for('add_appointment'))
            
        # Проверка: не занято ли время у этого врача?
        conflict = Appointment.query.filter(
            Appointment.doctor_id == doctor_id,
            Appointment.date_time == date_time,
            Appointment.status != 'cancelled'
        ).first()
        
        if conflict:
            flash('Это время уже занято!', 'warning')
            return redirect(url_for('add_appointment'))
            
        new_appointment = Appointment(...)
        db.session.add(new_appointment)
        db.session.commit()
        send_notification(...)  # Эмуляция уведомления
        flash('Запись создана!', 'success')
        return redirect(url_for('list_appointments'))
```

**Обработка ошибок:** Все формы имеют серверную валидацию. Даты парсятся безопасно, конфликты расписания проверяются до сохранения.

---

### 3. `app/utils.py` — Утилиты
Функции для хеширования паролей и отправки уведомлений.

```python
def send_notification(user_phone, user_email, message_type, details):
    """Эмуляция отправки SMS/email. Логирует событие."""
    logging.info(f"[{datetime.now()}] {message_type.upper()} | To: {user_phone} | {details}")
    print(f" Notification sent: {details}")  # Только в режиме DEBUG
```

**Логирование:** Все "отправленные" уведомления записываются в файл `notifications.log` для аудита.

---

### 4. `templates/base.html` — Базовый шаблон
Содержит общий дизайн: синюю шапку, навигацию, блок для flash-сообщений.

```html
<header>
    <h1>🐾 VetCare System</h1>
</header>
<nav>
    {% if current_user.is_authenticated %}
        <a href="{{ url_for('index') }}">Главная</a>
        <a href="{{ url_for('list_clients') }}">Клиенты</a>
        <a href="{{ url_for('list_appointments') }}">Приёмы</a>
        <span class="user-info">
             {{ current_user.full_name }} ({{ current_user.role }}) | 
            <a href="{{ url_for('logout') }}">Выйти</a>
        </span>
    {% endif %}
</nav>
```

 **UI/UX:** Интерфейс адаптивный, использует единый стиль CSS внутри `<style>` тега (для простоты MVP).

---

## Тестирование

Проект покрыт модульными тестами с помощью `pytest`.

### Запуск тестов:
```bash
pip install pytest
pytest tests/ -v
```

### Пример теста (`tests/test_models.py`):
```python
def test_user_password_hashing(client):
    with client.application.app_context():
        user = User(username='testuser', role='admin')
        user.set_password('secret123')
        db.session.add(user)
        db.session.commit()
        
        saved_user = User.query.filter_by(username='testuser').first()
        assert saved_user.password_hash != 'secret123'
        assert saved_user.check_password('secret123') is True
```

**Результат:** Все тесты проходят успешно. Проверено хеширование, уникальность телефонов, статусы приемов.

---

## 🛠️ Технологии и инструменты

| Категория        | Инструменты                          |
|------------------|--------------------------------------|
| Язык             | Python 3.9+                          |
| Фреймворк        | Flask                                |
| ORM              | SQLAlchemy                           |
| Аутентификация   | Flask-Login                          |
| Хеширование      | Werkzeug Security                    |
| Шаблонизатор     | Jinja2                               |
| База данных      | SQLite (файл `instance/vetcare.db`)  |
| Тестирование     | pytest                               |
| Линтинг          | Flake8, Pylint                       |
| Версионирование  | Git                                  |
| IDE              | VS Code / PyCharm                    |


