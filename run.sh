#!/bin/bash

# Ascend - Build & Run Script
# Usage: ./run.sh [device-name]

set -e

PROJECT="Ascend.xcodeproj"
SCHEME="Ascend"
CONFIGURATION="Debug"

# Default to iPhone 15 Pro if no device specified
DEVICE_NAME="${1:-iPhone 15 Pro}"
# Use device ID for reliable targeting
DEVICE_ID="7DC73CE7-936E-4319-B0AB-70E870D0B687"

echo "🔨 Building Ascend..."

# Build the app
xcodebuild \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -configuration "$CONFIGURATION" \
  -sdk iphonesimulator \
  -destination "platform=iOS Simulator,id=$DEVICE_ID" \
  -derivedDataPath build \
  build

echo "✅ Build complete!"

# Get the app bundle path
APP_PATH=$(find build/Build/Products/Debug-iphonesimulator -name "*.app" -maxdepth 1 | head -1)

if [ -z "$APP_PATH" ]; then
  echo "❌ Could not find .app bundle"
  exit 1
fi

echo "📱 Installing on $DEVICE_NAME..."

# Boot simulator if not already running
xcrun simctl boot "$DEVICE_ID" 2>/dev/null || true

# Open Simulator.app
open -a Simulator

# Install the app
xcrun simctl install "$DEVICE_ID" "$APP_PATH"

# Bundle identifier from project.yml
BUNDLE_ID="com.barsboldb.ascend"

echo "🚀 Launching Ascend..."

# Launch the app
xcrun simctl launch --console "$DEVICE_ID" "$BUNDLE_ID"

echo "✨ Ascend is running on $DEVICE_NAME"
