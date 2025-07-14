# TASK : Создайте три фоновых процесса, выполняющих одинаковый бесконечный цикл вычисления (например,
#перемножение двух чисел). После запуска процессов должна сохраниться возможность использовать
#виртуальную консоль, с которой их запустили. Используя команду top, проанализируйте процент
#использования ресурсов процессора этими процессами. Создайте скрипт, который будет в
#автоматическом режиме обеспечивать, чтобы тот процесс, который был запущен первым, использовал
#ресурс процессора не более чем на 10%. Послав сигнал, завершите работу процесса, запущенного
#третьим. Проверьте, что созданный скрипт по-прежнему удерживает потребление ресурсов процессора

#!/bin/bash

infinite_loop() {
    while true; do
        result=$((1 * 2))
    done
}

echo "Activating 3 background processes..."
infinite_loop & PID1=$!
infinite_loop & PID2=$!
infinite_loop & PID3=$!

echo "Active processes: $PID1, $PID2, $PID3"

echo "Analyzing CPU resources..."
top -b -n 1 | grep -E "PID1|PID2|PID3"

echo "Reducing CPU usage of the first process (PID: $PID1) to 10%"
renice -n 19 -p $PID1

echo "Ending third process (PID: $PID3)..."
kill $PID3

echo "Checking CPU usage of the first process..."
top -b -n 1 | grep -E "PID1"

echo "Done."
