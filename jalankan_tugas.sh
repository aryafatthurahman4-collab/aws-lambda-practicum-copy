#!/bin/bash
# Script Otomatis Menjalankan Tugas Pertemuan 5 - AWS Lambda di WSL 2 Ubuntu / Docker

echo "=================================================================="
echo "    PRAKTIKUM PERTEMUAN 5 - AWS LAMBDA (LOCAL SIMULATION)        "
echo "=================================================================="
echo ""
echo "Pilih metode eksekusi:"
echo "1) Jalankan langsung menggunakan Node.js di Ubuntu"
echo "2) Jalankan di dalam Docker Container (Port 9000)"
echo "3) Test curl ke http://localhost:9000"
echo "4) Keluar"
echo ""
read -p "Masukkan pilihan [1-4]: " PILIHAN

case $PILIHAN in
    1)
        echo "[INFO] Menjalankan server lokal Lambda..."
        node local_server.mjs
        ;;
    2)
        echo "[INFO] Membangun image Docker..."
        docker build -t aws-lambda-pert5 .
        echo "[INFO] Menghentikan container lama jika ada..."
        docker rm -f lambda-container 2>/dev/null
        echo "[INFO] Menjalankan container Docker di port 9000..."
        docker run -it --rm -p 9000:9000 --name lambda-container aws-lambda-pert5
        ;;
    3)
        echo "[INFO] Melakukan CURL ke http://localhost:9000 ..."
        curl -i http://localhost:9000
        ;;
    *)
        echo "Keluar."
        ;;
esac
