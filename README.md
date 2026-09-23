# First install

- install alacritty, kitty or ghostty
- install 1password
- zsh
    - install
    - `chsh -s $(which zsh)` (or `sudo chsh $USER` in fedora)
    - `bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"`
- install packages
    - fedora : `./scripts/install-fedora.sh`
- install fonts (`Recursive` and `Symbols Nerd Font Mono`)
- symlink dotfiles: `./stow.sh`
- generate missing completions : `./scripts/completions.sh`
- tmux
    - install
    - `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`
    - `tmux source ~/.config/tmux/tmux.conf`
    - workmux : `mise use -g cargo:raine/workmux`
- auto theming: `sudo systemctl enable TerminalSystemTheme`
