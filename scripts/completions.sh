mkdir -p ~/.config/zsh/completions

command -v docker &>/dev/null && docker completion zsh > ~/.config/zsh/completions/_docker
command -v gh &>/dev/null && gh completion -s zsh > ~/.config/zsh/completions/_gh
command -v bun &>/dev/null && bun completions zsh > ~/.config/zsh/completions/_bun
command -v rustup &>/dev/null && rustup completions zsh > ~/.config/zsh/completions/_rustup
command -v cargo &>/dev/null && rustup completions zsh cargo > ~/.config/zsh/completions/_cargo

rm -f ~/.zcompdump*
