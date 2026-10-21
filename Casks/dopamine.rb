cask "dopamine" do
  version "0.1.9"
  sha256 "466cc42b107cc0b0279a2a6d0130d0ee72c5d8caa46b50054c93365e21dbbfeb"

  url "https://github.com/Route23/dopamine-releases/releases/download/v#{version}/dopamine_#{version}_aarch64.dmg"
  name "dopamine"
  desc "Desktop browser built on gpui"
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
  postflight_steps do
    # Homebrew 7 runs steps in a sandbox: declare the app as writable or xattr is refused.
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/dopamine.app"],
        writable_paths: ["dopamine.app"], writable_base: :appdir
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
