#!/bin/bash

set -e

echo "📦 Building Tiny Home/End App Bundle..."

# Build the app
cd TinyHomeEnd
swift build --product TinyHomeEndApp -c release

# Create app bundle structure
APP_NAME="Tiny Home End"
BUILD_DIR=".build/release"
APP_BUNDLE="../build/$APP_NAME.app"
CONTENTS="$APP_BUNDLE/Contents"
MACOS="$CONTENTS/MacOS"
RESOURCES="$CONTENTS/Resources"

echo "🗂️  Creating app bundle structure..."
rm -rf "$APP_BUNDLE"
mkdir -p "$MACOS"
mkdir -p "$RESOURCES"

# Copy binary
echo "📋 Copying binary..."
cp "$BUILD_DIR/TinyHomeEndApp" "$MACOS/$APP_NAME"
chmod +x "$MACOS/$APP_NAME"

# Copy resources
echo "🎨 Copying resources..."
cp Resources/Info.plist "$CONTENTS/"
cp Resources/AppIcon.icns "$RESOURCES/"

# Update Info.plist executable name
sed -i '' "s/TinyHomeEndApp/$APP_NAME/g" "$CONTENTS/Info.plist"

echo "✅ App bundle created at: $APP_BUNDLE"
echo ""
echo "To run:"
echo "  open \"$APP_BUNDLE\""
echo ""
echo "To test:"
echo "  ls -lR \"$APP_BUNDLE\""
