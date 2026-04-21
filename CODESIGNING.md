# Code Signing & Notarization Guide

## Your Account Information

**Apple ID**: apple@adenearnshaw.com  
**Personal Account** (NOT AutoFlow company account)

⚠️ **Important**: This is a personal project. Make sure to use your personal Apple Developer account, not your company's AutoFlow account when setting up certificates.

## Prerequisites

You'll need:
1. ✅ Apple Developer Account (apple@adenearnshaw.com) - Renewed, waiting for activation
2. Developer ID Application Certificate (get after activation)
3. App-specific password for notarization

## Account Activation Status

Your Apple Developer account was recently renewed. Activation typically takes 1-24 hours.

Check activation status:
- https://developer.apple.com/account
- Once active, you'll see your membership details

## Step 1: Get Developer ID Application Certificate

**⚠️ Wait for your account to be fully activated before proceeding**

### Option A: Using Xcode (Easiest)

1. Open **Xcode**
2. Go to **Xcode > Settings... (⌘,)**
3. Click **Accounts** tab
4. Click **+** to add account (if not already added)
5. Sign in with: **apple@adenearnshaw.com**
6. Select your account and click **Manage Certificates...**
7. Click **+** button
8. Select **Developer ID Application**
9. Click **Done**

### Option B: Using Apple Developer Portal

1. Go to https://developer.apple.com/account/resources/certificates/list
2. Click **+** to create new certificate
3. Select **Developer ID Application**
4. Follow the prompts to create a CSR (Certificate Signing Request)
5. Download and install the certificate

## Step 2: Create App-Specific Password

1. Go to https://appleid.apple.com/account/manage
2. Sign in with: **apple@adenearnshaw.com**
3. Under **Security** section, find **App-Specific Passwords**
4. Click **Generate Password**
5. Name it: "Tiny Home End Notarization"
6. **Save this password** - you'll need it for notarization

## Step 3: Automated Release Build

Once your account is active and you have the certificate:

```bash
# Complete release build (all steps)
./scripts/release.sh
```

This will:
1. Build the app
2. Sign with your personal certificate
3. Notarize with Apple
4. Create signed DMG
5. Generate SHA256 for Homebrew

### Individual Steps

```bash
# Just sign the app
./scripts/sign-app.sh

# Just notarize
./scripts/notarize-app.sh

# Just create DMG
./scripts/create-dmg.sh
```

## Step 6: Verify

```bash
# Check signature
codesign -vvv --deep --strict "build/Tiny Home End.app"

# Check notarization
spctl -a -vvv -t install "build/Tiny Home End.app"
```

## Troubleshooting

### Certificate Not Found
- Make sure you're using "Developer ID Application" not "Apple Development"
- Check keychain access to ensure certificate is installed
- May need to download from developer portal

### Notarization Failed
- Check that hardened runtime is enabled
- Verify all entitlements are correct
- Check notarization log for specific errors

### Gatekeeper Blocking
- Make sure app is both signed AND notarized
- Staple the notarization ticket to the app
- Verify with `spctl -a -vvv -t install`

## Resources

- [Apple Code Signing Guide](https://developer.apple.com/support/code-signing/)
- [Notarization Documentation](https://developer.apple.com/documentation/security/notarizing_macos_software_before_distribution)
