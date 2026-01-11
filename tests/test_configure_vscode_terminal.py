import importlib.util
import json
from pathlib import Path

config_path = Path(__file__).resolve().parents[1] / "configure-vscode-terminal.py"
spec = importlib.util.spec_from_file_location("configure_vscode_terminal", config_path)
assert spec is not None
configure_vscode_terminal = importlib.util.module_from_spec(spec)
assert spec.loader is not None
spec.loader.exec_module(configure_vscode_terminal)  # type: ignore[arg-type]

backup_settings = configure_vscode_terminal.backup_settings
confirm = configure_vscode_terminal.confirm
get_recommended_settings = configure_vscode_terminal.get_recommended_settings
handle_choice = configure_vscode_terminal.handle_choice
load_settings = configure_vscode_terminal.load_settings
merge_settings = configure_vscode_terminal.merge_settings
save_settings = configure_vscode_terminal.save_settings
main = configure_vscode_terminal.main


def test_backup_settings_creates_copy(tmp_path: Path) -> None:
    settings_file = tmp_path / "user" / "settings.json"
    settings_file.parent.mkdir(parents=True)
    settings_file.write_text(json.dumps({"terminal": True}))

    backup = backup_settings(settings_file)
    assert backup is not None
    assert backup.exists()


def test_load_settings_handles_missing_file(tmp_path: Path) -> None:
    settings_file = tmp_path / "settings.json"
    assert load_settings(settings_file) == {}


def test_save_settings_creates_file(tmp_path: Path) -> None:
    settings_file = tmp_path / "settings.json"
    save_settings(settings_file, {"terminal.integrated.localEchoEnabled": True})
    assert settings_file.exists()
    assert (
        json.loads(settings_file.read_text())["terminal.integrated.localEchoEnabled"]
        is True
    )


def test_load_settings_reads_existing_file(tmp_path: Path) -> None:
    settings_file = tmp_path / "settings.json"
    settings_file.parent.mkdir(parents=True, exist_ok=True)
    settings_file.write_text(json.dumps({"terminal.integrated.localEchoEnabled": True}))

    result = load_settings(settings_file)
    assert result["terminal.integrated.localEchoEnabled"] is True


def test_load_settings_handles_invalid_json(tmp_path: Path, capsys) -> None:
    settings_file = tmp_path / "settings.json"
    settings_file.write_text("{invalid json")
    result = load_settings(settings_file)
    assert result == {}
    assert "Failed to parse settings file" in capsys.readouterr().out


def test_merge_settings_adds_missing_keys() -> None:
    recommended = get_recommended_settings()
    merged, updated_keys = merge_settings({}, recommended)
    assert set(updated_keys) == set(recommended.keys())
    assert merged["terminal.integrated.localEchoEnabled"] is False


def test_merge_settings_overwrites_existing_value() -> None:
    existing = {
        "terminal.integrated.scrollback": 42,
    }
    recommended = get_recommended_settings()
    merged, updated_keys = merge_settings(existing, recommended)
    assert "terminal.integrated.scrollback" in updated_keys
    assert merged["terminal.integrated.scrollback"] == 10000


def test_handle_choice_recommended() -> None:
    settings, message = handle_choice("1")
    assert message == "Applying recommended settings."
    assert "terminal.integrated.enablePersistentSessions" not in settings


def test_handle_choice_advanced() -> None:
    settings, message = handle_choice("2")
    assert message == "Applying recommended + advanced settings."
    assert settings["terminal.integrated.enablePersistentSessions"] is False


def test_confirm_yes(monkeypatch) -> None:
    monkeypatch.setattr("builtins.input", lambda: "y")
    assert confirm("Save these settings? (y/n): ") is True


def test_confirm_no(monkeypatch) -> None:
    monkeypatch.setattr("builtins.input", lambda: "n")
    assert confirm("Save these settings? (y/n): ") is False


def test_confirm_cancel(monkeypatch, capsys) -> None:
    monkeypatch.setattr(
        "builtins.input", lambda: (_ for _ in ()).throw(KeyboardInterrupt)
    )
    assert confirm("Save these settings? (y/n): ") is False
    captured = capsys.readouterr()
    assert "Operation cancelled" in captured.out


def test_main_applies_recommended(tmp_path: Path, monkeypatch) -> None:
    inputs = iter(["1", "y"])
    settings_file = tmp_path / "settings.json"

    monkeypatch.setattr("builtins.input", lambda prompt="": next(inputs))
    monkeypatch.setattr(
        configure_vscode_terminal,
        "get_vscode_settings_path",
        lambda: settings_file,
    )
    monkeypatch.setattr(
        configure_vscode_terminal,
        "backup_settings",
        lambda path: None,
    )

    main()

    stored = json.loads(settings_file.read_text())
    assert stored["terminal.integrated.localEchoEnabled"] is False


def test_main_applies_advanced(tmp_path: Path, monkeypatch) -> None:
    inputs = iter(["2", "y"])
    settings_file = tmp_path / "settings.json"

    monkeypatch.setattr("builtins.input", lambda prompt="": next(inputs))
    monkeypatch.setattr(
        configure_vscode_terminal,
        "get_vscode_settings_path",
        lambda: settings_file,
    )
    monkeypatch.setattr(
        configure_vscode_terminal,
        "backup_settings",
        lambda path: None,
    )

    main()

    stored = json.loads(settings_file.read_text())
    assert stored["terminal.integrated.enablePersistentSessions"] is False


def test_main_handles_cancel(monkeypatch, tmp_path: Path, capsys) -> None:
    monkeypatch.setattr("builtins.input", lambda prompt="": "3")
    settings_file = tmp_path / "settings.json"

    monkeypatch.setattr(
        configure_vscode_terminal,
        "get_vscode_settings_path",
        lambda: settings_file,
    )
    monkeypatch.setattr(
        configure_vscode_terminal,
        "backup_settings",
        lambda path: None,
    )

    main()

    assert not settings_file.exists()
    captured = capsys.readouterr()
    assert "Operation cancelled" in captured.out
