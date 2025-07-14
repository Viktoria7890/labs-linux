#TASK : Задайте еще один однократный запуск скрипта из пункта 1 через 2 минуты. Консоль после этого должна
#оставаться свободной. Выполнив отдельную команду организуйте слежение за файлом ~/report и
#выведите на консоль новые строки из этого файла, как только они появятся.

#!/bin/bash

echo "Planned start of task1.sh in 2 minutes..."
echo "~/task1.sh" | at now + 2 minutes

echo "Waiting for new logs in ~/report..."
tail -f ~/report
