#!/bin/bash

FILE_FOR_ANSWR="ANSWR.txt"

PROCESS_COUNTER=$(ps -u $(whoami) --no-headers | wc -l)

echo "$PROCESS_COUNTER" >> "$FILE_FOR_ANSWR"

echo "Количество процессов запущенных от текущего user $PROCESS_COUNTER были записаны в файл ANSWR.txt"

ANSWR2=$(ps -u $(whoami) -o pid,cmd)
echo "$ANSWR2"

