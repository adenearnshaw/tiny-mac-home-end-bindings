# Release Guide

This guide walks through the complete process of creating and publishing a new release of Tiny Home/End.

## Prerequisites

Before creating a release, ensure you have:

- [x] **Apple Developer Account** (apple@adenearnshaw.com)
  - Must be active and in good standing
  - Personal account (not AutoFlow company account)
  
- [x] **Developer ID Certificates** installed in Keychain
  - "Developer ID Application: Aden Earnshaw (DFD9M4LQT5)"
  - Used for code signing
  
- [x] **App-Specific Password** stored in Keychain
  - Profile name: `TinyHomeEnd`
  - Used for notarization
  - To verify: `xcrun notarytool store-credentials --list`
  
- [x] **GitHub CLI** configured
  - `gh auth status` should show you're logged in
  
- [x] **Xcode Command Line Tools** installed
  - `xcode-select --install` if needed

---

## Release Process

### Step 1: Prepare the Release

#### 1.1 Decide on Version Number

Follow [Semantic Versioning](https://semver.org/):
- **Major** (x.0.0): Breaking changes, major features
- **Minor** (0.x.0): New features, backward compatible
- **Patch** (0.0.x): Bug fixes, small improvements

Example: `0.3.0` → `0.4.0` (new feature) or `0.3.1` (bug fix)

#### 1.2 Update Version Numbers

Update the version in **3 files**:

1. **src/Resources/Info.plist**
   ```xml
   <key>CFBundleShortVersionString</key>
   <string>0.4.0</string>  <!-- Update this -->
   <key>CFBundleVersion</key>
   <string>3</string>       <!-- Increment build number -->
   ```

2. **scripts/release.sh**
   ```bash
   VERSION="0.4.0"  # Update this line
   ```

3. **scripts/create-dmg.sh**
   ```bash
   VERSION="0.4.0"  # Update this line
   ```

#### 1.3 Commit Version Changes

```bash
git add src/Resources/Info.plist scripts/release.sh scripts/create-dmg.sh
git commit -m "Bump version to 0.4.0"
git push origin main
```

---

### Step 2: Build and Sign the Release

Run the complete release script:

```bash
./scripts/release.sh
```

This script will automatically:
1. **Build** the app (`./scripts/build-app.sh`)
2. **Code sign** with your Developer ID (`./scripts/sign-app.sh`)
3. **Notarize** with Apple (`./scripts/notarize-app.sh`)
   - Takes 2-5 minutes typically
   - Must pass Apple's automated security scan
4. **Create DMG** installer (`./scripts/create-dmg.sh`)
5. **Sign DMG** with your Developer ID

**Expected output:**
```
✅ App successfully signed with your personal account!
✅ Notarization successful!
✅ DMG created successfully!
   File: build/TinyHomeEnd-0.4.0.dmg
   Size: 2.3M
```

---

### Step 3: Create Release Notes

Create a file with your release notes:

```bash
cat << 'EOF' > /tmp/release-notes.md
## 🎯 [Release Title]

[Brief description of what's new]

### What's Changed

- Feature 1: Description
- Feature 2: Description
- Bug fix: Description

### Installation

Download `TinyHomeEnd-0.4.0.dmg`, open it, and drag the app to Applications.

### Checksums

**SHA256**: `[will be added automatically]`

---

**Full Changelog**: https://github.com/adenearnshaw/tiny-mac-home-end-bindings/compare/v0.3.0...v0.4.0
EOF
```

#### Add the SHA256 Checksum

The `release.sh` script outputs the SHA256. Add it to your release notes:

```bash
shasum -a 256 build/TinyHomeEnd-0.4.0.dmg
```

---

### Step 4: Create Git Tag

```bash
git tag -a v0.4.0 -m "v0.4.0 - [Release Title]"
git push origin v0.4.0
```

---

### Step 5: Publish GitHub Release

```bash
gh release create v0.4.0 \
  build/TinyHomeEnd-0.4.0.dmg \
  --title "Tiny Home/End v0.4.0 - [Release Title]" \
  --notes-file /tmp/release-notes.md
```

The release will be published to:
```
https://github.com/adenearnshaw/tiny-mac-home-end-bindings/releases/tag/v0.4.0
```

---

### Step 6: Verify the Release

1. **Check GitHub**: Visit the release URL and verify:
   - DMG is attached
   - Release notes are correct
   - Download link works

2. **Test Installation**:
   ```bash
   # Download and test
   open build/TinyHomeEnd-0.4.0.dmg
   
   # Drag to Applications and launch
   # Verify it opens without Gatekeeper warnings
   ```

3. **Test Auto-Update** (if users are on older version):
   - Users should see update notification via Sparkle
   - Verify appcast URL is working

---

## Quick Reference

### One-Time Setup (Already Done)

These steps are already completed, but listed here for reference:

1. **Create Keychain Profile** (for notarization):
   ```bash
   xcrun notarytool store-credentials TinyHomeEnd \
     --apple-id apple@adenearnshaw.com \
     --team-id DFD9M4LQT5 \
     --password [app-specific-password]
   ```

2. **Verify Certificates**:
   ```bash
   security find-identity -v -p codesigning
   ```
   Should show: "Developer ID Application: Aden Earnshaw (DFD9M4LQT5)"

---

## Troubleshooting

### Notarization Fails

**Problem**: Notarization rejected by Apple

**Solution**:
1. Check the notarization log:
   ```bash
   xcrun notarytool log [SUBMISSION_ID] --keychain-profile TinyHomeEnd
   ```
2. Common issues:
   - Unsigned frameworks/libraries
   - Invalid entitlements
   - Hardened runtime issues

### Gatekeeper Blocks App

**Problem**: macOS warns "cannot be opened because the developer cannot be verified"

**Solution**:
- App must be both signed AND notarized
- Re-run `./scripts/notarize-app.sh` if needed
- Verify stapling: `stapler validate "build/Tiny Home End.app"`

### Wrong Apple Account Used

**Problem**: Build uses AutoFlow certificate instead of personal

**Solution**:
- Check certificate name in `scripts/sign-app.sh`
- Should grep for "Aden Earnshaw" and exclude "AutoFlow"
- Verify with: `codesign -dvv "build/Tiny Home End.app"`

### DMG Has Wrong Version

**Problem**: DMG created with old version number

**Solution**:
- Make sure ALL three files are updated (see Step 1.2)
- Clean build: `rm -rf build/*`
- Re-run: `./scripts/release.sh`

---

## File Locations

### Version Numbers
- `src/Resources/Info.plist` - App version
- `scripts/release.sh` - Release script version
- `scripts/create-dmg.sh` - DMG creation version

### Build Outputs
- `build/Tiny Home End.app` - Built application
- `build/TinyHomeEnd-X.X.X.dmg` - Distribution DMG
- `build/Tiny Home End.zip` - Notarization submission (temporary)

### Scripts
- `scripts/build-app.sh` - Builds the Swift app
- `scripts/sign-app.sh` - Code signs the app
- `scripts/notarize-app.sh` - Submits to Apple for notarization
- `scripts/create-dmg.sh` - Creates DMG installer
- `scripts/release.sh` - Runs all steps in order

---

## Security Notes

### Code Signing Identity

**Personal Account** (USE THIS):
- Name: "Developer ID Application: Aden Earnshaw (DFD9M4LQT5)"
- Team ID: DFD9M4LQT5
- Apple ID: apple@adenearnshaw.com

**Company Account** (DON'T USE):
- Name: "Developer ID Application: AutoFlow (XXXXXXXX)"
- This is for company projects only

### App-Specific Password

- Never commit this to git
- Stored securely in macOS Keychain
- Profile name: `TinyHomeEnd`
- Generate new one at: https://appleid.apple.com/account/manage

### Entitlements

The app requires these entitlements (in `src/Resources/TinyHomeEnd.entitlements`):
- `com.apple.security.app-sandbox` - App sandboxing
- `com.apple.security.files.user-selected.read-write` - File access
- Hardened runtime enabled for notarization

---

## Future Phases

### Phase 5: Homebrew Distribution

When ready to add Homebrew support:

1. Update `scripts/homebrew-cask.rb` with latest version
2. Fork homebrew-cask repo
3. Submit PR with cask formula
4. Users can install with: `brew install --cask tiny-home-end`

See `scripts/homebrew-cask.rb` for the formula template.

---

## Quick Checklist

Use this checklist for each release:

- [ ] Decide version number (semver)
- [ ] Update `Info.plist` (version + build)
- [ ] Update `scripts/release.sh` (VERSION)
- [ ] Update `scripts/create-dmg.sh` (VERSION)
- [ ] Commit and push version changes
- [ ] Run `./scripts/release.sh`
- [ ] Verify build succeeded (check DMG exists)
- [ ] Write release notes
- [ ] Add SHA256 to release notes
- [ ] Create git tag (`v0.X.X`)
- [ ] Push tag to GitHub
- [ ] Create GitHub release with DMG
- [ ] Test download and installation
- [ ] Announce release (optional)

---

## Questions?

If something goes wrong or this guide is unclear:

1. Check the build logs in terminal
2. Review Apple's notarization logs
3. Verify certificates are valid and not expired
4. Check GitHub Actions logs (when CI/CD is set up)

**Remember**: The release process should take 10-15 minutes total, with most time spent waiting for Apple's notarization service.

Good luck with your release! 🚀
