#!/bin/bash

# Emily's Marathon Split Calculator - Advanced Deploy Script
# This script builds the Flutter web app for release and deploys to Firebase
# with additional options and better error handling

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
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

print_header() {
    echo -e "${PURPLE}[STEP]${NC} $1"
}

# Default values
SKIP_ANALYZE=false
SKIP_CLEAN=false
VERBOSE=false
FIREBASE_PROJECT=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --skip-analyze)
            SKIP_ANALYZE=true
            shift
            ;;
        --skip-clean)
            SKIP_CLEAN=true
            shift
            ;;
        --verbose|-v)
            VERBOSE=true
            shift
            ;;
        --project|-p)
            FIREBASE_PROJECT="$2"
            shift 2
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --skip-analyze    Skip code analysis"
            echo "  --skip-clean      Skip flutter clean"
            echo "  --verbose, -v     Enable verbose output"
            echo "  --project, -p     Firebase project ID"
            echo "  --help, -h        Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0                                    # Normal deployment"
            echo "  $0 --skip-analyze --verbose          # Skip analysis, verbose output"
            echo "  $0 --project my-project-id           # Deploy to specific project"
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

print_header "Emily's Marathon Split Calculator - Deployment"
echo "=================================================="

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed or not in PATH"
    print_status "Install Flutter from: https://flutter.dev/docs/get-started/install"
    exit 1
fi

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    print_error "Firebase CLI is not installed"
    print_status "Install it with: npm install -g firebase-tools"
    exit 1
fi

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    print_error "pubspec.yaml not found. Are you in the Flutter project directory?"
    exit 1
fi

# Check if firebase.json exists
if [ ! -f "firebase.json" ]; then
    print_error "firebase.json not found. Initialize Firebase hosting first:"
    print_status "Run: firebase init hosting"
    exit 1
fi

# Show Flutter and Firebase versions
print_status "Flutter version: $(flutter --version | head -n 1)"
print_status "Firebase CLI version: $(firebase --version)"

# Step 1: Clean and get dependencies
if [ "$SKIP_CLEAN" = false ]; then
    print_header "Step 1: Cleaning project and getting dependencies"
    print_status "Running flutter clean..."
    flutter clean
    
    print_status "Getting dependencies..."
    flutter pub get
else
    print_warning "Skipping flutter clean (--skip-clean)"
    print_status "Getting dependencies..."
    flutter pub get
fi

# Step 2: Analyze code
if [ "$SKIP_ANALYZE" = false ]; then
    print_header "Step 2: Analyzing code"
    if [ "$VERBOSE" = true ]; then
        flutter analyze --verbose
    else
        flutter analyze
    fi
    
    if [ $? -ne 0 ]; then
        print_warning "Code analysis found issues, but continuing with build..."
    else
        print_success "Code analysis passed!"
    fi
else
    print_warning "Skipping code analysis (--skip-analyze)"
fi

# Step 3: Build for web release
print_header "Step 3: Building Flutter web app for release"
print_status "Building with release configuration..."

if [ "$VERBOSE" = true ]; then
    flutter build web --release --verbose
else
    flutter build web --release
fi

if [ $? -ne 0 ]; then
    print_error "Build failed!"
    exit 1
fi

print_success "Build completed successfully!"
print_status "Build output: build/web/"

# Step 4: Deploy to Firebase
print_header "Step 4: Deploying to Firebase"
print_status "Deploying to Firebase hosting..."

# Set Firebase project if specified
if [ -n "$FIREBASE_PROJECT" ]; then
    print_status "Using Firebase project: $FIREBASE_PROJECT"
    firebase use "$FIREBASE_PROJECT"
fi

# Deploy to Firebase
if [ "$VERBOSE" = true ]; then
    firebase deploy --only hosting --debug
else
    firebase deploy --only hosting
fi

if [ $? -ne 0 ]; then
    print_error "Firebase deployment failed!"
    exit 1
fi

print_success "Deployment completed successfully! 🎉"
print_status "Your app should now be live at your Firebase hosting URL"

# Show deployment info
print_header "Deployment Summary"
echo "==================="
print_status "Build directory: build/web/"
print_status "Firebase project: $(firebase use 2>/dev/null | grep 'Now using' | cut -d' ' -f3 || echo 'default')"
print_status "Deployment time: $(date)"
