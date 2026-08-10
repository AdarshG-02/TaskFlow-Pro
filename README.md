# TaskFlow Pro

TaskFlow Pro is a task management application developed as part of my internship project. The application allows users to create an account, log in, manage tasks, track task progress, and view dashboard information through a simple and user-friendly interface.

The project consists of a Flutter mobile application connected to a PHP backend and a MySQL database.

---

## 📌 Project Overview

TaskFlow Pro is designed to provide users with a centralized platform for managing their daily tasks.

The application provides:

- User registration and login
- Secure password handling
- Task creation
- Task editing
- Task deletion
- Task completion
- Task listing
- Task priority management
- Dashboard statistics
- Forgot password functionality
- User profile section
- Reports section
- Session management
- User-friendly Flutter interface

---

## 🛠️ Technologies Used

### Frontend

- Flutter
- Dart
- Material Design

### Backend

- PHP
- HTTP API integration

### Database

- MySQL

### Development Tools

- Android Studio
- Visual Studio Code
- XAMPP
- Git
- GitHub

---

## 🏗️ Project Architecture

The project follows a frontend-backend architecture:

```text
TaskFlow Pro
│
├── Flutter Application
│   ├── User Interface
│   ├── Authentication
│   ├── Task Management
│   ├── Dashboard
│   ├── Reports
│   └── Profile
│
├── PHP Backend
│   ├── Authentication APIs
│   ├── Task APIs
│   └── Dashboard APIs
│
└── MySQL Database
    └── TaskFlow Pro Database


## 📂 Project Structure


TaskFlow-Pro/
│
├── android/                 # Android platform configuration
├── assets/                  # Application assets and icons
│
├── backend/
│   └── taskflow_api/        # PHP backend API
│       ├── add_task.php
│       ├── complete_task.php
│       ├── config.php
│       ├── dashboard_stats.php
│       ├── delete_task.php
│       ├── forgot_password.php
│       ├── get_tasks.php
│       ├── login.php
│       ├── register.php
│       ├── response.php
│       └── update_task.php
│
├── ios/                     # iOS platform configuration
├── lib/                     # Main Flutter source code
│   ├── app/
│   │   ├── constants/
│   │   └── theme/
│   │
│   ├── screens/
│   │   ├── auth/
│   │   ├── dashboard/
│   │   ├── home/
│   │   ├── profile/
│   │   ├── reports/
│   │   ├── splash/
│   │   └── tasks/
│   │
│   ├── services/
│   └── widgets/
│
├── linux/                   # Linux platform configuration
├── macos/                   # macOS platform configuration
├── test/                    # Flutter tests
├── web/                     # Web platform configuration
├── windows/                 # Windows platform configuration
│
├── .gitignore
├── analysis_options.yaml
├── pubspec.yaml
└── README.md

✨ Main Features
🔐 User Authentication

Users can:

Create a new account
Log in using their credentials
Log out of the application
Maintain a user session
Access the forgot password screen

Passwords are handled using password hashing on the PHP backend.

📋 Task Management

Users can manage their tasks through the application.

Available operations include:

Add a new task
View tasks
Edit existing tasks
Delete tasks
Mark tasks as completed
Set task priority
Add task descriptions

📊 Dashboard

The dashboard provides an overview of task information and application activity.

It provides a central location from which users can navigate to different sections of the application.

👤 Profile

The profile section provides access to the user's account information and profile-related functionality.

📈 Reports

The application includes a reports section for displaying task-related information and reporting functionality.

🔌 Backend API

The Flutter application communicates with the PHP backend through HTTP requests.

The backend is located at:

backend/taskflow_api/

Main API endpoints include:

register.php
login.php
add_task.php
get_tasks.php
update_task.php
delete_task.php
complete_task.php
dashboard_stats.php
forgot_password.php

The PHP backend communicates with the MySQL database to store and retrieve application data.

🗄️ Database

The project uses MySQL as its database system.

Database name:

taskflow_pro

The backend database configuration is located at:

backend/taskflow_api/config.php

For local development, the backend can be hosted using XAMPP.

🚀 Getting Started

Prerequisites

Before running the project, install:

Flutter SDK
Dart SDK
Android Studio or another Flutter-compatible IDE
XAMPP
MySQL
Git
1. Clone the Repository

Clone the repository using:

git clone https://github.com/AdarshG-02/TaskFlow-Pro.git

Navigate into the project directory:

cd TaskFlow-Pro
2. Install Flutter Dependencies

Run:

flutter pub get
3. Configure the PHP Backend

Copy or place the backend API in the XAMPP htdocs directory.

Example:

C:\xampp\htdocs\taskflow_api

Start the following services from XAMPP:

Apache
MySQL
4. Configure the MySQL Database

Create a MySQL database named:

taskflow_pro

Import or create the required database tables before running the application.

5. Configure the API URL

The Flutter application communicates with the PHP backend through:

lib/services/api_service.dart

Update the API base URL according to the environment where the backend is hosted.

Example:

static const String baseUrl =
    "http://YOUR_SERVER_IP/taskflow_api";

For local network testing, replace YOUR_SERVER_IP with the IP address of the computer hosting the PHP backend.

6. Run the Application

Connect an Android device or start an Android emulator and run:

flutter run

To analyze the project:

flutter analyze

🔒 Security Note

This repository is intended for internship project demonstration and educational purposes.

For production deployment, additional security measures should be implemented, including:

HTTPS
Environment-based configuration
Secure database credentials
Production server configuration
Proper API authentication and authorization
Input validation and sanitization
Production error handling

🎯 Project Objectives

The main objectives of TaskFlow Pro were:

To develop a functional task management application using Flutter.
To implement user authentication.
To connect a Flutter application with a PHP backend.
To store application data using MySQL.
To implement CRUD operations for tasks.
To create a structured and user-friendly application interface.
To gain practical experience in full-stack application development.

📚 Learning Outcomes

Through this project, I gained practical experience in:

Flutter application development
Dart programming
UI/UX implementation
HTTP API integration
PHP backend development
MySQL database integration
Authentication and session management
CRUD operations
Git and GitHub
Debugging and application testing
Connecting frontend and backend systems

👨‍💻 Project Information

Project Name: TaskFlow Pro

Project Type: Internship Project

Technology Stack:

Flutter + Dart
PHP
MySQL
XAMPP
Git / GitHub

GitHub Repository:

https://github.com/AdarshG-02/TaskFlow-Pro

📄 License

This project was developed as part of an internship project and is intended primarily for educational and demonstration purposes.


### After you paste it

Save the file with:

**`Ctrl + S`**

Then in your VS Code terminal run these **one at a time**:

```powershell
git add README.md