# ZarinLab Homebrew tap

Homebrew formulae for ZarinLab tools.

## DoppelDock

Use two accounts in the same Mac app, side by side, each with its own sign-in
and its own Dock icon. See <https://zarinlab.github.io/doppeldock/>.

```bash
brew install zarinlab/tap/doppeldock
doppeldock install      # adds the DoppelDock app to your Applications folder
```

After `brew upgrade doppeldock`, run `doppeldock install` again to update the app.

## How the formula stays current

The [Update formulae](.github/workflows/update.yml) workflow checks for a new
DoppelDock release every 6 hours. When there is one, it points the formula at
the new version, installs it, runs `brew test` and `brew audit --strict`, and
only then commits. To pick up a release straight away, run the workflow by hand
from the Actions tab. [Test formulae](.github/workflows/test.yml) checks every
manual change.

GitHub pauses scheduled workflows in repositories with no activity for 60 days;
re-enable it from the Actions tab if that happens.
