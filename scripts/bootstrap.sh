#!/usr/bin/env bash
set -euo pipefail

if [ ! -r /etc/os-release ]; then
  echo "Sistema sem /etc/os-release; esperado Ubuntu 24.04." >&2
  exit 1
fi

. /etc/os-release
if [ "${ID:-}" != ubuntu ]; then
  echo "Aviso: template criado para Ubuntu; detectado ${ID:-desconhecido}." >&2
fi

sudo apt-get update
sudo apt-get install -y \
  apt-transport-https bat build-essential ca-certificates curl eza fish fonts-jetbrains-mono \
  fzf git gnupg jq kitty neovim onedrive openssh-server remmina ripgrep \
  software-properties-common tmux unzip wget

if ! command -v docker >/dev/null 2>&1; then
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg |
    sudo gpg --dearmor --yes -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg
  arch=$(dpkg --print-architecture)
  codename=${VERSION_CODENAME:?}
  echo "deb [arch=$arch signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $codename stable" |
    sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
  sudo apt-get update
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  sudo usermod -aG docker "$USER"
fi

if ! command -v node >/dev/null 2>&1 || [ "$(node --version | sed 's/^v//' | cut -d. -f1)" -ne 22 ]; then
  curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
  sudo apt-get install -y nodejs
fi

if ! command -v gh >/dev/null 2>&1; then
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg |
    sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null
  sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" |
    sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
  sudo apt-get update
  sudo apt-get install -y gh
fi

if ! command -v uv >/dev/null 2>&1; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi
"$HOME/.local/bin/uv" python install 3.14.3

sudo npm install -g @anthropic-ai/claude-code @openai/codex

fish -c '
  if not functions -q fisher
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
    fisher install jorgebucaran/fisher
  end
'

fish_path=$(command -v fish)
if ! grep -Fxq "$fish_path" /etc/shells; then
  echo "$fish_path" | sudo tee -a /etc/shells >/dev/null
fi
if [ "$(getent passwd "$USER" | cut -d: -f7)" != "$fish_path" ]; then
  chsh -s "$fish_path"
fi

echo "Bootstrap concluído. Rode ./scripts/restore-dotfiles.sh e faça login nas ferramentas."
