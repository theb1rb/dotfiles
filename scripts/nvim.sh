#!/bin/bash

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
        send_log "Neovim not installed"
        return 1
    fi

    version=$(nvim --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
    IFS=. read -r major minor patch <<< "$version"

    if (( major > 0 || (major == 0 && minor >= 11) )); then
        return 0
    fi

    return 2
}

function install_neovim() {

    # TODO: be specifc to version incase make command needs adjustment
    function _install_neovim() {
        git clone https://github.com/neovim/neovim.git $TEMP_DIR
        pushd $TEMP_DIR
        make CMAKE_BUILD_TYPE=RelWithDebInfo
        sudo make install
        popd
    }

    check_neovim
    case $? in
        0)
            echo "Neovim >= v0.11.0 already installed."
            return 0
            ;;

        1)
            send_log "Installing Neovim..."
            _install_neovim
            ;;

        2)
            send_log "Neovim version too old (need >= v0.11.0). Reinstalling..."
            uninstall_neovim
            _install_neovim
            ;;

        *)
            send_log "Unexpected status from check_neovim."
            return 1
            ;;
    esac

}

function import_neovim_configs() {

    if [ -d $NVIM_DIR ]; then
        send_log "Existing NeoVim configs detected! Backing up configs..."
        tar -zcf "$BACKUP_LOCATION/nvim_backup_$BACKUP_DATE.tar.gz" $NVIM_DIR/
        rm -rf $NVIM_DIR/
    else
        send_log "Creating NeoVim config directory"
        mkdir $NVIM_DIR/
    fi

    send_log "Writing NeoVim config"
    cp -R "$CLONED_REPO/nvim/" $CONFIG_DIR/

}

