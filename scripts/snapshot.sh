#!/usr/bin/env bash
set -euo pipefail

repo_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
inventory="$repo_dir/inventory"
projects_dir=${PROJECTS_DIR:-"$HOME/github"}
tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

apt-mark showmanual | sort >"$tmp_dir/apt-manual.txt"
snap list 2>/dev/null >"$tmp_dir/snap-list.txt" || :
flatpak list --app --columns=application 2>/dev/null | sort >"$tmp_dir/flatpak-apps.txt" || :
npm -g ls --depth=0 2>/dev/null >"$tmp_dir/npm-global.txt" || :
uv tool list 2>/dev/null >"$tmp_dir/uv-tools.txt" || :
code --list-extensions 2>/dev/null | sort >"$tmp_dir/vscode-extensions.txt" || :

{
  printf 'name\turl\tbranch\tcommit\tdirty\n'
  for project in "$projects_dir"/*; do
    [ -d "$project/.git" ] || continue
    name=$(basename "$project")
    [ "$name" = "$(basename "$repo_dir")" ] && continue
    url=$(git -C "$project" remote get-url origin 2>/dev/null || true)
    url=$(printf '%s' "$url" | sed -E 's#(https?://)[^/@]+:[^/@]+@#\1#; s#(https?://)[^/@]+@#\1#')
    branch=$(git -C "$project" branch --show-current)
    commit=$(git -C "$project" rev-parse HEAD)
    if [ -n "$(git -C "$project" status --porcelain)" ]; then dirty=yes; else dirty=no; fi
    printf '%s\t%s\t%s\t%s\t%s\n' "$name" "$url" "$branch" "$commit" "$dirty"
  done
} >"$tmp_dir/repositories.tsv"

{
  echo "# Retrato da máquina"
  echo
  echo "Gerado em: $(date --iso-8601=seconds)"
  echo
  echo '```text'
  grep -E '^(PRETTY_NAME|VERSION_CODENAME)=' /etc/os-release
  uname -srmo
  printf 'shell: '; getent passwd "$(id -un)" | cut -d: -f7
  bash --version | head -1
  fish --version 2>/dev/null || true
  git --version
  docker --version 2>/dev/null || true
  docker compose version 2>/dev/null || true
  node --version 2>/dev/null || true
  npm --version 2>/dev/null || true
  python3 --version
  uv --version 2>/dev/null || true
  gh --version 2>/dev/null | head -1 || true
  claude --version 2>/dev/null || true
  codex --version 2>/dev/null || true
  kitty --version 2>/dev/null || true
  echo '```'
} >"$tmp_dir/system.md"

{
  echo "# Preferências GNOME (inventário; revise antes de restaurar)"
  for schema in \
    org.gnome.desktop.interface \
    org.gnome.desktop.input-sources \
    org.gnome.desktop.wm.keybindings \
    org.gnome.settings-daemon.plugins.media-keys; do
    echo
    echo "## $schema"
    gsettings list-recursively "$schema" 2>/dev/null || true
  done
} >"$tmp_dir/gnome-settings.txt"

mkdir -p "$inventory"
for file in "$tmp_dir"/*; do
  mv "$file" "$inventory/$(basename "$file")"
done

echo "Inventário atualizado em $inventory"
