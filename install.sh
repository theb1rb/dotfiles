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
# - configure git
# - generate ssh and gpg keys
# - choose os
# - interactive <bool>
# - include <list>

function options() {
    echo "what are we installing?"
    echo "full or just packages?"
}

function check_os() {

    # TODO: more compatible for different OS's
    echo "make sure running on ubuntu"
    if [[ -r /etc/os-release ]]; then
        source /etc/os-release
        if [[ $ID == "ubuntu" ]]; then
            return 0
        fi
    else
        return 1
    fi

}

function cleanup() {
    echo "Beginning cleanup..."
    items=("neovim" "dotfiles")
    for item in "$items[@]"; do
        rm -rf /tmp/$item
    done
    echo "Finished cleanup"
}

function main() {

    if ! check_os; then
        echo "This script only supports Ubuntu" >&2
        exit 1
    fi

    if [ -d $CLONED_REPO ]; then
        rm -rf $CLONED_REPO
    fi

    if [ ! -d $BACKUP_LOCATION ]; then
        echo "Creating Backup Location"
        mkdir -p $BACKUP_LOCATION
    fi

    sudo apt-get update
    sudo apt-get install -y \
        make \
        cmake \
        git \
        gh \
        glab \
        tmux \
        vim \
        python3 \
        ansible \
        ca-certificates \
        pass

    git clone https://github.com/theb1rb/$REPO_NAME.git $CLONED_REPO/

    source ${CLONED_REPO}/scripts/log.sh
    source ${CLONED_REPO}/scripts/docker.sh
    source ${CLONED_REPO}/scripts/ghostty.sh
    source ${CLONED_REPO}/scripts/nvim.sh
    source ${CLONED_REPO}/scripts/tmux.sh

    source ${CLONED_REPO}/scripts/crypto.sh
    source ${CLONED_REPO}/scripts/git.sh

    install_docker
    install_ghostty && import_ghostty_config
    install_neovim && import_neovim_configs
    import_tmux_config
    cleanup

    send_log "DONE INSTALLING DOTFILES!"

}

main

