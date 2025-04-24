#!/bin/bash

get_cpu_usage() {
    grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print int(usage)}'
}

get_memory_info() {
    free | grep Mem | awk '{printf "{\"total\": %d, \"used\": %d, \"free\": %d, \"percentage\": %.1f}", $2, $3, $4, ($3/$2)*100}'
}

get_gpu_info() {
    nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null || echo "0"
}

get_temperature() {
    sensors | grep "Package id 0" | awk '{print $4}' | sed 's/+//;s/°C//' || echo "0"
}

get_disk_usage() {
    df -h / | tail -1 | awk '{printf "{\"total\": \"%s\", \"used\": \"%s\", \"free\": \"%s\", \"percentage\": %d}", $2, $3, $4, $5}'
}

# Obtener valores y asegurarse de que son números válidos
cpu_usage=$(get_cpu_usage)
gpu_usage=$(get_gpu_info | tr -d '\n')
temp=$(get_temperature)

# Asegurarse de que gpu_usage es un número válido
if ! [[ "$gpu_usage" =~ ^[0-9]+$ ]]; then
    gpu_usage="0"
fi

echo "{
    \"cpu\": {
        \"usage\": $cpu_usage,
        \"temperature\": $temp
    },
    \"memory\": $(get_memory_info),
    \"gpu\": {
        \"usage\": $gpu_usage
    },
    \"disk\": $(get_disk_usage)
}"
