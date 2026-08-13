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

  depends_on arch:  :arm64
  depends_on macos: ">= :sonoma"
  auto_updates true # in-app Tauri updater handles upgrades

  app "Route23.app"

  caveats <<~CAVEATS
    Route23 is not notarized. If macOS says the app is "damaged", it was
    quarantined on download. Install with --no-quarantine:
      brew install --cask --no-quarantine Route23/tap/route23
    Or clear it after install:
      xattr -dr com.apple.quarantine "#{appdir}/Route23.app"
  CAVEATS
end
