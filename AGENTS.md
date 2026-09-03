# Contexto da estação

Este repositório descreve e recria a estação de desenvolvimento de Vinicius
Silva. Ao trabalhar aqui, preserve portabilidade, idempotência e segurança.

## Ambiente de referência

- Ubuntu 24.04 LTS x86_64, locale brasileiro.
- Shell padrão: Fish; Bash e Zsh permanecem como fallback.
- Terminal: Kitty, tema Catppuccin Mocha com fundo preto translúcido.
- Stack recorrente: Git, Docker Compose, Node.js 22, Python, uv, Django,
  React/Vite, PostgreSQL e Redis.
- Diretório de projetos: `~/github`.

## Repositórios de trabalho

- `darwin`: plataforma de inteligência operacional com IA. Django/DRF,
  Channels, React/Vite, PostgreSQL/pgvector, Redis e Nginx.
- `joker`: plataforma de segurança documental, tokenização, anonimização e
  integrações como Google Drive.
- `neocontratos`: plataforma de contratos. Backend Django por domínios e
  frontend React/Vite em Feature-Sliced Design.

Branches e commits mudam; consulte `inventory/repositories.tsv`, que é a fonte
gerada mais recente. Detalhes adicionais ficam em `context/repositories.md`.

## Regras para manutenção

- Nunca versione `.env`, credenciais, tokens, cookies, chaves SSH, históricos de
  shell ou bancos de dados de ferramentas de IA.
- Não copie worktrees privados para este repositório. Preserve-os pelo remote,
  branch e commit; mudanças locais devem ser commitadas no projeto correto.
- Mantenha scripts idempotentes e compatíveis com uma instalação Ubuntu limpa.
- Use caminhos baseados em `$HOME`, não caminhos absolutos do usuário atual.
- Execute `./scripts/check-secrets.sh` antes de cada commit.
- Quando o inventário estiver desatualizado, execute `./scripts/snapshot.sh`.
- Não rode bootstrap, restauração ou clonagem sem pedido explícito: esses scripts
  alteram a máquina e podem acessar a rede.
