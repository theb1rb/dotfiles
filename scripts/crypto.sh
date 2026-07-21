#!/bin/bash

function generate_crypto() {

    local default_email='bluephoenix770@gmail.com'
    local default_username='theb1rb'

    function _gen_basic_ssh_key() {
        send_log "Generating basic ssh key..."
        ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N "" -q
    }

    function _gen_basic_gpg() {
        send_log "Generating basic gpg key..."
        gpg --batch \
            --passphrase '' \
            --quick-gen-key \
            "$default_username <$default_email>" \
            rsa4096 \
            default \
            never

        if [ $? -ne 0 ]; then
            send_log "ERROR: Failed to generate basic gpg key!"
            gpg --batch --yes --delete-keys "$default_email"
            gpg --batch --yes --delete-secret-keys "$default_email"
        fi
    }

    _gen_basic_gpg
    _gen_basic_ssh
}

