#!/bin/bash
# ===============================================
# 🔥 HAKEEM Forensic & Steganography Tool v5.0
# 👨‍💻 Developed by: Hakeem
# 🎯 Advanced Metadata Analysis & Steganography
# ===============================================

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
    echo -e "${PURPLE}"
    echo "  ██╗  ██╗ █████╗ ██╗  ██╗███████╗███████╗███╗   ███╗"
    echo "  ██║  ██║██╔══██╗██║ ██╔╝██╔════╝██╔════╝████╗ ████║"
    echo "  ███████║███████║█████╔╝ █████╗  █████╗  ██╔████╔██║"
    echo "  ██╔══██║██╔══██║██╔═██╗ ██╔══╝  ██╔══╝  ██║╚██╔╝██║"
    echo "  ██║  ██║██║  ██║██║  ██╗███████╗███████╗██║ ╚═╝ ██║"
    echo "  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝╚═╝     ╚═╝"
    echo -e "${CYAN}     Forensic & Steganography Suite v5.0${NC}"
    echo -e "${YELLOW}══════════════════════════════════════════════${NC}"
    echo -e "${GREEN}👨‍💻 Developer: Hakeem${NC}"
    echo -e "${BLUE}⚡ Version: 5.0 Professional${NC}"
    echo -e "${YELLOW}══════════════════════════════════════════════${NC}"
}

# Check tools
check_tools() {
    echo -e "${CYAN}🔍 Checking required tools...${NC}"
    
    local missing=0
    
    if ! command -v exiftool &> /dev/null; then
        echo -e "${YELLOW}📦 Installing ExifTool...${NC}"
        pkg install exiftool -y
    fi
    
    if ! command -v steghide &> /dev/null; then
        echo -e "${YELLOW}📦 Installing Steghide...${NC}"
        pkg install steghide -y
    fi
    
    if ! command -v identify &> /dev/null; then
        echo -e "${YELLOW}📦 Installing ImageMagick...${NC}"
        pkg install imagemagick -y
    fi
    
    # Create directories
    mkdir -p reports backups clean_output stego_files extracted_files
    
    echo -e "${GREEN}✅ All tools are ready!${NC}"
}

# Deep Analysis
deep_scan() {
    echo -e "${CYAN}🎯 Enter image path:${NC}"
    read image_path
    
    if [ ! -f "$image_path" ]; then
        echo -e "${RED}❌ File not found!${NC}"
        return
    fi
    
    filename=$(basename "$image_path")
    report="reports/HAKEEM_$(date +%Y%m%d_%H%M%S)_${filename%.*}.html"
    
    echo -e "${YELLOW}📊 Analyzing $filename...${NC}"
    
    # Create HTML report
    echo "<html><head><title>HAKEEM Report - $filename</title>" > "$report"
    echo "<style>body{font-family:Arial;margin:20px;background:#f5f5f5}" >> "$report"
    echo ".header{background:#2c3e50;color:white;padding:20px;border-radius:10px}" >> "$report"
    echo ".section{background:white;padding:15px;margin:10px 0;border-radius:5px}" >> "$report"
    echo "</style></head><body>" >> "$report"
    
    echo "<div class='header'>" >> "$report"
    echo "<h1>🔍 HAKEEM Forensic Report</h1>" >> "$report"
    echo "<p>File: $filename | Date: $(date)</p>" >> "$report"
    echo "</div>" >> "$report"
    
    # Basic info
    echo "<div class='section'>" >> "$report"
    echo "<h2>📄 File Information</h2>" >> "$report"
    echo "<p><strong>Name:</strong> $filename</p>" >> "$report"
    echo "<p><strong>Size:</strong> $(du -h "$image_path" | cut -f1)</p>" >> "$report"
    echo "</div>" >> "$report"
    
    # EXIF Data
    echo "<div class='section'>" >> "$report"
    echo "<h2>📸 EXIF Metadata</h2>" >> "$report"
    exiftool "$image_path" | while read line; do
        echo "<p>$line</p>" >> "$report"
    done
    echo "</div>" >> "$report"
    
    echo "</body></html>" >> "$report"
    
    echo -e "${GREEN}✅ Report created: $report${NC}"
    
    # Copy to Download folder
    if [ -d "/sdcard/Download" ]; then
        cp "$report" "/sdcard/Download/"
        echo -e "${CYAN}📱 Copied to phone: /sdcard/Download/$(basename "$report")${NC}"
    fi
}

# GPS Detection
gps_scan() {
    echo -e "${CYAN}🎯 Enter image path:${NC}"
    read image_path
    
    lat=$(exiftool -n -GPSLatitude "$image_path" 2>/dev/null | cut -d: -f2 | xargs)
    lon=$(exiftool -n -GPSLongitude "$image_path" 2>/dev/null | cut -d: -f2 | xargs)
    
    if [ -n "$lat" ] && [ -n "$lon" ]; then
        echo -e "${GREEN}📍 GPS Found!${NC}"
        echo -e "${CYAN}Latitude: $lat${NC}"
        echo -e "${CYAN}Longitude: $lon${NC}"
        echo ""
        echo -e "${YELLOW}🗺️ Map Links:${NC}"
        echo "Google Maps: https://maps.google.com/?q=$lat,$lon"
        echo "OpenStreetMap: https://www.openstreetmap.org/?mlat=$lat&mlon=$lon"
    else
        echo -e "${RED}❌ No GPS data found${NC}"
    fi
}

# Remove Metadata
clean_file() {
    echo -e "${CYAN}🎯 Enter image path:${NC}"
    read image_path
    
    backup="backups/HAKEEM_backup_$(date +%H%M%S)_$(basename "$image_path")"
    cp "$image_path" "$backup"
    
    echo -e "${YELLOW}🛡️ Cleaning metadata...${NC}"
    exiftool -all= "$image_path"
    
    clean="clean_output/HAKEEM_cleaned_$(basename "$image_path")"
    mv "$image_path" "$clean"
    
    echo -e "${GREEN}✅ Metadata removed!${NC}"
    echo -e "${BLUE}💾 Backup: $backup${NC}"
    echo -e "${GREEN}🧼 Clean file: $clean${NC}"
}

# NEW: Hide file in image (Steganography)
hide_file() {
    echo -e "${CYAN}🎯 Enter image path (cover image):${NC}"
    read cover_image
    
    if [ ! -f "$cover_image" ]; then
        echo -e "${RED}❌ Cover image not found!${NC}"
        return
    fi
    
    echo -e "${CYAN}📁 Enter file to hide (txt, zip, etc.):${NC}"
    read secret_file
    
    if [ ! -f "$secret_file" ]; then
        echo -e "${RED}❌ Secret file not found!${NC}"
        return
    fi
    
    output="stego_files/HAKEEM_stego_$(date +%H%M%S)_$(basename "$cover_image")"
    
    echo -e "${CYAN}🔐 Enter password (or press Enter for none):${NC}"
    read -s password
    
    echo -e "${YELLOW}🕵️ Hiding file in image...${NC}"
    
    if [ -z "$password" ]; then
        steghide embed -cf "$cover_image" -ef "$secret_file" -sf "$output"
    else
        steghide embed -cf "$cover_image" -ef "$secret_file" -sf "$output" -p "$password"
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ File hidden successfully!${NC}"
        echo -e "${BLUE}🔒 Stego image: $output${NC}"
        echo -e "${YELLOW}ℹ️ File size increased by: $(du -h "$secret_file" | cut -f1)${NC}"
    else
        echo -e "${RED}❌ Failed to hide file${NC}"
    fi
}

# NEW: Extract file from image
extract_file() {
    echo -e "${CYAN}🎯 Enter stego image path:${NC}"
    read stego_image
    
    if [ ! -f "$stego_image" ]; then
        echo -e "${RED}❌ Stego image not found!${NC}"
        return
    fi
    
    echo -e "${YELLOW}🔍 Checking for hidden files...${NC}"
    steghide info "$stego_image"
    
    echo -e "${CYAN}🔓 Enter password (if any):${NC}"
    read -s password
    
    output_dir="extracted_files/HAKEEM_extracted_$(date +%H%M%S)"
    mkdir -p "$output_dir"
    
    echo -e "${YELLOW}📤 Extracting hidden file...${NC}"
    
    if [ -z "$password" ]; then
        steghide extract -sf "$stego_image" -xf "$output_dir/extracted_file" 2>/dev/null
    else
        steghide extract -sf "$stego_image" -p "$password" -xf "$output_dir/extracted_file" 2>/dev/null
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ File extracted successfully!${NC}"
        echo -e "${BLUE}📁 Extracted to: $output_dir/${NC}"
        
        # Try to identify file type
        extracted_file=$(ls "$output_dir"/* 2>/dev/null | head -1)
        if [ -n "$extracted_file" ]; then
            echo -e "${CYAN}📊 File info:${NC}"
            file "$extracted_file"
        fi
    else
        echo -e "${RED}❌ Failed to extract file${NC}"
        echo -e "${YELLOW}⚠️ Wrong password or no hidden file${NC}"
    fi
}

# NEW: Add metadata bomb (fake metadata)
metadata_bomb() {
    echo -e "${CYAN}🎯 Enter image path:${NC}"
    read image_path
    
    if [ ! -f "$image_path" ]; then
        echo -e "${RED}❌ Image not found!${NC}"
        return
    fi
    
    backup="backups/HAKEEM_bomb_backup_$(basename "$image_path")"
    cp "$image_path" "$backup"
    
    echo -e "${YELLOW}💣 Adding metadata bomb...${NC}"
    
    # Add fake GPS (Egyptian pyramids)
    exiftool -GPSLatitude="29.9792" -GPSLongitude="31.1342" -GPSLatitudeRef="N" -GPSLongitudeRef="E" "$image_path"
    
    # Add fake camera info
    exiftool -Make="HAKEEM Corp" -Model="Stealth Cam X100" -SerialNumber="H4K33M-007" "$image_path"
    
    # Add fake author and copyright
    exiftool -Artist="Hakeem Security" -Copyright="© 2024 Hakeem Forensic Lab" "$image_path"
    
    # Add fake dates
    exiftool -DateTimeOriginal="2024:01:01 12:00:00" -CreateDate="2024:01:01 12:00:00" "$image_path"
    
    # Add comment
    exiftool -Comment="Analyzed by HAKEEM Forensic Tool v5.0 - https://github.com/hakim738-html" "$image_path"
    
    echo -e "${GREEN}✅ Metadata bomb added!${NC}"
    echo -e "${BLUE}💾 Original backup: $backup${NC}"
    echo -e "${YELLOW}📍 Fake GPS: 29.9792° N, 31.1342° E (Egyptian Pyramids)${NC}"
    echo -e "${YELLOW}📸 Fake Camera: HAKEEM Corp Stealth Cam X100${NC}"
}

# NEW: Quick stego check
stego_check() {
    echo -e "${CYAN}🎯 Enter image path to check:${NC}"
    read image_path
    
    echo -e "${YELLOW}🔍 Running steganalysis...${NC}"
    
    echo -e "${CYAN}1. Checking with steghide...${NC}"
    steghide info "$image_path" 2>&1 | grep -i "embedded" || echo "No steghide embedded data found"
    
    echo -e "${CYAN}2. Checking file structure...${NC}"
    strings "$image_path" | head -20
    
    echo -e "${CYAN}3. Checking file size anomalies...${NC}"
    actual_size=$(stat -c%s "$image_path" 2>/dev/null)
    echo "File size: $actual_size bytes"
    
    echo -e "${GREEN}✅ Steganalysis complete${NC}"
}

# Main Menu
main_menu() {
    while true; do
        show_banner
        check_tools
        
        echo -e "${CYAN}【1】📊 Deep Analysis + HTML Report${NC}"
        echo -e "${GREEN}【2】📍 GPS Detection & Maps${NC}"
        echo -e "${YELLOW}【3】🛡️ Remove Metadata${NC}"
        echo ""
        echo -e "${PURPLE}━━━━ STEGANOGRAPHY FEATURES ━━━━${NC}"
        echo -e "${BLUE}【4】📎 Hide File in Image${NC}"
        echo -e "${BLUE}【5】🔓 Extract File from Image${NC}"
        echo -e "${BLUE}【6】🕵️ Quick Stego Check${NC}"
        echo -e "${RED}【7】💣 Add Metadata Bomb${NC}"
        echo ""
        echo -e "${WHITE}【8】📁 Show File Browser${NC}"
        echo -e "${WHITE}【9】ℹ️ About HAKEEM${NC}"
        echo -e "${RED}【0】🚪 Exit${NC}"
        echo ""
        echo -e "${YELLOW}══════════════════════════════════════════════${NC}"
        
        read -p "➤ Select option [0-9]: " choice
        
        case $choice in
            1) deep_scan ;;
            2) gps_scan ;;
            3) clean_file ;;
            4) hide_file ;;
            5) extract_file ;;
            6) stego_check ;;
            7) metadata_bomb ;;
            8)
                echo -e "${CYAN}📁 Current directories:${NC}"
                ls -la reports/ backups/ clean_output/ stego_files/ extracted_files/ 2>/dev/null || echo "Directories are empty"
                ;;
            9)
                echo -e "${CYAN}🔥 HAKEEM Forensic & Steganography Tool v5.0${NC}"
                echo -e "${GREEN}Developed by: Hakeem${NC}"
                echo "Advanced metadata analysis and steganography tool"
                echo "Features: Metadata analysis, GPS detection, Steganography"
                echo "GitHub: github.com/hakim738-html"
                ;;
            0)
                echo -e "${GREEN}👋 Thank you for using HAKEEM Tool!${NC}"
                exit 0
                ;;
            *) echo -e "${RED}❌ Invalid option${NC}" ;;
        esac
        
        echo ""
        read -p "➤ Press Enter to continue..."
    done
}

# Start
main_menu
