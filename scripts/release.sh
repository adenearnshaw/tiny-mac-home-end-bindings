#!/bin/bash

set -e

echo "🚀 Complete Release Build for Tiny Home/End"
echo "=========================================="
echo ""

# Step 1: Build the app
echo "Step 1/5: Building app..."
./scripts/build-app.sh

# Step 2: Sign the app
echo ""
echo "Step 2/5: Code signing..."
./scripts/sign-app.sh

# Step 3: Notarize the app
echo ""
echo "Step 3/5: Notarizing with Apple..."
./scripts/notarize-app.sh

# Step 4: Create DMG
echo ""
echo "Step 4/5: Creating DMG installer..."
./scripts/create-dmg.sh

# Step 5: Summary
echo ""
echo "Step 5/5: Release Summary"
echo "========================="
echo ""

VERSION="0.3.0"
DMG_FILE="build/TinyHomeEnd-${VERSION}.dmg"

if [ -f "$DMG_FILE" ]; then
    echo "✅ Release build complete!"
    echo ""
    echo "📦 Deliverable:"
    echo "   File: $DMG_FILE"
    echo "   Size: $(ls -lh "$DMG_FILE" | awk '{print $5}')"
    echo ""
    echo "🔐 Security:"
    echo "   Signed: ✅"
    echo "   Notarized: ✅"
    echo "   Gatekeeper: ✅"
    echo ""
    echo "📋 SHA256:"
    shasum -a 256 "$DMG_FILE" | awk '{print "   " $1}'
    echo ""
    echo "🎯 Next Steps:"
    echo "   1. Test the DMG: open '$DMG_FILE'"
    echo "   2. Create GitHub release:"
    echo "      gh release create v${VERSION} '$DMG_FILE' --title 'v${VERSION}' --notes 'Release notes here'"
    echo "   3. Update Homebrew cask (see scripts/homebrew-cask.rb)"
    echo ""
else
    echo "❌ Release build failed!"
    echo "Check the output above for errors"
    exit 1
fi
