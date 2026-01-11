# Project Overview

## Purpose

- Bootstrap a macOS development environment via `init.zsh`, installing Homebrew, asdf-managed runtimes (Rust, Node.js, Go, Python, Java/Liberica, Perl, uv), CLI/GUI tools, configuring Zsh with Zim/Starship, and managing Cargo crates/env vars.

## Platform

- macOS (Apple Silicon + Intel); uses `sudo` for system installs (Xcode CLT, Rosetta) and keeps sudo alive during the run.

## Structure

- Root files: `init.zsh`, `README.md`, `README.en.md`, `.gitignore`, `configure-vscode-terminal.py`; Serena metadata in `.serena/` (tracked).
- Generated at runtime: `.profile`, `.zimrc`, `.default-cargo-crates` in `$HOME`.

## Key Assets

- `init.zsh` (entrypoint) orchestrates installs and backups.
- `configure-vscode-terminal.py` optionally tunes VSCode terminal settings.
- `.gitignore` ignores `.idea/` and `__pycache__/`; `.serena/` remains tracked.

## Notable Behavior

- Backs up existing config files before overwriting.
- Installs/sets asdf plugins to the latest matching versions.
- Ends by clearing quarantine on `~/.cache/uv` via `sudo xattr -dr com.apple.quarantine ~/.cache/uv`.

## Instructions

- Follow AGENTS.md: avoid formatting-only changes; keep scope necessary/sufficient; do not remove `.serena/` from tracking.
- Prefer existing conventions and avoid new dependencies/patterns without approval.
