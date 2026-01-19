#!/bin/bash
# ==========================================
# 🔥 HAKEEM Forensic & Pentest Tool v6.0
# 👨‍💻 Developer: Hakeem
# ==========================================

echo ""
echo "========================================"
echo "     HAKEEM Forensic Tool Installer"
echo "========================================"
echo "📦 Installing all dependencies..."
echo "========================================"

# Update system
echo "[1/8] Updating package lists..."
pkg update -y

# Install forensic tools
echo "[2/8] Installing forensic tools..."
pkg install exiftool -y        # Metadata analysis
pkg install imagemagick -y     # Image processing

# Install steganography tools
echo "[3/8] Installing steganography tools..."
pkg install steghide -y        # Hide/extract files
pkg install binwalk -y         # File analysis

# Install network tools
echo "[4/8] Installing network tools..."
pkg install curl -y            # Web requests
pkg install wget -y            # File downloads
pkg install netcat -y          # Networking tool

# Install development tools
echo "[5/8] Installing development tools..."
pkg install python -y          # Python 3
pkg install git -y             # Version control
pkg install nano -y            # Text editor

# Install Python modules
echo "[6/8] Installing Python modules..."
pip install requests           # HTTP requests
pip install flask              # Web framework (for phishing)

# Create directory structure
echo "[7/8] Creating directory structure..."
mkdir -p ~/HAKEEM-Tool/{reports,backups,clean_output,stego_files,extracted_files,phishing_pages,logs}

# Set permissions
echo "[8/8] Setting permissions..."
chmod +x *.sh 2>/dev/null

# Completion message
echo ""
echo "========================================"
echo "     ✅ INSTALLATION COMPLETE!"
echo "========================================"
echo ""
echo "🚀 To start HAKEEM Tool:"
echo "   chmod +x HAKEEM.sh"
echo "   ./HAKEEM.sh"
echo ""
echo "✨ NEW FEATURES IN v6.0:"
echo "   • 📧 Facebook phishing page generator"
echo "   • 🔗 Local phishing server setup"
echo "   • 📊 Credential logging system"
echo "   • 🕵️ Advanced steganography"
echo "   • 💣 Metadata manipulation"
echo ""
echo "⚠️  LEGAL DISCLAIMER:"
echo "   Use only for authorized penetration testing"
echo "   and educational purposes with explicit permission."
echo ""
echo "👨‍💻 Developer: Hakeem"
echo "🌐 GitHub: github.com/hakim738-html"
echo "========================================"
