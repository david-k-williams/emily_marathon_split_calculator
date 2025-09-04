#!/bin/bash

# Emily's Marathon Split Calculator - Deploy Script
# This script builds the Flutter web app for release and deploys to Firebase

set -e  # Exit on any error

echo "🚀 Starting deployment process..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed or not in PATH"
    exit 1
fi

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    print_error "Firebase CLI is not installed. Install it with: npm install -g firebase-tools"
    exit 1
fi

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    print_error "pubspec.yaml not found. Are you in the Flutter project directory?"
    exit 1
fi

# Step 1: Clean and get dependencies
print_status "Cleaning project and getting dependencies..."
flutter clean
flutter pub get

# Step 2: Analyze code
print_status "Analyzing code..."
if ! flutter analyze; then
    print_warning "Code analysis found issues, but continuing with build..."
fi

# Step 3: Build for web release
print_status "Building Flutter web app for release..."
if ! flutter build web --release; then
    print_error "Build failed!"
    exit 1
fi

print_success "Build completed successfully!"

# Step 3.1: Copy build to Firebase
print_status "Copying build to Firebase..."
cp -r build/web/* firebase/public/

print_success "Build copied to Firebase successfully!"

# Step 3.2: Change directory to firebase
print_status "Changing directory to firebase..."
cd firebase

# Step 4: Deploy to Firebase
print_status "Deploying to Firebase..."
if ! firebase deploy --only hosting; then

    print_error "Firebase deployment failed!"
    exit 1
fi

print_success "Deployment completed successfully! 🎉"
print_status "Your app should now be live at your Firebase hosting URL"
