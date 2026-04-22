import Foundation
import ServiceManagement

/// Service for managing launch at login
@MainActor
class LaunchAtLoginService {
    static let shared = LaunchAtLoginService()
    
    private init() {}
    
    /// Check if app is set to launch at login
    var isEnabled: Bool {
        get {
            UserDefaults.standard.bool(forKey: "launchAtLogin")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "launchAtLogin")
            updateLaunchAtLogin(enabled: newValue)
        }
    }
    
    private func updateLaunchAtLogin(enabled: Bool) {
        // For macOS 13+ we use SMAppService
        if #available(macOS 13.0, *) {
            let service = SMAppService.mainApp
            
            do {
                if enabled {
                    if service.status == .notRegistered {
                        try service.register()
                    }
                } else {
                    if service.status == .enabled {
                        try service.unregister()
                    }
                }
            } catch {
                print("Failed to update launch at login: \(error)")
            }
        }
    }
}
