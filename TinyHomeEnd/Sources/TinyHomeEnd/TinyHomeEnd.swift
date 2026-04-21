// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import KeyBindingCore

@main
struct TinyHomeEnd {
    static func main() {
        print("🔧 Tiny Home/End Key Bindings - Core Service Demo")
        print("================================================\n")
        
        let service = KeyBindingService()
        
        // Check if file exists
        if service.keyBindingFileExists() {
            print("✓ Found existing DefaultKeyBinding.dict")
            
            if let bindings = try? service.readCurrentKeyBindings() {
                print("  Current bindings count: \(bindings.count)")
            }
        } else {
            print("⚠ No existing DefaultKeyBinding.dict found")
        }
        
        // Show available backups
        if let backups = try? service.listBackups() {
            print("\n📦 Available backups: \(backups.count)")
            for backup in backups.prefix(3) {
                print("  - \(backup.lastPathComponent)")
            }
        }
        
        // Generate sample configuration
        print("\n📝 Windows-like configuration:")
        let windowsConfig = KeyBindingConfiguration.windowsLike
        let content = service.generateKeyBindingDictContent(config: windowsConfig)
        print(content)
        
        print("\n📝 Paragraph-based configuration:")
        let paragraphConfig = KeyBindingConfiguration.paragraphBased
        let paragraphContent = service.generateKeyBindingDictContent(config: paragraphConfig)
        print(paragraphContent)
        
        print("\n✅ Core service is working!")
        print("\nNext: Build full macOS menu bar app with SwiftUI")
    }
}
