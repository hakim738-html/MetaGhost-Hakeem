#!/bin/bash
# ======================================================
# 🔥 H A K E E M   U L T I M A T E   F O R E N S I C
# 👑 DEVELOPED BY: H A K E E M
# 🎯 VERSION: PRO 2024 EDITION
# 🌐 GitHub: https://github.com/hakim738-html
# ======================================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
HAKEEM_RED='\033[38;5;196m'
HAKEEM_GOLD='\033[38;5;220m'
HAKEEM_BLUE='\033[38;5;33m'
NC='\033[0m'

# Banner
show_banner() {
    clear
    echo -e "${HAKEEM_RED}"
    echo "  ██╗  ██╗ █████╗ ██╗  ██╗███████╗███████╗███╗   ███╗"
    echo "  ██║  ██║██╔══██╗██║ ██╔╝██╔════╝██╔════╝████╗ ████║"
    echo "  ███████║███████║█████╔╝ █████╗  █████╗  ██╔████╔██║"
    echo "  ██╔══██║██╔══██║██╔═██╗ ██╔══╝  ██╔══╝  ██║╚██╔╝██║"
    echo "  ██║  ██║██║  ██║██║  ██╗███████╗███████╗██║ ╚═╝ ██║"
    echo "  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝╚═╝     ╚═╝"
    echo -e "${HAKEEM_GOLD}"
    echo "          F O R E N S I C   S U I T E   v2.0"
    echo -e "${HAKEEM_BLUE}"
    echo "        Developer: H A K E E M"
    echo "        GitHub: hakim738-html"
    echo -e "${NC}"
}

# Check tools
check_tools() {
    echo -e "${CYAN}🔍 Checking tools...${NC}"
    
    if ! command -v exiftool &> /dev/null; then
        echo -e "${YELLOW}Installing ExifTool...${NC}"
        pkg install exiftool -y
    fi
    
    echo -e "${GREEN}✅ Ready!${NC}"
}

# Image analysis
analyze_image() {
    echo -e "${CYAN}🎯 Image path:${NC}"
    read img
    
    if [ ! -f "$img" ]; then
        echo -e "${RED}❌ File not found${NC}"
        return
    fi
    
    echo -e "${YELLOW}📊 Analyzing...${NC}"
    
    # Basic info
    echo -e "${BLUE}📁 File Info:${NC}"
    echo "Name: $(basename "$img")"
    echo "Size: $(du -h "$img" | cut -f1)"
    echo "Type: $(file "$img")"
    
    # EXIF data
    echo -e "${BLUE}📸 EXIF Data:${NC}"
    exiftool "$img" | head -20
    
    # GPS check
    echo -e "${BLUE}📍 GPS Check:${NC}"
    lat=$(exiftool -n -GPSLatitude "$img" 2>/dev/null | cut -d: -f2 | xargs)
    lon=$(exiftool -n -GPSLongitude "$img" 2>/dev/null | cut -d: -f2 | xargs)
    
    if [ -n "$lat" ] && [ -n "$lon" ]; then
        echo -e "${RED}⚠️  GPS Found!${NC}"
        echo "Latitude: $lat"
        echo "Longitude: $lon"
        echo "Maps: https://maps.google.com/?q=$lat,$lon"
    else
        echo "No GPS data"
    fi
    
    # Create report
    report="HAKEEM_$(date +%Y%m%d_%H%M%S)_$(basename "$img").txt"
    exiftool "$img" > "$report" 2>/dev/null
    echo -e "${GREEN}✅ Report saved: $report${NC}"
}

# Remove metadata
clean_image() {
    echo -e "${CYAN}🎯 Image to clean:${NC}"
    read img
    
    backup="BACKUP_$(date +%H%M%S)_$(basename "$img")"
    cp "$img" "$backup"
    
    echo -e "${YELLOW}🧹 Cleaning...${NC}"
    exiftool -all= "$img" 2>/dev/null
    
    echo -e "${GREEN}✅ Cleaned!${NC}"
    echo -e "${BLUE}💾 Backup: $backup${NC}"
}

# Steganography hide
hide_file() {
    echo -e "${CYAN}🎯 Cover image:${NC}"
    read cover
    echo -e "${CYAN}📁 File to hide:${NC}"
    read secret
    
    output="STEGO_$(date +%H%M%S)_$(basename "$cover")"
    
    echo -e "${YELLOW}🕵️ Hiding...${NC}"
    steghide embed -cf "$cover" -ef "$secret" -sf "$output" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Hidden! File: $output${NC}"
    else
        echo -e "${RED}❌ Failed${NC}"
    fi
}

# PUBG page
create_pubg_page() {
    page="PUBG_PAGE_$(date +%H%M%S).html"
    
    cat > "$page" << 'EOF'
<!DOCTYPE html>
<html>
<head><title>PUBG Rewards</title>
<style>
body{font-family:Arial;background:#0a0a0a;color:#fff;margin:20px;}
.header{background:linear-gradient(90deg,#ff0000,#ff9900);padding:20px;border-radius:10px;}
.reward{background:#1a1a1a;padding:15px;margin:10px 0;border-radius:5px;}
.button{background:#ff0000;color:white;padding:15px;border:none;border-radius:5px;font-size:16px;cursor:pointer;}
</style>
</head>
<body>
<div class="header">
<h1>🎮 PUBG MOBILE REWARDS</h1>
<p>Claim your free UC and skins!</p>
</div>

<div class="reward">
<h3>🎁 10,000 Unknown Cash</h3>
<p>Limited time offer!</p>
</div>

<form onsubmit="alert('Educational Page Only!');return false">
<input type="text" placeholder="PUBG ID" required style="width:100%;padding:10px;margin:10px 0;">
<input type="email" placeholder="Email" required style="width:100%;padding:10px;margin:10px 0;">
<button class="button">CLAIM REWARDS</button>
</form>

<div style="text-align:center;margin-top:30px;padding:10px;background:#333;border-radius:5px;">
⚠️ EDUCATIONAL PAGE - Created by Hakeem Forensic Tools
</div>
</body>
</html>
EOF
    
    echo -e "${GREEN}✅ PUBG page created: $page${NC}"
    echo -e "${CYAN}🌐 Serve with: python3 -m http.server 8080${NC}"
}

# Main menu
main_menu() {
    while true; do
        show_banner
        check_tools
        
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${GREEN}【1】🔍 Analyze Image"
        echo -e "【2】🧹 Clean Metadata"
        echo -e "【3】🕵️ Hide File in Image"
        echo -e "【4】🎮 Create PUBG Page"
        echo -e "【5】📊 Quick GPS Check"
        echo -e "${RED}【0】🚪 Exit"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        
        read -p "Select: " choice
        
        case $choice in
            1) analyze_image ;;
            2) clean_image ;;
            3) hide_file ;;
            4) create_pubg_page ;;
            5)
                echo -e "${CYAN}Image path:${NC}"
                read img
                exiftool -GPS* "$img" 2>/dev/null
                ;;
            0)
                echo -e "${GREEN}👋 Bye! - Hakeem${NC}"
                exit 0
                ;;
        esac
        
        echo ""
        read -p "Press Enter..."
    done
}

# Start
main_menu