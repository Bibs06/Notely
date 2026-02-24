# 📘 Notely

A lightweight Flutter Notes application built using **MVVM architecture** and **Riverpod state management**, with local persistence using **SQFlite**.


## Screen Shots

![alt text](<App Screen shots (1).png>)
---

## How to install

👉 Get the APK from the Releases section
📦 Extract the ZIP
📱 Install the APK

## Credentials to login

 email : student@gmail.com
 password : student123@

## 🚀 Features

- Create, Update, Delete Subjects
- Create, Update, Delete Notes
- Search Subjects & Notes
- Expandable Search UI
- Swipe to Delete Note
- Tap on Note to update note
- Hold and press to update or delete subject
- Offline Support
- Secure Authentication Storage
- Toast Notifications
- Clean & Responsive UI

---


## 🏗 Architecture

This app follows **MVVM architecture** using Riverpod.

- Model → Data layer  
- View → UI layer  
- ViewModel → Business logic & state  

This keeps the code clean, scalable, and maintainable.



## 🧠 State Management

- Riverpod


## 🗄 Local Storage
SQFlite

Used for:

Subjects table

Notes table (Foreign key linked)

CRUD operations


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

## Build APK (Optional)

To generate release APK:

flutter build apk --release



