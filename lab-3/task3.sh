#TASK : Задайте запуск скрипта из пункта 1 в каждую пятую минут каждого часа в день недели, в который вы
#будете выполнять работу.

#!/bin/bash

task_script="/home/viktoriya/lab3/task1.sh"
if [ ! -f "$task_script" ]; then
    echo "Error: script not found"
    exit 1
fi

echo "Adding task to crontab for every 5-minute activation..."
(crontab -l 2>/dev/null; echo "*/5 * * * * $task_script") | crontab -

echo "Checking tasks in crontab:"
crontab -l

echo "All ready. Awaiting activation every 5 minutes."
