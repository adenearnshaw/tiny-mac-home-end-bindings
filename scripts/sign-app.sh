#!/bin/bash

set -e

echo "🔐 Code Signing Tiny Home/End App..."

# Configuration
APP_NAME="Tiny Home End"
APP_BUNDLE="build/${APP_NAME}.app"
ENTITLEMENTS="TinyHomeEnd/Resources/TinyHomeEnd.entitlements"
BUNDLE_ID="com.a10w.tinymackeybindings"
APPLE_ID="apple@adenearnshaw.com"

# Find Developer ID Application certificate for personal account
# We'll look for your personal email to avoid company certificates
IDENTITY=$(security find-identity -v -p codesigning | grep "Developer ID Application" | grep -v "AutoFlow" | head -1 | grep -o '"[^"]*"' | tr -d '"')

if [ -z "$IDENTITY" ]; then
    echo "❌ Error: No personal 'Developer ID Application' certificate found"
    echo ""
    echo "Your Apple ID: $APPLE_ID"
    echo ""
    echo "Please follow these steps:"
    echo "1. Open Xcode"
    echo "2. Go to Xcode > Settings > Accounts"
    echo "3. Click '+' to add account"
    echo "4. Sign in with: $APPLE_ID"
    echo "5. Select your account and click 'Manage Certificates'"
    echo "6. Click '+' and select 'Developer ID Application'"
    echo ""
    echo "Note: Your account may still be activating. This can take up to 24 hours."
    echo "Check status at: https://developer.apple.com/account"
    echo ""
    echo "See CODESIGNING.md for detailed instructions"
    exit 1
fi

echo "✅ Found signing identity: $IDENTITY"
echo "   (Personal account - not AutoFlow)"

# Check if app bundle exists
if [ ! -d "$APP_BUNDLE" ]; then
    echo "❌ Error: App bundle not found at $APP_BUNDLE"
    echo "Run ./build-app.sh first"
    exit 1
fi

# Check if entitlements file exists
if [ ! -f "$ENTITLEMENTS" ]; then
    echo "❌ Error: Entitlements file not found at $ENTITLEMENTS"
    exit 1
fi

echo "📝 Using entitlements: $ENTITLEMENTS"

# Remove any existing signatures
echo "🧹 Removing existing signatures..."
codesign --remove-signature "$APP_BUNDLE" 2>/dev/null || true

# Sign all frameworks and dylibs first (if any)
echo "🔏 Signing frameworks and libraries..."
find "$APP_BUNDLE" -type f \( -name "*.dylib" -o -name "*.framework" \) -exec codesign --force --options runtime --timestamp --entitlements "$ENTITLEMENTS" --sign "$IDENTITY" {} \; 2>/dev/null || true

# Sign the main executable
echo "✍️  Signing main executable..."
EXECUTABLE="$APP_BUNDLE/Contents/MacOS/$APP_NAME"
if [ -f "$EXECUTABLE" ]; then
    codesign --force --options runtime --timestamp --entitlements "$ENTITLEMENTS" --sign "$IDENTITY" "$EXECUTABLE"
else
    echo "⚠️  Warning: Executable not found at $EXECUTABLE"
fi

# Sign the app bundle
echo "📦 Signing app bundle..."
codesign --force --options runtime --timestamp --deep --entitlements "$ENTITLEMENTS" --sign "$IDENTITY" "$APP_BUNDLE"

# Verify the signature
echo "🔍 Verifying signature..."
codesign --verify --verbose=4 --deep --strict "$APP_BUNDLE"

# Check if signature is valid
if codesign -vvv --deep --strict "$APP_BUNDLE" 2>&1; then
    echo "✅ Code signature verified successfully!"
else
    echo "❌ Code signature verification failed!"
    exit 1
fi

# Display signature info
echo ""
echo "📋 Signature Information:"
codesign -dvvv "$APP_BUNDLE" 2>&1 | grep -E "(Authority|Identifier|TeamIdentifier|Timestamp)"

echo ""
echo "✅ App successfully signed with your personal account!"
echo ""
echo "Next steps:"
echo "1. Notarize the app: ./scripts/notarize-app.sh"
echo "2. Create DMG: ./scripts/create-dmg.sh"
echo ""
echo "Or run all steps: ./scripts/release.sh"
