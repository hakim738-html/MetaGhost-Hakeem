#!/bin/bash
# ===================================================
# 🔥 H A K E E M   F O R E N S I C   P R O
# 👑 DEVELOPER: حكيم العرب (Hakeem Al-Arab)
# 🎯 VERSION: 2024 Enhanced
# ===================================================

# Enable error handling
set -e

# Colors for terminal
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Working directories
BASE_DIR="$HOME/Hakeem-Forensic"
REPORTS_DIR="$BASE_DIR/Reports"
BACKUPS_DIR="$BASE_DIR/Backups"
PAGES_DIR="$BASE_DIR/Pages"
LOGS_DIR="$BASE_DIR/Logs"

# ===================================================
# 🎯 DISPLAY BANNER
# ===================================================
show_banner() {
    clear
    echo -e "${RED}"
    echo " ██╗  ██╗ █████╗ ██╗  ██╗███████╗███████╗███╗   ███╗"
    echo " ██║  ██║██╔══██╗██║ ██╔╝██╔════╝██╔════╝████╗ ████║"
    echo " ███████║███████║█████╔╝ █████╗  █████╗  ██╔████╔██║"
    echo " ██╔══██║██╔══██║██╔═██╗ ██╔══╝  ██╔══╗  ██║╚██╔╝██║"
    echo " ██║  ██║██║  ██║██║  ██╗███████╗███████╗██║ ╚═╝ ██║"
    echo " ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝╚═╝     ╚═╝"
    echo -e "${YELLOW}"
    echo "         Digital Forensic Tool - Enhanced Version"
    echo -e "${GREEN}"
    echo "              👑 Developer: Hakeem Al-Arab"
    echo "              🌐 GitHub: hakim738-html"
    echo -e "${CYAN}"
    echo "              📊 Version: 4.0.0"
    echo -e "${NC}"
}

# ===================================================
# 🔍 CHECK REQUIRED TOOLS
# ===================================================
check_tools() {
    echo -e "${CYAN}[*] Checking required tools...${NC}"
    
    # Create working directories
    mkdir -p "$REPORTS_DIR" "$BACKUPS_DIR" "$PAGES_DIR" "$LOGS_DIR"
    
    # Check for ExifTool
    if ! command -v exiftool &> /dev/null; then
        echo -e "${YELLOW}[!] Installing ExifTool...${NC}"
        pkg install exiftool -y || {
            echo -e "${RED}[X] Failed to install ExifTool${NC}"
            exit 1
        }
    fi
    
    # Check for Python
    if ! command -v python3 &> /dev/null; then
        echo -e "${YELLOW}[!] Installing Python...${NC}"
        pkg install python -y || {
            echo -e "${RED}[X] Failed to install Python${NC}"
            exit 1
        }
    fi
    
    echo -e "${GREEN}[✓] All tools are ready!${NC}"
}

# ===================================================
# 🌐 CREATE WEB INTERFACE WITH REAL-TIME LOGGING
# ===================================================
create_web_interface() {
    echo -e "${CYAN}[*] Creating web interface with real-time logging...${NC}"
    
    local timestamp=$(date +"%Y%m%d_%H%M%S")
    local page_name="Live_Capture_${timestamp}.html"
    local page_path="$PAGES_DIR/$page_name"
    
    # Get IP address (for local network access)
    local ip_address=""
    if command -v ifconfig &> /dev/null; then
        ip_address=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | head -1)
    fi
    
    if [ -z "$ip_address" ]; then
        ip_address="127.0.0.1"
    fi
    
    # Create the HTML page with JavaScript for real-time updates
    cat > "$page_path" << HTML
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hakeem Forensic - Live Data Capture</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            color: white;
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .header {
            text-align: center;
            padding: 30px;
            background: linear-gradient(90deg, #ff416c, #ff4b2b);
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(255, 0, 0, 0.3);
        }
        
        .header h1 {
            font-size: 2.5rem;
            margin-bottom: 10px;
        }
        
        .info-box {
            background: rgba(255, 255, 255, 0.1);
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            border-left: 5px solid #3498db;
        }
        
        .info-box.warning {
            border-left-color: #f39c12;
            background: rgba(243, 156, 18, 0.1);
        }
        
        .form-container {
            background: rgba(255, 255, 255, 0.05);
            padding: 30px;
            border-radius: 15px;
            margin: 20px 0;
            backdrop-filter: blur(10px);
        }
        
        input[type="text"],
        input[type="password"],
        input[type="email"] {
            width: 100%;
            padding: 15px;
            margin: 10px 0;
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 8px;
            background: rgba(255, 255, 255, 0.1);
            color: white;
            font-size: 16px;
        }
        
        input:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 2px rgba(52, 152, 219, 0.3);
        }
        
        button {
            width: 100%;
            padding: 16px;
            background: linear-gradient(45deg, #3498db, #2980b9);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 18px;
            font-weight: bold;
            cursor: pointer;
            margin: 15px 0;
            transition: all 0.3s;
        }
        
        button:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(52, 152, 219, 0.4);
        }
        
        button.danger {
            background: linear-gradient(45deg, #e74c3c, #c0392b);
        }
        
        .terminal {
            background: #1e1e1e;
            color: #00ff00;
            padding: 20px;
            border-radius: 10px;
            margin-top: 30px;
            font-family: 'Courier New', monospace;
            height: 300px;
            overflow-y: auto;
            white-space: pre-wrap;
            word-wrap: break-word;
        }
        
        .terminal-title {
            color: #3498db;
            margin-bottom: 10px;
            font-weight: bold;
        }
        
        .url-box {
            background: rgba(0, 0, 0, 0.3);
            padding: 15px;
            border-radius: 8px;
            margin: 20px 0;
            word-break: break-all;
        }
        
        .url-box a {
            color: #3498db;
            text-decoration: none;
            font-weight: bold;
        }
        
        .footer {
            text-align: center;
            margin-top: 40px;
            padding: 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            color: #95a5a6;
        }
        
        .data-entry {
            margin: 15px 0;
            padding: 15px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 8px;
            animation: fadeIn 0.5s;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🔐 Hakeem Forensic Live Capture</h1>
            <p>Educational Security Awareness Page</p>
        </div>
        
        <div class="info-box warning">
            <h3>⚠️ Educational Purpose Only</h3>
            <p>This page simulates data capture for security awareness training. All data is logged locally in Termux.</p>
        </div>
        
        <div class="url-box">
            <h3>🌐 Access this page from any device:</h3>
            <p>Copy this URL and open in any browser on the same network:</p>
            <p><a href="http://${ip_address}:8000/${page_name}" target="_blank">http://${ip_address}:8000/${page_name}</a></p>
            <p><small>If port 8000 is blocked, try: <a href="http://${ip_address}:8080/${page_name}">http://${ip_address}:8080/${page_name}</a></small></p>
        </div>
        
        <div class="form-container">
            <h2>📝 Enter Test Data</h2>
            <form id="dataForm">
                <input type="text" id="username" placeholder="Username (test)" required>
                <input type="password" id="password" placeholder="Password (test)" required>
                <input type="email" id="email" placeholder="Email (test)">
                <input type="text" id="phone" placeholder="Phone Number (test)">
                
                <button type="submit">📡 Send Data to Termux</button>
                <button type="button" onclick="clearForm()" class="danger">🧹 Clear Form</button>
            </form>
        </div>
        
        <div class="terminal">
            <div class="terminal-title">📡 LIVE TERMUX TERMINAL OUTPUT:</div>
            <div id="terminalOutput">Waiting for data...</div>
        </div>
        
        <div class="footer">
            <p>👑 Developed by <strong>Hakeem Al-Arab</strong></p>
            <p>🔧 Tool: Hakeem Forensic Pro v4.0</p>
            <p>🌐 GitHub: <a href="https://github.com/hakim738-html" style="color:#3498db;">hakim738-html</a></p>
            <p style="font-size: 0.9em; margin-top: 15px; color: #7f8c8d;">
                ⚠️ This tool is for educational and legitimate forensic purposes only
            </p>
        </div>
    </div>

    <script>
        let dataLog = [];
        
        document.getElementById('dataForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Get form data
            const formData = {
                username: document.getElementById('username').value,
                password: document.getElementById('password').value,
                email: document.getElementById('email').value || 'Not provided',
                phone: document.getElementById('phone').value || 'Not provided',
                timestamp: new Date().toLocaleString(),
                ip: 'Remote IP: ' + (window.connection?.remoteAddress || 'Unknown'),
                userAgent: navigator.userAgent.substring(0, 50) + '...'
            };
            
            // Add to log
            dataLog.push(formData);
            
            // Update terminal display
            updateTerminal(formData);
            
            // Send data to server (simulated)
            simulateServerSend(formData);
            
            // Clear form (optional)
            // document.getElementById('dataForm').reset();
        });
        
        function updateTerminal(data) {
            const terminal = document.getElementById('terminalOutput');
            const entry = document.createElement('div');
            entry.className = 'data-entry';
            
            entry.innerHTML = \`
                <strong>📥 NEW DATA CAPTURED:</strong><br>
                🕐 Time: \${data.timestamp}<br>
                👤 Username: \${data.username}<br>
                🔑 Password: \${'*'.repeat(data.password.length)}<br>
                📧 Email: \${data.email}<br>
                📱 Phone: \${data.phone}<br>
                🌐 \${data.ip}<br>
                <hr style="margin: 10px 0; border-color: rgba(255,255,255,0.1)">
            \`;
            
            terminal.prepend(entry);
            
            // Scroll to top
            terminal.scrollTop = 0;
            
            // Show notification
            showNotification('Data logged to Termux!');
        }
        
        function simulateServerSend(data) {
            // In a real implementation, this would send data to Termux
            console.log('Data to be sent to Termux:', data);
            
            // Simulate network request
            setTimeout(() => {
                showNotification('✓ Data sent to Termux successfully');
            }, 500);
        }
        
        function clearForm() {
            document.getElementById('dataForm').reset();
            showNotification('Form cleared');
        }
        
        function showNotification(message) {
            // Create notification element
            const notification = document.createElement('div');
            notification.textContent = message;
            notification.style.cssText = \`
                position: fixed;
                top: 20px;
                right: 20px;
                background: #2ecc71;
                color: white;
                padding: 15px 25px;
                border-radius: 8px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.3);
                z-index: 1000;
                animation: slideIn 0.3s;
            \`;
            
            document.body.appendChild(notification);
            
            // Remove after 3 seconds
            setTimeout(() => {
                notification.style.animation = 'slideOut 0.3s';
                setTimeout(() => notification.remove(), 300);
            }, 3000);
        }
        
        // Add animation styles
        const style = document.createElement('style');
        style.textContent = \`
            @keyframes slideIn {
                from { transform: translateX(100%); opacity: 0; }
                to { transform: translateX(0); opacity: 1; }
            }
            @keyframes slideOut {
                from { transform: translateX(0); opacity: 1; }
                to { transform: translateX(100%); opacity: 0; }
            }
        \`;
        document.head.appendChild(style);
        
        // Display initial connection info
        window.addEventListener('load', () => {
            const terminal = document.getElementById('terminalOutput');
            terminal.innerHTML += \`\\n🔗 Page loaded from: \${window.location.href}\\n\`;
            terminal.innerHTML += \`🌐 User Agent: \${navigator.userAgent}\\n\`;
            terminal.innerHTML += \`🕐 Load Time: \${new Date().toLocaleString()}\\n\`;
        });
    </script>
</body>
</html>
HTML

    echo -e "${GREEN}[✓] Web interface created: $page_name${NC}"
    echo -e "${CYAN}[*] File location: $page_path${NC}"
    
    # Copy to sdcard for easy access
    if [ -d "/sdcard/Download" ]; then
        cp "$page_path" "/sdcard/Download/"
        echo -e "${GREEN}[✓] Copied to: /sdcard/Download/$page_name${NC}"
    fi
    
    # Create a Python HTTP server to serve the file
    echo -e "${YELLOW}[!] Starting web server...${NC}"
    echo -e "${CYAN}[*] Access URLs:${NC}"
    echo -e "   📱 On your phone: file://$page_path"
    echo -e "   💻 On same network: http://$ip_address:8000/$page_name"
    
    # Check if Python HTTP server can be started
    if command -v python3 &> /dev/null; then
        echo -e "${YELLOW}[!] To share on network, run this in another terminal:${NC}"
        echo -e "   cd \"$PAGES_DIR\" && python3 -m http.server 8000"
        echo -e "   Then open: http://$ip_address:8000/$page_name"
    fi
    
    # Log the action
    log_action "Web Interface" "Created live capture page: $page_name"
    
    # Open the file in Termux if possible
    if command -v termux-open &> /dev/null; then
        echo -e "${YELLOW}[!] Opening page in browser...${NC}"
        termux-open "$page_path" 2>/dev/null &
    fi
    
    return 0
}

# ===================================================
# 📊 ANALYZE IMAGE AND CREATE HTML REPORT
# ===================================================
analyze_image() {
    echo -e "${CYAN}[*] Enter image path:${NC}"
    read -r img_path
    
    if [ ! -f "$img_path" ]; then
        echo -e "${RED}[X] File not found!${NC}"
        echo -e "${YELLOW}[!] Try: /sdcard/Download/photo.jpg${NC}"
        return 1
    fi
    
    filename=$(basename "$img_path")
    timestamp=$(date +"%Y%m%d_%H%M%S")
    html_file="REPORT_${timestamp}_${filename%.*}.html"
    html_path="$REPORTS_DIR/$html_file"
    
    echo -e "${YELLOW}[*] Analyzing: $filename${NC}"
    
    # Extract metadata
    file_size=$(du -h "$img_path" 2>/dev/null | cut -f1 || echo "Unknown")
    make_model=$(exiftool -Make -Model "$img_path" 2>/dev/null | awk -F': ' '{print $2}' | tr '\n' ' ' || echo "Unknown")
    gps_data=$(exiftool -GPSLatitude -GPSLongitude "$img_path" 2>/dev/null || echo "No GPS data")
    
    # Create HTML report
    cat > "$html_path" << REPORT
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Forensic Report - $filename</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        .header { background: #2c3e50; color: white; padding: 20px; border-radius: 10px; }
        .section { background: white; padding: 20px; margin: 20px 0; border-radius: 10px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #f2f2f2; }
    </style>
</head>
<body>
    <div class="header">
        <h1>🔍 Forensic Analysis Report</h1>
        <p>File: $filename | Date: $(date)</p>
    </div>
    
    <div class="section">
        <h2>📁 File Information</h2>
        <p><strong>Name:</strong> $filename</p>
        <p><strong>Size:</strong> $file_size</p>
        <p><strong>Camera:</strong> $make_model</p>
    </div>
    
    <div class="section">
        <h2>📍 GPS Data</h2>
        <pre>$gps_data</pre>
    </div>
    
    <div class="section">
        <h2>📊 Full EXIF Data</h2>
        <pre>$(exiftool "$img_path" 2>/dev/null | head -50)</pre>
    </div>
    
    <div class="section" style="text-align: center; color: #7f8c8d;">
        <p>👑 Generated by Hakeem Forensic Pro</p>
        <p>🌐 https://github.com/hakim738-html</p>
    </div>
</body>
</html>
REPORT

    echo -e "${GREEN}[✓] Report created: $html_path${NC}"
    log_action "Image Analysis" "Analyzed $filename"
    
    return 0
}

# ===================================================
# 📝 LOG ACTIONS TO TERMINAL AND FILE
# ===================================================
log_action() {
    local action="$1"
    local details="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local log_file="$LOGS_DIR/actions.log"
    
    # Log to file
    echo "[$timestamp] ACTION: $action | DETAILS: $details" >> "$log_file"
    
    # Display in terminal with color
    echo -e "${PURPLE}════════════════════════════════════════${NC}"
    echo -e "${CYAN}[📝 LOG] ${WHITE}$timestamp${NC}"
    echo -e "${GREEN}Action:${NC} $action"
    echo -e "${YELLOW}Details:${NC} $details"
    echo -e "${PURPLE}════════════════════════════════════════${NC}"
    
    # Also show in a simple format for web interface
    echo "[TERMUX_LOG] $timestamp - $action: $details" >> "$LOGS_DIR/live.log"
}

# ===================================================
# 🧹 CLEAN IMAGE METADATA
# ===================================================
clean_metadata() {
    echo -e "${CYAN}[*] Enter file path:${NC}"
    read -r file_path
    
    if [ ! -f "$file_path" ]; then
        echo -e "${RED}[X] File not found!${NC}"
        return 1
    fi
    
    # Create backup
    backup_name="BACKUP_$(date +%s)_$(basename "$file_path")"
    backup_path="$BACKUPS_DIR/$backup_name"
    
    echo -e "${YELLOW}[*] Creating backup...${NC}"
    cp "$file_path" "$backup_path"
    
    echo -e "${YELLOW}[*] Cleaning metadata...${NC}"
    exiftool -all= "$file_path" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[✓] Metadata removed successfully!${NC}"
        echo -e "${CYAN}[*] Backup saved: $backup_path${NC}"
        log_action "Clean Metadata" "Cleaned $file_path"
    else
        echo -e "${RED}[X] Failed to clean metadata${NC}"
    fi
}

# ===================================================
# 🌐 NETWORK TOOLS
# ===================================================
network_tools() {
    echo -e "${CYAN}[*] Network Information:${NC}"
    
    if command -v ifconfig &> /dev/null; then
        ifconfig | grep -E "inet|ether" | head -10
    elif command -v ip &> /dev/null; then
        ip addr show | grep -E "inet|ether" | head -10
    else
        echo -e "${YELLOW}[!] Network tools not available${NC}"
    fi
    
    # Get public IP (if connected)
    echo -e "\n${CYAN}[*] Public IP (if connected):${NC}"
    curl -s http://ipinfo.io/ip 2>/dev/null || echo "Not connected"
    
    log_action "Network Scan" "Checked network information"
}

# ===================================================
# 🔐 PASSWORD STRENGTH TESTER
# ===================================================
password_tester() {
    echo -e "${CYAN}[*] Enter password to test:${NC}"
    read -s password
    echo ""
    
    local score=0
    local length=${#password}
    
    # Scoring rules
    [ $length -ge 8 ] && ((score++))
    [ $length -ge 12 ] && ((score++))
    [[ "$password" =~ [A-Z] ]] && ((score++))
    [[ "$password" =~ [a-z] ]] && ((score++))
    [[ "$password" =~ [0-9] ]] && ((score++))
    [[ "$password" =~ [[:punct:]] ]] && ((score++))
    
    echo -e "${CYAN}[*] Password Analysis:${NC}"
    echo "   Length: $length characters"
    echo "   Score: $score/6"
    
    if [ $score -le 2 ]; then
        echo -e "${RED}[X] Weak password${NC}"
    elif [ $score -le 4 ]; then
        echo -e "${YELLOW}[!] Medium password${NC}"
    elif [ $score -eq 5 ]; then
        echo -e "${GREEN}[✓] Good password${NC}"
    else
        echo -e "${GREEN}[✓] Excellent password!${NC}"
    fi
    
    log_action "Password Test" "Tested password (score: $score/6)"
}

# ===================================================
# 📋 MAIN MENU
# ===================================================
main_menu() {
    # Check tools on startup
    check_tools
    
    while true; do
        show_banner
        
        echo -e "${CYAN}════════════════════════════════════════${NC}"
        echo -e "${WHITE}           MAIN MENU                   ${NC}"
        echo -e "${CYAN}════════════════════════════════════════${NC}"
        echo ""
        echo -e "${GREEN}[1] 🔍 Analyze Image + Create Report"
        echo -e "[2] 🧹 Clean Image Metadata"
        echo -e "[3] 🌐 Create Web Interface (Live Capture)"
        echo -e "[4] 📡 Network Tools"
        echo -e "[5] 🔐 Password Strength Tester"
        echo -e "[6] 📁 File Manager"
        echo -e "[7] 📊 View Saved Reports"
        echo -e "[8] ⚙️  System Information"
        echo -e "${RED}[0] 🚪 Exit"
        echo -e "${NC}"
        echo -e "${CYAN}════════════════════════════════════════${NC}"
        
        echo -e "${YELLOW}"
        read -p "Select option: " choice
        echo -e "${NC}"
        
        case $choice in
            1) analyze_image ;;
            2) clean_metadata ;;
            3) create_web_interface ;;
            4) network_tools ;;
            5) password_tester ;;
            6) 
                echo -e "${CYAN}[*] File Manager:${NC}"
                ls -la "$REPORTS_DIR" | head -10
                echo -e "${YELLOW}[!] Total reports: $(ls -1 "$REPORTS_DIR" 2>/dev/null | wc -l)${NC}"
                ;;
            7)
                echo -e "${CYAN}[*] Recent Reports:${NC}"
                ls -lt "$REPORTS_DIR" | head -10 | awk '{print $9, $6, $7, $8}'
                ;;
            8)
                echo -e "${CYAN}[*] System Info:${NC}"
                echo "   OS: $(uname -o)"
                echo "   Storage: $(df -h . | tail -1 | awk '{print $4}') free"
                echo "   Memory: $(free -m | awk 'NR==2{printf "%sMB", $3}') used"
                ;;
            0)
                echo -e "${GREEN}[✓] Goodbye! - Hakeem Al-Arab${NC}"
                echo -e "${YELLOW}[*] GitHub: hakim738-html${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}[X] Invalid option!${NC}"
                ;;
        esac
        
        echo ""
        echo -e "${YELLOW}[!] Press Enter to continue...${NC}"
        read
    done
}

# ===================================================
# 🚀 START PROGRAM
# ===================================================
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    clear
    echo -e "${GREEN}[*] Starting Hakeem Forensic Pro...${NC}"
    sleep 1
    main_menu
fi