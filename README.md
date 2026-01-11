# :tada: Initial Settings

[English](README.en.md)

macOS 개발 환경 자동 설정 스크립트입니다.

## :sparkles: 개요

이 프로젝트는 새로운 macOS 머신에 필수 개발 도구, 쉘 설정, 애플리케이션 등을
자동으로 설치/구성하는 스크립트(`init.zsh`)를 제공합니다.

## :dart: 주요 기능

- **셸 설정**: [Zimfw](https://github.com/zimfw/zimfw) +
  [Starship](https://starship.rs/) 기반으로 Zsh를 구성합니다.
- **패키지 관리**: Homebrew를 설치하고 엄선된 CLI 도구 및 GUI 앱을 설치합니다.
- **버전 관리 (asdf)**: `asdf`로 다음 런타임/도구 버전을 설치/기본값 설정합니다.
  - Rust, Node.js, Go, Python, Java (Liberica), Perl, uv
- **Rust 기반 도구 (Cargo)**: `$HOME/.default-cargo-crates`에 정의된 유틸리티를
  관리합니다.
  - `exa`, `hexyl`, `sd`, `svgbob_cli`, `xh`
- **시스템 설정**:
  - SSH 키 생성 (`ed25519`)
  - Xcode Command Line Tools 및 Rosetta 설치
  - `.profile`을 통한 환경 변수 설정

> **참고**: Homebrew로 설치되는 도구 목록은 시간이 지나며 변경될 수 있습니다.
> 최신 내용은 `init.zsh`의 `brew install ...` 구간을 참고하세요.

## :rocket: 사용 방법

### 1. 프로젝트 다운로드

#### Option A: Git 사용 (권장)

```zsh
git clone https://github.com/ririnto/initial-settings.git
cd initial-settings
```

#### Option B: 터미널에서 다운로드

```zsh
curl -L -o initial-settings.zip https://github.com/ririnto/initial-settings/archive/refs/heads/main.zip
unzip initial-settings.zip
cd initial-settings-main
```

#### Option C: 직접 다운로드

Git이나 터미널 사용이 어렵다면 아래 링크에서 소스 코드를 내려받아
압축을 해제한 뒤 폴더로 이동하세요.

- [Source Code (ZIP)](https://github.com/ririnto/initial-settings/archive/refs/heads/main.zip)

### 2. 초기화 스크립트 실행

```zsh
./init.zsh
```

> **참고**: Xcode Command Line Tools / Rosetta 설치 등 일부 작업은
> 관리자 권한(`sudo`)이 필요합니다.

## :file_folder: 구성 파일

| 파일                    | 설명                         |
| ----------------------- | ---------------------------- |
| `init.zsh`              | 메인 진입점 스크립트         |
| `.zimrc`                | Zim Zsh 프레임워크 설정 파일 |
| `.profile`              | 환경 변수 및 경로 설정 파일  |
| `.default-cargo-crates` | 추적/설치할 Cargo crate 목록 |

## :clipboard: 요구 사항

- macOS (Apple Silicon 또는 Intel)
- 인터넷 연결 (패키지 다운로드용)

---

## :ice_cube: VSCode 터미널 최적화

GitHub Copilot 사용 시 터미널에 긴 입력이 발생하면
VSCode 터미널이 멈추는 문제가 있을 수 있습니다.
아래 설정으로 완화할 수 있습니다.

### 자동 설정 (권장)

Python 스크립트로 권장 설정을 자동 적용할 수 있습니다.

#### Option 1: VSCode Task 사용

1. VSCode에서 `Cmd+Shift+P` → "Tasks: Run Task" 실행
2. "VSCode 터미널 최적화 설정 적용" 선택
3. 안내에 따라 설정 적용

#### Option 2: 터미널에서 직접 실행

```zsh
python3 configure-vscode-terminal.py
```

> **참고**: 기존 설정은 `~/Library/Application Support/Code/Backups/`
> 경로에 자동 백업됩니다.

### 수동 설정

VSCode 설정 파일(`settings.json`)에 직접 추가할 수도 있습니다.

설정 파일 열기: `Cmd+Shift+P` → "Preferences: Open User Settings (JSON)"

#### 기본 설정 (대부분의 경우)

```json
{
  "terminal.integrated.localEchoEnabled": false,
  "terminal.integrated.shellIntegration.enabled": false,
  "terminal.integrated.scrollback": 10000
}
```

#### 심각한 문제 시 추가 설정

```json
{
  "terminal.integrated.enablePersistentSessions": false
}
```

### 주요 설정 설명

| 설정                       | 권장 값 | 설명                      |
| -------------------------- | ------- | ------------------------- |
| `localEchoEnabled`         | `false` | 터미널 입력 예측 비활성화 |
| `shellIntegration.enabled` | `false` | VSCode-셸 통합 비활성화   |
| `scrollback`               | `10000` | 터미널 히스토리 버퍼 증가 |
| `enablePersistentSessions` | `false` | 세션 영속성 비활성화      |

### 즉각적인 임시 해결책

- **터미널 정리**: `Cmd+K`
- **새 터미널 열기**: `` Cmd+Shift+` ``
- **VSCode 재시작**: 설정 변경 후 재시작 권장

## :ice_cube: IntelliJ 터미널 최적화

IntelliJ IDEA 및 JetBrains IDE에서도 유사한 터미널 멈춤 문제가
발생할 수 있습니다.

### 터미널 설정

Preferences/Settings 열기: `Cmd+,` (macOS)

`Preferences` → `Tools` → `Terminal`에서:

| 옵션                   | 권장 설정 | 설명                   |
| ---------------------- | --------- | ---------------------- |
| Shell integration      | 체크 해제 | IDE-셸 통합 비활성화   |
| Override IDE shortcuts | 체크 해제 | IDE 단축키 재정의 방지 |
| Audible bell           | 체크 해제 | 벨 소리 비활성화       |

### 외부 터미널 사용

`Preferences` → `Tools` → `Terminal`:

- **Shell path**: 실제 셸 경로 사용 (예: `/bin/zsh` 또는 `/bin/bash`)

외부 애플리케이션에서 터미널 열기:

- 터미널 탭에서 우클릭 → "Open in Terminal" (IDE 버전에 따라 다를 수 있음)

### 주요 설정 파일 위치

IntelliJ 설정은 XML 파일로 저장됩니다.

위치: `~/Library/Application Support/JetBrains/<Product><Version>/options/`

설정 파일 예시(제품/버전에 따라 다를 수 있음):

- `terminal.xml` - 터미널 설정
- `editor.xml` - 에디터 설정
- `ide.general.xml` - 일반 IDE 설정

## Developer workflow

1. `python3 -m venv .venv` *(already created; rerun if you delete the folder).*
2. `.venv/bin/pip install -e ".[dev]"` installs `ruff`, `pyright`, `pytest`, and `coverage` per `pyproject.toml`.
3. `.venv/bin/ruff check configure-vscode-terminal.py tests` for linting.
4. `.venv/bin/pyright` for type checks.
5. `.venv/bin/coverage run -m pytest` to execute tests and collect coverage.
6. `.venv/bin/coverage report` to inspect coverage metrics (aim for ≥90% on the CLI).
7. Rerun `python3 configure-vscode-terminal.py` only when you want to update your actual VS Code settings.
