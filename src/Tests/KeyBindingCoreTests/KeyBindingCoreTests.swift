import Testing
@testable import KeyBindingCore

@Test("KeyBindingConfiguration Windows-like default")
func testWindowsLikeConfiguration() {
    let config = KeyBindingConfiguration.windowsLike
    
    #expect(config.homeAction == .moveToBeginningOfLine)
    #expect(config.endAction == .moveToEndOfLine)
    #expect(config.shiftHomeAction == .moveToBeginningOfLineAndModifySelection)
    #expect(config.shiftEndAction == .moveToEndOfLineAndModifySelection)
    #expect(config.ctrlHomeAction == .moveToBeginningOfDocument)
    #expect(config.ctrlEndAction == .moveToEndOfDocument)
    #expect(config.useCommandModifier == false)
}

@Test("KeyBindingConfiguration paragraph-based")
func testParagraphBasedConfiguration() {
    let config = KeyBindingConfiguration.paragraphBased
    
    #expect(config.homeAction == .moveToBeginningOfParagraph)
    #expect(config.endAction == .moveToEndOfParagraph)
    #expect(config.shiftHomeAction == .moveToBeginningOfParagraphAndModifySelection)
    #expect(config.shiftEndAction == .moveToEndOfParagraphAndModifySelection)
}

@Test("KeyAction selectors have trailing colon")
func testKeyActionSelectors() {
    #expect(KeyAction.moveToBeginningOfLine.selector == "moveToBeginningOfLine:")
    #expect(KeyAction.moveToEndOfLine.selector == "moveToEndOfLine:")
    #expect(KeyAction.moveToBeginningOfDocument.selector == "moveToBeginningOfDocument:")
}

@Test("KeyCode modifier combinations")
func testKeyCodeModifiers() {
    #expect(KeyCode.home.with(modifiers: []) == "\\UF729")
    #expect(KeyCode.home.with(modifiers: [.shift]) == "$\\UF729")
    #expect(KeyCode.home.with(modifiers: [.control]) == "^\\UF729")
    #expect(KeyCode.home.with(modifiers: [.control, .shift]) == "$^\\UF729")
}

@Test("KeyBindingService generates correct content")
func testGenerateKeyBindingContent() {
    let service = KeyBindingService()
    let config = KeyBindingConfiguration.windowsLike
    
    let content = service.generateKeyBindingDictContent(config: config)
    
    #expect(content.contains("\\UF729"))
    #expect(content.contains("\\UF72B"))
    #expect(content.contains("moveToBeginningOfLine:"))
    #expect(content.contains("moveToEndOfLine:"))
    #expect(content.contains("moveToBeginningOfDocument:"))
    #expect(content.contains("moveToEndOfDocument:"))
}

@Test("KeyBindingService generates with Cmd modifier")
func testGenerateKeyBindingContentWithCmd() {
    let service = KeyBindingService()
    var config = KeyBindingConfiguration.windowsLike
    config = KeyBindingConfiguration(
        homeAction: config.homeAction,
        endAction: config.endAction,
        shiftHomeAction: config.shiftHomeAction,
        shiftEndAction: config.shiftEndAction,
        ctrlHomeAction: config.ctrlHomeAction,
        ctrlEndAction: config.ctrlEndAction,
        ctrlShiftHomeAction: config.ctrlShiftHomeAction,
        ctrlShiftEndAction: config.ctrlShiftEndAction,
        useCommandModifier: true
    )
    
    let content = service.generateKeyBindingDictContent(config: config)
    
    // Should use @ (command) instead of ^ (control)
    #expect(content.contains("@\\UF729"))
    #expect(content.contains("@\\UF72B"))
}
