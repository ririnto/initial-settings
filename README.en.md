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

#### Option A: Using Git (Recommended)

```zsh
git clone https://github.com/ririnto/initial-settings.git
cd initial-settings
```

#### Option B: Download via Terminal

```zsh
curl -L -o initial-settings.zip https://github.com/ririnto/initial-settings/archive/refs/heads/main.zip
unzip initial-settings.zip
cd initial-settings-main
```

#### Option C: Manual Download

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

## VSCode Terminal Optimization

When using GitHub Copilot, long terminal inputs may cause VSCode terminal to freeze. The following settings can resolve this issue.

### Automatic Configuration (Recommended)

You can automatically apply the recommended settings using a Python script:

#### Option 1: Using VSCode Task

1. In VSCode, press `Cmd+Shift+P` → "Tasks: Run Task"
2. Select "VSCode 터미널 최적화 설정 적용"
3. Follow the instructions to apply settings

#### Option 2: Run Directly in Terminal

```zsh
python3 configure-vscode-terminal.py
```

> **Note**: Existing settings are automatically backed up to `~/Library/Application Support/Code/Backups/`

### Manual Configuration

You can also add settings directly to VSCode settings file (`settings.json`).

Open settings file: `Cmd+Shift+P` → "Preferences: Open User Settings (JSON)"

#### Basic Settings (Most Cases)

```json
{
  "terminal.integrated.localEchoEnabled": false,
  "terminal.integrated.shellIntegration.enabled": false,
  "terminal.integrated.scrollback": 10000
}
```

#### Additional Settings for Severe Issues

```json
{
  "terminal.integrated.enablePersistentSessions": false
}
```

### Key Settings Explanation

| Setting                        | Recommended Value | Description                                                                                                                   |
| ------------------------------ | ----------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| **`localEchoEnabled`**         | `false`           | Disables terminal input prediction. Prevents conflicts between local prediction and actual server response during long inputs |
| **`shellIntegration.enabled`** | `false`           | Disables VSCode-shell integration. Removes processing overhead during PTY interaction                                         |
| **`scrollback`**               | `10000`           | Increases terminal history buffer size for preserving more output lines. May affect rendering performance with large outputs  |
| **`enablePersistentSessions`** | `false`           | Disables session persistence. Prevents complex state management conflicts during restoration                                  |

### Quick Temporary Solutions

- **Clear terminal**: `Cmd+K`
- **Open new terminal**: `Cmd+Shift+\``
- **Restart VSCode**: Recommended after changing settings

## IntelliJ Terminal Optimization

Similar terminal freezing issues may occur in IntelliJ IDEA and JetBrains IDEs.

### Terminal Settings

Open Preferences/Settings: `Cmd+,` (macOS)

`Preferences` → `Tools` → `Terminal`:

| Option                     | Recommended Setting | Description                                                                          |
| -------------------------- | ------------------- | ------------------------------------------------------------------------------------ |
| **Shell integration**      | Uncheck             | Disables IDE-shell integration. Removes processing overhead during long input/output |
| **Override IDE shortcuts** | Uncheck (optional)  | Prevents IDE shortcut redefinition. Reduces conflicts with terminal's own shortcuts  |
| **Audible bell**           | Uncheck             | Disables bell sound. Prevents UI interruption from unnecessary notifications         |

### Using External Terminal

`Preferences` → `Tools` → `Terminal`:

- **Shell path**: Use actual shell path (e.g., `/bin/zsh` or `/bin/bash`)

To open terminal in an external application:

- Right-click on terminal tab → "Open in Terminal" (may vary by IDE version)

### Key Configuration File Locations

IntelliJ settings are stored as XML files.

Location: `~/Library/Application Support/JetBrains/<Product><Version>/options/`

Example configuration files (may vary by product/version):

- `terminal.xml` - Terminal settings
- `editor.xml` - Editor settings
- `ide.general.xml` - General IDE settings
