# Initial Settings

[English](README.en.md)

macOS 개발 환경 자동 설정 스크립트입니다.

## 개요

이 프로젝트는 새로운 macOS 머신에 필수적인 개발 도구, 쉘 설정, 애플리케이션 등을 자동으로 설치하고 구성하는 쉘 스크립트(`init.zsh`)를 제공합니다.

## 주요 기능

- **쉘 설정**: [Zimfw](https://github.com/zimfw/zimfw)와 [Powerlevel10k](https://github.com/romkatv/powerlevel10k) 테마를 사용하여 Zsh를 설정합니다.
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

**옵션 A: Git 사용 (권장)**

```zsh
git clone https://github.com/ririnto/initial-settings.git
cd initial-settings
```

**옵션 B: 터미널에서 다운로드**

```zsh
curl -L -o initial-settings.zip https://github.com/ririnto/initial-settings/archive/refs/heads/main.zip
unzip initial-settings.zip
cd initial-settings-main
```

**옵션 C: 직접 다운로드**
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
- `.p10k.zsh`: Powerlevel10k 프롬프트 설정 파일입니다.
- `.profile`: 환경 변수 및 경로 설정 파일입니다.
- `.default-cargo-crates`: 추적/설치할 Cargo 크레이트 목록입니다.

## 요구 사항

- macOS (Apple Silicon 또는 Intel)
- 인터넷 연결 (패키지 다운로드용)
