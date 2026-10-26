#!/bin/bash

# Script simulasi "Confirm & Delete" dari video AWS Lambda
# Ini mensimulasikan proses menghapus Function URL dan Lambda function
# Tanpa perlu akun AWS - hanya untuk demonstrasi pembelajaran

echo "=========================================="
echo "SIMULASI: Delete Function URL & Lambda"
echo "=========================================="
echo ""
echo "Ini adalah simulasi langkah-langkah dari video:"
echo "1. Delete Function URL (ketik 'confirm')"
echo "2. Delete function"
echo ""

# Simulasi Step 1: Delete Function URL
echo "LANGKAH 1: Delete Function URL"
echo "----------------------------------------"
echo "Warning: When you delete a function URL, you can't recover it."
echo "Creating a new function URL will result in a different URL address."
echo ""
echo "To confirm deletion, type 'confirm' in the field."
echo ""

read -p "Ketik 'confirm' untuk melanjutkan: " user_input

if [ "$user_input" != "confirm" ]; then
    echo "❌ Input salah. Harus ketik 'confirm'"
    echo "Penghapusan dibatalkan."
    exit 1
fi

echo "✓ Function URL berhasil dihapus (simulasi)"
echo ""

# Simulasi Step 2: Delete Function
echo "LANGKAH 2: Delete Function"
echo "----------------------------------------"
echo "Apakah Anda yakin ingin menghapus function ini?"
echo "Action ini tidak dapat dibatalkan."
echo ""

read -p "Ketik nama function untuk konfirmasi (http-function-url-tutorial): " function_name

if [ "$function_name" != "http-function-url-tutorial" ]; then
    echo "❌ Nama function salah."
    echo "Penghapusan dibatalkan."
    exit 1
fi

echo "✓ Function berhasil dihapus (simulasi)"
echo ""

echo "=========================================="
echo "SELESAI"
echo "=========================================="
echo ""
echo "Di AWS Console asli, langkah ini akan:"
echo "- Menghapus Function URL publik"
echo "- Menghapus Lambda function"
echo "- Mencegah biaya berjalan dari free tier"
echo ""
echo "Di environment lokal (tanpa akun AWS):"
echo "- Anda hanya perlu menghentikan server dengan Ctrl+C"
echo "- Atau menghapus Docker container jika menggunakan Docker"
echo ""

# Tampilkan cara menghentikan jika server berjalan
if pgrep -f "node local_server.mjs" > /dev/null; then
    echo "INFO: Server lokal masih berjalan."
    echo "Untuk menghentikan, tekan Ctrl+C di terminal server"
    echo "Atau jalankan: pkill -f 'node local_server.mjs'"
fi

# Cek jika ada container Docker
if docker ps --format '{{.Names}}' | grep -q "lambda-container"; then
    echo "INFO: Docker container masih berjalan."
    echo "Untuk menghentikan: docker stop lambda-container"
    echo "Untuk menghapus: docker rm lambda-container"
fi
