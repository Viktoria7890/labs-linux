#!/bin/bash

fifo_file="/tmp/my_fifo"

while true; do
    echo "Enter command (*, +, number, QUIT):"
    read input
    echo "$input" > $fifo_file
    if [ "$input" == "QUIT" ]; then
        break
    fi
done
