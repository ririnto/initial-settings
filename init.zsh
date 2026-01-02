#!/usr/bin/env zsh
# -*- coding: utf-8 -*-

set -euo pipefail

BACKUP_DIR="$HOME/.local/backup"
mkdir -p "$BACKUP_DIR"

backup_if_exists() {
  local file_path="$1"
  if [ -f "$file_path" ]; then
    mv "$file_path" "$BACKUP_DIR/$(basename "$file_path").bak.$(date +%Y%m%d%H%M%S)"
  fi
}

sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
SUDO_KEEPALIVE_PID=$!
trap 'kill "${SUDO_KEEPALIVE_PID}" 2>/dev/null || true' EXIT INT TERM HUP

backup_if_exists "$HOME/.default-cargo-crates"
cat << "EOF" > "$HOME/.default-cargo-crates"
exa
hexyl
sd
svgbob_cli
xh
EOF

backup_if_exists "$HOME/.profile"
cat << "EOF" > "$HOME/.profile"
# -*- coding: utf-8 -*-

export OLLAMA_CONTEXT_LENGTH=8192
export OLLAMA_FLASH_ATTENTION=1
export OLLAMA_KEEP_ALIVE=60m
export OLLAMA_MAX_LOADED_MODELS=2
export OLLAMA_NUM_PARALLEL=2
EOF

backup_if_exists "$HOME/.zimrc"
curl --fail --location --silent --show-error -o "$HOME/.zimrc" https://raw.githubusercontent.com/zimfw/zimfw/refs/heads/master/src/templates/zimrc

cat << "EOF" >> "$HOME/.zimrc"
zmodule asdf
zmodule fasd
zmodule fzf
zmodule gradle/gradle-completion
zmodule joke/zim-minikube
zmodule joke/zim-yq
zmodule homebrew --if-ostype 'darwin*'
zmodule ohmyzsh/ohmyzsh --root plugins/vim-interaction
zmodule joke/zim-starship
EOF

mkdir -p "$HOME/.ssh"
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
  ssh-keygen -t ed25519 -f "$HOME/.ssh/id_ed25519" -N ""
fi

if ! grep -q ".profile" "$HOME/.zprofile" 2>/dev/null; then
cat >> "$HOME/.zprofile" << "EOF"
if [ -f "$HOME/.profile" ]; then
  source "$HOME/.profile"
fi
EOF
fi

if ! grep -q "zimfw" "$HOME/.zshrc" 2>/dev/null; then
cat >> "$HOME/.zshrc" << "EOF"
ZIM_HOME="${ZDOTDIR:-${HOME}}/.zim"
ZIM_CONFIG_FILE="${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc}"
if [ -f "${ZIM_CONFIG_FILE}" ] && ([ ! -f "${ZIM_HOME}/init.zsh" ] || [ ! "${ZIM_HOME}/init.zsh" -nt "${ZIM_CONFIG_FILE}" ]); then
  if (( ${+commands[brew]} )); then
    ZIM_FW_INIT_SCRIPT="$(brew --prefix zimfw)/share/zimfw.zsh"
    if [ -f "${ZIM_FW_INIT_SCRIPT}" ]; then
      source "${ZIM_FW_INIT_SCRIPT}" init
    fi
  fi
fi

# If INTELLIJ_ENVIRONMENT_READER is set, the IDE handles environment initialization, so initialize asdf instead.
if [ -n "$INTELLIJ_ENVIRONMENT_READER" ]; then
  if [ -f ~/.zim/modules/asdf/init.zsh ]; then
    source ~/.zim/modules/asdf/init.zsh
  fi
else
  # If Zim is installed and init.zsh exists, source that script to initialize Zim modules and plugins.
  if [ -f "${ZIM_HOME}/init.zsh" ]; then
    source "${ZIM_HOME}/init.zsh"
  fi
fi

if command -v ccr &>/dev/null; then
  eval "$(ccr activate)"
fi

alias sed=gsed
EOF
fi

if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install || true
fi

if [ "$(uname -m)" = "arm64" ]; then
  if ! pkgutil --pkg-info com.apple.pkg.RosettaUpdateAuto >/dev/null 2>&1; then
    sudo softwareupdate --install-rosetta --agree-to-license
  fi
fi

if [ "$(uname -m)" = "x86_64" ]; then
  HOMEBREW_PREFIX="/usr/local"
else
  HOMEBREW_PREFIX="/opt/homebrew"
fi

if [ -f "$HOMEBREW_PREFIX/bin/brew" ]; then
  eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
fi

if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
fi

brew install asdf ast-grep bandwhich bash bat coreutils curl difftastic diffutils dust fd findutils fzf gawk git gnu-getopt gnu-sed gnu-tar grep httpie hwatch jq mas moreutils openssl readline rename ripgrep-all sqlite3 xz yq zimfw zsh
brew install --cask docker google-chrome httpie-desktop jetbrains-toolbox visual-studio-code

git config --global core.pager cat

. "$HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh"

ensure_asdf_plugin() {
  local plugin_name="$1"
  if ! asdf plugin list | grep -qx "$plugin_name"; then
    asdf plugin add "$plugin_name"
  fi
}

sed -i.bak "
\|^[[:space:]]*fpath=($HOME/.docker/completions \\\$fpath)|{
  N
  N
  s|^\(.*\)\n\(.*\)\n\(.*\)|#\\1\n#\\2\n#\\3| ;
}
" "$HOME/.zshrc"

ensure_asdf_plugin rust
asdf install rust "$(asdf list all rust | grep -E '^[0-9]+(\.[0-9]+){1,2}$' | sort -V | tail -n 1)"
asdf set -u rust "$(asdf list all rust | grep -E '^[0-9]+(\.[0-9]+){1,2}$' | sort -V | tail -n 1)"

ensure_asdf_plugin nodejs
asdf install nodejs "$(asdf list all nodejs | grep -E '^24(\.[0-9]+){1,2}$' | sort -V | tail -n 1)"
asdf set -u nodejs "$(asdf list all nodejs | grep -E '^24(\.[0-9]+){1,2}$' | sort -V | tail -n 1)"

ensure_asdf_plugin golang
asdf install golang "$(asdf list all golang | grep -E '^[0-9]+(\.[0-9]+){1,2}$' | sort -V | tail -n 1)"
asdf set -u golang "$(asdf list all golang | grep -E '^[0-9]+(\.[0-9]+){1,2}$' | sort -V | tail -n 1)"

ensure_asdf_plugin python
asdf install python "$(asdf list all python | grep -E '^3\.13(\.[0-9]+){0,1}$' | sort -V | tail -n 1)"
asdf set -u python "$(asdf list all python | grep -E '^3\.13(\.[0-9]+){0,1}$' | sort -V | tail -n 1)"

ensure_asdf_plugin uv
asdf install uv "$(asdf list all uv | grep -E '^[0-9]+(\.[0-9]+){0,2}$' | sort -V | tail -n 1)"
asdf set -u uv "$(asdf list all uv | grep -E '^[0-9]+(\.[0-9]+){0,2}$' | sort -V | tail -n 1)"

ensure_asdf_plugin java
asdf install java "$(asdf list all java | grep '^liberica-8u' | sort -V | tail -n 1)"
asdf install java "$(asdf list all java | grep '^liberica-11\.' | sort -V | tail -n 1)"
asdf install java "$(asdf list all java | grep '^liberica-17\.' | sort -V | tail -n 1)"
asdf install java "$(asdf list all java | grep '^liberica-21\.' | sort -V | tail -n 1)"
asdf install java "$(asdf list all java | grep '^liberica-25\.' | sort -V | tail -n 1)"
asdf set -u java "$(asdf list all java | grep '^liberica-21\.' | sort -V | tail -n 1)"

ensure_asdf_plugin perl
asdf install perl "$(asdf list all perl | grep -E '^[0-9]+(\.[0-9]+){1,2}$' | sort -V | tail -n 1)"
asdf set -u perl "$(asdf list all perl | grep -E '^[0-9]+(\.[0-9]+){1,2}$' | sort -V | tail -n 1)"

# brew install --cask codex
# brew install --cask claude-code
# brew install --cask copilot-cli
# mkdir -p $HOME/Projects/local
# mkdir -p $HOME/.minikube/certs
# brew install gh glab minikube
# minikube start --embed-certs
# wget -O $HOME/Downloads/Ollama.dmg https://ollama.com/download/Ollama.dmg
