#!/bin/bash
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 <tag>" >&2
  echo "Example: $0 v1.0.0" >&2
  exit 1
fi

TAG="$1"
VERSION="${TAG#v}"
REPO="shonenada-vibe/pasty"
URL="https://github.com/${REPO}/releases/download/${TAG}/Pasty-${VERSION}.zip"

SHA256=$(curl -sL "$URL" | shasum -a 256 | awk '{print $1}')

if [ -z "$SHA256" ] || [ "$SHA256" = "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855" ]; then
  echo "Error: Failed to download release asset. Is the tag '${TAG}' released?" >&2
  exit 1
fi

cat <<EOF
cask "pasty" do
  version "${VERSION}"
  sha256 "${SHA256}"

  url "https://github.com/${REPO}/releases/download/v#{version}/Pasty-#{version}.zip"
  name "Pasty"
  desc "macOS menu bar clipboard manager"
  homepage "https://github.com/${REPO}"

  depends_on macos: ">= :sonoma"

  app "Pasty.app"

  postflight do
    system_command "/usr/bin/xattr", args: ["-cr", "#{appdir}/Pasty.app"]
  end

  zap trash: [
    "~/Library/Preferences/com.pasty.app.plist",
  ]
end
EOF
