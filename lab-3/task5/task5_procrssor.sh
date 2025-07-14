#!/bin/bash

fifo_file="/tmp/my_fifo"
rm -f $fifo_file
mkfifo $fifo_file

value=1
mode="add"

while true; do
    read input < $fifo_file
    case "$input" in
        "+") 
            mode="add"
            echo "Mode changed to addition"
            ;;
        "*") 
            mode="multiply"
            echo "Mode changed to multiplication"
            ;;
        "QUIT") 
            echo "Planned shutdown."
            break
            ;;
        [0-9]*)
            if [ "$mode" == "add" ]; then
                value=$((value + input))
            else
                value=$((value * input))
            fi
            echo "Current result: $value"
            ;;
        *) 
            echo "Error: incorrect input"
            break
            ;;
    esac
done

rm -f $fifo_file
