# tiny-mac-home-end-bindings

A native macOS menu bar app that applies Windows-like behavior for Home and End keys (with modifier support) across all applications.

## 🚀 Project Status

**Phase**: 0 - Research & Validation (In Progress)  
**Version**: Pre-alpha  
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

## 🛠️ Technology Stack

- **App**: Swift + SwiftUI (native macOS)
- **Bundle ID**: `com.a10w.tinymackeybindings`
- **Min macOS**: 14.0 (Sonoma) and above
- **License**: MIT
- **Distribution**: GitHub Releases → Homebrew (future)

## 🔬 Current Research Phase

### Completed
- ✅ Validated DefaultKeyBinding.dict approach
- ✅ Created backup/restore strategy
- ✅ File format validation working
- ✅ Created comprehensive test plan

### In Progress
- ⏳ Manual testing across applications
- ⏳ Documenting which apps require restart
- ⏳ Testing line vs paragraph behavior

### Next Steps
1. Complete application testing (see [TEST_PLAN.md](TEST_PLAN.md))
2. Document findings in [RESEARCH.md](RESEARCH.md)
3. Decide on default configuration (line vs paragraph)
4. Begin Phase 1: Core macOS app development

## 🧪 Testing

To run the validation script:

```bash
./validate-keybindings.sh
```

## 🔐 Safety First

This app will:
- ✅ **Always backup** your existing keybindings before modification
- ✅ **Merge** your custom bindings (not overwrite)
- ✅ **Restore** on disable or uninstall
- ✅ Keep the last 5 backups for safety

## 📦 Installation (Not Yet Available)

App is under development. Follow this repo for updates!

## 🤝 Contributing

Project is in early research phase. Contributions welcome after Phase 1 is complete.

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details

## 🙏 Acknowledgments

- Inspired by [this blog post](https://randomcoding.com/blog/2023-10-03-rebinding-the-home-and-end-keys-in-a-mac-to-work-like-they-do-in-windows-linux/)
- For eventual listing on Tiny Tool Town

---

**Note**: This is a work in progress. Star/watch this repo for updates!
