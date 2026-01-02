#!/bin/bash

# Direktori instalasi Pterodactyl
PTERO_DIR="/var/www/pterodactyl"
# URL Egg JSON
EGG_URL="https://raw.githubusercontent.com/akbarxyanto/eggbotwa/main/egg-botwa.json"
EGG_FILE="egg-botwa.json"

# Pastikan root
if [ "$EUID" -ne 0 ]; then
  echo "❌ HARUS ROOT!"
  exit 1
fi

# Cek Pterodactyl ada
if [ ! -d "$PTERO_DIR" ]; then
  echo "❌ Pterodactyl tidak ditemukan!"
  exit 1
fi

cd "$PTERO_DIR" || exit 1

# 1. Buat Nest baru otomatis (misal nama "Auto NodeJS Egg")
NEST_NAME="BOT WA TELEGRAM"
echo "📂 Membuat Nest baru: $NEST_NAME"
php artisan pterodactyl:nest:create "$NEST_NAME"

# 2. Ambil email admin user ID 1 (asumsi paling bawah atau pertama)
ADMIN_EMAIL=$(php artisan pterodactyl:user:list | grep "ID: 1" | awk '{print $4}')
echo "📧 Email admin: $ADMIN_EMAIL"

# 3. Download Egg dari raw
echo "⬇️ Download Egg dari raw..."
curl -fsSL "$EGG_URL" -o "$EGG_FILE"

# 4. Validasi JSON
if ! jq empty "$EGG_FILE" 2>/dev/null; then
  echo "❌ Egg JSON rusak!"
  rm -f "$EGG_FILE"
  exit 1
fi

# 5. Import Egg ke Nest otomatis
echo "📦 Mengimpor Egg ke Nest..."
php artisan pterodactyl:import-eggs "$EGG_FILE" --nest="$NEST_NAME" --email="$ADMIN_EMAIL"

# 6. Cek hasil import
if [ $? -eq 0 ]; then
  echo "✅ Egg berhasil diinstall!"
  echo "EGG_NAME: $(jq -r '.name' "$EGG_FILE")"
  echo "ADMIN_EMAIL: $ADMIN_EMAIL"
  rm -f "$EGG_FILE"
else
  echo "❌ Import Egg gagal!"
  exit 1
fi
