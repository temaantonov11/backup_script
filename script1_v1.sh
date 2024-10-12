#!/bin/bash


if [[ $# -ne 3 ]]; then
        echo "Передай 3 аргумента"
        exit 1
fi

folder_path="$1"
percent="$2"
size="$3"

if [[ ! -d "$folder_path" ]]; then
        echo "Это не путь"
        exit 1
fi

if ! [[ "$percent" =~ ^[0-9]+$ ]]; then
        echo "Введи число"
        exit 1
fi

if [[ "$percent" -lt 1 || "$percent" -gt 100 ]]; then
        echo "Процент должен быть от 1 до 100"
        exit 1
fi

if ! [[ "$size" =~ ^[0-9]+$ ]]; then
        echo "Размер должен быть числом"
        exit 1
fi

size_b=$((("$percent" * "$size" * 1024 * 1024 * 1024)/100))
folder_size=$(du -sb "$folder_path" | cut -f1)
backup_folder="backup/backup_bin/"
mkdir -p "$backup_folder"

while [[ "$folder_size" -gt "$size_b" ]]; do
	oldest_file=$(find "$folder_path" -type f -printf '%T@ %p\n' | sort -n | cut -d' ' -f2 | head -1)
	if [[ -z "$oldest_file" ]]; then
		echo "Нет файлов чтобы архивировать"
		break
	fi
	mv "$oldest_file" "$backup_folder"
	folder_size=$(du -sb "$folder_path" | cut -f1)
done

tar -czvf "backup/backup_$(date +%Y%m%d_%H%M%S).tar.gz" -C "$backup_folder" .

rm -r "$backup_folder"
