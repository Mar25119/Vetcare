from datetime import datetime

from flask_login import UserMixin
from werkzeug.security import check_password_hash, generate_password_hash

from . import db, login_manager


@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))


class User(UserMixin, db.Model):
    """Модель пользователя системы (администратор или врач)"""

    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    password_hash = db.Column(db.String(256), nullable=False)
    role = db.Column(db.String(20), nullable=False)  # 'admin' или 'doctor'
    full_name = db.Column(db.String(100))
    phone = db.Column(db.String(20))
    email = db.Column(db.String(100))

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)

    def __repr__(self):
        return f"<User {self.username} ({self.role})>"


class Client(db.Model):
    """Модель клиента (владельца животного)"""

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    phone = db.Column(db.String(20), unique=True, nullable=False)
    email = db.Column(db.String(100))
    # Связь: У клиента много питомцев
    pets = db.relationship("Pet", backref="owner", lazy=True, cascade="all, delete-orphan")

    def __repr__(self):
        return f"<Client {self.name}>"


class Pet(db.Model):
    """Модель питомца (пациента)"""

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    species = db.Column(db.String(50))
    breed = db.Column(db.String(50))
    birth_date = db.Column(db.Date)
    client_id = db.Column(db.Integer, db.ForeignKey("client.id"), nullable=False)

    # Связь с клиентом определена в Client через backref='owner'

    def __repr__(self):
        return f"<Pet {self.name} ({self.species})>"


class Appointment(db.Model):
    """Модель приема (записи на прием)"""

    id = db.Column(db.Integer, primary_key=True)
    date_time = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)
    diagnosis = db.Column(db.Text)
    recommendations = db.Column(db.Text)
    status = db.Column(db.String(20), default="scheduled")

    pet_id = db.Column(db.Integer, db.ForeignKey("pet.id"), nullable=False)
    doctor_id = db.Column(db.Integer, db.ForeignKey("user.id"), nullable=False)
    created_by = db.Column(db.Integer, db.ForeignKey("user.id"))

    pet = db.relationship("Pet", backref="visits")
    doctor = db.relationship("User", foreign_keys=[doctor_id])

    def __repr__(self):
        return f'<Appointment {self.date_time.strftime("%Y-%m-%d %H:%M")}>'
