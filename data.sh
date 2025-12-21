#!/bin/bash

PTERO_DIR="/var/www/pterodactyl"
EGG_URL="https://raw.githubusercontent.com/khususprotectsyah/eggbotwa/main/egg-botwa.json"
EGG_FILE="egg-botwa.json"

echo "🚀 INSTALL EGG NODEJS 100% AUTO"

# 1. HARUS ROOT
if [ "$EUID" -ne 0 ]; then
  echo "❌ HARUS ROOT!"
  exit 1
fi

# 2. CEK PTERODACTYL ADA
if [ ! -d "$PTERO_DIR" ]; then
  echo "❌ Pterodactyl tidak ada di $PTERO_DIR"
  exit 1
fi

cd "$PTERO_DIR" || exit 1

# 3. CEK ARTISAN & COMPOSER
if [ ! -f "artisan" ]; then
  echo "❌ artisan tidak ditemukan!"
  exit 1
fi

# 4. DOWNLOAD EGG + VALIDASI
echo "⬇️ Download egg..."
if ! curl -fsSL "$EGG_URL" -o "$EGG_FILE"; then
  echo "❌ Download gagal!"
  exit 1
fi

if [ ! -s "$EGG_FILE" ]; then
  echo "❌ Egg file kosong!"
  rm -f "$EGG_FILE"
  exit 1
fi

# 5. CEK JSON VALID
if ! jq empty "$EGG_FILE" 2>/dev/null; then
  echo "❌ Egg JSON rusak!"
  rm -f "$EGG_FILE"
  exit 1
fi

# 6. IMPORT EGG
echo "📦 Import egg..."
php artisan pterodactyl:import-eggs "$EGG_FILE"

if [ $? -eq 0 ]; then
  echo "✅ EGG NODEJS TERPASANG 100%!"
  rm -f "$EGG_FILE"
else
  echo "❌ Import gagal!"
  exit 1
fi
