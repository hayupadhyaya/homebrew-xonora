class XonoraCli < Formula
  desc "Cross-platform terminal client for Music Assistant"
  homepage "https://github.com/hayupadhyaya/xonora-cli"
  version "0.3.10"
  license :cannot_represent # proprietary, free for personal non-commercial use

  on_macos do
    # Apple Silicon only — Intel macOS is not supported in v0.3.10.
    on_arm do
      url "https://github.com/hayupadhyaya/xonora-cli/releases/download/cli-v#{version}/xonora-cli-v#{version}-macos-arm64.tar.gz"
      sha256 "e19cc2a9cd786d4688322d5291582d10f4dd8e7277315f39ec62e85dc50b61f3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/hayupadhyaya/xonora-cli/releases/download/cli-v#{version}/xonora-cli-v#{version}-linux-arm64.tar.gz"
      sha256 "bf52f70e279f5075db17f74c06e9e451836f9c4baa0917e3f82fe6435821ca46"
    end
    on_intel do
      url "https://github.com/hayupadhyaya/xonora-cli/releases/download/cli-v#{version}/xonora-cli-v#{version}-linux-x86_64.tar.gz"
      sha256 "d69b83c3c1e448204115ad5c6dd013d4ecf49b750bc2234de5473740bf323678"
    end
    depends_on "alsa-lib"
  end

  def install
    # Release tarballs are laid out as:
    #   xonora-cli-v${VERSION}-<os>-<arch>/xonora-cli
    #   xonora-cli-v${VERSION}-<os>-<arch>/licenses/...
    #   xonora-cli-v${VERSION}-<os>-<arch>/README.txt
    subdir = Dir["xonora-cli-v*-*-*"].first || "."
    bin.install "#{subdir}/xonora-cli"
    pkgshare.install Dir["#{subdir}/licenses"] if File.directory?("#{subdir}/licenses")
    doc.install "#{subdir}/README.txt" if File.exist?("#{subdir}/README.txt")
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
    assert_match "xonora-cli", shell_output("#{bin}/xonora-cli --version")
  end
end
