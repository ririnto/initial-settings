# -*- coding: utf-8 -*-

export OLLAMA_MAX_LOADED_MODELS=2
export OLLAMA_CONTEXT_LENGTH=8192
export OLLAMA_NUM_PARALLEL=4
export ANTHROPIC_BASE_URL="http://127.0.0.1:3456"
export ANTHROPIC_AUTH_TOKEN="ignore-me"

if [[ $(uname -m) == "x86_64" ]]; then
  HOMEBREW_PREFIX="/usr/local"
else
  HOMEBREW_PREFIX="/opt/homebrew"
fi

if [ -f "$HOMEBREW_PREFIX/bin/brew" ]; then
  eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
fi
