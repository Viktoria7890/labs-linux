#!/bin/bash

input_file="cpu_burst.txt"
output_file="cpu_burst_with_avg.txt"

> "$output_file"

current_ppid=""
sum_art=0
count=0

while IFS="= " read -r _ pid _ ppid _ art; do
	if [[ "$ppid" != "current_ppid" && -n "$current_ppid" ]]; then
	avg_art=$(bc <<< "scale=6; $sum_art / $count")
	echo "Average_Running_Children_of_ParentID=$current_ppid is $avg_art" >> "$output_file"

	sum_art=0
	count=0
	fi

	echo "ProcessID=$pid : Parent_ProcessID=$ppid : Average_Running_Time=$art" >> "$output_file"

	current_ppid = "$ppid"
	sum_art=$(bc <<< "$sum_art + $art")
	((count++))

done < "$input_file"

if [[ -n "$current_ppid" ]]; then
	avg_art=$(bc <<< "scale=6; $sum_art / $count")
	echo "Average_Running_Children_of_ParentID=$current_ppid is $avg_art" >> "$output_file"
fi 
echo "Результат сохранен в $output_file"


