#!/bin/bash
# ===================================================
# 🛠️  H A K E E M   S T E G O   I N S T A L L E R
# 👑 DEVELOPER: Hakeem Al-Arab
# 🎯 VERSION: 6.1 - Professional Edition
# 🌐 GITHUB: hakim738-html
# 🌍 Languages: العربية / English
# ===================================================

set -o pipefail

# === COLORS ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m'

# === PATHS (match main script) ===
BASE_DIR="$HOME/Hakeem-Stego"
STEGO_DIR="$BASE_DIR/stego-images"
REPORTS_DIR="$BASE_DIR/reports"
BACKUP_DIR="$BASE_DIR/backups"
LOGS_DIR="$BASE_DIR/logs"
HIDDEN_DIR="$BASE_DIR/hidden-files"
LANG_FILE="$HOME/.hakeem_lang"
LOG_FILE="$LOGS_DIR/install.log"

# === CLI FLAGS ===
NO_UPDATE=0
QUIET=0
for arg in "$@"; do
    case "$arg" in
        --no-update) NO_UPDATE=1 ;;
        --quiet|-q)  QUIET=1 ;;
        --help|-h)
            echo "Usage: ./install-hakeem-stego.sh [--no-update] [--quiet] [--help]"
            echo "  --no-update  Skip 'pkg update' step (faster)"
            echo "  --quiet      Minimal output"
            echo "  --help       Show this help"
            exit 0
            ;;
    esac
done

# === LANG PERSISTENCE ===
LANG_CHOICE="en"
[ -f "$LANG_FILE" ] && LANG_CHOICE=$(cat "$LANG_FILE")

# === MESSAGES ===
declare -A MSG_AR MSG_EN

MSG_AR=(
    [banner_title]="أداة حكيم لتلغيم الصور والتحليل الجنائي"
    [developer]="المطوّر: حكيم العرب"
    [version]="الإصدار"
    [welcome]="مرحباً بك في مثبّت أداة حكيم"
    [select_lang]="اختر اللغة / Select Language"
    [checking_env]="فحص البيئة..."
    [env_termux_ok]="✓ تم التعرف على Termux"
    [env_termux_no]="⚠ لم يتم التعرف على Termux (سيستمر التثبيت)"
    [updating]="تحديث قائمة الحزم..."
    [update_skip]="تم تخطي تحديث الحزم (--no-update)"
    [installing]="تثبيت"
    [install_ok]="تم التثبيت"
    [install_fail]="فشل التثبيت"
    [installing_pillow]="تثبيت مكتبة Pillow عبر pip..."
    [creating_dirs]="إنشاء المجلدات..."
    [setting_perms]="ضبط صلاحيات التنفيذ..."
    [verifying]="التحقق من التثبيت..."
    [verify_ok]="✓ %s جاهز"
    [verify_fail]="✗ %s غير متوفر"
    [all_ok]="تم التثبيت بنجاح!"
    [some_failed]="تم التثبيت مع بعض التحذيرات"
    [how_to_run]="للتشغيل:"
    [features]="المميزات:"
    [folders]="المجلدات المنشأة:"
    [thanks]="شكراً لاستخدامك أداة حكيم"
    [press_enter]="اضغط Enter للخروج"
    [root_warn]="تحذير: تشغيل كـ root غير مستحسن"
)

MSG_EN=(
    [banner_title]="Hakeem Steganography & Forensics Tool"
    [developer]="Developer: Hakeem Al-Arab"
    [version]="Version"
    [welcome]="Welcome to Hakeem Tool Installer"
    [select_lang]="Select Language / اختر اللغة"
    [checking_env]="Checking environment..."
    [env_termux_ok]="✓ Termux detected"
    [env_termux_no]="⚠ Termux not detected (continuing anyway)"
    [updating]="Updating package list..."
    [update_skip]="Skipped package update (--no-update)"
    [installing]="Installing"
    [install_ok]="installed"
    [install_fail]="failed"
    [installing_pillow]="Installing Pillow via pip..."
    [creating_dirs]="Creating directories..."
    [setting_perms]="Setting execution permissions..."
    [verifying]="Verifying installation..."
    [verify_ok]="✓ %s ready"
    [verify_fail]="✗ %s missing"
    [all_ok]="Installation completed successfully!"
    [some_failed]="Installation completed with warnings"
    [how_to_run]="To run:"
    [features]="Features:"
    [folders]="Folders created:"
    [thanks]="Thanks for using Hakeem Tool"
    [press_enter]="Press Enter to exit"
    [root_warn]="Warning: running as root is not recommended"
)

msg() {
    local key="$1"; shift
    local txt
    if [ "$LANG_CHOICE" = "ar" ]; then
        txt="${MSG_AR[$key]}"
    else
        txt="${MSG_EN[$key]}"
    fi
    printf "$txt" "$@"
}

# === LOGGING ===
log() {
    mkdir -p "$LOGS_DIR"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# === HELPERS ===
print_banner() {
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
    printf "${CYAN}│  👑 %-48s│${NC}\n" "$(msg developer)"
    printf "${CYAN}│  🌐 %-48s│${NC}\n" "GitHub: hakim738-html"
    printf "${CYAN}│  🎯 %-48s│${NC}\n" "$(msg version): 6.1 - Professional"
    printf "${CYAN}│  🌍 %-48s│${NC}\n" "Lang: $LANG_CHOICE"
    echo -e "${CYAN}└────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -e "${BOLD}${WHITE}  $(msg welcome)${NC}"
    echo ""
}

step() { [ "$QUIET" -eq 0 ] && echo -e "${BLUE}[*]${NC} $1"; }
ok()   { [ "$QUIET" -eq 0 ] && echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
err()  { echo -e "${RED}[✗]${NC} $1"; }

# === ENV CHECK ===
check_env() {
    step "$(msg checking_env)"

    if [ "$(id -u)" = "0" ]; then
        warn "$(msg root_warn)"
    fi

    if [ -n "$PREFIX" ] && [[ "$PREFIX" == *"com.termux"* ]]; then
        ok "$(msg env_termux_ok)"
    else
        warn "$(msg env_termux_no)"
    fi

    # Storage access (Termux)
    if command -v termux-setup-storage &>/dev/null; then
        if [ ! -d "$HOME/storage" ]; then
            step "Requesting storage permission..."
            termux-setup-storage 2>/dev/null || true
        fi
    fi
}

# === PACKAGE INSTALL ===
install_pkg() {
    local pkg="$1"
    if command -v "$pkg" &>/dev/null; then
        ok "$pkg $(msg install_ok) ✓"
        return 0
    fi
    step "$(msg installing) $pkg..."
    if pkg install -y "$pkg" >/dev/null 2>&1; then
        ok "$pkg $(msg install_ok)"
        log "INSTALL OK: $pkg"
        return 0
    else
        err "$pkg $(msg install_fail)"
        log "INSTALL FAIL: $pkg"
        return 1
    fi
}

# === LANGUAGE SELECTION ===
select_language() {
    if [ ! -f "$LANG_FILE" ]; then
        echo -e "${CYAN}╔══════════════════════════════════════╗${NC}"
        echo -e "${CYAN}║ $(msg select_lang)${NC}"
        echo -e "${CYAN}╚══════════════════════════════════════╝${NC}"
        echo "  1) العربية"
        echo "  2) English"
        read -r -p "> " lc
        case "$lc" in
            1) LANG_CHOICE="ar" ;;
            2) LANG_CHOICE="en" ;;
            *) LANG_CHOICE="en" ;;
        esac
        echo "$LANG_CHOICE" > "$LANG_FILE"
    fi
}

# === MAIN INSTALL ===
main_install() {
    local failed=0

    # 1. Env check
    check_env

    # 2. Update
    if [ "$NO_UPDATE" -eq 0 ]; then
        step "$(msg updating)"
        pkg update -y >/dev/null 2>&1 && ok "updated" || warn "update had warnings (continuing)"
    else
        step "$(msg update_skip)"
    fi

    # 3. Install packages
    for p in exiftool file binutils python coreutils findutils; do
        install_pkg "$p" || failed=$((failed+1))
    done

    # 4. Pillow via pip
    if command -v python3 &>/dev/null; then
        if ! python3 -c "from PIL import Image" 2>/dev/null; then
            step "$(msg installing_pillow)"
            pip install --quiet --upgrade pip >/dev/null 2>&1
            if pip install --quiet pillow >/dev/null 2>&1; then
                ok "Pillow $(msg install_ok)"
                log "INSTALL OK: pillow"
            else
                err "Pillow $(msg install_fail)"
                failed=$((failed+1))
            fi
        else
            ok "Pillow $(msg install_ok) ✓"
        fi
    fi

    # 5. Directories
    step "$(msg creating_dirs)"
    mkdir -p "$STEGO_DIR" "$REPORTS_DIR" "$BACKUP_DIR" "$LOGS_DIR" "$HIDDEN_DIR"
    ok "$BASE_DIR ready"

    # 6. Permissions
    step "$(msg setting_perms)"
    if [ -f "./hakeem-stego.sh" ]; then
        chmod +x ./hakeem-stego.sh
        ok "hakeem-stego.sh executable"
    else
        warn "hakeem-stego.sh not found in current directory"
    fi

    # 7. Verify
    echo ""
    step "$(msg verifying)"
    local missing=()
    for t in exiftool python3 file; do
        if command -v "$t" &>/dev/null; then
            printf "  ${GREEN}✓${NC} %s\n" "$(printf "$(msg verify_ok)" "$t")"
        else
            printf "  ${RED}✗${NC} %s\n" "$(printf "$(msg verify_fail)" "$t")"
            missing+=("$t")
        fi
    done
    if python3 -c "from PIL import Image" 2>/dev/null; then
        printf "  ${GREEN}✓${NC} %s\n" "$(printf "$(msg verify_ok)" "Pillow")"
    else
        printf "  ${RED}✗${NC} %s\n" "$(printf "$(msg verify_fail)" "Pillow")"
        missing+=("pillow")
    fi

    echo ""
    if [ ${#missing[@]} -eq 0 ]; then
        echo -e "${GREEN}${BOLD}══════════════════════════════════════════════════════${NC}"
        echo -e "${GREEN}${BOLD}  ✅ $(msg all_ok)${NC}"
        echo -e "${GREEN}${BOLD}══════════════════════════════════════════════════════${NC}"
    else
        echo -e "${YELLOW}${BOLD}  ⚠ $(msg some_failed): ${missing[*]}${NC}"
    fi

    # 8. Final info
    echo ""
    echo -e "${CYAN}🚀 ${BOLD}$(msg how_to_run)${NC}"
    echo -e "   ${WHITE}./hakeem-stego.sh${NC}"
    echo ""
    echo -e "${CYAN}✨ ${BOLD}$(msg features)${NC}"
    echo -e "   • $( [ "$LANG_CHOICE" = "ar" ] && echo 'إخفاء نصوص داخل الصور (LSB)' || echo 'Hide text inside images (LSB)' )"
    echo -e "   • $( [ "$LANG_CHOICE" = "ar" ] && echo 'استخراج النصوص المخفية' || echo 'Extract hidden text' )"
    echo -e "   • $( [ "$LANG_CHOICE" = "ar" ] && echo 'تحليل EXIF / GPS / الكاميرا' || echo 'EXIF / GPS / Camera analysis' )"
    echo -e "   • $( [ "$LANG_CHOICE" = "ar" ] && echo 'تحليل جنائي شامل مع تقارير' || echo 'Full forensic analysis with reports' )"
    echo -e "   • $( [ "$LANG_CHOICE" = "ar" ] && echo 'واجهة عربية وإنجليزية' || echo 'Arabic & English interface' )"
    echo ""
    echo -e "${CYAN}📁 ${BOLD}$(msg folders)${NC}"
    echo -e "   ${WHITE}$STEGO_DIR${NC}"
    echo -e "   ${WHITE}$REPORTS_DIR${NC}"
    echo -e "   ${WHITE}$BACKUP_DIR${NC}"
    echo -e "   ${WHITE}$LOGS_DIR${NC}"
    echo -e "   ${WHITE}$HIDDEN_DIR${NC}"
    echo ""
    echo -e "${CYAN}👑 $(msg developer)${NC}"
    echo -e "${CYAN}🌐 GitHub: hakim738-html${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}${BOLD}  $(msg thanks)${NC}"
    echo ""

    log "=== INSTALL COMPLETE (lang=$LANG_CHOICE, failed=$failed) ==="
    return $failed
}

# === ENTRY ===
select_language
print_banner
main_install
