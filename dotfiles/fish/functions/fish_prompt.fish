function fish_prompt --description 'Prompt Catppuccin compacto com contexto Git'
    set -l last_status $status
    set -l cwd (prompt_pwd)
    set -l git_info (fish_git_prompt)

    set_color b4befe
    echo -n $USER
    set_color 6c7086
    echo -n ' @ '
    set_color 89b4fa
    echo -n (hostname -s)
    set_color 6c7086
    echo -n '  '
    set_color 94e2d5
    echo -n $cwd

    if test -n "$git_info"
        set_color cba6f7
        echo -n $git_info
    end

    if test $last_status -ne 0
        set_color f38ba8
        echo -n " ["$last_status']'
    end

    set_color f9e2af
    echo -n '❯ '
    set_color normal
end
