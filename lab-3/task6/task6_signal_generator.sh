#!/bin/bash

echo "Enter process ID of the handler:"
read pid

while true; do
    echo "Enter command (+, *, TERM):"
    read input
    case "$input" in
        "+") kill -USR1 $pid ;;
        "*") kill -USR2 $pid ;;
        "TERM") kill -SIGTERM $pid; break ;;
        *) echo "Invalid input, ignoring" ;;
    esac
done
