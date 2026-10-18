cask "dopamine" do
  version "0.1.7"
  sha256 "69011dfb01c18900490f581286b06a790f42ff3918a8247a5a6247ed6319c573"

  url "https://github.com/Route23/dopamine-releases/releases/download/v#{version}/dopamine_#{version}_aarch64.dmg",
      verified: "github.com/Route23/dopamine-releases/"
  name "dopamine"
  desc "macOS desktop browser built on gpui"
  homepage "https://route23.github.io/dopamine-releases/"

  livecheck do
    url "https://github.com/Route23/dopamine-releases/releases/latest/download/latest.json"
    strategy :json do |json|
      json["version"]
    end
  end

  auto_updates true # in-app updater handles upgrades (ADR-0045)
  depends_on arch:  :arm64
  depends_on macos: :sonoma

  app "dopamine.app"

  # Ad-hoc signed (no Apple Developer ID): strip the quarantine flag so
  # Gatekeeper does not mark it "damaged". Notarization would remove the need.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/dopamine.app"],
                   sudo: false
  end

  zap trash: [
    "~/.config/dopamine",
    "~/Library/Application Support/dopamine",
    "~/Library/Caches/com.route23.dopamine",
    "~/Library/Preferences/com.route23.dopamine.plist",
  ]

  caveats <<~CAVEATS
    dopamine is signed ad-hoc, not notarized by Apple. This tap installs
    without quarantine, so it should open normally. If macOS ever reports it
    as "damaged":
      xattr -dr com.apple.quarantine "#{appdir}/dopamine.app"
  CAVEATS
end
