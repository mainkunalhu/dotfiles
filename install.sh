#!/bin/sh
# Symlink every top-level entry in this repo into ~/.config
# Usage: ./install.sh
set -eu

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DIR="$HOME/.config"

mkdir -p "$CONFIG_DIR"

for entry in "$DOTFILES_DIR"/*; do
  name="$(basename "$entry")"
  # skip repo meta files
  case "$name" in
    README.md|LICENSE|.git|.gitignore|install.sh) continue;;
  esac
  target="$CONFIG_DIR/$name"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    backup="$target.backup.$(date +%Y%m%d%H%M%S)"
    echo "Backing up existing $target -> $backup"
    mv "$target" "$backup"
  fi
  if [ -L "$target" ]; then
    rm "$target"
  fi
  echo "Linking $entry -> $target"
  ln -s "$entry" "$target"
done

echo "Done. Run: fastfetch"
