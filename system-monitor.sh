#!/bin/bash
cpu_limit=${1:-70}
mem_limit=${1:-80}
disk_limit=${1:-80}

log_file="system-monitor.log"

print_alert() { echo -e "\e[31m  $1\e[0m"; }
print_info() { echo -e "\e[32m$1\e[0m"; }
print_warn() { echo -e "\e[33m$1\e[0m"; }      

while true; do
    clear
    echo "        LINUX SYSTEM MONITOR         "
    echo "Thresholds -> CPU: $cpu_limit%, MEM: $mem_limit%, DISK: $disk_limit%"

    CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print int($2 + $4)}')
    echo -n "CPU Usage: $CPU% "
    [ "$CPU" -gt "$cpu_limit" ] && print_alert "high!!!!!!!!"
    [ "$CPU" -le " $cpu_limit" ] && print_info "✔ Normal"

    MEM=$(free | grep Mem | awk '{print int($3/$2 * 100)}')
    echo -n "Memory Usage: $MEM% "
    [ "$MEM" -gt "$mem_limit" ] && print_alert "high!!!!!!!!!"
    [ "$MEM" -le "$mem_limit" ] && print_info "✔ Normal"

    DISK=$(df / | tail -1 | awk '{print int($5)}')
    echo -n "Disk Usage: $DISK% "
    [ "$DISK" -gt "$disk_limit" ] && print_alert "High!!!!!!!"
    [ "$DISK" -le "$disk_limit" ] && print_info "✔ Normal"

    echo "$(date): CPU=$CPU%, MEM=$MEM%, DISK=$DISK%" >> "$log_file"

    read -p "Do you want to exit? (y/n): " choice
    if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
        echo "Exiting system monitor..."
        git add system-monitor.sh system-monitor.log README.md
        git commit -m "updates $(date)"
        git push origin main
        break   
    else  
        sleep 2
    fi
 
done
