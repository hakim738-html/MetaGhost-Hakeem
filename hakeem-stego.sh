#!/bin/bash
# ===================================================
# 🔥 H A K E E M   S T E G A N O G R A P H Y   T O O L
# 👑 DEVELOPER: Hakeem Al-Arab
# 🎯 VERSION: 6.1 - Image Steganography & Forensics
# 🌐 GITHUB: hakim738-html
# 🌍 Languages: العربية / English
# ===================================================

# === COLORS ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# === LANGUAGE PERSISTENCE ===
LANG_FILE="$HOME/.hakeem_lang"
LANG_CHOICE="ar"
[ -f "$LANG_FILE" ] && LANG_CHOICE=$(cat "$LANG_FILE")

# === MESSAGES (AR / EN) ===
declare -A MSG_AR MSG_EN

MSG_AR=(
    [developer]="المطوّر: حكيم العرب"
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
    [prompt_output]="أدخل اسم الصورة الناتجة (بدون امتداد)"
    [invalid_choice]="اختيار غير صالح"
    [file_not_found]="الملف غير موجود"
    [processing]="جاري المعالجة..."
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
    [lang_prompt]="اختر اللغة / Select Language"
    [lang_set]="تم تعيين اللغة"
    [logs_empty]="لا توجد سجلات بعد"
    [goodbye]="إلى اللقاء 👋"
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
    [menu_lang]="Change language (تغيير اللغة)"
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
    [lang_prompt]="Select Language / اختر اللغة"
    [lang_set]="Language set to"
    [logs_empty]="No logs yet"
    [goodbye]="Goodbye 👋"
)

msg() {
    local key="$1"
    if [ "$LANG_CHOICE" = "ar" ]; then
        echo "${MSG_AR[$key]}"
    else
        echo "${MSG_EN[$key]}"
    fi
}

# === DIRECTORIES ===
BASE_DIR="$HOME/Hakeem-Stego"
STEGO_DIR="$BASE_DIR/stego-images"
REPORTS_DIR="$BASE_DIR/reports"
BACKUP_DIR="$BASE_DIR/backups"
LOGS_DIR="$BASE_DIR/logs"
LOG_FILE="$LOGS_DIR/hakeem.log"

mkdir -p "$STEGO_DIR" "$REPORTS_DIR" "$BACKUP_DIR" "$LOGS_DIR"

# === HELPERS ===
log_action() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

expand_path() {
    local p="$1"
    p="${p/#\~/$HOME}"
    p="${p/#\$HOME/$HOME}"
    echo "$p"
}

# === BANNER ===
show_banner() {
    clear
    echo -e "${RED}"
    echo "╔══════════════════════════════════════════════════════╗"
    echo "║                                                      ║"
    echo "║   ██╗  ██╗ █████╗ ██╗  ██╗███████╗███████╗███╗   ███╗║"
    echo "║   ██║  ██║██╔══██╗██║ ██╔╝██╔════╝██╔════╝████╗ ████║║"
    echo "║   ███████║███████║█████╔╝ █████╗  █████╗  ██╔████╔██║║"
    echo "║   ██╔══██║██╔══██║██╔═██╗ ██╔══╝  ██╔══╝  ██║╚██╔╝██║║"
    echo "║   ██║  ██║██║  ██║██║  ██╗███████╗███████╗██║ ╚═╝ ██║║"
    echo "║   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝╚═╝     ╚═╝║"
    echo "║                                                      ║"
    echo "║      🔥 IMAGE STEGANOGRAPHY & FORENSICS TOOL 🔥     ║"
    echo "║                                                      ║"
    echo "╚══════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "${CYAN}┌────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│   👑 $(msg developer)"
    echo -e "${CYAN}│   🌐 GITHUB: hakim738-html"
    echo -e "${CYAN}│   🎯 $(msg version): 6.1 - Professional Edition"
    echo -e "${CYAN}│   🌍 Lang: $LANG_CHOICE"
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
                pillow) pip install pillow >/dev/null 2>&1 ;;
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

    if [ ! -f "$img_path" ]; then
        echo -e "${RED}[✗] $(msg file_not_found): $img_path${NC}"
        return
    fi

    local backup="$BACKUP_DIR/$(basename "$img_path").bak"
    cp "$img_path" "$backup"
    echo -e "${GREEN}[✓] $(msg backup_created): $backup${NC}"

    read -r -p "$(msg prompt_text): " secret_text
    if [ -z "$secret_text" ]; then
        echo -e "${RED}[✗] Empty text / النص فارغ${NC}"
        return
    fi

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

    if [ ! -f "$img_path" ]; then
        echo -e "${RED}[✗] $(msg file_not_found)${NC}"
        return
    fi

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
        echo -e "${YELLOW}$result${NC}"
    fi
}

# === EXIF ANALYSIS ===
exif_menu() {
    echo -e "${CYAN}═══ $(msg menu_exif) ═══${NC}"
    read -r -p "$(msg prompt_image): " img_path
    img_path=$(expand_path "$img_path")

    if [ ! -f "$img_path" ]; then
        echo -e "${RED}[✗] $(msg file_not_found)${NC}"
        return
    fi

    echo -e "${YELLOW}[*] $(msg processing)...${NC}"
    echo ""
    if command -v exiftool &>/dev/null; then
        exiftool "$img_path"
    else
        file "$img_path"
    fi
    log_action "EXIF: $img_path"
}

# === FORENSIC ANALYSIS ===
forensic_menu() {
    echo -e "${CYAN}═══ $(msg menu_forensic) ═══${NC}"
    read -r -p "$(msg prompt_image): " img_path
    img_path=$(expand_path "$img_path")

    if [ ! -f "$img_path" ]; then
        echo -e "${RED}[✗] $(msg file_not_found)${NC}"
        return
    fi

    local report="$REPORTS_DIR/forensic_$(date +%Y%m%d_%H%M%S).txt"
    {
        echo "==========================================="
        echo "  HAKEEM FORENSIC REPORT / تقرير جنائي"
        echo "  Date: $(date)"
        echo "  File: $img_path"
        echo "==========================================="
        echo ""
        echo "=== FILE INFO ==="
        file "$img_path"
        ls -lh "$img_path"
        echo ""
        echo "=== HASHES ==="
        (md5sum "$img_path" 2>/dev/null || md5 "$img_path" 2>/dev/null)
        (sha1sum "$img_path" 2>/dev/null || shasum "$img_path" 2>/dev/null)
        (sha256sum "$img_path" 2>/dev/null || shasum -a 256 "$img_path" 2>/dev/null)
        echo ""
        echo "=== EXIF METADATA ==="
        exiftool "$img_path" 2>/dev/null || echo "exiftool not available"
        echo ""
        echo "=== STRINGS (first 100) ==="
        strings "$img_path" 2>/dev/null | head -100
        echo ""
        echo "=== HEXDUMP (first 32 lines) ==="
        if command -v xxd &>/dev/null; then
            xxd "$img_path" | head -32
        elif command -v hexdump &>/dev/null; then
            hexdump -C "$img_path" | head -32
        else
            echo "No hex tool available"
        fi
    } > "$report" 2>&1

    cat "$report"
    echo ""
    echo -e "${GREEN}[✓] $(msg report_saved): $report${NC}"
    log_action "FORENSIC: $img_path -> $report"
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
    echo "1) العربية"
    echo "2) English"
    read -r -p "> " choice
    case "$choice" in
        1) LANG_CHOICE="ar" ;;
        2) LANG_CHOICE="en" ;;
        *) echo -e "${RED}$(msg invalid_choice)${NC}"; return ;;
    esac
    echo "$LANG_CHOICE" > "$LANG_FILE"
    echo -e "${GREEN}[✓] $(msg lang_set): $LANG_CHOICE${NC}"
}

# === INITIAL LANGUAGE SELECTION ===
initial_language_select() {
    if [ ! -f "$LANG_FILE" ]; then
        clear
        echo -e "${CYAN}╔══════════════════════════════════╗${NC}"
        echo -e "${CYAN}║  Select Language / اختر اللغة   ║${NC}"
        echo -e "${CYAN}╚══════════════════════════════════╝${NC}"
        echo "1) العربية"
        echo "2) English"
        read -r -p "> " choice
        case "$choice" in
            1) LANG_CHOICE="ar" ;;
            2) LANG_CHOICE="en" ;;
            *) LANG_CHOICE="en" ;;
        esac
        echo "$LANG_CHOICE" > "$LANG_FILE"
    fi
}

# === MAIN MENU ===
main_menu() {
    while true; do
        show_banner
        echo -e "${CYAN}═══ $(msg menu_title) ═══${NC}"
        echo -e "${GREEN}[1]${NC} $(msg menu_hide)"
        echo -e "${GREEN}[2]${NC} $(msg menu_extract)"
        echo -e "${GREEN}[3]${NC} $(msg menu_exif)"
        echo -e "${GREEN}[4]${NC} $(msg menu_forensic)"
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

# === ENTRY POINT ===
initial_language_select
check_tools
create_python_helper
log_action "=== Session started (lang=$LANG_CHOICE) ==="
main_menu
