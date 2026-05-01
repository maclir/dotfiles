# dotfiles

Personal macOS configuration: shell (zsh + bash), git, vim, Claude Code,
agent-deck, direnv, Homebrew. Stow-based, with a one-shot bootstrap
script for fresh laptops.

## Fresh laptop setup

Prerequisite: Xcode Command Line Tools — `xcode-select --install`.

```sh
git clone git@github.com:maclir/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
make bootstrap
```

`make bootstrap` runs `bin/bootstrap.sh`, which:

1. Verifies Xcode CLT
2. Installs Homebrew (if missing)
3. Runs `brew bundle` against the tracked `Brewfile`
4. Moves any pre-existing real `.zshrc`/`.gitconfig`/etc. aside as `*.preexisting`
5. Stows every package into `$HOME` (`make install`)
6. Symlinks the tracked `direnv/code/{work,personal}/.envrc` files into place (`make direnv`)
7. Seeds `~/.env.sh` from `shell/.env.sh.example` (chmod 600)
8. Installs vim plugins (`vim +PlugInstall +qall`)
9. Prints the remaining manual checklist

The script is idempotent; rerun it any time.

## Manual steps after bootstrap

These can't be automated:

1. Restore `~/.ssh/` keys from a secure transfer; `ssh-add --apple-use-keychain ~/.ssh/id_ed25519`
2. Edit `~/.env.sh` and fill in tokens (`GITHUB_TOKEN`, etc.)
3. Recreate the per-directory git config includes referenced from `git/.gitconfig`:
   - `~/code/work/.gitconfig` — work email + signing key
   - `~/code/personal/.gitconfig` — personal email + signing key
   - `~/go-workspace/src/work/.gitconfig`
   - `~/go-workspace/src/personal/.gitconfig`
4. `direnv allow ~/code/work && direnv allow ~/code/personal`
5. Restore GPG keys if signing commits
6. Sign in to:
   - `gcloud auth login` and `gcloud auth application-default login`
   - `gh auth login` (and `gh auth login --hostname ghe.spotify.net` for work)
   - SDKMAN (`sdk install java`, `sdk install kotlin` as needed)
7. Install GUI apps not covered by the Brewfile

## Make targets

| Target       | Behavior                                                          |
| ------------ | ----------------------------------------------------------------- |
| `install`    | `stow -t ~ <packages>` — symlinks all tracked configs into `$HOME` (default) |
| `uninstall`  | Removes the symlinks                                              |
| `update`     | `git pull && make install`                                        |
| `pull`       | `git pull` only                                                   |
| `bootstrap`  | One-shot fresh-laptop setup (runs `bin/bootstrap.sh`)             |
| `direnv`     | Symlinks `direnv/**/.envrc` files into `$HOME/...` and prints `direnv allow` reminders |
| `brew`       | `brew bundle --file ./Brewfile`                                   |
| `dump-brew`  | Regenerate `Brewfile` from currently installed Homebrew packages  |

## Repo layout

```
.
├── Makefile / Brewfile / README.md
├── bin/bootstrap.sh
├── git/         → ~/.gitconfig, ~/.git-templates/, ~/.git-*.sh helpers
├── shell/       → ~/.profile, ~/.zshrc, ~/.zprofile, ~/.bash_profile, ~/.env.sh.example
├── vim/         → ~/.vimrc, ~/.vim/
├── gitignore/   → ~/.config/git/ignore
├── agent-deck/  → ~/.agent-deck/config.toml
├── claude/      → ~/.claude/, ~/.claude-work/ (settings.json, CLAUDE.md)
└── direnv/      → symlinked into ~/code/{work,personal}/.envrc by `make direnv`
```

## Notes

- `~/.env.sh` is intentionally not tracked. Holds local tokens.
- `Brewfile` includes the `spotify/sptaps` tap which requires GHE access.
  On non-Spotify machines the entries from that tap will fail; comment them
  out or remove them.
- Vim plugins are managed by [vim-plug](https://github.com/junegunn/vim-plug).
  Bootstrap runs `:PlugInstall` automatically; rerun with `vim +PlugInstall +qall`.
