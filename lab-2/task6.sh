#!/bin/bash

max_mem=0
max_pid=0
max_cmd=""

for pid in /proc/[0-9]*; do
	pid=${pid##*/}

	if [[ -f "/proc/$pid/status" ]]; then 
	mem=$(awk '/^VmRSS:/ {print $2}' /proc/"$pid"/status)

		if [[ -n "$mem" && "$mem" =~ ^[0-9]+$ && "$mem" -gt "max_mem" ]]; then 
			max_mem=$mem
			max_pid=$pid
			max_cmd=$(cat /proc/"$pid"/cmline | tr '\0' ' ')
		fi
	fi
done

echo "Наибольший объем памяти использует процесс"
echo "PID : $max_pid"
echo "Команда : $max_cmd"
echo "Используемая память : $max_mem КВ"

echo -e "\nТОП-5 процессов по памяти (по версии top):"
top -b -o +%MEM | head -n 12


