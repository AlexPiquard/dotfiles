# optionally start tmux
if [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ] && [ -z "$TMUX" ] && [ -z "$SSH_TTY" ]; then
  if tmux has-session 2>/dev/null; then
    exec tmux attach
  else
    exec tmux new-session
  fi
fi

# history
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=100000
export SAVEHIST=100000
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt NO_BEEP
setopt INC_APPEND_HISTORY

export PATH="$PATH:$HOME/.local/bin:$HOME/bin"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -z $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
  export SUDO_EDITOR='nvim'
fi

# enable vi mode
bindkey -v
# instant vi mode when pressing <esc>
export KEYTIMEOUT=1

# Android development
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

# jdtls lombok
export JDTLS_JVM_ARGS="-javaagent:$HOME/.local/share/nvim/mason/packages/jdtls/lombok.jar"

# mise
(( $+commands[mise] )) && eval "$(mise activate zsh)"

# direnv
(( $+commands[direnv] )) && eval "$(direnv hook zsh)"

# starship
(( $+commands[starship] )) && eval "$(starship init zsh)"

# fzf
(( $+commands[fzf] )) && source <(fzf --zsh)

update_fzf_theme() {
  if [ -f "$HOME/.config/fzf/theme.sh" ]; then
    source "$HOME/.config/fzf/theme.sh"
  fi
}
## fzf: apply theme when using "fzf" command
fzf() {
  update_fzf_theme
  command fzf "$@"
}
## fzf: apply theme when using Ctrl+R
fzf-history-wrapper() {
  update_fzf_theme
  zle fzf-history-widget
}
zle -N fzf-history-wrapper
bindkey '^R' fzf-history-wrapper

# zoxide
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
# bun bin
export PATH="$HOME/.bun/bin:$PATH"

# go
export PATH="$PATH:$HOME/go/bin"

# fix pkg path
export PKG_CONFIG_PATH="/usr/share/pkgconfig:/usr/lib/x86_64-linux-gnu/pkgconfig"

# 1password gitea plugin for tea cli
[[ ! -f $HOME/.config/op/plugins.sh ]] || source $HOME/.config/op/plugins.sh

# lazygit theme
export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml,$HOME/.config/lazygit/theme.yml"

# aliases
alias ls='eza --icons=always --group-directories-first'
alias la='eza --all --icons=always --group-directories-first'
alias ll='eza --long --all --git --icons=always --group-directories-first'
alias tree='eza --tree --icons'
alias wm='workmux'
alias n='nvim'
alias lg='lazygit'

# Ctrl+Delete: kill the word forward (default is Alt+d)
# Ctrl+Backspace is handled in terminal config because this key is unknown here
bindkey '^[[3;5~' kill-word

# Ctrl+Arrow
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# rust
if [[ -f $HOME/.cargo/env ]]; then
  . "$HOME/.cargo/env"
fi

# rustowl
if [[ -d $HOME/.rustowl ]]; then
  export PATH="$PATH:$HOME/.rustowl"
fi

# gstreamer
export GST_PLUGIN_PATH="/usr/lib/x86_64-linux-gnu/gstreamer-1.0/"

# deno
[ -s $HOME/.deno/env ] && . "$HOME/.deno/env"

# linecast
export WEATHER_UNITS=metric

# add completion for manually installed things (fpath)
fpath=( "$HOME"/.config/zsh/completions $fpath )

# zinit
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
  print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
  command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
  command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
    print -P "%F{33} %F{34}Installation successful.%f%b" || \
    print -P "%F{160} The clone has failed.%f%b"
fi
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# zinit plugins
zinit wait lucid for \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
  blockf \
    zsh-users/zsh-completions
zinit ice wait"0" lucid depth=1 pick"deja.plugin.zsh" \
  atclone"curl -fsSL https://raw.githubusercontent.com/Giammarco-Ferranti/deja/main/install.sh | env -u ZSH_VERSION SHELL=/bin/sh sh && $HOME/.local/bin/deja import" \
  atpull"%atclone"
zinit light Giammarco-Ferranti/deja

# deja keybinds
export DEJA_ACCEPT_KEY='^N' # Space → accept full suggestion on a dedicated key
export DEJA_CYCLE_KEY='^L' # Tab → cycle alternatives
export DEJA_TOGGLE_KEY=
export DEJA_CYCLE_FUZZY_KEY=
export DEJA_CYCLE_FUZZY_BACK_KEY=
export DEJA_TOGGLE_EMPTY_KEY=
