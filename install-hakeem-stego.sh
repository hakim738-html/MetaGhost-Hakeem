#!/bin/bash
# ===================================================
# 🛠️ HAKEEM STEGANOGRAPHY TOOL INSTALLER
# ===================================================

echo "╔══════════════════════════════════════════════════════╗"
echo "║                                                      ║"
echo "║   🔥 HAKEEM STEGANOGRAPHY & FORENSICS TOOL 🔥      ║"
echo "║                                                      ║"
echo "║   👑 Developer: Hakeem Al-Arab                      ║"
echo "║   🌐 GitHub: hakim738-html                           ║"
echo "║   🎯 Version: 6.0 Professional                      ║"
echo "║                                                      ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""

echo "[*] Updating package list..."
pkg update -y

echo "[*] Installing ExifTool..."
pkg install exiftool -y

echo "[*] Installing Steghide for steganography..."
pkg install steghide -y

echo "[*] Installing additional tools..."
pkg install file -y
pkg install binutils -y

echo "[*] Creating working directories..."
mkdir -p ~/Hakeem-Stego/{stego-images,reports,hidden-files,logs}

echo "[*] Setting up the tool..."
chmod +x hakeem-stego.sh

echo ""
echo "✅ INSTALLATION COMPLETE!"
echo ""
echo "🚀 TO START THE TOOL:"
echo "   ./hakeem-stego.sh"
echo ""
echo "✨ FEATURES:"
echo "   • ✅ Hide text/files inside images (Steganography)"
echo "   • ✅ Extract hidden data from images"
echo "   • ✅ Forensic analysis with HTML reports"
echo "   • ✅ GPS location extraction"
echo "   • ✅ Camera/device information"
echo "   • ✅ Professional HTML reports in Download folder"
echo ""
echo "📁 FOLDERS CREATED:"
echo "   ~/Hakeem-Stego/stego-images/    # Images with hidden data"
echo "   ~/Hakeem-Stego/reports/         # HTML forensic reports"
echo "   ~/Hakeem-Stego/hidden-files/    # Extracted hidden files"
echo ""
echo "👑 DEVELOPER: Hakeem Al-Arab"
echo "🌐 GitHub: hakim738-html"
echo "========================================================"