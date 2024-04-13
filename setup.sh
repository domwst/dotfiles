#!/bin/bash

cur_dir=$(realpath $(dirname $0))

# Neovim
mkdir -p ~/.config
ln -s $cur_dir/nvim ~/.config/nvim

# Tmux
ln -s $cur_dir/tmux/tmux.conf ~/.tmux.conf
ln -s $cur_dir/tmux ~/.tmux

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins

# Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

rm ~/.zshrc

ln -s $cur_dir/zsh/zshrc ~/.zshrc
ln -s $cur_dir/zsh/p10k.zsh ~/.p10k.zsh

suggest_dir=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions $suggest_dir
chmod 755 $suggest_dir

highlight_dir=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $highlight_dir
chmod 755 $highlight_dir
