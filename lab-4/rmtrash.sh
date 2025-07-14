#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Ошибка: необходимо указать имя одного файла."
    exit 1
fi

FILENAME="$1"
TRASH_DIR="$HOME/.trash"
LOG_FILE="$HOME/.trash.log"

if [ ! -e "$FILENAME" ]; then
    echo "Ошибка: файл '$FILENAME' не существует."
    exit 1
fi

if [ ! -f "$FILENAME" ]; then
    echo "Ошибка: '$FILENAME' не является обычным файлом."
    exit 1
fi

if [ ! -d "$TRASH_DIR" ]; then
    mkdir "$TRASH_DIR" || { echo "Ошибка: не удалось создать каталог '$TRASH_DIR'."; exit 1; }
fi

ID=1
while [ -e "$TRASH_DIR/$ID" ]; do
    ((ID++))
done

ln "$FILENAME" "$TRASH_DIR/$ID"
if [ $? -ne 0 ]; then
    echo "Ошибка: не удалось создать жёсткую ссылку."
    exit 1
fi

rm "$FILENAME"
if [ $? -ne 0 ]; then
    echo "Ошибка: не удалось удалить оригинальный файл '$FILENAME'."
    exit 1
fi

REALPATH=$(realpath "$TRASH_DIR/$ID")
ORIGPATH=$(realpath "$PWD/$FILENAME" 2>/dev/null || echo "$PWD/$FILENAME")
echo "$ORIGPATH $ID" >> "$LOG_FILE"

echo "Файл '$FILENAME' перемещён в корзину как '$TRASH_DIR/$ID'."
