#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Ошибка: необходимо указать имя файла для восстановления."
    exit 1
fi

FILENAME="$1"
TRASH_DIR="$HOME/.trash"
LOG_FILE="$HOME/.trash.log"
RESTORE_SUCCESS=false

if [ ! -d "$TRASH_DIR" ]; then
    echo "Ошибка: корзина $TRASH_DIR не существует."
    exit 1
fi

if [ ! -f "$LOG_FILE" ]; then
    echo "Ошибка: лог-файл $LOG_FILE не найден."
    exit 1
fi

MATCHES=()
while read -r LINE; do
    ORIG_PATH=$(echo "$LINE" | awk '{print $1}')
    LINK_NAME=$(echo "$LINE" | awk '{print $2}')
    if [ "$(basename "$ORIG_PATH")" = "$FILENAME" ]; then
        MATCHES+=("$LINE")
    fi
done < "$LOG_FILE"

if [ ${#MATCHES[@]} -eq 0 ]; then
    echo "Файл '$FILENAME' не найден в корзине."
    exit 0
fi

echo "Найдены следующие версии файла '$FILENAME':"

for LINE in "${MATCHES[@]}"; do
    ORIG_PATH=$(echo "$LINE" | awk '{print $1}')
    LINK_NAME=$(echo "$LINE" | awk '{print $2}')
    LINK_PATH="$TRASH_DIR/$LINK_NAME"

    echo "Восстановить файл в: $ORIG_PATH ? [y/n]"
    read -r answer

    if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
        RESTORE_DIR=$(dirname "$ORIG_PATH")
        DEST_PATH="$ORIG_PATH"

        if [ ! -d "$RESTORE_DIR" ]; then
            echo "Каталог '$RESTORE_DIR' не существует. Восстановление в домашний каталог."
            RESTORE_DIR="$HOME"
            DEST_PATH="$HOME/$FILENAME"
        fi

        while [ -e "$DEST_PATH" ]; do
            echo "Файл '$DEST_PATH' уже существует. Введите новое имя:"
            read -r NEW_NAME
            DEST_PATH="$RESTORE_DIR/$NEW_NAME"
        done

        ln "$LINK_PATH" "$DEST_PATH"
        if [ $? -eq 0 ]; then
            echo "Файл восстановлен: $DEST_PATH"
            rm "$LINK_PATH"
            grep -v " $LINK_NAME\$" "$LOG_FILE" > "$LOG_FILE.tmp" && mv "$LOG_FILE.tmp" "$LOG_FILE"
            RESTORE_SUCCESS=true
        else
            echo "Ошибка: не удалось создать жёсткую ссылку '$DEST_PATH'."
        fi
    fi
done

if [ "$RESTORE_SUCCESS" = false ]; then
    echo "Файл не был восстановлен."
fi

