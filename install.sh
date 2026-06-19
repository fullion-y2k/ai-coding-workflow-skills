#!/usr/bin/env bash
set -euo pipefail

dry_run=0
with_worker_codex=0

for arg in "$@"; do
  case "$arg" in
    --dry-run) dry_run=1 ;;
    --with-worker-codex) with_worker_codex=1 ;;
    *) echo "Unknown argument: $arg" >&2; exit 2 ;;
  esac
done

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
skills_src="$repo_dir/skills"
agents_src="$repo_dir/agents/openai-codex"
skills_dest="$HOME/.agents/skills"
agents_dest="$HOME/.codex/agents"
stamp="$(date +%Y%m%d%H%M%S)"

run() {
  if [ "$dry_run" -eq 1 ]; then
    echo "[dry-run] $*"
  else
    "$@"
  fi
}

backup_if_exists() {
  local path="$1"
  if [ -e "$path" ]; then
    local backup="$path.backup-$stamp"
    echo "Backing up $path -> $backup"
    run mv "$path" "$backup"
  fi
}

copy_dir() {
  local src="$1"
  local dest="$2"
  backup_if_exists "$dest"
  echo "Installing $dest"
  run mkdir -p "$(dirname "$dest")"
  run cp -R "$src" "$dest"
}

copy_file() {
  local src="$1"
  local dest="$2"
  backup_if_exists "$dest"
  echo "Installing $dest"
  run mkdir -p "$(dirname "$dest")"
  run cp "$src" "$dest"
}

echo "Installing Skills to $skills_dest"
run mkdir -p "$skills_dest"
for skill in ai-new-project-delivery ai-existing-project-change; do
  copy_dir "$skills_src/$skill" "$skills_dest/$skill"
done

echo "Installing Custom Agents to $agents_dest"
run mkdir -p "$agents_dest"
for agent in explorer-mini.toml worker-mini.toml reviewer.toml critical-reviewer.toml; do
  copy_file "$agents_src/$agent" "$agents_dest/$agent"
done

if [ "$with_worker_codex" -eq 1 ]; then
  copy_file "$agents_src/worker-codex.toml.example" "$agents_dest/worker-codex.toml"
else
  echo "Skipping optional worker-codex.toml. Use --with-worker-codex to install it."
fi

echo "Done. No secrets, tokens, or config.toml changes were made."
