# 🛍️ Laza - E-Commerce Mobile Application

![Flutter](https://img.shields.io/badge/Flutter-3.9.2-02569B?logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-Latest-FFCA28?logo=firebase&logoColor=black)
![Dart](https://img.shields.io/badge/Dart-3.9.2-0175C2?logo=dart&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green.svg)

**Faculty of Computers and Data Science**  
**Fall 2025 | Cybersecurity Program | Mobile App Development**

---

##  Project Overview

Laza is a modern, full-featured e-commerce mobile application built with **Flutter** and **Firebase**. The application provides a seamless shopping experience with real-time data synchronization, secure user authentication, and an intuitive user interface following Material Design 3 guidelines.

###  Key Features

-  **User Authentication**: Email/Password signup, login, and password reset using Firebase Authentication
-  **Product Catalog**: Browse products from external API with real-time search functionality
-  **Favorites System**: Save and manage favorite products with persistent storage in Firestore
-  **Shopping Cart**: Add items, adjust quantities, and manage cart with real-time synchronization
-  **Order Management**: Place orders and track order history
-  **Product Reviews**: Read and write product reviews with star ratings
-  **Address Management**: Save and manage multiple shipping addresses
-  **Theme Support**: Light and Dark mode with smooth transitions
-  **Responsive Design**: Material Design 3 with adaptive layouts for all screen sizes
-  **Real-time Sync**: Firestore provides instant data synchronization across devices

###  Technology Stack

| Category | Technology | Version |
|----------|-----------|---------|
| **Framework** | Flutter | ^3.9.2 |
| **Language** | Dart | ^3.9.2 |
| **Authentication** | Firebase Auth | ^5.7.0 |
| **Database** | Cloud Firestore | ^5.6.12 |
| **Firebase Core** | Firebase Core | ^3.15.2 |
| **HTTP Client** | HTTP Package | ^0.13.6 |
| **External API** | Platzi Fake Store API | - |

###  Architecture

- **Service-based Architecture**: Clear separation of business logic and UI
- **Reactive Programming**: Stream-based data flow with Firestore snapshots
- **State Management**: Stateful widgets with setState for local state
- **Modular Structure**: Organized by models, services, screens, and widgets

---

##  Table of Contents

1. [How to Install Flutter](#-how-to-install-flutter)
2. [Project Dependencies Installation](#-project-dependencies-installation)
3. [Firebase Setup Steps](#-firebase-setup-steps)
4. [Firestore Rules Installation](#-firestore-rules-installation)
5. [How to Run Android & iOS Builds](#-how-to-run-android--ios-builds)
6. [How to Run Appium Tests](#-how-to-run-appium-tests)
7. [Screenshots](#-screenshots)
8. [Project Structure](#-project-structure)
9. [Troubleshooting](#-troubleshooting)

---

##  How to Install Flutter

### Prerequisites

Before installing Flutter, ensure you have:
- **Operating System**: Windows 10/11, macOS, or Linux
- **Disk Space**: At least 2.8 GB (does not include disk space for IDE/tools)
- **Tools**: Git for Windows (if on Windows)

### Installation Steps by Platform

<details>
<summary><b>📱 Windows Installation</b></summary>

#### Step 1: Download Flutter SDK
1. Visit [Flutter Download Page](https://flutter.dev/docs/get-started/install/windows)
2. Download the latest stable Flutter SDK zip file
3. Extract the zip file to a location like `C:\src\flutter`
   - **Important**: Do NOT install Flutter in directories like `C:\Program Files\` that require elevated privileges

#### Step 2: Update PATH Environment Variable
1. Open **Start Menu** → Search for "Environment Variables"
2. Click **"Edit the system environment variables"**
3. Click **"Environment Variables"** button
4. Under **"User variables"**, find **Path** and click **Edit**
5. Click **New** and add: `C:\src\flutter\bin`
6. Click **OK** on all dialogs

#### Step 3: Run Flutter Doctor
```bash
# Open Command Prompt or PowerShell
flutter doctor
```

This command checks your environment and displays a report of Flutter installation status.

#### Step 4: Install Android Studio
1. Download [Android Studio](https://developer.android.com/studio)
2. Install with default settings
3. Open Android Studio → **More Actions** → **SDK Manager**
4. Install:
   - Android SDK Platform (latest)
   - Android SDK Build-Tools
   - Android Emulator

#### Step 5: Accept Android Licenses
```bash
flutter doctor --android-licenses
```
Type `y` to accept all licenses.

#### Step 6: Verify Installation
```bash
flutter doctor -v
```

You should see all checkmarks (✓) except for optional items.
</details>

<details>
<summary><b>🍎 macOS Installation</b></summary>

#### Step 1: Download Flutter SDK
```bash
# Open Terminal
cd ~/development

# Clone Flutter repository
git clone https://github.com/flutter/flutter.git -b stable
```

#### Step 2: Add Flutter to PATH
```bash
# For zsh (default on macOS Catalina and later)
nano ~/.zshrc

# Add this line at the end:
export PATH="$PATH:$HOME/development/flutter/bin"

# Save (Ctrl+O, Enter, Ctrl+X)
# Reload configuration
source ~/.zshrc
```

If using bash instead of zsh:
```bash
nano ~/.bash_profile
# Add the same export line
source ~/.bash_profile
```

#### Step 3: Run Flutter Doctor
```bash
flutter doctor
```

#### Step 4: Install Xcode (for iOS development)
1. Install Xcode from the [Mac App Store](https://apps.apple.com/us/app/xcode/id497799835)
2. Open Xcode to accept license agreement
3. Run:
```bash
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
```

#### Step 5: Install CocoaPods
```bash
sudo gem install cocoapods
```

#### Step 6: Install Android Studio (for Android development)
1. Download [Android Studio](https://developer.android.com/studio)
2. Install with default settings
3. Accept Android licenses:
```bash
flutter doctor --android-licenses
```

#### Step 7: Verify Installation
```bash
flutter doctor -v
```
</details>

<details>
<summary><b>🐧 Linux Installation</b></summary>

#### Step 1: Download Flutter SDK
```bash
cd ~/development

# Clone Flutter repository
git clone https://github.com/flutter/flutter.git -b stable
```

#### Step 2: Add Flutter to PATH
```bash
nano ~/.bashrc

# Add this line at the end:
export PATH="$PATH:$HOME/development/flutter/bin"

# Save and reload
source ~/.bashrc
```

#### Step 3: Install Dependencies
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install curl git unzip xz-utils zip libglu1-mesa

# Fedora/Red Hat
sudo dnf install curl git unzip xz zip
```

#### Step 4: Run Flutter Doctor
```bash
flutter doctor
```

#### Step 5: Install Android Studio
1. Download from [Android Studio Website](https://developer.android.com/studio)
2. Extract and run `studio.sh`
3. Accept licenses:
```bash
flutter doctor --android-licenses
```

#### Step 6: Verify Installation
```bash
flutter doctor -v
```
</details>

### Verify Flutter Installation

After installation on any platform:

```bash
# Check Flutter version
flutter --version

# Check for issues
flutter doctor

# List available devices
flutter devices
```

**Expected Output:**
```
Flutter 3.9.2 • channel stable
Tools • Dart 3.9.2 • DevTools 2.x.x
```

---

## 📦 Project Dependencies Installation

### Step 1: Clone the Repository

```bash
# Clone the project from GitHub
git clone https://github.com/MostafaaaHussein/Laza.git

# Navigate to project directory
cd Laza
```

### Step 2: Install Flutter Dependencies

```bash
# Get all packages defined in pubspec.yaml
flutter pub get
```

This command will download and install all dependencies:
- `firebase_core: ^3.15.2`
- `cloud_firestore: ^5.6.12`
- `firebase_auth: ^5.7.0`
- `http: ^0.13.6`
- `cupertino_icons: ^1.0.8`

### Step 3: Platform-Specific Setup

#### For iOS Development (macOS only):
```bash
# Navigate to iOS folder
cd ios

# Install CocoaPods dependencies
pod install

# Return to root directory
cd ..
```

#### For Android Development:
No additional steps needed. Gradle will automatically download dependencies on first build.

### Step 4: Verify Dependencies

```bash
# Check for outdated packages
flutter pub outdated

# Upgrade all dependencies (if needed)
flutter pub upgrade
```

### Step 5: Analyze Code

```bash
# Run static analysis
flutter analyze

# Should show: No issues found!
```

---

## 🔥 Firebase Setup Steps

### Overview

Firebase provides backend services including Authentication and Firestore Database. Follow these steps to set up Firebase for the Laza app.

> **📖 Detailed Guide**: See [firebase_setup.md](firebase_setup.md) for comprehensive instructions with screenshots.

### Quick Setup Steps

#### Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **"Add project"** or **"Create a project"**
3. **Project name**: Enter `lazaaaaaaa-9112b` (or any name you prefer)
4. Click **Continue**
5. **Google Analytics**: Toggle OFF (optional)
6. Click **Create project**
7. Wait for project creation (~30-60 seconds)
8. Click **Continue** when done

#### Step 2: Enable Firebase Authentication

1. In Firebase Console sidebar, click **Authentication**
2. Click **Get started**
3. Go to **Sign-in method** tab
4. Click on **Email/Password**
5. Toggle **Enable** switch ON
6. Click **Save**

**Optional**: Customize email templates
- Go to **Templates** tab
- Edit **Password reset** and **Email verification** templates
- Add your app name: "Laza"

#### Step 3: Create Firestore Database

1. In Firebase Console sidebar, click **Firestore Database**
2. Click **Create database**
3. **Security rules**: Select **Start in production mode**
4. Click **Next**
5. **Location**: Choose closest to your users
   - For Egypt/Middle East: `eur3 (europe-west)`
   - For Global: `nam5 (us-central)`
6. Click **Enable**
7. Wait for database creation (~1-2 minutes)

#### Step 4: Add Android App to Firebase

1. In Firebase Console, click the **Android icon** or go to **Project Settings** → **Your apps**
2. Click **Add app** → Select **Android**
3. **Android package name**: `com.example.lazaaaaaaa`
   ```
   Find in: android/app/build.gradle
   Look for: applicationId "com.example.lazaaaaaaa"
   ```
4. **App nickname** (optional): `Laza Android`
5. **Debug signing certificate SHA-1** (optional but recommended):
   ```bash
   # Windows
   keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android

   # macOS/Linux
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```
   Copy the SHA-1 hash and paste it
6. Click **Register app**
7. **Download config file**: Click **Download google-services.json**
8. **Place the file**: Move `google-services.json` to `android/app/` directory
9. Click **Next** → **Next** → **Continue to console**

#### Step 5: Add iOS App to Firebase (macOS only)

1. In Firebase Console Project Settings, click **Add app** → Select **iOS**
2. **iOS bundle ID**: `com.example.lazaaaaaaa`
   ```
   Find in: ios/Runner.xcodeproj/project.pbxproj
   Search for: PRODUCT_BUNDLE_IDENTIFIER
   ```
3. **App nickname** (optional): `Laza iOS`
4. Click **Register app**
5. **Download config file**: Click **Download GoogleService-Info.plist**
6. **Add to Xcode**:
   ```bash
   # Open Xcode
   open ios/Runner.xcworkspace
   ```
   - Drag `GoogleService-Info.plist` into Xcode's `Runner` folder
   - ✅ Check **"Copy items if needed"**
   - ✅ Ensure it's added to **Runner** target
7. Click **Next** → **Next** → **Continue to console**

#### Step 6: Configure Web App

1. In Firebase Console Project Settings, click **Add app** → Select **Web** (`</>` icon)
2. **App nickname**: `Laza Web`
3. ✅ Check **"Also set up Firebase Hosting"** (optional)
4. Click **Register app**
5. Firebase will show configuration code
6. **Verify configuration** in `lib/firebase_options.dart`:
   ```dart
   static const FirebaseOptions web = FirebaseOptions(
     apiKey: 'AIzaSyBfcp11Qd1zdoBz4dWnKzTZ4NA0BJ0mwzY',
     appId: '1:130524301296:web:8a37f61d588cd2f2e3ff35',
     messagingSenderId: '130524301296',
     projectId: 'lazaaaaaaa-9112b',
     authDomain: 'lazaaaaaaa-9112b.firebaseapp.com',
     storageBucket: 'lazaaaaaaa-9112b.firebasestorage.app',
     measurementId: 'G-WTXJQRQY47',
   );
   ```
   The configuration is already set up in the project.

#### Step 7: Test Firebase Connection

```bash
# Run the app
flutter run

# Check logs for:
# ✅ "Firebase initialized successfully"
# ✅ No Firebase errors
```

**Test Authentication:**
1. Run the app
2. Click **Sign up**
3. Enter test credentials:
   - Name: `Test User`
   - Email: `test@example.com`
   - Password: `test123456`
4. Click **Sign up**
5. Go to Firebase Console → **Authentication** → **Users**
6. Verify the new user appears

---

## 🔒 Firestore Rules Installation

Firestore security rules control access to your database. These rules ensure users can only access their own data.

### Option 1: Install via Firebase Console (Recommended)

1. Open [Firebase Console](https://console.firebase.google.com/)
2. Select your project: `lazaaaaaaa-9112b`
3. Go to **Firestore Database** in the sidebar
4. Click on the **Rules** tab
5. **Copy the rules** from the `firestore.rules` file in this repository
6. **Paste** the rules into the console editor
7. Click **Publish**
8. Wait for confirmation: "Rules published successfully"

### Option 2: Install via Firebase CLI

#### Prerequisites:
```bash
# Install Node.js from https://nodejs.org/
# Then install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login
```

#### Deploy Rules:
```bash
# In project root directory

# Initialize Firebase (first time only)
firebase init firestore
# Select: Use an existing project
# Choose: lazaaaaaaa-9112b
# Firestore rules file: firestore.rules (default)
# Firestore indexes file: firestore.indexes.json (default)

# Deploy rules
firebase deploy --only firestore:rules
```

### Firestore Rules Content

The `firestore.rules` file contains:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper functions
    function isAuthenticated() {
      return request.auth != null;
    }
    
    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }
    
    // Users collection
    match /users/{userId} {
      allow read, create, update: if isOwner(userId);
      allow delete: if false;
      
      // Favorites subcollection
      match /favorites/{favoriteId} {
        allow read, write: if isOwner(userId);
      }
      
      // Cart subcollection
      match /cart/{cartItemId} {
        allow read, write: if isOwner(userId);
      }
      
      // Other subcollections (address, orders, etc.)
      match /{subcollection}/{document=**} {
        allow read, write: if isOwner(userId);
      }
    }
    
    // Products collection (public read)
    match /products/{productId} {
      allow read: if true;
      allow write: if false;
      
      match /reviews/{reviewId} {
        allow read: if true;
        allow create: if isAuthenticated();
        allow update, delete: if isAuthenticated() 
          && request.auth.uid == resource.data.userId;
      }
    }
    
    // Notes collection
    match /notes/{noteId} {
      allow read, write: if isAuthenticated();
    }
    
    // Default deny all
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

### Verify Rules Installation

1. Go to Firebase Console → **Firestore Database** → **Rules** tab
2. Check the **Published** timestamp (should be recent)
3. Verify rules match your `firestore.rules` file

### Test Rules

**Test 1: User can access own data**
```dart
// In the app, login as a user
// Add item to favorites
// Check Firestore Console - should see the data
```

**Test 2: User cannot access other user's data**
```dart
// Try to access another user's document directly
// Should get "permission-denied" error
```

---

## 📱 How to Run Android & iOS Builds

### Android Build

#### Prerequisites:
- ✅ Android Studio installed
- ✅ Android SDK installed
- ✅ Android Emulator or physical device

#### Step 1: Check Connected Devices

```bash
# List all connected devices and emulators
flutter devices

# Expected output:
# Android SDK built for x86 (mobile) • emulator-5554 • android-x86 • Android 11 (API 30)
# OR
# SM G960F (mobile) • 1234567890ABCDEF • android-arm64 • Android 10 (API 29)
```

If no devices are listed:
```bash
# Start Android Emulator from Android Studio
# OR
# Connect physical device via USB with USB debugging enabled
```

#### Step 2: Run in Debug Mode

```bash
# Run on default device
flutter run

# Run on specific device
flutter run -d emulator-5554
```

**Debug Mode Features:**
- Hot reload: Press `r` to reload changes
- Hot restart: Press `R` to restart app
- Quit: Press `q`

#### Step 3: Build APK (Release)

```bash
# Build APK for release
flutter build apk --release

# Output location:
# build/app/outputs/flutter-apk/app-release.apk
```

#### Step 4: Build App Bundle (for Google Play)

```bash
# Build App Bundle
flutter build appbundle --release

# Output location:
# build/app/outputs/bundle/release/app-release.aab
```

#### Step 5: Install APK on Device

```bash
# Install APK
flutter install

# Or manually install with adb
adb install build/app/outputs/flutter-apk/app-release.apk
```

#### Step 6: Run Release Build

```bash
# Run in release mode (optimized performance)
flutter run --release
```

### iOS Build (macOS only)

#### Prerequisites:
- ✅ Xcode installed (from Mac App Store)
- ✅ CocoaPods installed
- ✅ iOS Simulator or physical device
- ✅ Apple Developer account (for physical device)

#### Step 1: Open iOS Project in Xcode

```bash
# Open workspace (not .xcodeproj!)
open ios/Runner.xcworkspace
```

#### Step 2: Configure Signing

1. In Xcode, select **Runner** in project navigator
2. Go to **Signing & Capabilities** tab
3. **Team**: Select your Apple Developer team
   - Or click "Add Account" to sign in
   - Or use "Automatically manage signing" for development
4. **Bundle Identifier**: Verify it's `com.example.lazaaaaaaa`

#### Step 3: Select Target Device

In Xcode toolbar:
- Click the device dropdown
- Select **iPhone Simulator** (e.g., iPhone 14 Pro)
- OR connect physical iPhone/iPad via USB

#### Step 4: Run from Xcode

1. Click the ▶️ **Play** button in Xcode
2. Wait for build to complete
3. App launches on simulator/device

#### Step 5: Run from Command Line

```bash
# List iOS devices
flutter devices

# Run on iOS simulator
flutter run -d "iPhone 14 Pro"

# Run on physical device
flutter run -d "Your iPhone Name"
```

#### Step 6: Build for Release

```bash
# Build iOS app for release
flutter build ios --release

# Output location:
# build/ios/iphoneos/Runner.app
```

#### Step 7: Build IPA (for App Store)

```bash
# Build IPA file
flutter build ipa --release

# Output location:
# build/ios/ipa/
```

**To upload to App Store:**
1. Open Xcode
2. **Product** → **Archive**
3. Wait for archive to complete
4. Click **Distribute App**
5. Follow App Store Connect upload process

### Web Build

```bash
# Run on Chrome
flutter run -d chrome

# Run on web server (accessible from other devices)
flutter run -d web-server --web-port 8080
# Open: http://localhost:8080

# Build for production
flutter build web --release

# Output location: build/web/

# Preview production build
cd build/web
python3 -m http.server 8000
# Open: http://localhost:8000
```

### Build Tips

```bash
# Clean build cache
flutter clean

# Rebuild everything
flutter clean && flutter pub get && flutter run

# Build with verbose output
flutter build apk --verbose

# Build for specific architecture
flutter build apk --target-platform android-arm64

# Check build size
flutter build apk --analyze-size
```

### Common Build Issues

**Issue**: "Gradle build failed"
```bash
# Solution:
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter build apk
```

**Issue**: "CocoaPods error" (iOS)
```bash
# Solution:
cd ios
pod deintegrate
rm Podfile.lock
pod install
cd ..
flutter clean
flutter run
```

---

## 🧪 How to Run Appium Tests

Appium is an open-source test automation framework for mobile applications. Follow these steps to set up and run Appium tests for Laza.

### Prerequisites Installation

#### Step 1: Install Node.js

Download and install Node.js from [https://nodejs.org/](https://nodejs.org/)

```bash
# Verify installation
node --version  # Should show v16.x or higher
npm --version   # Should show v8.x or higher
```

#### Step 2: Install Appium

```bash
# Install Appium globally
npm install -g appium

# Verify installation
appium --version  # Should show 2.x.x
```

#### Step 3: Install Appium Doctor

```bash
# Install Appium Doctor for diagnostics
npm install -g appium-doctor

# Check Android setup
appium-doctor --android

# Check iOS setup (macOS only)
appium-doctor --ios
```

Fix any issues reported by Appium Doctor before continuing.

#### Step 4: Install Appium Drivers

```bash
# Install UiAutomator2 driver for Android
appium driver install uiautomator2

# Install XCUITest driver for iOS (macOS only)
appium driver install xcuitest

# List installed drivers
appium driver list --installed
```

### Test Project Setup

#### Step 1: Create Test Directory

```bash
# In project root
mkdir -p test/appium
cd test/appium
```

#### Step 2: Initialize npm Project

```bash
# Create package.json
npm init -y
```

#### Step 3: Install Test Dependencies

```bash
# Install WebdriverIO and dependencies
npm install --save-dev \
  webdriverio \
  @wdio/cli \
  @wdio/local-runner \
  @wdio/mocha-framework \
  @wdio/spec-reporter

# Initialize WebdriverIO configuration
npx wdio config
```

**Configuration Wizard Selections:**
- Test runner: `@wdio/local-runner`
- Framework: `mocha`
- Reporter: `spec`
- Service: `appium`
- Base URL: `(leave empty)`

#### Step 4: Create Test Configuration

Create `test/appium/wdio.conf.js`:

```javascript
exports.config = {
  runner: 'local',
  port: 4723,
  
  specs: [
    './specs/**/*.js'
  ],
  
  capabilities: [{
    platformName: 'Android',
    'appium:deviceName': 'Android Emulator',
    'appium:platformVersion': '13.0',
    'appium:app': process.env.APP_PATH || '/path/to/app-release.apk',
    'appium:automationName': 'UiAutomator2',
    'appium:autoGrantPermissions': true,
    'appium:noReset': false,
    'appium:fullReset': false
  }],
  
  logLevel: 'info',
  bail: 0,
  waitforTimeout: 10000,
  connectionRetryTimeout: 120000,
  connectionRetryCount: 3,
  
  framework: 'mocha',
  reporters: ['spec'],
  
  mochaOpts: {
    ui: 'bdd',
    timeout: 60000
  }
};
```

#### Step 5: Create Test Specs Directory

```bash
mkdir -p test/appium/specs
```

### Writing Test Scripts

#### Test 1: Splash Screen Test

Create `test/appium/specs/splash.test.js`:

```javascript
describe('Laza App - Splash Screen', () => {
  it('should display splash screen with LAZA text', async () => {
    // Wait for splash screen to load
    await driver.pause(2000);
    
    // Find LAZA text
    const splashTitle = await $('~LAZA');
    
    // Verify it's displayed
    await expect(splashTitle).toBeDisplayed();
  });

  it('should display Login button', async () => {
    const loginButton = await $('~Login');
    await expect(loginButton).toBeDisplayed();
  });

  it('should display Sign up button', async () => {
    const signupButton = await $('~Sign up');
    await expect(signupButton).toBeDisplayed();
  });
});
```

#### Test 2: Login Flow Test

Create `test/appium/specs/login.test.js`:

```javascript
describe('Laza App - Login Flow', () => {
  before(async () => {
    // Navigate to login screen
    const loginButton = await $('~Login');
    await loginButton.click();
    await driver.pause(2000);
  });

  it('should display email input field', async () => {
    const emailField = await $('android=new UiSelector().className("android.widget.EditText").instance(0)');
    await expect(emailField).toBeDisplayed();
  });

  it('should display password input field', async () => {
    const passwordField = await $('android=new UiSelector().className("android.widget.EditText").instance(1)');
    await expect(passwordField).toBeDisplayed();
  });

  it('should login with valid credentials', async () => {
    // Enter email
    const emailField = await $('android=new UiSelector().className("android.widget.EditText").instance(0)');
    await emailField.setValue('test@example.com');
    
    // Enter password
    const passwordField = await $('android=new UiSelector().className("android.widget.EditText").instance(1)');
    await passwordField.setValue('test123456');
    
    // Click login button
    const submitButton = await $('~Login');
    await submitButton.click();
    
    // Wait for navigation
    await driver.pause(3000);
    
    // Verify successful login (check for home screen element)
    const homeIndicator = await $('~Home');
    await expect(homeIndicator).toBeDisplayed();
  });

  it('should show error with invalid credentials', async () => {
    // Enter invalid email
    const emailField = await $('android=new UiSelector().className("android.widget.EditText").instance(0)');
    await emailField.setValue('invalid@example.com');
    
    // Enter password
    const passwordField = await $('android=new UiSelector().className("android.widget.EditText").instance(1)');
    await passwordField.setValue('wrongpassword');
    
    // Click login button
    const submitButton = await $('~Login');
    await submitButton.click();
    
    // Wait for error message
    await driver.pause(2000);
    
    // Verify error is displayed
    const errorMessage = await $('android=new UiSelector().textContains("wrong")');
    await expect(errorMessage).toBeDisplayed();
  });
});
```

#### Test 3: Product Browsing Test

Create `test/appium/specs/products.test.js`:

```javascript
describe('Laza App - Product Browsing', () => {
  before(async () => {
    // Assume user is logged in
    // Navigate to home/products screen
  });

  it('should display product grid', async () => {
    await driver.pause(3000);
    
    const productGrid = await $('android=new UiSelector().className("android.view.View")');
    await expect(productGrid).toBeDisplayed();
  });

  it('should search for products', async () => {
    // Find search field
    const searchField = await $('android=new UiSelector().className("android.widget.EditText")');
    await searchField.click();
    await searchField.setValue('shirt');
    
    // Wait for search results
    await driver.pause(2000);
    
    // Verify results contain search term
    const result = await $('android=new UiSelector().textContains("shirt")');
    await expect(result).toBeDisplayed();
  });

  it('should add product to favorites', async () => {
    // Find first product
    const product = await $('android=new UiSelector().className("android.view.View").instance(0)');
    await product.click();
