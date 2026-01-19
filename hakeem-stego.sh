#!/bin/bash
# ===================================================
# 🔥 H A K E E M   S T E G A N O G R A P H Y   T O O L
# 👑 DEVELOPER: Hakeem Al-Arab
# 🎯 VERSION: 6.0 - Image Steganography & Forensics
# ===================================================

# Colors for terminal
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Directories
BASE_DIR="$HOME/Hakeem-Stego"
STEGO_DIR="$BASE_DIR/stego-images"
REPORTS_DIR="$BASE_DIR/reports"
HIDDEN_DIR="$BASE_DIR/hidden-files"
LOGS_DIR="$BASE_DIR/logs"

# Create directories
mkdir -p "$STEGO_DIR" "$REPORTS_DIR" "$HIDDEN_DIR" "$LOGS_DIR"

# ===================================================
# 🎯 DISPLAY BANNER
# ===================================================
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
    echo -e "${CYAN}│   👑 DEVELOPER: Hakeem Al-Arab                     │${NC}"
    echo -e "${CYAN}│   🌐 GITHUB: hakim738-html                         │${NC}"
    echo -e "${CYAN}│   🎯 VERSION: 6.0 - Professional Edition           │${NC}"
    echo -e "${CYAN}└────────────────────────────────────────────────────┘${NC}"
    echo ""
}

# ===================================================
# 🔍 CHECK AND INSTALL REQUIRED TOOLS
# ===================================================
check_tools() {
    echo -e "${CYAN}[*] Checking required tools...${NC}"
    
    local missing=()
    
    # Check for exiftool
    if ! command -v exiftool &> /dev/null; then
        missing+=("exiftool")
        echo -e "${YELLOW}[!] ExifTool not found${NC}"
    else
        echo -e "${GREEN}[✓] ExifTool is installed${NC}"
    fi
    
    # Check for steghide for steganography
    if ! command -v steghide &> /dev/null; then
        missing+=("steghide")
        echo -e "${YELLOW}[!] Steghide not found${NC}"
    else
        echo -e "${GREEN}[✓] Steghide is installed${NC}"
    fi
    
    # Check for strings command
    if ! command -v strings &> /dev/null; then
        echo -e "${YELLOW}[!] Strings command not found${NC}"
    else
        echo -e "${GREEN}[✓] Strings command is available${NC}"
    fi
    
    # Install missing tools
    if [ ${#missing[@]} -gt 0 ]; then
        echo -e "${YELLOW}[!] Installing missing tools...${NC}"
        pkg update -y
        for tool in "${missing[@]}"; do
            echo -e "${BLUE}[*] Installing $tool...${NC}"
            pkg install "$tool" -y
        done
    fi
    
    echo -e "${GREEN}[✓] All tools are ready!${NC}"
}

# ===================================================
# 📸 HIDE TEXT FILE IN IMAGE (STEGANOGRAPHY)
# ===================================================
hide_file_in_image() {
    echo -e "${CYAN}[*] HIDE TEXT FILE IN IMAGE${NC}"
    echo -e "${BLUE}────────────────────────────────────${NC}"
    
    # Get image path
    echo -e "${YELLOW}[?] Enter image path: ${NC}"
    echo -e "${WHITE}    Example: /sdcard/Download/photo.jpg${NC}"
    echo -ne "${GREEN}[>] ${NC}"
    read image_path
    
    if [ ! -f "$image_path" ]; then
        echo -e "${RED}[X] Error: Image not found!${NC}"
        return 1
    fi
    
    # Get text to hide
    echo -e "${YELLOW}[?] Enter text to hide (or press Enter to create file): ${NC}"
    echo -ne "${GREEN}[>] ${NC}"
    read hidden_text
    
    if [ -z "$hidden_text" ]; then
        # Create a text file with information
        timestamp=$(date +"%Y-%m-%d %H:%M:%S")
        hidden_text="=== HIDDEN DATA - HAKEEM STEGO TOOL ===
Date Created: $timestamp
Created By: Hakeem Al-Arab
Tool: Hakeem Steganography Tool v6.0
GitHub: hakim738-html

[SYSTEM INFORMATION]
Device: $(uname -o) $(uname -m)
Date: $(date)
User: $USER
IP Info: Check network settings

[SECRET MESSAGE]
This is a hidden message embedded in the image.
Only someone with the right tool can extract it.

[END OF HIDDEN DATA]"
    fi
    
    # Create hidden text file
    timestamp=$(date +"%Y%m%d_%H%M%S")
    hidden_file="$HIDDEN_DIR/hidden_data_$timestamp.txt"
    echo "$hidden_text" > "$hidden_file"
    
    # Create stego image
    stego_image="$STEGO_DIR/stego_$(basename "$image_path")"
    cp "$image_path" "$stego_image"
    
    echo -e "${YELLOW}[*] Embedding data into image...${NC}"
    
    # Use steghide to hide the file
    if command -v steghide &> /dev/null; then
        # Create a password
        password="hakeem_$(date +%s)"
        
        # Embed the file
        steghide embed -cf "$stego_image" -ef "$hidden_file" -p "$password" -sf "$stego_image.tmp" 2>/dev/null
        
        if [ $? -eq 0 ]; then
            mv "$stego_image.tmp" "$stego_image"
            echo -e "${GREEN}[✓] Data successfully hidden in image!${NC}"
            echo -e "${CYAN}[*] Password for extraction: $password${NC}"
        else
            echo -e "${RED}[X] Steghide failed, using alternative method...${NC}"
            # Alternative: append text to image
            echo "=== HIDDEN DATA ===" >> "$stego_image"
            echo "$hidden_text" >> "$stego_image"
            echo "=== END ===" >> "$stego_image"
        fi
    else
        # Simple append method
        echo -e "${YELLOW}[!] Steghide not available, using simple method${NC}"
        echo "=== HIDDEN DATA BY HAKEEM ===" >> "$stego_image"
        echo "$hidden_text" >> "$stego_image"
        echo "=== END ===" >> "$stego_image"
    fi
    
    # Copy to Download folder
    if [ -d "/sdcard/Download" ]; then
        cp "$stego_image" "/sdcard/Download/"
        echo -e "${GREEN}[✓] Stego image saved to: /sdcard/Download/${NC}"
    fi
    
    echo -e "${BLUE}[*] Original image: $image_path${NC}"
    echo -e "${GREEN}[*] Stego image: $stego_image${NC}"
    echo -e "${YELLOW}[*] Hidden file: $hidden_file${NC}"
    
    log_action "Hide File" "Hidden data in $(basename "$image_path")"
    
    return 0
}

# ===================================================
# 🔓 EXTRACT HIDDEN DATA FROM IMAGE
# ===================================================
extract_from_image() {
    echo -e "${CYAN}[*] EXTRACT HIDDEN DATA FROM IMAGE${NC}"
    echo -e "${BLUE}────────────────────────────────────${NC}"
    
    # Get image path
    echo -e "${YELLOW}[?] Enter stego image path: ${NC}"
    echo -ne "${GREEN}[>] ${NC}"
    read stego_image
    
    if [ ! -f "$stego_image" ]; then
        echo -e "${RED}[X] Error: Image not found!${NC}"
        return 1
    fi
    
    echo -e "${YELLOW}[*] Analyzing image for hidden data...${NC}"
    
    # Try to extract with steghide first
    extracted_data=""
    
    if command -v steghide &> /dev/null; then
        echo -e "${YELLOW}[?] Try password (or press Enter for auto-scan): ${NC}"
        echo -ne "${GREEN}[>] ${NC}"
        read password
        
        if [ -z "$password" ]; then
            # Try common passwords
            passwords=("hakeem" "password" "secret" "123456" "image" "stego" "")
            
            for pass in "${passages[@]}"; do
                echo -e "${BLUE}[*] Trying password: $pass${NC}"
                steghide extract -sf "$stego_image" -p "$pass" -xf "$HIDDEN_DIR/extracted_$$.txt" 2>/dev/null
                if [ $? -eq 0 ]; then
                    extracted_data=$(cat "$HIDDEN_DIR/extracted_$$.txt" 2>/dev/null)
                    echo -e "${GREEN}[✓] Data extracted with password: $pass${NC}"
                    break
                fi
            done
        else
            steghide extract -sf "$stego_image" -p "$password" -xf "$HIDDEN_DIR/extracted_$$.txt" 2>/dev/null
            if [ $? -eq 0 ]; then
                extracted_data=$(cat "$HIDDEN_DIR/extracted_$$.txt" 2>/dev/null)
                echo -e "${GREEN}[✓] Data extracted successfully!${NC}"
            fi
        fi
    fi
    
    # If steghide didn't work, try strings command
    if [ -z "$extracted_data" ]; then
        echo -e "${YELLOW}[*] Trying strings extraction...${NC}"
        extracted_data=$(strings "$stego_image" | grep -A 20 -B 5 "HIDDEN\|SECRET\|HAKEEM")
        
        if [ -z "$extracted_data" ]; then
            # Get last 1000 characters of file
            extracted_data=$(tail -c 1000 "$stego_image" | strings)
        fi
    fi
    
    if [ -z "$extracted_data" ]; then
        echo -e "${RED}[X] No hidden data found in image${NC}"
        return 1
    fi
    
    # Save extracted data
    timestamp=$(date +"%Y%m%d_%H%M%S")
    extracted_file="$HIDDEN_DIR/extracted_$timestamp.txt"
    echo "$extracted_data" > "$extracted_file"
    
    echo -e "${GREEN}[✓] Hidden data extracted!${NC}"
    echo -e "${CYAN}[*] Extracted data saved to: $extracted_file${NC}"
    
    # Display first few lines
    echo -e "${BLUE}────────────────────────────────────${NC}"
    echo -e "${WHITE}EXTRACTED DATA:${NC}"
    echo "$extracted_data" | head -20
    echo -e "${BLUE}────────────────────────────────────${NC}"
    
    log_action "Extract Data" "Extracted from $(basename "$stego_image")"
    
    return 0
}

# ===================================================
# 🔍 FORENSIC ANALYSIS OF IMAGE (HTML REPORT)
# ===================================================
forensic_analysis() {
    echo -e "${CYAN}[*] FORENSIC ANALYSIS OF IMAGE${NC}"
    echo -e "${BLUE}────────────────────────────────────${NC}"
    
    # Get image path
    echo -e "${YELLOW}[?] Enter image path for analysis: ${NC}"
    echo -e "${WHITE}    Example: /sdcard/Download/photo.jpg${NC}"
    echo -ne "${GREEN}[>] ${NC}"
    read image_path
    
    if [ ! -f "$image_path" ]; then
        echo -e "${RED}[X] Error: Image not found!${NC}"
        return 1
    fi
    
    echo -e "${YELLOW}[*] Performing forensic analysis...${NC}"
    
    # Get image information
    filename=$(basename "$image_path")
    filesize=$(du -h "$image_path" | cut -f1)
    timestamp=$(date +"%Y%m%d_%H%M%S")
    
    # Extract EXIF data
    echo -e "${BLUE}[*] Extracting EXIF data...${NC}"
    exif_data=$(exiftool "$image_path" 2>/dev/null)
    
    # Extract specific information
    make=$(echo "$exif_data" | grep -i "make" | head -1 | cut -d: -f2- | xargs)
    model=$(echo "$exif_data" | grep -i "model" | head -1 | cut -d: -f2- | xargs)
    datetime=$(echo "$exif_data" | grep -i "date" | head -1 | cut -d: -f2- | xargs)
    gps_lat=$(exiftool -n -GPSLatitude "$image_path" 2>/dev/null | awk -F': ' '{print $2}' | xargs)
    gps_lon=$(exiftool -n -GPSLongitude "$image_path" 2>/dev/null | awk -F': ' '{print $2}' | xargs)
    software=$(echo "$exif_data" | grep -i "software" | head -1 | cut -d: -f2- | xargs)
    
    # Check for hidden data
    echo -e "${BLUE}[*] Checking for hidden data...${NC}"
    hidden_data=$(strings "$image_path" | grep -i -E "hidden|secret|password|stego|hakeem" | head -5)
    
    # Create HTML report
    html_file="$REPORTS_DIR/forensic_report_${filename%.*}_$timestamp.html"
    
    echo -e "${BLUE}[*] Creating HTML report...${NC}"
    
    # Start HTML file
    cat > "$html_file" << HTML
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forensic Report - $filename</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            color: #333;
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.3);
        }
        
        .header {
            background: linear-gradient(90deg, #ff0000, #ff9900);
            color: white;
            padding: 40px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: linear-gradient(90deg, #00dbde, #fc00ff);
        }
        
        .header h1 {
            font-size: 2.8rem;
            margin-bottom: 15px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        
        .developer {
            font-size: 1.5rem;
            margin-top: 10px;
            color: #ffcc00;
            font-weight: bold;
        }
        
        .section {
            padding: 30px;
            border-bottom: 1px solid #eee;
        }
        
        .section-title {
            color: #ff0000;
            font-size: 1.8rem;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 3px solid #ff0000;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .section-title i {
            font-size: 1.5rem;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        
        .info-card {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 12px;
            border-left: 6px solid #3498db;
            transition: transform 0.3s, box-shadow 0.3s;
        }
        
        .info-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        
        .info-card.danger {
            border-left-color: #e74c3c;
            background: #ffeaea;
        }
        
        .info-card.warning {
            border-left-color: #f39c12;
            background: #fff3cd;
        }
        
        .info-card.success {
            border-left-color: #2ecc71;
            background: #eaffea;
        }
        
        .label {
            font-weight: bold;
            color: #2c3e50;
            display: block;
            margin-bottom: 8px;
            font-size: 1.1rem;
        }
        
        .value {
            color: #7f8c8d;
            font-size: 1.2rem;
            word-break: break-word;
        }
        
        .exif-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .exif-table th {
            background: linear-gradient(90deg, #3498db, #2980b9);
            color: white;
            padding: 18px;
            text-align: left;
            font-weight: bold;
        }
        
        .exif-table td {
            padding: 15px;
            border-bottom: 1px solid #eee;
        }
        
        .exif-table tr:nth-child(even) {
            background: #f8f9fa;
        }
        
        .exif-table tr:hover {
            background: #e3f2fd;
        }
        
        .map-links {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            margin-top: 20px;
        }
        
        .map-btn {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            background: linear-gradient(45deg, #3498db, #2980b9);
            color: white;
            padding: 15px 25px;
            border-radius: 10px;
            text-decoration: none;
            font-weight: bold;
            transition: all 0.3s;
        }
        
        .map-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(52, 152, 219, 0.3);
        }
        
        .map-btn.danger {
            background: linear-gradient(45deg, #e74c3c, #c0392b);
        }
        
        .footer {
            background: #2c3e50;
            color: white;
            padding: 40px;
            text-align: center;
        }
        
        .footer h3 {
            color: #ff9900;
            margin-bottom: 20px;
            font-size: 1.5rem;
        }
        
        .tools-used {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin: 20px 0;
            flex-wrap: wrap;
        }
        
        .tool-badge {
            background: rgba(255,255,255,0.1);
            padding: 10px 20px;
            border-radius: 50px;
            font-size: 0.9rem;
        }
        
        @media (max-width: 768px) {
            .header h1 {
                font-size: 2rem;
            }
            
            .info-grid {
                grid-template-columns: 1fr;
            }
            
            .exif-table {
                font-size: 0.9rem;
            }
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-microscope"></i> FORENSIC ANALYSIS REPORT</h1>
            <p>Complete Image Metadata & Steganography Analysis</p>
            <div class="developer">
                <i class="fas fa-crown"></i> DEVELOPER: HAKEEM AL-ARAB
            </div>
        </div>
        
        <div class="section">
            <h2 class="section-title"><i class="fas fa-file-image"></i> IMAGE INFORMATION</h2>
            <div class="info-grid">
                <div class="info-card">
                    <span class="label"><i class="fas fa-file"></i> File Name</span>
                    <span class="value">$filename</span>
                </div>
                <div class="info-card">
                    <span class="label"><i class="fas fa-weight-hanging"></i> File Size</span>
                    <span class="value">$filesize</span>
                </div>
                <div class="info-card">
                    <span class="label"><i class="fas fa-folder"></i> File Path</span>
                    <span class="value">$image_path</span>
                </div>
            </div>
        </div>
        
        <div class="section">
            <h2 class="section-title"><i class="fas fa-camera"></i> CAMERA & DEVICE INFORMATION</h2>
            <div class="info-grid">
                <div class="info-card">
                    <span class="label"><i class="fas fa-camera-retro"></i> Device Make</span>
                    <span class="value">${make:-Not Available}</span>
                </div>
                <div class="info-card">
                    <span class="label"><i class="fas fa-mobile-alt"></i> Device Model</span>
                    <span class="value">${model:-Not Available}</span>
                </div>
                <div class="info-card">
                    <span class="label"><i class="fas fa-calendar-alt"></i> Date & Time</span>
                    <span class="value">${datetime:-Not Available}</span>
                </div>
                <div class="info-card">
                    <span class="label"><i class="fas fa-code"></i> Software Used</span>
                    <span class="value">${software:-Not Available}</span>
                </div>
            </div>
        </div>
HTML

    # Add GPS section if available
    if [ -n "$gps_lat" ] && [ -n "$gps_lon" ]; then
        cat >> "$html_file" << GPS
        <div class="section">
            <h2 class="section-title"><i class="fas fa-map-marker-alt"></i> LOCATION DATA (GPS)</h2>
            <div class="info-card danger">
                <span class="label"><i class="fas fa-exclamation-triangle"></i> SECURITY WARNING</span>
                <span class="value">This image contains GPS coordinates that can reveal exact location</span>
            </div>
            <div class="info-grid" style="margin-top: 20px;">
                <div class="info-card danger">
                    <span class="label"><i class="fas fa-globe-americas"></i> Latitude</span>
                    <span class="value">$gps_lat</span>
                </div>
                <div class="info-card danger">
                    <span class="label"><i class="fas fa-globe-americas"></i> Longitude</span>
                    <span class="value">$gps_lon</span>
                </div>
            </div>
            <div class="map-links">
                <a href="https://maps.google.com/?q=$gps_lat,$gps_lon" class="map-btn" target="_blank">
                    <i class="fab fa-google"></i> View on Google Maps
                </a>
                <a href="https://www.openstreetmap.org/?mlat=$gps_lat&mlon=$gps_lon" class="map-btn" target="_blank">
                    <i class="fas fa-map"></i> View on OpenStreetMap
                </a>
            </div>
        </div>
GPS
    else
        cat >> "$html_file" << NOGPS
        <div class="section">
            <h2 class="section-title"><i class="fas fa-map-marker-alt"></i> LOCATION DATA (GPS)</h2>
            <div class="info-card success">
                <span class="label"><i class="fas fa-shield-alt"></i> SECURITY STATUS</span>
                <span class="value">No GPS data found in this image</span>
            </div>
        </div>
NOGPS
    fi

    # Add steganography analysis
    if [ -n "$hidden_data" ]; then
        cat >> "$html_file" << STEGO
        <div class="section">
            <h2 class="section-title"><i class="fas fa-user-secret"></i> STEGANOGRAPHY ANALYSIS</h2>
            <div class="info-card warning">
                <span class="label"><i class="fas fa-exclamation-circle"></i> HIDDEN DATA DETECTED</span>
                <span class="value">This image may contain hidden or embedded data</span>
            </div>
            <div class="info-card" style="margin-top: 20px;">
                <span class="label"><i class="fas fa-search"></i> Suspicious Strings Found</span>
                <span class="value"><pre style="background: #f5f5f5; padding: 15px; border-radius: 5px; overflow-x: auto;">$hidden_data</pre></span>
            </div>
        </div>
STEGO
    else
        cat >> "$html_file" << NOSTEGO
        <div class="section">
            <h2 class="section-title"><i class="fas fa-user-secret"></i> STEGANOGRAPHY ANALYSIS</h2>
            <div class="info-card success">
                <span class="label"><i class="fas fa-check-circle"></i> ANALYSIS RESULT</span>
                <span class="value">No obvious hidden data detected in this image</span>
            </div>
        </div>
NOSTEGO
    fi

    # Add EXIF data table
    cat >> "$html_file" << EXIF
        <div class="section">
            <h2 class="section-title"><i class="fas fa-database"></i> COMPLETE EXIF METADATA</h2>
            <div style="overflow-x: auto;">
                <table class="exif-table">
                    <thead>
                        <tr>
                            <th>TAG</th>
                            <th>VALUE</th>
                        </tr>
                    </thead>
                    <tbody>
EXIF

    # Add EXIF data rows
    exiftool "$image_path" 2>/dev/null | while read -r line; do
        if [ -n "$line" ]; then
            tag=$(echo "$line" | cut -d: -f1 | xargs)
            value=$(echo "$line" | cut -d: -f2- | xargs | sed 's/</\&lt;/g; s/>/\&gt;/g')
            
            # Truncate long values
            if [ ${#value} -gt 100 ]; then
                value="${value:0:100}..."
            fi
            
            cat >> "$html_file" << ROW
                        <tr>
                            <td><strong>$tag</strong></td>
                            <td>$value</td>
                        </tr>
ROW
        fi
    done

    # Close HTML
    cat >> "$html_file" << FOOTER
                    </tbody>
                </table>
            </div>
        </div>
        
        <div class="footer">
            <h3><i class="fas fa-tools"></i> FORENSIC TOOLS USED</h3>
            <div class="tools-used">
                <div class="tool-badge">ExifTool</div>
                <div class="tool-badge">Steghide</div>
                <div class="tool-badge">Strings Analysis</div>
                <div class="tool-badge">Binary Analysis</div>
            </div>
            
            <div style="margin: 30px 0;">
                <h3 style="color: #ffcc00;">
                    <i class="fas fa-crown"></i> REPORT GENERATED BY HAKEEM STEGANOGRAPHY TOOL
                </h3>
                <p style="margin: 10px 0; font-size: 1.2rem;">
                    <i class="fas fa-user"></i> Developer: Hakeem Al-Arab
                </p>
                <p style="margin: 10px 0;">
                    <i class="fab fa-github"></i> GitHub: <a href="https://github.com/hakim738-html" style="color: #3498db;">hakim738-html</a>
                </p>
                <p style="margin: 10px 0;">
                    <i class="fas fa-calendar"></i> Report Date: $(date '+%Y-%m-%d %H:%M:%S')
                </p>
            </div>
            
            <div style="background: rgba(255,255,255,0.1); padding: 20px; border-radius: 10px; margin-top: 20px;">
                <p style="font-size: 0.9rem;">
                    <i class="fas fa-exclamation-triangle"></i> 
                    <strong>LEGAL DISCLAIMER:</strong> This tool is for educational purposes, legitimate forensic analysis, 
                    and security research only. Never use for illegal activities.
                </p>
            </div>
        </div>
    </div>
    
    <script>
        // Add some interactivity
        document.addEventListener('DOMContentLoaded', function() {
            // Add click event to info cards
            const cards = document.querySelectorAll('.info-card');
            cards.forEach(card => {
                card.addEventListener('click', function() {
                    this.style.transform = 'scale(0.98)';
                    setTimeout(() => {
                        this.style.transform = '';
                    }, 150);
                });
            });
            
            // Print button functionality
            const printBtn = document.createElement('button');
            printBtn.innerHTML = '<i class="fas fa-print"></i> Print Report';
            printBtn.style.cssText = \`
                position: fixed;
                bottom: 20px;
                right: 20px;
                background: #3498db;
                color: white;
                border: none;
                padding: 15px 25px;
                border-radius: 50px;
                cursor: pointer;
                font-size: 16px;
                box-shadow: 0 5px 15px rgba(52, 152, 219, 0.3);
                z-index: 1000;
            \`;
            printBtn.onclick = () => window.print();
            document.body.appendChild(printBtn);
        });
    </script>
</body>
</html>
FOOTER

    echo -e "${GREEN}[✓] Forensic report created successfully!${NC}"
    echo -e "${CYAN}[*] Report saved to: $html_file${NC}"
    
    # Copy to Download folder
    if [ -d "/sdcard/Download" ]; then
        cp "$html_file" "/sdcard/Download/"
        echo -e "${GREEN}[✓] Report copied to: /sdcard/Download/${NC}"
    fi
    
    # Display report info
    echo ""
    echo -e "${YELLOW}📊 REPORT SUMMARY:${NC}"
    echo "  📷 Device: ${make:-Unknown} ${model:-Unknown}"
    echo "  📍 GPS: $(if [ -n "$gps_lat" ]; then echo "✅ Found"; else echo "❌ Not found"; fi)"
    echo "  🔍 Hidden Data: $(if [ -n "$hidden_data" ]; then echo "✅ Detected"; else echo "❌ Not detected"; fi)"
    echo "  📏 File Size: $filesize"
    echo ""
    echo -e "${BLUE}[*] TO VIEW REPORT:${NC}"
    echo "  📱 On Phone: Open File Manager → Download folder"
    echo "  💻 In Browser: Open the HTML file"
    
    # Try to open the report
    if command -v termux-open &> /dev/null; then
        echo -e "${YELLOW}[*] Opening report in browser...${NC}"
        termux-open "$html_file" 2>/dev/null &
    fi
    
    log_action "Forensic Analysis" "Created report for $(basename "$image_path")"
    
    return 0
}

# ===================================================
# 📝 LOG ACTIONS
# ===================================================
log_action() {
    local action="$1"
    local details="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local log_file="$LOGS_DIR/activity.log"
    
    echo "[$timestamp] $action: $details" >> "$log_file"
    
    # Display in terminal
    echo -e "${PURPLE}════════════════════════════════════════${NC}"
    echo -e "${CYAN}[📝 LOG] ${WHITE}$timestamp${NC}"
    echo -e "${GREEN}Action:${NC} $action"
    echo -e "${YELLOW}Details:${NC} $details"
    echo -e "${PURPLE}════════════════════════════════════════${NC}"
}

# ===================================================
# 📋 MAIN MENU
# ===================================================
main_menu() {
    # Check tools on startup
    check_tools
    
    while true; do
        show_banner
        
        echo -e "${CYAN}══════════════════════════════════════════════════════${NC}"
        echo -e "${WHITE}               H A K E E M   M E N U                  ${NC}"
        echo -e "${CYAN}══════════════════════════════════════════════════════${NC}"
        echo ""
        echo -e "${GREEN}[1] 📸 HIDE TEXT IN IMAGE (Steganography)"
        echo -e "[2] 🔓 EXTRACT HIDDEN DATA FROM IMAGE"
        echo -e "[3] 🔍 FORENSIC ANALYSIS (Create HTML Report)"
        echo -e "[4] 📁 VIEW STEGO IMAGES"
        echo -e "[5] 📁 VIEW REPORTS"
        echo -e "[6] 📁 VIEW HIDDEN FILES"
        echo -e "[7] 📊 SYSTEM INFORMATION"
        echo -e "${RED}[0] 🚪 EXIT"
        echo -e "${NC}"
        echo -e "${CYAN}══════════════════════════════════════════════════════${NC}"
        
        echo -e "${YELLOW}[?] SELECT OPTION: ${NC}\c"
        read choice
        
        case $choice in
            1)
                hide_file_in_image
                ;;
            2)
                extract_from_image
                ;;
            3)
                forensic_analysis
                ;;
            4)
                echo -e "${CYAN}[*] Stego Images:${NC}"
                ls -lt "$STEGO_DIR"/* 2>/dev/null | head -10 | awk '{print $9}'
                echo ""
                ;;
            5)
                echo -e "${CYAN}[*] Forensic Reports:${NC}"
                ls -lt "$REPORTS_DIR"/*.html 2>/dev/null | head -10 | awk '{print $9}'
                echo ""
                ;;
            6)
                echo -e "${CYAN}[*] Hidden Files:${NC}"
                ls -lt "$HIDDEN_DIR"/*.txt 2>/dev/null | head -10 | awk '{print $9}'
                echo ""
                ;;
            7)
                echo -e "${CYAN}[*] System Info:${NC}"
                echo "  OS: $(uname -o)"
                echo "  Storage: $(df -h . | tail -1 | awk '{print $4}') free"
                echo "  Tool: Hakeem Steganography v6.0"
                echo "  Developer: Hakeem Al-Arab"
                ;;
            0)
                echo -e "${GREEN}[✓] Thank you for using Hakeem Steganography Tool!${NC}"
                echo -e "${YELLOW}[*] GitHub: hakim738-html${NC}"
                echo -e "${RED}👑 Developed by Hakeem Al-Arab${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}[X] Invalid option!${NC}"
                ;;
        esac
        
        echo ""
        echo -e "${YELLOW}[!] PRESS ENTER TO CONTINUE...${NC}"
        read
    done
}

# ===================================================
# 🚀 START TOOL
# ===================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Clear screen and start
    clear
    echo -e "${GREEN}[*] Starting Hakeem Steganography Tool v6.0...${NC}"
    sleep 1
    main_menu
fi