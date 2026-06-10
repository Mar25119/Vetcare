from flask import Flask
from flask_login import LoginManager
from flask_sqlalchemy import SQLAlchemy

from config import Config

db = SQLAlchemy()
login_manager = LoginManager()
login_manager.login_view = "login"
login_manager.login_message = "Пожалуйста, войдите в систему."


def create_app(config_class=Config):
    app = Flask(__name__)
    app.config.from_object(config_class)

    db.init_app(app)
    login_manager.init_app(app)

    with app.app_context():
        from . import models

        db.create_all()

        # Создаём админа, если его нет
        if not models.User.query.filter_by(username="admin").first():
            admin = models.User(
                username="admin",
                full_name="Администратор Системы",
                role="admin",
                phone="+79990000000",
                email="admin@vetcare.local",
            )
            admin.set_password("admin123")
            db.session.add(admin)
            db.session.commit()
            print("Создан пользователь admin / пароль: admin123")

        from . import routes

        routes.init_routes(app)

    return app
