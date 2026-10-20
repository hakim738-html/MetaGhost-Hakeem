#!/bin/bash
# ===================================================
# 🔥 H A K E E M   S T E G A N O G R A P H Y   T O O L
# 👑 DEVELOPER: Hakeem Al-Arab
# 🎯 VERSION: 6.4 - Arabic Shaping Fixed
# 🌐 GITHUB: hakim738-html
# 🌍 Languages: العربية / English
# ✨ NEW: Proper Arabic letters connection + HTML reports
# ===================================================

# === COLORS (FIXED with $'...' for escape sequences) ===
RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[1;33m'
BLUE=$'\033[0;34m'
PURPLE=$'\033[0;35m'
CYAN=$'\033[0;36m'
WHITE=$'\033[1;37m'
BOLD=$'\033[1m'
NC=$'\033[0m'

# === DIRECTORIES ===
BASE_DIR="$HOME/Hakeem-Stego"
STEGO_DIR="$BASE_DIR/stego-images"
REPORTS_DIR="$BASE_DIR/reports"
BACKUP_DIR="$BASE_DIR/backups"
LOGS_DIR="$BASE_DIR/logs"
LANG_FILE="$HOME/.hakeem_lang"
LOG_FILE="$LOGS_DIR/hakeem.log"

mkdir -p "$STEGO_DIR" "$REPORTS_DIR" "$BACKUP_DIR" "$LOGS_DIR"

# === LANGUAGE PERSISTENCE (FIXED quotes) ===
LANG_CHOICE="ar"
if [ -f "$LANG_FILE" ]; then
    LANG_CHOICE=$(tr -d '[:space:]' < "$LANG_FILE" 2>/dev/null)
fi
[ "$LANG_CHOICE" = "en" ] || LANG_CHOICE="ar"

# === 🆕 ARABIC SHAPING SUPPORT ===
ARABIC_SUPPORT=0
ensure_arabic_support() {
    if [ "$LANG_CHOICE" = "ar" ]; then
        if python3 -c "import arabic_reshaper; from bidi.algorithm import get_display" 2>/dev/null; then
            ARABIC_SUPPORT=1
        else
            echo -e "${YELLOW}[*] Installing Arabic display support...${NC}"
            pip install --quiet arabic-reshaper python-bidi 2>/dev/null || \
            pip install --quiet --break-system-packages arabic-reshaper python-bidi 2>/dev/null || true
            if python3 -c "import arabic_reshaper; from bidi.algorithm import get_display" 2>/dev/null; then
                ARABIC_SUPPORT=1
                echo -e "${GREEN}[✓] Arabic shaping enabled${NC}"
            else
                echo -e "${YELLOW}[!] Arabic will appear disconnected (install arabic-reshaper manually)${NC}"
            fi
        fi
    fi
}

# === 🆕 SHAPE ARABIC TEXT ===
declare -A AR_CACHE
shape_ar() {
    local text="$1"
    [ -z "$text" ] && return
    [ "$ARABIC_SUPPORT" -eq 0 ] && { printf '%s' "$text"; return; }

    # Check cache
    if [ -n "${AR_CACHE[$text]+x}" ]; then
        printf '%s' "${AR_CACHE[$text]}"
        return
    fi

    local shaped
    shaped=$(python3 -c "
import sys
try:
    import arabic_reshaper
    from bidi.algorithm import get_display
    t = sys.argv[1]
    print(get_display(arabic_reshaper.reshape(t)), end='')
except Exception:
    print(sys.argv[1], end='')
" "$text" 2>/dev/null)

    AR_CACHE[$text]="$shaped"
    printf '%s' "$shaped"
}

# === MESSAGES ===
declare -A MSG_AR MSG_EN

MSG_AR=(
    [developer]="المطوّر: حكيم العرب"
    [version]="الإصدار"
    [menu_title]="القائمة الرئيسية"
    [menu_hide]="إخفاء نص في صورة"
    [menu_extract]="استخراج نص مخفي من صورة"
    [menu_exif]="تحليل بيانات الصورة EXIF"
    [menu_forensic]="تحليل جنائي شامل"
    [menu_logs]="عرض السجلات"
    [menu_lang]="تغيير اللغة"
    [menu_exit]="خروج"
    [prompt_choice]="اختر رقم العملية"
    [prompt_image]="أدخل مسار الصورة"
    [prompt_text]="أدخل النص المراد إخفاؤه"
    [prompt_output]="أدخل اسم الصورة الناتجة بدون امتداد"
    [invalid_choice]="اختيار غير صالح"
    [file_not_found]="الملف غير موجود"
    [processing]="جاري المعالجة"
    [success_hide]="تم إخفاء النص بنجاح"
    [success_extract]="تم استخراج النص بنجاح"
    [error]="خطأ"
    [press_enter]="اضغط Enter للمتابعة"
    [checking_tools]="فحص الأدوات المطلوبة"
    [tool_found]="موجودة"
    [tool_missing]="غير موجودة"
    [tool_installing]="جاري تثبيت"
    [install_deps]="تثبيت المتطلبات الناقصة"
    [backup_created]="تم إنشاء نسخة احتياطية"
    [report_saved]="تم حفظ التقرير في"
    [no_hidden_text]="لا يوجد نص مخفي في هذه الصورة"
    [capacity_error]="حجم الصورة غير كافٍ لإخفاء هذا النص"
    [lang_prompt]="اختر اللغة"
    [lang_set]="تم تعيين اللغة"
    [logs_empty]="لا توجد سجلات بعد"
    [goodbye]="إلى اللقاء"
    [empty_text]="النص فارغ، لا يمكن الإخفاء"
    [empty_path]="لم تدخل مسارا"
    [report_gen]="جاري إنشاء تقرير HTML"
    [report_created]="تم إنشاء تقرير HTML بنجاح"
    [report_location]="موقع التقرير"
    [open_report]="لفتح التقرير افتح مدير الملفات ثم Downloads"
    [analysis_done]="اكتمل التحليل"
    [forensic_done]="اكتمل التحليل الجنائي"
)

MSG_EN=(
    [developer]="Developer: Hakeem Al-Arab"
    [version]="Version"
    [menu_title]="Main Menu"
    [menu_hide]="Hide text in image"
    [menu_extract]="Extract hidden text from image"
    [menu_exif]="Analyze image metadata (EXIF)"
    [menu_forensic]="Full forensic analysis"
    [menu_logs]="View logs"
    [menu_lang]="Change language"
    [menu_exit]="Exit"
    [prompt_choice]="Enter operation number"
    [prompt_image]="Enter image path"
    [prompt_text]="Enter text to hide"
    [prompt_output]="Enter output image name (without extension)"
    [invalid_choice]="Invalid choice"
    [file_not_found]="File not found"
    [processing]="Processing..."
    [success_hide]="Text hidden successfully"
    [success_extract]="Text extracted successfully"
    [error]="Error"
    [press_enter]="Press Enter to continue"
    [checking_tools]="Checking required tools"
    [tool_found]="found"
    [tool_missing]="missing"
    [tool_installing]="Installing"
    [install_deps]="Installing missing dependencies"
    [backup_created]="Backup created"
    [report_saved]="Report saved to"
    [no_hidden_text]="No hidden text found in this image"
    [capacity_error]="Image is too small to hide this text"
    [lang_prompt]="Select Language"
    [lang_set]="Language set to"
    [logs_empty]="No logs yet"
    [goodbye]="Goodbye"
    [empty_text]="Text is empty, cannot hide"
    [empty_path]="No path provided"
    [report_gen]="Generating HTML report..."
    [report_created]="HTML report created"
    [report_location]="Report location"
    [open_report]="To open: File Manager → Downloads"
    [analysis_done]="Analysis complete"
    [forensic_done]="Forensic analysis complete"
)

# === MSG FUNCTION (with Arabic shaping) ===
msg() {
    local key="$1"
    local txt=""
    if [ "$LANG_CHOICE" = "ar" ]; then
        txt="${MSG_AR[$key]:-[$key]}"
        shape_ar "$txt"
    else
        txt="${MSG_EN[$key]:-[$key]}"
        printf '%s' "$txt"
    fi
}

# === HELPERS ===
log_action() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"; }

expand_path() {
    local p="$1"
    p="${p/#\~/$HOME}"
    p="${p/#\$HOME/$HOME}"
    echo "$p"
}

get_download_dir() {
    if [ -d "$HOME/storage/downloads" ]; then echo "$HOME/storage/downloads"
    elif [ -d "/sdcard/Download" ]; then echo "/sdcard/Download"
    elif [ -d "$HOME/Downloads" ]; then echo "$HOME/Downloads"
    else mkdir -p "$HOME/Downloads"; echo "$HOME/Downloads"; fi
}

# === BANNER ===
show_banner() {
    clear
    echo -e "${RED}"
    echo "╔══════════════════════════════════════════════════════╗"
    echo "║   ██╗  ██╗ █████╗ ██╗  ██╗███████╗███████╗███╗   ███╗║"
    echo "║   ██║  ██║██╔══██╗██║ ██╔╝██╔════╝██╔════╝████╗ ████║║"
    echo "║   ███████║███████║█████╔╝ █████╗  █████╗  ██╔████╔██║║"
    echo "║   ██╔══██║██╔══██║██╔═██╗ ██╔══╝  ██╔══╝  ██║╚██╔╝██║║"
    echo "║   ██║  ██║██║  ██║██║  ██╗███████╗███████╗██║ ╚═╝ ██║║"
    echo "║   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝╚═╝     ╚═╝║"
    echo "║      🔥 IMAGE STEGANOGRAPHY & FORENSICS TOOL 🔥     ║"
    echo "╚══════════════════════════════════════════════════════╝"
    echo -e "${NC}${CYAN}┌────────────────────────────────────────────────────┐${NC}"
    printf "${CYAN}│  👑 %-48s│${NC}\n" "$(msg developer)"
    printf "${CYAN}│  🌐 %-48s│${NC}\n" "GitHub: hakim738-html"
    printf "${CYAN}│  🎯 %-48s│${NC}\n" "$(msg version): 6.4"
    printf "${CYAN}│  🌍 %-48s│${NC}\n" "Lang: $LANG_CHOICE"
    echo -e "${CYAN}└────────────────────────────────────────────────────┘${NC}"
    echo ""
}

# === TOOL CHECK ===
check_tools() {
    echo -e "${CYAN}[*] $(msg checking_tools)...${NC}"
    local missing=()
    for tool in exiftool python3 file; do
        if ! command -v "$tool" &>/dev/null; then
            missing+=("$tool")
            echo -e "${YELLOW}[!] $tool: $(msg tool_missing)${NC}"
        else
            echo -e "${GREEN}[✓] $tool: $(msg tool_found)${NC}"
        fi
    done
    if command -v python3 &>/dev/null; then
        if ! python3 -c "from PIL import Image" 2>/dev/null; then
            echo -e "${YELLOW}[!] Pillow: $(msg tool_missing)${NC}"
            missing+=("pillow")
        else
            echo -e "${GREEN}[✓] Pillow: $(msg tool_found)${NC}"
        fi
    fi
    if [ ${#missing[@]} -gt 0 ]; then
        echo -e "${YELLOW}[!] $(msg install_deps)...${NC}"
        pkg update -y >/dev/null 2>&1
        for tool in "${missing[@]}"; do
            echo -e "${BLUE}[*] $(msg tool_installing) $tool...${NC}"
            case "$tool" in
                pillow) pkg install -y python-pillow >/dev/null 2>&1 ;;
                *) pkg install "$tool" -y >/dev/null 2>&1 ;;
            esac
        done
        echo -e "${GREEN}[✓] Done${NC}"
    fi
}

# === PYTHON HELPER ===
create_python_helper() {
    cat > "$BASE_DIR/stego_helper.py" << 'PYEOF'
#!/usr/bin/env python3
import sys
from PIL import Image

def hide_text(image_path, text, output_path):
    image = Image.open(image_path).convert("RGB")
    text_bytes = text.encode('utf-8')
    length = len(text_bytes)
    data = length.to_bytes(4, 'big') + text_bytes
    binary_data = ''.join(format(b, '08b') for b in data)
    capacity = image.width * image.height * 3
    if len(binary_data) > capacity:
        print(f"ERROR: need {len(binary_data)//8} bytes, capacity {capacity//8} bytes", file=sys.stderr)
        sys.exit(2)
    pixels = list(image.getdata())
    new_pixels, idx = [], 0
    for pixel in pixels:
        r, g, b = pixel
        if idx < len(binary_data): r = (r & ~1) | int(binary_data[idx]); idx += 1
        if idx < len(binary_data): g = (g & ~1) | int(binary_data[idx]); idx += 1
        if idx < len(binary_data): b = (b & ~1) | int(binary_data[idx]); idx += 1
        new_pixels.append((r, g, b))
    new_image = Image.new("RGB", image.size)
    new_image.putdata(new_pixels)
    new_image.save(output_path, format="PNG")
    print(f"OK:{length}")

def extract_text(image_path):
    image = Image.open(image_path).convert("RGB")
    pixels = list(image.getdata())
    bits = []
    for pixel in pixels:
        for i in range(3):
            bits.append(pixel[i] & 1)
    if len(bits) < 32:
        print("ERROR:image too small", file=sys.stderr); sys.exit(3)
    length = 0
    for i in range(32):
        length = (length << 1) | bits[i]
    if length <= 0 or length * 8 + 32 > len(bits):
        print("ERROR:no valid data", file=sys.stderr); sys.exit(4)
    data_bytes = bytearray()
    for i in range(length):
        byte = 0
        for j in range(8):
            byte = (byte << 1) | bits[32 + i*8 + j]
        data_bytes.append(byte)
    try:
        print(data_bytes.decode('utf-8'))
    except UnicodeDecodeError:
        print("ERROR:not valid UTF-8", file=sys.stderr); sys.exit(5)

if __name__ == "__main__":
    if len(sys.argv) == 5 and sys.argv[1] == "hide":
        hide_text(sys.argv[2], sys.argv[3], sys.argv[4])
    elif len(sys.argv) == 3 and sys.argv[1] == "extract":
        extract_text(sys.argv[2])
    else:
        print("Usage: stego_helper.py hide <img> <text> <out> | extract <img>", file=sys.stderr)
        sys.exit(1)
PYEOF
    chmod +x "$BASE_DIR/stego_helper.py"
}

# === HIDE TEXT ===
hide_text_menu() {
    echo -e "${CYAN}═══ $(msg menu_hide) ═══${NC}"
    read -r -p "$(msg prompt_image): " img_path
    img_path=$(expand_path "$img_path")
    [ -z "$img_path" ] && { echo -e "${RED}[✗] $(msg empty_path)${NC}"; return; }
    [ ! -f "$img_path" ] && { echo -e "${RED}[✗] $(msg file_not_found)${NC}"; return; }
    local backup="$BACKUP_DIR/$(basename "$img_path").bak"
    cp "$img_path" "$backup"
    echo -e "${GREEN}[✓] $(msg backup_created): $backup${NC}"
    read -r -p "$(msg prompt_text): " secret_text
    [ -z "$secret_text" ] && { echo -e "${RED}[✗] $(msg empty_text)${NC}"; return; }
    read -r -p "$(msg prompt_output) [hidden_output]: " out_name
    out_name="${out_name:-hidden_output}"
    local output="$STEGO_DIR/${out_name}.png"
    echo -e "${YELLOW}[*] $(msg processing)...${NC}"
    if python3 "$BASE_DIR/stego_helper.py" hide "$img_path" "$secret_text" "$output" 2>&1; then
        echo -e "${GREEN}[✓] $(msg success_hide)${NC}"
        echo -e "${GREEN}[✓] Output: $output${NC}"
        log_action "HIDE: $img_path -> $output"
    else
        echo -e "${RED}[✗] $(msg capacity_error)${NC}"
    fi
}

# === EXTRACT TEXT ===
extract_text_menu() {
    echo -e "${CYAN}═══ $(msg menu_extract) ═══${NC}"
    read -r -p "$(msg prompt_image): " img_path
    img_path=$(expand_path "$img_path")
    [ ! -f "$img_path" ] && { echo -e "${RED}[✗] $(msg file_not_found)${NC}"; return; }
    echo -e "${YELLOW}[*] $(msg processing)...${NC}"
    local result
    result=$(python3 "$BASE_DIR/stego_helper.py" extract "$img_path" 2>&1)
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[✓] $(msg success_extract):${NC}"
        echo -e "${WHITE}─────────────────────────────────────${NC}"
        echo -e "$result"
        echo -e "${WHITE}─────────────────────────────────────${NC}"
        log_action "EXTRACT: $img_path"
    else
        echo -e "${RED}[✗] $(msg no_hidden_text)${NC}"
    fi
}

# === HTML REPORT ===
create_html_report() {
    local img_path="$1"
    local report_type="$2"
    echo -e "${YELLOW}[*] $(msg report_gen)...${NC}"
    local download_dir=$(get_download_dir)
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local html_file="$download_dir/hakeem_${report_type}_${timestamp}.html"
    local img_name=$(basename "$img_path")
    local img_size=$(du -h "$img_path" 2>/dev/null | cut -f1)
    local img_type=$(file -b "$img_path" 2>/dev/null)
    local analysis_date=$(date '+%Y-%m-%d %H:%M:%S')

    local exif_raw=""
    command -v exiftool &>/dev/null && exif_raw=$(exiftool "$img_path" 2>/dev/null)

    local gps_lat=$(echo "$exif_raw" | grep -i "GPS Latitude" | head -1 | sed 's/.*: //')
    local gps_lon=$(echo "$exif_raw" | grep -i "GPS Longitude" | head -1 | sed 's/.*: //')
    local camera_make=$(echo "$exif_raw" | grep -iE "^Make\s*:" | head -1 | sed 's/.*: //')
    local camera_model=$(echo "$exif_raw" | grep -iE "^Camera Model Name" | head -1 | sed 's/.*: //')
    local date_taken=$(echo "$exif_raw" | grep -iE "Date/Time Original" | head -1 | sed 's/.*: //')

    local md5_hash="" sha1_hash="" sha256_hash=""
    if [ "$report_type" = "forensic" ]; then
        md5_hash=$(md5sum "$img_path" 2>/dev/null | cut -d' ' -f1)
        sha1_hash=$(sha1sum "$img_path" 2>/dev/null | cut -d' ' -f1)
        sha256_hash=$(sha256sum "$img_path" 2>/dev/null | cut -d' ' -f1)
    fi

    html_escape() { sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g'; }

    cat > "$html_file" << HTMLEOF
<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Hakeem Report - ${img_name}</title>
<style>
:root{--bg:#0d1117;--card:#161b22;--border:#30363d;--text:#e6edf3;--muted:#8b949e;--green:#3fb950;--blue:#58a6ff;--orange:#f0883e;--red:#ff5757}
*{box-sizing:border-box;margin:0;padding:0}
body{background:var(--bg);color:var(--text);font-family:-apple-system,"Segoe UI",Tahoma,sans-serif;line-height:1.7;padding:20px;max-width:960px;margin:0 auto}
header{text-align:center;padding:30px;border-bottom:1px solid var(--border);margin-bottom:25px}
h1{font-size:1.9em;background:linear-gradient(135deg,var(--red),var(--orange));-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;margin-bottom:8px}
.subtitle{color:var(--muted);font-size:.9em}
section{background:var(--card);border:1px solid var(--border);border-radius:10px;padding:20px;margin-bottom:16px}
h2{color:var(--orange);font-size:1.2em;margin-bottom:14px;padding-bottom:8px;border-bottom:1px solid var(--border)}
.info-grid{display:grid;grid-template-columns:1fr 1fr;gap:10px}
@media(max-width:600px){.info-grid{grid-template-columns:1fr}}
.info-item{background:var(--bg);border-radius:6px;padding:10px 12px}
.info-label{color:var(--muted);font-size:.8em;margin-bottom:3px}
.info-value{color:var(--text);font-size:.92em;word-break:break-all;font-weight:500}
.code-block{background:#010409;border:1px solid var(--border);border-radius:6px;padding:12px;font-family:"Courier New",monospace;font-size:.82em;overflow-x:auto;white-space:pre-wrap;word-break:break-all;color:#79c0ff;direction:ltr;text-align:left;max-height:400px;overflow-y:auto}
.hash-block{background:#010409;border:1px solid var(--border);border-radius:6px;padding:10px;margin-bottom:8px;font-family:"Courier New",monospace;font-size:.8em;word-break:break-all;direction:ltr;text-align:left;color:#bc8cff}
footer{text-align:center;padding:25px;color:var(--muted);border-top:1px solid var(--border);margin-top:25px;font-size:.85em}
footer a{color:var(--blue);text-decoration:none}
</style>
</head>
<body>
<header>
<h1>🔥 Hakeem Stego Report</h1>
<div class="subtitle">👑 حكيم العرب — Hakeem Al-Arab</div>
<div class="subtitle">📅 ${analysis_date}</div>
</header>

<section>
<h2>🖼️ معلومات الصورة</h2>
<div class="info-grid">
<div class="info-item"><div class="info-label">اسم الملف</div><div class="info-value">${img_name}</div></div>
<div class="info-item"><div class="info-label">الحجم</div><div class="info-value">${img_size}</div></div>
<div class="info-item"><div class="info-label">النوع</div><div class="info-value">${img_type}</div></div>
<div class="info-item"><div class="info-label">المسار</div><div class="info-value" style="font-size:.75em">${img_path}</div></div>
</div>
</section>

<section>
<h2>📍 الموقع الجغرافي</h2>
<div class="info-grid">
<div class="info-item"><div class="info-label">خط العرض</div><div class="info-value">${gps_lat:-غير متوفر}</div></div>
<div class="info-item"><div class="info-label">خط الطول</div><div class="info-value">${gps_lon:-غير متوفر}</div></div>
</div>
</section>

<section>
<h2>📱 معلومات الجهاز</h2>
<div class="info-grid">
<div class="info-item"><div class="info-label">الشركة</div><div class="info-value">${camera_make:-غير متوفر}</div></div>
<div class="info-item"><div class="info-label">الطراز</div><div class="info-value">${camera_model:-غير متوفر}</div></div>
<div class="info-item"><div class="info-label">تاريخ الالتقاط</div><div class="info-value">${date_taken:-غير متوفر}</div></div>
</div>
</section>
HTMLEOF

    if [ "$report_type" = "forensic" ]; then
        cat >> "$html_file" << HTMLEOF
<section>
<h2>🔐 التجزئات</h2>
<div class="hash-block">MD5: ${md5_hash:-N/A}</div>
<div class="hash-block">SHA1: ${sha1_hash:-N/A}</div>
<div class="hash-block">SHA256: ${sha256_hash:-N/A}</div>
</section>
HTMLEOF
    fi

    cat >> "$html_file" << HTMLEOF
<section>
<h2>📋 بيانات EXIF الكاملة</h2>
<div class="code-block">$(echo "$exif_raw" | html_escape)</div>
</section>

<footer>
<p>👑 <strong>حكيم العرب — Hakeem Al-Arab</strong></p>
<p>🌐 <a href="https://github.com/hakim738-html">github.com/hakim738-html</a></p>
<p>Hakeem Stego v6.4 • MIT License</p>
</footer>
</body></html>
HTMLEOF

    echo ""
    echo -e "${GREEN}${BOLD}════════════════════════════════════════${NC}"
    echo -e "${GREEN}${BOLD}  ✅ $(msg report_created)${NC}"
    echo -e "${GREEN}${BOLD}════════════════════════════════════════${NC}"
    echo -e "${CYAN}  $(msg report_location):${NC}"
    echo -e "${WHITE}  📁 ${BOLD}$html_file${NC}"
    echo -e "${CYAN}  $(msg open_report)${NC}"
    echo -e "${GREEN}${BOLD}════════════════════════════════════════${NC}"

    log_action "HTML_REPORT: $report_type -> $html_file"
    command -v termux-open &>/dev/null && sleep 1 && termux-open "$html_file" 2>/dev/null || true
}

# === EXIF MENU ===
exif_menu() {
    echo -e "${CYAN}═══ $(msg menu_exif) ═══${NC}"
    read -r -p "$(msg prompt_image): " img_path
    img_path=$(expand_path "$img_path")
    [ -z "$img_path" ] && { echo -e "${RED}[✗] $(msg empty_path)${NC}"; return; }
    [ ! -f "$img_path" ] && { echo -e "${RED}[✗] $(msg file_not_found)${NC}"; return; }
    echo -e "${YELLOW}[*] $(msg processing)...${NC}"
    echo ""
    command -v exiftool &>/dev/null && exiftool "$img_path" || file "$img_path"
    log_action "EXIF: $img_path"
    create_html_report "$img_path" "exif"
    echo ""
    echo -e "${GREEN}[✓] $(msg analysis_done)${NC}"
}

# === FORENSIC MENU ===
forensic_menu() {
    echo -e "${CYAN}═══ $(msg menu_forensic) ═══${NC}"
    read -r -p "$(msg prompt_image): " img_path
    img_path=$(expand_path "$img_path")
    [ -z "$img_path" ] && { echo -e "${RED}[✗] $(msg empty_path)${NC}"; return; }
    [ ! -f "$img_path" ] && { echo -e "${RED}[✗] $(msg file_not_found)${NC}"; return; }
    echo -e "${YELLOW}[*] $(msg processing)...${NC}"

    local txt_report="$REPORTS_DIR/forensic_$(date +%Y%m%d_%H%M%S).txt"
    {
        echo "=== FORENSIC REPORT ==="
        echo "Date: $(date)"
        echo "File: $img_path"
        echo ""
        file "$img_path"
        ls -lh "$img_path"
        echo ""
        md5sum "$img_path" 2>/dev/null
        sha1sum "$img_path" 2>/dev/null
        sha256sum "$img_path" 2>/dev/null
        echo ""
        exiftool "$img_path" 2>/dev/null
    } > "$txt_report" 2>&1

    echo -e "${GREEN}[✓] Text report: $txt_report${NC}"
    create_html_report "$img_path" "forensic"
    echo ""
    echo -e "${GREEN}[✓] $(msg forensic_done)${NC}"
}

# === VIEW LOGS ===
view_logs() {
    echo -e "${CYAN}═══ $(msg menu_logs) ═══${NC}"
    if [ -f "$LOG_FILE" ] && [ -s "$LOG_FILE" ]; then
        tail -50 "$LOG_FILE"
    else
        echo -e "${YELLOW}$(msg logs_empty)${NC}"
    fi
}

# === CHANGE LANGUAGE ===
change_language() {
    echo -e "${CYAN}═══ $(msg lang_prompt) ═══${NC}"
    echo "  1) العربية"
    echo "  2) English"
    read -r -p "> " choice
    case "$choice" in
        1) LANG_CHOICE="ar" ;;
        2) LANG_CHOICE="en" ;;
        *) echo -e "${RED}$(msg invalid_choice)${NC}"; return ;;
    esac
    printf '%s' "$LANG_CHOICE" > "$LANG_FILE"
    echo -e "${GREEN}[✓] $(msg lang_set): $LANG_CHOICE${NC}"
    [ "$LANG_CHOICE" = "ar" ] && ensure_arabic_support
}

# === INITIAL LANGUAGE ===
initial_language_select() {
    [ -f "$LANG_FILE" ] && return
    clear
    echo -e "${CYAN}╔══════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║  Select Language / اختر اللغة       ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════╝${NC}"
    echo "  1) العربية"
    echo "  2) English"
    read -r -p "> " choice
    case "$choice" in
        1) LANG_CHOICE="ar" ;;
        2) LANG_CHOICE="en" ;;
        *) LANG_CHOICE="ar" ;;
    esac
    printf '%s' "$LANG_CHOICE" > "$LANG_FILE"
}

# === MAIN MENU ===
main_menu() {
    while true; do
        show_banner
        echo -e "${CYAN}═══ $(msg menu_title) ═══${NC}"
        echo -e "${GREEN}[1]${NC} $(msg menu_hide)"
        echo -e "${GREEN}[2]${NC} $(msg menu_extract)"
        echo -e "${GREEN}[3]${NC} $(msg menu_exif) ${YELLOW}→ HTML${NC}"
        echo -e "${GREEN}[4]${NC} $(msg menu_forensic) ${YELLOW}→ HTML${NC}"
        echo -e "${GREEN}[5]${NC} $(msg menu_logs)"
        echo -e "${GREEN}[6]${NC} $(msg menu_lang)"
        echo -e "${RED}[0]${NC} $(msg menu_exit)"
        echo ""
        read -r -p "$(msg prompt_choice): " choice
        case "$choice" in
            1) hide_text_menu; read -r -p "$(msg press_enter)..." ;;
            2) extract_text_menu; read -r -p "$(msg press_enter)..." ;;
            3) exif_menu; read -r -p "$(msg press_enter)..." ;;
            4) forensic_menu; read -r -p "$(msg press_enter)..." ;;
            5) view_logs; read -r -p "$(msg press_enter)..." ;;
            6) change_language; read -r -p "$(msg press_enter)..." ;;
            0) echo -e "${GREEN}$(msg goodbye)${NC}"; exit 0 ;;
            *) echo -e "${RED}$(msg invalid_choice)${NC}"; sleep 1 ;;
        esac
    done
}

# === ENTRY ===
initial_language_select
ensure_arabic_support
check_tools
create_python_helper
log_action "=== Session started (lang=$LANG_CHOICE) ==="
main_menu
