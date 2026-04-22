import Foundation
import CryptoKit

/// Service for managing DefaultKeyBinding.dict file
public class KeyBindingService {
    public enum KeyBindingError: Error, LocalizedError {
        case invalidFileFormat
        case backupFailed(String)
        case writeFailed(String)
        case permissionDenied
        case fileNotFound
        case invalidConfiguration
        
        public var errorDescription: String? {
            switch self {
            case .invalidFileFormat:
                return "The DefaultKeyBinding.dict file has an invalid format"
            case .backupFailed(let reason):
                return "Failed to create backup: \(reason)"
            case .writeFailed(let reason):
                return "Failed to write configuration: \(reason)"
            case .permissionDenied:
                return "Permission denied to access KeyBindings directory"
            case .fileNotFound:
                return "DefaultKeyBinding.dict file not found"
            case .invalidConfiguration:
                return "Invalid key binding configuration"
            }
        }
    }
    
    private let fileManager = FileManager.default
    private let keyBindingsPath: URL
    private let backupDirectory: URL
    
    public init() {
        let libraryPath = fileManager.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        self.keyBindingsPath = libraryPath
            .appendingPathComponent("KeyBindings")
            .appendingPathComponent("DefaultKeyBinding.dict")
        
        let appSupport = libraryPath.appendingPathComponent("Application Support")
        self.backupDirectory = appSupport
            .appendingPathComponent("com.a10w.tinymackeybindings")
            .appendingPathComponent("backups")
    }
    
    /// Check if DefaultKeyBinding.dict exists
    public func keyBindingFileExists() -> Bool {
        fileManager.fileExists(atPath: keyBindingsPath.path)
    }
    
    /// Read current DefaultKeyBinding.dict as property list
    public func readCurrentKeyBindings() throws -> [String: Any] {
        guard keyBindingFileExists() else {
            throw KeyBindingError.fileNotFound
        }
        
        guard let data = try? Data(contentsOf: keyBindingsPath),
              let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any] else {
            throw KeyBindingError.invalidFileFormat
        }
        
        return plist
    }
    
    /// Create backup of current DefaultKeyBinding.dict
    @discardableResult
    public func createBackup() throws -> URL {
        guard keyBindingFileExists() else {
            throw KeyBindingError.fileNotFound
        }
        
        // Create backup directory if needed
        try? fileManager.createDirectory(at: backupDirectory, withIntermediateDirectories: true)
        
        // Generate backup filename with timestamp
        let timestamp = ISO8601DateFormatter().string(from: Date())
            .replacingOccurrences(of: ":", with: "-")
        let backupFilename = "DefaultKeyBinding.dict.backup.\(timestamp)"
        let backupURL = backupDirectory.appendingPathComponent(backupFilename)
        
        do {
            try fileManager.copyItem(at: keyBindingsPath, to: backupURL)
            
            // Create metadata
            let metadata = BackupMetadata(
                timestamp: Date(),
                originalHash: try calculateHash(of: keyBindingsPath),
                appVersion: "1.0.0",
                backupPath: backupURL.path,
                originalPath: keyBindingsPath.path
            )
            
            try saveMetadata(metadata, for: backupURL)
            
            // Clean old backups (keep last 5)
            try cleanOldBackups(keeping: 5)
            
            return backupURL
        } catch {
            throw KeyBindingError.backupFailed(error.localizedDescription)
        }
    }
    
    /// Generate DefaultKeyBinding.dict content from configuration
    public func generateKeyBindingDictContent(config: KeyBindingConfiguration) -> String {
        let modifier = config.useCommandModifier ? KeyModifier.command : KeyModifier.control
        
        var lines: [String] = ["{"]
        
        // Home key
        lines.append("  \"\(KeyCode.home.rawValue)\" = \"\(config.homeAction.selector)\";")
        
        // End key
        lines.append("  \"\(KeyCode.end.rawValue)\" = \"\(config.endAction.selector)\";")
        
        // Shift + Home
        lines.append("  \"\(KeyCode.home.with(modifiers: [.shift]))\" = \"\(config.shiftHomeAction.selector)\";")
        
        // Shift + End
        lines.append("  \"\(KeyCode.end.with(modifiers: [.shift]))\" = \"\(config.shiftEndAction.selector)\";")
        
        // Ctrl/Cmd + Home
        lines.append("  \"\(KeyCode.home.with(modifiers: [modifier]))\" = \"\(config.ctrlHomeAction.selector)\";")
        
        // Ctrl/Cmd + End
        lines.append("  \"\(KeyCode.end.with(modifiers: [modifier]))\" = \"\(config.ctrlEndAction.selector)\";")
        
        // Ctrl/Cmd + Shift + Home
        lines.append("  \"\(KeyCode.home.with(modifiers: [modifier, .shift]))\" = \"\(config.ctrlShiftHomeAction.selector)\";")
        
        // Ctrl/Cmd + Shift + End
        lines.append("  \"\(KeyCode.end.with(modifiers: [modifier, .shift]))\" = \"\(config.ctrlShiftEndAction.selector)\";")
        
        lines.append("}")
        
        return lines.joined(separator: "\n") + "\n"
    }
    
    /// Apply configuration (with merge logic)
    public func applyConfiguration(_ config: KeyBindingConfiguration, merge: Bool = true) throws {
        // Create backup first
        if keyBindingFileExists() {
            try createBackup()
        }
        
        var finalDict: [String: Any]
        
        if merge && keyBindingFileExists() {
            // Merge with existing bindings
            var existing = try readCurrentKeyBindings()
            let newBindings = try parseKeyBindingDict(generateKeyBindingDictContent(config: config))
            
            // Merge: new bindings override existing for Home/End keys only
            for (key, value) in newBindings {
                existing[key] = value
            }
            finalDict = existing
        } else {
            // Just use new configuration
            finalDict = try parseKeyBindingDict(generateKeyBindingDictContent(config: config))
        }
        
        // Write to file
        try writeKeyBindingDict(finalDict)
    }
    
    /// Restore from backup
    public func restoreFromBackup(_ backupURL: URL) throws {
        guard fileManager.fileExists(atPath: backupURL.path) else {
            throw KeyBindingError.fileNotFound
        }
        
        try fileManager.copyItem(at: backupURL, to: keyBindingsPath)
    }
    
    /// List available backups
    public func listBackups() throws -> [URL] {
        guard fileManager.fileExists(atPath: backupDirectory.path) else {
            return []
        }
        
        let contents = try fileManager.contentsOfDirectory(
            at: backupDirectory,
            includingPropertiesForKeys: [.creationDateKey],
            options: .skipsHiddenFiles
        )
        
        return contents
            .filter { $0.lastPathComponent.hasPrefix("DefaultKeyBinding.dict.backup.") }
            .sorted { url1, url2 in
                let date1 = try? url1.resourceValues(forKeys: [.creationDateKey]).creationDate
                let date2 = try? url2.resourceValues(forKeys: [.creationDateKey]).creationDate
                return (date1 ?? Date.distantPast) > (date2 ?? Date.distantPast)
            }
    }
    
    // MARK: - Private Helpers
    
    private func calculateHash(of url: URL) throws -> String {
        let data = try Data(contentsOf: url)
        let hash = CryptoKit.SHA256.hash(data: data)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    private func parseKeyBindingDict(_ content: String) throws -> [String: Any] {
        guard let data = content.data(using: .utf8),
              let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any] else {
            throw KeyBindingError.invalidFileFormat
        }
        return plist
    }
    
    private func writeKeyBindingDict(_ dict: [String: Any]) throws {
        let keyBindingsDir = keyBindingsPath.deletingLastPathComponent()
        try? fileManager.createDirectory(at: keyBindingsDir, withIntermediateDirectories: true)
        
        let data = try PropertyListSerialization.data(
            fromPropertyList: dict,
            format: .xml,
            options: 0
        )
        
        try data.write(to: keyBindingsPath, options: .atomic)
    }
    
    private func saveMetadata(_ metadata: BackupMetadata, for backupURL: URL) throws {
        let metadataURL = backupURL.appendingPathExtension("json")
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        
        let data = try encoder.encode(metadata)
        try data.write(to: metadataURL)
    }
    
    private func cleanOldBackups(keeping count: Int) throws {
        let backups = try listBackups()
        guard backups.count > count else { return }
        
        for backup in backups.dropFirst(count) {
            try? fileManager.removeItem(at: backup)
            // Also remove metadata
            let metadataURL = backup.appendingPathExtension("json")
            try? fileManager.removeItem(at: metadataURL)
        }
    }
}

// MARK: - Supporting Types

public struct BackupMetadata: Codable {
    public let timestamp: Date
    public let originalHash: String
    public let appVersion: String
    public let backupPath: String
    public let originalPath: String
}
