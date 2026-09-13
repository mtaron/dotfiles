#!/usr/bin/env bash

# green MESSAGE
# Prints MESSAGE in green when stdout is a terminal and color hasn't been
# disabled; otherwise prints it plain.
green() {
    if [[ -t 1 && -z ${NO_COLOR:-} ]]; then
        printf '\033[32m%s\033[0m\n' "$1"
    else
        printf '%s\n' "$1"
    fi
}
