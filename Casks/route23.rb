cask "route23" do
  version "0.1.208"
  sha256 "1c1a316cf4bcf3afc9b8853126ecc63ea7d955ee485bfcd8321f9ee3e78a2903"

  url "https://github.com/Route23/r23/releases/download/v#{version}/Route23_#{version}_aarch64.dmg",
      verified: "github.com/Route23/r23/"
  name "Route23"
  desc "Desktop browser with file, image, RSS and bookmark management"
  homepage "https://github.com/Route23/r23"

  livecheck do
    url "https://github.com/Route23/r23/releases/latest/download/latest.json"
    strategy :json do |json|
      json["version"]
    end
  end

  auto_updates true # in-app Tauri updater handles upgrades
  depends_on arch:  :arm64
  depends_on macos: :sonoma

  app "Route23.app"

  # Unsigned build: strip the quarantine flag so Gatekeeper does not mark it
  # "damaged". Notarization would remove the need for this.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Route23.app"],
                   sudo: false
  end

  caveats <<~CAVEATS
    Route23 is unsigned (ad-hoc). This tap installs without quarantine, so it
    should open normally. If macOS ever reports it as "damaged":
      xattr -dr com.apple.quarantine "#{appdir}/Route23.app"
  CAVEATS
end
