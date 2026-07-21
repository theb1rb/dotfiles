#!/bin/bash

function import_git_configs() {

    send_log "Configuring git..."

    local git_user="theb1rb"
    local git_email="bluephoenix770@gmail.com"

    git config --global user.name "${git_user}"
    git config --global user.email "${git_email}"

    if gpg --list-keys "${git_email}" >/dev/null 2>&1; then
        local finger_print=$(gpg --list-keys --with-colons "${git_email}" \
                | awk -F: '$1 == "fpr" { print $10; exit }')
        git config --global user.signingkey "${finger_print}"
        git config --global commit.gpgsign true
    else
        send_log "ERROR: Couldn't configure git gpg key"
    fi
}

