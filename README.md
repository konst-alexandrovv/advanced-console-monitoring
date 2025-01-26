# Advanced Monitoring Tools / Продвинутые инструменты мониторинга

**A collection of advanced shell scripts for system monitoring and administration.**
Набор продвинутых скриптов для мониторинга и администрирования системы.

## Features / Возможности

- Interactive command monitoring with customizable refresh rate
- Process monitoring with CPU/Memory visualization
- Log monitoring with color highlighting
- Port scanning with visualization
- File search with vim integration
- Real-time process statistics

## Installation / Установка

```bash
git clone https://github.com/username/monitoring-tools
cd monitoring-tools
chmod +x install.sh
./install.sh
```

## Tools / Инструменты

### watch-command / Мониторинг команд
Interactive command execution with refresh.
```bash
watch_command 'ps aux | grep nginx' 2
```

### vim-find / Поиск с vim
Search files and open results in vim tabs.
```bash
vim_find /path/to/search "pattern"
```

### process-monitor / Монитор процессов
Visual process monitoring with CPU/Memory graphs.
```bash
process_monitor nginx
```

### log-monitor / Монитор логов
Log monitoring with color highlighting.
```bash
log_monitor /var/log/syslog 'error|warn'
```

### port-scanner / Сканер портов
Port scanning with visual feedback.
```bash
port_scanner localhost 80 1000
```

## Script Contents / Содержимое скриптов

```bash
${document_content}
```

## Dependencies / Зависимости

- vim
- inotify-tools
- bc
- lsof
- netstat
- iftop

Review with Claude 3.5
