#!/bin/bash

# Ascend - Build & Run Script
# Usage: ./run.sh [device-name]

set -e

PROJECT="Ascend.xcodeproj"
SCHEME="Ascend"
CONFIGURATION="Debug"

DEVICE_NAME="${1:-iPhone 17 Pro}"
DEVICE_ID="CF410C2F-CC12-4D3E-940A-D4B7758FA395"

xcrun simctl boot "$DEVICE_ID" 2>/dev/null || true
open -a Simulator

# Wait for the simulator to register with Xcode's build system
xcrun simctl bootstatus "$DEVICE_ID" -b > /dev/null 2>&1 || true

echo "🔨 Building Ascend for $DEVICE_NAME..."

xcodebuild \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -configuration "$CONFIGURATION" \
  -destination "platform=iOS Simulator,id=$DEVICE_ID" \
  -derivedDataPath build \
  build

echo "✅ Build complete!"

APP_PATH=$(find build/Build/Products/Debug-iphonesimulator -name "*.app" -maxdepth 1 | head -1)

if [ -z "$APP_PATH" ]; then
  echo "❌ Could not find .app bundle"
  exit 1
fi

echo "📱 Installing on $DEVICE_NAME..."
xcrun simctl install "$DEVICE_ID" "$APP_PATH"

BUNDLE_ID="com.barsboldb.ascend"

echo "🚀 Launching Ascend..."
xcrun simctl launch --console "$DEVICE_ID" "$BUNDLE_ID"

echo "✨ Ascend is running on $DEVICE_NAME"
