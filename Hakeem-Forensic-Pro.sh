#!/bin/bash
# ===================================================
# 🔥 H A K E E M   F O R E N S I C   P R O   F I X E D
# 👑 DEVELOPED BY: حكيم العرب
# 🎯 VERSION: الإصدار المصحح 2024
# ===================================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Banner
show_banner() {
    clear
    echo -e "${RED}"
    echo " ██╗  ██╗ █████╗ ██╗  ██╗███████╗███████╗███╗   ███╗"
    echo " ██║  ██║██╔══██╗██║ ██╔╝██╔════╝██╔════╝████╗ ████║"
    echo " ███████║███████║█████╔╝ █████╗  █████╗  ██╔████╔██║"
    echo " ██╔══██║██╔══██║██╔═██╗ ██╔══╝  ██╔══╝  ██║╚██╔╝██║"
    echo " ██║  ██║██║  ██║██║  ██╗███████╗███████╗██║ ╚═╝ ██║"
    echo " ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝╚═╝     ╚═╝"
    echo -e "${YELLOW}"
    echo "         أداة الطب الشرعي الرقمي - الإصدار المصحح"
    echo -e "${GREEN}"
    echo "              👑 المطور: حكيم العرب"
    echo "              🌐 GitHub: hakim738-html"
    echo -e "${NC}"
}

# Check tools
check_tools() {
    echo -e "${CYAN}🔍 جاري التحقق من الأدوات...${NC}"
    
    if ! command -v exiftool &> /dev/null; then
        echo -e "${YELLOW}📦 تثبيت ExifTool...${NC}"
        pkg install exiftool -y
    fi
    
    if ! command -v python3 &> /dev/null; then
        echo -e "${YELLOW}🐍 تثبيت Python...${NC}"
        pkg install python -y
    fi
    
    # إنشاء مجلدات العمل
    mkdir -p ~/Hakeem-Reports ~/Hakeem-Backups ~/Hakeem-Pages
    echo -e "${GREEN}✅ جاهز!${NC}"
}

# ============================================
# 🔍 وظيفة تحليل الصورة مع إنشاء HTML
# ============================================
analyze_image() {
    echo -e "${CYAN}🎯 أدخل مسار الصورة:${NC}"
    read img_path
    
    if [ ! -f "$img_path" ]; then
        echo -e "${RED}❌ الملف غير موجود!${NC}"
        echo -e "${YELLOW}جرب: /sdcard/Download/photo.jpg${NC}"
        return
    fi
    
    filename=$(basename "$img_path")
    timestamp=$(date +"%Y%m%d_%H%M%S")
    
    # اسم ملف HTML
    html_file="HAKEEM_${timestamp}_${filename%.*}.html"
    html_path="~/Hakeem-Reports/$html_file"
    
    echo -e "${YELLOW}📊 جاري تحليل: $filename${NC}"
    echo -e "${BLUE}⏳ يرجى الانتظار...${NC}"
    
    # استخراج البيانات
    file_size=$(du -h "$img_path" | cut -f1)
    file_type=$(file "$img_path")
    make_model=$(exiftool -Make -Model "$img_path" 2>/dev/null | sed 's/^.*: //')
    date_time=$(exiftool -DateTimeOriginal "$img_path" 2>/dev/null | sed 's/^.*: //')
    
    # تحقق من GPS
    gps_lat=$(exiftool -n -GPSLatitude "$img_path" 2>/dev/null | cut -d: -f2 | xargs)
    gps_lon=$(exiftool -n -GPSLongitude "$img_path" 2>/dev/null | cut -d: -f2 | xargs)
    
    # ============================================
    # 🔧 إنشاء ملف HTML
    # ============================================
    {
        echo "<!DOCTYPE html>"
        echo "<html dir='rtl' lang='ar'>"
        echo "<head>"
        echo "    <meta charset='UTF-8'>"
        echo "    <meta name='viewport' content='width=device-width, initial-scale=1.0'>"
        echo "    <title>تقرير حكيم - $filename</title>"
        echo "    <style>"
        echo "        * { margin: 0; padding: 0; box-sizing: border-box; }"
        echo "        body {"
        echo "            font-family: 'Arial', sans-serif;"
        echo "            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);"
        echo "            color: white;"
        echo "            line-height: 1.6;"
        echo "            padding: 20px;"
        echo "            min-height: 100vh;"
        echo "        }"
        echo "        .header {"
        echo "            background: linear-gradient(90deg, #ff0000, #ff9900);"
        echo "            padding: 25px;"
        echo "            border-radius: 15px;"
        echo "            text-align: center;"
        echo "            margin-bottom: 30px;"
        echo "            box-shadow: 0 10px 30px rgba(255, 0, 0, 0.3);"
        echo "        }"
        echo "        .header h1 {"
        echo "            font-size: 2.5em;"
        echo "            margin-bottom: 10px;"
        echo "        }"
        echo "        .section {"
        echo "            background: rgba(255, 255, 255, 0.1);"
        echo "            backdrop-filter: blur(10px);"
        echo "            padding: 25px;"
        echo "            border-radius: 12px;"
        echo "            margin: 20px 0;"
        echo "            border: 2px solid rgba(255, 255, 255, 0.2);"
        echo "        }"
        echo "        .section h2 {"
        echo "            color: #ffcc00;"
        echo "            border-bottom: 2px solid #ffcc00;"
        echo "            padding-bottom: 10px;"
        echo "            margin-bottom: 20px;"
        echo "        }"
        echo "        .info-grid {"
        echo "            display: grid;"
        echo "            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));"
        echo "            gap: 15px;"
        echo "        }"
        echo "        .info-card {"
        echo "            background: rgba(255, 255, 255, 0.05);"
        echo "            padding: 18px;"
        echo "            border-radius: 10px;"
        echo "            border-left: 5px solid #3498db;"
        echo "        }"
        echo "        .danger { border-left-color: #e74c3c !important; background: rgba(231, 76, 60, 0.1); }"
        echo "        .warning { border-left-color: #f39c12 !important; background: rgba(243, 156, 18, 0.1); }"
        echo "        .safe { border-left-color: #2ecc71 !important; background: rgba(46, 204, 113, 0.1); }"
        echo "        .label { font-weight: bold; color: #3498db; display: block; margin-bottom: 5px; }"
        echo "        .value { color: #ecf0f1; }"
        echo "        .map-link {"
        echo "            display: inline-block;"
        echo "            background: #3498db;"
        echo "            color: white;"
        echo "            padding: 12px 25px;"
        echo "            border-radius: 8px;"
        echo "            text-decoration: none;"
        echo "            margin: 10px 5px;"
        echo "            transition: all 0.3s;"
        echo "        }"
        echo "        .map-link:hover {"
        echo "            background: #2980b9;"
        echo "            transform: translateY(-3px);"
        echo "            box-shadow: 0 5px 15px rgba(52, 152, 219, 0.4);"
        echo "        }"
        echo "        .footer {"
        echo "            text-align: center;"
        echo "            margin-top: 40px;"
        echo "            padding: 20px;"
        echo "            border-top: 1px solid rgba(255, 255, 255, 0.1);"
        echo "            color: #95a5a6;"
        echo "        }"
        echo "        .developer {"
        echo "            color: #ff9900;"
        echo "            font-weight: bold;"
        echo "            font-size: 1.2em;"
        echo "        }"
        echo "        .exif-table {"
        echo "            width: 100%;"
        echo "            border-collapse: collapse;"
        echo "            margin-top: 15px;"
        echo "        }"
        echo "        .exif-table th, .exif-table td {"
        echo "            padding: 12px;"
        echo "            text-align: right;"
        echo "            border-bottom: 1px solid rgba(255, 255, 255, 0.1);"
        echo "        }"
        echo "        .exif-table th {"
        echo "            background: rgba(255, 255, 255, 0.1);"
        echo "            color: #ffcc00;"
        echo "        }"
        echo "        .exif-table tr:hover {"
        echo "            background: rgba(255, 255, 255, 0.05);"
        echo "        }"
        echo "    </style>"
        echo "</head>"
        echo "<body>"
        echo "    <div class='header'>"
        echo "        <h1>🔍 تقرير الطب الشرعي الرقمي</h1>"
        echo "        <p>تحليل البيانات الوصفية للصور</p>"
        echo "    </div>"
        echo ""
        echo "    <div class='section'>"
        echo "        <h2>📁 معلومات الملف</h2>"
        echo "        <div class='info-grid'>"
        echo "            <div class='info-card'>"
        echo "                <span class='label'>📄 اسم الملف:</span>"
        echo "                <span class='value'>$filename</span>"
        echo "            </div>"
        echo "            <div class='info-card'>"
        echo "                <span class='label'>📏 الحجم:</span>"
        echo "                <span class='value'>$file_size</span>"
        echo "            </div>"
        echo "            <div class='info-card'>"
        echo "                <span class='label'>🖼️ نوع الملف:</span>"
        echo "                <span class='value'>${file_type:0:100}</span>"
        echo "            </div>"
        echo "        </div>"
        echo "    </div>"
        echo ""
        echo "    <div class='section'>"
        echo "        <h2>📸 معلومات الكاميرا</h2>"
        echo "        <div class='info-grid'>"
        echo "            <div class='info-card'>"
        echo "                <span class='label'>📷 الشركة المصنعة:</span>"
        echo "                <span class='value'>$(echo "$make_model" | head -1)</span>"
        echo "            </div>"
        echo "            <div class='info-card'>"
        echo "                <span class='label'>📱 موديل الجهاز:</span>"
        echo "                <span class='value'>$(echo "$make_model" | tail -1)</span>"
        echo "            </div>"
        echo "            <div class='info-card'>"
        echo "                <span class='label'>📅 تاريخ الالتقاط:</span>"
        echo "                <span class='value'>$date_time</span>"
        echo "            </div>"
        echo "        </div>"
        echo "    </div>"
        echo ""
    } > "$html_path"
    
    # ============================================
    # 📍 قسم GPS
    # ============================================
    {
        echo "    <div class='section'>"
        echo "        <h2>📍 بيانات الموقع الجغرافي</h2>"
    } >> "$html_path"
    
    if [ -n "$gps_lat" ] && [ -n "$gps_lon" ]; then
        {
            echo "        <div class='info-card danger'>"
            echo "            <span class='label'>⚠️ تحذير: تم اكتشاف بيانات موقع!</span>"
            echo "            <span class='value'>هذه الصورة تحتوي على إحداثيات GPS يمكنها كشف موقعك</span>"
            echo "        </div>"
            echo "        <div style='margin: 20px 0;'>"
            echo "            <div class='info-card'>"
            echo "                <span class='label'>🌍 خط العرض:</span>"
            echo "                <span class='value'>$gps_lat</span>"
            echo "            </div>"
            echo "            <div class='info-card'>"
            echo "                <span class='label'>🌍 خط الطول:</span>"
            echo "                <span class='value'>$gps_lon</span>"
            echo "            </div>"
            echo "        </div>"
            echo "        <div style='margin-top: 20px;'>"
            echo "            <a href='https://maps.google.com/?q=$gps_lat,$gps_lon' class='map-link' target='_blank'>"
            echo "                🗺️ عرض على خرائط جوجل"
            echo "            </a>"
            echo "            <a href='https://www.openstreetmap.org/?mlat=$gps_lat&mlon=$gps_lon' class='map-link' target='_blank'>"
            echo "                🗺️ عرض على OpenStreetMap"
            echo "            </a>"
            echo "        </div>"
        } >> "$html_path"
    else
        {
            echo "        <div class='info-card safe'>"
            echo "            <span class='label'>✅ آمن: لا توجد بيانات موقع</span>"
            echo "            <span class='value'>هذه الصورة لا تحتوي على إحداثيات GPS</span>"
            echo "        </div>"
        } >> "$html_path"
    fi
    
    {
        echo "    </div>"
    } >> "$html_path"
    
    # ============================================
    # 📊 قسم البيانات الوصفية الكاملة
    # ============================================
    {
        echo "    <div class='section'>"
        echo "        <h2>📊 جميع البيانات الوصفية (EXIF)</h2>"
        echo "        <table class='exif-table'>"
        echo "            <thead>"
        echo "                <tr>"
        echo "                    <th>العنوان</th>"
        echo "                    <th>القيمة</th>"
        echo "                </tr>"
        echo "            </thead>"
        echo "            <tbody>"
    } >> "$html_path"
    
    # استخراج كل بيانات EXIF وإضافتها للجدول
    exiftool "$img_path" | while read -r line; do
        if [ -n "$line" ]; then
            key=$(echo "$line" | cut -d: -f1 | sed 's/^[ \t]*//;s/[ \t]*$//')
            value=$(echo "$line" | cut -d: -f2- | sed 's/^[ \t]*//;s/[ \t]*$//')
            
            # تحديد فئة الخطورة
            if echo "$key" | grep -qi -E "(GPS|Location|Latitude|Longitude)"; then
                class="danger"
            elif echo "$key" | grep -qi -E "(Model|Make|Serial|Device)"; then
                class="warning"
            else
                class="safe"
            fi
            
            {
                echo "                <tr class='$class'>"
                echo "                    <td>$key</td>"
                echo "                    <td>$value</td>"
                echo "                </tr>"
            } >> "$html_path"
        fi
    done
    
    {
        echo "            </tbody>"
        echo "        </table>"
        echo "    </div>"
    } >> "$html_path"
    
    # ============================================
    # 👑 تذييل الصفحة
    # ============================================
    {
        echo "    <div class='footer'>"
        echo "        <p>📅 تاريخ التقرير: $(date '+%Y-%m-%d %H:%M:%S')</p>"
        echo "        <p class='developer'>👑 تم إنشاء هذا التقرير بواسطة <strong>حكيم العرب</strong></p>"
        echo "        <p>🔧 الأداة: Hakeem Forensic Pro - الإصدار المصحح</p>"
        echo "        <p>🌐 GitHub: <a href='https://github.com/hakim738-html' style='color:#3498db;'>hakim738-html</a></p>"
        echo "        <p style='margin-top: 15px; font-size: 0.9em; color: #7f8c8d;'>"
        echo "            ⚠️ هذا التقرير للأغراض التعليمية والطب الشرعي فقط"
        echo "        </p>"
        echo "    </div>"
        echo "</body>"
        echo "</html>"
    } >> "$html_path"
    
    # ============================================
    # ✅ عرض النتائج
    # ============================================
    echo -e "${GREEN}✅ تم إنشاء التقرير بنجاح!${NC}"
    echo ""
    echo -e "${CYAN}📄 معلومات التقرير:${NC}"
    echo -e "   📁 الملف: $html_path"
    echo -e "   📏 الحجم: $(du -h "$html_path" | cut -f1)"
    echo -e "   📅 الوقت: $(date '+%H:%M:%S')"
    echo ""
    
    # نسخ لملف التنزيلات
    if [ -d "/sdcard/Download" ]; then
        cp "$html_path" "/sdcard/Download/"
        echo -e "${GREEN}📱 تم نسخ التقرير إلى: /sdcard/Download/$html_file${NC}"
        echo -e "${YELLOW}📂 يمكنك فتحه من تطبيق الملفات على هاتفك${NC}"
    fi
    
    # عرض معلومات سريعة
    echo -e "${CYAN}📊 ملخص التحليل:${NC}"
    echo -e "   📷 الكاميرا: $(echo "$make_model" | tr '\n' ' ')"
    echo -e "   📍 GPS: $(if [ -n "$gps_lat" ]; then echo "✅ موجود"; else echo "❌ غير موجود"; fi)"
    echo -e "   📏 الأبعاد: $(exiftool -ImageWidth -ImageHeight "$img_path" 2>/dev/null | grep -o '[0-9]\+' | tr '\n' 'x' | sed 's/x$//')"
    
    echo ""
    echo -e "${YELLOW}🎯 للعرض السريع:${NC}"
    echo -e "   🔍 في Termux: cat $html_path | head -50"
    if [ -d "/sdcard/Download" ]; then
        echo -e "   📱 في الهاتف: افتح مجلد Download وابحث عن $html_file"
    fi
}

# ============================================
# 🎮 وظيفة صفحة الفيسبوك مع إرسال البيانات
# ============================================
create_facebook_page() {
    echo -e "${CYAN}🎯 إنشاء صفحة فيسبوك تعليمية...${NC}"
    
    page_name="FACEBOOK_$(date +%H%M%S).html"
    page_path="~/Hakeem-Pages/$page_name"
    
    # إنشاء صفحة HTML
    cat > "$page_path" << 'EOF'
<!DOCTYPE html>
<html dir="rtl" lang="ar">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>فيسبوك - تسجيل الدخول</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Arial', sans-serif;
            background: #f0f2f5;
            color: #1c1e21;
            line-height: 1.34;
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
            box-shadow: 0 2px 4px rgba(0, 0, 0, .1), 0 8px 16px rgba(0, 0, 0, .1);
        }
        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 14px 16px;
            margin: 10px 0;
            border: 1px solid #dddfe2;
            border-radius: 6px;
            font-size: 17px;
            background: #f5f6f7;
        }
        input:focus {
            border-color: #1877f2;
            outline: none;
            box-shadow: 0 0 0 2px #e7f3ff;
        }
        .login-btn {
            width: 100%;
            padding: 14px;
            background: #1877f2;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 20px;
            font-weight: bold;
            margin: 10px 0;
            cursor: pointer;
            transition: background 0.3s;
        }
        .login-btn:hover {
            background: #166fe5;
        }
        .links {
            text-align: center;
            margin: 20px 0;
        }
        .links a {
            color: #1877f2;
            text-decoration: none;
            font-size: 14px;
            display: block;
            margin: 5px 0;
        }
        .create-btn {
            width: 60%;
            padding: 12px;
            background: #42b72a;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 17px;
            font-weight: bold;
            margin: 20px auto;
            display: block;
            cursor: pointer;
        }
        .create-btn:hover {
            background: #36a420;
        }
        .warning {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            color: #856404;
            padding: 15px;
            border-radius: 6px;
            margin-top: 20px;
            text-align: center;
            font-size: 14px;
        }
        .terminal-output {
            background: #1e1e1e;
            color: #00ff00;
            padding: 15px;
            border-radius: 6px;
            margin-top: 20px;
            font-family: monospace;
            font-size: 12px;
            display: none;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="logo">facebook</div>
            <p style="color: #606770;">سجّل الدخول إلى فيسبوك</p>
        </div>
        
        <div class="form-box">
            <form id="loginForm">
                <input type="text" id="email" placeholder="البريد الإلكتروني أو رقم الهاتف" required>
                <input type="password" id="password" placeholder="كلمة السر" required>
                
                <button type="submit" class="login-btn">تسجيل الدخول</button>
            </form>
            
            <div class="links">
                <a href="#">هل نسيت كلمة السر؟</a>
                <hr style="margin: 20px 0; border: 0.5px solid #dadde1;">
                <button class="create-btn">إنشاء حساب جديد</button>
            </div>
        </div>
        
        <div class="warning">
            ⚠️ <strong>صفحة تعليمية</strong><br>
            هذه صفحة محاكاة لتوعية المستخدمين بمخاطر التصيد
        </div>
        
        <div id="terminalOutput" class="terminal-output">
            <div id="dataDisplay"></div>
        </div>
    </div>

    <script>
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;
            const terminal = document.getElementById('terminalOutput');
            const dataDisplay = document.getElementById('dataDisplay');
            
            // إظهار نافذة Terminal
            terminal.style.display = 'block';
            
            // إنشاء بيانات للتسجيل
            const logData = `
[📡] البيانات المرسلة إلى الترمكس:
[📧] البريد: ${email}
[🔑] كلمة السر: ${password}
[🕐] الوقت: ${new Date().toLocaleTimeString()}
[📍] IP: 192.168.1.1 (مثال)
========================================
            `;
            
            // عرض البيانات
            dataDisplay.textContent = logData;
            
            // محاكاة إرسال البيانات
            setTimeout(() => {
                alert('🎓 محاكاة تعليمية: تم تسجيل البيانات محلياً للأغراض التعليمية');
                
                // إعادة تعيين الحقول
                document.getElementById('email').value = '';
                document.getElementById('password').value = '';
                terminal.style.display = 'none';
            }, 2000);
        });
        
        document.querySelector('.create-btn').addEventListener('click', function() {
            alert('⛔ هذه الميزة غير متاحة في النسخة التعليمية');
        });
    </script>
</body>
</html>
EOF
    
    echo -e "${GREEN}✅ تم إنشاء صفحة الفيسبوك: $page_name${NC}"
    
    # نسخ لملف التنزيلات
    if [ -d "/sdcard/Download" ]; then
        cp "$page_path" "/sdcard/Download/"
        echo -e "${GREEN}📱 تم النسخ إلى: /sdcard/Download/$page_name${NC}"
    fi
    
    echo ""
    echo -e "${CYAN}🎮 كيفية الاستخدام:${NC}"
    echo -e "   1. افتح الملف في متصفح هاتفك"
    echo -e "   2. أدخل بيانات تجريبية"
    echo -e "   3. شاهد البيانات تظهر في الصفحة نفسها"
    echo ""
    echo -e "${YELLOW}📁 الموقع: $page_path${NC}"
}

# ============================================
# 📡 وظيفة تسجيل البيانات في الترمكس
# ============================================
log_to_terminal() {
    local data_type=$1
    local data=$2
    
    echo -e "${PURPLE}════════════════════════════════════════${NC}"
    echo -e "${CYAN}📡 [تسجيل البيانات] ${WHITE}$(date '+%H:%M:%S')${NC}"
    echo -e "${GREEN}📊 النوع:${NC} $data_type"
    echo -e "${YELLOW}📝 البيانات:${NC}"
    echo "$data"
    echo -e "${PURPLE}════════════════════════════════════════${NC}"
    
    # حفظ في ملف log
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $data_type: $data" >> ~/Hakeem-Reports/data_log.txt
}

# ============================================
# 📋 القائمة الرئيسية
# ============================================
main_menu() {
    check_tools
    
    while true; do
        show_banner
        
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${GREEN}【1】🔍 تحليل صورة + إنشاء HTML"
        echo -e "【2】📸 استخراج بيانات GPS"
        echo -e "【3】🧹 تنظيف بيانات الصورة"
        echo -e "${BLUE}【4】📘 صفحة فيسبوك تعليمية"
        echo -e "【5】🔵 صفحة جوجل تعليمية"
        echo -e "【6】🎮 صفحة بابجي تعليمية"
        echo -e "${YELLOW}【7】📊 عرض التقارير المحفوظة"
        echo -e "【8】📁 فتح مجلد التنزيلات"
        echo -e "${RED}【0】🚪 خروج"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        
        echo -e "${WHITE}"
        read -p "   اختر رقم الخيار: " choice
        echo -e "${NC}"
        
        case $choice in
            1)
                analyze_image
                log_to_terminal "تحليل صورة" "تم إنشاء تقرير HTML"
                ;;
            2)
                echo -e "${CYAN}🎯 أدخل مسار الصورة:${NC}"
                read img_path
                exiftool -GPS* "$img_path" 2>/dev/null
                log_to_terminal "استخراج GPS" "فحص إحداثيات الصورة"
                ;;
            3)
                echo -e "${CYAN}🎯 أدخل مسار الصورة:${NC}"
                read img_path
                backup="BACKUP_$(date +%H%M%S)_$(basename "$img_path")"
                cp "$img_path" "$backup"
                exiftool -all= "$img_path" 2>/dev/null
                echo -e "${GREEN}✅ تم التنظيف!${NC}"
                log_to_terminal "تنظيف بيانات" "تمت إزالة metadata من $img_path"
                ;;
            4)
                create_facebook_page
                log_to_terminal "إنشاء صفحة" "صفحة فيسبوك تعليمية"
                ;;
            5|6|7|8)
                echo -e "${YELLOW}⏳ قيد التطوير...${NC}"
                log_to_terminal "طلب ميزة" "المستخدم طلب الخيار $choice"
                ;;
            0)
                echo -e "${GREEN}👋 مع السلامة - حكيم العرب${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}❌ خيار غير صحيح!${NC}"
                ;;
        esac
        
        echo ""
        echo -e "${YELLOW}⏸️ اضغط Enter للمتابعة...${NC}"
        read
    done
}

# ============================================
# 🚀 بدء التشغيل
# ============================================
main_menu
