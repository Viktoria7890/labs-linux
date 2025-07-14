#!/bin/bash

HOME_DIR="/home/$USER"
SOURCE_DIR="$HOME_DIR/source"
REPORT_FILE="$HOME_DIR/backup-report"
TODAY=$(date +%F)  # Формат YYYY-MM-DD
BACKUP_NAME="Backup-$TODAY"
BACKUP_PATH="$HOME_DIR/$BACKUP_NAME"

latest_backup=$(find "$HOME_DIR" -maxdepth 1 -type d -name "Backup-*" | sort -r | while read dir; do
  dir_date=$(basename "$dir" | cut -d'-' -f2-)
  if (( $(date -d "$TODAY" +%s) - $(date -d "$dir_date" +%s) < 604800 )); then
    echo "$dir"
    break
  fi
done)

if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "Каталог $SOURCE_DIR не существует. Создайте его и добавьте туда файлы."
  exit 1
fi

if [[ -z "$latest_backup" ]]; then
  mkdir "$BACKUP_PATH"
  echo "Создан новый каталог резервного копирования: $BACKUP_PATH"
  echo "Создан новый каталог резервного копирования: $BACKUP_PATH" >> "$REPORT_FILE"
  echo "Дата создания: $TODAY" >> "$REPORT_FILE"
  echo "Список скопированных файлов:" >> "$REPORT_FILE"

  for file in "$SOURCE_DIR"/*; do
    cp "$file" "$BACKUP_PATH/"
    filename=$(basename "$file")
    echo "  → Скопирован $filename"
    echo "$filename" >> "$REPORT_FILE"
  done
else
  echo "Используется существующий каталог: $latest_backup"
  echo "Обновление действующего каталога резервного копирования: $latest_backup" >> "$REPORT_FILE"
  echo "Дата обновления: $TODAY" >> "$REPORT_FILE"

  for file in "$SOURCE_DIR"/*; do
    filename=$(basename "$file")
    dest_file="$latest_backup/$filename"

    if [[ ! -f "$dest_file" ]]; then
      cp "$file" "$latest_backup/"
      echo "  → Новый файл $filename скопирован"
      echo "$filename" >> "$REPORT_FILE"
    else
      source_size=$(stat -c %s "$file")
      dest_size=$(stat -c %s "$dest_file")
      if [[ "$source_size" -ne "$dest_size" ]]; then
        mv "$dest_file" "$dest_file.$TODAY"
        cp "$file" "$latest_backup/"
        echo "  → Версия файла $filename отличается: создаём $filename.$TODAY"
        echo "$filename $filename.$TODAY" >> "$REPORT_FILE"
      fi
    fi
  done
fi
