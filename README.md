# Initial Settings

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
- **시스템 설정**:
  - SSH 키 생성 (`ed25519`).
  - Xcode Command Line Tools 및 Rosetta 설치.
  - `.profile`을 통한 환경 변수 설정.

## 사용 방법

1. 저장소를 클론합니다:

   ```zsh
   git clone https://github.com/ririnto/initial-settings.git
   cd initial-settings
   ```

2. 초기화 스크립트를 실행합니다:

   ```zsh
   ./init.zsh
   ```

   > **참고**: 스크립트 실행 시 일부 작업(예: 시작 시 `sudo -v`)을 위해 관리자 권한(`sudo`)이 필요합니다.

## 구성 파일

- `init.zsh`: 메인 진입점 스크립트입니다.
- `.zimrc`: Zim Zsh 프레임워크 설정 파일입니다.
- `.p10k.zsh`: Powerlevel10k 프롬프트 설정 파일입니다.
- `.profile`: 환경 변수 및 경로 설정 파일입니다.
- `.default-cargo-crates`: 추적/설치할 Cargo 크레이트 목록입니다.

## 요구 사항

- macOS (Apple Silicon 또는 Intel)
- 인터넷 연결 (패키지 다운로드용)
