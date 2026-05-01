<!-- @formatter:off -->

# Workspace Setup

## 사용자 설정

LLM이 이후 설정을 진행할 수 있게 사용자가 먼저 Homebrew와 shell profile을 준비한다.

### Homebrew 설치

Homebrew를 설치한다.

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Shell profile 설정

`~/.zprofile`에 다음 내용을 추가한다.

```sh
if [ -f ~/.profile ]; then
    . ~/.profile
fi
```

`~/.profile`에 다음 내용을 추가한다.

```sh
eval "$(/opt/homebrew/bin/brew shellenv zsh)"
export PATH="$PATH:$HOME/.asdf/shims"
export PATH="$HOME/.bun/bin:$PATH"
```

### 인증 토큰 설정

API 키 방식으로 사용할 때는 `~/.profile`에 인증 토큰을 추가한다. 구독 기반 로그인 방식을 사용하는 경우에는 생략한다.

```sh
export ANTHROPIC_AUTH_TOKEN="sk-..."
```

### asdf와 bun 준비

새로운 터미널에서 asdf를 설치한다.

```sh
brew install asdf
```

bun 플러그인을 추가한다.

```sh
asdf plugin add bun
```

bun 1.x 최신 버전을 설치하고 user scope 기본값으로 설정한다.

```sh
asdf install bun "$(asdf list all bun | sed 's/^[[:space:]*]*//' | grep -E '^1\.' | sort -V | tail -n 1)"
asdf set -u bun "$(asdf list bun | sed 's/^[[:space:]*]*//' | grep -E '^1\.' | sort -V | tail -n 1)"
```

### LLM CLI 설치

LLM CLI가 필요하면 아래 예시 중 사용할 도구를 선택해 설치한다. API 키 대신 로그인 방식으로 사용하거나, 동일 목적의 다른 CLI를 사용해도 된다.

```sh
bun add -g @anthropic-ai/claude-code
bun add -g @openai/codex
bun add -g opencode-ai
```

---

## agent 설정

### 진행 원칙

설치는 각 단계에서 사용자 동의를 구한 뒤 진행한다. 사용자가 전체 설치를 요청한 경우에는 MCP 서버 등록 단계를 제외하고 이 문서의 설치 항목을 모두 진행한다.

MCP 서버 등록 단계에서는 사용자가 전체 설치를 요청했더라도 반드시 설정할 MCP 목록을 다시 확인하고, 선택된 항목만 진행한다.

### Homebrew 의존성 설치

Python을 asdf로 설치하기 전에 빌드에 필요한 Homebrew 의존성을 먼저 설치한다.

| 패키지 | 방법 | 용도 |
| --- | --- | --- |
| openssl@3 | `brew install openssl@3` | SSL/TLS |
| readline | `brew install readline` | 대화형 셸 |
| sqlite | `brew install sqlite` | 데이터베이스 |
| xz | `brew install xz` | 압축 |
| zlib | `brew install zlib` | 압축 |
| git | `brew install git` | 버전 관리 |
| git-lfs | `brew install git-lfs` | 대용량 파일 관리 |
| ripgrep | `brew install ripgrep` | 빠른 파일/텍스트 검색 |
| kotlin-lsp | `brew install JetBrains/utils/kotlin-lsp` | Kotlin Language Server |

Git 저장소 초기화 시 기본 브랜치가 `main`이 되도록 전역 설정한다.

```sh
git config --global init.defaultBranch main
```

### asdf

#### 플러그인 추가

| 플러그인 | 추가 명령 |
| --- | --- |
| python | `asdf plugin add python` |
| golang | `asdf plugin add golang` |
| nodejs | `asdf plugin add nodejs` |
| java | `asdf plugin add java` |
| rust | `asdf plugin add rust` |
| uv | `asdf plugin add uv` |
| bun | `asdf plugin add bun` |

#### 런타임 설치

asdf로 설치할 런타임 버전을 고를 때는 표의 기준을 기본값으로 삼되, 사용자의 추가 선호가 있는지 먼저 질문한다.

| 런타임 | 구현 | 버전 기준 | 조회 패턴 |
| --- | --- | --- | --- |
| python | CPython | 3.13.x 최신 (기본) | `^3\.13\.` |
| golang | Go | 1.26.x 최신 (기본) | `^1\.26\.` |
| nodejs | Node.js | 24.x 최신 LTS (기본) | `^24\.` |
| nodejs | Node.js | 22.x 최신 Maintenance | `^22\.` |
| nodejs | Node.js | 20.x 최신 Maintenance | `^20\.` |
| java | Liberica JDK | 25.x 최신 LTS (기본) | `^liberica-25\.` |
| java | Liberica JDK | 21.x 최신 LTS | `^liberica-21\.` |
| java | Liberica JDK | 17.x 최신 LTS | `^liberica-17\.` |
| java | Liberica JDK | 11.x 최신 Legacy | `^liberica-11\.` |
| java | Liberica JDK | 8.x 최신 Legacy | `^liberica-8u` |
| rust | rustup | 1.x 최신 (기본) | `^1\.` |
| uv | uv | 0.11.x 최신 (기본) | `^0\.11\.` |
| bun | Bun | 1.3.x 최신 (기본) | `^1\.3\.` |

조회 패턴으로 설치 가능한 최신 버전을 확인한 뒤, 확인된 버전을 명시해 설치한다.

```sh
asdf install java "$(asdf list all java | sed 's/^[[:space:]*]*//' | grep -E '^liberica-21\.' | sort -V | tail -n 1)"
```

기본 버전은 설치된 버전 중 원하는 메이저 버전을 조회해 user scope에 설정한다.

```sh
asdf set -u java "$(asdf list java | sed 's/^[[:space:]*]*//' | grep -E '^liberica-25\.' | sort -V | tail -n 1)"
```

#### 설치 원칙

- asdf로 의존성을 설치할 때는 `latest` 또는 `stable`을 지정하지 않고, 설치할 버전을 명시적으로 작성한다.
- 설치할 버전은 설치 이전에 `asdf list all`로 조회 가능한 패턴을 사용해 결정한다.

### 앱 설치

| 순서 | 앱 | 방법 |
| --- | --- | --- |
| 1 | FiraCode Nerd Font | `brew install --cask font-fira-code-nerd-font` |
| 2 | Starship | `brew install starship` |
| 3 | iTerm2 | `brew install --cask iterm2` |
| 4 | Visual Studio Code | `brew install --cask visual-studio-code` |
| 5 | JetBrains Toolbox | `brew install --cask jetbrains-toolbox` |
| 6 | Docker | `brew install --cask docker` |
| 7 | ZimFW | `curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh \| zsh` |

Starship은 아이콘 표시를 위해 Nerd Font가 필요하다. 폰트 설치 후 사용하는 터미널의 font 설정에서 Nerd Font를 선택한다.

### Bun 글로벌 패키지

| 패키지 | 설치 명령 | 용도 |
| --- | --- | --- |
| opencode-ai | `bun add -g opencode-ai` | 터미널 AI 코딩 에이전트 |
| @openai/codex | `bun add -g @openai/codex` | OpenAI Codex CLI |
| @anthropic-ai/claude-code | `bun add -g @anthropic-ai/claude-code` | Claude Code CLI |

### VS Code 확장

VS Code 확장은 `code --install-extension` 명령으로 설치한다.

| 순서 | 확장 | 설치 명령 | 용도 |
| --- | --- | --- | --- |
| 1 | EditorConfig.EditorConfig | `code --install-extension EditorConfig.EditorConfig` | EditorConfig 지원 |
| 2 | DavidAnson.vscode-markdownlint | `code --install-extension DavidAnson.vscode-markdownlint` | Markdown linting 및 스타일 검사 |
| 3 | ms-python.python | `code --install-extension ms-python.python` | Python 언어 지원 |
| 4 | charliermarsh.ruff | `code --install-extension charliermarsh.ruff` | Python Ruff linter 및 formatter 지원 |
| 5 | ms-vscode.vscode-typescript-next | `code --install-extension ms-vscode.vscode-typescript-next` | TypeScript Nightly 기반 JS/TS 지원 |
| 6 | biomejs.biome | `code --install-extension biomejs.biome` | Web toolchain 지원 |
| 7 | golang.Go | `code --install-extension golang.Go` | Go 언어 지원 |
| 8 | redhat.vscode-yaml | `code --install-extension redhat.vscode-yaml` | YAML 언어 지원 및 Kubernetes syntax 지원 |
| 9 | rust-lang.rust-analyzer | `code --install-extension rust-lang.rust-analyzer` | Rust 언어 지원 |
| 10 | vscjava.vscode-java-pack | `code --install-extension vscjava.vscode-java-pack` | Java IntelliSense, debugging, testing, Maven/Gradle 지원 |
| 11 | vmware.vscode-boot-dev-pack | `code --install-extension vmware.vscode-boot-dev-pack` | Spring Boot 애플리케이션 개발 지원 |
| 12 | Kotlin LSP | `code --install-extension path/to/kotlin-lsp.vsix` | [Kotlin/kotlin-lsp](https://github.com/Kotlin/kotlin-lsp) 릴리스의 VSIX 설치 |

Kotlin LSP의 VS Code 확장은 Marketplace ID 기반 설치가 공식 문서에 명시되어 있지 않으므로, 릴리스에서 VSIX를 내려받아 설치한다.

### ZimFW 모듈

| 모듈 | 분류 |
| --- | --- |
| environment, git, input, termtitle, utility | 기본 (설치 시 기본 추가됨) |
| asdf, archive, fzf, homebrew, prompt-pwd, ssh, smite | 추가 설치 |
| duration-info, git-info, asciiship | 프롬프트 |
| zsh-completions, completion | 자동완성 |
| zsh-syntax-highlighting, zsh-history-substring-search, zsh-autosuggestions | 품질향상 |

### Claude Code MCP 서버 등록

MCP 서버를 등록하기 전에는 사용자에게 설정할 MCP 목록을 먼저 질문하고, 선택된 항목만 진행한다. 사용자가 전체 설치를 요청했더라도 이 확인은 생략하지 않는다.

MCP 서버는 `~/.claude.json`을 직접 수정하지 않고 `claude mcp add --scope user` 명령으로 user scope에 등록한다.

| 이름 | 타입 | 등록 명령 | 비고 |
| --- | --- | --- | --- |
| context7 | stdio | `claude mcp add --scope user context7 -- npx -y @upstash/context7-mcp` | 라이브러리 문서 조회 |
| docling | stdio | `claude mcp add --scope user docling -- uvx --with pip-system-certs --from=docling-mcp docling-mcp-server` | 문서 파싱 ([docling-project/docling](https://github.com/docling-project/docling)) |
| fetch | stdio | `claude mcp add --scope user fetch -- uvx --with pip-system-certs mcp-server-fetch --ignore-robots-txt` | URL → markdown |
| git | stdio | `claude mcp add --scope user git -- uvx --with pip-system-certs mcp-server-git` | Git 저장소 조작 |
| scrapling | stdio | `claude mcp add --scope user scrapling -- uvx --with pip-system-certs --from scrapling[ai] scrapling mcp` | 웹 스크래핑 ([D4Vinci/Scrapling](https://github.com/D4Vinci/Scrapling)) |
| exa | http | `claude mcp add --scope user --transport http exa https://mcp.exa.ai/mcp` | 웹 검색 |

등록 후에는 다음 명령으로 현재 등록 상태를 확인한다.

```sh
claude mcp list
```

위 명령은 user scope 설정 파일인 `~/.claude.json`에 다음과 같은 형태로 저장된다.

```json
{
  "mcpServers": {
    "context7": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp"]
    },
    "docling": {
      "type": "stdio",
      "command": "uvx",
      "args": ["--with", "pip-system-certs", "--from=docling-mcp", "docling-mcp-server"]
    },
    "fetch": {
      "type": "stdio",
      "command": "uvx",
      "args": ["--with", "pip-system-certs", "mcp-server-fetch", "--ignore-robots-txt"]
    },
    "git": {
      "type": "stdio",
      "command": "uvx",
      "args": ["--with", "pip-system-certs", "mcp-server-git"]
    },
    "scrapling": {
      "type": "stdio",
      "command": "uvx",
      "args": ["--with", "pip-system-certs", "--from", "scrapling[ai]", "scrapling", "mcp"]
    },
    "exa": {
      "type": "http",
      "url": "https://mcp.exa.ai/mcp"
    }
  }
}
```

### 설치 후 사용자 안내

#### iTerm2 설정

iTerm2를 사용하는 경우 다음 설정을 권장한다.

- 상단 바 -> iTerm2 -> Make iTerm2 Default Term 설정
- 상단 바 -> iTerm2 -> Install Shell Integration 설치
- 상단 바 -> iTerm2 -> Settings... -> Profiles -> Keys -> Key Bindings -> Presets... -> Terminal.app Compatibility 설정
- 상단 바 -> iTerm2 -> Settings... -> Profiles -> Text -> Font 설정을 MesloLGS Nerd Font Mono 등으로 변경

Nerd Font 설정은 Starship이 사용하는 아이콘을 표시하기 위해 필요하다.

#### Docker Desktop 설정

Docker Desktop은 다음 명령으로 실행한 뒤 약관 동의 및 기타 초기 설정을 완료한다.

```sh
open -a docker
```

Docker Settings에서는 `Send usage statistics` 비활성화를 권장한다.

Docker Desktop의 `Configure shell completions` 설정 시 `~/.zshrc`에 다음 내용이 추가될 수 있다.

```sh
fpath=($HOME/.docker/completions $fpath)
autoload -Uz compinit
compinit
```

`compinit` 관련 경고가 발생하면 `compinit` 라인을 주석 처리한다.

<!-- @formatter:on -->
