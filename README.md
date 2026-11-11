# dotfiles

Private backup of my `~/.config` — so I never have to rewrite configs from scratch.
Just pull and symlink.

Repo layout **mirrors** `~/.config`:

```text
dotfiles/
  fastfetch/
    config.jsonc          <- slim: title, os, uptime, shell, terminal, cpu, memory, disk, Directory(pwd)
    assets/
      geto-rounded.png   <- rounded-corners image used by fastfetch
      geto-original.png  <- original upload
  home/
    .zshrc                <- shell startup: fastfetch autorun + `clear` alias + starship init
  starship.toml           <- minimal prompt (linked to ~/.config/starship.toml)
  install.sh              <- symlinks everything into ~/.config + $HOME
  README.md
```

## Restore on a new machine

```bash
git clone <this-repo> ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` symlinks:

- `~/dotfiles/fastfetch` → `~/.config/fastfetch`
- `~/dotfiles/starship.toml` → `~/.config/starship.toml`
- `~/dotfiles/home/.*` → `~/.*` (e.g. `.zshrc`, with backup of existing files)

## Shell prompt (Starship, minimal)

Setup used here: macOS **Terminal.app** + **cmux** multiplexer (no Ghostty).

- Requires a Nerd Font: `brew install --cask font-jetbrains-mono-nerd-font` (already installed).
  Terminal.app can't take font config from a file — set it once manually:
  **Terminal → Settings → Profiles → Text → Font → Change → `JetBrainsMono Nerd Font`**
  (cmux inherits the Terminal.app font, nothing extra needed there).
- Prompt is two lines: `directory on <git-branch> <status>` then a green `❯` (red when last command failed).
- Shows node/python versions only inside project dirs, command duration only over 2s.
- Tweak it in `starship.toml`, then open a new terminal — no reinstall needed (symlinked).

## Fastfetch image (Terminal.app + cmux)

- The Geto PNG already renders in your cmux setup via the `kitty` graphics type — keep it.
- Config: `fastfetch/config.jsonc` → `logo.source = ~/.config/fastfetch/assets/geto-rounded.png`, `logo.type = kitty`, `logo.width = 30`.
- Slimmed to ~10 lines (title, os, uptime, shell, terminal, cpu, memory, disk, Directory) so text fits the image height.
- `Directory` is a `command` module running `pwd` — it shows the folder you ran fastfetch from, and updates every time fastfetch runs (e.g. `cd /tmp && fastfetch` shows `/tmp`).
- Live-updating path without re-running isn't a fastfetch thing — your shell prompt already does that. Don't auto-run fastfetch on every `cd` (it re-renders the image each time and gets noisy).

### Always on top (new terminal + after `clear`)

`home/.zshrc` contains:

```zsh
if command -v fastfetch >/dev/null 2>&1 && [[ -o interactive ]] && [[ -t 1 ]]; then
  fastfetch
  alias clear='command clear && fastfetch'
fi
```

- New interactive terminal → fastfetch runs once at the top.
- `clear` → clears then re-runs fastfetch, so it's always back on top.
- Guarded by `[[ -t 1 ]]` so scripts, pipes, and agent shells stay clean.

### If image doesn't show

1. Run `fastfetch --show-errors` to see why.
2. If the terminal lacks image support, edit `config.jsonc` and change `"type": "kitty"` → `"type": "chafa"` (ASCII fallback, works everywhere).
3. After changing logo type without touching the file, run `fastfetch --logo-cache regen` once.

## Add more configs later

Just drop any `~/.config/<app>` folder in here with the same name, e.g. `fish/`, then re-run `./install.sh` and push.
