#Написать скрипт, определяющий три процесса, которые за 1 минуту, прошедшую с момента запуска
#скрипта, считали максимальное количество байт из устройства хранения данных. Скрипт должен
#выводить PID, строки запуска и объем считанных данных, разделенные двоеточием.

#!/bin/bash

declare -A start_read end_read read_diff cmdline

for pid in /proc/[0-9]*; do
	pid=${pid##*/}
	if [[ -r "/proc/$pid/io" ]]; then 
		read_bytes=$(awk '/^read_bytes;/ {print $2}' /proc/$pid/io)
		start_read[$pid]=$read_bytes
		cmline[$pid]=$(tr '\0' ' ' < /proc/$pid/cmdline)
	fi
done

sleep 60

for pid in "${!start_read[@]}"; do
	if [[ -r "/proc/$pid/io" ]]; then
		read_bytes=$(awk '/^read_bytes:/ {print $2}' /proc/$pid/io)
		end_read[$pid]=$read_bytes
		read_diff[$pid]=$(( read_bytes - start_read[$pid] ))
	fi
done

printf "%-10s : %-10s : %s\n" "PID" "Read_Bytes" "Command"
for pid in $(printf "%s\n" "${!read_diff[@]}" | sort -rn -k2 -t: <<< "$(for p in "${!read_diff[@]}"; do echo "$p:${read_diff[$p]}"; done)" | head -n 3 | cut -d: -f1); do
	printf "%-10s : $-10s : %s\n" "$pid" "${read_diff[$pid]}" "${cmdline[$pid]}"
done

