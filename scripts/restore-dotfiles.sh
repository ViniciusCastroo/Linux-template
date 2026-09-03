#!/usr/bin/env bash
set -euo pipefail

repo_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
backup_dir="$HOME/.local/state/linux-template/backups/$(date +%Y%m%d-%H%M%S)"
backup_created=false

link_file() {
  local source=$1 target=$2
  mkdir -p "$(dirname "$target")"

  if [ -L "$target" ] && [ "$(readlink -f "$target")" = "$(readlink -f "$source")" ]; then
    echo "ok      $target"
    return
  fi

  if [ -e "$target" ] || [ -L "$target" ]; then
    mkdir -p "$backup_dir$(dirname "${target#$HOME}")"
    mv "$target" "$backup_dir${target#$HOME}"
    backup_created=true
    echo "backup  $target"
  fi

  ln -s "$source" "$target"
  echo "link    $target -> $source"
}

link_file "$repo_dir/dotfiles/bashrc" "$HOME/.bashrc"
link_file "$repo_dir/dotfiles/zshrc" "$HOME/.zshrc"
link_file "$repo_dir/dotfiles/profile" "$HOME/.profile"
link_file "$repo_dir/dotfiles/gitconfig" "$HOME/.gitconfig"
link_file "$repo_dir/dotfiles/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"
link_file "$repo_dir/dotfiles/fish/config.fish" "$HOME/.config/fish/config.fish"
link_file "$repo_dir/dotfiles/fish/fish_plugins" "$HOME/.config/fish/fish_plugins"
link_file "$repo_dir/dotfiles/fish/conf.d/terminal-tools.fish" "$HOME/.config/fish/conf.d/terminal-tools.fish"
link_file "$repo_dir/dotfiles/fish/conf.d/uv.env.fish" "$HOME/.config/fish/conf.d/uv.env.fish"
link_file "$repo_dir/dotfiles/fish/functions/fish_prompt.fish" "$HOME/.config/fish/functions/fish_prompt.fish"
link_file "$repo_dir/dotfiles/fish/functions/fish_right_prompt.fish" "$HOME/.config/fish/functions/fish_right_prompt.fish"
link_file "$repo_dir/dotfiles/claude/settings.json" "$HOME/.claude/settings.json"
link_file "$repo_dir/dotfiles/claude/statusline-command.sh" "$HOME/.claude/statusline-command.sh"
link_file "$repo_dir/dotfiles/onedrive/config" "$HOME/.config/onedrive/config"
link_file "$repo_dir/dotfiles/onedrive/sync_list" "$HOME/.config/onedrive/sync_list"
link_file "$repo_dir/dotfiles/autostart/remmina-applet.desktop" "$HOME/.config/autostart/remmina-applet.desktop"

mkdir -p "$HOME/.codex"
codex_target="$HOME/.codex/config.toml"
codex_rendered=$(mktemp)
sed "s#__HOME__#$HOME#g" "$repo_dir/dotfiles/codex/config.toml.template" >"$codex_rendered"
if [ ! -e "$codex_target" ] || ! cmp -s "$codex_rendered" "$codex_target"; then
  if [ -e "$codex_target" ]; then
    mkdir -p "$backup_dir/.codex"
    mv "$codex_target" "$backup_dir/.codex/config.toml"
    backup_created=true
  fi
  install -m 600 "$codex_rendered" "$codex_target"
  echo "render  $codex_target"
else
  echo "ok      $codex_target"
fi
rm -f "$codex_rendered"

fish -c 'functions -q fisher; and fisher update' ||
  echo "Aviso: Fisher ainda não instalado; rode o bootstrap."

if $backup_created; then
  echo "Arquivos anteriores preservados em $backup_dir"
fi
