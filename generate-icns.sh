#!/bin/bash

ICON_DIR="TinyHomeEnd/Resources/AppIcon.appiconset"
ICONSET_DIR="TinyHomeEnd/Resources/AppIcon.iconset"
ICNS_FILE="TinyHomeEnd/Resources/AppIcon.icns"

# Create iconset directory
mkdir -p "$ICONSET_DIR"

# Copy and rename files for iconutil
cp "$ICON_DIR/icon_16x16.png" "$ICONSET_DIR/icon_16x16.png"
cp "$ICON_DIR/icon_16x16@2x.png" "$ICONSET_DIR/icon_16x16@2x.png"
cp "$ICON_DIR/icon_32x32.png" "$ICONSET_DIR/icon_32x32.png"
cp "$ICON_DIR/icon_32x32@2x.png" "$ICONSET_DIR/icon_32x32@2x.png"
cp "$ICON_DIR/icon_128x128.png" "$ICONSET_DIR/icon_128x128.png"
cp "$ICON_DIR/icon_128x128@2x.png" "$ICONSET_DIR/icon_128x128@2x.png"
cp "$ICON_DIR/icon_256x256.png" "$ICONSET_DIR/icon_256x256.png"
cp "$ICON_DIR/icon_256x256@2x.png" "$ICONSET_DIR/icon_256x256@2x.png"
cp "$ICON_DIR/icon_512x512.png" "$ICONSET_DIR/icon_512x512.png"
cp "$ICON_DIR/icon_512x512@2x.png" "$ICONSET_DIR/icon_512x512@2x.png"

# Generate .icns file
iconutil -c icns "$ICONSET_DIR" -o "$ICNS_FILE"

echo "✅ Generated: $ICNS_FILE"
ls -lh "$ICNS_FILE"
