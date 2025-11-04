#!/usr/bin/env bash
set -euo pipefail

echo "=== Step 1: Run hello-world ==="
docker run --rm hello-world

echo
echo "=== Step 2: Start Nginx on port 8080 ==="
docker run -d --name web1 -p 8080:80 nginx:alpine
echo "Open http://localhost:8080 in your browser to check Nginx."

echo
echo "=== Step 3: Start 10 Nginx containers on ports 8081..8090 ==="
for i in {1..10}; do
  PORT=$((8080+i))
  NAME="nginx-$i"
  echo "Starting $NAME on port $PORT..."
  docker run -d --name "$NAME" -p "$PORT:80" nginx:alpine
done
echo "All containers started."

echo
echo "=== Step 4: Show running containers ==="
docker ps --format "table {{.Names}}\t{{.Ports}}"

echo
echo "=== Step 5: Stop and remove all containers ==="
docker rm -f $(docker ps -aq) >/dev/null 2>&1 || true
echo "All containers stopped and removed."

echo
echo "Done!"