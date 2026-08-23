export ZSH="$HOME/.oh-my-zsh"

export DISABLE_AUTO_UPDATE="true"

# Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# oh my zsh
source $HOME/oh-my-zsh.zsh

export PATH="$PATH:$HOME/.local/bin"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -z $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
  export SUDO_EDITOR='nvim'
fi

# Android development
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

# jdtls lombok
export JDTLS_JVM_ARGS="-javaagent:$HOME/.local/share/nvim/mason/packages/jdtls/lombok.jar"

# mise
(( $+commands[mise] )) && eval "$(mise activate zsh)"

# direnv
(( $+commands[direnv] )) && eval "$(direnv export zsh)"

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
alias ll='ls -la'

# Ctrl+Delete: kill the word forward (default is Alt+d)
# Ctrl+Backspace is handled in terminal config because this key is unknown here
bindkey '^[[3;5~' kill-word

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
