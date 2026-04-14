class XonoraCli < Formula
  desc "Native C++ terminal client for Music Assistant"
  homepage "https://github.com/hayupadhyaya/xonora-cli"
  version "0.1"
  license :cannot_represent

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/hayupadhyaya/xonora-cli/releases/download/v0.1/xonora-cli-v0.1-macos-arm64.tar.gz"
      sha256 "2874aa55100a152d69091846265a5f5e7489d7fe60b5d68eafb0e2880640d684"
    else
      url "https://github.com/hayupadhyaya/xonora-cli/releases/download/v0.1/xonora-cli-v0.1-macos-x86_64.tar.gz"
      sha256 "e4d76578e74002cd557b4ad14e830fabd71efc3a38a0f393b347620003061542"
    end
  end

  def install
    bin.install "xonora-cli"
    doc.install "README.md"
    (share/"xonora-cli/licenses").install Dir["licenses/*"]
  end

  def caveats
    <<~EOS
      xonora-cli is an unsigned binary. On first launch macOS may block it.
      To bypass Gatekeeper:
        xattr -d com.apple.quarantine #{bin}/xonora-cli
      Or approve via System Settings -> Privacy & Security.

      Requires a reachable Music Assistant server (schema 28+) with the
      Sendspin provider enabled.
    EOS
  end

  test do
    assert_match "xonora-cli", shell_output("#{bin}/xonora-cli --help")
  end
end
