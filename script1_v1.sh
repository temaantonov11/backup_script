#!/bin/bash


if [[ $# -ne 2 ]]; then
        echo "Передай 2 аргумента"
        exit 1
fi

folder_path="$1"
percent="$2"

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

size=$(df -h --output=pcent "$folder_path" |tail -1| sed 's/%//g')


backup_folder="backup/backup_bin/"
mkdir -p "$backup_folder"


while [[ "$size" -gt "$percent" ]]; do
	oldest_file=$(sudo find "$folder_path" -type f -printf '%T@ %p\n' | sort -n | cut -d' ' -f2 | head -1)
	if [[ -z "$oldest_file" ]]; then
		echo "Нет файлов чтобы архивировать"
		break
	fi
	sudo mv "$oldest_file" "$backup_folder"
	size=$(df -h --output=pcent "$folder_path" |tail -1|sed 's/%//g')
done

tar -czvf "backup/backup_$(date +%Y%m%d_%H%M%S).tar.gz" -C "$backup_folder" . 

rm -r "$backup_folder"
