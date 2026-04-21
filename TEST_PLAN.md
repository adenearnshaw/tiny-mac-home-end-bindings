# Test Plan - DefaultKeyBinding.dict Validation

**Version**: 1.0  
**Date**: 2026-04-21  
**Tester**: _______  
**macOS Version**: _______

---

## Pre-Test Setup

- [ ] Backup created: `~/Library/KeyBindings/DefaultKeyBinding.dict.backup-research-YYYYMMDD-HHMMSS`
- [ ] Backup verified with `plutil -lint`
- [ ] Test document created (see below)
- [ ] All test applications installed

---

## Test Document Content

Create a new text document with the following content for testing:

```
Line 1: The quick brown fox
Line 2: jumps over the lazy dog
Line 3: when testing Home and End keys

Paragraph 2, Line 1: This is a second paragraph
Paragraph 2, Line 2: with multiple lines in it
Paragraph 2, Line 3: to test paragraph vs line behavior

Single line with no line break after
```

**Save As**: `home-end-test.txt`

---

## Test Configuration A: LINE-based (Windows-like)

### Config File Content:
```
{
  "\UF729"   = "moveToBeginningOfLine:";
  "\UF72B"   = "moveToEndOfLine:";
  "$\UF729"  = "moveToBeginningOfLineAndModifySelection:";
  "$\UF72B"  = "moveToEndOfLineAndModifySelection:";
  "^\UF729"  = "moveToBeginningOfDocument:";
  "^\UF72B"  = "moveToEndOfDocument:";
  "^$\UF729" = "moveToBeginningOfDocumentAndModifySelection:";
  "^$\UF72B" = "moveToEndOfDocumentAndModifySelection:";
}
```

---

## Test Configuration B: PARAGRAPH-based (Current User Config)

### Config File Content:
```
{
  "\UF729"   = "moveToBeginningOfParagraph:";
  "\UF72B"   = "moveToEndOfParagraph:";
  "$\UF729"  = "moveToBeginningOfParagraphAndModifySelection:";
  "$\UF72B"  = "moveToEndOfParagraphAndModifySelection:";
  "^\UF729"  = "moveToBeginningOfDocument:";
  "^\UF72B"  = "moveToEndOfDocument:";
  "^$\UF729" = "moveToBeginningOfDocumentAndModifySelection:";
  "^$\UF72B" = "moveToEndOfDocumentAndModifySelection:";
}
```

---

## Application Test Matrix

For each application, test BOTH Configuration A and Configuration B.

---

## 1. TextEdit (Native Cocoa App)

### Test Setup
- [ ] Open TextEdit
- [ ] Create new document
- [ ] Paste test content
- [ ] Close and restart TextEdit after changing config

### Configuration A (Line-based) Tests

| Test # | Action | Starting Position | Expected Result | Actual Result | Pass/Fail |
|--------|--------|-------------------|-----------------|---------------|-----------|
| 1.1 | Press `Home` | Middle of Line 1 | Cursor at start of Line 1 | | ☐ |
| 1.2 | Press `End` | Middle of Line 1 | Cursor at end of Line 1 | | ☐ |
| 1.3 | Press `Shift+Home` | Middle of Line 2 | Select from cursor to start of Line 2 | | ☐ |
| 1.4 | Press `Shift+End` | Middle of Line 2 | Select from cursor to end of Line 2 | | ☐ |
| 1.5 | Press `Ctrl+Home` | Middle of document | Cursor at start of document | | ☐ |
| 1.6 | Press `Ctrl+End` | Middle of document | Cursor at end of document | | ☐ |
| 1.7 | Press `Ctrl+Shift+Home` | Middle of document | Select from cursor to start of document | | ☐ |
| 1.8 | Press `Ctrl+Shift+End` | Middle of document | Select from cursor to end of document | | ☐ |

**Requires App Restart**: ☐ Yes ☐ No  
**Notes**: _______________________________________

### Configuration B (Paragraph-based) Tests

| Test # | Action | Starting Position | Expected Result | Actual Result | Pass/Fail |
|--------|--------|-------------------|-----------------|---------------|-----------|
| 1.9 | Press `Home` | Middle of P2, Line 2 | Cursor at start of P2, Line 1 | | ☐ |
| 1.10 | Press `End` | Middle of P2, Line 1 | Cursor at end of P2, Line 3 | | ☐ |

**Notes**: _______________________________________

---

## 2. Safari (WebKit - Text Areas)

### Test Setup
- [ ] Open Safari
- [ ] Navigate to: `data:text/html,<textarea style="width:100%;height:300px;font-size:16px"></textarea>`
- [ ] Paste test content into textarea
- [ ] Close and restart Safari after changing config

### Configuration A (Line-based) Tests

| Test # | Action | Starting Position | Expected Result | Actual Result | Pass/Fail |
|--------|--------|-------------------|-----------------|---------------|-----------|
| 2.1 | Press `Home` | Middle of Line 1 | Cursor at start of Line 1 | | ☐ |
| 2.2 | Press `End` | Middle of Line 1 | Cursor at end of Line 1 | | ☐ |
| 2.3 | Press `Shift+Home` | Middle of Line 2 | Select from cursor to start of Line 2 | | ☐ |
| 2.4 | Press `Shift+End` | Middle of Line 2 | Select from cursor to end of Line 2 | | ☐ |
| 2.5 | Press `Ctrl+Home` | Middle of document | Cursor at start of document | | ☐ |
| 2.6 | Press `Ctrl+End` | Middle of document | Cursor at end of document | | ☐ |

**Requires App Restart**: ☐ Yes ☐ No  
**Web Refresh Required**: ☐ Yes ☐ No  
**Notes**: _______________________________________

---

## 3. Terminal.app

### Test Setup
- [ ] Open Terminal
- [ ] Create test file: `nano ~/home-end-test.txt`
- [ ] Paste test content
- [ ] Close and restart Terminal after changing config

### Configuration A (Line-based) Tests

| Test # | Action | Starting Position | Expected Result | Actual Result | Pass/Fail |
|--------|--------|-------------------|-----------------|---------------|-----------|
| 3.1 | Press `Home` | Middle of Line 1 | Cursor at start of Line 1 | | ☐ |
| 3.2 | Press `End` | Middle of Line 1 | Cursor at end of Line 1 | | ☐ |

**Requires App Restart**: ☐ Yes ☐ No  
**Notes**: Terminal may use shell's key bindings instead  
**Works with nano**: ☐ Yes ☐ No  
**Works with vim**: ☐ Yes ☐ No  
**Works at shell prompt**: ☐ Yes ☐ No

---

## 4. Notes.app

### Test Setup
- [ ] Open Notes
- [ ] Create new note
- [ ] Paste test content
- [ ] Close and restart Notes after changing config

### Configuration A (Line-based) Tests

| Test # | Action | Starting Position | Expected Result | Actual Result | Pass/Fail |
|--------|--------|-------------------|-----------------|---------------|-----------|
| 4.1 | Press `Home` | Middle of Line 1 | Cursor at start of Line 1 | | ☐ |
| 4.2 | Press `End` | Middle of Line 1 | Cursor at end of Line 1 | | ☐ |
| 4.3 | Press `Shift+Home` | Middle of Line 2 | Select from cursor to start of Line 2 | | ☐ |
| 4.4 | Press `Shift+End` | Middle of Line 2 | Select from cursor to end of Line 2 | | ☐ |
| 4.5 | Press `Ctrl+Home` | Middle of note | Cursor at start of note | | ☐ |
| 4.6 | Press `Ctrl+End` | Middle of note | Cursor at end of note | | ☐ |

**Requires App Restart**: ☐ Yes ☐ No  
**Notes**: _______________________________________

---

## 5. Mail.app

### Test Setup
- [ ] Open Mail
- [ ] Click "New Message"
- [ ] Paste test content in message body
- [ ] Close and restart Mail after changing config

### Configuration A (Line-based) Tests

| Test # | Action | Starting Position | Expected Result | Actual Result | Pass/Fail |
|--------|--------|-------------------|-----------------|---------------|-----------|
| 5.1 | Press `Home` | Middle of Line 1 | Cursor at start of Line 1 | | ☐ |
| 5.2 | Press `End` | Middle of Line 1 | Cursor at end of Line 1 | | ☐ |
| 5.3 | Press `Shift+Home` | Middle of Line 2 | Select from cursor to start of Line 2 | | ☐ |
| 5.4 | Press `Shift+End` | Middle of Line 2 | Select from cursor to end of Line 2 | | ☐ |

**Requires App Restart**: ☐ Yes ☐ No  
**Notes**: _______________________________________

---

## 6. VS Code (Electron App)

### Test Setup
- [ ] Open VS Code
- [ ] Create new file
- [ ] Paste test content
- [ ] Close and restart VS Code after changing config

### Configuration A (Line-based) Tests

| Test # | Action | Starting Position | Expected Result | Actual Result | Pass/Fail |
|--------|--------|-------------------|-----------------|---------------|-----------|
| 6.1 | Press `Home` | Middle of Line 1 | Cursor at start of Line 1 | | ☐ |
| 6.2 | Press `End` | Middle of Line 1 | Cursor at end of Line 1 | | ☐ |
| 6.3 | Press `Shift+Home` | Middle of Line 2 | Select from cursor to start of Line 2 | | ☐ |
| 6.4 | Press `Shift+End` | Middle of Line 2 | Select from cursor to end of Line 2 | | ☐ |
| 6.5 | Press `Ctrl+Home` | Middle of file | Cursor at start of file | | ☐ |
| 6.6 | Press `Ctrl+End` | Middle of file | Cursor at end of file | | ☐ |

**Requires App Restart**: ☐ Yes ☐ No  
**Respects DefaultKeyBinding.dict**: ☐ Yes ☐ No  
**Notes**: Electron apps often ignore system key bindings  
**VS Code Keybinding Override Needed**: ☐ Yes ☐ No

---

## 7. Additional Applications (Optional)

### Chrome Browser (Text Areas)

**Status**: ☐ Tested ☐ Skipped  
**Respects DefaultKeyBinding.dict**: ☐ Yes ☐ No  
**Notes**: _______________________________________

### Slack (Electron App)

**Status**: ☐ Tested ☐ Skipped  
**Respects DefaultKeyBinding.dict**: ☐ Yes ☐ No  
**Notes**: _______________________________________

### Other: _________________

**Status**: ☐ Tested ☐ Skipped  
**Respects DefaultKeyBinding.dict**: ☐ Yes ☐ No  
**Notes**: _______________________________________

---

## Summary Results

### Apps That Work Without Restart
- ☐ TextEdit
- ☐ Safari
- ☐ Terminal
- ☐ Notes
- ☐ Mail
- ☐ VS Code
- ☐ Other: _______

### Apps That Require Restart
- ☐ TextEdit
- ☐ Safari
- ☐ Terminal
- ☐ Notes
- ☐ Mail
- ☐ VS Code
- ☐ Other: _______

### Apps That Don't Work At All
- ☐ TextEdit
- ☐ Safari
- ☐ Terminal
- ☐ Notes
- ☐ Mail
- ☐ VS Code
- ☐ Other: _______

---

## Configuration Preference

Based on testing, which configuration feels more natural?

- ☐ Configuration A (Line-based) - matches Windows behavior exactly
- ☐ Configuration B (Paragraph-based) - jumps entire paragraphs
- ☐ Both - let user choose in app settings

**Reasoning**: _______________________________________

---

## Additional Findings

### Edge Cases Discovered
1. _______________________________________
2. _______________________________________
3. _______________________________________

### Unexpected Behaviors
1. _______________________________________
2. _______________________________________
3. _______________________________________

### Compatibility Issues
1. _______________________________________
2. _______________________________________
3. _______________________________________

---

## Recommendations

### Primary Approach
☐ Proceed with DefaultKeyBinding.dict approach  
☐ Consider Accessibility API approach instead  
☐ Hybrid approach (DefaultKeyBinding.dict + per-app instructions)

**Reasoning**: _______________________________________

### Default Configuration
☐ Line-based (Windows-like)  
☐ Paragraph-based (current behavior)  
☐ User choice on first launch

**Reasoning**: _______________________________________

### App-Specific Workarounds Needed
- [ ] Document VS Code keybinding override
- [ ] Document Terminal shell configuration
- [ ] Document other: _______

---

## Test Completion

**Date Completed**: _______  
**Total Time**: _______ hours  
**Pass Rate**: _______% 
**Overall Assessment**: _______________________________________

**Ready to Proceed to Phase 1**: ☐ Yes ☐ No (see blockers below)

**Blockers**:
1. _______________________________________
2. _______________________________________

---

## Appendix A: Quick Test Commands

### Apply Configuration A (Line-based)
```bash
cat > ~/Library/KeyBindings/DefaultKeyBinding.dict << 'EOF'
{
  "\UF729"   = "moveToBeginningOfLine:";
  "\UF72B"   = "moveToEndOfLine:";
  "$\UF729"  = "moveToBeginningOfLineAndModifySelection:";
  "$\UF72B"  = "moveToEndOfLineAndModifySelection:";
  "^\UF729"  = "moveToBeginningOfDocument:";
  "^\UF72B"  = "moveToEndOfDocument:";
  "^$\UF729" = "moveToBeginningOfDocumentAndModifySelection:";
  "^$\UF72B" = "moveToEndOfDocumentAndModifySelection:";
}
EOF
plutil -lint ~/Library/KeyBindings/DefaultKeyBinding.dict
```

### Apply Configuration B (Paragraph-based)
```bash
cat > ~/Library/KeyBindings/DefaultKeyBinding.dict << 'EOF'
{
  "\UF729"   = "moveToBeginningOfParagraph:";
  "\UF72B"   = "moveToEndOfParagraph:";
  "$\UF729"  = "moveToBeginningOfParagraphAndModifySelection:";
  "$\UF72B"  = "moveToEndOfParagraphAndModifySelection:";
  "^\UF729"  = "moveToBeginningOfDocument:";
  "^\UF72B"  = "moveToEndOfDocument:";
  "^$\UF729" = "moveToBeginningOfDocumentAndModifySelection:";
  "^$\UF72B" = "moveToEndOfDocumentAndModifySelection:";
}
EOF
plutil -lint ~/Library/KeyBindings/DefaultKeyBinding.dict
```

### Restore Original Backup
```bash
# Find latest backup
ls -t ~/Library/KeyBindings/DefaultKeyBinding.dict.backup-* | head -1

# Restore (replace with actual backup filename)
cp ~/Library/KeyBindings/DefaultKeyBinding.dict.backup-YYYYMMDD-HHMMSS ~/Library/KeyBindings/DefaultKeyBinding.dict
```
