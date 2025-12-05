# Setup Instructions

Follow these steps to set up and run the Water Quality Assessment app:

## Prerequisites

1. **Install Flutter**
   - Download Flutter from [https://flutter.dev](https://flutter.dev)
   - Follow installation instructions for your platform
   - Verify installation: `flutter doctor`

2. **Install Android Studio / Xcode**
   - For Android: Install Android Studio and Android SDK
   - For iOS: Install Xcode (macOS only)

## Installation Steps

### 1. Get Dependencies

```bash
flutter pub get
```

### 2. Run the App

```bash
# For Android
flutter run

# For iOS (macOS only)
flutter run -d ios
```

### 3. Build for Release

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS (requires macOS and Xcode)
flutter build ios --release
```

## Permissions Setup

### Android

Location permissions are already configured in `android/app/src/main/AndroidManifest.xml`. 

**For Android 12+ (API 31+)**, you may need to handle location permissions at runtime. The app uses `permission_handler` package which handles this automatically.

### iOS

Location permissions are configured in `ios/Runner/Info.plist`.

**Additional iOS Setup:**
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select the Runner target
3. Go to "Signing & Capabilities"
4. Add your Apple Developer account for signing

## Troubleshooting

### Packages Not Found

If you see errors about missing packages:
```bash
flutter clean
flutter pub get
```

### Hive Adapter Errors

The Hive adapter is already created manually, so you don't need to run `build_runner`. If you see any issues:
```bash
flutter clean
flutter pub get
```

### Location Permission Issues

**Android:**
- Ensure location permissions are granted in device settings
- For testing, grant permissions manually: Settings > Apps > Water Quality Assessment > Permissions > Location

**iOS:**
- First run will prompt for location permission
- Grant "While Using the App" or "Always" permission

### PDF Generation Issues

If PDF generation doesn't work:
- Ensure you have a PDF viewer installed
- On iOS, PDF sharing uses the system share sheet
- On Android, it opens the system print dialog

## Testing

To run tests (when available):
```bash
flutter test
```

## Debug Mode

Run in debug mode with hot reload:
```bash
flutter run
```

Press `r` for hot reload, `R` for hot restart, or `q` to quit.

## Building Release

Before building for release, make sure to:

1. Update version in `pubspec.yaml`:
   ```yaml
   version: 1.0.0+1
   ```

2. Build release version:
   ```bash
   flutter build apk --release  # Android
   flutter build ios --release  # iOS (macOS only)
   ```

---

For more information, see the main [README.md](README.md) file.

