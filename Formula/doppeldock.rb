class Doppeldock < Formula
  desc "Second, separately signed-in copy of an Electron app with its own Dock icon"
  homepage "https://zarinlab.github.io/doppeldock/"
  url "https://github.com/ZarinLab/doppeldock/releases/download/v1.1.2/doppeldock-1.1.2.tar.gz"
  sha256 "d8e916b381a62e462099762bc8904d4a9148aaa5bb869dd53ff8dd94008cb2c7"
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
