#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
VSCode 터미널 최적화 설정 자동 적용 스크립트

GitHub Copilot 사용 시 터미널이 멈추는 문제를 해결하기 위해
VSCode settings.json에 권장 설정을 추가합니다.
"""

import json
import os
import shutil
from datetime import datetime
from pathlib import Path


def get_vscode_settings_path():
    """VSCode 사용자 설정 파일 경로 반환"""
    home = Path.home()
    settings_path = home.joinpath(
        "Library",
        "Application Support",
        "Code",
        "User",
        "settings.json"
    )
    return settings_path


def backup_settings(settings_path):
    """기존 설정 파일 백업"""
    if not settings_path.exists():
        return None

    backup_dir = settings_path.parent.parent / "Backups"
    backup_dir.mkdir(exist_ok=True)

    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_path = backup_dir / f"settings.json.backup.{timestamp}"

    shutil.copy2(settings_path, backup_path)
    print(f"✓ 기존 설정 백업 완료: {backup_path}")
    return backup_path


def load_settings(settings_path):
    """기존 설정 파일 로드 (없으면 빈 딕셔너리 반환)"""
    if not settings_path.exists():
        print("ℹ 기존 설정 파일이 없습니다. 새로 생성합니다.")
        return {}

    try:
        with open(settings_path, 'r', encoding='utf-8') as f:
            content = f.read().strip()
            if not content:
                return {}
            return json.loads(content)
    except json.JSONDecodeError as e:
        print(f"⚠ 설정 파일 파싱 오류: {e}")
        print("  기존 설정을 백업하고 새로 시작합니다.")
        return {}


def get_recommended_settings():
    """권장 터미널 설정 반환"""
    return {
        "terminal.integrated.localEchoEnabled": False,
        "terminal.integrated.shellIntegration.enabled": False,
        "terminal.integrated.scrollback": 10000,
    }


def get_advanced_settings():
    """심각한 문제용 추가 설정"""
    return {
        "terminal.integrated.enablePersistentSessions": False,
    }


def merge_settings(existing, new_settings):
    """기존 설정과 새 설정 병합"""
    merged = existing.copy()
    updated_keys = []

    for key, value in new_settings.items():
        if key not in merged or merged[key] != value:
            merged[key] = value
            updated_keys.append(key)

    return merged, updated_keys


def save_settings(settings_path, settings):
    """설정을 파일에 저장"""
    settings_path.parent.mkdir(parents=True, exist_ok=True)

    with open(settings_path, 'w', encoding='utf-8') as f:
        json.dump(settings, f, indent=2, ensure_ascii=False)
        f.write('\n')  # 마지막 줄바꿈 추가

    print(f"✓ 설정 저장 완료: {settings_path}")


def main():
    print("=" * 60)
    print("VSCode 터미널 최적화 설정 적용")
    print("=" * 60)
    print()

    # 1. 설정 파일 경로 확인
    settings_path = get_vscode_settings_path()
    print(f"설정 파일 위치: {settings_path}")
    print()

    # 2. 기존 설정 백업
    if settings_path.exists():
        backup_settings(settings_path)

    # 3. 기존 설정 로드
    existing_settings = load_settings(settings_path)

    # 4. 적용할 설정 선택
    print("\n적용할 설정을 선택하세요:")
    print("1. 기본 설정 (권장)")
    print("2. 기본 + 고급 설정 (심각한 문제용)")
    print("3. 취소")

    try:
        choice = input("\n선택 (1-3): ").strip()
    except (KeyboardInterrupt, EOFError):
        print("\n\n✗ 취소되었습니다.")
        return

    if choice == "3":
        print("\n✗ 취소되었습니다.")
        return

    # 5. 설정 병합
    recommended = get_recommended_settings()

    if choice == "2":
        recommended.update(get_advanced_settings())
        print("\n기본 + 고급 설정을 적용합니다.")
    else:
        print("\n기본 설정을 적용합니다.")

    merged_settings, updated_keys = merge_settings(
        existing_settings,
        recommended
    )

    # 6. 변경 내역 출력
    if updated_keys:
        print(f"\n다음 {len(updated_keys)}개 설정이 추가/변경됩니다:")
        for key in updated_keys:
            old_value = existing_settings.get(key, "(없음)")
            new_value = merged_settings[key]
            print(f"  • {key}")
            print(f"    {old_value} → {new_value}")
    else:
        print("\n모든 권장 설정이 이미 적용되어 있습니다.")
        return

    # 7. 확인 후 저장
    print("\n설정을 저장하시겠습니까? (y/n): ", end="")
    try:
        confirm = input().strip().lower()
    except (KeyboardInterrupt, EOFError):
        print("\n\n✗ 취소되었습니다.")
        return

    if confirm in ('y', 'yes', 'ㅛ'):
        save_settings(settings_path, merged_settings)
        print("\n" + "=" * 60)
        print("✓ 완료!")
        print("=" * 60)
        print("\n다음 단계:")
        print("1. VSCode를 재시작하세요.")
        print("2. 터미널을 새로 열어 설정이 적용되었는지 확인하세요.")
        print("\n문제가 지속되면 기본 설정에서 고급 설정으로 변경해 보세요.")
    else:
        print("\n✗ 취소되었습니다.")


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"\n✗ 오류 발생: {e}")
        import traceback
        traceback.print_exc()
        exit(1)
