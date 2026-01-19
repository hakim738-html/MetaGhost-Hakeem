#!/bin/bash
# ===================================================
# 🛠️ H A K E E M   F O R E N S I C   P R O   I N S T A L L E R
# ===================================================

echo "========================================"
echo "     H A K E E M   F O R E N S I C"
echo "========================================"
echo ""
echo "[*] Installing requirements..."
pkg update -y
pkg install exiftool python git -y
pip install requests 2>/dev/null
echo ""
echo "[*] Creating directories..."
mkdir -p ~/Hakeem-Forensic/{Reports,Backups,Pages,Logs}
echo ""
echo "[*] Setting up files..."
chmod +x Hakeem-Forensic-Pro.sh
echo ""
echo "[✓] Installation complete!"
echo ""
echo "[*] To run the tool:"
echo "    ./Hakeem-Forensic-Pro.sh"
echo ""
echo "[*] Features:"
echo "    • ✅ Web interface with live logging"
echo "    • ✅ Image metadata analysis"
echo "    • ✅ GPS data extraction"
echo "    • ✅ Password strength testing"
echo "    • ✅ Network tools"
echo ""
echo "👑 Developer: Hakeem Al-Arab"
echo "🌐 GitHub: hakim738-html"
echo "========================================"