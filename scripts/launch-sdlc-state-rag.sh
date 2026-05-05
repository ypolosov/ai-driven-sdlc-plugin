#!/usr/bin/env bash
set -euo pipefail

if command -v sdlc-state-rag >/dev/null 2>&1; then
  exec sdlc-state-rag "$@"
fi

if [ -n "${NVM_DIR:-}" ] && [ -s "$NVM_DIR/nvm.sh" ]; then
  # shellcheck source=/dev/null
  . "$NVM_DIR/nvm.sh" >/dev/null 2>&1 || true
elif [ -s "$HOME/.nvm/nvm.sh" ]; then
  export NVM_DIR="$HOME/.nvm"
  # shellcheck source=/dev/null
  . "$NVM_DIR/nvm.sh" >/dev/null 2>&1 || true
fi

if command -v sdlc-state-rag >/dev/null 2>&1; then
  exec sdlc-state-rag "$@"
fi

for candidate in \
  /usr/local/bin/sdlc-state-rag \
  /opt/homebrew/bin/sdlc-state-rag \
  "$HOME/.local/bin/sdlc-state-rag"; do
  if [ -x "$candidate" ]; then
    exec "$candidate" "$@"
  fi
done

if command -v npx >/dev/null 2>&1; then
  exec npx -y @ypolosov/sdlc-state-rag "$@"
fi

printf 'launch-sdlc-state-rag: не найден ни sdlc-state-rag, ни node/npx.\n' >&2
printf 'Установите: npm install -g @ypolosov/sdlc-state-rag\n' >&2
exit 127
