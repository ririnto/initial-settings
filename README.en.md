# :tada: Initial Settings

[한국어](README.md)

Automated setup script for macOS development environment.

## :sparkles: Overview

This project provides a shell script (`init.zsh`) to bootstrap a new macOS
machine with essential dev tools, shell configuration, and applications.

## :dart: Features

- **Shell configuration**: Sets up Zsh with
  [Zimfw](https://github.com/zimfw/zimfw) and
  [Starship](https://starship.rs/).
- **Package management**: Installs Homebrew and a curated list of CLI tools
  and GUI apps.
- **Version management (asdf)**: Installs and sets global versions for:
  - Rust, Node.js, Go, Python, Java (Liberica), Perl, uv
- **Rust-based tools (Cargo)**: Manages utilities defined in
  `$HOME/.default-cargo-crates`.
  - `exa`, `hexyl`, `sd`, `svgbob_cli`, `xh`
- **System setup**:
  - Generates SSH keys (`ed25519`).
  - Installs Xcode Command Line Tools and Rosetta.
  - Configures environment variables via `.profile`.

> **Note**: The Homebrew install list may evolve over time.
> See the `brew install ...` section in `init.zsh` for the latest.

## :rocket: Usage

### 1. Download the project

#### Option A: Using Git (Recommended)

```zsh
git clone https://github.com/ririnto/initial-settings.git
cd initial-settings
```

#### Option B: Download via terminal

```zsh
curl -L -o initial-settings.zip https://github.com/ririnto/initial-settings/archive/refs/heads/main.zip
unzip initial-settings.zip
cd initial-settings-main
```

#### Option C: Manual download

Download the source code from the link below, extract it, then navigate to
the folder.

- [Source Code (ZIP)](https://github.com/ririnto/initial-settings/archive/refs/heads/main.zip)

### 2. Run the initialization script

```zsh
./init.zsh
```

> **Note**: Administrator privileges (`sudo`) are required for installing
> Xcode Command Line Tools, Rosetta, etc.

## :file_folder: Configuration files

| File                    | Description                                  |
| ----------------------- | -------------------------------------------- |
| `init.zsh`              | The main entry point script                  |
| `.zimrc`                | Configuration for the Zim Zsh framework      |
| `.profile`              | Environment variables and path settings      |
| `.default-cargo-crates` | List of Cargo crates to be tracked/installed |

## :clipboard: Requirements

- macOS (Apple Silicon or Intel)
- Internet connection (for downloading packages)

---

## :ice_cube: VSCode terminal optimization

When using GitHub Copilot, long terminal inputs may cause the VSCode terminal
to freeze. The settings below can help.

### Automatic configuration (Recommended)

You can apply the recommended settings automatically via the Python script.

#### Option 1: Using a VSCode Task

1. In VSCode, press `Cmd+Shift+P` → "Tasks: Run Task"
2. Select "VSCode 터미널 최적화 설정 적용"
3. Follow the instructions

#### Option 2: Run directly in a terminal

```zsh
python3 configure-vscode-terminal.py
```

> **Note**: Existing settings are backed up to
> `~/Library/Application Support/Code/Backups/`.

### Manual configuration

You can also add settings directly to VSCode's `settings.json`.

Open settings: `Cmd+Shift+P` → "Preferences: Open User Settings (JSON)"

#### Basic settings (most cases)

```json
{
  "terminal.integrated.localEchoEnabled": false,
  "terminal.integrated.shellIntegration.enabled": false,
  "terminal.integrated.scrollback": 10000
}
```

#### Additional setting for severe issues

```json
{
  "terminal.integrated.enablePersistentSessions": false
}
```

### Key settings explanation

| Setting                    | Recommended | Description                     |
| -------------------------- | ----------- | ------------------------------- |
| `localEchoEnabled`         | `false`     | Disables local input prediction |
| `shellIntegration.enabled` | `false`     | Disables VSCode-shell integ.    |
| `scrollback`               | `10000`     | Increases history buffer size   |
| `enablePersistentSessions` | `false`     | Disables session persistence    |

### Quick temporary fixes

- **Clear terminal**: `Cmd+K`
- **Open new terminal**: `` Cmd+Shift+` ``
- **Restart VSCode**: Recommended after changing settings

## :ice_cube: IntelliJ terminal optimization

Similar terminal freezing issues may occur in IntelliJ IDEA and other
JetBrains IDEs.

### Terminal settings

Open Preferences/Settings: `Cmd+,` (macOS)

`Preferences` → `Tools` → `Terminal`:

| Option                 | Recommended | Description                     |
| ---------------------- | ----------- | ------------------------------- |
| Shell integration      | Uncheck     | Disables IDE-shell integration  |
| Override IDE shortcuts | Uncheck     | Prevents IDE shortcut conflicts |
| Audible bell           | Uncheck     | Disables bell sound             |

### Using an external terminal

`Preferences` → `Tools` → `Terminal`:

- **Shell path**: Use the actual shell path
  (e.g., `/bin/zsh` or `/bin/bash`)

To open a terminal in an external application:

- Right-click on the terminal tab → "Open in Terminal"
  (may vary by IDE version)

### Key configuration file locations

IntelliJ settings are stored as XML files.

Location: `~/Library/Application Support/JetBrains/<Product><Version>/options/`

Example files (may vary by product/version):

- `terminal.xml` - Terminal settings
- `editor.xml` - Editor settings
- `ide.general.xml` - General IDE settings
