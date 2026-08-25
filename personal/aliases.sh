# ============================================
# ALIASES PERSONALES - Cargado desde bash y zsh
# ============================================

# ---- Navegación ----
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'
alias personal='cd ~/.personal'

# ---- ls / eza ----
alias ls='ls --color=auto'
alias ll='ls -lah'
alias la='ls -A'
alias lt='eza -1 --icons --tree --level=2 -a'
alias l1='eza -1 --icons --tree --level=1 -a'
alias l2='eza -1 --icons --tree --level=2 -a'
alias l3='eza -1 --icons --tree --level=3 -a'

# ---- nvim ----
alias nt='nvim +NERDTreeCWD'
alias vim='nvim'
alias nv='nvim'

# ---- fzf shortcuts ----
alias fv='nvim $(fzf --reverse --preview "bat -n --color=always {} 2>/dev/null || cat {}")'
alias fcd='cd $(find . -type d 2>/dev/null | sed "s|^\./||" | fzf --reverse --preview "eza -1 --icons --tree --level=2 {} 2>/dev/null")'
alias fkill='ps -eo pid,user,comm --sort=-%mem | fzf --header-lines=1 --preview "echo {}" | awk "{print \$1}" | xargs kill 2>/dev/null'

# ---- Sistema ----
alias clock='tty-clock -c -s -C 2'
alias scy='scrcpy'
alias spty='ncspot'
alias fast1='fastfetch -c ~/.config/fastfetch/config1.jsonc'
alias fast2='fastfetch -c ~/.config/fastfetch/config2.jsonc'
alias fast3='fastfetch -c ~/.config/fastfetch/config3.jsonc'
alias fast0='/usr/local/bin/script_fast.sh'
alias grep='grep --color=auto'
alias df='duf'
alias cat='bat --paging=never 2>/dev/null || cat'

# ---- Git ----
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate --all'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias lg='lazygit'

# ---- Docker / Podman ----
alias dps='podman ps -a'
alias di='podman images'
alias dexec='podman exec -it'

# ---- Red ----
alias ip='ip -c'
alias ports='ss -tulanp'
alias myip='curl -s ifconfig.me'

# ---- Utilidades ----
alias rp='realpath'
alias edit='nvim ~/.personal/aliases.sh'
alias reload='exec $SHELL'
alias cls='clear'
alias tree='eza --icons --tree'
alias path='echo -e ${PATH//:/\\n}'
alias weather='curl -s wttr.in'
alias cheat='tldr'
alias myfastfetch='fastfetch -c ~/.config/fastfetch/config1.jsonc'

# ---- Aplicaciones ----
alias spotify='ncspot'
alias notes='nvim ~/Documentos/Obsidian\ Vault/obsidian_sync_git/Documentacion/'
