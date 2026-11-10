#!/bin/bash
# ═════════════════════════════════════════════════════════════════
# 🔥 H A K E E M   S T E G A N O G R A P H Y   T O O L
# 👑 DEVELOPER: Hakeem Al-Arab
# 🎯 VERSION: 8.1 - Ultimate Cyber Edition (Path-Fix Release)
# 🌐 GITHUB: hakim738-html
# ═════════════════════════════════════════════════════════════════

# ─── COLORS (BASH PROPER ESCAPE) ───
RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[1;33m'
BLUE=$'\033[0;34m'
MAGENTA=$'\033[0;35m'
CYAN=$'\033[0;36m'
WHITE=$'\033[1;37m'
BOLD=$'\033[1m'
DIM=$'\033[2m'
NC=$'\033[0m'

# ─── DIRECTORIES ───
BASE_DIR="$HOME/Hakeem-Stego"
STEGO_DIR="$BASE_DIR/stego-images"
REPORTS_DIR="$BASE_DIR/reports"
BACKUP_DIR="$BASE_DIR/backups"
LOGS_DIR="$BASE_DIR/logs"
LANG_FILE="$HOME/.hakeem_lang"
LOG_FILE="$LOGS_DIR/hakeem.log"

mkdir -p "$STEGO_DIR" "$REPORTS_DIR" "$BACKUP_DIR" "$LOGS_DIR"

# ─── LANGUAGE ───
LANG_CHOICE="ar"
[ -f "$LANG_FILE" ] && LANG_CHOICE=$(tr -d '[:space:]' < "$LANG_FILE" 2>/dev/null)
[ "$LANG_CHOICE" = "en" ] || LANG_CHOICE="ar"

ARABIC_SUPPORT=0
declare -A AR_CACHE

ensure_arabic_support() {
    [ "$LANG_CHOICE" = "ar" ] || return
    if python3 -c "import arabic_reshaper; from bidi.algorithm import get_display" 2>/dev/null; then
        ARABIC_SUPPORT=1
    else
        pip install --quiet arabic-reshaper python-bidi --break-system-packages 2>/dev/null || \
        pip install --quiet arabic-reshaper python-bidi 2>/dev/null || true
        python3 -c "import arabic_reshaper; from bidi.algorithm import get_display" 2>/dev/null && ARABIC_SUPPORT=1
    fi
}

shape_ar() {
    local text="$1"
    [ -z "$text" ] && return
    [ "$ARABIC_SUPPORT" -eq 0 ] && { printf '%s' "$text"; return; }
    [ -n "${AR_CACHE[$text]+x}" ] && { printf '%s' "${AR_CACHE[$text]}"; return; }
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

# ─── MESSAGES ───
declare -A MSG_AR MSG_EN
MSG_AR=(
    [dev]="👑 المطور: حكيم العرب"
    [menu_title]="القائمة الرئيسية"
    [hide]="إخفاء نص في صورة"
    [extract]="استخراج نص مخفي من صورة"
    [exif]="تحليل بيانات الصورة (EXIF + تقرير HTML)"
    [forensic]="تحليل جنائي شامل + تقرير"
    [devinfo]="نافذة المطور - حكيم العرب"
    [logs]="عرض السجلات"
    [lang]="تغيير اللغة (Change Language)"
    [exit]="خروج"
    [prompt_choice]="اختر رقم العملية"
    [prompt_image]="أدخل مسار الصورة (يدعم أي لغة)"
    [prompt_text]="أدخل النص المراد إخفاؤه"
    [prompt_output]="أدخل اسم الصورة الناتجة"
    [invalid]="اختيار غير صالح"
    [not_found]="❌ الملف غير موجود! تأكد من المسار"
    [tried]="تم البحث في"
    [processing]="جاري المعالجة"
    [ok_hide]="✅ تم إخفاء النص بنجاح"
    [ok_extract]="✅ تم استخراج النص بنجاح"
    [press_enter]="اضغط Enter للمتابعة..."
    [backup]="✅ تم إنشاء نسخة احتياطية"
    [no_hidden]="❌ لا يوجد نص مخفي أو الصورة غير صالحة"
    [capacity]="❌ حجم الصورة غير كافٍ"
    [lang_prompt]="اختر اللغة"
    [lang_set]="✅ تم تعيين اللغة"
    [logs_empty]="📭 لا توجد سجلات بعد"
    [goodbye]="👋 إلى اللقاء"
    [empty_text]="❌ النص فارغ"
    [empty_path]="❌ لم تُدخل مساراً"
    [report_gen]="⏳ جاري إنشاء تقرير HTML"
    [report_created]="✅ تم إنشاء التقرير في مجلد التنزيلات"
    [report_loc]="📍 موقع التقرير"
    [analysis_done]="✅ اكتمل التحليل"
    [forensic_done]="✅ اكتمل التحليل الجنائي"
    [found]="✅ تم إيجاد الملف"
    [gps_found]="🗺️ تم العثور على موقع GPS"
    [no_gps]="📍 لا يوجد بيانات موقع"
)
MSG_EN=(
    [dev]="👑 Developer: Hakeem Al-Arab"
    [menu_title]="Main Menu"
    [hide]="Hide text in image"
    [extract]="Extract hidden text"
    [exif]="Analyze EXIF + HTML report"
    [forensic]="Full forensic analysis"
    [devinfo]="Developer Window - Hakeem Al-Arab"
    [logs]="View logs"
    [lang]="Change Language"
    [exit]="Exit"
    [prompt_choice]="Choose operation number"
    [prompt_image]="Enter image path (any language)"
    [prompt_text]="Enter text to hide"
    [prompt_output]="Enter output image name"
    [invalid]="Invalid choice"
    [not_found]="❌ File not found"
    [tried]="Searched at"
    [processing]="Processing"
    [ok_hide]="✅ Text hidden successfully"
    [ok_extract]="✅ Text extracted successfully"
    [press_enter]="Press Enter to continue..."
    [backup]="✅ Backup created"
    [no_hidden]="❌ No hidden text found"
    [capacity]="❌ Image too small"
    [lang_prompt]="Select Language"
    [lang_set]="✅ Language set"
    [logs_empty]="📭 No logs yet"
    [goodbye]="👋 Goodbye"
    [empty_text]="❌ Text is empty"
    [empty_path]="❌ No path provided"
    [report_gen]="⏳ Generating HTML report"
    [report_created]="✅ Report saved to Downloads"
    [report_loc]="📍 Report location"
    [analysis_done]="✅ Analysis complete"
    [forensic_done]="✅ Forensic analysis complete"
    [found]="✅ File found"
    [gps_found]="🗺️ GPS location found"
    [no_gps]="📍 No GPS data"
)

msg() {
    local k="$1"
    if [ "$LANG_CHOICE" = "ar" ]; then
        shape_ar "${MSG_AR[$k]:-[$k]}"
    else
        printf '%s' "${MSG_EN[$k]:-[$k]}"
    fi
}

# ─── HELPERS ───
log_action() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"; }

spinner() {
    local pid=$1 label="$2"
    local frames=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
    while kill -0 "$pid" 2>/dev/null; do
        for f in "${frames[@]}"; do
            printf "\r${CYAN}%s${NC} %s... " "$f" "$label"
            sleep 0.08
        done
    done
    printf "\r%-60s\r" ""
}

typewriter() {
    local text="$1" delay="${2:-0.02}"
    local i
    for ((i=0; i<${#text}; i++)); do
        printf '%s' "${text:$i:1}"
        sleep "$delay"
    done
    echo
}

get_download_dir() {
    if [ -d "$HOME/storage/downloads" ]; then echo "$HOME/storage/downloads"
    elif [ -d "/sdcard/Download" ]; then echo "/sdcard/Download"
    elif [ -d "/sdcard/Downloads" ]; then echo "/sdcard/Downloads"
    elif [ -d "$HOME/Downloads" ]; then echo "$HOME/Downloads"
    else mkdir -p "$HOME/Downloads"; echo "$HOME/Downloads"; fi
}

# ─── PYTHON HELPERS ───
create_python_helpers() {

# ═══════════════════════════════════════════════════════════════════
# PATH RESOLVER v8.1 — يحاول المسار الأصلي أولاً (قبل تحويل الأرقام)
# ═══════════════════════════════════════════════════════════════════
cat > "$BASE_DIR/path_resolver.py" <<'PYEOF'
#!/usr/bin/env python3
import sys, os, unicodedata

AR2EN = str.maketrans('٠١٢٣٤٥٦٧٨٩', '0123456789')
EN2AR = str.maketrans('0123456789', '٠١٢٣٤٥٦٧٨٩')
FA2EN = str.maketrans('۰۱۲۳۴۵۶۷۸۹', '0123456789')

def clean_str(s):
    s = ''.join(c for c in s if unicodedata.category(c) != 'Cf')
    s = s.strip().strip("'\"").strip()
    return os.path.expanduser(s)

def nfc(s):
    return unicodedata.normalize('NFC', s)

def try_isfile(p):
    if os.path.isfile(p):
        return p
    for form in ('NFC', 'NFD'):
        alt = unicodedata.normalize(form, p)
        if os.path.isfile(alt):
            return alt
    return None

def resolve(raw):
    if not raw:
        return ""
    clean = clean_str(raw)
    if not clean:
        return ""

    # 1) جرّب المسار الأصلي حرفياً أولاً
    hit = try_isfile(clean)
    if hit: return hit

    # 2) جرّب كل تركيبة تحويل أرقام
    candidates = []
    for conv in (AR2EN, EN2AR, FA2EN):
        c = clean.translate(conv)
        if c != clean:
            candidates.append(c)
    for cand in candidates:
        hit = try_isfile(cand)
        if hit: return hit

    # 3) بحث ضمني داخل مجلد الملف نفسه
    base = os.path.basename(clean)
    dir_part = os.path.dirname(clean)
    basenames = {base, base.translate(AR2EN), base.translate(EN2AR), base.translate(FA2EN)}
    basenames_nfc = {nfc(b) for b in basenames}

    if dir_part and os.path.isdir(dir_part):
        try:
            for entry in os.listdir(dir_part):
                if entry in basenames or nfc(entry) in basenames_nfc:
                    return os.path.join(dir_part, entry)
        except Exception:
            pass

    # 4) بحث في مجلدات معروفة
    search_dirs = [
        dir_part,
        '/storage/emulated/0/DCIM/Camera',
        '/storage/emulated/0/DCIM',
        '/storage/emulated/0/Pictures',
        '/storage/emulated/0/Pictures/Screenshots',
        '/storage/emulated/0/Download',
        '/storage/emulated/0/Downloads',
        '/storage/emulated/0/WhatsApp/Media/WhatsApp Images',
        '/sdcard/DCIM/Camera',
        '/sdcard/DCIM',
        '/sdcard/Pictures',
        '/sdcard/Download',
        '/sdcard/Downloads',
        os.path.expanduser('~/storage/dcim/Camera'),
        os.path.expanduser('~/storage/dcim'),
        os.path.expanduser('~/storage/pictures'),
        os.path.expanduser('~/storage/downloads'),
        os.path.expanduser('~/Downloads'),
        os.path.expanduser('~/Pictures'),
        os.path.expanduser('~/Desktop'),
        os.path.expanduser('~'),
    ]
    for d in search_dirs:
        if not d or not os.path.isdir(d):
            continue
        try:
            for entry in os.listdir(d):
                if entry in basenames or nfc(entry) in basenames_nfc:
                    full = os.path.join(d, entry)
                    if os.path.isfile(full):
                        return full
        except Exception:
            continue

    # 5) بحث متداخل داخل DCIM (عمق 2)
    deep_roots = ['/storage/emulated/0/DCIM', '/sdcard/DCIM',
                  os.path.expanduser('~/storage/dcim')]
    for root in deep_roots:
        if not os.path.isdir(root): continue
        try:
            for dirpath, dirnames, filenames in os.walk(root):
                depth = dirpath[len(root):].count(os.sep)
                if depth > 2:
                    dirnames[:] = []
                    continue
                for entry in filenames:
                    if entry in basenames or nfc(entry) in basenames_nfc:
                        return os.path.join(dirpath, entry)
        except Exception:
            continue

    return clean

if __name__ == '__main__':
    print(resolve(sys.argv[1] if len(sys.argv) > 1 else ''))
PYEOF

# ═══════════════════════════════════════════════════════════════════
# IMAGE ANALYZER — تحليل بكسلات وألوان عميق
# ═══════════════════════════════════════════════════════════════════
cat > "$BASE_DIR/image_analyzer.py" <<'PYEOF'
#!/usr/bin/env python3
import sys, os, json
from PIL import Image, ImageStat, ImageFilter

def analyze(path):
    out = {}
    try:
        img = Image.open(path)
        out['width']  = img.width
        out['height'] = img.height
        out['mode']   = img.mode
        out['format'] = img.format or 'UNKNOWN'
        out['file_size'] = os.path.getsize(path)
        out['megapixels'] = round(img.width * img.height / 1_000_000, 2)
        out['total_pixels'] = img.width * img.height

        from math import gcd
        g = gcd(img.width, img.height)
        out['aspect_ratio'] = f"{img.width//g}:{img.height//g}"

        dpi = img.info.get('dpi')
        out['dpi'] = f"{dpi[0]}x{dpi[1]}" if dpi else 'N/A'

        try:
            rgb = img.convert('RGB')
            small = rgb.resize((64, 64))
            colors = small.getcolors(64*64) or []
            colors.sort(reverse=True)
            palette = []
            for count, c in colors[:10]:
                pct = round(count / (64*64) * 100, 2)
                palette.append({
                    'hex': f"#{c[0]:02x}{c[1]:02x}{c[2]:02x}",
                    'rgb': f"{c[0]},{c[1]},{c[2]}",
                    'pct': pct
                })
            out['palette'] = palette

            stat = ImageStat.Stat(rgb)
            out['avg_rgb'] = ','.join(str(round(x)) for x in stat.mean)
            brightness = sum(stat.mean) / 3
            out['brightness'] = round(brightness, 2)
            out['brightness_level'] = (
                'Dark' if brightness < 85 else
                'Normal' if brightness < 170 else 'Bright'
            )
            contrast = sum(stat.stddev) / 3
            out['contrast'] = round(contrast, 2)
            out['contrast_level'] = (
                'Low' if contrast < 30 else
                'Normal' if contrast < 60 else 'High'
            )

            try:
                edges = rgb.filter(ImageFilter.FIND_EDGES)
                est = ImageStat.Stat(edges)
                sharp = sum(est.mean) / 3
                out['sharpness'] = round(sharp, 2)
                out['sharpness_level'] = (
                    'Blurry' if sharp < 10 else
                    'Normal' if sharp < 25 else 'Sharp'
                )
            except Exception:
                pass

            try:
                preview = rgb.convert('L').resize((50, 25))
                chars = ' .:-=+*#%@'
                ascii_art = []
                for y in range(preview.height):
                    line = ''
                    for x in range(preview.width):
                        p = preview.getpixel((x, y))
                        line += chars[min(p * len(chars) // 256, len(chars)-1)]
                    ascii_art.append(line)
                out['ascii_art'] = ascii_art
            except Exception:
                pass

        except Exception as e:
            out['analysis_error'] = str(e)

        try:
            exif = img.getexif()
            if exif:
                out['exif_entries'] = len(exif)
        except Exception:
            pass

    except Exception as e:
        out['error'] = str(e)

    print(json.dumps(out, ensure_ascii=False))

if __name__ == '__main__':
    analyze(sys.argv[1])
PYEOF

# ═══════════════════════════════════════════════════════════════════
# STEGO HELPER — إخفاء/استخراج LSB
# ═══════════════════════════════════════════════════════════════════
cat > "$BASE_DIR/stego_helper.py" <<'PYEOF'
#!/usr/bin/env python3
import sys
from PIL import Image

def hide_text(image_path, text, output_path):
    img = Image.open(image_path).convert("RGB")
    data = len(text.encode('utf-8')).to_bytes(4, 'big') + text.encode('utf-8')
    bits = ''.join(format(b, '08b') for b in data)
    if len(bits) > img.width * img.height * 3: sys.exit(2)
    pixels = list(img.getdata())
    new_pixels, i = [], 0
    for r, g, b in pixels:
        if i < len(bits): r = (r & ~1) | int(bits[i]); i += 1
        if i < len(bits): g = (g & ~1) | int(bits[i]); i += 1
        if i < len(bits): b = (b & ~1) | int(bits[i]); i += 1
        new_pixels.append((r, g, b))
    out = Image.new("RGB", img.size); out.putdata(new_pixels)
    out.save(output_path, format="PNG")

def extract_text(image_path):
    img = Image.open(image_path).convert("RGB")
    bits = []
    for p in img.getdata():
        for c in p: bits.append(c & 1)
    if len(bits) < 32: sys.exit(3)
    length = 0
    for i in range(32): length = (length << 1) | bits[i]
    if length <= 0 or length * 8 + 32 > len(bits): sys.exit(4)
    data = bytearray()
    for i in range(length):
        byte = 0
        for j in range(8): byte = (byte << 1) | bits[32 + i*8 + j]
        data.append(byte)
    try: print(data.decode('utf-8'))
    except: sys.exit(5)

if __name__ == "__main__":
    if len(sys.argv) == 5 and sys.argv[1] == "hide":
        hide_text(sys.argv[2], sys.argv[3], sys.argv[4])
    elif len(sys.argv) == 3 and sys.argv[1] == "extract":
        extract_text(sys.argv[2])
    else: sys.exit(1)
PYEOF

    chmod +x "$BASE_DIR"/*.py
}

# ─── DEPENDENCIES ───
check_tools() {
    local need=()
    command -v python3 &>/dev/null || need+=("python3")
    command -v exiftool &>/dev/null || need+=("exiftool")
    python3 -c "import PIL" 2>/dev/null || need+=("pillow")

    if [ ${#need[@]} -gt 0 ]; then
        echo -e "${YELLOW}⚠️  تثبيت الحزم المطلوبة...${NC}"
        if command -v pkg &>/dev/null; then
            for p in "${need[@]}"; do
                case "$p" in
                    python3) pkg install -y python ;;
                    exiftool) pkg install -y exiftool 2>/dev/null || pkg install -y libimage-exiftool-perl 2>/dev/null ;;
                    pillow) pip install --quiet pillow --break-system-packages 2>/dev/null || pip install --quiet pillow 2>/dev/null ;;
                esac
            done
        elif command -v apt &>/dev/null; then
            sudo apt update -y >/dev/null 2>&1
            sudo apt install -y python3 python3-pip libimage-exiftool-perl 2>/dev/null
            pip3 install --quiet pillow 2>/dev/null || true
        fi
    fi
}

# ─── BANNER ───
show_banner() {
    clear
    echo -e "${GREEN}${BOLD}"
    cat <<'EOF'
    ╔═══════════════════════════════════════════════════════════════════╗
    ║   ██╗  ██╗ █████╗ ██╗  ██╗███████╗███████╗███╗   ███╗             ║
    ║   ██║  ██║██╔══██╗██║ ██╔╝██╔════╝██╔════╝████╗ ████║             ║
    ║   ███████║███████║█████╔╝ █████╗  █████╗  ██╔████╔██║             ║
    ║   ██╔══██║██╔══██║██╔═██╗ ██╔══╝  ██╔══╝  ██║╚██╔╝██║             ║
    ║   ██║  ██║██║  ██║██║  ██╗███████╗███████╗██║ ╚═╝ ██║             ║
    ║   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝╚═╝     ╚═╝             ║
    ║                                                                   ║
    ║   👑 Hakeem Al-Arab  |  🎯 v8.1 Ultimate Cyber Edition           ║
    ║   🔥 Steganography · EXIF · Forensics · HTML Dashboard            ║
    ╠═══════════════════════════════════════════════════════════════════╣
EOF
    echo -e "${NC}"
}

# ─── PYTHON ANALYZE → BASH VARS ───
declare -A IMG_INFO
analyze_image() {
    local path="$1"
    IMG_INFO=()
    local json
    json=$(python3 "$BASE_DIR/image_analyzer.py" "$path" 2>/dev/null)
    while IFS=$'\t' read -r k v; do
        [ -n "$k" ] && IMG_INFO["$k"]="$v"
    done < <(python3 -c "
import json, sys
try:
    d = json.loads(sys.argv[1])
    for k, v in d.items():
        if isinstance(v, (list, dict)): continue
        print(f'{k}\t{v}')
except Exception: pass
" "$json" 2>/dev/null)
    echo "$json" | python3 -c "
import json, sys
try:
    d = json.loads(sys.stdin.read())
    if 'palette' in d:
        for c in d['palette']:
            print(f\"PALETTE\t{c['hex']}\t{c['rgb']}\t{c['pct']}\")
    if 'ascii_art' in d:
        for line in d['ascii_art']:
            print(f\"ASCII\t{line}\")
except Exception: pass
" > "$BASE_DIR/.img_extra.txt" 2>/dev/null
}

# ─── HIDE ───
hide_text_menu() {
    echo -e "${CYAN}${BOLD}═══ $(msg hide) ═══${NC}"
    read -r -p "$(msg prompt_image): " raw
    [ -z "$raw" ] && { echo -e "${RED}[✗] $(msg empty_path)${NC}"; return; }
    local path
    path=$(python3 "$BASE_DIR/path_resolver.py" "$raw")
    if [ ! -f "$path" ]; then
        echo -e "${RED}[✗] $(msg not_found)${NC}"
        echo -e "${DIM}   $(msg tried): $path${NC}"
        return
    fi
    echo -e "${GREEN}[✓] $(msg found): $path${NC}"

    cp "$path" "$BACKUP_DIR/$(basename "$path").$(date +%s).bak" 2>/dev/null
    echo -e "${GREEN}[✓] $(msg backup)${NC}"

    read -r -p "$(msg prompt_text): " txt
    [ -z "$txt" ] && { echo -e "${RED}[✗] $(msg empty_text)${NC}"; return; }

    read -r -p "$(msg prompt_output) [hidden]: " out_name
    out_name="${out_name:-hidden}"
    local out="$STEGO_DIR/${out_name}.png"

    (python3 "$BASE_DIR/stego_helper.py" hide "$path" "$txt" "$out" >/dev/null 2>&1) &
    spinner $! "$(msg processing)"
    if [ -f "$out" ]; then
        echo -e "${GREEN}[✓] $(msg ok_hide)${NC}"
        echo -e "${CYAN}📁 $out${NC}"
        log_action "HIDE: $path -> $out"
    else
        echo -e "${RED}[✗] $(msg capacity)${NC}"
    fi
}

# ─── EXTRACT ───
extract_text_menu() {
    echo -e "${CYAN}${BOLD}═══ $(msg extract) ═══${NC}"
    read -r -p "$(msg prompt_image): " raw
    local path
    path=$(python3 "$BASE_DIR/path_resolver.py" "$raw")
    if [ ! -f "$path" ]; then
        echo -e "${RED}[✗] $(msg not_found)${NC}"
        echo -e "${DIM}   $(msg tried): $path${NC}"
        return
    fi

    local result
    (result=$(python3 "$BASE_DIR/stego_helper.py" extract "$path" 2>&1); echo "$result" > "$BASE_DIR/.extract_result") &
    spinner $! "$(msg processing)"
    result=$(cat "$BASE_DIR/.extract_result" 2>/dev/null)
    if [ -n "$result" ]; then
        echo -e "${GREEN}[✓] $(msg ok_extract)${NC}"
        echo -e "${WHITE}──────────────────────────────────${NC}"
        echo "$result"
        echo -e "${WHITE}──────────────────────────────────${NC}"
        log_action "EXTRACT: $path"
    else
        echo -e "${RED}[✗] $(msg no_hidden)${NC}"
    fi
    rm -f "$BASE_DIR/.extract_result"
}

# ═══════════════════════════════════════════════════════════════════
# ─── HTML REPORT GENERATOR (Cyber Dashboard with Animations) ───
# ═══════════════════════════════════════════════════════════════════
create_html_report() {
    local img_path="$1"
    echo -e "${YELLOW}[*] $(msg report_gen)...${NC}"

    local out_html
    out_html="$(get_download_dir)/hakeem_report_$(date +%Y%m%d_%H%M%S).html"

    # ── Extract metadata ──
    local exif_raw make model software date_time resolution iso aperture focal flash
    exif_raw=$(exiftool "$img_path" 2>/dev/null)
    make=$(echo "$exif_raw" | awk -F': ' '/^Make /{print $2; exit}')
    model=$(echo "$exif_raw" | awk -F': ' '/^Camera Model Name /{print $2; exit}')
    software=$(echo "$exif_raw" | awk -F': ' '/^Software /{print $2; exit}')
    date_time=$(echo "$exif_raw" | awk -F': ' '/^Date\/Time Original /{print $2; exit}')
    resolution=$(echo "$exif_raw" | awk -F': ' '/^Image Size /{print $2; exit}')
    iso=$(echo "$exif_raw" | awk -F': ' '/^ISO /{print $2; exit}')
    aperture=$(echo "$exif_raw" | awk -F': ' '/^Aperture /{print $2; exit}')
    focal=$(echo "$exif_raw" | awk -F': ' '/^Focal Length /{print $2; exit}')
    flash=$(echo "$exif_raw" | awk -F': ' '/^Flash /{print $2; exit}')

    # GPS numeric
    local lat lng alt gps_raw
    lat=$(exiftool -n -s3 -GPSLatitude "$img_path" 2>/dev/null)
    lng=$(exiftool -n -s3 -GPSLongitude "$img_path" 2>/dev/null)
    alt=$(exiftool -n -s3 -GPSAltitude "$img_path" 2>/dev/null)
    gps_raw=$(exiftool -s3 -GPSPosition "$img_path" 2>/dev/null)

    # Hashes
    local md5 sha
    md5=$(md5sum "$img_path" 2>/dev/null | cut -d' ' -f1)
    [ -z "$md5" ] && md5=$(python3 -c "
import hashlib,sys
print(hashlib.md5(open(sys.argv[1],'rb').read()).hexdigest())" "$img_path" 2>/dev/null)
    sha=$(sha256sum "$img_path" 2>/dev/null | cut -d' ' -f1)
    [ -z "$sha" ] && sha=$(python3 -c "
import hashlib,sys
print(hashlib.sha256(open(sys.argv[1],'rb').read()).hexdigest())" "$img_path" 2>/dev/null)

    # Deep image analysis
    analyze_image "$img_path"
    local width="${IMG_INFO[width]:-?}" height="${IMG_INFO[height]:-?}"
    local mode="${IMG_INFO[mode]:-?}" fmt="${IMG_INFO[format]:-?}"
    local mp="${IMG_INFO[megapixels]:-0}" total_px="${IMG_INFO[total_pixels]:-0}"
    local aspect="${IMG_INFO[aspect_ratio]:-?}"
    local dpi="${IMG_INFO[dpi]:-N/A}"
    local brightness="${IMG_INFO[brightness]:-0}"
    local bright_lvl="${IMG_INFO[brightness_level]:-?}"
    local contrast="${IMG_INFO[contrast]:-0}"
    local contrast_lvl="${IMG_INFO[contrast_level]:-?}"
    local sharpness="${IMG_INFO[sharpness]:-0}"
    local sharp_lvl="${IMG_INFO[sharpness_level]:-?}"
    local avg_rgb="${IMG_INFO[avg_rgb]:-?}"
    local file_size="${IMG_INFO[file_size]:-0}"

    local size_h bright_pct contrast_pct
    size_h=$(python3 -c "
s=int(sys.argv[1])
for u in ['B','KB','MB','GB']:
    if s < 1024: print(f'{s:.1f} {u}'); break
    s/=1024" "$file_size" 2>/dev/null)
    bright_pct=$(python3 -c "print(min(100,int(float('${brightness}')/255*100)))" 2>/dev/null || echo 0)
    contrast_pct=$(python3 -c "print(min(100,int(float('${contrast}')/128*100)))" 2>/dev/null || echo 0)

    # ── Palette swatches ──
    local palette_html=""
    while IFS=$'\t' read -r tag hex rgb pct; do
        [ "$tag" != "PALETTE" ] && continue
        palette_html+="<div class='swatch'><div class='swatch-color' style='background:$hex'></div><div class='swatch-info'><div class='swatch-hex'>$hex</div><div class='swatch-meta'>$pct% · rgb($rgb)</div></div></div>"
    done < "$BASE_DIR/.img_extra.txt"

    # ── ASCII preview ──
    local ascii_html=""
    while IFS=$'\t' read -r tag line; do
        [ "$tag" != "ASCII" ] && continue
        ascii_html+="$line
"
    done < "$BASE_DIR/.img_extra.txt"

    # ── GPS block ──
    local gps_block maps_url iframe_url
    if [ -n "$lat" ] && [ -n "$lng" ] && [ "$lat" != "0" ]; then
        maps_url="https://www.google.com/maps?q=${lat},${lng}"
        iframe_url="https://maps.google.com/maps?q=${lat},${lng}&z=15&output=embed"
        gps_block="
        <div class='card gps-card'>
            <h2>🗺️ موقع التقاط الصورة</h2>
            <div class='gps-grid'>
                <div class='gps-info'>
                    <div class='gps-row'><span>الإحداثيات الأصلية</span><strong>${gps_raw:-$lat, $lng}</strong></div>
                    <div class='gps-row'><span>خط العرض (Lat)</span><strong>$lat</strong></div>
                    <div class='gps-row'><span>خط الطول (Lng)</span><strong>$lng</strong></div>
                    <div class='gps-row'><span>الارتفاع</span><strong>${alt:-غير متوفر} m</strong></div>
                    <a href='$maps_url' target='_blank' rel='noopener' class='btn-maps'>📍 فتح في خرائط جوجل</a>
                </div>
                <div class='map-embed'>
                    <iframe src='$iframe_url' loading='lazy' referrerpolicy='no-referrer-when-downgrade'></iframe>
                </div>
            </div>
        </div>"
        echo -e "${GREEN}[✓] $(msg gps_found): $lat, $lng${NC}"
    else
        gps_block="
        <div class='card gps-card no-gps'>
            <h2>❌ لا يوجد بيانات موقع GPS</h2>
            <p>الصورة لا تحتوي على بيانات GPS أو تم حذفها.</p>
        </div>"
        echo -e "${YELLOW}[!] $(msg no_gps)${NC}"
    fi

    # ── Build HTML ──
    cat > "$out_html" <<HTMLEOF
<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>🔥 Hakeem Cyber Report — $model</title>
<style>
:root{
  --bg1:#0a0e27; --bg2:#1a0033; --bg3:#001a33; --bg4:#0d1117;
  --card:rgba(22,27,34,0.6); --border:rgba(48,54,61,0.8);
  --text:#c9d1d9; --muted:#8b949e;
  --green:#3fb950; --red:#f85149; --blue:#58a6ff; --purple:#bc8cff;
  --yellow:#f0b429; --cyan:#39d2c0;
}
*{box-sizing:border-box;margin:0;padding:0}
@keyframes gradBG{0%{background-position:0% 50%}50%{background-position:100% 50%}100%{background-position:0% 50%}}
@keyframes fadeUp{from{opacity:0;transform:translateY(30px)}to{opacity:1;transform:translateY(0)}}
@keyframes glow{0%,100%{box-shadow:0 0 15px rgba(88,166,255,.4)}50%{box-shadow:0 0 35px rgba(88,166,255,.8)}}
@keyframes float{0%,100%{transform:translateY(0)}50%{transform:translateY(-8px)}}
@keyframes pulse{0%,100%{opacity:1}50%{opacity:.6}}
@keyframes scan{from{transform:translateY(-100%)}to{transform:translateY(100vh)}}
@keyframes spin{to{transform:rotate(360deg)}}
@keyframes shine{0%{background-position:-200% 0}100%{background-position:200% 0}}
body{
  font-family:'Segoe UI',Tahoma,'Noto Naskh Arabic',sans-serif;
  color:var(--text);line-height:1.7;min-height:100vh;padding:20px;
  background:linear-gradient(-45deg,var(--bg1),var(--bg2),var(--bg3),var(--bg4));
  background-size:400% 400%;animation:gradBG 18s ease infinite;
}
body::before{
  content:'';position:fixed;inset:0;pointer-events:none;z-index:1;
  background:repeating-linear-gradient(0deg,rgba(0,255,200,.03) 0 1px,transparent 1px 4px);
  animation:scan 8s linear infinite;
}
.container{max-width:1100px;margin:0 auto;position:relative;z-index:2}

/* HEADER */
header{
  text-align:center;padding:40px 20px;margin-bottom:30px;position:relative;
  background:rgba(13,17,23,.5);backdrop-filter:blur(20px);-webkit-backdrop-filter:blur(20px);
  border:1px solid var(--border);border-radius:20px;
  animation:fadeUp .8s ease,glow 4s ease-in-out infinite;
}
header h1{
  font-size:2.3em;margin-bottom:10px;
  background:linear-gradient(90deg,var(--blue),var(--purple),var(--cyan),var(--blue));
  background-size:200% auto;-webkit-background-clip:text;background-clip:text;
  -webkit-text-fill-color:transparent;color:transparent;
  animation:shine 4s linear infinite;
}
header .crown{font-size:2.5em;animation:float 3s ease-in-out infinite;display:inline-block}
header p{color:var(--muted);margin-top:8px}

/* CARDS */
.card{
  background:var(--card);backdrop-filter:blur(16px);-webkit-backdrop-filter:blur(16px);
  border:1px solid var(--border);border-radius:16px;padding:25px;margin-bottom:20px;
  box-shadow:0 8px 32px rgba(0,0,0,.4);
  animation:fadeUp .6s ease backwards;transition:transform .3s,border-color .3s;
}
.card:hover{transform:translateY(-3px);border-color:var(--blue)}
.card h2{color:var(--blue);margin-bottom:18px;padding-bottom:12px;
  border-bottom:1px solid var(--border);font-size:1.3em}
.card h3{color:var(--purple);margin-bottom:12px;font-size:1.1em}
.card:nth-child(2){animation-delay:.1s}
.card:nth-child(3){animation-delay:.2s}
.card:nth-child(4){animation-delay:.3s}
.card:nth-child(5){animation-delay:.4s}
.card:nth-child(6){animation-delay:.5s}

/* GRID */
.grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:18px;margin-bottom:20px}
.grid-3{grid-template-columns:repeat(auto-fit,minmax(200px,1fr))}

/* DATA ROWS */
.data-row{display:flex;justify-content:space-between;padding:10px 0;
  border-bottom:1px dashed rgba(48,54,61,.4);font-size:.95em}
.data-row:last-child{border:0}
.data-label{color:var(--muted)}
.data-value{font-weight:600;color:#fff;word-break:break-word;max-width:60%;text-align:left}

/* GPS */
.gps-card{background:linear-gradient(135deg,rgba(35,134,54,.15),rgba(88,166,255,.1));
  border:1px solid rgba(63,185,80,.5)}
.gps-card.no-gps{background:rgba(248,81,73,.1);border-color:rgba(248,81,73,.4)}
.gps-grid{display:grid;grid-template-columns:1fr 1fr;gap:20px}
@media(max-width:700px){.gps-grid{grid-template-columns:1fr}}
.gps-row{display:flex;justify-content:space-between;padding:8px 0;border-bottom:1px solid rgba(48,54,61,.3)}
.btn-maps{
  display:inline-block;margin-top:15px;padding:12px 24px;border-radius:10px;font-weight:bold;
  background:linear-gradient(135deg,#238636,#2ea043);color:#fff;text-decoration:none;
  transition:all .3s;box-shadow:0 4px 15px rgba(35,134,54,.4);
}
.btn-maps:hover{transform:scale(1.05);box-shadow:0 0 25px rgba(63,185,80,.8)}
.map-embed iframe{width:100%;height:280px;border:0;border-radius:12px;
  box-shadow:0 4px 20px rgba(0,0,0,.5);filter:invert(0) contrast(1)}

/* PALETTE */
.palette{display:grid;grid-template-columns:repeat(auto-fill,minmax(140px,1fr));gap:12px}
.swatch{background:rgba(0,0,0,.3);border-radius:10px;overflow:hidden;
  border:1px solid var(--border);transition:.3s}
.swatch:hover{transform:scale(1.05);border-color:var(--blue)}
.swatch-color{height:60px;width:100%}
.swatch-info{padding:8px;font-size:.75em;text-align:center}
.swatch-hex{font-family:monospace;font-weight:bold;color:#fff}
.swatch-meta{color:var(--muted);font-size:.85em}

/* PROGRESS BAR */
.progress{background:rgba(0,0,0,.4);border-radius:20px;overflow:hidden;height:10px;margin:6px 0}
.progress-fill{height:100%;background:linear-gradient(90deg,var(--blue),var(--purple));
  border-radius:20px;transition:width 1s ease;animation:pulse 2s infinite}

/* ASCII */
.ascii-box{
  background:#000;color:#7ee787;padding:18px;border-radius:10px;
  overflow-x:auto;font-family:'Courier New',monospace;font-size:6px;line-height:1.1;
  white-space:pre;border:1px solid #238636;box-shadow:inset 0 0 30px rgba(35,134,54,.2);
}

/* HASH */
.hash{font-family:'Courier New',monospace;background:rgba(0,0,0,.5);padding:12px;
  border-radius:8px;color:#7ee787;word-break:break-all;font-size:.8em;
  border:1px solid var(--border);margin-bottom:10px;transition:.3s}
.hash:hover{border-color:var(--green);box-shadow:0 0 15px rgba(63,185,80,.4)}

/* DETAILS */
details{background:var(--card);backdrop-filter:blur(16px);border:1px solid var(--border);
  border-radius:16px;padding:18px;margin-bottom:20px}
summary{cursor:pointer;color:var(--blue);font-weight:bold;font-size:1.05em;
  padding:6px;outline:none;transition:.3s}
summary:hover{color:var(--cyan)}
pre{background:#000;color:#7ee787;padding:18px;border-radius:10px;overflow-x:auto;
  direction:ltr;text-align:left;font-size:.8em;margin-top:15px;
  border:1px solid var(--border);white-space:pre-wrap;word-break:break-all}

/* FOOTER */
footer{text-align:center;padding:35px 20px;margin-top:30px;
  background:rgba(13,17,23,.5);backdrop-filter:blur(20px);
  border:1px solid var(--border);border-radius:20px;
  animation:fadeUp 1s ease}
footer .dev-badge{
  display:inline-block;padding:12px 26px;border-radius:50px;
  background:linear-gradient(135deg,var(--purple),var(--blue));
  color:#fff;font-weight:bold;margin-bottom:12px;
  box-shadow:0 0 25px rgba(188,140,255,.5);
  animation:glow 3s ease-in-out infinite;
}
footer p{color:var(--muted);font-size:.9em;margin:4px 0}

/* BADGES */
.badge{display:inline-block;padding:4px 12px;border-radius:20px;font-size:.8em;
  font-weight:bold;margin-right:8px}
.badge-green{background:rgba(63,185,80,.2);color:var(--green);border:1px solid var(--green)}
.badge-blue{background:rgba(88,166,255,.2);color:var(--blue);border:1px solid var(--blue)}
.badge-yellow{background:rgba(240,180,41,.2);color:var(--yellow);border:1px solid var(--yellow)}
.badge-red{background:rgba(248,81,73,.2);color:var(--red);border:1px solid var(--red)}
</style>
</head>
<body>
<div class="container">

  <header>
    <div class="crown">👑</div>
    <h1>Hakeem Cyber Forensics Report</h1>
    <p>لوحة التحليل الجنائي المتقدمة — المطور: حكيم العرب</p>
    <p><span class="badge badge-blue">${fmt}</span> <span class="badge badge-green">${width}×${height}</span> <span class="badge badge-yellow">${mp} MP</span></p>
  </header>

  ${gps_block}

  <div class="card">
    <h2>📸 معلومات الكاميرا والجهاز</h2>
    <div class="grid">
      <div>
        <div class="data-row"><span class="data-label">الشركة</span><span class="data-value">${make:-غير معروف}</span></div>
        <div class="data-row"><span class="data-label">الطراز</span><span class="data-value">${model:-غير معروف}</span></div>
        <div class="data-row"><span class="data-label">البرنامج</span><span class="data-value">${software:-غير معروف}</span></div>
        <div class="data-row"><span class="data-label">تاريخ الالتقاط</span><span class="data-value">${date_time:-غير معروف}</span></div>
      </div>
      <div>
        <div class="data-row"><span class="data-label">ISO</span><span class="data-value">${iso:-—}</span></div>
        <div class="data-row"><span class="data-label">فتحة العدسة</span><span class="data-value">${aperture:-—}</span></div>
        <div class="data-row"><span class="data-label">البعد البؤري</span><span class="data-value">${focal:-—}</span></div>
        <div class="data-row"><span class="data-label">الفلاش</span><span class="data-value">${flash:-—}</span></div>
      </div>
    </div>
  </div>

  <div class="card">
    <h2>🔬 التحليل التقني للصورة (Pixel-Level)</h2>
    <div class="grid grid-3">
      <div>
        <div class="data-row"><span class="data-label">الأبعاد</span><span class="data-value">${width} × ${height}</span></div>
        <div class="data-row"><span class="data-label">الميجابكسل</span><span class="data-value">${mp} MP</span></div>
        <div class="data-row"><span class="data-label">إجمالي البكسلات</span><span class="data-value">${total_px}</span></div>
        <div class="data-row"><span class="data-label">نسبة الأبعاد</span><span class="data-value">${aspect}</span></div>
      </div>
      <div>
        <div class="data-row"><span class="data-label">الصيغة</span><span class="data-value">${fmt}</span></div>
        <div class="data-row"><span class="data-label">الوضع اللوني</span><span class="data-value">${mode}</span></div>
        <div class="data-row"><span class="data-label">الحجم</span><span class="data-value">${size_h}</span></div>
        <div class="data-row"><span class="data-label">DPI</span><span class="data-value">${dpi}</span></div>
      </div>
      <div>
        <div class="data-row"><span class="data-label">متوسط RGB</span><span class="data-value">${avg_rgb}</span></div>
        <div class="data-row"><span class="data-label">مستوى الإضاءة</span><span class="data-value">${bright_lvl} (${brightness})</span></div>
        <div class="data-row"><span class="data-label">التباين</span><span class="data-value">${contrast_lvl} (${contrast})</span></div>
        <div class="data-row"><span class="data-label">الحدة</span><span class="data-value">${sharp_lvl} (${sharpness})</span></div>
      </div>
    </div>
    <div style="margin-top:20px">
      <div class="data-label">مستوى الإضاءة: <strong>${brightness}/255</strong></div>
      <div class="progress"><div class="progress-fill" style="width:${bright_pct}%"></div></div>
      <div class="data-label">مستوى التباين: <strong>${contrast}</strong></div>
      <div class="progress"><div class="progress-fill" style="width:${contrast_pct}%"></div></div>
    </div>
  </div>

  <div class="card">
    <h2>🎨 لوحة الألوان السائدة (Dominant Colors)</h2>
    <div class="palette">${palette_html:-<p style="color:var(--muted)">لا توجد بيانات</p>}</div>
  </div>

  <details>
    <summary>🖼️ معاينة الصورة بـ ASCII (Pixel Preview)</summary>
    <div class="ascii-box">${ascii_html:-لا توجد معاينة}</div>
  </details>

  <div class="card">
    <h2>🔐 البصمات الرقمية (Hashes)</h2>
    <div class="data-row"><span class="data-label">MD5</span></div>
    <div class="hash">${md5:-غير متوفر}</div>
    <div class="data-row"><span class="data-label">SHA-256</span></div>
    <div class="hash">${sha:-غير متوفر}</div>
  </div>

  <details>
    <summary>🛠️ البيانات الخام الكاملة (RAW EXIF)</summary>
    <pre>$(echo "$exif_raw" | sed 's/</\&lt;/g; s/>/\&gt;/g')</pre>
  </details>

  <footer>
    <div class="dev-badge">👑 المطور: حكيم العرب</div>
    <p><strong>Hakeem Al-Arab — Cyber Forensics Suite v8.1</strong></p>
    <p>🌐 github.com/hakim738-html</p>
    <p>📁 المسار: <code style="color:var(--cyan)">$img_path</code></p>
    <p>🕐 تم التوليد: $(date '+%Y-%m-%d %H:%M:%S')</p>
  </footer>

</div>
</body>
</html>
HTMLEOF

    echo -e "${GREEN}[✓] $(msg report_created)${NC}"
    echo -e "${CYAN}$(msg report_loc):${NC} $out_html"
    log_action "HTML_REPORT: $out_html"

    if command -v termux-open &>/dev/null; then
        sleep 1 && termux-open "$out_html" 2>/dev/null &
    elif command -v xdg-open &>/dev/null; then
        xdg-open "$out_html" 2>/dev/null &
    fi
    echo "$out_html"
}

# ─── EXIF MENU ───
exif_menu() {
    echo -e "${CYAN}${BOLD}═══ $(msg exif) ═══${NC}"
    read -r -p "$(msg prompt_image): " raw
    local path
    path=$(python3 "$BASE_DIR/path_resolver.py" "$raw")
    if [ ! -f "$path" ]; then
        echo -e "${RED}[✗] $(msg not_found)${NC}"
        echo -e "${DIM}   $(msg tried): $path${NC}"
        return
    fi
    echo -e "${GREEN}[✓] $(msg found)${NC}"

    exiftool "$path" 2>/dev/null | head -60 || file "$path"
    echo
    create_html_report "$path"
    echo -e "${GREEN}[✓] $(msg analysis_done)${NC}"
}

# ─── FORENSIC MENU ───
forensic_menu() {
    echo -e "${CYAN}${BOLD}═══ $(msg forensic) ═══${NC}"
    read -r -p "$(msg prompt_image): " raw
    local path
    path=$(python3 "$BASE_DIR/path_resolver.py" "$raw")
    if [ ! -f "$path" ]; then
        echo -e "${RED}[✗] $(msg not_found)${NC}"
        echo -e "${DIM}   $(msg tried): $path${NC}"
        return
    fi

    exiftool "$path" 2>/dev/null
    create_html_report "$path"
    echo -e "${GREEN}[✓] $(msg forensic_done)${NC}"
}

# ─── DEVELOPER WINDOW ───
show_developer() {
    clear
    echo -e "${MAGENTA}${BOLD}"
    sleep 0.1; echo "    ╔═══════════════════════════════════════════════════════╗"
    sleep 0.1; echo "    ║                                                       ║"
    sleep 0.1; echo "    ║              👑  ح ك ي م   ا ل ع ر ب  👑              ║"
    sleep 0.1; echo "    ║                                                       ║"
    sleep 0.1; echo "    ║                    Hakeem Al-Arab                     ║"
    sleep 0.1; echo "    ║                                                       ║"
    echo -e "    ║   ${CYAN}🎯 Cyber Security Expert${MAGENTA}                          ║"
    sleep 0.1; echo -e "    ║   ${CYAN}🔥 Ethical Hacker${MAGENTA}                                ║"
    sleep 0.1; echo -e "    ║   ${CYAN}💻 Full-Stack Developer${MAGENTA}                          ║"
    sleep 0.1; echo -e "    ║   ${CYAN}🛡️  Digital Forensics Specialist${MAGENTA}                 ║"
    echo "    ║                                                       ║"
    sleep 0.1; echo -e "    ║   ${GREEN}🌐 github.com/hakim738-html${MAGENTA}                      ║"
    echo "    ║                                                       ║"
    sleep 0.1; echo -e "    ║   ${YELLOW}\"الأمن السيبراني ليس ترفاً، بل ضرورة\"${MAGENTA}         ║"
    echo "    ║                                                       ║"
    sleep 0.1; echo "    ║        ⚡ Hakeem Tools · Est. 2024 ⚡                  ║"
    echo "    ║                                                       ║"
    sleep 0.1; echo "    ╚═══════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    sleep 0.3
    echo -e "${CYAN}"
    typewriter "    → شكراً لاستخدامك أدوات حكيم العرب 👑" 0.02
    echo -e "${NC}"
}

# ─── LOGS ───
view_logs() {
    echo -e "${CYAN}${BOLD}═══ $(msg logs) ═══${NC}"
    if [ -f "$LOG_FILE" ] && [ -s "$LOG_FILE" ]; then
        tail -50 "$LOG_FILE"
    else
        echo -e "${YELLOW}$(msg logs_empty)${NC}"
    fi
}

# ─── LANGUAGE ───
change_language() {
    echo -e "${CYAN}${BOLD}═══ $(msg lang_prompt) ═══${NC}"
    echo "  1) العربية"
    echo "  2) English"
    read -r -p "> " c
    case "$c" in
        1) LANG_CHOICE="ar"; ensure_arabic_support ;;
        2) LANG_CHOICE="en" ;;
        *) return ;;
    esac
    printf '%s' "$LANG_CHOICE" > "$LANG_FILE"
    echo -e "${GREEN}[✓] $(msg lang_set): $LANG_CHOICE${NC}"
}

initial_language_select() {
    [ -f "$LANG_FILE" ] && return
    clear
    echo -e "${CYAN}${BOLD}╔══════════════════════════════════════╗${NC}"
    echo -e "${CYAN}${BOLD}║  👑 Hakeem Stego — Select Language   ║${NC}"
    echo -e "${CYAN}${BOLD}╚══════════════════════════════════════╝${NC}"
    echo "  1) العربية"
    echo "  2) English"
    read -r -p "> " c
    case "$c" in 2) LANG_CHOICE="en";; *) LANG_CHOICE="ar";; esac
    printf '%s' "$LANG_CHOICE" > "$LANG_FILE"
}

# ─── MAIN MENU ───
main_menu() {
    while true; do
        show_banner
        echo -e "    ║   ${GREEN}[1]${NC} 🕵️   $(msg hide)"
        echo -e "    ║   ${GREEN}[2]${NC} 🔍   $(msg extract)"
        echo -e "    ║   ${GREEN}[3]${NC} 📊   $(msg exif)"
        echo -e "    ║   ${GREEN}[4]${NC} 🧬   $(msg forensic)"
        echo -e "    ║   ${GREEN}[5]${NC} 👑   $(msg devinfo)"
        echo -e "    ║   ${GREEN}[6]${NC} 📋   $(msg logs)"
        echo -e "    ║   ${GREEN}[7]${NC} 🌐   $(msg lang)"
        echo -e "    ║   ${RED}[0]${NC} ❌   $(msg exit)"
        echo -e "    ╚═══════════════════════════════════════════════════════════════════╝"
        echo
        read -r -p "${GREEN}    ┌──(${RED}root㉿hakeem${GREEN})─[${CYAN}~${GREEN}]"$'\n'"    └─${RED}\$${NC} " choice

        case "$choice" in
            1) hide_text_menu;        read -r -p "$(msg press_enter)" _ ;;
            2) extract_text_menu;     read -r -p "$(msg press_enter)" _ ;;
            3) exif_menu;             read -r -p "$(msg press_enter)" _ ;;
            4) forensic_menu;         read -r -p "$(msg press_enter)" _ ;;
            5) show_developer;        read -r -p "$(msg press_enter)" _ ;;
            6) view_logs;             read -r -p "$(msg press_enter)" _ ;;
            7) change_language;       read -r -p "$(msg press_enter)" _ ;;
            0) echo -e "${GREEN}${BOLD}$(msg goodbye)${NC}"; exit 0 ;;
            *) echo -e "${RED}$(msg invalid)${NC}"; sleep 1 ;;
        esac
    done
}

# ═══════════════════════════════════════════════════════════════════
# ENTRY POINT
# ═══════════════════════════════════════════════════════════════════
initial_language_select
ensure_arabic_support
check_tools
create_python_helpers
log_action "=== Session started (lang=$LANG_CHOICE) ==="
main_menu
