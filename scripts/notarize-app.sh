#!/bin/bash

set -e

echo "📮 Notarizing Tiny Home/End App with Apple..."

# Configuration
APP_NAME="Tiny Home End"
APP_BUNDLE="build/${APP_NAME}.app"
APPLE_ID="apple@adenearnshaw.com"
BUNDLE_ID="com.a10w.tinymackeybindings"

# Check if app is signed
if ! codesign -vvv --deep --strict "$APP_BUNDLE" 2>&1 > /dev/null; then
    echo "❌ Error: App is not properly signed"
    echo "Run ./scripts/sign-app.sh first"
    exit 1
fi

echo "✅ App is signed"

# Get Team ID from the signed app
TEAM_ID=$(codesign -dvvv "$APP_BUNDLE" 2>&1 | grep "TeamIdentifier" | cut -d'=' -f2)
if [ -z "$TEAM_ID" ]; then
    echo "⚠️  Warning: Could not determine Team ID from signature"
    echo "You'll need to provide it manually when prompted"
fi

echo "📦 Creating submission package..."
ZIP_FILE="build/${APP_NAME}.zip"
ditto -c -k --keepParent "$APP_BUNDLE" "$ZIP_FILE"
echo "✅ Created: $ZIP_FILE"

echo ""
echo "🔑 Notarization Credentials Setup"
echo "================================="
echo ""
echo "You need to create an app-specific password:"
echo "1. Go to: https://appleid.apple.com/account/manage"
echo "2. Sign in with: $APPLE_ID"
echo "3. Under 'Security', find 'App-Specific Passwords'"
echo "4. Click 'Generate Password'"
echo "5. Name it: 'Tiny Home End Notarization'"
echo "6. Copy the password that's generated"
echo ""
read -p "Press Enter when you have your app-specific password ready..."

echo ""
echo "Now we'll store these credentials securely in your keychain..."
echo ""

# Store credentials in keychain for future use
xcrun notarytool store-credentials "notarytool-tinyhomeend" \
    --apple-id "$APPLE_ID" \
    --team-id "$TEAM_ID" \
    --password "$(read -sp 'Paste your app-specific password: ' pwd; echo $pwd)"

echo ""
echo ""
echo "✅ Credentials stored!"
echo ""
echo "📤 Submitting app to Apple for notarization..."

# Submit for notarization
xcrun notarytool submit "$ZIP_FILE" \
    --keychain-profile "notarytool-tinyhomeend" \
    --wait

# Check if notarization succeeded
if [ $? -eq 0 ]; then
    echo "✅ Notarization successful!"
    
    # Staple the notarization ticket to the app
    echo "📎 Stapling notarization ticket to app..."
    xcrun stapler staple "$APP_BUNDLE"
    
    echo ""
    echo "🎉 App is now notarized and ready for distribution!"
    echo ""
    echo "Next step: Create DMG installer"
    echo "  ./scripts/create-dmg.sh"
else
    echo "❌ Notarization failed!"
    echo ""
    echo "To see the detailed log:"
    echo "  xcrun notarytool log <submission-id> --keychain-profile notarytool-tinyhomeend"
    exit 1
fi

# Verify notarization
echo ""
echo "🔍 Verifying notarization..."
spctl -a -vvv -t install "$APP_BUNDLE"

if [ $? -eq 0 ]; then
    echo "✅ Gatekeeper will allow this app!"
else
    echo "⚠️  Warning: Gatekeeper verification had issues"
fi

# Clean up zip file
rm -f "$ZIP_FILE"

echo ""
echo "✅ Notarization complete!"
