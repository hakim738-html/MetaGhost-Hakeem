#!/bin/bash
# ═══════════════════════════════════════════════════════════════════
# 🛠️  H A K E E M   S T E G O   I N S T A L L E R
# 👑 DEVELOPER: Hakeem Al-Arab
# 🎯 VERSION: 8.0 - Ultimate Cyber Installer
# 🌐 GITHUB: hakim738-html
# 🌍 Languages: العربية / English
# ═══════════════════════════════════════════════════════════════════

set -o pipefail

# ─── COLORS (fixed bash escape) ───
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

# ─── PATHS ───
BASE_DIR="$HOME/Hakeem-Stego"
STEGO_DIR="$BASE_DIR/stego-images"
REPORTS_DIR="$BASE_DIR/reports"
BACKUP_DIR="$BASE_DIR/backups"
LOGS_DIR="$BASE_DIR/logs"
HIDDEN_DIR="$BASE_DIR/hidden-files"
LANG_FILE="$HOME/.hakeem_lang"
LOG_FILE="$LOGS_DIR/install.log"
MAIN_SCRIPT="$BASE_DIR/hakeem-stego.sh"
REPO_URL="https://raw.githubusercontent.com/hakim738-html/hakeem-stego/main/hakeem-stego.sh"

mkdir -p "$LOGS_DIR"

# ─── CLI FLAGS ───
NO_UPDATE=0
QUIET=0
DO_UPDATE=0
DO_UNINSTALL=0
DO_CHECK=0
AUTO_DOWNLOAD=1

for arg in "$@"; do
    case "$arg" in
        --no-update)     NO_UPDATE=1 ;;
        --quiet|-q)      QUIET=1 ;;
        --update|-u)     DO_UPDATE=1 ;;
        --uninstall)     DO_UNINSTALL=1 ;;
        --check|-c)      DO_CHECK=1 ;;
        --no-download)   AUTO_DOWNLOAD=0 ;;
        --help|-h)
            echo "════════════════════════════════════════════════════════"
            echo "  👑 Hakeem Stego Installer v8.0"
            echo "════════════════════════════════════════════════════════"
            echo "Usage: ./install-hakeem-stego.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --no-update      Skip 'pkg update' (faster)"
            echo "  --quiet, -q      Minimal output"
            echo "  --update, -u     Update main script from GitHub"
            echo "  --uninstall      Remove all installed files"
            echo "  --check, -c      Check if everything is installed"
            echo "  --no-download    Don't auto-download main script"
            echo "  --help, -h       Show this help"
            echo "════════════════════════════════════════════════════════"
            exit 0
            ;;
    esac
done

# ─── LANGUAGE ───
LANG_CHOICE="ar"
[ -f "$LANG_FILE" ] && LANG_CHOICE=$(tr -d '[:space:]' < "$LANG_FILE" 2>/dev/null)
[ "$LANG_CHOICE" = "en" ] || LANG_CHOICE="ar"

# ─── ARABIC SHAPING ───
AR_SUPPORT=0
ensure_ar() {
    [ "$LANG_CHOICE" = "ar" ] || return
    if python3 -c "import arabic_reshaper; from bidi.algorithm import get_display" 2>/dev/null; then
        AR_SUPPORT=1
    fi
}
shape_ar() {
    local t="$1"
    [ -z "$t" ] && return
    [ "$AR_SUPPORT" -eq 0 ] && { printf '%s' "$t"; return; }
    python3 -c "
import sys
try:
    import arabic_reshaper
    from bidi.algorithm import get_display
    print(get_display(arabic_reshaper.reshape(sys.argv[1])), end='')
except Exception:
    print(sys.argv[1], end='')
" "$t" 2>/dev/null
}

# ─── MESSAGES ───
declare -A MSG_AR MSG_EN
MSG_AR=(
    [banner]="أداة حكيم لتلغيم الصور والتحليل الجنائي"
    [dev]="المطوّر: حكيم العرب"
    [version]="الإصدار"
    [welcome]="مرحباً بك في مثبّت أداة حكيم"
    [select_lang]="اختر اللغة"
    [checking_env]="فحص البيئة..."
    [termux_ok]="تم التعرف على Termux"
    [linux_ok]="تم التعرف على Linux"
    [env_unknown]="بيئة غير معروفة، سيتم المحاولة"
    [updating]="تحديث قائمة الحزم..."
    [update_skip]="تم تخطي تحديث الحزم"
    [installing]="تثبيت"
    [install_ok]="تم التثبيت"
    [install_fail]="فشل التثبيت"
    [already]="مثبتة مسبقاً"
    [installing_pip]="تثبيت مكتبات Python..."
    [creating_dirs]="إنشاء المجلدات..."
    [setting_perms]="ضبط الصلاحيات..."
    [verifying]="التحقق من التثبيت..."
    [ready]="جاهز"
    [missing]="غير متوفر"
    [all_ok]="تم التثبيت بنجاح!"
    [warnings]="تم التثبيت مع تحذيرات"
    [how_to_run]="للتشغيل"
    [features]="المميزات"
    [folders]="المجلدات المنشأة"
    [thanks]="شكراً لاستخدامك أداة حكيم"
    [press_enter]="اضغط Enter للخروج"
    [root_warn]="تحذير: تشغيل كـ root غير مستحسن"
    [downloading]="تنزيل السكربت الرئيسي..."
    [download_ok]="تم تنزيل السكربت الرئيسي"
    [download_fail]="فشل التنزيل - ضع hakeem-stego.sh يدوياً في المجلد الحالي"
    [creating_shortcut]="إنشاء اختصار hakeem..."
    [shortcut_ok]="يمكنك الآن كتابة: hakeem"
    [update_mode]="وضع التحديث"
    [uninstall_mode]="وضع إلغاء التثبيت"
    [check_mode]="وضع الفحص"
    [confirm_uninstall]="هل أنت متأكد؟ (yes/no)"
    [uninstalled]="تم إلغاء التثبيت"
    [cancelled]="تم الإلغاء"
    [storage_req]="طلب إذن التخزين..."
    [cleanup]="تنظيف..."
)
MSG_EN=(
    [banner]="Hakeem Steganography & Forensics Tool"
    [dev]="Developer: Hakeem Al-Arab"
    [version]="Version"
    [welcome]="Welcome to Hakeem Tool Installer"
    [select_lang]="Select Language"
    [checking_env]="Checking environment..."
    [termux_ok]="Termux detected"
    [linux_ok]="Linux detected"
    [env_unknown]="Unknown environment, trying anyway"
    [updating]="Updating package list..."
    [update_skip]="Skipped update"
    [installing]="Installing"
    [install_ok]="installed"
    [install_fail]="failed"
    [already]="already installed"
    [installing_pip]="Installing Python packages..."
    [creating_dirs]="Creating directories..."
    [setting_perms]="Setting permissions..."
    [verifying]="Verifying installation..."
    [ready]="ready"
    [missing]="missing"
    [all_ok]="Installation completed successfully!"
    [warnings]="Installation completed with warnings"
    [how_to_run]="To run"
    [features]="Features"
    [folders]="Folders created"
    [thanks]="Thanks for using Hakeem Tool"
    [press_enter]="Press Enter to exit"
    [root_warn]="Warning: running as root is not recommended"
    [downloading]="Downloading main script..."
    [download_ok]="Main script downloaded"
    [download_fail]="Download failed - place hakeem-stego.sh manually"
    [creating_shortcut]="Creating 'hakeem' shortcut..."
    [shortcut_ok]="You can now type: hakeem"
    [update_mode]="Update Mode"
    [uninstall_mode]="Uninstall Mode"
    [check_mode]="Check Mode"
    [confirm_uninstall]="Are you sure? (yes/no)"
    [uninstalled]="Uninstalled"
    [cancelled]="Cancelled"
    [storage_req]="Requesting storage permission..."
    [cleanup]="Cleaning up..."
)

msg() {
    local k="$1"; shift
    local txt
    if [ "$LANG_CHOICE" = "ar" ]; then
        txt="${MSG_AR[$k]:-$k}"
        txt=$(shape_ar "$txt")
    else
        txt="${MSG_EN[$k]:-$k}"
    fi
    # Safe printf (only substitute %s if args given)
    if [ $# -gt 0 ]; then
        printf "$txt" "$@"
    else
        printf '%s' "$txt"
    fi
}

# ─── LOGGING ───
log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"; }

# ─── HELPERS ───
step() { [ "$QUIET" -eq 0 ] && echo -e "${BLUE}[*]${NC} $1"; }
ok()   { [ "$QUIET" -eq 0 ] && echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
err()  { echo -e "${RED}[✗]${NC} $1"; }

spinner() {
    local pid=$1 label="$2"
    local f=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
    while kill -0 "$pid" 2>/dev/null; do
        for c in "${f[@]}"; do
            printf "\r${CYAN}%s${NC} %s... " "$c" "$label"
            sleep 0.08
        done
    done
    printf "\r%-70s\r" ""
}

# ─── BANNER (FIXED ALIGNMENT) ───
print_banner() {
    clear
    echo -e "${RED}${BOLD}"
    cat << 'EOF'
╔════════════════════════════════════════════════════════════════════╗
║                                                                    ║
║    ██╗  ██╗ █████╗ ██╗  ██╗███████╗███████╗███╗   ███╗             ║
║    ██║  ██║██╔══██╗██║ ██╔╝██╔════╝██╔════╝████╗ ████║             ║
║    ███████║███████║█████╔╝ █████╗  █████╗  ██╔████╔██║             ║
║    ██╔══██║██╔══██║██╔═██╗ ██╔══╝  ██╔══╝  ██║╚██╔╝██║             ║
║    ██║  ██║██║  ██║██║  ██╗███████╗███████╗██║ ╚═╝ ██║             ║
║    ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝╚═╝     ╚═╝             ║
║                                                                    ║
║          🔥 IMAGE STEGANOGRAPHY & FORENSICS TOOL 🔥                ║
║                                                                    ║
╚════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    echo -e "${CYAN}┌────────────────────────────────────────────────────────────────────┐${NC}"
    printf "${CYAN}│  👑 %-62s│${NC}\n" "$(msg dev)"
    printf "${CYAN}│  🌐 %-62s│${NC}\n" "GitHub: hakim738-html"
    printf "${CYAN}│  🎯 %-62s│${NC}\n" "$(msg version): 8.0 - Ultimate Cyber"
    printf "${CYAN}│  🌍 %-62s│${NC}\n" "Lang: $LANG_CHOICE"
    echo -e "${CYAN}└────────────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -e "${BOLD}${WHITE}  $(msg welcome)${NC}"
    echo ""
}

# ─── ENV DETECT ───
ENV_TYPE="unknown"
detect_env() {
    step "$(msg checking_env)"
    [ "$(id -u)" = "0" ] && warn "$(msg root_warn)"

    if [ -n "$PREFIX" ] && [[ "$PREFIX" == *"com.termux"* ]]; then
        ENV_TYPE="termux"
        ok "$(msg termux_ok)"
        if command -v termux-setup-storage &>/dev/null && [ ! -d "$HOME/storage" ]; then
            step "$(msg storage_req)"
            termux-setup-storage 2>/dev/null || true
        fi
    elif command -v apt &>/dev/null || command -v dnf &>/dev/null || command -v pacman &>/dev/null; then
        ENV_TYPE="linux"
        ok "$(msg linux_ok)"
    else
        warn "$(msg env_unknown)"
    fi
}

# ─── PACKAGE INSTALLER (multi-platform) ───
pkg_installed() { command -v "$1" &>/dev/null; }

install_pkg() {
    local pkg="$1"
    local pkg_name="${2:-$1}"

    if pkg_installed "$pkg"; then
        ok "$pkg — $(msg already) ✓"
        return 0
    fi

    step "$(msg installing) $pkg..."

    local rc=0
    case "$ENV_TYPE" in
        termux) pkg install -y "$pkg_name" >/dev/null 2>&1 || rc=1 ;;
        linux)
            if command -v apt &>/dev/null; then
                sudo apt install -y "$pkg_name" >/dev/null 2>&1 || rc=1
            elif command -v dnf &>/dev/null; then
                sudo dnf install -y "$pkg_name" >/dev/null 2>&1 || rc=1
            elif command -v pacman &>/dev/null; then
                sudo pacman -S --noconfirm "$pkg_name" >/dev/null 2>&1 || rc=1
            fi
            ;;
        *) rc=1 ;;
    esac

    if [ $rc -eq 0 ] || pkg_installed "$pkg"; then
        ok "$pkg $(msg install_ok)"
        log "INSTALL OK: $pkg"
        return 0
    else
        err "$pkg $(msg install_fail)"
        log "INSTALL FAIL: $pkg"
        return 1
    fi
}

# ─── PIP INSTALLER ───
pip_install() {
    local pkg="$1" check="$2"
    [ -z "$check" ] && check="$pkg"

    if python3 -c "import $check" 2>/dev/null; then
        ok "$pkg — $(msg already) ✓"
        return 0
    fi

    step "$(msg installing) $pkg (pip)..."
    (pip install --quiet "$pkg" --break-system-packages 2>/dev/null || \
     pip install --quiet "$pkg" 2>/dev/null) &
    spinner $! "$pkg"

    if python3 -c "import $check" 2>/dev/null; then
        ok "$pkg $(msg install_ok)"
        log "PIP OK: $pkg"
        return 0
    else
        err "$pkg $(msg install_fail)"
        log "PIP FAIL: $pkg"
        return 1
    fi
}

# ─── DOWNLOAD MAIN SCRIPT ───
download_main() {
    [ "$AUTO_DOWNLOAD" -eq 0 ] && return
    [ -f "$MAIN_SCRIPT" ] && [ "$DO_UPDATE" -eq 0 ] && return
    [ "$DO_UPDATE" -eq 1 ] || [ ! -f "./hakeem-stego.sh" ] || return

    step "$(msg downloading)"
    if command -v curl &>/dev/null; then
        if curl -fsSL "$REPO_URL" -o "$MAIN_SCRIPT" 2>/dev/null && [ -s "$MAIN_SCRIPT" ]; then
            chmod +x "$MAIN_SCRIPT"
            ok "$(msg download_ok)"
            return 0
        fi
    elif command -v wget &>/dev/null; then
        if wget -q "$REPO_URL" -O "$MAIN_SCRIPT" 2>/dev/null && [ -s "$MAIN_SCRIPT" ]; then
            chmod +x "$MAIN_SCRIPT"
            ok "$(msg download_ok)"
            return 0
        fi
    fi
    # Fallback: copy local
    if [ -f "./hakeem-stego.sh" ]; then
        cp "./hakeem-stego.sh" "$MAIN_SCRIPT"
        chmod +x "$MAIN_SCRIPT"
        ok "$(msg download_ok) (local)"
        return 0
    fi
    warn "$(msg download_fail)"
}

# ─── CREATE SHORTCUT ───
create_shortcut() {
    [ "$ENV_TYPE" = "termux" ] || return
    step "$(msg creating_shortcut)"
    mkdir -p "$PREFIX/bin"
    cat > "$PREFIX/bin/hakeem" << EOF
#!/bin/bash
exec "$MAIN_SCRIPT" "\$@"
EOF
    chmod +x "$PREFIX/bin/hakeem"
    ok "$(msg shortcut_ok)"
}

# ─── LANGUAGE SELECT ───
select_language() {
    [ -f "$LANG_FILE" ] && return
    echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║  $(msg select_lang)                          ${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
    echo "  1) العربية"
    echo "  2) English"
    read -r -p "> " lc
    case "$lc" in
        1) LANG_CHOICE="ar" ;;
        2) LANG_CHOICE="en" ;;
        *) LANG_CHOICE="ar" ;;
    esac
    printf '%s' "$LANG_CHOICE" > "$LANG_FILE"
}

# ─── CHECK MODE ───
do_check() {
    echo -e "${CYAN}${BOLD}═══ $(msg check_mode) ═══${NC}"
    local ok=0 fail=0
    for t in exiftool python3 file; do
        if command -v "$t" &>/dev/null; then
            echo -e "  ${GREEN}✓${NC} $t ($(command -v "$t"))"; ((ok++))
        else
            echo -e "  ${RED}✗${NC} $t — $(msg missing)"; ((fail++))
        fi
    done
    for m in PIL arabic_reshaper bidi; do
        if python3 -c "import $m" 2>/dev/null; then
            echo -e "  ${GREEN}✓${NC} Python: $m"; ((ok++))
        else
            echo -e "  ${YELLOW}○${NC} Python: $m — $(msg missing)"; ((fail++))
        fi
    done
    [ -f "$MAIN_SCRIPT" ] && echo -e "  ${GREEN}✓${NC} Main script" || echo -e "  ${RED}✗${NC} Main script missing"
    echo
    echo -e "${CYAN}OK: $ok | Missing: $fail${NC}"
}

# ─── UNINSTALL ───
do_uninstall() {
    echo -e "${RED}${BOLD}═══ $(msg uninstall_mode) ═══${NC}"
    echo -e "${YELLOW}$(msg confirm_uninstall)${NC}"
    read -r ans
    case "$ans" in
        yes|y|Y|نعم)
            step "$(msg cleanup)"
            rm -rf "$BASE_DIR"
            rm -f "$LANG_FILE" "$PREFIX/bin/hakeem" 2>/dev/null
            ok "$(msg uninstalled)"
            ;;
        *) warn "$(msg cancelled)" ;;
    esac
    exit 0
}

# ─── UPDATE MODE ───
do_update() {
    echo -e "${CYAN}${BOLD}═══ $(msg update_mode) ═══${NC}"
    DO_UPDATE=1
    download_main
    exit $?
}

# ─── VERIFY ───
verify_install() {
    step "$(msg verifying)"
    local missing=()
    local ok_count=0

    for t in exiftool python3 file; do
        if command -v "$t" &>/dev/null; then
            printf "  ${GREEN}✓${NC} %s — %s\n" "$t" "$(msg ready)"
            ((ok_count++))
        else
            printf "  ${RED}✗${NC} %s — %s\n" "$t" "$(msg missing)"
            missing+=("$t")
        fi
    done

    if python3 -c "from PIL import Image" 2>/dev/null; then
        printf "  ${GREEN}✓${NC} Pillow — %s\n" "$(msg ready)"
        ((ok_count++))
    else
        printf "  ${RED}✗${NC} Pillow — %s\n" "$(msg missing)"
        missing+=("pillow")
    fi

    # Optional (Arabic shaping)
    for m in arabic_reshaper bidi; do
        if python3 -c "import $m" 2>/dev/null; then
            printf "  ${GREEN}✓${NC} Python:%s — %s\n" "$m" "$(msg ready)"
        else
            printf "  ${YELLOW}○${NC} Python:%s — optional\n" "$m"
        fi
    done

    echo ""
    if [ ${#missing[@]} -eq 0 ]; then
        echo -e "${GREEN}${BOLD}════════════════════════════════════════════════════════════${NC}"
        echo -e "${GREEN}${BOLD}  ✅ $(msg all_ok)${NC}"
        echo -e "${GREEN}${BOLD}════════════════════════════════════════════════════════════${NC}"
        return 0
    else
        echo -e "${YELLOW}${BOLD}  ⚠ $(msg warnings): ${missing[*]}${NC}"
        return 1
    fi
}

# ─── FINAL INFO ───
final_info() {
    echo ""
    echo -e "${CYAN}🚀 ${BOLD}$(msg how_to_run)${NC}"
    if [ "$ENV_TYPE" = "termux" ] && [ -f "$PREFIX/bin/hakeem" ]; then
        echo -e "   ${WHITE}hakeem${NC}      ${DIM}(shortcut)${NC}"
    fi
    echo -e "   ${WHITE}$MAIN_SCRIPT${NC}"
    echo ""

    echo -e "${CYAN}✨ ${BOLD}$(msg features)${NC}"
    local F
    if [ "$LANG_CHOICE" = "ar" ]; then
        F=(
            "إخفاء نصوص داخل الصور (LSB)"
            "استخراج النصوص المخفية"
            "تحليل EXIF / GPS / الكاميرا"
            "تقرير HTML تفاعلي مع خرائط جوجل"
            "تحليل بكسلات وألوان وحدة الصورة"
            "نافذة المطور حكيم العرب"
            "واجهة عربية وإنجليزية"
        )
    else
        F=(
            "Hide text inside images (LSB)"
            "Extract hidden text"
            "EXIF / GPS / camera analysis"
            "Interactive HTML report with Google Maps"
            "Pixel/color/sharpness analysis"
            "Hakeem Al-Arab developer window"
            "Arabic & English interface"
        )
    fi
    for f in "${F[@]}"; do echo -e "   • $f"; done
    echo ""

    echo -e "${CYAN}📁 ${BOLD}$(msg folders)${NC}"
    for d in "$STEGO_DIR" "$REPORTS_DIR" "$BACKUP_DIR" "$LOGS_DIR" "$HIDDEN_DIR"; do
        echo -e "   ${WHITE}$d${NC}"
    done
    echo ""
    echo -e "${CYAN}👑 $(msg dev)${NC}"
    echo -e "${CYAN}🌐 GitHub: hakim738-html${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}${BOLD}  $(msg thanks)${NC}"
    echo ""
}

# ─── MAIN INSTALL ───
main_install() {
    local failed=0

    detect_env
    ensure_ar

    # 1) Update
    if [ "$NO_UPDATE" -eq 0 ] && [ "$ENV_TYPE" = "termux" ]; then
        step "$(msg updating)"
        pkg update -y >/dev/null 2>&1 && ok "updated" || warn "update warnings (continuing)"
    else
        step "$(msg update_skip)"
    fi

    # 2) System packages
    install_pkg exiftool libimage-exiftool-perl || failed=$((failed+1))
    install_pkg python  python3                        || failed=$((failed+1))
    install_pkg file    file                           || failed=$((failed+1))
    install_pkg curl    curl                           || failed=$((failed+1))

    # 3) Python packages
    step "$(msg installing_pip)"
    pip_install pillow          PIL              || failed=$((failed+1))
    pip_install arabic-reshaper arabic_reshaper  || true   # optional
    pip_install python-bidi     bidi             || true   # optional

    # 4) Directories
    step "$(msg creating_dirs)"
    mkdir -p "$STEGO_DIR" "$REPORTS_DIR" "$BACKUP_DIR" "$LOGS_DIR" "$HIDDEN_DIR"
    ok "$BASE_DIR"

    # 5) Download main script
    download_main

    # 6) Permissions
    step "$(msg setting_perms)"
    [ -f "./hakeem-stego.sh" ] && cp -f "./hakeem-stego.sh" "$MAIN_SCRIPT" 2>/dev/null
    [ -f "$MAIN_SCRIPT" ] && chmod +x "$MAIN_SCRIPT" && ok "hakeem-stego.sh executable"

    # 7) Shortcut
    create_shortcut

    # 8) Verify
    echo ""
    verify_install || true
    final_info
    log "=== INSTALL COMPLETE (lang=$LANG_CHOICE, env=$ENV_TYPE, failed=$failed) ==="
    return $failed
}

# ═══════════════════════════════════════════════════════════════════
# ENTRY POINT
# ═══════════════════════════════════════════════════════════════════
select_language
print_banner
ensure_ar

[ "$DO_UNINSTALL" -eq 1 ] && do_uninstall
[ "$DO_UPDATE" -eq 1 ]    && do_update
[ "$DO_CHECK" -eq 1 ]     && { do_check; exit 0; }

main_install
