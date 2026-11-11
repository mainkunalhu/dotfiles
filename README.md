# dotfiles

Private backup of my `~/.config` — so I never have to rewrite configs from scratch.
Just pull and symlink.

Repo layout **mirrors** `~/.config`:

```text
dotfiles/
  fastfetch/
    config.jsonc
    assets/
      geto-rounded.png   <- rounded-corners image used by fastfetch
      geto-original.png  <- original upload
  install.sh             <- symlinks everything into ~/.config
  README.md
```

## Restore on a new machine

```bash
git clone <this-repo> ~/dotfiles
cd ~/dotfiles
./install.sh
fastfetch
```

`install.sh` symlinks:

- `~/dotfiles/fastfetch` → `~/.config/fastfetch`

## Fastfetch image (Ghostty)

- Terminal: Ghostty supports the `kitty` graphics protocol, so the Geto PNG shows on the left where ASCII used to be.
- Config: `fastfetch/config.jsonc` → `logo.source = ~/.config/fastfetch/assets/geto-rounded.png`, `logo.type = kitty`, `logo.width = 32`.
- Rounded corners were pre-baked into `geto-rounded.png` (transparent 180px radius mask) because fastfetch itself can't round images.

### If image doesn't show

1. In Ghostty, run `fastfetch --show-errors` to see why.
2. If terminal lacks kitty support, edit `config.jsonc` and change `"type": "kitty"` → `"type": "chafa"` (ASCII fallback, works everywhere).
3. For `kitty-direct` (fastest on Ghostty, PNG only) you must set both `width` + `height`.
4. After changing logo type without touching the file, run `fastfetch --logo-cache regen` once.

## Add more configs later

Just drop any `~/.config/<app>` folder in here with the same name, e.g. `fish/`, `ghostty/`, then re-run `./install.sh` and push.
