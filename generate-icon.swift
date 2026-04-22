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

let outputDir = "src/Resources/AppIcon.appiconset"

// Create output directory
try? FileManager.default.createDirectory(atPath: outputDir, withIntermediateDirectories: true)

// Generate icon using SF Symbol
let config = NSImage.SymbolConfiguration(pointSize: 512, weight: .regular, scale: .large)
guard let image = NSImage(systemSymbolName: "arrowkeys", accessibilityDescription: nil)?
    .withSymbolConfiguration(config) else {
    print("❌ Failed to create symbol image")
    exit(1)
}

// Create a professional macOS-style icon
let baseSize = NSSize(width: 1024, height: 1024)
let finalImage = NSImage(size: baseSize)

finalImage.lockFocus()

// macOS icon specs: rounded rectangle fills entire canvas
let cornerRadius: CGFloat = 228  // ~22.3% of 1024 for macOS rounded corners
let iconPath = NSBezierPath(roundedRect: NSRect(origin: .zero, size: baseSize), 
                            xRadius: cornerRadius, 
                            yRadius: cornerRadius)

// Clip to rounded rectangle shape
iconPath.addClip()

// Draw vibrant gradient background (blue to purple)
let gradient = NSGradient(colors: [
    NSColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0),      // Bright blue
    NSColor(red: 0.4, green: 0.3, blue: 0.95, alpha: 1.0)      // Vibrant purple
])
gradient?.draw(in: NSRect(origin: .zero, size: baseSize), angle: 135)

// Add subtle top highlight for depth (like macOS icons)
let highlight = NSGradient(colors: [
    NSColor.white.withAlphaComponent(0.25),
    NSColor.white.withAlphaComponent(0.0)
])
let highlightRect = NSRect(x: 0, y: baseSize.height * 0.5, 
                          width: baseSize.width, height: baseSize.height * 0.5)
highlight?.draw(in: highlightRect, angle: 90)

// Draw keyboard symbol with subtle shadow for depth
let symbolSize: CGFloat = 520
let symbolRect = NSRect(x: (baseSize.width - symbolSize) / 2,
                       y: (baseSize.height - symbolSize) / 2,
                       width: symbolSize,
                       height: symbolSize)

// Draw shadow
let shadow = NSShadow()
shadow.shadowColor = NSColor.black.withAlphaComponent(0.3)
shadow.shadowBlurRadius = 20
shadow.shadowOffset = NSSize(width: 0, height: -10)
shadow.set()

// Draw symbol in white
NSColor.white.setFill()
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
