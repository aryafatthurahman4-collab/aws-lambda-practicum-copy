#!/bin/bash

# Script untuk mengakses AWS Lambda Function URL dari WSL 2 (Ubuntu/Kali Linux)
# Berikan URL sebagai argumen pertama atau melalui environment variable FUNCTION_URL.

FUNCTION_URL="${1:-${FUNCTION_URL:-}}"

if [ -z "$FUNCTION_URL" ]; then
    echo "Penggunaan: $0 https://<function-id>.lambda-url.<region>.on.aws"
    echo "Atau: FUNCTION_URL=https://<function-id>.lambda-url.<region>.on.aws $0"
    exit 2
fi

echo "=========================================="
echo "Testing AWS Lambda Function from WSL 2"
echo "=========================================="
echo ""
echo "Function URL: $FUNCTION_URL"
echo ""

echo ""
echo "System Information:"
echo "-------------------"
echo "OS: $(uname -a)"
echo "Kernel: $(uname -r)"
echo "Distro: $(cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '\"')"
echo ""

echo "Accessing Lambda Function..."
echo "---------------------------"
if ! curl --show-error --fail --include "$FUNCTION_URL"; then
    echo ""
    echo "Gagal mengakses Function URL. Periksa URL dan koneksi internet WSL 2."
    exit 1
fi

echo ""
echo "=========================================="
echo "Test completed!"
echo "=========================================="
