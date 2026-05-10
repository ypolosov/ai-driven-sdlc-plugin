# v0.5.2 — hotfix MCP launcher для разных Node-окружений

Дата: 2026-05-05.

## Что исправлено

v0.5.1 заменил `npx -y` на прямой бинарь `sdlc-state-rag`. Но Claude Code MCP launcher имеет ограниченный PATH (без nvm), и бинарь с shebang `#!/usr/bin/env node` не запускается без node в PATH.

## Решение

`scripts/launch-sdlc-state-rag.sh` — wrapper с fallback-цепочкой:

1. `command -v sdlc-state-rag` — если бинарь в PATH.
2. `source $NVM_DIR/nvm.sh` или `$HOME/.nvm/nvm.sh` — для nvm-окружений.
3. `/usr/local/bin/sdlc-state-rag` / `/opt/homebrew/bin/sdlc-state-rag` / `$HOME/.local/bin/sdlc-state-rag` — стандартные локации.
4. `npx -y @ypolosov/sdlc-state-rag` — последний fallback.

Это работает для:
- nvm-пользователей (наиболее распространённый случай).
- Homebrew Node на macOS.
- System-wide install через `apt`/`yum` или `npm i -g` в `/usr/local`.
- Любых других Node-окружений (через npx).

## ⚠️ ACTION REQUIRED

Перезагрузите Claude Code или выполните `/plugin reload ai-driven-sdlc`.

## Verification

```bash
claude mcp list | grep sdlc-state-rag
# должно показать: sdlc-state-rag: ... ✓ Connected
```

## Связанные релизы

- v0.5.0 — принцип 22 + enforce-sdlc-phase hook.
- v0.5.1 — попытка фикса MCP через прямой бинарь (не работало в nvm-окружениях).
- v0.5.2 — этот релиз: launcher с fallback-цепочкой.
