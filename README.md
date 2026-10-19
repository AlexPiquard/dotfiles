<a href="https://dotfyle.com/AlexPiquard/dotfiles-config-nvim"><img src="https://dotfyle.com/AlexPiquard/dotfiles-config-nvim/badges/plugins?style=flat" /></a>
<a href="https://dotfyle.com/AlexPiquard/dotfiles-config-nvim"><img src="https://dotfyle.com/AlexPiquard/dotfiles-config-nvim/badges/leaderkey?style=flat" /></a>
<a href="https://dotfyle.com/AlexPiquard/dotfiles-config-nvim"><img src="https://dotfyle.com/AlexPiquard/dotfiles-config-nvim/badges/plugin-manager?style=flat" /></a>

# First install

- install alacritty, kitty or ghostty
- zsh
    - install
    - `chsh -s $(which zsh)` (or `sudo chsh $USER` in fedora)
    - `bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"`
- install packages
    - fedora : `./scripts/install-fedora.sh`
    - mise tools : `./scripts/install-mise-tools.sh`
- install fonts (`Recursive` and `Symbols Nerd Font Mono`)
- symlink dotfiles: `./stow.sh`
- generate missing completions : `./scripts/completions.sh`
- tmux
    - install
    - `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`
    - `tmux source ~/.config/tmux/tmux.conf`
- auto theming: `sudo systemctl enable TerminalSystemTheme`
