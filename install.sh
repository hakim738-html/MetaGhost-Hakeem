#!/bin/bash
# ==========================================
# 🔥 HAKEEM Security Suite Installer v7.0
# 👨‍💻 One-Command Installation
# ==========================================

echo ""
echo "========================================"
echo "     HAKEEM Security Suite Installer"
echo "========================================"

echo ""
echo "📦 Step 1: Updating system..."
pkg update -y

echo ""
echo "🔧 Step 2: Installing core tools..."
pkg install exiftool -y        # Metadata analysis
pkg install steghide -y        # Steganography
pkg install imagemagick -y     # Image processing
pkg install python -y          # Python 3
pkg install git -y             # Version control

echo ""
echo "🐍 Step 3: Installing Python modules..."
pip install requests           # HTTP library

echo ""
echo "📁 Step 4: Creating directory structure..."
mkdir -p reports backups clean_output stego_files extracted_files phishing_pages captured_data

echo ""
echo "🔒 Step 5: Setting permissions..."
chmod +x HAKEEM.sh

echo ""
echo "========================================"
echo "     ✅ INSTALLATION COMPLETE!"
echo "========================================"
echo ""
echo "🚀 To start HAKEEM Security Suite:"
echo ""
echo "   chmod +x HAKEEM.sh"
echo "   ./HAKEEM.sh"
echo ""
echo "✨ All-in-One Features:"
echo "   • 📸 Image forensics & metadata analysis"
echo "   • 🕵️ File hiding & extraction (steganography)"
echo "   • 🌐 Educational web testing pages"
echo "   • 💣 Advanced security tools"
echo ""
echo "⚠️  LEGAL NOTE: Use only for authorized"
echo "    testing and educational purposes."
echo ""
echo "👨‍💻 Developer: Hakeem"
echo "🌐 GitHub: github.com/hakim738-html"
echo "========================================"
