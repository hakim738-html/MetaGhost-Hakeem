#!/bin/bash
# ===================================================
# 🔥 H A K E E M   S T E G A N O G R A P H Y   T O O L
# 👑 DEVELOPER: Hakeem Al-Arab
# 🎯 VERSION: 6.6 - Universal Input Support
# 🌐 GITHUB: hakim738-html
# 🌍 Languages: العربية / English
# ===================================================

# === COLORS ===
RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[1;33m'
BLUE=$'\033[0;34m'
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

# === LANGUAGE PERSISTENCE ===
LANG_CHOICE="ar"
if [ -f "$LANG_FILE" ]; then
    LANG_CHOICE=$(tr -d '[:space:]' < "$LANG_FILE" 2>/dev/null)
fi
[ "$LANG_CHOICE" = "en" ] || LANG_CHOICE="ar"

# === 🆕 ARABIC SHAPING SUPPORT ===
ARABIC_SUPPORT=0
declare -A AR_CACHE

ensure_arabic_support() {
    if [ "$LANG_CHOICE" = "ar" ]; then
        if python3 -c "import arabic_reshaper; from bidi.algorithm import get_display" 2>/dev/null; then
            ARABIC_SUPPORT=1
        else
            echo -e "${YELLOW}[*] Installing Arabic display support...${NC}"
            pip install --quiet arabic-reshaper python-bidi==0.4.2 --break-system-packages 2>/dev/null || true
            if python3 -c "import arabic_reshaper; from bidi.algorithm import get_display" 2>/dev/null; then
                ARABIC_SUPPORT=1
            fi
        fi
    fi
}

shape_ar() {
    local text="$1"
    [ -z "$text" ] && return
    [ "$ARABIC_SUPPORT" -eq 0 ] && { printf '%s' "$text"; return; }

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
    print(get_display(arabic_reshaper.reshape(sys.argv[1])), end='')
except Exception:
    print(sys.argv[1], end='')
" "$text" 2>/dev/null)

    AR_CACHE[$text]="$shaped"
    printf '%s' "$shaped"
}

# === 🆕 UNIVERSAL NUMBER CONVERTER (Accepts Arabic ٠١٢٣٤٥٦٧٨٩) ===
normalize_num() {
    python3 -c "
import sys
trans = str.maketrans('٠١٢٣٤٥٦٧٨٩', '0123456789')
print(sys.argv[1].translate(trans), end='')
" "$1"
}

# === MESSAGES ===
declare -A MSG_AR MSG_EN

MSG_AR=(
    [developer]="المطور: حكيم العرب"
    [version]="الإصدار"
    [menu_title]="القائمة الرئيسية"
    [menu_hide]="إخفاء نص في صورة"
    [menu_extract]="استخراج نص مخفي من صورة"
    [menu_exif]="تحليل بيانات الصورة (EXIF)"
    [menu_forensic]="تحليل جنائي شامل"
    [menu_logs]="عرض السجلات"
    [menu_lang]="تغيير اللغة (Change Language)"
    [menu_exit]="خروج"
    [prompt_choice]="اختر رقم العملية"
    [prompt_image]="أدخل مسار الصورة"
    [prompt_text]="أدخل النص المراد إخفاؤه"
    [prompt_output]="أدخل اسم الصورة الناتجة"
    [invalid_choice]="اختيار غير صالح"
    [file_not_found]="الملف غير موجود"
    [processing]="جاري المعالجة..."
    [success_hide]="تم إخفاء النص بنجاح"
    [success_extract]="تم استخراج النص بنجاح"
    [press_enter]="اضغط Enter للمتابعة..."
    [checking_tools]="فحص الأدوات المطلوبة"
    [tool_found]="موجودة"
    [tool_missing]="غير موجودة"
    [backup_created]="تم إنشاء نسخة احتياطية"
    [no_hidden_text]="لا يوجد نص مخفي أو الصورة غير صالحة"
    [capacity_error]="حجم الصورة غير كافٍ لإخفاء هذا النص"
    [lang_prompt]="اختر اللغة"
    [lang_set]="تم تعيين اللغة"
    [logs_empty]="لا توجد سجلات بعد"
    [goodbye]="إلى اللقاء"
    [empty_text]="النص فارغ"
    [empty_path]="لم تُدخل مساراً"
    [report_gen]="جاري إنشاء تقرير HTML..."
    [report_created]="تم إنشاء تقرير HTML بنجاح"
    [report_location]="موقع التقرير"
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
    [prompt_output]="Enter output image name"
    [invalid_choice]="Invalid choice"
    [file_not_found]="File not found"
    [processing]="Processing..."
    [success_hide]="Text hidden successfully"
    [success_extract]="Text extracted successfully"
    [press_enter]="Press Enter to continue..."
    [checking_tools]="Checking required tools"
    [tool_found]="found"
    [tool_missing]="missing"
    [backup_created]="Backup created"
    [no_hidden_text]="No hidden text found or invalid image"
    [capacity_error]="Image is too small to hide this text"
    [lang_prompt]="Select Language"
    [lang_set]="Language set to"
    [logs_empty]="No logs yet"
    [goodbye]="Goodbye"
    [empty_text]="Text is empty"
    [empty_path]="No path provided"
    [report_gen]="Generating HTML report..."
    [report_created]="HTML report created"
    [report_location]="Report location"
    [analysis_done]="Analysis complete"
    [forensic_done]="Forensic analysis complete"
)

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
    p=$(normalize_num "$p") # تحويل الأرقام العربية إلى إنجليزية
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
    printf "${CYAN}│  🎯 %-48s│${NC}\n" "$(msg version): 6.6"
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
            missing+=("pillow")
            echo -e "${YELLOW}[!] Pillow: $(msg tool_missing)${NC}"
        else
            echo -e "${GREEN}[✓] Pillow: $(msg tool_found)${NC}"
        fi
    fi
    if [ ${#missing[@]} -gt 0 ]; then
        pkg update -y >/dev/null 2>&1
        for tool in "${missing[@]}"; do
            case "$tool" in
                pillow) pkg install -y python-pillow >/dev/null 2>&1 ;;
                *) pkg install "$tool" -y >/dev/null 2>&1 ;;
            esac
        done
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

def extract_text(image_path):
    image = Image.open(image_path).convert("RGB")
    pixels = list(image.getdata())
    bits = []
    for pixel in pixels:
        for i in range(3): bits.append(pixel[i] & 1)
    if len(bits) < 32: sys.exit(3)
    length = 0
    for i in range(32): length = (length << 1) | bits[i]
    if length <= 0 or length * 8 + 32 > len(bits): sys.exit(4)
    data_bytes = bytearray()
    for i in range(length):
        byte = 0
        for j in range(8): byte = (byte << 1) | bits[32 + i*8 + j]
        data_bytes.append(byte)
    try: print(data_bytes.decode('utf-8'))
    except: sys.exit(5)

if __name__ == "__main__":
    if len(sys.argv) == 5 and sys.argv[1] == "hide": hide_text(sys.argv[2], sys.argv[3], sys.argv[4])
    elif len(sys.argv) == 3 and sys.argv[1] == "extract": extract_text(sys.argv[2])
    else: sys.exit(1)
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
    
    cp "$img_path" "$BACKUP_DIR/$(basename "$img_path").bak"
    echo -e "${GREEN}[✓] $(msg backup_created)${NC}"
    
    read -r -p "$(msg prompt_text): " secret_text
    [ -z "$secret_text" ] && { echo -e "${RED}[✗] $(msg empty_text)${NC}"; return; }
    
    read -r -p "$(msg prompt_output) [hidden]: " out_name
    out_name="${out_name:-hidden}"
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
    echo -e "${YELLOW}[*] $(msg report_gen)...${NC}"
    local html_file="$(get_download_dir)/hakeem_report_$(date +%Y%m%d_%H%M%S).html"
    local exif_raw=$(exiftool "$img_path" 2>/dev/null)
    local md5=$(md5sum "$img_path" | cut -d' ' -f1)
    local sha=$(sha256sum "$img_path" | cut -d' ' -f1)
    
    cat > "$html_file" << HTMLEOF
<!DOCTYPE html><html lang="ar" dir="rtl"><head><meta charset="UTF-8">
<title>Hakeem Report</title>
<style>
body{font-family:Tahoma, sans-serif;background:#0d1117;color:#fff;padding:20px;line-height:1.6}
h1{color:#f0883e;text-align:center}.box{background:#161b22;padding:20px;border-radius:8px;margin-bottom:20px;border:1px solid #30363d}
pre{background:#000;padding:15px;overflow:auto;direction:ltr;text-align:left;border-radius:6px;color:#58a6ff}
.label{color:#8b949e;font-size:0.9em}
</style></head>
<body>
<h1>🔥 تقرير تحليل الصورة - Hakeem Stego</h1>
<div class="box">
<p><span class="label">الملف:</span> $img_path</p>
<p><span class="label">التاريخ:</span> $(date)</p>
<p><span class="label">MD5:</span> $md5</p>
<p><span class="label">SHA256:</span> $sha</p>
</div>
<div class="box">
<h3>بيانات EXIF الكاملة:</h3>
<pre>$exif_raw</pre>
</div>
</body></html>
HTMLEOF

    echo -e "${GREEN}[✓] $(msg report_created)${NC}"
    echo -e "${CYAN}$(msg report_location):${NC} $html_file"
    log_action "HTML_REPORT: $html_file"
    command -v termux-open &>/dev/null && sleep 1 && termux-open "$html_file" 2>/dev/null || true
}

# === EXIF MENU ===
exif_menu() {
    echo -e "${CYAN}═══ $(msg menu_exif) ═══${NC}"
    read -r -p "$(msg prompt_image): " img_path
    img_path=$(expand_path "$img_path")
    [ ! -f "$img_path" ] && { echo -e "${RED}[✗] $(msg file_not_found)${NC}"; return; }
    
    echo -e "${YELLOW}[*] $(msg processing)...${NC}"
    exiftool "$img_path" 2>/dev/null || file "$img_path"
    create_html_report "$img_path"
    echo -e "${GREEN}[✓] $(msg analysis_done)${NC}"
}

# === FORENSIC MENU ===
forensic_menu() {
    echo -e "${CYAN}═══ $(msg menu_forensic) ═══${NC}"
    read -r -p "$(msg prompt_image): " img_path
    img_path=$(expand_path "$img_path")
    [ ! -f "$img_path" ] && { echo -e "${RED}[✗] $(msg file_not_found)${NC}"; return; }
    
    echo -e "${YELLOW}[*] $(msg processing)...${NC}"
    exiftool "$img_path" 2>/dev/null
    create_html_report "$img_path"
    echo -e "${GREEN}[✓] $(msg forensic_done)${NC}"
}

# === LOGS ===
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
        *) return ;;
    esac
    printf '%s' "$LANG_CHOICE" > "$LANG_FILE"
    [ "$LANG_CHOICE" = "ar" ] && ensure_arabic_support
    echo -e "${GREEN}[✓] $(msg lang_set): $LANG_CHOICE${NC}"
}

# === INITIAL LANGUAGE ===
initial_language_select() {
    [ -f "$LANG_FILE" ] && return
    clear
    echo "1) العربية"
    echo "2) English"
    read -r -p "> " choice
    case "$choice" in 1) LANG_CHOICE="ar";; 2) LANG_CHOICE="en";; *) LANG_CHOICE="ar";; esac
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
            1) hide_text_menu; read -r -p "$(msg press_enter)" ;;
            2) extract_text_menu; read -r -p "$(msg press_enter)" ;;
            3) exif_menu; read -r -p "$(msg press_enter)" ;;
            4) forensic_menu; read -r -p "$(msg press_enter)" ;;
            5) view_logs; read -r -p "$(msg press_enter)" ;;
            6) change_language; read -r -p "$(msg press_enter)" ;;
            0) echo -e "${GREEN}$(msg goodbye)${NC}"; exit 0 ;;
            *) echo -e "${RED}$(msg invalid_choice)${NC}"; sleep 1 ;;
        esac
    done
}

# === ENTRY POINT ===
initial_language_select
ensure_arabic_support
check_tools
create_python_helper
log_action "=== Session started (lang=$LANG_CHOICE) ==="
main_menu
