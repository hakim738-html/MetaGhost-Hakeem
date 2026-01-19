#!/bin/bash
echo "========================================"
echo "     مُثبِّت أداة HAKEEM للطب الشرعي"
echo "========================================"
echo ""
echo "📦 جاري تثبيت المتطلبات..."
pkg update -y
pkg install exiftool imagemagick -y
echo ""
echo "✅ اكتمل التثبيت!"
echo ""
echo "🚀 لتشغيل أداة HAKEEM:"
echo "   chmod +x HAKEEM.sh"
echo "   ./HAKEEM.sh"
echo ""
echo "👨‍💻 المطور: Hakeem"
echo "GitHub: github.com/hakim738-html"
echo "========================================"
