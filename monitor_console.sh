#!/bin/bash

# Interactive command monitor with customizable interval
# Интерактивный watch с настраиваемым интервалом
watch_command() {
    local cmd="$1"
    local interval="${2:-1}"

    # Argument validation / Проверка аргументов
    if [ -z "$cmd" ]; then
        echo "Usage / Использование: $0 'command/команда' [interval/интервал]"
        exit 1
    }

    tput clear
    while true; do
        # Save cursor position / Сохраняем позицию курсора
        tput sc

        # Display header / Выводим заголовок
        echo -e "\033[1;34m=== Command Monitor / Мониторинг команды: $cmd (Interval / Интервал: ${interval}s) ===\033[0m"
        echo -e "\033[1;30m$(date '+%Y-%m-%d %H:%M:%S')\033[0m\n"

        # Execute command / Выполняем команду
        eval "$cmd"

        # Restore cursor / Восстанавливаем курсор
        tput rc
        sleep "$interval"
        tput clear
    done
}

# File search with vim
# Поиск файлов с открытием в vim
vim_find() {
    # Temporary results file / Временный файл для результатов
    local temp_file="/tmp/vim_find_results.txt"
    local search_dir="${1:-.}"
    local pattern="$2"

    # Argument validation / Проверка аргументов
    if [ -z "$pattern" ]; then
        echo "Usage / Использование: $0 [directory/директория] pattern/шаблон"
        exit 1
    fi

    # Clear temp file / Очищаем временный файл
    > "$temp_file"

    # Search files / Ищем файлы
    find "$search_dir" -type f -exec grep -l "$pattern" {} \; > "$temp_file"

    # Open results / Открываем результаты
    if [ -s "$temp_file" ]; then
        vim -p $(cat "$temp_file")
    else
        echo "Files not found / Файлы не найдены"
    fi
}

# Process monitor with visualization
# Интерактивный монитор процессов с визуализацией
process_monitor() {
    local process_name="$1"
    local width=50  # Graph width / Ширина графика

    if [ -z "$process_name" ]; then
        echo "Usage / Использование: $0 process_name/имя_процесса"
        exit 1
    fi

    while true; do
        clear
        echo -e "\033[1;34m=== Process Monitor / Монитор процесса: $process_name ===\033[0m"

        # Get process stats / Получаем статистику
        local cpu=$(ps aux | grep "$process_name" | grep -v grep | awk '{print $3}')
        local mem=$(ps aux | grep "$process_name" | grep -v grep | awk '{print $4}')
        local pid=$(pgrep "$process_name")

        # Draw graphs / Рисуем графики
        if [ ! -z "$cpu" ]; then
            local cpu_bars=$(printf "%.0f" $(echo "$cpu * $width / 100" | bc -l))
            echo -en "\nCPU Usage / Использование CPU: [$cpu%] "
            for ((i=0; i<cpu_bars; i++)); do echo -en "\033[1;31m|\033[0m"; done
            echo

            local mem_bars=$(printf "%.0f" $(echo "$mem * $width / 100" | bc -l))
            echo -en "Memory Usage / Использование памяти: [$mem%] "
            for ((i=0; i<mem_bars; i++)); do echo -en "\033[1;32m|\033[0m"; done
            echo

            echo -e "\nProcess ID / ID процесса: $pid"
            echo "Open files / Открытые файлы:"
            lsof -p "$pid" | head -n 5

            echo -e "\nConnections / Соединения:"
            netstat -np 2>/dev/null | grep "$pid" | head -n 5
        else
            echo "Process not found / Процесс не найден"
        fi

        sleep 1
    done
}

# Log monitor with highlighting
# Монитор лог-файла с подсветкой
log_monitor() {
    local log_file="$1"
    local pattern="${2:-.*}"  # Optional filter / Опциональный фильтр

    if [ ! -f "$log_file" ]; then
        echo "File not found / Файл не найден: $log_file"
        exit 1
    fi

    # Color setup / Настройка цветов
    local error_color="\033[1;31m"    # Red / Красный
    local warn_color="\033[1;33m"     # Yellow / Желтый
    local info_color="\033[1;32m"     # Green / Зеленый
    local reset_color="\033[0m"

    tail -f "$log_file" | while read -r line; do
        if [[ "$line" =~ $pattern ]]; then
            # Highlight by content / Подсветка по содержимому
            if [[ "$line" =~ [Ee]rror|ERROR|FAIL ]]; then
                echo -e "${error_color}${line}${reset_color}"
            elif [[ "$line" =~ [Ww]arn|WARN ]]; then
                echo -e "${warn_color}${line}${reset_color}"
            else
                echo -e "${info_color}${line}${reset_color}"
            fi
        fi
    done
}

# Port scanner with visualization
# Сканер портов с визуализацией
port_scanner() {
    local host="$1"
    local start_port="${2:-1}"
    local end_port="${3:-1000}"

    if [ -z "$host" ]; then
        echo "Usage / Использование: $0 host/хост [start_port/начальный_порт] [end_port/конечный_порт]"
        exit 1
    fi

    echo -e "\033[1;34m=== Port Scan / Сканирование портов for/для $host ===\033[0m\n"

    for port in $(seq "$start_port" "$end_port"); do
        (echo >/dev/tcp/"$host"/"$port") >/dev/null 2>&1 && \
        echo -e "\033[1;32m[OPEN/ОТКРЫТ]\033[0m Port/Порт $port" || \
        echo -e "\033[1;31m[CLOSED/ЗАКРЫТ]\033[0m Port/Порт $port" &

        # Limit parallel processes / Ограничиваем параллельные процессы
        if [ $((port % 20)) -eq 0 ]; then
            wait
        fi
    done
    wait
}
