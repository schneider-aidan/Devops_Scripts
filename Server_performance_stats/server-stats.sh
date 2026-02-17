#!/bin/bash

TOP_COMMAND=$(top -b -n 1)
#echo "$TOP_COMMAND"
IDLE_PERCENT=$(echo "$TOP_COMMAND" | grep "Cpu(s)" | awk -F ',' '{print $4}' | awk '{print $1}')
#echo "Idle CPU Percentage: $IDLE_PERCENT%"
USED_PERCENT=$(echo "100 - $IDLE_PERCENT" | bc)


MEMORY_LINE=$(echo "$TOP_COMMAND" | grep 'MiB Mem')
TOTAL_MEM=$(echo "$MEMORY_LINE" | awk -F ':' '{print $2}' | awk '{print $1}')
FREE_MEM=$(echo "$MEMORY_LINE" | awk -F ',' '{print $2}' | awk '{print $1}')
USED_MEM=$(echo "$MEMORY_LINE"  | awk -F ',' '{print $3}' | awk '{print $1}')
USED_MEM_PERCENT=$(awk "BEGIN {printf \"%.2f\\n\", ($USED_MEM / $TOTAL_MEM) * 100}")





echo "Total CPU Usage Percentage: $USED_PERCENT%"
echo "Total Memory Usage Used: $USED_MEM MiB"
echo "Total Memory Usage Free: $FREE_MEM MiB"
echo "Total Memory Usage Percentage: $USED_MEM_PERCENT%"

