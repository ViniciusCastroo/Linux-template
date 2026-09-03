#!/usr/bin/env bash
set -euo pipefail

repo_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
inventory="$repo_dir/inventory/repositories.tsv"
destination=${PROJECTS_DIR:-"$HOME/github"}
exact=false
[ "${1:-}" = "--exact" ] && exact=true

mkdir -p "$destination"

while IFS=$'\t' read -r name url branch commit dirty; do
  [ "$name" = name ] && continue
  [ -z "$name" ] && continue
  target="$destination/$name"

  if [ ! -d "$target/.git" ]; then
    git clone "$url" "$target"
  fi

  git -C "$target" fetch origin
  if $exact; then
    git -C "$target" checkout --detach "$commit"
  elif git -C "$target" show-ref --verify --quiet "refs/heads/$branch"; then
    git -C "$target" switch "$branch"
  else
    git -C "$target" switch --track -c "$branch" "origin/$branch"
  fi
  echo "$name: branch=$branch snapshot=$commit dirty=$dirty"
done <"$inventory"
