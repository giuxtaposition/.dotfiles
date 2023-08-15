#!/bin/sh

#==============
# Variables
#==============
dotfiles_dir=~/.dotfiles

#==============
# Delete existing dot files and folders
#==============
sudo rm -rf ~/.config/nvim > /dev/null 2>&1
sudo rm -rf ~/.config/wezterm > /dev/null 2>&1
sudo rm -rf ~/.config/fish > /dev/null 2>&1
sudo rm ~/.config/starship.toml > /dev/null 2>&1

#============== 
# Create symlinks in the home folder
#==============
ln -sf $dotfiles_dir/.config/nvim ~/.config/nvim
ln -sf $dotfiles_dir/.config/wezterm ~/.config/wezterm
ln -sf $dotfiles_dir/.config/fish ~/.config/fish
ln -sf $dotfiles_dir/.config/starship.toml ~/.config/starship.toml

#==============
# Install fish plugins
#==============
fisher install jethrokuan/z
fisher install patrickf1/fzf.fish
fisher install jorgebucaran/nvm.fish

#==============
# Fonts
#==============
mkdir -p ~/.fonts
cp -r $dotfiles_dir/.fonts/* ~/.fonts/ &> /dev/null
fc-cache -v &> /dev/null 
