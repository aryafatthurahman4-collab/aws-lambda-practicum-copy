#!/bin/bash

# Script untuk mengirim perintah "confirm" ke Docker container
# Script ini mensimulasikan delete Function URL di dalam container

echo "=========================================="
echo "Simulasi Delete Function URL di Docker"
echo "=========================================="
echo ""

# Cek apakah container berjalan
if ! docker ps --format '{{.Names}}' | grep -q "lambda-container"; then
    echo "❌ Container lambda-container tidak berjalan"
    echo "Jalankan dulu: bash start_wsl.sh"
    exit 1
fi

echo "Container berjalan..."
echo ""
echo "Mengirim perintah 'confirm' ke container..."
echo ""

# Kill process node di dalam container dan restart dengan flag deleted
docker exec lambda-container pkill -f node

# Restart container dengan environment variable untuk simulasi delete
docker stop lambda-container
docker rm lambda-container

# Jalankan container baru dengan flag delete
docker run -d -p 9000:9000 --name lambda-container \
    -e FUNCTION_URL_DELETED=1 \
    lambda-pert5

echo ""
echo "✓ Function URL telah dihapus (simulasi)"
echo ""
echo "Refresh browser untuk melihat: {\"Message\":null}"
echo ""
echo "Untuk mengaktifkan kembali:"
echo "docker stop lambda-container"
echo "docker rm lambda-container"
echo "bash start_wsl.sh"
echo ""
