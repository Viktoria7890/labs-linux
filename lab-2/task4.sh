#!/bin/bash

output_file="cpu_burst.txt"
> "$output_file"

for PID in /proc/[0-9]*; do
    PID=${PID##*/}

    if [ -f "/proc/$PID/status" ] && [ -f "/proc/$PID/sched" ]; then 
        PARENT_PID=$(awk '/^PPid:/ {print $2}' /proc/"$PID"/status)
        SUM_EXEC_RUNTIME=$(awk '/^se.sum_exec_runtime/ {print $3}' /proc/"$PID"/sched)
        NR_SWITCHES=$(awk '/^nr_switches/ {print $3}' /proc/"$PID"/sched)

        if [[ "$NR_SWITCHES" =~ ^[0-9]+$ && "$NR_SWITCHES" -gt 0 ]]; then 
            ART=$(bc <<< "scale=6; $SUM_EXEC_RUNTIME / $NR_SWITCHES")
            echo "ProcessID=$PID : Parent_ProcessID=$PARENT_PID : Average_Running_Time=$ART" >> "$output_file"
        fi
    fi
done

sort -t '=' -k4 -n "$output_file" -o "$output_file"

echo "Результат выполнения сохранен в $output_file"

