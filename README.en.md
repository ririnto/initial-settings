# Initial Settings

[한국어](README.md)

Automated setup script for macOS development environment.

## Overview

This project provides a shell script (`init.zsh`) to bootstrap a new macOS machine with essential development tools, shell configurations, and applications.

## Features

- **Shell Configuration**: Sets up Zsh with [Zimfw](https://github.com/zimfw/zimfw) and [Starship](https://starship.rs/) prompt.
- **Package Management**: Installs Homebrew and a curated list of CLI tools and GUI applications.
- **Version Management**: Configures `asdf` for managing runtime versions of:
  - Rust
  - Node.js
  - Go
  - Python
- **Rust-based Tools**: Installs useful CLI tools defined in `.default-cargo-crates`:
  - `bat`: A modern alternative to `cat` with syntax highlighting.
  - `bandwhich`: Terminal bandwidth utilization monitor.
  - `difftastic`: A structural diff tool that understands syntax.
  - `exa`: A modern replacement for `ls`.
  - `du-dust`: A more intuitive version of `du`.
  - `fd-find`: A simple, fast, and user-friendly alternative to `find`.
  - `hexyl`: A command-line hex viewer.
  - `hwatch`: A modern alternative to the `watch` command.
  - `ripgrep`: A line-oriented search tool that recursively searches for a regex pattern.
  - `sd`: Intuitive find & replace CLI (`sed` alternative).
  - `svgbob_cli`: Converts ASCII diagrams to SVG.
  - `xh`: Friendly and fast tool for sending HTTP requests.
- **System Setup**:
  - Generates SSH keys (`ed25519`).
  - Installs Xcode Command Line Tools and Rosetta.
  - Configures environment variables via `.profile`.

## Usage

### 1. Download Project

**Option A: Using Git (Recommended)**

```zsh
git clone https://github.com/ririnto/initial-settings.git
cd initial-settings
```

**Option B: Download via Terminal**

```zsh
curl -L -o initial-settings.zip https://github.com/ririnto/initial-settings/archive/refs/heads/main.zip
unzip initial-settings.zip
cd initial-settings-main
```

**Option C: Manual Download**
If you prefer, download the source code from the link below and extract it, then navigate to the folder.

- [Source Code (ZIP)](https://github.com/ririnto/initial-settings/archive/refs/heads/main.zip)

### 2. Run Initialization Script

```zsh
./init.zsh
```

> **Note**: Administrator privileges (`sudo`) are required for installing Xcode Command Line Tools, Rosetta, etc.

## Configuration Files

- `init.zsh`: The main entry point script.
- `.zimrc`: Configuration for the Zim Zsh framework.
- `.profile`: Environment variables and path settings.
- `.default-cargo-crates`: List of Cargo crates to be tracked/installed.

## Requirements

- macOS (Apple Silicon or Intel)
- Internet connection (for downloading packages)
