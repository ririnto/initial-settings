# Suggested Commands

## Git

- `git status`, `git diff`, `git add`, `git commit` – standard workflow; `.serena/` is tracked (do not add to gitignore).

## Setup

- `./init.zsh` – main entrypoint; requires `sudo`, installs Homebrew/asdf runtimes and tools, clears quarantine on `~/.cache/uv` at end.

## Editor Helpers

- `python3 configure-vscode-terminal.py` – optional VSCode terminal tuning script.

## Inspection

- `brew list` / `asdf list` – inspect installed packages/runtimes if debugging init flow.

## System Basics

- `ls`, `cd`, `cat`, `more`, `grep` (gnu variants installed by init).
