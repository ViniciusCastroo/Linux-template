#!/usr/bin/env bash
set -uo pipefail

repo_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
settings="$repo_dir/inventory/gnome-settings.txt"

if [ "${1:-}" != "--yes" ]; then
  echo "Este comando aplicará atalhos, tema, fonte e preferências GNOME do snapshot."
  read -r -p "Continuar? [y/N] " answer
  case "$answer" in
    y|Y|yes|YES|sim|SIM) ;;
    *) echo "Cancelado."; exit 0 ;;
  esac
fi

applied=0
failed=0
while IFS=' ' read -r schema key value; do
  case "$schema" in
    org.gnome.desktop.interface|\
    org.gnome.desktop.input-sources|\
    org.gnome.desktop.wm.keybindings|\
    org.gnome.settings-daemon.plugins.media-keys) ;;
    *) continue ;;
  esac

  if gsettings set "$schema" "$key" "$value"; then
    applied=$((applied + 1))
  else
    echo "Aviso: não foi possível aplicar $schema $key" >&2
    failed=$((failed + 1))
  fi
done <"$settings"

echo "GNOME restaurado: $applied preferências aplicadas; $failed falharam."
