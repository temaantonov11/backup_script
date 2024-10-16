#!/bin/bash

folder_path="$1"

# создаем пустой файл размером 2Гб (фиксированный размер раздела, который мы создаем)  и заполняем его нулями
dd if=/dev/zero of=pattern.fs bs=1G count=2

# создаем файловую систему в файле pattern.fs
sudo mkfs.ext4 pattern.fs

# монтируем ранее созданную файловую систему в папку, переданную как параметр
sudo mount -o users,rw -t ext4 pattern.fs "$folder_path"

# меняем права доступа к разделу на запись/чтение/выполение для всех пользователей
sudo chmod a+rwx "$folder_path"

# удаляем файл pattern.fs
rm pattern.fs
