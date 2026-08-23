export ZSH_DISABLE_COMPFIX="true"
export ZSH_COMPDUMP="$HOME/.zcompdump"

# check compinit cached file only once a day
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

if [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ] && [ -z "$TMUX" ] && [ -z "$SSH_TTY" ]; then
  if tmux has-session 2>/dev/null; then
    exec tmux attach
  else
    exec tmux new-session
  fi
fi

[[ ! -f $ZSH/oh-my-zsh.sh ]] || source $ZSH/oh-my-zsh.sh

root_dir="/usr/share/"

load_plugin() {
  [[ -f "$root_dir/$1" ]] && source "$root_dir/$1"
}

load_plugin zsh-autosuggestions/zsh-autosuggestions.zsh
load_plugin zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
