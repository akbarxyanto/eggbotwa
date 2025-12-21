#!/bin/bash

# ===== CONFIG =====
PTERO_DIR="/var/www/pterodactyl"
EGG_URL="https://raw.githubusercontent.com/khususprotectsyah/eggbotwa/main/egg-botwa.json"
EGG_FILE="egg-botwa.json"

echo "🚀 AUTO INSTALL EGG NODEJS PTERODACTYL"

# ===== CEK ROOT =====
if [ "$EUID" -ne 0 ]; then
  echo "❌ Harus dijalankan sebagai root"
  exit 1
fi

# ===== CEK PTERODACTYL =====
if [ ! -d "$PTERO_DIR" ]; then
  echo "❌ Folder Pterodactyl tidak ditemukan!"
  exit 1
fi

cd "$PTERO_DIR" || exit 1

# ===== DOWNLOAD EGG =====
echo "⬇️ Download egg..."
curl -fsSL "$EGG_URL" -o "$EGG_FILE"

if [ ! -f "$EGG_FILE" ]; then
  echo "❌ Gagal download egg"
  exit 1
fi

# ===== IMPORT EGG =====
echo "📦 Import egg ke panel..."
php artisan pterodactyl:import-eggs "$EGG_FILE"

if [ $? -ne 0 ]; then
  echo "❌ Gagal import egg"
  exit 1
fi

echo "✅ EGG NODEJS BERHASIL DIPASANG"
  
