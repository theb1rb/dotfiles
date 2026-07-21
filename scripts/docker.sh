#!/bin/bash
DOCKER_REPO=https://github.com/docker/docker-install.git
function install_docker() {
    if ! command -v docker >/dev/null 2>&1; then
        send_log "Docker not installed!"
        send_log "Installing docker..."
        #curl -fsSL https://get.docker.com | sudo bash

        git clone $DOCKER_REPO $TEMP_DIR
        pushd ${TEMP_DIR}/docker-install/

        # Make sure OS supports Docker
        make shellcheck

        # Run install script
        chmod +x install.sh
        bash install.sh

        popd
    else
        send_log "Docker already installed"
    fi

    # User in docker group
    sudo groupadd docker
    sudo usermod -aG $USER docker
    newgrp

    # Verify install
    docker --version

    if ! docker run --rm hello-world; then
        send_log "ERROR: Could not get docker to run the hello world container"
    else
        send_log "Docker install complete!"
    fi

}

