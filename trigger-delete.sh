#!/bin/bash

# Script untuk mensimulasikan delete Function URL via HTTP API
# Dapat dijalankan dari Windows, WSL 2, atau terminal manapun

echo "=========================================="
echo "Simulasi Delete Function URL"
echo "=========================================="
echo ""

# Check jika server berjalan
if ! curl -s http://localhost:9000 > /dev/null 2>&1; then
    echo "❌ Server tidak berjalan di http://localhost:9000"
    echo "Jalankan dulu: bash start_wsl.sh"
    exit 1
fi

echo "Mengirim perintah delete ke server..."
echo ""

# Send POST request to delete endpoint
curl -X POST http://localhost:9000/delete-function-url

echo ""
echo ""
echo "✓ Function URL telah dihapus (simulasi)"
echo ""
echo "Cek dengan curl:"
echo "curl http://localhost:9000"
echo ""
echo "Expected output: {\"Message\":null}"
echo ""
echo "Untuk mengaktifkan kembali:"
echo "curl -X POST http://localhost:9000/activate-function-url"
echo ""
