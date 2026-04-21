import Foundation

/// Configuration for Home/End key bindings
public struct KeyBindingConfiguration: Codable, Equatable {
    public let homeAction: KeyAction
    public let endAction: KeyAction
    public let shiftHomeAction: KeyAction
    public let shiftEndAction: KeyAction
    public let ctrlHomeAction: KeyAction
    public let ctrlEndAction: KeyAction
    public let ctrlShiftHomeAction: KeyAction
    public let ctrlShiftEndAction: KeyAction
    public let useCommandModifier: Bool
    
    public init(
        homeAction: KeyAction = .moveToBeginningOfLine,
        endAction: KeyAction = .moveToEndOfLine,
        shiftHomeAction: KeyAction = .moveToBeginningOfLineAndModifySelection,
        shiftEndAction: KeyAction = .moveToEndOfLineAndModifySelection,
        ctrlHomeAction: KeyAction = .moveToBeginningOfDocument,
        ctrlEndAction: KeyAction = .moveToEndOfDocument,
        ctrlShiftHomeAction: KeyAction = .moveToBeginningOfDocumentAndModifySelection,
        ctrlShiftEndAction: KeyAction = .moveToEndOfDocumentAndModifySelection,
        useCommandModifier: Bool = false
    ) {
        self.homeAction = homeAction
        self.endAction = endAction
        self.shiftHomeAction = shiftHomeAction
        self.shiftEndAction = shiftEndAction
        self.ctrlHomeAction = ctrlHomeAction
        self.ctrlEndAction = ctrlEndAction
        self.ctrlShiftHomeAction = ctrlShiftHomeAction
        self.ctrlShiftEndAction = ctrlShiftEndAction
        self.useCommandModifier = useCommandModifier
    }
    
    /// Windows-like default configuration (line-based)
    public static var windowsLike: KeyBindingConfiguration {
        KeyBindingConfiguration()
    }
    
    /// Paragraph-based configuration (macOS traditional)
    public static var paragraphBased: KeyBindingConfiguration {
        KeyBindingConfiguration(
            homeAction: .moveToBeginningOfParagraph,
            endAction: .moveToEndOfParagraph,
            shiftHomeAction: .moveToBeginningOfParagraphAndModifySelection,
            shiftEndAction: .moveToEndOfParagraphAndModifySelection
        )
    }
}

/// Available key actions for macOS text system
public enum KeyAction: String, Codable {
    // Line-based actions
    case moveToBeginningOfLine
    case moveToEndOfLine
    case moveToBeginningOfLineAndModifySelection
    case moveToEndOfLineAndModifySelection
    
    // Paragraph-based actions
    case moveToBeginningOfParagraph
    case moveToEndOfParagraph
    case moveToBeginningOfParagraphAndModifySelection
    case moveToEndOfParagraphAndModifySelection
    
    // Document-based actions
    case moveToBeginningOfDocument
    case moveToEndOfDocument
    case moveToBeginningOfDocumentAndModifySelection
    case moveToEndOfDocumentAndModifySelection
    
    /// The selector string for the key action (with trailing colon)
    public var selector: String {
        "\(self.rawValue):"
    }
}

/// Key codes for Home/End keys
public enum KeyCode: String {
    case home = "\\UF729"
    case end = "\\UF72B"
    
    /// Generate key combination string with modifiers
    public func with(modifiers: Set<KeyModifier>) -> String {
        var result = ""
        let sortedModifiers = modifiers.sorted { $0.rawValue < $1.rawValue }
        for modifier in sortedModifiers {
            result += modifier.rawValue
        }
        result += self.rawValue
        return result
    }
}

/// Key modifiers
public enum KeyModifier: String, Comparable {
    case shift = "$"
    case control = "^"
    case option = "~"
    case command = "@"
    
    public static func < (lhs: KeyModifier, rhs: KeyModifier) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
