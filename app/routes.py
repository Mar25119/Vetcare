from datetime import datetime, timedelta

from flask import abort, flash, redirect, render_template, request, url_for
from flask_login import current_user, login_required, login_user, logout_user

from .models import Appointment, Client, Pet, User, db
from .utils import send_notification


def init_routes(app):
    """Функция регистрации всех маршрутов"""

    @app.route("/login", methods=["GET", "POST"])
    def login():
        if current_user.is_authenticated:
            return redirect(url_for("index"))

        if request.method == "POST":
            username = request.form["username"]
            password = request.form["password"]
            user = User.query.filter_by(username=username).first()

            if user and user.check_password(password):
                login_user(user)
                flash(f"Добро пожаловать, {user.full_name}!", "success")
                next_page = request.args.get("next")
                return redirect(next_page or url_for("index"))
            else:
                flash("Неверное имя пользователя или пароль.", "error")

        return render_template("login.html")

    @app.route("/logout")
    @login_required
    def logout():
        logout_user()
        flash("Вы вышли из системы.", "info")
        return redirect(url_for("login"))

    @app.route("/register", methods=["GET", "POST"])
    def register():
        # Только первый пользователь может регистрироваться (или только админ)
        if User.query.count() > 0 and not current_user.is_authenticated:
            abort(403)
        if current_user.is_authenticated and current_user.role != "admin":
            abort(403)

        if request.method == "POST":
            username = request.form["username"].strip()
            password = request.form["password"]
            full_name = request.form["full_name"].strip()
            role = request.form["role"]
            phone = request.form.get("phone", "").strip()
            email = request.form.get("email", "").strip()

            if User.query.filter_by(username=username).first():
                flash("Пользователь с таким именем уже существует.", "warning")
                return redirect(url_for("register"))

            new_user = User(
                username=username,
                full_name=full_name,
                role=role,
                phone=phone if phone else None,
                email=email if email else None,
            )
            new_user.set_password(password)
            db.session.add(new_user)
            db.session.commit()
            flash(f'Пользователь "{username}" успешно создан!', "success")
            return redirect(url_for("login"))

        return render_template("register.html")

    # Главная страница

    @app.route("/")
    @login_required
    def index():
        clients_count = Client.query.count()
        pets_count = Pet.query.count()
        today_appointments = Appointment.query.filter(
            Appointment.date_time >= datetime.today(),
            Appointment.date_time < datetime.today() + timedelta(days=1),
        ).count()
        return render_template(
            "index.html",
            clients=clients_count,
            pets=pets_count,
            today_appointments=today_appointments,
        )

    # Клиенты

    @app.route("/clients")
    @login_required
    def list_clients():
        clients = Client.query.order_by(Client.name).all()
        return render_template("clients.html", clients=clients)

    @app.route("/add_client", methods=["GET", "POST"])
    @login_required
    def add_client():
        if request.method == "POST":
            name = request.form["name"].strip()
            phone = request.form["phone"].strip()
            email = request.form.get("email", "").strip()

            if not name or not phone:
                flash("Имя и телефон обязательны!", "error")
                return redirect(url_for("add_client"))

            existing_client = Client.query.filter_by(phone=phone).first()
            if existing_client:
                flash("Клиент с таким телефоном уже существует!", "warning")
                return redirect(url_for("list_clients"))

            new_client = Client(name=name, phone=phone, email=email if email else None)
            db.session.add(new_client)
            db.session.commit()

            if new_client.email:
                send_notification(
                    new_client.phone,
                    new_client.email,
                    "email",
                    f"Здравствуйте, {new_client.name}! Вы зарегистрированы в системе VetCare.",
                )

            flash(f'Клиент "{name}" успешно добавлен!', "success")
            return redirect(url_for("list_clients"))

        return render_template("add_client.html")

    # --- Питомцы ---

    @app.route("/pets/<int:client_id>")
    @login_required
    def list_pets(client_id):
        client = Client.query.get_or_404(client_id)
        return render_template("pets.html", client=client, pets=client.pets)

    @app.route("/add_pet/<int:client_id>", methods=["POST"])
    @login_required
    def add_pet(client_id):
        name = request.form["name"].strip()
        species = request.form["species"]
        breed = request.form.get("breed", "").strip()
        birth_date_str = request.form.get("birth_date")

        if not name:
            flash("Кличка питомца обязательна!", "error")
            return redirect(url_for("list_pets", client_id=client_id))

        birth_date = None
        if birth_date_str:
            try:
                birth_date = datetime.strptime(birth_date_str, "%Y-%m-%d").date()
            except ValueError:
                flash("Неверный формат даты рождения!", "warning")

        new_pet = Pet(
            name=name,
            species=species,
            breed=breed if breed else None,
            birth_date=birth_date,
            client_id=client_id,
        )
        db.session.add(new_pet)
        db.session.commit()
        flash(f'Питомец "{name}" добавлен!', "success")
        return redirect(url_for("list_pets", client_id=client_id))

    # --- Приёмы ---

    @app.route("/appointments")
    @login_required
    def list_appointments():
        future_appointments = (
            Appointment.query.filter(Appointment.date_time >= datetime.utcnow())
            .order_by(Appointment.date_time)
            .all()
        )

        from collections import defaultdict

        appointments_by_date = defaultdict(list)
        for apt in future_appointments:
            date_key = apt.date_time.strftime("%Y-%m-%d")
            appointments_by_date[date_key].append(apt)

        return render_template(
            "appointments.html",
            appointments_by_date=dict(appointments_by_date),
            sorted_dates=sorted(appointments_by_date.keys()),
        )

    @app.route("/add_appointment", methods=["GET", "POST"])
    @login_required
    def add_appointment():
        if request.method == "POST":
            pet_id = request.form["pet_id"]
            doctor_id = request.form["doctor_id"]
            date_time_str = request.form["date_time"]
            diagnosis = request.form.get("diagnosis", "").strip()
            recommendations = request.form.get("recommendations", "").strip()

            try:
                date_time = datetime.strptime(date_time_str, "%Y-%m-%dT%H:%M")
            except ValueError:
                flash("Неверный формат даты и времени!", "error")
                return redirect(url_for("add_appointment"))

            doctor = User.query.get(doctor_id)
            if not doctor or doctor.role != "doctor":
                flash("Выбранный специалист не найден или не является врачом.", "error")
                return redirect(url_for("add_appointment"))

            new_appointment = Appointment(
                date_time=date_time,
                diagnosis=diagnosis if diagnosis else None,
                recommendations=recommendations if recommendations else None,
                pet_id=pet_id,
                doctor_id=doctor_id,
                created_by=current_user.id,
            )
            db.session.add(new_appointment)
            db.session.commit()

            pet = Pet.query.get(pet_id)
            client = Client.query.get(pet.client_id)
            if client:
                notification_msg = f'Запись на приём подтверждена: {pet.name}, {date_time.strftime("%d.%m.%Y в %H:%M")}. Врач: {doctor.full_name}'
                send_notification(client.phone, client.email, "sms/email", notification_msg)
                flash(f"Приём создан и уведомление отправлено владельцу {client.name}", "success")
            else:
                flash(
                    "Приём создан, но не удалось отправить уведомление (клиент не найден).",
                    "warning",
                )

            return redirect(url_for("list_appointments"))

        pets = Pet.query.all()
        doctors = User.query.filter_by(role="doctor").all()
        return render_template("add_appointment.html", pets=pets, doctors=doctors)

    @app.route("/complete_appointment/<int:appointment_id>", methods=["POST"])
    @login_required
    def complete_appointment(appointment_id):
        appointment = Appointment.query.get_or_404(appointment_id)
        if appointment.status != "scheduled":
            flash("Этот приём уже завершён или отменён.", "warning")
            return redirect(url_for("list_appointments"))

        appointment.status = "completed"
        db.session.commit()
        flash("Приём отмечен как завершённый.", "success")
        return redirect(url_for("list_appointments"))

    @app.route("/cancel_appointment/<int:appointment_id>", methods=["POST"])
    @login_required
    def cancel_appointment(appointment_id):
        appointment = Appointment.query.get_or_404(appointment_id)
        if appointment.status != "scheduled":
            flash("Нельзя отменить уже завершённый приём.", "warning")
            return redirect(url_for("list_appointments"))

        appointment.status = "cancelled"
        db.session.commit()
        flash("Приём отменён.", "info")
        return redirect(url_for("list_appointments"))
