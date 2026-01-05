# Deploy Smart Finance Wallet

This guide covers building the application for Android and iOS.

## Prerequisites

- Flutter SDK installed
- Android Studio (for Android)
- Xcode (for iOS, macOS only)
- Active Apple Developer Account (for iOS distribution)

## Android

### 1. Generate Keystore

If you don't have a keystore, generate one:

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

### 2. Configure Signing

Create `android/key.properties`:

```properties
storePassword=<your-store-password>
keyPassword=<your-key-password>
keyAlias=upload
storeFile=/Users/<user>/upload-keystore.jks
```

Update `android/app/build.gradle`:

```gradle
android {
    signingConfigs {
        release {
            keyAlias 'upload'
            keyPassword '...'
            storeFile file('/path/to/upload-keystore.jks')
            storePassword '...'
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### 3. Build

- **App Bundle (Play Store)**:
  ```bash
  flutter build appbundle
  ```
- **APK**:
  ```bash
  flutter build apk
  ```

## iOS

### 1. Setup in Xcode

1. Open `ios/Runner.xcworkspace` in Xcode.
2. Select the `Runner` target.
3. In the "Signing & Capabilities" tab, select your Development Team.
4. Ensure a unique Bundle Identifier is set.

### 2. Update Version

Update `pubspec.yaml`:

```yaml
version: 1.0.0+1
```

### 3. Archive & Release

1. In Xcode, select **Product > Archive**.
2. Once archived, the Organizer window will open.
3. Click **Distribute App** to upload to TestFlight or the App Store.

## Troubleshooting

- **CocoaPods issues**: Run `cd ios && pod install --repo-update`.
- **Signing issues**: Ensure certificates in Keychain Access are valid.
