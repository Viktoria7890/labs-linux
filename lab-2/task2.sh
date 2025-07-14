#TASK:Вывести в файл список PID всех процессов, которые были запущены командами, расположенными в /sbin/

#!/bin/bash

OUTPUT_FILE="answ2.txt"

ps ax -o pid=,cmd= --no-headers | while read -r PID CMD REST; do
	if [[ $CMD == /sbin/* ]]; then
		echo "$PID" >> "$OUTPUT_FILE"
	fi
done

echo "список процессов записан в файл $OUTPUT_FILE" 
