# Phase 0: Research & Validation

**Date Started**: 2026-04-21  
**Status**: In Progress

---

## Executive Summary

This document tracks research findings for implementing Windows-like Home/End key behavior on macOS using the `DefaultKeyBinding.dict` approach.

---

## 1. Technical Approach: DefaultKeyBinding.dict

### 1.1 Current Status

**Existing File Found**: ✅  
**Location**: `~/Library/KeyBindings/DefaultKeyBinding.dict`

**Current Contents**:
```
{
  "\UF729"  = moveToBeginningOfParagraph:; // home
  "\UF72B"  = moveToEndOfParagraph:; // end
  "$\UF729" = moveToBeginningOfParagraphAndModifySelection:; // shift-home
  "$\UF72B" = moveToEndOfParagraphAndModifySelection:; // shift-end
  "^\UF729" = moveToBeginningOfDocument:; // ctrl-home
  "^\UF72B" = moveToEndOfDocument:; // ctrl-end
  "^$\UF729" = moveToBeginningOfDocumentAndModifySelection:; // ctrl-shift-home
  "^$\UF72B" = moveToEndOfDocumentAndModifySelection:; // ctrl-shift-end
}
```

**Observation**: This maps to *paragraph* beginning/end instead of *line* beginning/end for basic Home/End. Need to verify if this is intentional or should be changed to line-based.

### 1.2 Key Code Mappings

| Key Combination | Unicode Code | Selector (Line-based) | Selector (Paragraph-based) |
|----------------|--------------|----------------------|---------------------------|
| Home | `\UF729` | `moveToBeginningOfLine:` | `moveToBeginningOfParagraph:` |
| End | `\UF72B` | `moveToEndOfLine:` | `moveToEndOfParagraph:` |
| Shift+Home | `$\UF729` | `moveToBeginningOfLineAndModifySelection:` | `moveToBeginningOfParagraphAndModifySelection:` |
| Shift+End | `$\UF72B` | `moveToEndOfLineAndModifySelection:` | `moveToEndOfParagraphAndModifySelection:` |
| Ctrl+Home | `^\UF729` | `moveToBeginningOfDocument:` | Same |
| Ctrl+End | `^\UF72B` | `moveToEndOfDocument:` | Same |
| Ctrl+Shift+Home | `^$\UF729` | `moveToBeginningOfDocumentAndModifySelection:` | Same |
| Ctrl+Shift+End | `^$\UF72B` | `moveToEndOfDocumentAndModifySelection:` | Same |

**Modifier Key Codes**:
- `$` = Shift
- `^` = Control
- `~` = Option/Alt
- `@` = Command

### 1.3 Windows Behavior Reference

On Windows 11:
- **Home**: Move to beginning of current line
- **End**: Move to end of current line
- **Shift+Home**: Select from cursor to beginning of line
- **Shift+End**: Select from cursor to end of line
- **Ctrl+Home**: Move to beginning of document
- **Ctrl+End**: Move to end of document
- **Ctrl+Shift+Home**: Select from cursor to beginning of document
- **Ctrl+Shift+End**: Select from cursor to end of document

### 1.4 Recommended DefaultKeyBinding.dict for Windows-like Behavior

```
{
  /* Windows-like Home/End key behavior */
  "\UF729"   = "moveToBeginningOfLine:";                   /* Home */
  "\UF72B"   = "moveToEndOfLine:";                         /* End */
  "$\UF729"  = "moveToBeginningOfLineAndModifySelection:"; /* Shift+Home */
  "$\UF72B"  = "moveToEndOfLineAndModifySelection:";       /* Shift+End */
  "^\UF729"  = "moveToBeginningOfDocument:";               /* Ctrl+Home */
  "^\UF72B"  = "moveToEndOfDocument:";                     /* Ctrl+End */
  "^$\UF729" = "moveToBeginningOfDocumentAndModifySelection:"; /* Ctrl+Shift+Home */
  "^$\UF72B" = "moveToEndOfDocumentAndModifySelection:";       /* Ctrl+Shift+End */
}
```

**Key Difference**: Using `Line` instead of `Paragraph` for basic Home/End keys.

---

## 2. Application Testing

### 2.1 Test Plan

**Test Applications**:
- [ ] TextEdit (native Cocoa)
- [ ] Safari (WebKit text fields)
- [ ] Terminal.app
- [ ] Notes.app
- [ ] Mail.app
- [ ] VS Code (Electron)
- [ ] Chrome (if available)
- [ ] Slack (if available)

**Test Scenarios** (for each app):
1. Basic Home/End (line navigation)
2. Shift+Home/End (line selection)
3. Ctrl+Home/End (document navigation)
4. Ctrl+Shift+Home/End (document selection)
5. Multi-line text behavior
6. Empty line behavior
7. Restart requirement (does it hot-reload?)

### 2.2 Testing Methodology

**Setup**:
1. Create backup of current DefaultKeyBinding.dict
2. Apply Windows-like configuration
3. Test with existing running apps (no restart)
4. Restart apps and test again
5. Document which apps require restart

**Test Document Template**:
```
Line 1: The quick brown fox
Line 2: jumps over
Line 3: the lazy dog

Paragraph 1, line 1
Paragraph 1, line 2

Paragraph 2, line 1
```

---

## 3. Test Results

### 3.1 TextEdit

**Status**: ⏳ Pending  
**Requires Restart**: TBD  
**Home/End Behavior**: TBD  
**Shift+Home/End Behavior**: TBD  
**Ctrl+Home/End Behavior**: TBD  
**Notes**: 

---

### 3.2 Safari (Text Fields)

**Status**: ⏳ Pending  
**Requires Restart**: TBD  
**Home/End Behavior**: TBD  
**Notes**: 

---

### 3.3 Terminal.app

**Status**: ⏳ Pending  
**Requires Restart**: TBD  
**Home/End Behavior**: TBD  
**Notes**: Terminal may have its own keybindings that override system defaults

---

### 3.4 VS Code (Electron)

**Status**: ⏳ Pending  
**Requires Restart**: TBD  
**Home/End Behavior**: TBD  
**Notes**: Electron apps may not respect DefaultKeyBinding.dict

---

### 3.5 Notes.app

**Status**: ⏳ Pending  
**Requires Restart**: TBD  
**Home/End Behavior**: TBD  
**Notes**: 

---

### 3.6 Mail.app

**Status**: ⏳ Pending  
**Requires Restart**: TBD  
**Home/End Behavior**: TBD  
**Notes**: 

---

## 4. Known Limitations

### 4.1 Applications That Don't Respect DefaultKeyBinding.dict

**Confirmed**:
- TBD

**Likely Issues**:
- Electron-based apps (VS Code, Slack, Discord) - they use Chromium's text handling
- Cross-platform apps with custom text engines
- Terminal emulators with their own keybinding systems
- Some Java-based applications

**Workarounds**:
- Document per-app keybinding configurations
- Recommend Karabiner-Elements for global key remapping as alternative

---

## 5. Alternative Approaches Considered

### 5.1 CGEventTap (Accessibility API)

**Pros**:
- System-wide key interception (works with all apps)
- No app restart required
- More reliable

**Cons**:
- Requires Accessibility permissions (more invasive)
- More complex implementation
- Higher security scrutiny from Apple
- Need to handle security prompts

**Recommendation**: Keep as v2.0 option if DefaultKeyBinding.dict proves too limited

---

### 5.2 Karabiner-Elements Integration

**Pros**:
- Already popular and trusted
- Very powerful
- Works everywhere

**Cons**:
- External dependency
- Kernel extension (Complex Elements needs system extensions)
- Overkill for simple Home/End remapping

**Recommendation**: Suggest as alternative in docs, not as primary solution

---

## 6. Backup Strategy Validation

### 6.1 File Format Analysis

**Format**: Property List (plist) in old-style text format  
**Encoding**: UTF-8  
**Validation**: Can be parsed with `plutil`

```bash
plutil -lint ~/Library/KeyBindings/DefaultKeyBinding.dict
```

**✅ VALIDATED**: Current file passes `plutil -lint` successfully  
**File Hash (SHA-256)**: `1311540a8e25e75ac15bceb0a5fc0583cbec1c9faa09d1ed512781a5f422a4d7`

### 6.2 Backup Approach

**Location**: `~/Library/Application Support/com.a10w.tinymackeybindings/backups/`

**Naming Convention**: `DefaultKeyBinding.dict.backup.YYYY-MM-DD-HH-MM-SS`

**Metadata File**: JSON file alongside backup with:
```json
{
  "timestamp": "2026-04-21T21:52:00Z",
  "originalHash": "sha256:1311540a8e25e75ac15bceb0a5fc0583cbec1c9faa09d1ed512781a5f422a4d7",
  "appVersion": "1.0.0",
  "backupPath": "~/Library/Application Support/com.a10w.tinymackeybindings/backups/DefaultKeyBinding.dict.backup.2026-04-21-21-52-00",
  "originalPath": "~/Library/KeyBindings/DefaultKeyBinding.dict"
}
```

**✅ VALIDATED**: 
- Backup creation works
- File permissions are correct (writable)
- Hash calculation works
- Directory structure can be created

### 6.3 Merge Strategy

**Approach**: Parse existing dict, merge only Home/End key codes, preserve everything else

**Example**: If user has custom bindings like `^w = deleteWordBackward:`, those should be preserved.

**Conflict Resolution**: If Home/End keys already exist, backup shows diff to user before overwriting

**✅ VALIDATED**: 
- Can read and validate multiple dict files
- Merge logic implementation needed in Swift (property list parsing)

---

## 7. Questions & Decisions

### 7.1 Line vs Paragraph Behavior

**Question**: Should basic Home/End go to line or paragraph boundaries?

**Windows Behavior**: Line boundaries  
**Current User Config**: Paragraph boundaries  
**Blog Post Recommendation**: Line boundaries

**Decision**: ⏳ Test both behaviors and let user choose in settings

---

### 7.2 Cmd vs Ctrl for Document Navigation

**Question**: Should we offer Cmd+Home/End as alternative to Ctrl+Home/End?

**Reasoning**: Some apps use Cmd as primary modifier on macOS

**Decision**: ⏳ Yes, add as optional setting (choose Ctrl or Cmd)

---

## 8. Next Steps

- [x] Backup existing DefaultKeyBinding.dict
- [x] Create test version with Line-based behavior
- [x] Applied line-based configuration for testing
- [x] Created test document
- [ ] Test on all applications in test plan (MANUAL TESTING REQUIRED)
- [ ] Document which apps require restart
- [ ] Document which apps don't work at all
- [ ] Validate backup/restore process
- [x] Create TEST_PLAN.md with detailed checklist
- [x] Decide: Line vs Paragraph default → **DECISION: Line-based (Windows-like) as default**
- [x] Decide: Include Cmd modifier option → **DECISION: Yes, as optional setting**

### Decision Rationale

**Line-based as default:**
- Matches Windows behavior (project goal)
- Blog post recommendation
- More intuitive for line-by-line editing
- Paragraph-based can be optional advanced setting

**Cmd modifier support:**
- Some apps work better with Cmd than Ctrl
- Let user choose in settings
- Increase compatibility

---

## 9. References

- [Original Blog Post](https://randomcoding.com/blog/2023-10-03-rebinding-the-home-and-end-keys-in-a-mac-to-work-like-they-do-in-windows-linux/)
- [Apple Developer: Cocoa Text System](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/EventOverview/TextDefaultsBindings/TextDefaultsBindings.html)
- [macOS Text System Key Bindings](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/EventOverview/TextDefaultsBindings/TextDefaultsBindings.html)

---

**Last Updated**: 2026-04-21  
**Next Review**: After completing application testing
