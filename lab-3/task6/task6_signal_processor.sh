#!/bin/bash

value=1
mode="add"

handle_usr1() {
    mode="add"
    echo "Mode switched to addition"
}

handle_usr2() {
    mode="multiply"
    echo "Mode switched to multiplication"
}

handle_term() {
    echo "Terminating by TERM signal"
    exit 0
}

trap handle_usr1 USR1
trap handle_usr2 USR2
trap handle_term SIGTERM

while true; do
    sleep 1
    if [ "$mode" == "add" ]; then
        value=$((value + 2))
    else
        value=$((value * 2))
    fi
    echo "Current result: $value"
done
