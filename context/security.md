# Segurança do backup

Este repositório pode ser publicado porque contém apenas configuração e
metadados deliberadamente selecionados. Ele não substitui um backup criptografado
nem um gerenciador de segredos.

## Excluído de propósito

- `~/.ssh`, chaves GPG e certificados privados.
- Tokens do GitHub CLI, Claude, Codex, npm e outros serviços.
- `.env`, cookies, históricos, sessões e bancos SQLite.
- Diretórios de cache, `node_modules`, ambientes virtuais e imagens Docker.
- Código dos repositórios privados e alterações locais não commitadas.

## Recuperação

Depois do bootstrap, autentique cada ferramenta manualmente e restaure segredos
por um canal privado. Se for necessário guardar material secreto junto do
backup, use um arquivo criptografado com SOPS/age e mantenha a chave fora do Git.
