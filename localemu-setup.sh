#!/bin/bash

# Script untuk menjalankan LocalEmu (AWS Cloud Emulator) di WSL 2
# LocalEmu mensimulasikan 133+ layanan AWS termasuk Lambda, EC2, RDS
# Tidak perlu akun AWS, gratis, berjalan lokal

echo "=========================================="
echo "LocalEmu Setup - AWS Cloud Emulator"
echo "=========================================="
echo ""

# Cek Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker tidak terinstall. Install dulu di WSL 2."
    exit 1
fi

# Cek apakah container localemu sudah ada
if docker ps -a --format '{{.Names}}' | grep -q "localemu"; then
    echo "Container localemu sudah ada, menghentikan..."
    docker stop localemu 2>/dev/null
    docker rm localemu 2>/dev/null
fi

# Jalankan LocalEmu
echo "Menjalankan LocalEmu..."
docker run --rm -d --name localemu \
    -p 4566:4566 \
    -p 4510-4559:4510-4559 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --group-add docker \
    -e DASHBOARD_API_OPEN=1 \
    -e PERSISTENCE=1 \
    -v localemu-data:/var/lib/localemu \
    localemu/localemu:latest

echo ""
echo "Menunggu LocalEmu siap..."
sleep 5

# Cek health
if curl -s http://localhost:4566/_localemu/health > /dev/null; then
    echo "✓ LocalEmu berjalan dengan baik!"
else
    echo "❌ LocalEmu gagal start. Cek logs: docker logs localemu"
    exit 1
fi

echo ""
echo "=========================================="
echo "LocalEmu Berjalan!"
echo "=========================================="
echo "Dashboard: http://localhost:4566/_localemu/dashboard"
echo "Endpoint: http://localhost:4566"
echo ""
echo "Export environment variables:"
echo "export AWS_ENDPOINT_URL=http://localhost:4566"
echo "export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE"
echo "export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
echo "export AWS_DEFAULT_REGION=us-east-1"
echo ""
echo "Cek status: curl http://localhost:4566/_localemu/health"
echo "Stop: docker stop localemu"
echo "=========================================="
