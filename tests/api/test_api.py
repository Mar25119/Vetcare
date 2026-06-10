"""
API-тесты для VetCare
Проверяют корректность HTTP-запросов
"""
import os
os.environ['DATABASE_URL'] = 'sqlite:///:memory:'

import pytest
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..')))

from app import create_app, db
from app.models import User


@pytest.fixture
def app():
    """Создание тестового приложения"""
    app = create_app()
    app.config['TESTING'] = True
    app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///:memory:'
    app.config['WTF_CSRF_ENABLED'] = False
    
    with app.app_context():
        yield app
        db.drop_all()


@pytest.fixture
def client(app):
    """Тестовый клиент Flask"""
    return app.test_client()


@pytest.fixture
def auth_client(client):
    """Клиент с авторизацией (admin уже создан автоматически)"""
    client.post('/login', data={
        'username': 'admin',
        'password': 'admin123'
    })
    return client


class TestAuthAPI:
    """Тесты авторизации"""
    
    def test_login_page_get(self, client):
        """GET /login возвращает 200"""
        response = client.get('/login')
        assert response.status_code == 200
    
    def test_login_wrong_credentials(self, client):
        """POST /login с неверными данными"""
        response = client.post('/login', data={
            'username': 'admin',
            'password': 'wrong'
        })
        assert response.status_code == 200  # Остаётся на странице
    
    def test_logout(self, auth_client):
        """GET /logout работает"""
        response = auth_client.get('/logout', follow_redirects=False)
        assert response.status_code in [302, 200]


class TestProtectedRoutes:
    """Тесты защищённых маршрутов"""
    
    def test_clients_requires_auth(self, client):
        """GET /clients без авторизации — редирект"""
        response = client.get('/clients')
        assert response.status_code == 302
    
    def test_clients_with_auth(self, auth_client):
        """GET /clients с авторизацией — 200"""
        response = auth_client.get('/clients')
        assert response.status_code == 200
    
    def test_appointments_with_auth(self, auth_client):
        """GET /appointments с авторизацией — 200"""
        response = auth_client.get('/appointments')
        assert response.status_code == 200


class TestErrorHandling:
    """Тесты обработки ошибок"""
    
    def test_404_not_found(self, client):
        """Несуществующий URL — 404"""
        response = client.get('/this_page_does_not_exist_12345')
        assert response.status_code == 404