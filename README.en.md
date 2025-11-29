# Initial Settings

Automated setup script for macOS development environment.

## Overview

This project provides a shell script (`init.zsh`) to bootstrap a new macOS machine with essential development tools, shell configurations, and applications.

## Features

- **Shell Configuration**: Sets up Zsh with [Zimfw](https://github.com/zimfw/zimfw) and [Powerlevel10k](https://github.com/romkatv/powerlevel10k) theme.
- **Package Management**: Installs Homebrew and a curated list of CLI tools and GUI applications.
- **Version Management**: Configures `asdf` for managing runtime versions of:
  - Rust
  - Node.js
  - Go
  - Python
- **System Setup**:
  - Generates SSH keys (`ed25519`).
  - Installs Xcode Command Line Tools and Rosetta.
  - Configures environment variables via `.profile`.

## Usage

1. Clone this repository:

   ```zsh
   git clone https://github.com/ririnto/initial-settings.git
   cd initial-settings
   ```

2. Run the initialization script:

   ```zsh
   ./init.zsh
   ```

   > **Note**: The script requires `sudo` privileges for some operations (e.g., `sudo -v` at the start).

## Configuration Files

- `init.zsh`: The main entry point script.
- `.zimrc`: Configuration for the Zim Zsh framework.
- `.p10k.zsh`: Configuration for the Powerlevel10k prompt.
- `.profile`: Environment variables and path settings.
- `.default-cargo-crates`: List of Cargo crates to be tracked/installed.

## Requirements

- macOS (Apple Silicon or Intel)
- Internet connection (for downloading packages)
