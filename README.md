# Initial Settings

[English](README.en.md)

macOS 개발 환경 자동 설정 스크립트입니다.

## 개요

이 프로젝트는 새로운 macOS 머신에 필수적인 개발 도구, 쉘 설정, 애플리케이션 등을 자동으로 설치하고 구성하는 쉘 스크립트(`init.zsh`)를 제공합니다.

## 주요 기능

- **쉘 설정**: [Zimfw](https://github.com/zimfw/zimfw)와 [Starship](https://starship.rs/) 프롬프트를 사용하여 Zsh를 설정합니다.
- **패키지 관리**: Homebrew를 설치하고 엄선된 CLI 도구 및 GUI 애플리케이션 목록을 설치합니다.
- **버전 관리**: `asdf`를 사용하여 다음 언어들의 런타임 버전을 관리하도록 설정합니다:
  - Rust
  - Node.js
  - Go
  - Python
- **Rust 기반 도구**: `.default-cargo-crates`에 정의된 유용한 CLI 도구들을 설치합니다:
  - `bat`: `cat`의 현대적인 대안 (구문 강조)
  - `bandwhich`: 네트워크 대역폭 사용량 모니터링
  - `difftastic`: 문법을 인식하는 구조적 diff 도구
  - `exa`: `ls`의 현대적인 대안
  - `du-dust`: `du`의 직관적인 대안
  - `fd-find`: `find`의 빠르고 사용자 친화적인 대안
  - `hexyl`: 터미널용 16진수 뷰어
  - `hwatch`: `watch` 명령어의 현대적인 대안
  - `ripgrep`: 매우 빠른 `grep` 대안
  - `sd`: `sed`의 직관적인 대안 (Find & Replace)
  - `svgbob_cli`: ASCII 아트를 SVG로 변환
  - `xh`: 빠르고 사용하기 쉬운 HTTP 클라이언트
- **시스템 설정**:
  - SSH 키 생성 (`ed25519`).
  - Xcode Command Line Tools 및 Rosetta 설치.
  - `.profile`을 통한 환경 변수 설정.

## 사용 방법

### 1. 프로젝트 다운로드

#### 옵션 A: Git 사용 (권장)

```zsh
git clone https://github.com/ririnto/initial-settings.git
cd initial-settings
```

#### 옵션 B: 터미널에서 다운로드

```zsh
curl -L -o initial-settings.zip https://github.com/ririnto/initial-settings/archive/refs/heads/main.zip
unzip initial-settings.zip
cd initial-settings-main
```

#### 옵션 C: 직접 다운로드

Git이나 터미널 사용이 어렵다면 아래 링크에서 소스 코드를 다운로드하여 압축을 해제한 뒤 해당 폴더로 이동하세요.

- [Source Code (ZIP)](https://github.com/ririnto/initial-settings/archive/refs/heads/main.zip)

### 2. 초기화 스크립트 실행

```zsh
./init.zsh
```

> **참고**: Xcode Command Line Tools 및 Rosetta 설치 등의 작업을 진행하기 위해 관리자 권한(`sudo`)이 필요합니다.

## 구성 파일

- `init.zsh`: 메인 진입점 스크립트입니다.
- `.zimrc`: Zim Zsh 프레임워크 설정 파일입니다.
- `.profile`: 환경 변수 및 경로 설정 파일입니다.
- `.default-cargo-crates`: 추적/설치할 Cargo 크레이트 목록입니다.

## 요구 사항

- macOS (Apple Silicon 또는 Intel)
- 인터넷 연결 (패키지 다운로드용)

## VSCode 터미널 최적화

GitHub Copilot 사용 시 터미널에 긴 입력이 발생하면 VSCode 터미널이 멈추는 문제가 있을 수 있습니다. 아래 설정으로 해결할 수 있습니다.

### 자동 설정 (권장)

Python 스크립트로 권장 설정을 자동으로 적용할 수 있습니다:

#### 옵션 1: VSCode 태스크 사용

1. VSCode에서 `Cmd+Shift+P` → "Tasks: Run Task" 실행
2. "VSCode 터미널 최적화 설정 적용" 선택
3. 안내에 따라 설정 적용

#### 옵션 2: 터미널에서 직접 실행

```zsh
python3 configure-vscode-terminal.py
```

> **참고**: 기존 설정은 `~/Library/Application Support/Code/Backups/` 경로에 자동으로 백업됩니다

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

| 설정                           | 권장 값 | 설명                                                                                       |
| ------------------------------ | ------- | ------------------------------------------------------------------------------------------ |
| **`localEchoEnabled`**         | `false` | 터미널 입력 예측 기능 비활성화. 긴 입력 시 로컬 예측과 실제 서버 응답 간 충돌 방지         |
| **`shellIntegration.enabled`** | `false` | VSCode-쉘 통합 기능 비활성화. PTY 상호작용 시 발생하는 처리 오버헤드 제거                  |
| **`scrollback`**               | `10000` | 터미널 히스토리 버퍼 크기 증가. 더 많은 출력 라인 보존. 큰 출력 시 렌더링 성능에 영향 가능 |
| **`enablePersistentSessions`** | `false` | 세션 영속성 비활성화. 복원 과정에서 발생하는 복잡한 상태 관리 충돌 방지                    |

### 즉각적인 임시 해결책

- **터미널 정리**: `Cmd+K`
- **새 터미널 열기**: `Cmd+Shift+\``
- **VSCode 재시작**: 설정 변경 후 재시작 권장

## IntelliJ 터미널 최적화

IntelliJ IDEA 및 JetBrains IDE에서도 유사한 터미널 멈춤 문제가 발생할 수 있습니다.

### 터미널 설정

Preferences/Settings 열기: `Cmd+,` (macOS)

`Preferences` → `Tools` → `Terminal`에서:

| 옵션                       | 권장 설정        | 설명                                                                     |
| -------------------------- | ---------------- | ------------------------------------------------------------------------ |
| **Shell integration**      | 체크 해제        | IDE와 쉘의 통합 기능 비활성화. 긴 입/출력 시 발생하는 처리 오버헤드 제거 |
| **Override IDE shortcuts** | 체크 해제 (선택) | IDE 단축키 재정의 방지. 터미널 자체 단축키와의 충돌 감소                 |
| **Audible bell**           | 체크 해제        | 벨 소리 비활성화. 불필요한 알림으로 인한 UI 중단 방지                    |

### 외부 터미널 사용

`Preferences` → `Tools` → `Terminal`:

- **Shell path**: 실제 셸 경로 사용 (예: `/bin/zsh` 또는 `/bin/bash`)

외부 애플리케이션에서 터미널 열기:

- 터미널 탭에서 오른쪽 클릭 → "Open in Terminal" (IDE 버전에 따라 다를 수 있음)

### 주요 설정 파일 위치

IntelliJ 설정은 XML 파일로 저장됩니다.

위치: `~/Library/Application Support/JetBrains/<Product><Version>/options/`

설정 파일 예시 (제품/버전에 따라 다를 수 있음):

- `terminal.xml` - 터미널 설정
- `editor.xml` - 에디터 설정
- `ide.general.xml` - 일반 IDE 설정
