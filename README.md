# tiny-mac-home-end-bindings

A native macOS menu bar app that applies Windows-like behavior for Home and End keys (with modifier support) across all applications.

## 🚀 Project Status

**Phase**: 2 - UI Polish (In Progress)  
**Version**: Pre-alpha (v0.2.0)  
**Last Updated**: 2026-04-21

## 📋 Quick Links

- [Project Plan](PLAN.md) - Full development roadmap
- [Research Findings](RESEARCH.md) - Technical validation and approach
- [Test Plan](TEST_PLAN.md) - Manual testing checklist

## 🎯 What This App Does

Makes Home/End keys behave like Windows on your Mac:
- **Home** → Beginning of line (not beginning of document)
- **End** → End of line (not end of document)
- **Shift+Home** → Select to beginning of line
- **Shift+End** → Select to end of line
- **Ctrl+Home** → Beginning of document
- **Ctrl+End** → End of document
- **Ctrl+Shift+Home/End** → Select to beginning/end of document

## ✨ Features

### Implemented ✅
- Native macOS menu bar application
- Windows-like & paragraph-based presets
- Automatic backup before changes
- Merge user bindings (preserves custom keys)
- Settings UI with live configuration
- About window with app info
- Launch at login option
- First-run welcome experience
- Modern notifications (UserNotifications)
- Dynamic menu bar icon (shows enabled state)

### In Progress 🚧
- App icon design
- Code signing & notarization
- DMG packaging

### Planned 📋
- Homebrew cask distribution
- Website (SvelteKit)
- Auto-update mechanism (Sparkle)

## 🛠️ Technology Stack

- **App**: Swift + SwiftUI (native macOS)
- **Bundle ID**: `com.a10w.tinymackeybindings`
- **Min macOS**: 14.0 (Sonoma) and above
- **License**: MIT
- **Distribution**: GitHub Releases → Homebrew (future)

## 🔐 Safety First

This app will:
- ✅ **Always backup** your existing keybindings before modification
- ✅ **Merge** your custom bindings (not overwrite)
- ✅ **Restore** on disable or uninstall
- ✅ Keep the last 5 backups for safety
- ✅ Show clear warnings before applying changes

## 🧪 Development

### Building from Source

```bash
cd TinyHomeEnd
swift build --product TinyHomeEndApp
.build/arm64-apple-macosx/debug/TinyHomeEndApp
```

### Running Tests

```bash
cd TinyHomeEnd
swift test
```

**Test Results**: 6/6 passing ✅

## 📦 Installation (Not Yet Available)

App is under development. Follow this repo for updates!

**Coming Soon**:
- Direct download (.dmg)
- Homebrew: `brew install --cask tiny-home-end`

## 🤝 Contributing

Project is in active development. Contributions welcome after v1.0 release.

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details

## 🙏 Acknowledgments

- Inspired by [this blog post](https://randomcoding.com/blog/2023-10-03-rebinding-the-home-and-end-keys-in-a-mac-to-work-like-they-do-in-windows-linux/)
- For eventual listing on Tiny Tool Town

---

## 📊 Development Progress

- [x] Phase 0: Research & Validation
- [x] Phase 1: Core Service + Mac App  
- [ ] Phase 2: UI Polish (~75% complete)
- [ ] Phase 3: Distribution Setup
- [ ] Phase 4: Website
- [ ] Phase 5: Testing & Launch

**Note**: This is a work in progress. Star/watch this repo for updates!
