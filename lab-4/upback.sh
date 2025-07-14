#!/bin/bash

USER_HOME="/home/$(whoami)"

LATEST_BACKUP=$(ls -dt $USER_HOME/Backup-* | head -n 1)

if [ -z "$LATEST_BACKUP" ]; then
  echo "Нет доступных резервных копий для восстановления."
  exit 1
fi

RESTORE_DIR="$USER_HOME/restore"
mkdir -p "$RESTORE_DIR"

for file in $LATEST_BACKUP/*; do
  if [ -f "$file" ]; then
    if [[ ! "$file" =~ \.[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
      cp "$file" "$RESTORE_DIR/"
      echo "Файл $file восстановлен."
    fi
  fi
done

echo "Восстановление завершено."
