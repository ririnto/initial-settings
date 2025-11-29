#!/usr/bin/env zsh
# -*- coding: utf-8 -*-

sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

if [ -f $HOME/.default-cargo-crates ]; then
  mv $HOME/.default-cargo-crates $HOME/.default-cargo-crates.bak.$(date +%Y%m%d%H%M%S)
fi
cp $(dirname "$0")/.default-cargo-crates $HOME/.default-cargo-crates

if [ -f $HOME/.p10k.zsh ]; then
  mv $HOME/.p10k.zsh $HOME/.p10k.zsh.bak.$(date +%Y%m%d%H%M%S)
fi
cp $(dirname "$0")/.p10k.zsh $HOME/.p10k.zsh

if [ -f $HOME/.profile ]; then
  mv $HOME/.profile $HOME/.profile.bak.$(date +%Y%m%d%H%M%S)
fi
cp $(dirname "$0")/.profile $HOME/.profile

if [ -f $HOME/.zimrc ]; then
  mv $HOME/.zimrc $HOME/.zimrc.bak.$(date +%Y%m%d%H%M%S)
fi
cp $(dirname "$0")/.zimrc $HOME/.zimrc

if [ ! -f $HOME/.ssh/id_ed25519 ]; then
  ssh-keygen -t ed25519 -f $HOME/.ssh/id_ed25519 -N ""
fi

if ! grep -q ".profile" "$HOME/.zprofile" 2>/dev/null; then
cat >> $HOME/.zprofile << "EOF"
if [ -f "$HOME/.profile" ]; then
  source "$HOME/.profile"
fi
EOF
fi

if ! grep -q "p10k-instant-prompt" "$HOME/.zshrc" 2>/dev/null; then
cat >> $HOME/.zshrc << "EOF"
if [ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
EOF
fi

if ! grep -q "zimfw" "$HOME/.zshrc" 2>/dev/null; then
cat >> $HOME/.zshrc << "EOF"
ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
ZIM_CONFIG_FILE=${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc}
if [ -f ${ZIM_CONFIG_FILE} ] && ([ ! -f ${ZIM_HOME}/init.zsh ] || [ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE} ]); then
  if (( ${+commands[brew]} )); then
    ZIM_FW_INIT_SCRIPT=$(brew --prefix zimfw)/share/zimfw.zsh
    if [ -f ${ZIM_FW_INIT_SCRIPT} ]; then
      source ${ZIM_FW_INIT_SCRIPT} init
    fi
  fi
fi

# Initialize modules.
if [ -f ${ZIM_HOME}/init.zsh ]; then
  source ${ZIM_HOME}/init.zsh
fi
EOF
fi

if ! grep -q "p10k.zsh" "$HOME/.zshrc" 2>/dev/null; then
cat >> $HOME/.zshrc << "EOF"
if [ -f $HOME/.p10k.zsh ]; then
  source $HOME/.p10k.zsh
fi
EOF
fi

sudo xcode-select --install
sudo softwareupdate --install-rosetta --agree-to-license

if [[ $(uname -m) == "x86_64" ]]; then
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

brew install coreutils xz yq rename openssl readline sqlite3 asdf zimfw mas httpie git
brew install --cask docker google-chrome jetbrains-toolbox visual-studio-code httpie-desktop

. "$HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh"

sed -i.bak "
\|^[[:space:]]*fpath=($HOME/.docker/completions \\\$fpath)|{
  N
  N
  s|^\(.*\)\n\(.*\)\n\(.*\)|#\\1\n#\\2\n#\\3| ;
}
" "$HOME/.zshrc"

asdf plugin add rust
asdf install rust stable
asdf set -u rust stable

asdf plugin add nodejs
asdf install nodejs latest:24
asdf set -u nodejs latest:24

asdf plugin add golang
asdf install golang latest
asdf set -u golang latest

asdf list all python
asdf install python latest:3.13
asdf set -u python latest:3.13

# mkdir -p $HOME/Projects/local
# mkdir -p $HOME/.minikube/certs
# brew install glab gh minikube
# minikube start --embed-certs
# wget -O $HOME/Downloads/Ollama.dmg https://ollama.com/download/Ollama.dmg
