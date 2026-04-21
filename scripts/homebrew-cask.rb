cask "tiny-home-end" do
  version "0.2.0"
  sha256 "REPLACE_WITH_ACTUAL_SHA256"

  url "https://github.com/adenearnshaw/tiny-mac-home-end-bindings/releases/download/v#{version}/TinyHomeEnd-#{version}.dmg"
  name "Tiny Home/End"
  desc "Windows-like Home/End key behavior for macOS"
  homepage "https://github.com/adenearnshaw/tiny-mac-home-end-bindings"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :sonoma"

  app "Tiny Home End.app"

  postflight do
    system_command "#{appdir}/Tiny Home End.app/Contents/MacOS/Tiny Home End",
                   args: ["--first-run"],
                   sudo: false
  end

  uninstall quit: "com.a10w.tinymackeybindings"

  zap trash: [
    "~/Library/Application Support/com.a10w.tinymackeybindings",
    "~/Library/Preferences/com.a10w.tinymackeybindings.plist",
    "~/Library/KeyBindings/DefaultKeyBinding.dict.backup.*",
  ]

  caveats <<~EOS
    Tiny Home/End is a menu bar application.
    
    After installation:
    1. The app will appear in your menu bar (keyboard icon)
    2. Click to enable Windows-like Home/End key behavior
    3. Your existing keybindings will be automatically backed up
    
    To customize settings:
    - Click the menu bar icon and select "Settings..."
    - Or press Cmd+, while the app is active
    
    Keyboard shortcuts:
    - Cmd+Shift+K: Toggle bindings on/off
    - Cmd+,: Open Settings
    
    Note: You may need to restart applications for the keybindings to take effect.
  EOS
end
