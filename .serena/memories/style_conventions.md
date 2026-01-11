# Style & Conventions

## Language

- zsh scripts with `#!/usr/bin/env zsh` and `set -euo pipefail` for strict handling.

## Formatting

- Two-space indentation; `if [ ... ]; then` / `fi`; commands explicit; avoid formatting-only changes per AGENTS.

## Structure

- Helper functions (e.g., `backup_if_exists`, `ensure_asdf_plugin`); linear install/config sections; brief intent-focused comments only when needed.

## Behavior

- Guard re-installs (`command -v brew`, `asdf plugin list`), back up existing files before overwriting, keep scripts idempotent where practical, keep `.serena/` tracked (not in gitignore).

## Governance

- Follow AGENTS priority and non-negotiables; no new dependencies/patterns without approval; keep edits review-friendly and minimal-but-sufficient.
