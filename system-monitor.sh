#!/bin/bash
cpu_limit=${1:-70}
mem_limit=${1:-80}
disk_limit=${1:-80}
technical_dep_email="maramborni@outlook.com"
log_file="system-monitor.log"

print_alert() { echo -e "\e[31m  $1\e[0m"; }
print_info() { echo -e "\e[32m$1\e[0m"; }
print_warn() { echo -e "\e[33m$1\e[0m"; }      
send_email_alert() {
    subject="$1"
    body="$2"
    echo "$body" | mail -s "$subject" "$technical_dep_email"
}

while true; do
    clear
    echo "        LINUX SYSTEM MONITOR         "
    echo "Thresholds -> CPU: $cpu_limit%, MEM: $mem_limit%, DISK: $disk_limit%"

    CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print int($2 + $4)}')
    echo -n "CPU Usage: $CPU% "
    if [ "$CPU" -gt "$cpu_limit" ]; then
    print_alert "CPU High!"
    send_email_alert "CPU Alert" "CPU usage is $CPU%, above $cpu_limit%!"

 else  [ "$CPU" -le " $cpu_limit" ] && print_info "✔ Normal"

fi

    MEM=$(free | grep Mem | awk '{print int($3/$2 * 100)}')
    echo -n "Memory Usage: $MEM% "
    if [ "$MEM" -gt "$mem_limit" ]; then
    print_alert "High Mem huryy !"
    send_email_alert "Mem alert" "Mem usage is $MEM%, above $mem_limit%!"

   else  [ "$MEM" -le "$mem_limit" ] && print_info "✔ Normal"
fi

    DISK=$(df / | tail -1 | awk '{print int($5)}')
    echo -n "Disk Usage: $DISK% "
    if [ "$DISK" -gt "$disk_limit" ]; then
    print_alert "disk about to explodeee"
    send_email_alert "DISKK Alert" "disk usage is $DISK%, above $disk_limit%!"

    else [ "$DISK" -le "$disk_limit" ] && print_info "✔ Normal"
fi

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
