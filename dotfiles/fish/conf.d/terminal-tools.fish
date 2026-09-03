if status is-interactive
    if type -q eza
        function l; eza --group-directories-first $argv; end
        function la; eza --all --group-directories-first $argv; end
        function lt; eza --tree --level=2 --group-directories-first $argv; end
        function ll; eza --long --all --header --git --group-directories-first $argv; end
    end

    if type -q batcat
        function cat; batcat --paging=never --style=plain $argv; end
    else if type -q bat
        function cat; bat --paging=never --style=plain $argv; end
    end
end
