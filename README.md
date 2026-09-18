# 📝 Flutter Notes — Firebase + Provider

A multi-screen Flutter application featuring **Firebase Authentication**, **Cloud Firestore** real-time CRUD, **Provider** state management, and dynamic **Light / Dark** theming.

---

## ✨ Features

- **Authentication (Firebase Auth)**
  - Email / Password **Sign In**, **Sign Up**, and **Sign Out**
  - Optional **Google Sign-In**
  - Screen protection via persistent auth state — unauthenticated users are redirected to the login screen automatically
- **Real-Time CRUD (Cloud Firestore)** — a Notes resource
  - **Create** notes linked to the logged-in user's `uid`
  - **Read** a live stream of the user's notes
  - **Update** existing notes
  - **Delete** with a confirmation dialog *and* swipe-to-delete
- **State Management (Provider)** — business logic and Firebase calls live in `services/` and `providers/`, never in widgets
- **Light & Dark Mode** — custom `ThemeData`, toggle in the Settings screen; theme changes without resetting app state

---

## 📸 Screenshots

> <img width="1910" height="543" alt="Screenshot 2026-09-18 215840" src="https://github.com/user-attachments/assets/00ab3380-06c3-4069-994a-e77184d1d43f" />
<img width="1905" height="970" alt="Screenshot 2026-09-18 215830" src="https://github.com/user-attachments/assets/b0a0c83e-5ba2-48a0-994d-d77e7529da9e" />
<img width="1897" height="390" alt="Screenshot 2026-09-18 215818" src="https://github.com/user-attachments/assets/3e04afdb-a44c-4dcb-a5d0-f8dd5073eb80" />
<img width="1912" height="966" alt="Screenshot 2026-09-18 214312" src="https://github.com/user-attachments/assets/2c3b9eab-4cd3-4bdc-a7f3-79db508fa4f9" />
<img width="1917" height="975" alt="Screenshot 2026-09-18 214043" src="https://github.com/user-attachments/assets/59f1322a-ad63-4ac9-8762-24e9807f4ab6" />

---

## 🗂️ Project Structure

```
lib/
├── models/          # Note model (toJson / fromFirestore)
├── services/        # AuthService, NoteService (Firebase API wrappers)
├── providers/       # AuthProvider, NoteProvider, ThemeProvider
├── theme/           # AppTheme — light & dark ThemeData
├── screens/         # auth_gate, login, home, note_form, settings
└── main.dart        # Firebase init + root MultiProvider
```

---

## 🔧 Firebase Setup

1. **Create a Firebase project** at <https://console.firebase.google.com>.

2. **Enable Authentication**
   - Authentication → Sign-in method → enable **Email/Password** (and **Google** if you want the Google button).

3. **Create a Cloud Firestore database**
   - Firestore Database → Create database → start in production mode.
   - Paste the rules from [`firestore.rules`](./firestore.rules) (they restrict each user to their own notes).

4. **Register your apps** (Android / iOS / Web) in Project Settings and download the config files:
   - Android → `android/app/google-services.json`
   - iOS → `ios/Runner/GoogleService-Info.plist`

5. **Generate `firebase_options.dart`** (recommended, automatic):
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```
   This writes `lib/firebase_options.dart` for you.

   **Or manually:**
   ```bash
   cp lib/firebase_options.dart.template lib/firebase_options.dart
   # then fill in the YOUR_* values from Firebase → Project settings
   ```

> `firebase_options.dart`, `google-services.json`, and `GoogleService-Info.plist` are git-ignored so keys aren't committed. A `firebase_options.dart.template` is provided instead.

---

## ▶️ Run

```bash
flutter pub get
flutter run
```

---

## 🧱 Firestore data shape

Collection `notes`, one document per note:

```json
{
  "uid": "<owner user id>",
  "title": "Groceries",
  "content": "Milk, eggs, coffee",
  "createdAt": "<timestamp>",
  "updatedAt": "<timestamp>"
}
```




---


