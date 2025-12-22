#!/usr/bin/env zsh
# -*- coding: utf-8 -*-

sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

if [ -f "$HOME/.default-cargo-crates" ]; then
  mv "$HOME/.default-cargo-crates" "$HOME/.default-cargo-crates.bak.$(date +%Y%m%d%H%M%S)"
fi
cat << "EOF" > "$HOME/.default-cargo-crates"
exa
hexyl
sd
svgbob_cli
xh
EOF

if [ -f "$HOME/.p10k.zsh" ]; then
  mv "$HOME/.p10k.zsh" "$HOME/.p10k.zsh.bak.$(date +%Y%m%d%H%M%S)"
fi
cp "$(dirname "$0")/.p10k.zsh" "$HOME/.p10k.zsh"

if [ -f "$HOME/.profile" ]; then
  mv "$HOME/.profile" "$HOME/.profile.bak.$(date +%Y%m%d%H%M%S)"
fi
cat << "EOF" > "$HOME/.profile"
# -*- coding: utf-8 -*-

export ANTHROPIC_API_KEY=""
export ANTHROPIC_AUTH_TOKEN="test"
export ANTHROPIC_BASE_URL="http://127.0.0.1:3456"
export API_TIMEOUT_MS="600000"
export DISABLE_COST_WARNINGS="true"
export DISABLE_TELEMETRY="true"
export NO_PROXY="127.0.0.1"

export OLLAMA_CONTEXT_LENGTH=8192
export OLLAMA_FLASH_ATTENTION=1
export OLLAMA_KEEP_ALIVE=60m
export OLLAMA_MAX_LOADED_MODELS=2
export OLLAMA_NUM_PARALLEL=2

unset CLAUDE_CODE_USE_BEDROCK
EOF

if [ -f "$HOME/.zimrc" ]; then
  mv "$HOME/.zimrc" "$HOME/.zimrc.bak.$(date +%Y%m%d%H%M%S)"
fi
curl -o "$HOME/.zimrc" https://raw.githubusercontent.com/zimfw/zimfw/refs/heads/master/src/templates/zimrc

cat << "EOF" >> "$HOME/.zimrc"
zmodule asdf
zmodule fasd
zmodule fzf
zmodule gradle/gradle-completion
zmodule joke/zim-minikube
zmodule joke/zim-yq
zmodule homebrew --if-ostype 'darwin*'
zmodule ohmyzsh/ohmyzsh --root plugins/vim-interaction
zmodule romkatv/powerlevel10k --use degit
EOF

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

if ! grep -q "p10k-instant-prompt" "$HOME/.zshrc" 2>/dev/null; then
cat >> "$HOME/.zshrc" << "EOF"
if [ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
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
EOF
fi

if ! grep -q "p10k.zsh" "$HOME/.zshrc" 2>/dev/null; then
cat >> "$HOME/.zshrc" << "EOF"
if [ -f "$HOME/.p10k.zsh" ]; then
  source "$HOME/.p10k.zsh"
fi
EOF
fi

sudo xcode-select --install
sudo softwareupdate --install-rosetta --agree-to-license

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

brew install asdf ast-grep bandwhich bat coreutils curl difftastic dust fd fzf git httpie hwatch jq mas openssl readline rename ripgrep-all sqlite3 xz yq zimfw zsh
brew install --cask docker google-chrome httpie-desktop jetbrains-toolbox visual-studio-code

. "$HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh"

sed -i.bak "
\|^[[:space:]]*fpath=($HOME/.docker/completions \\\$fpath)|{
  N
  N
  s|^\(.*\)\n\(.*\)\n\(.*\)|#\\1\n#\\2\n#\\3| ;
}
" "$HOME/.zshrc"

asdf plugin add rust
asdf install rust "$(asdf list all rust | grep -E '^[0-9]+(\.[0-9]+){1,2}$' | sort -V | tail -n 1)"
asdf set -u rust "$(asdf list all rust | grep -E '^[0-9]+(\.[0-9]+){1,2}$' | sort -V | tail -n 1)"

asdf plugin add nodejs
asdf install nodejs "$(asdf list all nodejs | grep -E '^24(\.[0-9]+){1,2}$' | sort -V | tail -n 1)"
asdf set -u nodejs "$(asdf list all nodejs | grep -E '^24(\.[0-9]+){1,2}$' | sort -V | tail -n 1)"

asdf plugin add golang
asdf install golang "$(asdf list all golang | grep -E '^[0-9]+(\.[0-9]+){1,2}$' | sort -V | tail -n 1)"
asdf set -u golang "$(asdf list all golang | grep -E '^[0-9]+(\.[0-9]+){1,2}$' | sort -V | tail -n 1)"

asdf plugin add python
asdf install python "$(asdf list all python | grep -E '^3\.13(\.[0-9]+){0,1}$' | sort -V | tail -n 1)"
asdf set -u python "$(asdf list all python | grep -E '^3\.13(\.[0-9]+){0,1}$' | sort -V | tail -n 1)"

asdf plugin add uv
asdf install uv "$(asdf list all uv | grep -E '^[0-9]+(\.[0-9]+){0,2}$' | sort -V | tail -n 1)"
asdf set -u uv "$(asdf list all uv | grep -E '^[0-9]+(\.[0-9]+){0,2}$' | sort -V | tail -n 1)"

asdf plugin add java
asdf install java "$(asdf list all java | grep '^liberica-8u' | sort -V | tail -n 1)"
asdf install java "$(asdf list all java | grep '^liberica-11\.' | sort -V | tail -n 1)"
asdf install java "$(asdf list all java | grep '^liberica-17\.' | sort -V | tail -n 1)"
asdf install java "$(asdf list all java | grep '^liberica-21\.' | sort -V | tail -n 1)"
asdf install java "$(asdf list all java | grep '^liberica-25\.' | sort -V | tail -n 1)"
asdf set -u java "$(asdf list all java | grep '^liberica-21\.' | sort -V | tail -n 1)"

asdf plugin add perl
asdf install perl "$(asdf list all perl | grep -E '^[0-9]+(\.[0-9]+){1,2}$' | sort -V | tail -n 1)"
asdf set -u perl "$(asdf list all perl | grep -E '^[0-9]+(\.[0-9]+){1,2}$' | sort -V | tail -n 1)"

# mkdir -p $HOME/Projects/local
# mkdir -p $HOME/.minikube/certs
# brew install gh glab minikube
# minikube start --embed-certs
# wget -O $HOME/Downloads/Ollama.dmg https://ollama.com/download/Ollama.dmg
