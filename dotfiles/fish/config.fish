if status is-interactive
    # Commands interativos ficam nos arquivos conf.d e functions.
end

# Nord para sintaxe do Fish.
set -g fish_color_normal normal
set -g fish_color_command 88c0d0
set -g fish_color_param e5e9f0
set -g fish_color_keyword 81a1c1
set -g fish_color_quote a3be8c
set -g fish_color_redirection b48ead
set -g fish_color_end 81a1c1
set -g fish_color_error bf616a
set -g fish_color_comment 4c566a
set -g fish_color_selection --background=3b4252
set -g fish_color_search_match --background=3b4252
set -g fish_color_operator 81a1c1
set -g fish_color_escape ebcb8b
set -g fish_color_autosuggestion 4c566a
set -g fish_color_cwd 8fbcbb
set -g fish_color_user 88c0d0
set -g fish_color_host 81a1c1

# Evita problemas de renderização do Kitty nesta VM.
set -gx KITTY_ENABLE_WAYLAND 0
set -gx KITTY_DISABLE_WAYLAND 1

alias g='git'
alias gs='git status'
alias ga='git add .'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'

alias d='docker'
alias dc='docker compose'
alias dcu='docker compose up -d'
alias dcd='docker compose down'

alias nr='npm run'
alias py='python3'
alias venv='python3 -m venv .venv'
alias cls='clear'

function auto_venv --on-variable PWD
    if test -e .venv/bin/activate.fish
        source .venv/bin/activate.fish
    end
end
