#!/usr/bin/env bash
#
# One-shot setup for a fresh macOS laptop.
# Run from anywhere: ~/.dotfiles/bin/bootstrap.sh
#
# Idempotent: safe to re-run.

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m==>\033[0m %s\n' "$*" >&2; }

# 1. Xcode Command Line Tools
if ! xcode-select -p >/dev/null 2>&1; then
	warn "Xcode Command Line Tools missing. Run: xcode-select --install"
	exit 1
fi

# 2. Homebrew
if ! command -v brew >/dev/null 2>&1; then
	log "Installing Homebrew"
	NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	# Activate brew for the rest of this script (Apple Silicon path)
	if [ -x /opt/homebrew/bin/brew ]; then
		eval "$(/opt/homebrew/bin/brew shellenv)"
	elif [ -x /usr/local/bin/brew ]; then
		eval "$(/usr/local/bin/brew shellenv)"
	fi
fi

# 3. Brew bundle
log "Installing Homebrew packages from Brewfile"
brew bundle --file "$DOTFILES_DIR/Brewfile" || warn "Some Brewfile entries failed (likely the spotify/sptaps tap on a non-GHE machine). Continuing."

# 4. Move pre-existing real files out of the way so stow can symlink
preexisting=()
for rel in .zshrc .zprofile .profile .bash_profile .gitconfig; do
	if [ -e "$HOME/$rel" ] && [ ! -L "$HOME/$rel" ]; then
		mv "$HOME/$rel" "$HOME/$rel.preexisting"
		preexisting+=("$HOME/$rel.preexisting")
	fi
done
if [ ${#preexisting[@]} -gt 0 ]; then
	log "Moved pre-existing files aside: ${preexisting[*]}"
fi

# 5. Stow tracked configs
log "Stowing dotfiles into \$HOME"
make -C "$DOTFILES_DIR" install

# 6. Symlink direnv files
log "Linking direnv files into ~/code/{work,personal}"
make -C "$DOTFILES_DIR" direnv

# 7. Seed ~/.env.sh from template if absent
if [ ! -f "$HOME/.env.sh" ]; then
	cp "$DOTFILES_DIR/shell/.env.sh.example" "$HOME/.env.sh"
	chmod 600 "$HOME/.env.sh"
	log "Seeded ~/.env.sh from template (chmod 600)"
fi

# 8. Vim plugins (vim-plug bootstraps itself from the tracked autoload/plug.vim)
if command -v vim >/dev/null 2>&1; then
	log "Installing vim plugins (PlugInstall)"
	vim +PlugInstall +qall
fi

# 9. Manual handoff checklist
cat <<'EOF'

==> Bootstrap complete. Manual steps remain:

  1. Restore SSH keys to ~/.ssh/ and `ssh-add --apple-use-keychain ~/.ssh/id_ed25519`
  2. Edit ~/.env.sh and fill in any tokens you need
  3. Recreate the local gitconfig includes:
       ~/code/work/.gitconfig
       ~/code/personal/.gitconfig
       ~/go-workspace/src/work/.gitconfig
       ~/go-workspace/src/personal/.gitconfig
  4. `direnv allow ~/code/work && direnv allow ~/code/personal`
  5. Restore GPG keys for commit signing if used
  6. Sign in: gcloud auth login, gcloud auth application-default login
              gh auth login (and `gh auth login --hostname ghe.spotify.net` for work)
              SDKMAN: `sdk install java`, `sdk install kotlin` as needed
  7. GUI apps not in the Brewfile (Android Studio, etc.)

EOF
