#!/bin/bash

#Проверка на количество аргументов
if [[ $# -ne 3 ]]; then
        echo "Ошибка архивации: необходимо передать 3 аргумента"
        exit 1
fi

folder_path="$1"
percent="$2"
proposal_backup="$3"

#Проверка сущесвтования пути к папке с файлами
if [[ ! -d "$folder_path" ]]; then
        echo "Ошибка архивации: укажите правильный путь до данных"
        exit 1
fi

#Проверка сущесвтования пути куда архивируем
if [[ ! -d "$proposal_backup" ]]; then
        echo "Ошибка архивации: укажите верный путь для сохранения архива"
        exit 1
fi

#Проверка процента заполнения на число
if ! [[ "$percent" =~ ^[0-9]+$ ]]; then
        echo "Ошибка архивации: процент должен быть числом"
        exit 1
fi

#Проверка на то что процент лежит в диапазоне от 1 до 100
if [[ "$percent" -lt 1 || "$percent" -gt 100 ]]; then
        echo "Ошибка архивации: процент должен быть от 1 до 100"
        exit 1
fi

# В size хранится процент заполненности раздела
size=$(df -h --output=pcent "$folder_path" |tail -1| sed 's/%//g')


backup_folder="$proposal_backup/backup_bin/"
mkdir -p "$backup_folder"

echo "Процент заполнения начальный: $size"
echo "Попытка архивации......"
count=0

#Перемещение файлов
while [[ "$size" -gt "$percent" ]]; do
	oldest_file=$(sudo find "$folder_path" -type f -printf '%T@ %p\n' | sort -n | cut -d' ' -f2 | head -n 1)
	if [[ -z "$oldest_file" ]]; then
		echo "Нет файлов чтобы архивировать"
		break
	fi
	sudo mv "$oldest_file" "$backup_folder"
        count=$((count + 1))
	size=$(df -h --output=pcent "$folder_path" |tail -1|sed 's/%//g')   
done



if [[ "$count" -ne 0 ]]; then
        #Архивация
        tar -czf "$proposal_backup/backup_$(date +%Y%m%d_%H%M%S).tar.gz" -C "$backup_folder" &> /dev/null 

        echo "Архивировано: $count самых старых файлов"
        echo "Процент заполнения конечный: $size"
else
        echo "Архивации не было!"
fi

rm -r "$backup_folder"
