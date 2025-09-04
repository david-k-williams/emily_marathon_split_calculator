@echo off
REM Emily's Marathon Split Calculator - Deploy Script (Windows)
REM This script builds the Flutter web app for release and deploys to Firebase

echo 🚀 Starting deployment process...

REM Check if Flutter is installed
where flutter >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Flutter is not installed or not in PATH
    exit /b 1
)

REM Check if Firebase CLI is installed
where firebase >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Firebase CLI is not installed. Install it with: npm install -g firebase-tools
    exit /b 1
)

REM Check if we're in the right directory
if not exist "pubspec.yaml" (
    echo [ERROR] pubspec.yaml not found. Are you in the Flutter project directory?
    exit /b 1
)

REM Step 1: Clean and get dependencies
echo [INFO] Cleaning project and getting dependencies...
flutter clean
flutter pub get
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to get dependencies
    exit /b 1
)

REM Step 2: Analyze code
echo [INFO] Analyzing code...
flutter analyze
if %ERRORLEVEL% NEQ 0 (
    echo [WARNING] Code analysis found issues, but continuing with build...
)

REM Step 3: Build for web release
echo [INFO] Building Flutter web app for release...
flutter build web --release
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Build failed!
    exit /b 1
)

echo [SUCCESS] Build completed successfully!

REM Step 4: Deploy to Firebase
echo [INFO] Deploying to Firebase...
firebase deploy --only hosting
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Firebase deployment failed!
    exit /b 1
)

echo [SUCCESS] Deployment completed successfully! 🎉
echo [INFO] Your app should now be live at your Firebase hosting URL
