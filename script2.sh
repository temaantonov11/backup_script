#!/bin/bash
main_file="script1.sh"


# Путь для тестовых данных
test_dir="/home/sokolmax/sect"
proposal_backup="./backup"

clean_folder() {
    sudo find "$test_dir" -type f -exec rm {} +
}

run_test() {
    local test_name="$1"
    local percent="$2"
    local count_files="$3"
    local file_size="$4"
    echo "--------------------------"
    echo "$test_name"
    for ((i=1; i<=count_files; i++)); do

        dd if=/dev/zero of="$test_dir/logfile$i.log" bs=1M count=$file_size &> /dev/null
        sleep 0.1

    done
    echo "Объем папки изначально: $((file_size * count_files)) Mбайт"
    ./script1.sh "$test_dir" "$percent" "$proposal_backup"
    echo "--------------------------"
    clean_folder
}




# Тест 1: папка занята меньше чем на X(70%), нет архивации
run_test "Тест 1: X = 70%, 100 файлов по 10M" 70 100 10

# Тест 2: архивация v1
run_test "Тест 2: X = 70%, 150 файлов по 10M" 70 150 10

# Тест 3: архивация v2
run_test "Тест 3: X = 10%, 50 файлов по 15M" 10 50 15

# Тест 4: ошибка при запуске
run_test "Тест 4: X = -123%, 50 файлов по 10M, " -123 50 10
