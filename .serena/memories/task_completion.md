# Task Completion Checklist

## Scope & Instructions

- Ensure changes align with AGENTS.md: minimal-but-sufficient scope, no formatting-only changes, keep `.serena/` tracked.

## Review

- Run `git status` to confirm only intended files changed.
- Stage with `git add` and review `git diff` for unintended edits.

## Optional Validation

- If init flow changed, optionally rerun `./init.zsh` on macOS (requires `sudo`; clears quarantine on `~/.cache/uv`).

## Documentation

- Document any manual verification steps; no automated tests are defined in this repo.

## Governance

- Avoid introducing new dependencies/patterns without approval; keep edits review-friendly and idempotent where possible.
