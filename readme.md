# Mobile App (Flutter) – JWT Auth Take-Home

Flutter mobile application that connects to a Go (Fiber) backend for JWT-based authentication.

## Main Features

- **Register** (with auto-login on success)  
- **Login**  
- **Protected dashboard** – shows `Hello [email], welcome back`  
- **Auto-logout after 15 minutes of inactivity** (client-side)  
- **Secure token storage** using `flutter_secure_storage`  
- **State management**: Bloc + Cubit + Freezed + `ViewData` pattern  

## Requirements

- **Flutter SDK** ≥ 3.38.9  
- **Docker & Docker Compose** (for running the backend)  
- **Android Emulator** or physical device

## Mobile Folder Structure

```text
mobile/
├── lib/
│   ├── core/              # shared: network, constants, common state
│   ├── features/
│   │   └── auth/          # auth feature (cubit, screens, entities)
│   └── routes/            # go_router configuration
├── pubspec.yaml
└── README.md
```

## Run End-to-End (Backend + Mobile)

### 1. Start the backend (from repo root)

From the **root repository** (not inside `mobile/`):

```bash
docker compose up --build
```

Wait until you see a log similar to:  
`INFO Server started on: http://127.0.0.1:8080`  
The backend is now live on port **8080** (keep this terminal open).

### 2. Go to the mobile app folder

```bash
cd mobile
```

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Set the correct API base URL (important)

Open `lib/core/network/dio_client.dart` and set `baseUrl` according to your environment:

```dart
final dio = Dio(
  BaseOptions(
    baseUrl: 'http://10.0.2.2:8080/api',    // Android Emulator (recommended)
    // baseUrl: 'http://localhost:8080/api',   // Physical device (replace xxx with your Mac's IP)
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ),
);
```

**Find your Mac IP (for physical device):**

- System Settings → Network → Wi‑Fi → Details → IP address (e.g. `192.168.1.100`)  
- Ensure phone and Mac are on the **same Wi‑Fi network**.

### 5. Run the app

On emulator/simulator:

```bash
flutter run
```

On physical device (Android via USB):

```bash
flutter devices               # list connected devices
flutter run -d <device-id>    # example: flutter run -d abc123
```

The app will build, install, and launch automatically.  
For hot reload, press `r` in the terminal.

### 6. Test the end-to-end flow

- Splash screen → redirects to **Login** (if not logged in)  
- Register → fill email/password/confirm → submit → auto-login → goes to **Dashboard**  
- Dashboard → shows `Hello [email], welcome back` (from `/protected` API)  
- Logout → returns to **Login**  
- Manual login → back to **Dashboard**  
- Wait ~15 minutes without interaction → auto-logout → back to **Login**  
- Stop backend (`Ctrl + C` in Docker terminal) → app should show a network error  

## Build APK / AAB

Build **release APK** (for manual install on Android phone):

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
