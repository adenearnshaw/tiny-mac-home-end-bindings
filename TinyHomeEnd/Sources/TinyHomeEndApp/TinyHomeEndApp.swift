import SwiftUI
import KeyBindingCore
import UserNotifications

@main
struct TinyHomeEndApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

@MainActor
class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    private var settingsWindow: NSWindow?
    private var aboutWindow: NSWindow?
    private let keyBindingService = KeyBindingService()
    @Published private var isEnabled = false
    private var isFirstRun = false
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Request notification permissions
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            }
        }
        
        // Check if first run
        isFirstRun = !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        
        // Create menu bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            updateMenuBarIcon()
            button.action = #selector(statusBarButtonClicked)
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        
        updateMenu()
        checkCurrentState()
        
        // Setup keyboard shortcuts
        setupKeyboardShortcuts()
        
        // Show first run welcome
        if isFirstRun {
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.showFirstRunWelcome()
            }
        }
    }
    
    private func setupKeyboardShortcuts() {
        // Add local event monitor for keyboard shortcuts
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            // Cmd+Shift+K to toggle bindings
            if event.modifierFlags.contains([.command, .shift]) && event.charactersIgnoringModifiers == "k" {
                DispatchQueue.main.async {
                    self?.toggleBindings()
                }
                return nil
            }
            
            return event
        }
    }
    
    @MainActor
    private func updateMenuBarIcon() {
        guard let button = statusItem?.button else { return }
        
        // Use different icon based on enabled state
        let iconName = isEnabled ? "keyboard.fill" : "keyboard"
        button.image = NSImage(systemSymbolName: iconName, accessibilityDescription: "Tiny Home/End")
    }
    
    @MainActor
    @objc func statusBarButtonClicked() {
        updateMenu()
        statusItem?.menu?.popUp(positioning: nil, at: NSEvent.mouseLocation, in: nil)
    }
    
    @MainActor
    private func updateMenu() {
        let menu = NSMenu()
        
        // Enable/Disable toggle
        let enableItem = NSMenuItem(
            title: isEnabled ? "Disable Home/End Bindings" : "Enable Home/End Bindings",
            action: #selector(toggleBindings),
            keyEquivalent: "k"
        )
        enableItem.target = self
        enableItem.keyEquivalentModifierMask = [.command, .shift]
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
        
        // Launch at Login
        let launchAtLoginItem = NSMenuItem(
            title: "Launch at Login",
            action: #selector(toggleLaunchAtLogin),
            keyEquivalent: ""
        )
        launchAtLoginItem.target = self
        launchAtLoginItem.state = LaunchAtLoginService.shared.isEnabled ? .on : .off
        menu.addItem(launchAtLoginItem)
        
        menu.addItem(NSMenuItem.separator())
        
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
    
    @MainActor
    @objc func toggleLaunchAtLogin() {
        LaunchAtLoginService.shared.isEnabled.toggle()
        updateMenu()
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
                    updateMenuBarIcon()
                    showNotification(title: "Bindings Disabled", message: "Original keybindings restored")
                }
            } else {
                // Enable: apply Windows-like configuration
                let config = KeyBindingConfiguration.windowsLike
                try keyBindingService.applyConfiguration(config, merge: true)
                updateMenuBarIcon()
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
    private func showFirstRunWelcome() {
        let alert = NSAlert()
        alert.messageText = "Welcome to Tiny Home/End!"
        alert.informativeText = """
        This app makes Home/End keys work like they do on Windows.
        
        • Home → Beginning of line
        • End → End of line
        • Ctrl+Home/End → Document navigation
        
        Your existing keybindings will be backed up automatically before any changes.
        
        Would you like to enable Windows-like bindings now?
        """
        alert.alertStyle = .informational
        alert.addButton(withTitle: "Enable")
        alert.addButton(withTitle: "Later")
        
        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            toggleBindings()
        }
    }
    
    @MainActor
    @objc func openSettings() {
        if settingsWindow == nil {
            let settingsView = SettingsView(service: keyBindingService)
            let hostingController = NSHostingController(rootView: settingsView)
            
            settingsWindow = NSWindow(contentViewController: hostingController)
            settingsWindow?.title = "Settings"
            settingsWindow?.styleMask = [.titled, .closable, .miniaturizable]
            settingsWindow?.setContentSize(NSSize(width: 550, height: 500))
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
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification error: \(error)")
            }
        }
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
