#!/usr/bin/env bash
set -euo pipefail

scope="${1:-project}"
project_path="${2:-$(pwd)}"
skill_name="execution-memory-engine-mvp"
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source_dir="$repo_root/skills/$skill_name"

if [ ! -f "$source_dir/SKILL.md" ]; then
  echo "Skill source not found: $source_dir" >&2
  exit 1
fi

if [ "$scope" = "global" ]; then
  target_root="${XDG_CONFIG_HOME:-$HOME/.config}/opencode/skills"
elif [ "$scope" = "project" ]; then
  target_root="$project_path/.opencode/skills"
else
  echo "Usage: scripts/install.sh [project|global] [project_path]" >&2
  exit 1
fi

target="$target_root/$skill_name"
mkdir -p "$target_root"
rm -rf "$target"
cp -R "$source_dir" "$target"

echo "Installed $skill_name to $target"
echo "Verify with: opencode debug skill | grep '$skill_name'"
