
# opencode
export PATH=/Users/kunal/.opencode/bin:$PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm
export PNPM_HOME='/Users/kunal/Library/pnpm'
case ":$PATH:" in
  ":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end

# bun completions
[ -s "/Users/kunal/.bun/_bun" ] && source "/Users/kunal/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

. "$HOME/.local/bin/env"

# fastfetch — always on top (new shell + after clear)
# Only in interactive terminals so scripts/pipes stay clean.
if command -v fastfetch >/dev/null 2>&1 && [[ -o interactive ]] && [[ -t 1 ]]; then
  fastfetch
  alias clear='command clear && fastfetch'
fi
