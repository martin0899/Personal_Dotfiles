# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

unset rc

# ---- WSL Detection (4.5) ----
is_wsl() {
    grep -qi microsoft /proc/version 2>/dev/null
}

# ---- WSL-specific configuration (4.6) ----
if is_wsl; then
    # Windows home directory integration
    WIN_USER=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')
    if [ -n "$WIN_USER" ]; then
        export WIN_HOME="/mnt/c/Users/${WIN_USER}"
    fi

    # WSL-specific aliases
    alias explorer='explorer.exe .'
    alias code='code.cmd'

    # Clipboard integration for WSL (win32yank)
    if command -v win32yank.exe &>/dev/null; then
        export CLIPBOARD_PROVIDER="win32yank"
    fi
fi

# ---- Load Angular CLI autocompletion (4.3) ----
if command -v ng &>/dev/null; then
    source <(ng completion script)
fi

# ---- Android SDK (4.2 - conditional) ----
if [ -d "$HOME/Android/Sdk" ]; then
    export ANDROID_HOME="$HOME/Android/Sdk"
    export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"
    export ANDROID_SDK_ROOT="$ANDROID_HOME"
fi

# ---- Flutter SDK (4.2 - conditional) ----
if [ -d "$HOME/Documentos/flutter/bin" ]; then
    export PATH="$PATH:$HOME/Documentos/flutter/bin"
fi
if [ -d "$HOME/Documentos/Aplicativos/flutter_linux_3.38.5-stable/flutter/bin" ]; then
    export PATH="$PATH:$HOME/Documentos/Aplicativos/flutter_linux_3.38.5-stable/flutter/bin"
fi

# ---- Snap (4.2 - conditional, skip on WSL) ----
if ! is_wsl && [ -d /snap/bin ]; then
    export PATH=$PATH:/snap/bin
fi

# ---- Rust/Cargo (4.2 - conditional) ----
if [ -d "$HOME/.cargo/bin" ]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# ---- pnpm (4.1 - using $HOME) ----
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac

# ---- Neovim (4.2 - conditional) ----
if [ -d /opt/nvim ]; then
    export PATH="$PATH:/opt/nvim/"
fi
export EDITOR=nvim
export VISUAL=nvim

# ---- Personal aliases ----
if [ -f ~/.personal/aliases.sh ]; then
  source ~/.personal/aliases.sh
fi
export PATH="$HOME/.personal/bin:$PATH"

# ---- Ranger cd function ----
function rgr() {
    local temp_file="$(mktemp -t "ranger_cd.XXXXXXXXXX")"
    ranger --choosedir="$temp_file" "$@"
    if [ -f "$temp_file" ]; then
        local target_dir="$(cat "$temp_file")"
        rm -f "$temp_file"
        if [ -d "$target_dir" ] && [ "$target_dir" != "$(pwd)" ]; then
            cd "$target_dir"
        fi
    fi
}
export PATH=$HOME/.npm-global/bin:$PATH

# ---- FZF (búsqueda difusa) ----
if [ -f /usr/share/fzf/shell/key-bindings.bash ]; then
    source /usr/share/fzf/shell/key-bindings.bash
fi
source /etc/bash_completion.d/fzf 2>/dev/null
export FZF_DEFAULT_OPTS="--height 60% --layout=reverse --border --preview-window=right:60%"
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {} 2>/dev/null || cat {}'"
export FZF_ALT_C_OPTS="--preview 'eza -1 --icons --tree --level=2 {} 2>/dev/null || ls {}'"

# ---- Zoxide ----
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init bash)"
    function z() {
      if [ $# -eq 0 ]; then
        zoxide query -i
      else
        cd "$(zoxide query "$@")"
      fi
    }
fi

# ---- TheFuck ----
if command -v thefuck &>/dev/null; then
    eval "$(thefuck --alias)"
fi

# ---- Fastfetch random ----
if command -v fastfetch &>/dev/null && [ -f /usr/local/bin/script_fast.sh ]; then
    fast0
fi

# ---- mimocode (4.1 - using $HOME) ----
if [ -d "$HOME/.mimocode/bin" ]; then
    export PATH="$HOME/.mimocode/bin:$PATH"
fi

# ---- Starship prompt ----
if command -v starship &>/dev/null; then
    eval "$(starship init bash)"
fi

# ---- Buscador interactivo de aliases con fzf ----
__insert_alias() {
    local selected
    selected=$(grep "^alias " ~/.personal/aliases.sh | sed "s/^alias //" | fzf --reverse | cut -d= -f1)
    if [[ -n "$selected" ]]; then
        READLINE_LINE="$selected"
        READLINE_POINT=${#selected}
    fi
}
bind -x '"\C-b": __insert_alias'

# ---- Go (4.2 - conditional) ----
if [ -d "$HOME/go/bin" ]; then
    export PATH="$HOME/go/bin:$PATH"
fi

# ---- scrcpy alias (4.7 - conditional for WSL) ----
if ! is_wsl && command -v scrcpy &>/dev/null; then
    alias scy='scrcpy'
fi
