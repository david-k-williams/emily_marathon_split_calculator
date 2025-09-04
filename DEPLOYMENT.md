# Deployment Guide

This guide explains how to deploy Emily's Marathon Split Calculator to Firebase Hosting.

## Prerequisites

1. **Flutter SDK** - Install from [flutter.dev](https://flutter.dev/docs/get-started/install)
2. **Firebase CLI** - Install with: `npm install -g firebase-tools`
3. **Firebase Project** - Initialize with: `firebase init hosting`

## Quick Deployment

### Option 1: Shell Script (macOS/Linux)
```bash
./deploy.sh
```

### Option 2: Windows Batch File
```cmd
deploy.bat
```

### Option 3: NPM Script
```bash
npm run deploy
```

## Advanced Deployment

For more control over the deployment process:

```bash
./deploy-advanced.sh [OPTIONS]
```

### Available Options

- `--skip-analyze` - Skip code analysis
- `--skip-clean` - Skip flutter clean
- `--verbose, -v` - Enable verbose output
- `--project, -p PROJECT_ID` - Deploy to specific Firebase project
- `--help, -h` - Show help message

### Examples

```bash
# Normal deployment
./deploy-advanced.sh

# Skip analysis and enable verbose output
./deploy-advanced.sh --skip-analyze --verbose

# Deploy to specific Firebase project
./deploy-advanced.sh --project my-project-id

# Quick deployment (skip clean and analysis)
./deploy-advanced.sh --skip-clean --skip-analyze
```

## Manual Deployment Steps

If you prefer to run the commands manually:

1. **Clean and get dependencies:**
   ```bash
   flutter clean
   flutter pub get
   ```

2. **Analyze code (optional):**
   ```bash
   flutter analyze
   ```

3. **Build for release:**
   ```bash
   flutter build web --release
   ```

4. **Deploy to Firebase:**
   ```bash
   firebase deploy --only hosting
   ```

## NPM Scripts

The `package.json` includes several useful scripts:

- `npm run deploy` - Full deployment (clean, build, deploy)
- `npm run deploy:quick` - Quick deployment (build, deploy)
- `npm run deploy:verbose` - Verbose deployment with analysis
- `npm run build` - Build only
- `npm run analyze` - Code analysis only
- `npm run clean` - Clean project
- `npm run deps` - Get dependencies
- `npm run test` - Run tests
- `npm run serve` - Serve locally with Firebase
- `npm run preview` - Deploy to preview channel

## Troubleshooting

### Common Issues

1. **Flutter not found:**
   - Ensure Flutter is installed and in your PATH
   - Run `flutter doctor` to check installation

2. **Firebase CLI not found:**
   - Install with: `npm install -g firebase-tools`
   - Login with: `firebase login`

3. **Build fails:**
   - Check for errors in the build output
   - Ensure all dependencies are installed
   - Try running `flutter clean` first

4. **Deployment fails:**
   - Check Firebase project configuration
   - Ensure you're logged in: `firebase login`
   - Verify `firebase.json` exists

### Getting Help

- Check Flutter documentation: [docs.flutter.dev](https://docs.flutter.dev)
- Check Firebase documentation: [firebase.google.com/docs](https://firebase.google.com/docs)
- Run `flutter doctor` to diagnose Flutter issues
- Run `firebase --help` for Firebase CLI help

## File Structure

```
emily_marathon_split_calculator/
├── deploy.sh              # Basic deployment script (macOS/Linux)
├── deploy.bat             # Basic deployment script (Windows)
├── deploy-advanced.sh     # Advanced deployment script
├── package.json           # NPM scripts
├── firebase.json          # Firebase configuration
├── assets/races.json      # Race data
└── build/web/             # Build output (created during build)
```
