#!/bin/bash
# ===============================================
# 🔥 HAKEEM Forensic Tool v4.0
# 👨‍💻 Developed by: Hakeem
# 🎯 Advanced Metadata Analysis & Privacy Tool
# ===============================================

# ألوان للواجهة
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# عرض البانر
show_banner() {
    clear
    echo -e "${PURPLE}"
    echo "  ██╗  ██╗ █████╗ ██╗  ██╗███████╗███████╗███╗   ███╗"
    echo "  ██║  ██║██╔══██╗██║ ██╔╝██╔════╝██╔════╝████╗ ████║"
    echo "  ███████║███████║█████╔╝ █████╗  █████╗  ██╔████╔██║"
    echo "  ██╔══██║██╔══██║██╔═██╗ ██╔══╝  ██╔══╝  ██║╚██╔╝██║"
    echo "  ██║  ██║██║  ██║██║  ██╗███████╗███████╗██║ ╚═╝ ██║"
    echo "  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝╚═╝     ╚═╝"
    echo -e "${CYAN}         Forensic Metadata Analyzer${NC}"
    echo -e "${YELLOW}══════════════════════════════════════════════${NC}"
    echo -e "${GREEN}👨‍💻 Developer: Hakeem${NC}"
    echo -e "${BLUE}⚡ Version: 4.0 Professional${NC}"
    echo -e "${YELLOW}══════════════════════════════════════════════${NC}"
}

# التحقق من الأدوات المطلوبة
check_tools() {
    echo -e "${CYAN}🔍 جاري التحقق من الأدوات...${NC}"
    
    if ! command -v exiftool &> /dev/null; then
        echo -e "${YELLOW}📦 جاري تثبيت ExifTool...${NC}"
        pkg install exiftool -y
    fi
    
    mkdir -p reports backups clean_output
    echo -e "${GREEN}✅ جميع الأدوات جاهزة!${NC}"
}

# التحليل العميق
deep_scan() {
    echo -e "${CYAN}🎯 أدخل مسار الصورة:${NC}"
    read image_path
    
    if [ ! -f "$image_path" ]; then
        echo -e "${RED}❌ الملف غير موجود!${NC}"
        return
    fi
    
    filename=$(basename "$image_path")
    report="reports/HAKEEM_$(date +%Y%m%d_%H%M%S)_${filename%.*}.html"
    
    echo -e "${YELLOW}📊 جاري تحليل $filename...${NC}"
    
    # إنشاء تقرير HTML
    echo "<html><head><title>تقرير HAKEEM - $filename</title></head><body>" > "$report"
    echo "<h1>🔍 تقرير HAKEEM للبيانات الوصفية</h1>" >> "$report"
    echo "<p><strong>الملف:</strong> $filename</p>" >> "$report"
    echo "<p><strong>التاريخ:</strong> $(date)</p>" >> "$report"
    exiftool "$image_path" | sed 's/</\&lt;/g; s/>/\&gt;/g' >> "$report"
    echo "</body></html>" >> "$report"
    
    echo -e "${GREEN}✅ تم إنشاء التقرير: $report${NC}"
    
    # نسخ إلى مجلد التنزيلات
    if [ -d "/sdcard/Download" ]; then
        cp "$report" "/sdcard/Download/"
        echo -e "${CYAN}📱 تم النسخ إلى الهاتف: /sdcard/Download/$(basename "$report")${NC}"
    fi
}

# اكتشاف GPS
gps_scan() {
    echo -e "${CYAN}🎯 أدخل مسار الصورة:${NC}"
    read image_path
    
    lat=$(exiftool -n -GPSLatitude "$image_path" 2>/dev/null | cut -d: -f2 | xargs)
    lon=$(exiftool -n -GPSLongitude "$image_path" 2>/dev/null | cut -d: -f2 | xargs)
    
    if [ -n "$lat" ] && [ -n "$lon" ]; then
        echo -e "${GREEN}📍 تم العثور على إحداثيات GPS!${NC}"
        echo -e "${CYAN}خط العرض: $lat${NC}"
        echo -e "${CYAN}خط الطول: $lon${NC}"
        echo ""
        echo -e "${YELLOW}🗺️ روابط الخرائط:${NC}"
        echo "خرائط جوجل: https://maps.google.com/?q=$lat,$lon"
        echo "OpenStreetMap: https://www.openstreetmap.org/?mlat=$lat&mlon=$lon"
    else
        echo -e "${RED}❌ لا توجد بيانات GPS في هذه الصورة${NC}"
    fi
}

# إزالة البيانات الوصفية
clean_file() {
    echo -e "${CYAN}🎯 أدخل مسار الصورة:${NC}"
    read image_path
    
    backup="backups/HAKEEM_backup_$(date +%H%M%S)_$(basename "$image_path")"
    cp "$image_path" "$backup"
    
    echo -e "${YELLOW}🛡️ جاري تنظيف البيانات الوصفية...${NC}"
    exiftool -all= "$image_path"
    
    clean="clean_output/HAKEEM_cleaned_$(basename "$image_path")"
    mv "$image_path" "$clean"
    
    echo -e "${GREEN}✅ تمت إزالة البيانات الوصفية!${NC}"
    echo -e "${BLUE}💾 النسخة الاحتياطية: $backup${NC}"
    echo -e "${GREEN}🧼 الملف النظيف: $clean${NC}"
}

# القائمة الرئيسية
main_menu() {
    show_banner
    check_tools
    
    echo -e "${CYAN}【1】📊 تحليل عميق + تقرير HTML${NC}"
    echo -e "${GREEN}【2】📍 اكتشاف GPS وخرائط${NC}"
    echo -e "${YELLOW}【3】🛡️ إزالة البيانات الوصفية${NC}"
    echo -e "${BLUE}【4】📁 عرض التقارير${NC}"
    echo -e "${PURPLE}【5】ℹ️ عن أداة HAKEEM${NC}"
    echo -e "${RED}【0】🚪 خروج${NC}"
    echo ""
    echo -e "${YELLOW}══════════════════════════════════════════════${NC}"
    
    read -p "➤ اختر خياراً [0-5]: " choice
    
    case $choice in
        1) deep_scan ;;
        2) gps_scan ;;
        3) clean_file ;;
        4) ls -la reports/ 2>/dev/null || echo "لا توجد تقارير بعد" ;;
        5) 
            echo -e "${CYAN}🔥 أداة HAKEEM للطب الشرعي v4.0${NC}"
            echo -e "${GREEN}المطور: Hakeem${NC}"
            echo "أداة متقدمة لتحليل البيانات الوصفية وحماية الخصوصية"
            echo "GitHub: github.com/hakim738-html"
            ;;
        0)
            echo -e "${GREEN}👋 شكراً لاستخدامك أداة HAKEEM!${NC}"
            exit 0
            ;;
        *) echo -e "${RED}❌ خيار غير صحيح${NC}" ;;
    esac
    
    echo ""
    read -p "➤ اضغط Enter للمتابعة..."
    main_menu
}

# بدء التشغيل
main_menu
