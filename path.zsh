# =========================================================
# ZERO POLLUTION PATH SYSTEM (Oh My Zsh)
# file: ~/.oh-my-zsh/custom/path.zsh
# =========================================================

# -------------------------
# 1. BASE CLEAN PATH
# -------------------------
_reset_path() {
  export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
}

# -------------------------
# 2. CLEAN FILTER
# -------------------------
_clean_path() {
  export PATH=$(echo "$PATH" \
    | sed 's/# docker//g' \
    | sed 's/::/:/g' \
    | sed 's/:$//')
}

# -------------------------
# 3. DEBUG TOOL
# -------------------------
check_path() {
  echo "$PATH" | tr ':' '\n' | nl | while read i p; do
    if [[ -z "$p" ]]; then
      echo "$i EMPTY"
    elif [[ "$p" == *"#"* ]]; then
      echo "$i BAD: $p"
    elif [[ "$p" == /System/* || "$p" == /var/run/* ]]; then
      echo "$i SYSTEM: $p"
    elif [ -d "$p" ]; then
      echo "$i OK: $p"
    else
      echo "$i MISS: $p"
    fi
  done
}

# -------------------------
# 4. HOMEBREW
# -------------------------
_load_brew() {
  eval "$(/opt/homebrew/bin/brew shellenv)"

  export PATH="/opt/homebrew/opt/curl/bin:$PATH"
  export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
  export LDFLAGS="-L/opt/homebrew/opt/libpq/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/libpq/include"
}

# -------------------------
# 5. GUI TOOLS LAYER
# -------------------------
_load_gui() {
  export PATH="$HOME/.orbstack/bin:$PATH"
  export PATH="$HOME/Library/Application Support/JetBrains/Toolbox/scripts:$PATH"
}

# -------------------------
# 6. CLI TOOLS
# -------------------------
_load_cli() {
  source <(fzf --zsh)
  export TLDR_LANGUAGE="zh"
  eval $(thefuck --alias)
}

# -------------------------
# 7. NVM (Node)
# -------------------------
_load_nvm() {
  export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
}

# -------------------------
# 8. CONDA (Python)
# -------------------------
_load_conda() {
  __conda_setup="$('/opt/homebrew/Caskroom/miniforge/base/bin/conda' 'shell.zsh' 'hook' 2>/dev/null)"
  if [ $? -eq 0 ]; then
    eval "$__conda_setup"
  fi
  unset __conda_setup
}

# -------------------------
# 9. SDKMAN (Java)
# -------------------------
_load_sdkman() {
  export SDKMAN_DIR="$HOME/.sdkman"
  [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
}

# -------------------------
# 10. MASTER INIT (唯一入口)
# -------------------------
init_path() {
  _reset_path

  _load_brew
  _load_gui
  _load_cli

  _load_nvm
  _load_conda
  _load_sdkman

  _clean_path
}

init_path