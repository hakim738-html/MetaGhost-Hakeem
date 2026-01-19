#!/bin/bash
# ===================================================
# 🛠️  برنامج تثبيت Hakeem Forensic Pro
# 👑 المطور: حكيم العرب
# ===================================================

set -e

# الألوان
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

show_header() {
    clear
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════╗"
    echo "║    H A K E E M   F O R E N S I C     ║"
    echo "║        P R O   I N S T A L L E R     ║"
    echo "╚══════════════════════════════════════╝"
    echo -e "${NC}"
}

show_progress() {
    echo -e "${YELLOW}📦 $1...${NC}"
}

show_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

show_error() {
    echo -e "${RED}❌ $1${NC}"
}

check_platform() {
    if [[ "$(uname -o)" == "Android" ]]; then
        echo "termux"
    elif [[ "$(uname -s)" == "Linux" ]]; then
        echo "linux"
    else
        echo "unknown"
    fi
}

install_dependencies() {
    local platform=$(check_platform)
    
    show_progress "تحديث قائمة الحزم"
    
    if [[ "$platform" == "termux" ]]; then
        pkg update -y && pkg upgrade -y
    elif [[ "$platform" == "linux" ]]; then
        sudo apt-get update && sudo apt-get upgrade -y
    fi
    
    show_progress "تثبيت الأدوات الأساسية"
    
    # قائمة الحزم المطلوبة
    local packages=("exiftool" "python3" "git")
    
    for pkg in "${packages[@]}"; do
        if ! command -v "$pkg" &> /dev/null; then
            show_progress "تثبيت $pkg"
            
            if [[ "$platform" == "termux" ]]; then
                pkg install "$pkg" -y || {
                    show_error "فشل تثبيت $pkg"
                    return 1
                }
            elif [[ "$platform" == "linux" ]]; then
                sudo apt-get install "$pkg" -y || {
                    show_error "فشل تثبيت $pkg"
                    return 1
                }
            fi
        fi
    done
    
    # تثبيت مكتبات Python إضافية
    show_progress "تثبيت مكتبات Python"
    pip3 install requests beautifulsoup4 2>/dev/null || true
    
    return 0
}

setup_directories() {
    show_progress "إنشاء مجلدات العمل"
    
    local base_dir="$HOME/Hakeem-Forensic"
    local dirs=("Reports" "Backups" "Pages" "Logs" "Scripts")
    
    for dir in "${dirs[@]}"; do
        mkdir -p "$base_dir/$dir"
    done
    
    show_success "تم إنشاء المجلدات في: $base_dir"
}

configure_scripts() {
    show_progress "إعداد ملفات البرنامج"
    
    # جعل الملفات قابلة للتنفيذ
    if [[ -f "Hakeem-Forensic-Pro.sh" ]]; then
        chmod +x "Hakeem-Forensic-Pro.sh"
        
        # إنشاء اختصار في المجلد الشخصي
        ln -sf "$(pwd)/Hakeem-Forensic-Pro.sh" "$HOME/hakeem" 2>/dev/null || true
        
        show_success "تم إعداد الأداة الرئيسية"
    else
        show_error "ملف Hakeem-Forensic-Pro.sh غير موجود!"
        return 1
    fi
    
    return 0
}

create_launcher() {
    show_progress "إنشاء ملف تشغيل سريع"
    
    cat > "$HOME/.hakeem-launcher" << 'EOF'
#!/bin/bash
cd "$HOME/Hakeem-Forensic" 2>/dev/null || cd ~
./Hakeem-Forensic-Pro.sh "$@"
EOF
    
    chmod +x "$HOME/.hakeem-launcher"
    
    # إضافة إلى .bashrc إذا لم تكن موجودة
    if ! grep -q "alias hakeem=" "$HOME/.bashrc" 2>/dev/null; then
        echo "alias hakeem='~/.hakeem-launcher'" >> "$HOME/.bashrc"
    fi
    
    if ! grep -q "alias hakeem=" "$HOME/.bash_profile" 2>/dev/null; then
        echo "alias hakeem='~/.hakeem-launcher'" >> "$HOME/.bash_profile"
    fi
}

show_completion() {
    echo ""
    echo -e "${GREEN}════════════════════════════════════════${NC}"
    echo -e "${GREEN}        ✅ اكتمل التثبيت بنجاح!         ${NC}"
    echo -e "${GREEN}════════════════════════════════════════${NC}"
    echo ""
    echo -e "${YELLOW}🚀 أوامر التشغيل:${NC}"
    echo "   ./Hakeem-Forensic-Pro.sh          # الطريقة العادية"
    echo "   hakeem                            # اختصار سريع (بعد إعادة تشغيل الترمكس)"
    echo ""
    echo -e "${BLUE}📁 مجلدات العمل:${NC}"
    echo "   $HOME/Hakeem-Forensic/Reports     # التقارير"
    echo "   $HOME/Hakeem-Forensic/Backups     # النسخ الاحتياطية"
    echo "   $HOME/Hakeem-Forensic/Pages       # الصفحات التعليمية"
    echo "   $HOME/Hakeem-Forensic/Logs        # سجلات النظام"
    echo ""
    echo -e "${GREEN}✨ المميزات الجديدة:${NC}"
    echo "   • ✅ واجهة محسنة مع ألوان جديدة"
    echo "   • ✅ معالجة أخطاء محسنة"
    echo "   • ✅ صفحات HTML متقدمة"
    echo "   • ✅ أدوات شبكة وكلمات مرور"
    echo "   • ✅ مدير ملفات متكامل"
    echo ""
    echo -e "${YELLOW}👑 المطور: حكيم العرب${NC}"
    echo -e "${BLUE}🌐 GitHub: hakim738-html${NC}"
    echo -e "${GREEN}════════════════════════════════════════${NC}"
    echo ""
    
    # إعادة تشغيل الـ shell لتفعيل الـ alias
    if [[ -n "$BASH_VERSION" ]]; then
        source "$HOME/.bashrc"
    fi
}

# ===================================================
# 🚀 تنفيذ التثبيت
# ===================================================
main() {
    show_header
    
    echo -e "${YELLOW}🔍 التحقق من النظام...${NC}"
    local platform=$(check_platform)
    
    if [[ "$platform" == "unknown" ]]; then
        show_error "هذا النظام غير مدعوم!"
        exit 1
    fi
    
    echo -e "${GREEN}✅ النظام: $platform${NC}"
    
    # تثبيت المتطلبات
    if ! install_dependencies; then
        show_error "فشل في تثبيت المتطلبات"
        exit 1
    fi
    
    # إعداد المجلدات
    setup_directories
    
    # تكوين البرنامج
    if ! configure_scripts; then
        show_error "فشل في إعداد البرنامج"
        exit 1
    fi
    
    # إنشاء ملف التشغيل
    create_launcher
    
    # عرض رسالة الإكمال
    show_completion
}

# تشغيل التثبيت
main "$@"