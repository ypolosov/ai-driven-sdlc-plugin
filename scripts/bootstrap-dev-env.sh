#!/usr/bin/env bash
set -euo pipefail

required=(bats shellcheck shfmt)
missing=()

for tool in "${required[@]}"; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    missing+=("$tool")
  fi
done

if [[ ${#missing[@]} -eq 0 ]]; then
  printf 'dev env OK: bats shellcheck shfmt installed.\n'
  exit 0
fi

printf 'dev env: missing %s\n' "${missing[*]}" >&2

detect_pkg_manager() {
  if command -v apt-get >/dev/null 2>&1; then
    echo apt
  elif command -v brew >/dev/null 2>&1; then
    echo brew
  elif command -v pacman >/dev/null 2>&1; then
    echo pacman
  elif command -v dnf >/dev/null 2>&1; then
    echo dnf
  else
    echo ""
  fi
}

pm="$(detect_pkg_manager)"

case "$pm" in
  apt)
    printf 'run: sudo apt-get install -y %s\n' "${missing[*]}"
    ;;
  brew)
    printf 'run: brew install %s\n' "${missing[*]}"
    ;;
  pacman)
    printf 'run: sudo pacman -S %s\n' "${missing[*]}"
    ;;
  dnf)
    printf 'run: sudo dnf install -y %s\n' "${missing[*]}"
    ;;
  *)
    printf 'unknown package manager; install manually: %s\n' "${missing[*]}"
    ;;
esac

exit 1
