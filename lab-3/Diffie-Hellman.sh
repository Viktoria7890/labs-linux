#!/bin/bash

read -p "Введите значение p (основание): " p
read -p "Введите значение q (большое простое число): " q

file1="process1.txt"
file2="process2.txt"

a=$(($RANDOM % 100 + 1))
A=$(echo "($q ^ $a) % $p" | bc)

echo $A > $file1
echo "Процесс 1: a = $a, A = $A"

b=$(($RANDOM % 100 + 1))
B=$(echo "($q ^ $b) % $p" | bc)

echo $B > $file2
echo "Процесс 2: b = $b, B = $B"

A_from_process2=$(cat $file2)
B_from_process1=$(cat $file1)

K1=$(echo "$A_from_process2 ^ $b % $p" | bc)
K2=$(echo "$B_from_process1 ^ $a % $p" | bc)

echo "Процесс 1: Общий секретный ключ K = $K1"
echo "Процесс 2: Общий секретный ключ K = $K2"

if [[ $K1 -eq $K2 ]]; then
    echo "Общий секретный ключ успешно вычислен: $K1"
else
    echo "Ошибка! Ключи не совпадают."
fi

rm $file1 $file2

