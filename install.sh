#!/bin/bash

set -euo pipefail

BACKUP_DATE=$(date +"%F")
BACKUP_LOCATION="$HOME/.config/backups"
CLONE_LOCATION="/tmp"
CONFIG_DIR="$HOME/.config"
GHOSTTY_DIR="$CONFIG_DIR/ghostty"
GIT_USERNAME="theb1rb"
NVIM_DIR="$CONFIG_DIR/nvim"
REPO_NAME="dotfiles"
CLONED_REPO="$CLONE_LOCATION/$REPO_NAME"
TMUX_LOCATION="$CONFIG_DIR/tmux.conf"
TMUX_DEFAULT="$HOME/.tmux.conf"

# take options:
# - interactive <bool>
# - include <list>

sudo apt-get update
sudo apt-get install -y \
    git \
	tmux \
	ghostty \
	vim \
	neovim \
	python3 \
	ansible \
	ca-certificates

if [ ! -e $(which docker)]; then
    echo "Installing Docker"
    curl -fsSL https://get.docker.com | sudo bash
fi

git clone https://github.com/theb1rb/$REPO_NAME.git $CLONED_REPO/

if [ ! -d $BACKUP_LOCATION ]; then
    echo "Creating Backup Location"
    mkdir -p $BACKUP_LOCATION
fi

if [ -d $NVIM_DIR ]; then
    echo "Existing NeoVim configs detected! Backing up configs..."
    tar -zcf "$BACKUP_LOCATION/nvim_backup_$BACKUP_DATE.tar.gz" $NVIM_DIR/
    rm -rf $NVIM_DIR/
else
    echo "Creating NeoVim config directory"
    mkdir $NVIM_DIR/
fi

echo "Writing NeoVim config"
cp -R "$CLONED_REPO/nvim/" $CONFIG_DIR/

if [ -f $TMUX_DEFAULT ]; then
    echo "Existing TMUX config detected! Backing up config..."
    mv $TMUX_DEFAULT "$BACKUP_LOCATION/tmux-$BACKUP_DATE.conf.bak"
    rm $TMUX_DEFAULT
fi

echo "Writing TMUX config"
cp "$CLONED_REPO/tmux.conf" $TMUX_LOCATION
ln -s $TMUX_LOCATION $TMUX_DEFAULT

if [ -d $GHOSTTY_DIR ]; then
    echo "Existing Ghostty configs detected! Backing up configs..."
    tar -zcf "$BACKUP_LOCATION/ghostty_config_$BACKUP_DATE.tar.gz" $GHOSTTY_DIR/
    rm -rf $GHOSTTY_DIR/
else
    echo "Creating Ghostty config directory"
    mkdir $GHOSTTY_DIR/
fi

echo "Writing Ghostty config"
cp -R "$CLONED_REPO/ghostty/" $CONFIG_DIR/

echo "DONE INSTALLING DOTFILES!"

