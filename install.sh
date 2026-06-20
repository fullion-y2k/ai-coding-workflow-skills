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
skill_backup_root="$HOME/.agents/skill-backups"
agent_backup_root="$HOME/.codex/agent-backups"
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
  local backup_root="$2"
  if [ -e "$path" ]; then
    local backup_dir="$backup_root/$stamp"
    local backup="$backup_dir/$(basename "$path")"
    echo "Backing up $path -> $backup"
    run mkdir -p "$backup_dir"
    run mv "$path" "$backup"
  fi
}

copy_dir() {
  local src="$1"
  local dest="$2"
  local backup_root="$3"
  backup_if_exists "$dest" "$backup_root"
  echo "Installing $dest"
  run mkdir -p "$(dirname "$dest")"
  run cp -R "$src" "$dest"
}

copy_file() {
  local src="$1"
  local dest="$2"
  local backup_root="$3"
  backup_if_exists "$dest" "$backup_root"
  echo "Installing $dest"
  run mkdir -p "$(dirname "$dest")"
  run cp "$src" "$dest"
}

move_legacy_backups() {
  local active_dir="$1"
  local backup_root="$2"
  [ -d "$active_dir" ] || return 0
  local backup_dir="$backup_root/$stamp-legacy"
  shopt -s nullglob
  local item
  for item in "$active_dir"/*.backup-*; do
    local backup="$backup_dir/$(basename "$item")"
    echo "Moving legacy backup $item -> $backup"
    run mkdir -p "$backup_dir"
    run mv "$item" "$backup"
  done
  shopt -u nullglob
}

echo "Installing Skills to $skills_dest"
run mkdir -p "$skills_dest"
move_legacy_backups "$skills_dest" "$skill_backup_root"
for skill in ai-new-project-delivery ai-existing-project-change; do
  copy_dir "$skills_src/$skill" "$skills_dest/$skill" "$skill_backup_root"
done

echo "Installing Custom Agents to $agents_dest"
run mkdir -p "$agents_dest"
move_legacy_backups "$agents_dest" "$agent_backup_root"
for agent in explorer-mini.toml worker-mini.toml reviewer.toml critical-reviewer.toml; do
  copy_file "$agents_src/$agent" "$agents_dest/$agent" "$agent_backup_root"
done

if [ "$with_worker_codex" -eq 1 ]; then
  copy_file "$agents_src/worker-codex.toml.example" "$agents_dest/worker-codex.toml" "$agent_backup_root"
else
  echo "Skipping optional worker-codex.toml. Use --with-worker-codex to install it."
fi

echo "Done. Backups are stored outside active install directories. No secrets, tokens, or config.toml changes were made."
