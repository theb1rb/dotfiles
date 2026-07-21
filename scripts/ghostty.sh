#!/bin/bash

function install_ghostty() {
    sudo snap install ghostty --classic

    if ($? < 0); then
        send_log "[X] Failed to install Ghostty!"
        return 0
    fi

    # TODO: Try and determine how to install things
    # TODO: Try building from source
}

function import_ghostty_config() {

    if [ -d $GHOSTTY_DIR ]; then
        send_log "Existing Ghostty configs detected! Backing up configs..."
        tar -zcf "$BACKUP_LOCATION/ghostty_config_$BACKUP_DATE.tar.gz" $GHOSTTY_DIR/
        rm -rf $GHOSTTY_DIR/
    else
        send_log "Creating Ghostty config directory"
        mkdir $GHOSTTY_DIR/
    fi

    send_log "Writing Ghostty config"
    cp -R "$CLONED_REPO/ghostty/" $CONFIG_DIR/

}

