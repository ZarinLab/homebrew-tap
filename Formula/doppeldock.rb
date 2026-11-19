class Doppeldock < Formula
  desc "Second, separately signed-in copy of an Electron app with its own Dock icon"
  homepage "https://zarinlab.github.io/doppeldock/"
  url "https://github.com/ZarinLab/doppeldock/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "67a81fe4cf21f67fb0c36314ed49566d9c8f9e46fedea966428a9cfc6b7b3eea"
  license "MIT"

  depends_on :macos

  def install
    bin.install "doppeldock"
  end

  def caveats
    <<~EOS
      To add the DoppelDock app to your Applications folder, run:
        doppeldock install

      After `brew upgrade doppeldock`, run `doppeldock install` again.
    EOS
  end

  test do
    assert_match "DoppelDock #{version}", shell_output("#{bin}/doppeldock --version")
  end
end
