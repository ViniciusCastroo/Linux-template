# Contexto dos repositórios

O código-fonte não é duplicado aqui. `scripts/clone-repos.sh` usa o inventário
para recriar cada checkout em `~/github`. Isso evita sub-repositórios quebrados,
históricos enormes e vazamento acidental de `.env`.

## Darwin

Plataforma de inteligência operacional com IA para uma empresa brasileira de
cibersegurança. Centraliza reuniões, documentos, tarefas, alertas e interações.

- Frontend: React, Vite e Zustand (`:5173`).
- Backend: Django 4.2, DRF e SimpleJWT (`:8010`).
- Tempo real: Django Channels/Daphne (`:8011`).
- Infra local: Nginx (`:8082`), PostgreSQL 15 + pgvector e Redis 7.
- IA: LangChain/LangGraph; Celery para tarefas assíncronas.
- Arquivos sensíveis: `.env*`, configurações de produção e deploy.

## Joker

Plataforma de segurança de documentos que extrai dados sensíveis, tokeniza,
anonimiza e permite destokenização controlada. Possui frontend principal e
frontend S3, backend Python/Django e Docker Compose. A integração com Google
Drive exige atenção especial a OAuth, chaveiros e dados em produção.

## NeoContratos

Plataforma principal de contratos do ecossistema Neo.

- Backend Django organizado nos domínios `audit`, `contracts`, `core` e `iam`.
- Frontend React/Vite organizado por Feature-Sliced Design.
- Ambientes locais e de deploy via Docker Compose e Makefile.

## Como preservar contexto novo

Mantenha a documentação específica em cada projeto (`README.md`, `AGENTS.md`,
`docs/` e decisões arquiteturais). Este repositório guarda apenas o mapa entre
eles. Antes de migrar de máquina, confirme que `git status` está limpo em todos
os projetos; o inventário não salva alterações sem commit.
