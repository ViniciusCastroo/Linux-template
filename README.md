# Linux Template

Backup reproduzível da estação Ubuntu de Vinicius Silva. Este repositório guarda
configurações versionáveis, inventários da máquina e contexto suficiente para
recriar o ambiente de desenvolvimento sem versionar senhas ou duplicar projetos.

## O que está salvo

- Fish como shell principal, aliases, prompt, Fisher e plugins.
- Kitty com tema e atalhos atuais.
- Bash, Zsh, profile e configuração global do Git.
- Preferências portáveis do Claude Code e do Codex.
- OneDrive (sem token), autostart do Remmina e preferências do GNOME.
- Pacotes APT/Snap/npm, versões das ferramentas e preferências do GNOME.
- Catálogo dos repositórios, incluindo remote, branch e commit.
- Um `AGENTS.md` que apresenta a máquina e os projetos para agentes de IA.

## Uso rápido em uma instalação nova

```bash
git clone https://github.com/ViniciusCastroo/Linux-template.git ~/github/Linux-template
cd ~/github/Linux-template
./scripts/bootstrap.sh
./scripts/restore-dotfiles.sh
./scripts/clone-repos.sh
# opcional: ./scripts/restore-gnome.sh
```

Os scripts são idempotentes. Antes de substituir um arquivo real,
`restore-dotfiles.sh` cria uma cópia em `~/.local/state/linux-template/backups/`.
Credenciais continuam sendo configuradas manualmente:

```bash
gh auth login
claude login
codex login
```

Chaves SSH e arquivos `.env` devem vir de um gerenciador de segredos, nunca deste
repositório.

## Atualizar o retrato desta máquina

```bash
./scripts/snapshot.sh
./scripts/check-secrets.sh
git diff
```

O snapshot atualiza os inventários mecânicos. Mudanças de dotfiles continuam
intencionais e devem ser copiadas para `dotfiles/` após revisão.

## Estrutura

```text
AGENTS.md             contexto inicial para agentes de IA
context/              mapa humano dos projetos e decisões de segurança
dotfiles/             arquivos que serão ligados ao diretório pessoal
inventory/            retrato gerado da máquina e dos repositórios
scripts/              bootstrap, restauração, clonagem e auditoria
```

Veja também [context/repositories.md](context/repositories.md) e
[context/security.md](context/security.md).
