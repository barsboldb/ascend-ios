#!/bin/bash

# Ascend - Install & Run Script
# Usage: ./run.sh [device-name]
# Note: expects the app to already be built by `make build`

set -e

# Default to iPhone 17 Pro if no device specified
DEVICE_NAME="${1:-iPhone 17 Pro}"
# Use device ID for reliable targeting
DEVICE_ID="CF410C2F-CC12-4D3E-940A-D4B7758FA395"

# Get the app bundle path
APP_PATH=$(find build/Build/Products/Debug-iphonesimulator -name "*.app" -maxdepth 1 | head -1)

if [ -z "$APP_PATH" ]; then
  echo "❌ Could not find .app bundle — run \`make build\` first"
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
