# Code Signing & Notarization Guide

## Your Account Information

**Apple ID**: `apple@<your-personal-domain>.com`  
**Account Type**: Personal Apple Developer Account

⚠️ **Important**: This project uses a personal Apple Developer account. Ensure you're using the correct account when setting up certificates and notarization.

## Prerequisites

You'll need:
1. ✅ Active Apple Developer Account ($99/year)
2. Developer ID Application Certificate
3. App-specific password for notarization

## Verify Account Status

Before proceeding, ensure your Apple Developer account is active:
- Visit https://developer.apple.com/account
- Confirm your membership is active and in good standing
- Note: New accounts or renewals may take 1-24 hours to activate

## Step 1: Get Developer ID Application Certificate

### Option A: Using Xcode (Recommended)

1. Open **Xcode**
2. Go to **Xcode > Settings... (⌘,)**
3. Click **Accounts** tab
4. Click **+** to add account (if not already added)
5. Sign in with your **Apple Developer account**
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
2. Sign in with your **Apple ID**
3. Under **Security** section, find **App-Specific Passwords**
4. Click **Generate Password**
5. Name it: "Tiny Mac Home End Notarization" (or similar)
6. **Save this password** - you'll need it for notarization

### Store Password Securely

Store the app-specific password in your keychain for automation:

```bash
xcrun notarytool store-credentials "notarytool-profile" \
  --apple-id "YOUR_APPLE_ID" \
  --team-id "YOUR_TEAM_ID" \
  --password "APP_SPECIFIC_PASSWORD"
```

Find your Team ID at: https://developer.apple.com/account

## Step 3: Build and Sign the App

Once your certificate is installed:

```bash
# Build the app using the build script
./scripts/build-app.sh
```

This script will:
1. Clean previous builds
2. Build the app with Xcode
3. Sign the app with your Developer ID Application certificate
4. Prepare it for notarization

The signed app will be in: `build/Tiny Mac Home End.app`

## Step 4: Verify Signing

Check that the app is properly signed:

```bash
# Verify code signature
codesign -vvv --deep --strict "build/Tiny Mac Home End.app"

# Check signing identity
codesign -dvv "build/Tiny Mac Home End.app"
```

Expected output should show:
- Valid signature
- Developer ID Application certificate
- Hardened runtime enabled

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
