# Tiny Mac Home/End Bindings - Project Plan

## Project Overview
A native macOS menu bar application that applies Windows-like behavior for Home and End keys (with modifier support) across all applications. The app manages the `~/Library/KeyBindings/DefaultKeyBinding.dict` file to enable customizable key bindings.

## Technology Stack
- **App**: Swift + SwiftUI (native macOS)
- **Bundle ID**: `com.a10w.tinymackeybindings`
- **Website**: Svelte + Static Site Generator (hosted on GitHub Pages)
- **Distribution**: GitHub Releases (v1), Homebrew Cask (v1.1+)
- **Minimum macOS**: macOS 14.0 (Sonoma) and above
- **License**: MIT
- **Auto-updates**: Yes (using Sparkle framework)
- **Analytics**: None (no tracking to avoid GDPR concerns)

## Project Phases

---

## Phase 0: Research & Validation (Week 1)

### 0.1 Technical Validation
- [ ] **Research DefaultKeyBinding.dict approach**
  - Test the blog post solution manually on macOS 14+
  - Document which applications respect DefaultKeyBinding.dict
  - Identify any applications that don't honor it (e.g., Electron apps, some IDEs)
  - Test all Home/End combinations:
    - `Home` → beginning of line
    - `End` → end of line
    - `Shift+Home` → select to beginning of line
    - `Shift+End` → select to end of line
    - `Ctrl+Home` → beginning of document
    - `Ctrl+End` → end of document
    - `Shift+Ctrl+Home` → select to beginning of document
    - `Shift+Ctrl+End` → select to end of document
    - `Cmd+Home` → (document if Ctrl doesn't work in some apps)
    - `Cmd+End` → (document if Ctrl doesn't work in some apps)

- [ ] **Test app restart requirement**
  - Verify which applications need restart vs hot-reload
  - Document the restart process for common apps

- [ ] **Research alternative approaches (if DefaultKeyBinding.dict has limitations)**
  - Accessibility API (CGEventTap) for system-wide key interception
  - Pros/cons analysis
  - Permission requirements comparison

### 0.2 Create Test Plan
- [ ] Define test applications for validation:
  - TextEdit (native Cocoa)
  - Safari (WebKit)
  - VS Code (Electron)
  - Terminal.app
  - Notes.app
  - Mail.app
  - Chrome (if available)
  - Slack (if available)

- [ ] Create manual test checklist document
- [ ] Create automated test harness approach (if feasible)

**Deliverables:**
- `RESEARCH.md` - findings and recommendations
- `TEST_PLAN.md` - manual test checklist
- Decision on whether to proceed with DefaultKeyBinding.dict approach

---

## Phase 1: Core macOS Application (Week 2-3)

### 1.1 Project Setup
- [ ] Create Xcode project
  - App name: "Tiny Home/End"
  - Bundle identifier: `com.a10w.tinymackeybindings`
  - App icon design and creation
  - Code signing setup

- [ ] Setup project structure
  ```
  TinyHomeEnd/
  ├── App/
  │   ├── TinyHomeEndApp.swift
  │   └── AppDelegate.swift
  ├── Views/
  │   ├── MenuBarView.swift
  │   ├── SettingsView.swift
  │   └── AboutView.swift
  ├── Models/
  │   ├── KeyBindingConfiguration.swift
  │   └── AppSettings.swift
  ├── Services/
  │   ├── KeyBindingService.swift
  │   └── AppRestartService.swift
  ├── Resources/
  │   ├── Assets.xcassets
  │   └── DefaultKeyBinding.dict.template
  └── Tests/
      └── TinyHomeEndTests/
  ```

- [ ] Setup Git workflows
  - `.gitignore` for Xcode/Swift
  - Pre-commit hooks (SwiftLint)
  - CI/CD setup (GitHub Actions for builds)

### 1.2 Core Functionality
- [ ] **KeyBindingService implementation**
  - Read existing `~/Library/KeyBindings/DefaultKeyBinding.dict`
  - **CRITICAL: Create timestamped backup before ANY modifications** (e.g., `DefaultKeyBinding.dict.backup.2026-04-21-14-30-00`)
  - Store backup metadata (original file hash, timestamp, app version)
  - Write new DefaultKeyBinding.dict with merged user preferences
  - **Merge logic**: Preserve user's existing bindings, only add/modify Home/End related keys
  - Restore backup functionality (when app is disabled or uninstalled)
  - Validate dict file syntax before writing
  - Handle multiple backups (keep last 5 backups, clean old ones)
  - **Uninstall/Disable behavior**: Automatically restore original backup

- [ ] **Menu Bar Integration**
  - Create menu bar icon (hideable)
  - Menu structure:
    - Enable/Disable Home/End Bindings (toggle - restores backup when disabled)
    - Settings...
    - About
    - Check for Updates...
    - Quit
  - Show/hide menu bar icon preference
  - Launch at login option
  - Show notification when backup is created/restored

- [ ] **Settings Window (SwiftUI)**
  - Toggle switches for each binding combination:
    - Home → Beginning of Line
    - End → End of Line
    - Shift+Home → Select to Beginning of Line
    - Shift+End → Select to End of Line
    - Ctrl+Home → Beginning of Document
    - Ctrl+End → End of Document
    - Shift+Ctrl+Home → Select to Beginning of Document
    - Shift+Ctrl+End → Select to End of Document
  - Option to use Cmd instead of Ctrl (for some apps)
  - "Apply Changes" button with warning about app restarts
  - "Restore Original Keybindings" button (shows backup info if available)
  - "View Backups" section showing backup history with timestamps
  - Warning indicator if existing keybindings detected on first run

- [ ] **About Window**
  - App version
  - Brief description
  - Link to website
  - Link to GitHub repository
  - "Buy Me a Coffee" link (optional, for future)
  - Credits/Attribution
  - MIT License notice

### 1.3 App Lifecycle Management
- [ ] Launch at login functionality
- [ ] **Auto-update mechanism (Sparkle framework)**
  - Integrate Sparkle for automatic updates
  - Check for updates on launch (configurable frequency)
  - Manual "Check for Updates" menu item
  - Download and install updates in background
  - Generate appcast.xml for releases
- [ ] First-run experience:
  - Welcome message
  - Explain what the app does
  - **IMPORTANT: Warn if existing DefaultKeyBinding.dict found**
  - Explain backup strategy clearly
  - Request permission to modify KeyBindings
  - Show settings window on first launch
- [ ] **Uninstall helper**
  - Provide uninstall script or instructions
  - Automatically restore backup on uninstall
  - Clean up app support files

### 1.4 Testing
- [ ] Unit tests for KeyBindingService
  - Test backup creation
  - Test backup restoration
  - Test merge logic (preserving existing bindings)
  - Test edge cases (corrupted files, missing directories)
- [ ] Integration tests for file operations
- [ ] **Critical test**: Verify existing user bindings are preserved
- [ ] Manual testing with test plan from Phase 0
- [ ] Test on clean macOS installation
- [ ] Test backup/restore cycle multiple times

**Deliverables:**
- Working macOS app (.app bundle)
- Internal testing build

---

## Phase 2: UI Polish & User Experience (Week 4)

### 2.1 Design Refinement
- [ ] App icon finalization (multiple sizes for Retina)
- [ ] Menu bar icon (light/dark mode variants)
- [ ] Settings window UI/UX polish
- [ ] Animations and transitions
- [ ] Error message design (friendly, actionable)

### 2.2 User Feedback & Instructions
- [ ] In-app help/tooltips
- [ ] Notification when bindings applied
- [ ] Warning notifications:
  - Apps need restart to apply changes
  - **Existing DefaultKeyBinding.dict detected with preview of contents**
  - Backup created successfully with timestamp and location
  - Backup restored successfully
- [ ] "Test Your Bindings" in-app guide
- [ ] Clear messaging about backup safety: "Your original keybindings are safe"

### 2.3 Edge Cases & Error Handling
- [ ] Handle permission errors (file system access)
- [ ] Handle corrupted DefaultKeyBinding.dict files (keep backup, show error)
- [ ] Handle disk full scenarios (prevent data loss)
- [ ] Handle multiple instances of app running
- [ ] Handle macOS updates that might reset bindings
- [ ] **Handle case where backup file is deleted/corrupted**
- [ ] **Handle case where user manually edits DefaultKeyBinding.dict while app is running**
- [ ] **Prevent accidental data loss**: Always confirm before overwriting without backup

**Deliverables:**
- Polished app ready for beta testing

---

## Phase 3: Distribution Setup (Week 5)

### 3.1 Code Signing & Notarization
- [ ] Apple Developer account setup
- [ ] Create signing certificates
- [ ] Notarize the app with Apple
- [ ] Staple notarization ticket

### 3.2 Packaging
- [ ] Create .dmg installer with:
  - App icon
  - Background image
  - Drag-to-Applications instruction
  - Eject instruction
- [ ] Create zip archive (for direct download)
- [ ] Version numbering scheme (semantic versioning)

### 3.3 GitHub Release Process
- [ ] Create release workflow (GitHub Actions)
  - Build app
  - Sign and notarize
  - Create .dmg and .zip
  - Generate release notes
  - **Generate Sparkle appcast.xml with EdDSA signature**
  - Upload artifacts (including appcast.xml)
  - Tag release
- [ ] Setup release notes template
- [ ] Create CHANGELOG.md
- [ ] Document Sparkle appcast update process

### 3.4 Homebrew Preparation
- [ ] Document Homebrew cask requirements
- [ ] Create homebrew-tinytooltown tap structure (for future)
- [ ] Test installation process locally
- [ ] Create documentation for Homebrew installation

**Deliverables:**
- First GitHub Release (v1.0.0)
- Notarized and signed .dmg and .zip files
- Homebrew installation documentation (for future phase)

---

## Phase 4: Website (Week 6)

### 4.1 Website Setup
- [ ] Choose Svelte framework (SvelteKit recommended)
- [ ] Setup project structure
  ```
  website/
  ├── src/
  │   ├── routes/
  │   │   ├── +page.svelte (home)
  │   │   ├── download/
  │   │   ├── docs/
  │   │   └── support/
  │   ├── lib/
  │   │   ├── components/
  │   │   │   ├── Header.svelte
  │   │   │   ├── Footer.svelte
  │   │   │   ├── DownloadButton.svelte
  │   │   │   └── FeatureCard.svelte
  │   │   └── assets/
  │   └── app.html
  ├── static/
  │   ├── images/
  │   ├── screenshots/
  │   └── favicon.png
  └── svelte.config.js
  ```

- [ ] Configure static site generation
- [ ] Setup GitHub Pages deployment (GitHub Actions)

### 4.2 Website Content
- [ ] **Home Page**
  - Hero section with tagline
  - Problem statement (Mac vs Windows Home/End behavior)
  - Solution overview
  - Download CTA button (latest release from GitHub)
  - Screenshot/demo video
  - Feature highlights
  - **Safety notice: "Your original keybindings are automatically backed up"**
  - System requirements

- [ ] **Download Page**
  - Latest version info (fetched from GitHub API)
  - Download .dmg button
  - Download .zip button
  - Installation instructions
  - Verification instructions (SHA256 checksums)
  - Troubleshooting section

- [ ] **Documentation Page**
  - Getting started guide
  - How to configure settings
  - Supported key combinations
  - Which apps work with bindings
  - **Backup & Restore guide**
  - FAQ section:
    - "What happens to my existing keybindings?"
    - "How do I restore my original keybindings?"
    - "Where are backups stored?"
  - Uninstall instructions (with backup restoration steps)

- [ ] **Support Page**
  - GitHub issues link
  - Known limitations
  - Contact information
  - Sponsor link placeholder

### 4.3 Design & Styling
- [ ] Responsive design (mobile-first)
- [ ] Dark mode support
- [ ] Consistent with Tiny Tool Town branding (if applicable)
- [ ] Accessibility compliance (WCAG 2.1 AA)
- [ ] Performance optimization (lazy loading, image optimization)

### 4.4 SEO & Meta
- [ ] Meta tags for social sharing
- [ ] OpenGraph images
- [ ] Sitemap.xml
- [ ] robots.txt
- [ ] **No analytics** (privacy-focused, no GDPR concerns)

**Deliverables:**
- Live website on GitHub Pages
- Website source code in `/website` directory

---

## Phase 5: Testing & Launch (Week 7)

### 5.1 Beta Testing
- [ ] Recruit 5-10 beta testers
- [ ] Collect feedback via GitHub Discussions or form
- [ ] Test on various macOS versions (Sonoma 14.0+, Sequoia 15.0+)
- [ ] Test on various apps from test plan
- [ ] Fix critical bugs

### 5.2 Documentation Review
- [ ] Update README.md with:
  - Project description
  - Installation instructions
  - Usage guide
  - Contributing guidelines
  - License information
- [ ] Update CHANGELOG.md
- [ ] Create CONTRIBUTING.md
- [ ] Create CODE_OF_CONDUCT.md (if open to contributions)

### 5.3 Launch Preparation
- [ ] Final QA pass
- [ ] Prepare launch announcement
- [ ] Create social media assets
- [ ] Update Tiny Tool Town website (if applicable)

### 5.4 Public Release
- [ ] Publish v1.0.0 release on GitHub
- [ ] Deploy website to GitHub Pages
- [ ] Announce on social media / relevant communities
- [ ] Monitor GitHub issues for bug reports

**Deliverables:**
- Public v1.0.0 release
- Live public website
- Launch announcement

---

## Phase 6: Post-Launch & Iteration (Ongoing)

### 6.1 User Feedback Collection
- [ ] Monitor GitHub issues
- [ ] Track download statistics
- [ ] Collect feature requests
- [ ] Identify bugs and prioritize fixes

### 6.2 Maintenance
- [ ] Bug fixes (patch releases)
- [ ] macOS compatibility updates
- [ ] Security updates
- [ ] Performance improvements

### 6.3 Future Features (v1.1+)
- [ ] **Homebrew Distribution** (Priority 1)
  - Create homebrew cask
  - Submit to homebrew-cask repository
  - Update website with Homebrew installation instructions

- [ ] **Buy Me a Coffee Integration** (Priority 2 - Optional)
  - Add "Buy Me a Coffee" link in About window
  - Optional donation link on website
  - No paywalled features (keep it free and open)

- [ ] **Additional Key Bindings** (Priority 3)
  - Option/Alt + . for emoji picker
  - Ctrl/Cmd + Left/Right for word navigation
  - Page Up/Down behavior customization
  - Delete/Backspace behavior

- [ ] **Advanced Features** (Future)
  - Import/Export settings
  - Profiles for different use cases
  - Per-app binding overrides
  - Update checker with notifications
  - Keyboard shortcut recorder

---

## Risk Assessment & Mitigation

### Risk 1: DefaultKeyBinding.dict limitations
**Impact:** High | **Probability:** Medium
- **Mitigation:** Phase 0 research thoroughly validates approach
- **Fallback:** Document limitations clearly; consider Accessibility API approach for v2

### Risk 2: App doesn't work with Electron apps
**Impact:** Medium | **Probability:** High
- **Mitigation:** Document which apps work/don't work
- **Fallback:** Provide alternative solutions (e.g., Karabiner-Elements) in docs

### Risk 3: Apple notarization issues
**Impact:** High | **Probability:** Low
- **Mitigation:** Start notarization process early in Phase 3
- **Fallback:** Provide instructions for users to bypass Gatekeeper (not ideal)

### Risk 4: User confusion about app restart requirement
**Impact:** Medium | **Probability:** High
- **Mitigation:** Clear UI warnings and notifications
- **Fallback:** Provide in-app "Restart Apps" helper (AppleScript)

### Risk 5: User loses existing keybindings
**Impact:** Critical | **Probability:** Low (with proper implementation)
- **Mitigation:** 
  - Always backup before modifications
  - Keep multiple backup versions (last 5)
  - Clear UI showing backup status
  - Test backup/restore extensively
  - Merge user bindings (don't overwrite)
- **Fallback:** Manual backup instructions in docs; emergency recovery guide

---

## Success Metrics

### Launch Success (End of Phase 5)
- [ ] App builds and runs on macOS 14.0+
- [ ] All 8 Home/End key combinations work in at least 5 test apps
- [ ] Website live and accessible
- [ ] First GitHub release published
- [ ] No critical bugs in issue tracker

### Adoption Success (3 months post-launch)
- [ ] 100+ downloads from GitHub releases
- [ ] 10+ stars on GitHub repository
- [ ] Positive feedback from users
- [ ] Listed on Tiny Tool Town website
- [ ] No major security issues reported

### Long-term Success (6+ months)
- [ ] Available via Homebrew
- [ ] 500+ downloads
- [ ] Active community engagement
- [ ] At least one sponsor (if sponsorship enabled)

---

## Timeline Summary

| Phase | Duration | Week # | Key Deliverable |
|-------|----------|--------|-----------------|
| Phase 0: Research | 1 week | Week 1 | Research findings, validated approach |
| Phase 1: Core App | 2 weeks | Week 2-3 | Working app prototype |
| Phase 2: UI Polish | 1 week | Week 4 | Beta-ready app |
| Phase 3: Distribution | 1 week | Week 5 | First GitHub release |
| Phase 4: Website | 1 week | Week 6 | Live website |
| Phase 5: Testing & Launch | 1 week | Week 7 | Public v1.0.0 release |
| Phase 6: Post-Launch | Ongoing | Week 8+ | Maintenance & iteration |

**Total Time to Launch: ~7 weeks**

---

## Open Questions

1. **Tiny Tool Town Integration:**
   - Is there a specific listing format required?
   - Any branding guidelines to follow?

2. **App Icon Design:**
   - Any specific design preferences or themes?
   - Should it match Tiny Tool Town visual style?

3. **Backup Retention Policy:**
   - How many backups to keep? (Suggested: 5)
   - Where to store metadata? (Suggested: `~/Library/Application Support/com.a10w.tinymackeybindings/`)

## Resolved Questions ✅

- **Bundle ID**: `com.a10w.tinymackeybindings`
- **License**: MIT
- **Sponsorship**: Buy Me a Coffee (optional, future consideration)
- **Analytics**: None (privacy-focused, no GDPR)
- **Auto-updates**: Yes (Sparkle framework)
- **Backup Strategy**: Always backup existing keybindings, restore on disable/uninstall

---

## Next Steps

1. **Review and approve this plan**
2. **Answer open questions**
3. **Begin Phase 0: Research & Validation**
4. **Setup Xcode project structure**
5. **Create initial GitHub issues/milestones for tracking**

---

## Notes

- This plan assumes one developer working part-time (~10-15 hours/week)
- Adjust timeline based on actual availability
- Each phase can be broken down into smaller GitHub issues for tracking
- Regular check-ins recommended at end of each phase
- Plan is living document - update as needed based on findings and feedback
