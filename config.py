import os

class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'vetcare-secret-key-change-in-production'
    # Измените эту строку:
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL') or 'sqlite:///vetcare.db'
    SQLALCHEMY_TRACK_MODIFICATIONS = False