#!/bin/bash
LOG_LOCATION=${HOME}/dotfile_install.log
function get_time() {
    # Example Output: [2026-07-21 12:46:01]
    date +"[%Y-%m-%d %H:%M:%S]"
}

function send_log() {
    echo "$(get_time) $1" | tee -a $LOG_LOCATION
}
