#!/usr/bin/env bash
set -euo pipefail

target="${1:-project}"
project_path="${2:-$(pwd)}"
custom_skills_path="${3:-}"
skill_name="execution-memory-engine-skills"
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source_dir="$repo_root/skills/$skill_name"

if [ ! -f "$source_dir/SKILL.md" ]; then
  echo "Skill source not found: $source_dir" >&2
  exit 1
fi

case "$target" in
  codex)
    target_root="$HOME/.codex/skills"
    ;;
  opencode)
    target_root="${XDG_CONFIG_HOME:-$HOME/.config}/opencode/skills"
    ;;
  claude)
    target_root="$HOME/.claude/skills"
    ;;
  project)
    target_root="$project_path/.skills"
    ;;
  custom)
    if [ -z "$custom_skills_path" ]; then
      echo "custom target requires a custom skills path as the third argument" >&2
      exit 1
    fi
    target_root="$custom_skills_path"
    ;;
  *)
    echo "Usage: scripts/install.sh [codex|opencode|claude|project|custom] [project_path] [custom_skills_path]" >&2
    exit 1
    ;;
esac

target_dir="$target_root/$skill_name"
mkdir -p "$target_root"
rm -rf "$target_dir"
cp -R "$source_dir" "$target_dir"

echo "Installed $skill_name to $target_dir"
echo "Use the installed SKILL.md with your LLM tool, or point the model at: $target_dir/SKILL.md"
