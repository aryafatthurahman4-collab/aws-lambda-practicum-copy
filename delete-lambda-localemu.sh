#!/bin/bash

# Script untuk menghapus Function URL dan Lambda function di LocalEmu
# Simulasi "confirm & delete" dari video

echo "=========================================="
echo "Simulasi Delete Function URL & Lambda"
echo "=========================================="
echo ""

# Set environment variables untuk LocalEmu
export AWS_ENDPOINT_URL=http://localhost:4566
export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
export AWS_DEFAULT_REGION=us-east-1

FUNCTION_NAME="lambda-wsl-tutorial"

# Step 1: Delete Function URL
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

# Delete Function URL
aws lambda delete-function-url-config \
    --function-name "$FUNCTION_NAME" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✓ Function URL berhasil dihapus"
else
    echo "ℹ Function URL mungkin sudah dihapus atau tidak ada"
fi

echo ""

# Step 2: Delete Lambda function
echo "LANGKAH 2: Delete Lambda Function"
echo "----------------------------------------"
echo "Apakah Anda yakin ingin menghapus function ini?"
echo "Action ini tidak dapat dibatalkan."
echo ""

read -p "Ketik nama function untuk konfirmasi ($FUNCTION_NAME): " function_name

if [ "$function_name" != "$FUNCTION_NAME" ]; then
    echo "❌ Nama function salah."
    echo "Penghapusan dibatalkan."
    exit 1
fi

# Delete Lambda function
aws lambda delete-function \
    --function-name "$FUNCTION_NAME" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✓ Function berhasil dihapus"
else
    echo "ℹ Function mungkin sudah dihapus atau tidak ada"
fi

echo ""
echo "=========================================="
echo "SELESAI"
echo "=========================================="
echo ""
echo "Di LocalEmu, langkah ini akan:"
echo "- Menghapus Function URL publik"
echo "- Menghapus Lambda function"
echo "- Data tersimpan di persistence volume LocalEmu"
echo ""
echo "Untuk menghapus semua data LocalEmu:"
echo "docker stop localemu"
echo "docker volume rm localemu-data"
echo ""
