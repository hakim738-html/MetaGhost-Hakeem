#!/bin/bash
# ===================================================
# 🔥 H A K E E M   F O R E N S I C   P R O   F I X E D
# 👑 DEVELOPED BY: حكيم العرب
# 🎯 VERSION: الإصدار المصحح والمحسن 2024
# ===================================================

# تمكين معالجة الأخطاء
set -e
trap 'echo -e "${RED}❌ خطأ في السطر $LINENO${NC}"; exit 1' ERR

# الألوان
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# مجلدات العمل
BASE_DIR="$HOME/Hakeem-Forensic"
REPORTS_DIR="$BASE_DIR/Reports"
BACKUPS_DIR="$BASE_DIR/Backups"
PAGES_DIR="$BASE_DIR/Pages"
LOGS_DIR="$BASE_DIR/Logs"

# ===================================================
# 🎯 وظيفة البانر
# ===================================================
show_banner() {
    clear
    echo -e "${RED}"
    cat << "EOF"
    ██╗  ██╗ █████╗ ██╗  ██╗███████╗███████╗███╗   ███╗
    ██║  ██║██╔══██╗██║ ██╔╝██╔════╝██╔════╝████╗ ████║
    ███████║███████║█████╔╝ █████╗  █████╗  ██╔████╔██║
    ██╔══██║██╔══██║██╔═██╗ ██╔══╝  ██╔══╝  ██║╚██╔╝██║
    ██║  ██║██║  ██║██║  ██╗███████╗███████╗██║ ╚═╝ ██║
    ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝╚═╝     ╚═╝
EOF
    echo -e "${YELLOW}"
    echo "         أداة الطب الشرعي الرقمي - الإصدار المحسن"
    echo -e "${GREEN}"
    echo "              👑 المطور: حكيم العرب"
    echo "              🌐 GitHub: hakim738-html"
    echo -e "${CYAN}"
    echo "              📊 الإصدار: 3.0.1"
    echo -e "${NC}"
}

# ===================================================
# 🔍 وظيفة التحقق من الأدوات
# ===================================================
check_tools() {
    echo -e "${CYAN}🔍 جاري التحقق من الأدوات المطلوبة...${NC}"
    
    # إنشاء مجلدات العمل
    mkdir -p "$REPORTS_DIR" "$BACKUPS_DIR" "$PAGES_DIR" "$LOGS_DIR"
    
    # قائمة الأدوات المطلوبة
    declare -A tools=(
        ["exiftool"]="تثبيت ExifTool"
        ["python3"]="تثبيت Python3"
    )
    
    for tool in "${!tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            echo -e "${YELLOW}📦 ${tools[$tool]}...${NC}"
            
            if [[ "$(uname -o)" == "Android" ]]; then
                pkg install "$tool" -y || {
                    echo -e "${RED}❌ فشل تثبيت $tool${NC}"
                    return 1
                }
            elif [[ "$(uname -s)" == "Linux" ]]; then
                sudo apt-get install "$tool" -y || sudo yum install "$tool" -y || {
                    echo -e "${RED}❌ فشل تثبيت $tool${NC}"
                    return 1
                }
            fi
        fi
    done
    
    echo -e "${GREEN}✅ جميع الأدوات جاهزة!${NC}"
    return 0
}

# ===================================================
# 📄 وظيفة تحليل الصورة مع إنشاء HTML
# ===================================================
analyze_image() {
    echo -e "${CYAN}🎯 أدخل مسار الصورة:${NC}"
    read -r img_path
    
    # التحقق من وجود الملف
    if [[ ! -f "$img_path" ]]; then
        echo -e "${RED}❌ الملف غير موجود!${NC}"
        echo -e "${YELLOW}💡 جرب أحد المسارات التالية:${NC}"
        echo "   /sdcard/Download/image.jpg"
        echo "   /storage/emulated/0/DCIM/Camera/photo.jpg"
        echo "   $HOME/picture.png"
        return 1
    fi
    
    # معلومات الملف
    filename=$(basename "$img_path")
    timestamp=$(date +"%Y%m%d_%H%M%S")
    html_file="HAKEEM_REPORT_${timestamp}_${filename%.*}.html"
    html_path="$REPORTS_DIR/$html_file"
    
    echo -e "${YELLOW}📊 جاري تحليل: $filename${NC}"
    echo -e "${BLUE}⏳ يرجى الانتظار...${NC}"
    
    # استخراج البيانات الوصفية
    if ! command -v exiftool &> /dev/null; then
        echo -e "${RED}❌ ExifTool غير مثبت!${NC}"
        return 1
    fi
    
    # معلومات أساسية
    file_size=$(du -h "$img_path" 2>/dev/null | cut -f1 || echo "غير معروف")
    file_type=$(file -b "$img_path" 2>/dev/null || echo "غير معروف")
    make_model=$(exiftool -Make -Model "$img_path" 2>/dev/null | awk -F': ' '{print $2}' | tr '\n' ' ' || echo "غير معروف")
    date_time=$(exiftool -DateTimeOriginal -CreateDate "$img_path" 2>/dev/null | head -1 | cut -d':' -f2- | sed 's/^ *//' || echo "غير معروف")
    
    # بيانات GPS
    gps_lat=$(exiftool -n -GPSLatitude "$img_path" 2>/dev/null | awk -F': ' '{print $2}' || echo "")
    gps_lon=$(exiftool -n -GPSLongitude "$img_path" 2>/dev/null | awk -F': ' '{print $2}' || echo "")
    
    # أبعاد الصورة
    dimensions=$(exiftool -ImageWidth -ImageHeight "$img_path" 2>/dev/null | awk -F': ' '{print $2}' | tr '\n' 'x' | sed 's/x$//' || echo "غير معروف")
    
    # ============================================
    # 🔧 إنشاء ملف HTML
    # ============================================
    cat > "$html_path" << HTML_HEADER
<!DOCTYPE html>
<html dir="rtl" lang="ar">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>تقرير حكيم - $filename</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #0f0c29, #302b63, #24243e);
            color: #fff;
            line-height: 1.8;
            padding: 20px;
            min-height: 100vh;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .header {
            background: linear-gradient(90deg, #ff416c, #ff4b2b);
            padding: 30px;
            border-radius: 20px;
            text-align: center;
            margin-bottom: 30px;
            box-shadow: 0 15px 35px rgba(255, 65, 108, 0.3);
            position: relative;
            overflow: hidden;
        }
        
        .header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: linear-gradient(90deg, #00dbde, #fc00ff);
        }
        
        .header h1 {
            font-size: 2.8rem;
            margin-bottom: 15px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        
        .header p {
            font-size: 1.2rem;
            opacity: 0.9;
        }
        
        .section {
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(15px);
            padding: 30px;
            border-radius: 15px;
            margin: 25px 0;
            border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }
        
        .section:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 40px rgba(0, 0, 0, 0.2);
        }
        
        .section-title {
            color: #00dbde;
            font-size: 1.8rem;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 3px solid #00dbde;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .section-title i {
            font-size: 1.5rem;
        }
        
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        
        .card {
            background: rgba(255, 255, 255, 0.05);
            padding: 25px;
            border-radius: 12px;
            border-left: 6px solid #4a00e0;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(45deg, transparent 30%, rgba(255,255,255,0.03) 50%, transparent 70%);
            transform: translateX(-100%);
            transition: transform 0.6s;
        }
        
        .card:hover::before {
            transform: translateX(100%);
        }
        
        .card:hover {
            background: rgba(255, 255, 255, 0.08);
            transform: translateY(-3px);
        }
        
        .card.danger {
            border-left-color: #ff416c;
            background: rgba(255, 65, 108, 0.1);
        }
        
        .card.warning {
            border-left-color: #ff9a00;
            background: rgba(255, 154, 0, 0.1);
        }
        
        .card.safe {
            border-left-color: #00dbde;
            background: rgba(0, 219, 222, 0.1);
        }
        
        .card.info {
            border-left-color: #8a2be2;
            background: rgba(138, 43, 226, 0.1);
        }
        
        .label {
            font-weight: bold;
            color: #8e2de2;
            display: block;
            margin-bottom: 10px;
            font-size: 1.1rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .value {
            color: #e0e0e0;
            font-size: 1.2rem;
            word-break: break-word;
        }
        
        .map-links {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            margin-top: 20px;
        }
        
        .map-btn {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            background: linear-gradient(45deg, #00dbde, #0093e9);
            color: white;
            padding: 15px 25px;
            border-radius: 10px;
            text-decoration: none;
            font-weight: bold;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
        }
        
        .map-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(0, 219, 222, 0.3);
        }
        
        .map-btn.danger {
            background: linear-gradient(45deg, #ff416c, #ff4b2b);
        }
        
        .map-btn.danger:hover {
            box-shadow: 0 10px 20px rgba(255, 65, 108, 0.3);
        }
        
        .table-container {
            overflow-x: auto;
            margin-top: 20px;
            border-radius: 10px;
            background: rgba(255, 255, 255, 0.05);
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 600px;
        }
        
        th {
            background: linear-gradient(45deg, #8a2be2, #4a00e0);
            color: white;
            padding: 18px;
            text-align: right;
            font-weight: bold;
        }
        
        td {
            padding: 16px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            text-align: right;
        }
        
        tr:hover {
            background: rgba(255, 255, 255, 0.05);
        }
        
        .footer {
            text-align: center;
            margin-top: 50px;
            padding: 30px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            color: #aaa;
            background: rgba(0, 0, 0, 0.2);
            border-radius: 15px;
        }
        
        .developer {
            color: #ff9a00;
            font-size: 1.4rem;
            margin: 15px 0;
            font-weight: bold;
        }
        
        .download-btn {
            display: inline-block;
            background: linear-gradient(45deg, #00b09b, #96c93d);
            color: white;
            padding: 15px 30px;
            border-radius: 10px;
            text-decoration: none;
            margin: 15px;
            font-weight: bold;
            transition: all 0.3s;
        }
        
        .download-btn:hover {
            transform: scale(1.05);
            box-shadow: 0 10px 20px rgba(0, 176, 155, 0.3);
        }
        
        @media (max-width: 768px) {
            .grid {
                grid-template-columns: 1fr;
            }
            
            .header h1 {
                font-size: 2rem;
            }
            
            .section {
                padding: 20px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-microscope"></i> تقرير الطب الشرعي الرقمي</h1>
            <p>تحليل متقدم للبيانات الوصفية (EXIF)</p>
        </div>
HTML_HEADER

    # قسم معلومات الملف
    cat >> "$html_path" << FILE_SECTION
        <div class="section">
            <h2 class="section-title"><i class="fas fa-file-alt"></i> معلومات الملف</h2>
            <div class="grid">
                <div class="card info">
                    <span class="label"><i class="fas fa-file"></i> اسم الملف:</span>
                    <span class="value">$filename</span>
                </div>
                <div class="card info">
                    <span class="label"><i class="fas fa-weight-hanging"></i> الحجم:</span>
                    <span class="value">$file_size</span>
                </div>
                <div class="card info">
                    <span class="label"><i class="fas fa-expand-alt"></i> الأبعاد:</span>
                    <span class="value">$dimensions</span>
                </div>
                <div class="card info">
                    <span class="label"><i class="fas fa-file-image"></i> نوع الملف:</span>
                    <span class="value">$file_type</span>
                </div>
            </div>
        </div>
FILE_SECTION

    # قسم معلومات الكاميرا
    cat >> "$html_path" << CAMERA_SECTION
        <div class="section">
            <h2 class="section-title"><i class="fas fa-camera"></i> معلومات الكاميرا</h2>
            <div class="grid">
                <div class="card warning">
                    <span class="label"><i class="fas fa-camera-retro"></i> الشركة المصنعة:</span>
                    <span class="value">$(echo "$make_model" | cut -d' ' -f1 2>/dev/null || echo "غير معروف")</span>
                </div>
                <div class="card warning">
                    <span class="label"><i class="fas fa-mobile-alt"></i> موديل الجهاز:</span>
                    <span class="value">$(echo "$make_model" | cut -d' ' -f2- 2>/dev/null || echo "غير معروف")</span>
                </div>
                <div class="card warning">
                    <span class="label"><i class="fas fa-calendar-alt"></i> تاريخ الالتقاط:</span>
                    <span class="value">$date_time</span>
                </div>
            </div>
        </div>
CAMERA_SECTION

    # قسم بيانات GPS
    cat >> "$html_path" << GPS_SECTION_HEADER
        <div class="section">
            <h2 class="section-title"><i class="fas fa-map-marker-alt"></i> الموقع الجغرافي</h2>
GPS_SECTION_HEADER

    if [[ -n "$gps_lat" && -n "$gps_lon" ]]; then
        cat >> "$html_path" << GPS_PRESENT
            <div class="card danger">
                <span class="label"><i class="fas fa-exclamation-triangle"></i> تنبيه أمني!</span>
                <span class="value">هذه الصورة تحتوي على إحداثيات GPS يمكنها كشف الموقع الدقيق</span>
            </div>
            
            <div class="grid" style="margin-top: 20px;">
                <div class="card danger">
                    <span class="label"><i class="fas fa-globe-americas"></i> خط العرض:</span>
                    <span class="value">$gps_lat</span>
                </div>
                <div class="card danger">
                    <span class="label"><i class="fas fa-globe-americas"></i> خط الطول:</span>
                    <span class="value">$gps_lon</span>
                </div>
            </div>
            
            <div class="map-links">
                <a href="https://maps.google.com/?q=$gps_lat,$gps_lon" class="map-btn danger" target="_blank">
                    <i class="fab fa-google"></i> خرائط جوجل
                </a>
                <a href="https://www.openstreetmap.org/?mlat=$gps_lat&mlon=$gps_lon" class="map-btn" target="_blank">
                    <i class="fas fa-map"></i> OpenStreetMap
                </a>
                <button class="map-btn" onclick="copyCoordinates('$gps_lat,$gps_lon')">
                    <i class="fas fa-copy"></i> نسخ الإحداثيات
                </button>
            </div>
GPS_PRESENT
    else
        cat >> "$html_path" << NO_GPS
            <div class="card safe">
                <span class="label"><i class="fas fa-shield-alt"></i> حالة آمنة</span>
                <span class="value">لا توجد بيانات موقع جغرافي في هذه الصورة</span>
            </div>
NO_GPS
    fi

    cat >> "$html_path" << GPS_SECTION_FOOTER
        </div>
GPS_SECTION_FOOTER

    # قسم البيانات الوصفية الكاملة
    cat >> "$html_path" << EXIF_HEADER
        <div class="section">
            <h2 class="section-title"><i class="fas fa-database"></i> البيانات الوصفية الكاملة</h2>
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>العنوان</th>
                            <th>القيمة</th>
                            <th>الحالة</th>
                        </tr>
                    </thead>
                    <tbody>
EXIF_HEADER

    # استخراج وعرض جميع بيانات EXIF
    exiftool "$img_path" 2>/dev/null | while IFS= read -r line; do
        [[ -z "$line" ]] && continue
        
        key=$(echo "$line" | cut -d: -f1 | xargs)
        value=$(echo "$line" | cut -d: -f2- | xargs)
        
        # تحديد حالة البيانات
        if echo "$key" | grep -qi -E "(GPS|Location|Latitude|Longitude|Altitude)"; then
            status="<span style='color:#ff416c'><i class='fas fa-exclamation-triangle'></i> خطير</span>"
            class="danger"
        elif echo "$key" | grep -qi -E "(Make|Model|Serial|Device|Camera|Lens)"; then
            status="<span style='color:#ff9a00'><i class='fas fa-exclamation-circle'></i> تحذير</span>"
            class="warning"
        elif echo "$key" | grep -qi -E "(DateTime|CreateDate|ModifyDate)"; then
            status="<span style='color:#00dbde'><i class='fas fa-clock'></i> زمني</span>"
            class="safe"
        else
            status="<span style='color:#8a2be2'><i class='fas fa-info-circle'></i> معلومات</span>"
            class="info"
        fi
        
        # تقليم القيم الطويلة
        if [[ ${#value} -gt 100 ]]; then
            value="${value:0:100}..."
        fi
        
        cat >> "$html_path" << EXIF_ROW
                        <tr class="$class">
                            <td><strong>$key</strong></td>
                            <td>$value</td>
                            <td>$status</td>
                        </tr>
EXIF_ROW
    done

    cat >> "$html_path" << EXIF_FOOTER
                    </tbody>
                </table>
            </div>
        </div>
EXIF_FOOTER

    # التذييل
    cat >> "$html_path" << FOOTER
        <div class="footer">
            <h3><i class="fas fa-file-download"></i> تحميل التقرير</h3>
            <p>يمكنك حفظ هذا التقرير للرجوع إليه لاحقاً</p>
            
            <a href="#" class="download-btn" onclick="window.print()">
                <i class="fas fa-print"></i> طباعة التقرير
            </a>
            
            <div class="developer">
                <i class="fas fa-crown"></i> تم إنشاء هذا التقرير بواسطة <strong>حكيم العرب</strong>
            </div>
            
            <p>
                <i class="fas fa-tools"></i> الأداة: Hakeem Forensic Pro v3.0.1<br>
                <i class="fab fa-github"></i> GitHub: <a href="https://github.com/hakim738-html" style="color:#00dbde;">hakim738-html</a><br>
                <i class="fas fa-calendar"></i> تاريخ الإنشاء: $(date '+%Y-%m-%d %H:%M:%S')
            </p>
            
            <p style="margin-top: 20px; font-size: 0.9em; color: #888;">
                <i class="fas fa-exclamation-circle"></i> تنبيه: هذا التقرير للأغراض التعليمية والطب الشرعي القانوني فقط
            </p>
        </div>
    </div>

    <script>
        function copyCoordinates(coords) {
            navigator.clipboard.writeText(coords).then(() => {
                alert('تم نسخ الإحداثيات: ' + coords);
            });
        }
        
        function downloadReport() {
            const element = document.createElement('a');
            const content = document.documentElement.outerHTML;
            const blob = new Blob([content], { type: 'text/html' });
            element.href = URL.createObjectURL(blob);
            element.download = '$html_file';
            document.body.appendChild(element);
            element.click();
            document.body.removeChild(element);
        }
        
        // إضافة تأثيرات للجداول
        document.addEventListener('DOMContentLoaded', function() {
            const rows = document.querySelectorAll('tbody tr');
            rows.forEach((row, index) => {
                row.style.animationDelay = (index * 0.05) + 's';
                row.classList.add('fade-in');
            });
        });
    </script>
    
    <style>
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .fade-in {
            animation: fadeIn 0.5s ease forwards;
            opacity: 0;
        }
    </style>
</body>
</html>
FOOTER

    # ============================================
    # ✅ عرض النتائج
    # ============================================
    echo -e "${GREEN}✅ تم إنشاء التقرير بنجاح!${NC}"
    echo ""
    echo -e "${CYAN}📄 معلومات التقرير:${NC}"
    echo -e "   📁 الملف: $html_path"
    echo -e "   📏 الحجم: $(du -h "$html_path" 2>/dev/null | cut -f1 || echo 'غير معروف')"
    echo -e "   📅 الوقت: $(date '+%H:%M:%S')"
    echo ""
    
    # عرض معلومات سريعة
    echo -e "${CYAN}📊 ملخص التحليل:${NC}"
    echo -e "   📷 الكاميرا: ${make_model:-'غير معروف'}"
    echo -e "   📍 GPS: $(if [[ -n "$gps_lat" ]]; then echo "✅ موجود ($gps_lat, $gps_lon)"; else echo "❌ غير موجود"; fi)"
    echo -e "   📏 الأبعاد: ${dimensions:-'غير معروف'}"
    echo -e "   📅 التاريخ: ${date_time:-'غير معروف'}"
    
    # نسخ لملف التنزيلات إذا كان موجوداً
    if [[ -d "/sdcard/Download" ]]; then
        cp "$html_path" "/sdcard/Download/" 2>/dev/null && \
        echo -e "${GREEN}📱 تم نسخ التقرير إلى: /sdcard/Download/${NC}"
    elif [[ -d "$HOME/Downloads" ]]; then
        cp "$html_path" "$HOME/Downloads/" 2>/dev/null && \
        echo -e "${GREEN}📁 تم نسخ التقرير إلى: ~/Downloads/${NC}"
    fi
    
    echo ""
    echo -e "${YELLOW}🎯 أوامر العرض السريع:${NC}"
    echo -e "   🔍 عرض التقرير: cat $html_path | head -20"
    echo -e "   🌐 فتح في المتصفح: (انسخ المسار وافتحه في متصفح)"
    
    # تسجيل الإجراء
    log_action "تحليل صورة" "تم تحليل $filename وإنشاء $html_file"
    
    return 0
}

# ============================================
# 🎮 وظيفة إنشاء صفحات تعليمية
# ============================================
create_learning_pages() {
    local choice=$1
    
    case $choice in
        1)  # صفحة فيسبوك
            create_facebook_page
            ;;
        2)  # صفحة جوجل
            create_google_page
            ;;
        3)  # صفحة ألعاب
            create_gaming_page
            ;;
        *)
            echo -e "${RED}❌ خيار غير صحيح${NC}"
            return 1
            ;;
    esac
    
    return 0
}

# ============================================
# 📘 صفحة فيسبوك تعليمية
# ============================================
create_facebook_page() {
    local page_name="Facebook_Security_Page_$(date +%s).html"
    local page_path="$PAGES_DIR/$page_name"
    
    echo -e "${CYAN}🎯 جاري إنشاء صفحة فيسبوك تعليمية...${NC}"
    
    cat > "$page_path" << 'FACEBOOK_PAGE'
<!DOCTYPE html>
<html dir="rtl" lang="ar">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>صفحة تعليمية - التوعية الأمنية</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: Arial, sans-serif;
            background: #f0f2f5;
            color: #1c1e21;
        }
        .container {
            max-width: 400px;
            margin: 50px auto;
            padding: 20px;
        }
        .header {
            text-align: center;
            margin-bottom: 30px;
        }
        .logo {
            color: #1877f2;
            font-size: 48px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        .form-box {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,.1);
        }
        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 14px;
            margin: 10px 0;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 16px;
        }
        .login-btn {
            width: 100%;
            padding: 14px;
            background: #1877f2;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 18px;
            cursor: pointer;
            margin: 10px 0;
        }
        .warning-box {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            color: #856404;
            padding: 15px;
            border-radius: 6px;
            margin-top: 20px;
            text-align: center;
        }
        .terminal {
            background: #1e1e1e;
            color: #0f0;
            padding: 15px;
            border-radius: 6px;
            margin-top: 20px;
            font-family: monospace;
            display: none;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="logo">facebook</div>
            <p>صفحة تعليمية للتوعية الأمنية</p>
        </div>
        
        <div class="form-box">
            <form id="demoForm">
                <input type="text" placeholder="اسم المستخدم (تجريبي)" id="username">
                <input type="password" placeholder="كلمة المرور (تجريبية)" id="password">
                <button type="submit" class="login-btn">تسجيل دخول (تجريبي)</button>
            </form>
        </div>
        
        <div class="warning-box">
            ⚠️ <strong>صفحة تعليمية</strong><br>
            هذه محاكاة للتوعية بمخاطر التصيد الإلكتروني
        </div>
        
        <div id="terminal" class="terminal">
            <div id="output"></div>
        </div>
    </div>

    <script>
        document.getElementById('demoForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const username = document.getElementById('username').value;
            const password = document.getElementById('password').value;
            const terminal = document.getElementById('terminal');
            const output = document.getElementById('output');
            
            // عرض البيانات في الـ Terminal
            terminal.style.display = 'block';
            output.innerHTML = `
[🎓] هذا عرض تعليمي
[👤] المستخدم: ${username || 'لم يتم إدخال'}
[🔑] كلمة المرور: ${'*'.repeat(password.length)}
[🕐] الوقت: ${new Date().toLocaleTimeString()}
====================================
💡 تم تسجيل البيانات محلياً فقط للأغراض التعليمية
            `;
            
            // إعادة تعيين الحقول بعد 3 ثوان
            setTimeout(() => {
                document.getElementById('username').value = '';
                document.getElementById('password').value = '';
                terminal.style.display = 'none';
                alert('✅ تم حفظ البيانات التعليمية محلياً');
            }, 3000);
        });
    </script>
</body>
</html>
FACEBOOK_PAGE

    echo -e "${GREEN}✅ تم إنشاء الصفحة: $page_name${NC}"
    
    # نسخ للتنزيلات إذا أمكن
    if [[ -d "/sdcard/Download" ]]; then
        cp "$page_path" "/sdcard/Download/" 2>/dev/null
        echo -e "${GREEN}📱 تم النسخ إلى: /sdcard/Download/${NC}"
    fi
    
    log_action "إنشاء صفحة" "صفحة فيسبوك تعليمية: $page_name"
    
    return 0
}

# ============================================
# 📊 وظيفة تسجيل الإجراءات
# ============================================
log_action() {
    local action=$1
    local details=$2
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local log_file="$LOGS_DIR/actions.log"
    
    echo "[$timestamp] $action: $details" >> "$log_file"
    
    # عرض في الترمكس
    echo -e "${PURPLE}════════════════════════════════════════${NC}"
    echo -e "${CYAN}📝 [سجل الإجراءات] ${WHITE}$timestamp${NC}"
    echo -e "${GREEN}📌 الإجراء:${NC} $action"
    echo -e "${YELLOW}📋 التفاصيل:${NC} $details"
    echo -e "${PURPLE}════════════════════════════════════════${NC}"
}

# ============================================
# 🧹 وظيفة تنظيف البيانات الوصفية
# ============================================
clean_metadata() {
    echo -e "${CYAN}🎯 أدخل مسار الملف المراد تنظيفه:${NC}"
    read -r file_path
    
    if [[ ! -f "$file_path" ]]; then
        echo -e "${RED}❌ الملف غير موجود!${NC}"
        return 1
    fi
    
    # إنشاء نسخة احتياطية
    local backup_name="BACKUP_$(date +%s)_$(basename "$file_path")"
    local backup_path="$BACKUPS_DIR/$backup_name"
    
    echo -e "${YELLOW}📦 إنشاء نسخة احتياطية...${NC}"
    cp "$file_path" "$backup_path"
    
    echo -e "${BLUE}🧹 جاري تنظيف البيانات الوصفية...${NC}"
    
    if command -v exiftool &> /dev/null; then
        exiftool -all= "$file_path" 2>/dev/null
        
        if [[ $? -eq 0 ]]; then
            echo -e "${GREEN}✅ تم تنظيف البيانات الوصفية بنجاح!${NC}"
            echo -e "${CYAN}📁 النسخة الاحتياطية:${NC} $backup_path"
            
            # التحقق من النتيجة
            local remaining_metadata=$(exiftool "$file_path" 2>/dev/null | wc -l)
            if [[ $remaining_metadata -le 5 ]]; then
                echo -e "${GREEN}✅ تمت إزالة جميع البيانات الوصفية تقريباً${NC}"
            else
                echo -e "${YELLOW}⚠️  لا يزال هناك بعض البيانات الوصفية${NC}"
            fi
            
            log_action "تنظيف metadata" "تم تنظيف $file_path (النسخة: $backup_name)"
        else
            echo -e "${RED}❌ فشل عملية التنظيف${NC}"
            return 1
        fi
    else
        echo -e "${RED}❌ ExifTool غير مثبت!${NC}"
        return 1
    fi
    
    return 0
}

# ============================================
# 📋 وظيفة عرض التقارير المحفوظة
# ============================================
show_reports() {
    echo -e "${CYAN}📁 التقارير المحفوظة:${NC}"
    
    if [[ ! -d "$REPORTS_DIR" ]] || [[ -z "$(ls -A "$REPORTS_DIR" 2>/dev/null)" ]]; then
        echo -e "${YELLOW}⚠️  لا توجد تقارير محفوظة${NC}"
        return 1
    fi
    
    local count=1
    echo -e "${WHITE}"
    echo "┌────┬────────────────────────────┬────────────────────┐"
    echo "│ رقم │ اسم الملف                  │ تاريخ الإنشاء     │"
    echo "├────┼────────────────────────────┼────────────────────┤"
    
    for report in "$REPORTS_DIR"/*.html; do
        if [[ -f "$report" ]]; then
            local filename=$(basename "$report")
            local filedate=$(stat -c %y "$report" 2>/dev/null | cut -d' ' -f1) || \
                           $(date -r "$report" '+%Y-%m-%d' 2>/dev/null) || \
                           echo "غير معروف"
            
            # تقصير اسم الملف إذا كان طويلاً
            if [[ ${#filename} -gt 25 ]]; then
                filename="${filename:0:22}..."
            fi
            
            printf "│ %-2d │ %-26s │ %-18s │\n" "$count" "$filename" "$filedate"
            ((count++))
        fi
    done
    
    echo "└────┴────────────────────────────┴────────────────────┘"
    echo -e "${NC}"
    
    echo -e "${YELLOW}🎯 اختيارات:${NC}"
    echo "   • أدخل رقم التقرير لعرضه"
    echo "   • اكتب 'all' لعرض جميع التقارير"
    echo "   • اكتب 'clean' لمسح التقارير القديمة"
    echo "   • اكتب 'back' للعودة"
    
    read -r choice
    
    case $choice in
        [0-9]*)
            if [[ $choice -lt $count ]] && [[ $choice -gt 0 ]]; then
                local files=("$REPORTS_DIR"/*.html)
                local selected="${files[$((choice-1))]}"
                if [[ -f "$selected" ]]; then
                    echo -e "${GREEN}📄 عرض التقرير: $(basename "$selected")${NC}"
                    # محاولة فتح التقرير إذا أمكن
                    if command -v w3m &> /dev/null; then
                        w3m -dump "$selected" | head -50
                    else
                        head -30 "$selected"
                    fi
                fi
            fi
            ;;
        all)
            for report in "$REPORTS_DIR"/*.html; do
                echo -e "${CYAN}📄 $(basename "$report")${NC}"
            done
            ;;
        clean)
            echo -e "${YELLOW}🧹 حذف التقارير الأقدم من 7 أيام...${NC}"
            find "$REPORTS_DIR" -name "*.html" -mtime +7 -delete 2>/dev/null
            echo -e "${GREEN}✅ تم التنظيف${NC}"
            ;;
    esac
    
    return 0
}

# ============================================
# 🚀 الوظائف الإضافية الجديدة
# ============================================

# 📡 تحليل شبكة محلية
analyze_network() {
    echo -e "${CYAN}📡 جاري تحليل الشبكة المحلية...${NC}"
    
    if command -v ifconfig &> /dev/null || command -v ip &> /dev/null; then
        echo -e "${GREEN}🌐 معلومات الشبكة:${NC}"
        
        if command -v ip &> /dev/null; then
            ip addr show | grep -E "inet |ether " | while read line; do
                echo "   $line"
            done
        elif command -v ifconfig &> /dev/null; then
            ifconfig | grep -E "inet |ether " | while read line; do
                echo "   $line"
            done
        fi
        
        log_action "تحليل شبكة" "فحص إعدادات الشبكة المحلية"
    else
        echo -e "${RED}❌ أدوات الشبكة غير متوفرة${NC}"
    fi
}

# 🔐 اختبار قوة كلمة المرور
test_password_strength() {
    echo -e "${CYAN}🔐 اختبار قوة كلمة المرور${NC}"
    echo -e "${YELLOW}أدخل كلمة المرور (لن تظهر على الشاشة):${NC}"
    
    read -s password
    echo ""
    
    local score=0
    local length=${#password}
    
    # قواعد القوة
    [[ $length -ge 8 ]] && ((score++))
    [[ $length -ge 12 ]] && ((score++))
    [[ "$password" =~ [A-Z] ]] && ((score++))
    [[ "$password" =~ [a-z] ]] && ((score++))
    [[ "$password" =~ [0-9] ]] && ((score++))
    [[ "$password" =~ [[:punct:]] ]] && ((score++))
    
    # تقييم القوة
    case $score in
        0|1|2)
            echo -e "${RED}❌ ضعيفة جداً${NC}"
            ;;
        3|4)
            echo -e "${YELLOW}⚠️  متوسطة${NC}"
            ;;
        5)
            echo -e "${GREEN}✅ جيدة${NC}"
            ;;
        6)
            echo -e "${GREEN}🔒 قوية جداً${NC}"
            ;;
    esac
    
    echo -e "${CYAN}📊 النقاط: $score/6${NC}"
    log_action "اختبار كلمة مرور" "تم اختبار قوة كلمة مرور (النقاط: $score/6)"
}

# 📁 إدارة الملفات المتقدمة
file_manager() {
    echo -e "${CYAN}📁 مدير الملفات${NC}"
    
    while true; do
        echo -e "${WHITE}"
        echo "   [1] عرض الملفات في المجلد الحالي"
        echo "   [2] البحث عن ملفات"
        echo "   [3] تحليل حجم الملفات"
        echo "   [4] العودة"
        echo -e "${NC}"
        
        read -r choice
        
        case $choice in
            1)
                echo -e "${GREEN}📂 محتويات المجلد:${NC}"
                ls -la --color=auto || ls -la
                ;;
            2)
                echo -e "${YELLOW}🔍 أدخل اسم الملف للبحث:${NC}"
                read -r search_term
                find . -name "*$search_term*" 2>/dev/null | head -20
                ;;
            3)
                echo -e "${BLUE}📊 تحليل حجم الملفات:${NC}"
                du -sh ./* 2>/dev/null | sort -hr | head -10
                ;;
            4)
                break
                ;;
            *)
                echo -e "${RED}❌ خيار غير صحيح${NC}"
                ;;
        esac
    done
}

# ============================================
# 📋 القائمة الرئيسية
# ============================================
main_menu() {
    # التحقق من الأدوات عند البدء
    if ! check_tools; then
        echo -e "${RED}❌ فشل في تهيئة الأدوات المطلوبة${NC}"
        echo -e "${YELLOW}💡 حاول تشغيل: pkg install exiftool python3${NC}"
        exit 1
    fi
    
    while true; do
        show_banner
        
        echo -e "${CYAN}════════════════════════════════════════${NC}"
        echo -e "${GREEN}           🎯 القائمة الرئيسية           ${NC}"
        echo -e "${CYAN}════════════════════════════════════════${NC}"
        echo ""
        echo -e "${WHITE}【1】🔍 تحليل صورة وإنشاء تقرير HTML"
        echo -e "【2】📍 استخراج بيانات GPS من الصور"
        echo -e "【3】🧹 تنظيف البيانات الوصفية من الملفات"
        echo -e "【4】📡 تحليل الشبكة المحلية"
        echo -e "【5】🔐 اختبار قوة كلمة المرور"
        echo -e "【6】📁 مدير الملفات المتقدم"
        echo -e "${BLUE}【7】📘 صفحات تعليمية للتوعية الأمنية"
        echo -e "【8】📊 عرض التقارير المحفوظة"
        echo -e "【9】⚙️  إعدادات وأدوات النظام"
        echo -e "${RED}【0】🚪 خروج من الأداة"
        echo -e "${NC}"
        echo -e "${CYAN}════════════════════════════════════════${NC}"
        
        echo -e "${YELLOW}"
        read -p "   اختر رقم الخيار: " choice
        echo -e "${NC}"
        
        case $choice in
            1)
                analyze_image
                ;;
            2)
                echo -e "${CYAN}🎯 أدخل مسار الصورة:${NC}"
                read -r img_path
                if [[ -f "$img_path" ]]; then
                    exiftool -GPS* "$img_path" 2>/dev/null || \
                    echo -e "${RED}❌ لا توجد بيانات GPS${NC}"
                else
                    echo -e "${RED}❌ الملف غير موجود${NC}"
                fi
                ;;
            3)
                clean_metadata
                ;;
            4)
                analyze_network
                ;;
            5)
                test_password_strength
                ;;
            6)
                file_manager
                ;;
            7)
                echo -e "${CYAN}🎮 اختر نوع الصفحة:${NC}"
                echo "   [1] صفحة فيسبوك تعليمية"
                echo "   [2] صفحة جوجل تعليمية"
                echo "   [3] صفحة ألعاب تعليمية"
                read -r page_choice
                create_learning_pages "$page_choice"
                ;;
            8)
                show_reports
                ;;
            9)
                echo -e "${CYAN}⚙️  إعدادات النظام:${NC}"
                echo -e "   📊 مساحة التخزين: $(df -h . | tail -1 | awk '{print $4}')"
                echo -e "   💾 الذاكرة: $(free -m | awk 'NR==2{printf "%sMB/%sMB", $3,$2}')"
                echo -e "   🖥️  المعالج: $(grep -c ^processor /proc/cpuinfo 2>/dev/null || echo '?') نواة"
                ;;
            0)
                echo -e "${GREEN}👋 مع السلامة - حكيم العرب${NC}"
                echo -e "${YELLOW}🌐 تابعني على GitHub: hakim738-html${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}❌ خيار غير صحيح!${NC}"
                ;;
        esac
        
        echo ""
        echo -e "${YELLOW}⏸️  اضغط Enter للمتابعة...${NC}"
        read -r
    done
}

# ============================================
# 🚀 بدء التشغيل
# ============================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    clear
    echo -e "${GREEN}🚀 بدء تشغيل Hakeem Forensic Pro...${NC}"
    sleep 1
    main_menu
fi