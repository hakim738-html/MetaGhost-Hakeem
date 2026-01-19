#!/bin/bash
echo "========================================"
echo "     H A K E E M   F I X E D   S E T U P"
echo "========================================"
echo ""
echo "📦 تثبيت المتطلبات..."
pkg update -y
pkg install exiftool python -y
pip install requests 2>/dev/null
echo ""
echo "📁 إنشاء مجلدات العمل..."
mkdir -p ~/Hakeem-Reports ~/Hakeem-Backups ~/Hakeem-Pages
echo ""
echo "🔧 إعداد الملفات..."
chmod +x Hakeem-Forensic-Pro-Fixed.sh
echo ""
echo "✅ اكتمل التثبيت!"
echo ""
echo "🚀 للتشغيل:"
echo "   ./Hakeem-Forensic-Pro-Fixed.sh"
echo ""
echo "✨ المميزات المصححة:"
echo "   • ✅ إنشاء ملف HTML في /sdcard/Download"
echo "   • ✅ عرض البيانات في الترمكس مباشرة"
echo "   • ✅ صفحات ويب تعليمية مع تسجيل بيانات"
echo "   • ✅ تصميم عربي احترافي"
echo ""
echo "👑 المطور: حكيم العرب"
echo "🌐 GitHub: hakim738-html"
echo "========================================"
