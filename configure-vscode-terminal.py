#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from __future__ import annotations

import json
import shutil
from datetime import datetime
from pathlib import Path
from typing import Any, Dict, List, Optional, Tuple


def get_vscode_settings_path() -> Path:
    """Return the VSCode user settings.json location."""
    home = Path.home()
    settings_path = home.joinpath(
        "Library",
        "Application Support",
        "Code",
        "User",
        "settings.json",
    )
    return settings_path


def backup_settings(settings_path: Path) -> Optional[Path]:
    """Create a timestamped backup of the settings file, if it exists."""
    if not settings_path.exists():
        return None

    backup_dir = settings_path.parent.parent / "Backups"
    backup_dir.mkdir(exist_ok=True)

    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_path = backup_dir / f"settings.json.backup.{timestamp}"

    shutil.copy2(settings_path, backup_path)
    print(f"✓ Backup complete: {backup_path}")
    return backup_path


def load_settings(settings_path: Path) -> Dict[str, Any]:
    """Load existing settings or return an empty dict when no file is present."""
    if not settings_path.exists():
        print("ℹ No existing settings found; creating new file.")
        return {}

    try:
        with open(settings_path, "r", encoding="utf-8") as f:
            content = f.read().strip()
            if not content:
                return {}
            return json.loads(content)
    except json.JSONDecodeError as decode_error:
        print(f"⚠ Failed to parse settings file: {decode_error}")
        print("  Backing up the file and starting fresh.")
        return {}


def get_recommended_settings() -> Dict[str, Any]:
    """Return the recommended terminal settings."""
    return {
        "terminal.integrated.localEchoEnabled": False,
        "terminal.integrated.shellIntegration.enabled": False,
        "terminal.integrated.scrollback": 10000,
    }


def get_advanced_settings() -> Dict[str, Any]:
    """Return additional settings for severe terminal issues."""
    return {
        "terminal.integrated.enablePersistentSessions": False,
    }


def merge_settings(
    existing: Dict[str, Any], new_settings: Dict[str, Any]
) -> Tuple[Dict[str, Any], List[str]]:
    """Return merged settings plus the list of updated keys."""
    merged = existing.copy()
    updated_keys: List[str] = []

    for key, value in new_settings.items():
        if key not in merged or merged[key] != value:
            merged[key] = value
            updated_keys.append(key)

    return merged, updated_keys


def save_settings(settings_path: Path, settings: Dict[str, Any]) -> None:
    """Persist settings to disk in a human-friendly JSON format."""
    settings_path.parent.mkdir(parents=True, exist_ok=True)

    with open(settings_path, "w", encoding="utf-8") as f:
        json.dump(settings, f, indent=2, ensure_ascii=False)
        f.write("\n")

    print(f"✓ Settings saved to: {settings_path}")


def print_menu() -> None:
    """Print the interactive menu options."""
    print("\nChoose which settings to apply:")
    print("1. Recommended defaults")
    print("2. Recommended + advanced settings (for persistent issues)")
    print("3. Cancel")


def handle_choice(choice: str) -> Tuple[Dict[str, Any], str]:
    """Return settings and a description for the given menu choice."""
    recommended = get_recommended_settings()
    if choice == "2":
        recommended.update(get_advanced_settings())
        return recommended, "Applying recommended + advanced settings."
    return recommended, "Applying recommended settings."


def confirm(prompt: str) -> bool:
    """Ask the user to confirm and return True if they agree."""
    print(prompt, end="")
    try:
        response = input().strip().lower()
    except (KeyboardInterrupt, EOFError):
        print("\n\n✗ Operation cancelled.")
        return False

    return response in ("y", "yes")


def main() -> None:
    print("=" * 60)
    print("Applying VS Code terminal optimization settings")
    print("=" * 60)
    print()

    settings_path = get_vscode_settings_path()
    print(f"Settings file location: {settings_path}")
    print()

    backup_settings(settings_path)
    existing_settings = load_settings(settings_path)

    print_menu()

    try:
        choice = input("\nSelection (1-3): ").strip()
    except (KeyboardInterrupt, EOFError):
        print("\n\n✗ Operation cancelled.")
        return

    if choice == "3":
        print("\n✗ Operation cancelled.")
        return

    settings_to_apply, message = handle_choice(choice)
    print(f"\n{message}")

    merged_settings, updated_keys = merge_settings(existing_settings, settings_to_apply)

    if updated_keys:
        print(f"\nThe following {len(updated_keys)} settings will be added/updated:")
        for key in updated_keys:
            old_value = existing_settings.get(key, "(not set)")
            new_value = merged_settings[key]
            print(f"  • {key}")
            print(f"    {old_value} → {new_value}")
    else:
        print("\nAll recommended settings are already applied.")
        return

    if not confirm("\nSave these settings? (y/n): "):
        return

    save_settings(settings_path, merged_settings)
    print("\n" + "=" * 60)
    print("✓ Done!")
    print("=" * 60)
    print("\nNext steps:")
    print("1. Restart VSCode.")
    print("2. Open a new terminal to verify the settings took effect.")
    print("\nIf issues persist, rerun and choose the advanced option.")


if __name__ == "__main__":
    try:
        main()
    except Exception as exc:
        print(f"\n✗ Error occurred: {exc}")
        import traceback

        traceback.print_exc()
        exit(1)
