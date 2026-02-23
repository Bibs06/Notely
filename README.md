# 📘 Notely

A lightweight Flutter Notes application built using **MVVM architecture** and **Riverpod state management**, with local persistence using **SQFlite**.

---

## Credentials to login

 email : student@gmail.com
 password : student123@

## 🚀 Features

- Create, Update, Delete Subjects
- Create, Update, Delete Notes
- Search Subjects & Notes
- Pagination (Lazy Loading)
- Expandable Search UI
- Swipe to Delete
- Offline Support
- Secure Authentication Storage
- Toast Notifications
- Clean & Responsive UI

---

## 🏗 Architecture

This project follows **MVVM (Model-View-ViewModel)** architecture.


## 🧠 State Management

- Riverpod


## 🗄 Local Storage
SQFlite

Used for:

Subjects table

Notes table (Foreign key linked)

CRUD operations

Pagination using LIMIT & OFFSET

Search queries

## 🔐 Flutter Secure Storage

Used for:

Storing auth state

Persisting login state securely

## 📦 Packages Used

flutter_riverpod

sqflite

path

flutter_secure_storage

flutter_screenutil

flutter_toast

##📱 Authentication

Dummy authentication supported

Secure session persistence

Auto login on app restart

⚡ Pagination

Scroll listener

Page tracking

Total page calculation

Lazy loading implementation


## 🛠 How to Run the Project

### 1️⃣ Prerequisites

Make sure you have:

- Flutter SDK installed
- Android Studio / VS Code
- Android Emulator or Physical Device
- Git installed

Check Flutter installation:

```bash
flutter doctor

5️⃣ Build APK (Optional)

To generate release APK:

flutter build apk --release



