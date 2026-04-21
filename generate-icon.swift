#!/usr/bin/swift
import AppKit
import Foundation

// Generate app icon from SF Symbol
let sizes: [(size: Int, scale: Int)] = [
    (16, 1), (16, 2),
    (32, 1), (32, 2),
    (128, 1), (128, 2),
    (256, 1), (256, 2),
    (512, 1), (512, 2)
]

let outputDir = "TinyHomeEnd/Resources/AppIcon.appiconset"

// Create output directory
try? FileManager.default.createDirectory(atPath: outputDir, withIntermediateDirectories: true)

// Generate icon using SF Symbol
let config = NSImage.SymbolConfiguration(pointSize: 512, weight: .regular, scale: .large)
guard let image = NSImage(systemSymbolName: "keyboard.fill", accessibilityDescription: nil)?
    .withSymbolConfiguration(config) else {
    print("❌ Failed to create symbol image")
    exit(1)
}

// Create a colored version with gradient
let baseSize = NSSize(width: 1024, height: 1024)
let finalImage = NSImage(size: baseSize)

finalImage.lockFocus()

// Draw gradient background
let gradient = NSGradient(colors: [
    NSColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0),  // Blue
    NSColor(red: 0.35, green: 0.34, blue: 0.84, alpha: 1.0)  // Purple
])
gradient?.draw(in: NSRect(origin: .zero, size: baseSize), angle: 135)

// Draw rounded rectangle background
let cornerRadius: CGFloat = 228  // ~22% of 1024 for macOS Big Sur style
let inset: CGFloat = 0
let backgroundRect = NSRect(x: inset, y: inset, width: baseSize.width - inset * 2, height: baseSize.height - inset * 2)
let path = NSBezierPath(roundedRect: backgroundRect, xRadius: cornerRadius, yRadius: cornerRadius)
NSColor.white.withAlphaComponent(0.15).setFill()
path.fill()

// Draw symbol in white
NSColor.white.setFill()
let symbolRect = NSRect(x: 200, y: 200, width: 624, height: 624)
image.draw(in: symbolRect)

finalImage.unlockFocus()

// Save at different sizes
for (size, scale) in sizes {
    let actualSize = size * scale
    let scaledImage = NSImage(size: NSSize(width: actualSize, height: actualSize))
    
    scaledImage.lockFocus()
    finalImage.draw(in: NSRect(origin: .zero, size: NSSize(width: actualSize, height: actualSize)),
                    from: NSRect(origin: .zero, size: baseSize),
                    operation: .copy,
                    fraction: 1.0)
    scaledImage.unlockFocus()
    
    if let tiffData = scaledImage.tiffRepresentation,
       let bitmap = NSBitmapImageRep(data: tiffData),
       let pngData = bitmap.representation(using: .png, properties: [:]) {
        let filename = scale == 1 ? "icon_\(size)x\(size).png" : "icon_\(size)x\(size)@2x.png"
        let path = "\(outputDir)/\(filename)"
        try? pngData.write(to: URL(fileURLWithPath: path))
        print("✅ Generated: \(filename)")
    }
}

// Generate Contents.json
let contentsJSON = """
{
  "images" : [
    {
      "filename" : "icon_16x16.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "16x16"
    },
    {
      "filename" : "icon_16x16@2x.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "16x16"
    },
    {
      "filename" : "icon_32x32.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "32x32"
    },
    {
      "filename" : "icon_32x32@2x.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "32x32"
    },
    {
      "filename" : "icon_128x128.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "128x128"
    },
    {
      "filename" : "icon_128x128@2x.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "128x128"
    },
    {
      "filename" : "icon_256x256.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "256x256"
    },
    {
      "filename" : "icon_256x256@2x.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "256x256"
    },
    {
      "filename" : "icon_512x512.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "512x512"
    },
    {
      "filename" : "icon_512x512@2x.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "512x512"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
"""

try? contentsJSON.write(toFile: "\(outputDir)/Contents.json", atomically: true, encoding: .utf8)
print("✅ Generated: Contents.json")

print("\n🎉 App icon set created successfully!")
print("📁 Location: \(outputDir)")
