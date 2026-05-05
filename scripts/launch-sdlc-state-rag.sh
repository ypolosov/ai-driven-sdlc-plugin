#!/usr/bin/env bash
set -euo pipefail

case "${SDLC_STATE_RAG_DSN:-}" in
  '${SDLC_STATE_RAG_DSN}' | '${'*'}')
    unset SDLC_STATE_RAG_DSN
    ;;
esac

if command -v sdlc-state-rag >/dev/null 2>&1; then
  exec sdlc-state-rag "$@"
fi

_nvm_path=""
if [ -n "${NVM_DIR:-}" ] && [ -s "$NVM_DIR/nvm.sh" ]; then
  _nvm_path="$NVM_DIR/nvm.sh"
elif [ -s "$HOME/.nvm/nvm.sh" ]; then
  export NVM_DIR="$HOME/.nvm"
  _nvm_path="$HOME/.nvm/nvm.sh"
fi
if [ -n "$_nvm_path" ]; then
  . "$_nvm_path" >/dev/null 2>&1 || true
fi
unset _nvm_path

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
