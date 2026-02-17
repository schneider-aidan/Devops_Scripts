#!/bin/bash

TOP_COMMAND=$(top -b -n 1)
IDLE_PERCENT=$(echo "$TOP_COMMAND" | grep "Cpu(s)" | awk -F ',' '{print $4}' | awk '{print $1}')
USED_PERCENT=$(echo "100 - $IDLE_PERCENT" | bc)


MEMORY_LINE=$(free | grep -w 'Mem:')
TOTAL_MEM_MiB=$(echo "$MEMORY_LINE" | awk '{print $2}')
#FREE_MEM=$(echo "$MEMORY_LINE" | awk -F ',' '{print $2}' | awk '{print $1}')
USED_MEM_MiB=$(echo "$MEMORY_LINE"  | awk '{print $3}')

USED_MEM_GB=$(awk "BEGIN {printf \"%.2f\\n\", $USED_MEM_MiB / 1024^2}")
TOTAL_MEM_GB=$(awk "BEGIN {printf \"%.2f\\n\", $TOTAL_MEM_MiB / 1024^2}")
USED_MEM_PERCENT=$(awk "BEGIN {printf \"%.2f\\n\", ($USED_MEM_GB / $TOTAL_MEM_GB) * 100}")


DISK_USAGE_LINE=$(df -h --total | grep "total")
#echo "$DISK_USAGE_LINE"
TOTAL_DISK=$(echo "$DISK_USAGE_LINE" | awk '{print $2}')
USED_DISK=$(echo "$DISK_USAGE_LINE" | awk '{print $3}')
USED_DISK_PERCENT=$(echo "$DISK_USAGE_LINE" | awk '{print $5}')

echo "CPU Usage: $USED_PERCENT%"
echo

echo "Memory Usage:"
echo "$USED_MEM_GB GiB / $TOTAL_MEM_GB GiB ($USED_MEM_PERCENT%)"
echo

echo "Disk Usage:"
echo "Used: $USED_DISK / Total: $TOTAL_DISK ($USED_DISK_PERCENT%)"
echo

echo "Top 5 Processes by CPU Usage:"
ps aux --sort -%cpu | head -n 6 | awk '{print $2 "\t" $3 "\t" $4 "\t" $11}'
echo

echo "Top 5 Processes by Memory Usage:"
ps aux --sort -%mem | head -n 6 | awk '{print $2 "\t" $3 "\t" $4 "\t" $11}'
echo

echo "OS Version: $(uname -a)"
echo

echo "Uptime: $(uptime -p)"
echo

echo "Logged in users: $(users | wc -w)"
