#!/bin/sh
# Symlink this repo onto the system.
# - top-level folders (fastfetch/, fish/, ...) -> ~/.config/<name>
# - home/* (e.g. home/.zshrc)                 -> ~/<name>
# Usage: ./install.sh
set -eu

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DIR="$HOME/.config"

mkdir -p "$CONFIG_DIR"

link_target() {
  src="$1"
  dest="$2"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    backup="$dest.backup.$(date +%Y%m%d%H%M%S)"
    echo "Backing up existing $dest -> $backup"
    mv "$dest" "$backup"
  fi
  if [ -L "$dest" ]; then
    rm "$dest"
  fi
  echo "Linking $src -> $dest"
  ln -s "$src" "$dest"
}

for entry in "$DOTFILES_DIR"/* "$DOTFILES_DIR"/.*; do
  name="$(basename "$entry")"
  case "$name" in
    .|..|.git|.gitignore|README.md|LICENSE|install.sh|.) continue;;
  esac
  [ -e "$entry" ] || continue
  # home/ holds $HOME dotfiles (e.g. .zshrc)
  if [ "$name" = "home" ] && [ -d "$entry" ]; then
    for dot in "$entry"/.* "$entry"/*; do
      dname="$(basename "$dot")"
      case "$dname" in
        .|..|.gitignore|.DS_Store) continue;;
      esac
      [ -e "$dot" ] || continue
      link_target "$dot" "$HOME/$dname"
    done
    continue
  fi
  # hidden files at repo root (except home contents) are skipped
  case "$name" in
    .*) continue;;
  esac
  link_target "$entry" "$CONFIG_DIR/$name"
done

# Ghostty on macOS reads ~/Library/Application Support/com.mitchellh.ghostty/config,
# not ~/.config — link the versioned copy there too.
if [ "$(uname)" = "Darwin" ] && [ -f "$DOTFILES_DIR/ghostty/config" ]; then
  GHOSTTY_DIR="$HOME/Library/Application Support/com.mitchellh.ghostty"
  mkdir -p "$GHOSTTY_DIR"
  link_target "$DOTFILES_DIR/ghostty/config" "$GHOSTTY_DIR/config"
fi

echo "Done. Open a new terminal or run: source ~/.zshrc"
