#!/bin/bash

set -e

echo "💿 Creating DMG Installer for Tiny Home/End..."

# Configuration
APP_NAME="Tiny Home End"
APP_BUNDLE="build/${APP_NAME}.app"
DMG_NAME="TinyHomeEnd"
VERSION="0.2.0"
OUTPUT_DMG="build/${DMG_NAME}-${VERSION}.dmg"
TEMP_DMG="build/temp.dmg"
VOLUME_NAME="Tiny Home End ${VERSION}"

# Check if app exists
if [ ! -d "$APP_BUNDLE" ]; then
    echo "❌ Error: App bundle not found at $APP_BUNDLE"
    echo "Run ./build-app.sh first"
    exit 1
fi

# Check if app is signed and notarized
if ! codesign -vvv --deep --strict "$APP_BUNDLE" 2>&1 > /dev/null; then
    echo "⚠️  Warning: App is not signed"
    echo "For distribution, run ./scripts/sign-app.sh and ./scripts/notarize-app.sh first"
fi

# Create temporary directory for DMG contents
echo "📁 Preparing DMG contents..."
TEMP_DIR="build/dmg-temp"
rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"

# Copy app to temp directory
cp -R "$APP_BUNDLE" "$TEMP_DIR/"

# Create Applications symlink
ln -s /Applications "$TEMP_DIR/Applications"

# Create a simple README
cat > "$TEMP_DIR/README.txt" << 'EOF'
Tiny Home/End - Windows-like Home/End Keys for macOS

Installation:
1. Drag "Tiny Home End.app" to the Applications folder
2. Open the app from Applications
3. Grant necessary permissions when prompted
4. The app will appear in your menu bar

Usage:
- Click the keyboard icon in menu bar to enable/disable
- Use Cmd+Shift+K to quickly toggle bindings
- Open Settings (Cmd+,) to customize behavior

For more information:
https://github.com/adenearnshaw/tiny-mac-home-end-bindings

License: MIT
Copyright © 2026 Aden Earnshaw
EOF

# Calculate size needed
echo "📏 Calculating required size..."
SIZE=$(du -sm "$TEMP_DIR" | awk '{print $1}')
SIZE=$((SIZE + 50))  # Add 50MB buffer

# Create DMG
echo "💿 Creating DMG..."
rm -f "$TEMP_DMG" "$OUTPUT_DMG"

hdiutil create -srcfolder "$TEMP_DIR" \
    -volname "$VOLUME_NAME" \
    -fs HFS+ \
    -fsargs "-c c=64,a=16,e=16" \
    -format UDRW \
    -size ${SIZE}m \
    "$TEMP_DMG"

# Mount the DMG
echo "📂 Mounting DMG..."
MOUNT_OUTPUT=$(hdiutil attach -readwrite -noverify -noautoopen "$TEMP_DMG")
MOUNT_DIR=$(echo "$MOUNT_OUTPUT" | grep -E '/Volumes/' | sed 's/.*\(\/Volumes\/.*\)/\1/')

if [ -z "$MOUNT_DIR" ]; then
    echo "❌ Failed to mount DMG"
    exit 1
fi

echo "   Mounted at: $MOUNT_DIR"

# Set background and icon positions (requires AppleScript)
echo "🎨 Customizing DMG appearance..."
cat > /tmp/dmg-customization.applescript << EOF
tell application "Finder"
    tell disk "$VOLUME_NAME"
        open
        set current view of container window to icon view
        set toolbar visible of container window to false
        set statusbar visible of container window to false
        set the bounds of container window to {100, 100, 600, 400}
        set viewOptions to the icon view options of container window
        set arrangement of viewOptions to not arranged
        set icon size of viewOptions to 72
        set position of item "${APP_NAME}.app" of container window to {120, 150}
        set position of item "Applications" of container window to {380, 150}
        set position of item "README.txt" of container window to {250, 280}
        update without registering applications
        delay 2
        close
    end tell
end tell
EOF

osascript /tmp/dmg-customization.applescript || echo "⚠️  Could not customize DMG appearance"
rm /tmp/dmg-customization.applescript

# Unmount
echo "💾 Finalizing DMG..."
sync
hdiutil detach "$MOUNT_DIR"

# Convert to read-only compressed DMG
hdiutil convert "$TEMP_DMG" \
    -format UDZO \
    -imagekey zlib-level=9 \
    -o "$OUTPUT_DMG"

# Clean up
rm -f "$TEMP_DMG"
rm -rf "$TEMP_DIR"

# Get file size
DMG_SIZE=$(ls -lh "$OUTPUT_DMG" | awk '{print $5}')

echo ""
echo "✅ DMG created successfully!"
echo "   File: $OUTPUT_DMG"
echo "   Size: $DMG_SIZE"

# If signed, sign the DMG too
IDENTITY=$(security find-identity -v -p codesigning | grep "Developer ID Application" | grep -v "AutoFlow" | head -1 | grep -o '"[^"]*"' | tr -d '"')

if [ -n "$IDENTITY" ]; then
    echo ""
    echo "🔐 Signing DMG..."
    codesign --force --sign "$IDENTITY" "$OUTPUT_DMG"
    echo "✅ DMG signed!"
fi

echo ""
echo "📋 DMG Information:"
echo "   Name: $(basename "$OUTPUT_DMG")"
echo "   Size: $DMG_SIZE"
echo "   SHA256:"
shasum -a 256 "$OUTPUT_DMG" | awk '{print "     " $1}'

echo ""
echo "🎉 DMG ready for distribution!"
echo ""
echo "Test it:"
echo "  open '$OUTPUT_DMG'"
echo ""
echo "Next: Upload to GitHub releases"
