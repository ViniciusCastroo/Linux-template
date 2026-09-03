#!/usr/bin/env bash
set -euo pipefail

repo_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$repo_dir"
failed=false

file_list=$(find . -path './.git' -prune -o -type f -print | sed 's#^./##')

if printf '%s\n' "$file_list" | grep -E '(^|/)(\.env($|\.)|.*credentials.*|auth\.json|hosts\.yml|id_(rsa|ed25519)|.*\.(pem|key)$)' >/dev/null; then
  echo "Erro: nome de arquivo potencialmente secreto está versionado:" >&2
  printf '%s\n' "$file_list" | grep -E '(^|/)(\.env($|\.)|.*credentials.*|auth\.json|hosts\.yml|id_(rsa|ed25519)|.*\.(pem|key)$)' >&2
  failed=true
fi

pattern='BEGIN (RSA |OPENSSH |EC )?PRIVATE KEY|AKIA[0-9A-Z]{16}|ghp_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{40,}|sk-(ant-|proj-)[A-Za-z0-9_-]{20,}'
if rg -n --hidden --glob '!.git/**' --glob '!.gitignore' "$pattern" . >/tmp/linux-template-secret-hits 2>/dev/null; then
  echo "Erro: conteúdo com formato de segredo encontrado:" >&2
  cat /tmp/linux-template-secret-hits >&2
  failed=true
fi
rm -f /tmp/linux-template-secret-hits

if $failed; then exit 1; fi
echo "Nenhum segredo óbvio encontrado nos arquivos versionados."
