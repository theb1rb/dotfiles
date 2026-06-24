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
TEMP_DIR=$(mktemp -d)

# take options:
# - interactive <bool>
# - include <list>

function uninstall_neovim() {

    if $(snap list | grep -E '^neovim'); then
        sudo snap remove neovim
    fi

    if $(apt list --installed | grep -E '^neovim'); then
        sudo apt purge --autoremove neovim
    fi

}

function check_neovim() {
    if ! command -v nvim >/dev/null 2>&1; then
        echo "Neovim not installed"
        return 1
    fi

    version=$(nvim --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
    IFS=. read -r major minor patch <<< "$version"

    if (( major > 0 || (major == 0 && minor >= 11) )); then
        echo "Neovim already satisfied"
        return 0
    fi

    echo "Neovim version too old (need >= v0.11.0)"
    return 2
}

function install_neovim() {

    function _install_neovim() {
        git clone https://github.com/neovim/neovim.git $TEMP_DIR
        cd $TEMP_DIR/neovim/
        make CMAKE_BUILD_TYPE=RelWithDebInfo
        sudo make install
        cd -
    }

    check_neovim
    case $? in
        0)
            echo "Neovim >= v0.11.0 already installed."
            return 0
            ;;

        1)
            echo "Neovim not installed. Installing..."
            _install_neovim
            ;;

        2)
            echo "Neovim version too old. Reinstalling..."
            uninstall_neovim
            _install_neovim
            ;;

        *)
            echo "Unexpected status from check_neovim."
            return 1
            ;;
    esac

}

function import_neovim_configs() {

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


}

function import_tmux_config() {

    if [ -f $TMUX_DEFAULT ]; then
        echo "Existing TMUX config detected! Backing up config..."
        mv $TMUX_DEFAULT "$BACKUP_LOCATION/tmux-$BACKUP_DATE.conf.bak"
        rm $TMUX_DEFAULT
    fi

    echo "Writing TMUX config"
    cp "$CLONED_REPO/tmux.conf" $TMUX_LOCATION
    ln -s $TMUX_LOCATION $TMUX_DEFAULT

}

function import_ghostty_config(){

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

}

function install_docker(){
    if [ ! -e $(which docker)]; then
        echo "Installing Docker"
        curl -fsSL https://get.docker.com | sudo bash
    fi
}

function main() {

    if [ ! -d $BACKUP_LOCATION ]; then
        echo "Creating Backup Location"
        mkdir -p $BACKUP_LOCATION
    fi

    sudo apt-get update
    sudo apt-get install -y \
        make \
        cmake \
        git \
        tmux \
        vim \
        python3 \
        ansible \
        ca-certificates

    sudo snap install ghostty --classic

    git clone https://github.com/theb1rb/$REPO_NAME.git $CLONED_REPO/

    install_docker
    install_neovim && import_neovim_configs
    import_tmux_config
    import_ghostty_config

    echo "DONE INSTALLING DOTFILES!"
}

main

