#!/bin/bash

function import_tmux_config() {

    if [ -f $TMUX_DEFAULT ]; then
        send_log "Existing TMUX config detected! Backing up config..."
        mv $TMUX_DEFAULT "$BACKUP_LOCATION/tmux-$BACKUP_DATE.conf.bak"
    fi

    send_log "Writing TMUX config"
    cp "$CLONED_REPO/tmux.conf" $TMUX_LOCATION
    ln -s $TMUX_LOCATION $TMUX_DEFAULT

}

