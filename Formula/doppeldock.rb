class Doppeldock < Formula
  desc "Second, separately signed-in copy of an Electron app with its own Dock icon"
  homepage "https://zarinlab.github.io/doppeldock/"
  url "https://github.com/ZarinLab/doppeldock/releases/download/v1.1.1/doppeldock-1.1.1.tar.gz"
  sha256 "6188d6742a4bbcab09d7b4d8dc0ce6cc03704beb5fcc6e2497f7b2501bc86b41"
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
