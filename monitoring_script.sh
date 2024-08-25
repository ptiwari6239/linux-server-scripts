#!/bin/bash

# Function to display the top 10 most used applications
display_top_applications() {
    echo "Top 10 Applications by CPU and Memory Usage:"
    ps aux --sort=-%cpu,-%mem | head -n 11
    echo "-------------------------------------------"
}

# Function to display network monitoring data
display_network_monitoring() {
    echo "Network Monitoring:"
    echo "Number of concurrent connections: $(netstat -tun | grep ESTABLISHED | wc -l)"
    echo "Packet drops: $(netstat -s | grep 'dropped')"
    echo "MB in: $(ifconfig | grep 'RX bytes' | awk '{print $2}' | cut -d: -f2 | awk '{s+=$1} END {print s/1024/1024 " MB"}')"
    echo "MB out: $(ifconfig | grep 'TX bytes' | awk '{print $6}' | cut -d: -f2 | awk '{s+=$1} END {print s/1024/1024 " MB"}')"
    echo "-------------------------------------------"
}

# Function to display disk usage
display_disk_usage() {
    echo "Disk Usage:"
    df -h | awk '$5 > 80 {print "Partition " $1 " is using " $5 " of space!"}'
    echo "-------------------------------------------"
}

# Function to display system load
display_system_load() {
    echo "System Load:"
    uptime
    echo "CPU usage breakdown:"
    top -bn1 | grep "Cpu(s)"
    echo "-------------------------------------------"
}

# Function to display memory usage
display_memory_usage() {
    echo "Memory Usage:"
    free -m
    echo "-------------------------------------------"
}

# Function to display process monitoring
display_process_monitoring() {
    echo "Process Monitoring:"
    echo "Number of active processes: $(ps aux | wc -l)"
    echo "Top 5 processes by CPU and Memory usage:"
    ps aux --sort=-%cpu,-%mem | head -n 6
    echo "-------------------------------------------"
}

# Function to display service monitoring
display_service_monitoring() {
    echo "Service Monitoring:"
    services=("sshd" "nginx" "apache2" "iptables")
    for service in "${services[@]}"
    do
        systemctl is-active --quiet $service && echo "$service is running" || echo "$service is not running"
    done
    echo "-------------------------------------------"
}

# Function to display the full dashboard
display_full_dashboard() {
    display_top_applications
    display_network_monitoring
    display_disk_usage
    display_system_load
    display_memory_usage
    display_process_monitoring
    display_service_monitoring
}

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -cpu) display_system_load; ;;
        -memory) display_memory_usage; ;;
        -network) display_network_monitoring; ;;
        -disk) display_disk_usage; ;;
        -process) display_process_monitoring; ;;
        -services) display_service_monitoring; ;;
        -top) display_top_applications; ;;
        *) echo "Unknown parameter passed: $1"; exit 1; ;;
    esac
    shift
done

# If no arguments, display full dashboard
if [ "$#" -eq 0 ]; then
    while true; do
        clear
        display_full_dashboard
        sleep 5
    done
fi
