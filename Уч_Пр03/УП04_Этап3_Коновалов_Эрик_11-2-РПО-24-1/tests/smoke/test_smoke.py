"""
Smoke-тесты для VetCare
Проверяют базовую работоспособность приложения
"""
import pytest
import sys
import os

# Добавляем корень проекта в путь
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..')))

from app import create_app, db
from app.models import User, Client, Pet


@pytest.fixture
def app():
    """Создание тестового приложения"""
    app = create_app()
    app.config['TESTING'] = True
    app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///:memory:'
    app.config['WTF_CSRF_ENABLED'] = False
    
    with app.app_context():
        db.create_all()
        yield app
        db.drop_all()


@pytest.fixture
def client(app):
    """Тестовый клиент Flask"""
    return app.test_client()


class TestSmokeTests:
    """Базовые smoke-тесты"""
    
    def test_home_page_redirect(self, client):
        """TC-01: Главная страница редиректит на login без авторизации"""
        response = client.get('/')
        assert response.status_code == 302
        assert '/login' in response.location
    
    def test_login_page_accessible(self, client):
        """TC-02: Страница входа доступна"""
        response = client.get('/login')
        assert response.status_code == 200
        assert b'login' in response.data.lower()
    
    def test_login_success(self, client, app):
        """TC-03: Успешный вход с правильными данными"""
        with app.app_context():
            # Создаём тестового пользователя
            user = User(username='testadmin', role='admin')
            user.set_password('testpass')
            db.session.add(user)
            db.session.commit()
        
        response = client.post('/login', data={
            'username': 'testadmin',
            'password': 'testpass'
        }, follow_redirects=True)
        
        assert response.status_code == 200
    
    def test_login_wrong_password(self, client, app):
        """TC-04: Неверный пароль — остаёмся на странице входа"""
        with app.app_context():
            user = User(username='testadmin', role='admin')
            user.set_password('testpass')
            db.session.add(user)
            db.session.commit()
        
        response = client.post('/login', data={
            'username': 'testadmin',
            'password': 'wrongpass'
        })
        
        assert response.status_code == 200  # Остаётся на странице
    
    def test_protected_route_requires_auth(self, client):
        """TC-05: Защищённый маршрут требует авторизации"""
        response = client.get('/clients')
        assert response.status_code == 302
        assert '/login' in response.location
    
    def test_404_page(self, client):
        """TC-06: Несуществующий URL возвращает 404"""
        response = client.get('/nonexistent_page_xyz')
        assert response.status_code == 404


class TestDatabaseSmoke:
    """Smoke-тесты для БД"""
    
    def test_create_user(self, app):
        """TC-07: Создание пользователя"""
        with app.app_context():
            user = User(username='newuser', role='doctor', full_name='Test Doctor')
            user.set_password('password123')
            db.session.add(user)
            db.session.commit()
            
            saved = User.query.filter_by(username='newuser').first()
            assert saved is not None
            assert saved.role == 'doctor'
            assert saved.check_password('password123')
    
    def test_create_client(self, app):
        """TC-08: Создание клиента"""
        with app.app_context():
            client = Client(name='Иванов И.И.', phone='+79991234567')
            db.session.add(client)
            db.session.commit()
            
            saved = Client.query.filter_by(phone='+79991234567').first()
            assert saved is not None
            assert saved.name == 'Иванов И.И.'
    
    def test_create_pet(self, app):
        """TC-09: Создание питомца"""
        with app.app_context():
            client = Client(name='Петров П.П.', phone='+79997654321')
            db.session.add(client)
            db.session.commit()
            
            pet = Pet(name='Барсик', species='Кошка', client_id=client.id)
            db.session.add(pet)
            db.session.commit()
            
            saved = Pet.query.filter_by(name='Барсик').first()
            assert saved is not None
            assert saved.species == 'Кошка'
    
    def test_password_hashing(self, app):
        """TC-10: Пароли хешируются"""
        with app.app_context():
            user = User(username='hashtest', role='admin')
            user.set_password('mypassword')
            db.session.add(user)
            db.session.commit()
            
            saved = User.query.filter_by(username='hashtest').first()
            assert saved.password_hash != 'mypassword'
            assert saved.check_password('mypassword')
            assert not saved.check_password('wrongpassword')