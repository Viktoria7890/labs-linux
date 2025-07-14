#TASK:Посчитать количество процессов, запущенных пользователем user, 
#и вывести в файл получившееся число, 
#а затем пары PID:команда для таких процессов.

#!/bin/bash

FILE_FOR_ANSW="ANSWR.txt"

PROCESS_COUNTER=$(ps -u $(whoami) --no-headers | wc -l)

echo "$PROCESS_COUNTER" >> "$FILE_FOR_ANSW"

echo "Количество процессов запущенных от текущего user $PROCESS_COUNTER были записаны в файл ANSWR.txt"

ANSW2=$(ps -u $(whoami) -o pid,cmd)
echo "$ANSW2"

