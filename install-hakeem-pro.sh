#!/bin/bash
# ==========================================
# 🔧 HAKEEM PRO INSTALLER
# ==========================================

echo ""
echo "========================================"
echo "     H A K E E M   P R O   S E T U P"
echo "========================================"

echo ""
echo "📦 Installing dependencies..."
pkg update -y
pkg install exiftool python termux-api -y
pip install requests

echo ""
echo "📁 Creating workspace..."
mkdir -p ~/Hakeem-Data/{pages,logs,captured}

echo ""
echo "🔧 Setting up tools..."
chmod +x Hakeem-Forensic-Pro.sh

echo ""
echo "✅ Installation complete!"
echo ""
echo "🚀 To start:"
echo "   ./Hakeem-Forensic-Pro.sh"
echo ""
echo "✨ Features:"
echo "   • 3 Educational Web Pages"
echo "   • Live Data Logging to Terminal"
echo "   • Image Forensics Tools"
echo "   • Auto-browser opening"
echo ""
echo "👑 Developer: Hakeem"
echo "🌐 GitHub: hakim738-html"
echo "========================================"