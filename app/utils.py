import logging
from datetime import datetime

from werkzeug.security import check_password_hash, generate_password_hash

# Настройка логирования "уведомлений"
logging.basicConfig(
    filename="notifications.log",
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
)


def hash_password(password):
    return generate_password_hash(password)


def verify_password(hashed_password, password):
    return check_password_hash(hashed_password, password)


def send_notification(user_phone, user_email, message_type, details):
    """
    Эмуляция отправки уведомления (SMS/email).
    В реальном проекте здесь будет интеграция с Twilio/SMS.ru или SMTP.
    """
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    log_message = f"[{timestamp}] {message_type.upper()} | To: {user_phone} / {user_email} | Details: {details}"

    print(log_message)
    logging.info(log_message)

    return f"Уведомление отправлено: {details}"
