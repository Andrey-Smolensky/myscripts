#!/bin/bash
# определяем сеть автоматически, если $1 пустой
if [ -z "$1" ]; then
  # попытка через ip route
  gwip=$(ip route get 1.1.1.1 2>/dev/null | awk '/src/ {print $7; exit}')
  if [ -z "$gwip" ]; then
    # fallback
    gwip=$(hostname -I | awk '{print $1}')
  fi
  # пример: 192.168.1 -> взять первые три октета
  base="${gwip%.*}"
else
  base="$1"
fi

echo "Using base network: $base"

for ip in $(seq 1 254); do
  ping -c 1 "$base.$ip" | grep "64 bytes" | cut -d " " -f 4 | tr -d ":"
done
