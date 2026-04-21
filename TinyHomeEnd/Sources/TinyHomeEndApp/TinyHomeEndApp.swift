import SwiftUI
import KeyBindingCore

@main
struct TinyHomeEndApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    private var settingsWindow: NSWindow?
    private var aboutWindow: NSWindow?
    private let keyBindingService = KeyBindingService()
    @Published private var isEnabled = false
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create menu bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "keyboard", accessibilityDescription: "Tiny Home/End")
            button.action = #selector(statusBarButtonClicked)
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        
        updateMenu()
        checkCurrentState()
    }
    
    @objc func statusBarButtonClicked() {
        updateMenu()
        statusItem?.menu?.popUp(positioning: nil, at: NSEvent.mouseLocation, in: nil)
    }
    
    private func updateMenu() {
        let menu = NSMenu()
        
        // Enable/Disable toggle
        let enableItem = NSMenuItem(
            title: isEnabled ? "Disable Home/End Bindings" : "Enable Home/End Bindings",
            action: #selector(toggleBindings),
            keyEquivalent: ""
        )
        enableItem.target = self
        menu.addItem(enableItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Settings
        let settingsItem = NSMenuItem(
            title: "Settings...",
            action: #selector(openSettings),
            keyEquivalent: ","
        )
        settingsItem.target = self
        menu.addItem(settingsItem)
        
        // About
        let aboutItem = NSMenuItem(
            title: "About Tiny Home/End",
            action: #selector(openAbout),
            keyEquivalent: ""
        )
        aboutItem.target = self
        menu.addItem(aboutItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Quit
        let quitItem = NSMenuItem(
            title: "Quit",
            action: #selector(quit),
            keyEquivalent: "q"
        )
        quitItem.target = self
        menu.addItem(quitItem)
        
        statusItem?.menu = menu
    }
    
    private func checkCurrentState() {
        // Check if our bindings are currently applied
        isEnabled = keyBindingService.keyBindingFileExists()
    }
    
    @MainActor
    @objc func toggleBindings() {
        do {
            if isEnabled {
                // Disable: restore from backup
                if let backups = try? keyBindingService.listBackups(), let latest = backups.first {
                    try keyBindingService.restoreFromBackup(latest)
                    showNotification(title: "Bindings Disabled", message: "Original keybindings restored")
                }
            } else {
                // Enable: apply Windows-like configuration
                let config = KeyBindingConfiguration.windowsLike
                try keyBindingService.applyConfiguration(config, merge: true)
                showNotification(
                    title: "Bindings Enabled",
                    message: "Windows-like Home/End keys applied. Restart apps to apply changes."
                )
            }
            isEnabled.toggle()
            updateMenu()
        } catch {
            showAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
    @MainActor
    @objc func openSettings() {
        if settingsWindow == nil {
            let settingsView = SettingsView(service: keyBindingService)
            let hostingController = NSHostingController(rootView: settingsView)
            
            settingsWindow = NSWindow(contentViewController: hostingController)
            settingsWindow?.title = "Settings"
            settingsWindow?.styleMask = [.titled, .closable]
            settingsWindow?.setContentSize(NSSize(width: 500, height: 400))
            settingsWindow?.center()
        }
        
        settingsWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @MainActor
    @objc func openAbout() {
        if aboutWindow == nil {
            let aboutView = AboutView()
            let hostingController = NSHostingController(rootView: aboutView)
            
            aboutWindow = NSWindow(contentViewController: hostingController)
            aboutWindow?.title = "About"
            aboutWindow?.styleMask = [.titled, .closable]
            aboutWindow?.setContentSize(NSSize(width: 400, height: 300))
            aboutWindow?.center()
        }
        
        aboutWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @MainActor
    @objc func quit() {
        NSApp.terminate(nil)
    }
    
    private func showNotification(title: String, message: String) {
        let notification = NSUserNotification()
        notification.title = title
        notification.informativeText = message
        notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.default.deliver(notification)
    }
    
    @MainActor
    private func showAlert(title: String, message: String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
}
