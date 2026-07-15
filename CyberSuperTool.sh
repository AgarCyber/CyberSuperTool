#!/bin/bash

# ============================================================
#  AgarCyber - Nmap Toolkit
#  Personalized recon/scanning menu built on top of Nmap.
#  For authorized testing, CTFs and labs only. (Sadece izinli
#  testler, CTF ve lab ortamlari icin kullanin.)
# ============================================================

# Colors (Renkler)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
MAGENTA='\033[1;35m'
CYAN='\033[1;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

clear

# ---- Check nmap ----
if ! command -v nmap &> /dev/null; then
    echo -e "${RED}Nmap is not installed on this system. (Nmap sistemde yuklu degil.)${NC}"
    echo -e "${YELLOW}Install it with: (Kurulum icin:)${NC}"
    echo -e "${GREEN}sudo apt update && sudo apt install nmap${NC}"
    exit 1
fi

mkdir -p logs
LOG_FILE="logs/agarcyber_log_$(date +'%Y-%m-%d_%H-%M-%S').txt"

# ------------------------------------------------------------
# Small boot animation (does not auto-run any scan)
# (Kucuk acilis animasyonu, otomatik tarama baslatmaz)
# ------------------------------------------------------------
boot_animation() {
    local frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
    local msg="Initializing AgarCyber... (AgarCyber baslatiliyor...)"
    for i in $(seq 1 15); do
        f=${frames[$((i % 10))]}
        printf "\r${CYAN}${f} ${msg}${NC}"
        sleep 0.05
    done
    printf "\r%*s\r" "${#msg}" ""
}

spinner_run() {
    # spinner_run "message" command...
    local msg="$1"; shift
    ("$@") &
    local pid=$!
    local frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
    local i=0
    while kill -0 "$pid" 2>/dev/null; do
        printf "\r${YELLOW}${frames[$((i % 10))]} ${msg}${NC}"
        sleep 0.1
        ((i++))
    done
    wait "$pid"
    printf "\r%*s\r" "$((${#msg}+2))" ""
}

banner() {
    echo -e "${MAGENTA}${BOLD}"
    echo "   █████╗  ██████╗  █████╗ ██████╗  ██████╗██╗   ██╗██████╗ ███████╗██████╗ "
    echo "  ██╔══██╗██╔════╝ ██╔══██╗██╔══██╗██╔════╝╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗"
    echo "  ███████║██║  ███╗███████║██████╔╝██║      ╚████╔╝ ██████╔╝█████╗  ██████╔╝"
    echo "  ██╔══██║██║   ██║██╔══██║██╔══██╗██║       ╚██╔╝  ██╔══██╗██╔══╝  ██╔══██╗"
    echo "  ██║  ██║╚██████╔╝██║  ██║██║  ██║╚██████╗   ██║   ██████╔╝███████╗██║  ██║"
    echo "  ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝   ╚═╝   ╚═════╝ ╚══════╝╚═╝  ╚═╝"
    echo -e "${CYAN}"
    echo "        |\\___/|        "
    echo "       (= o.o =)       "
    echo "        > ^ <          "
    echo -e "${NC}"
}

ana_menu() {
    clear
    banner
    echo -e "${CYAN}${BOLD}AgarCyber Main Menu - pick a category (1-12) (Ana Menu - kategori sec)${NC}"
    echo -e "${YELLOW}Each category groups related Nmap options. (Her kategori ilgili Nmap secenekleri icerir.)${NC}"
    echo -e "${GREEN}"
    echo "1)  Port Scans (Port Taramalari)"
    echo "2)  Service & Version Detection (Servis & Versiyon Bilgisi)"
    echo "3)  OS Detection (Isletim Sistemi Tespiti)"
    echo "4)  Firewall & Filter Checks (Firewall ve Filtre Kontrolleri)"
    echo "5)  NSE Script Scans (NSE Script Taramalari)"
    echo "6)  Network Discovery & Topology (Ag Kesfi ve Topoloji)"
    echo "7)  Speed & Timing Settings (Hiz & Zamanlama Ayarlari)"
    echo "8)  Target Specification (Hedef Belirleme Teknikleri)"
    echo "9)  Spoofing / Fragmentation Techniques (Spoofing / Fragmentation Teknikleri)"
    echo "10) Combination Examples (Kombinasyon Ornekleri)"
    echo "11) Extra Features (Ek Ozellikler) - admin finder, real-IP, version risk"
    echo "12) About AgarCyber (Hakkinda)"
    echo "99) Exit (Cikis)"
    echo -e "${NC}"
    read -p "Your choice (Seciminiz) (1-12 | 99): " secim

    case $secim in
        1) kategori1 ;;
        2) kategori2 ;;
        3) kategori3 ;;
        4) kategori4 ;;
        5) kategori5 ;;
        6) kategori6 ;;
        7) kategori7 ;;
        8) kategori8 ;;
        9) kategori9 ;;
        10) kategori10 ;;
        11) ek_ozellikler ;;
        12) hakkinda ;;
        99) echo -e "${CYAN}See you! (Gorusuruz!)${NC}" && exit 0 ;;
        *) echo "Invalid choice (Gecersiz secim)"; sleep 1; ana_menu ;;
    esac
}

# ------------------------------------------------------------
# Category 1: Port Scans
# ------------------------------------------------------------
kategori1() {
    clear
    echo -e "${BLUE}Port Scans (Port Taramalari) - pick an option:${NC}"
    echo "1) Fast scan -F (Hizli tarama)"
    echo "2) Scan specific ports -p (Belirli portlar)"
    echo "3) Scan all ports -p- (Tum portlar)"
    echo "4) TCP SYN scan -sS"
    echo "5) TCP connect scan -sT"
    echo "6) UDP scan -sU"
    echo "7) Xmas scan -sX"
    echo "8) Null scan -sN"
    echo "9) ACK scan -sA"
    echo "10) Window scan -sW"
    echo "99) Main Menu (Ana Menu)"
    read -p "Choice: " secim
    if [[ "$secim" != "99" ]]; then read -p "Target IP (Hedef IP): " hedef; fi

    case $secim in
        1) nmap -F "$hedef" | tee -a "$LOG_FILE" ;;
        2) read -p "Port(s): " port; nmap -p "$port" "$hedef" | tee -a "$LOG_FILE" ;;
        3) nmap -p- "$hedef" | tee -a "$LOG_FILE" ;;
        4) nmap -sS "$hedef" | tee -a "$LOG_FILE" ;;
        5) nmap -sT "$hedef" | tee -a "$LOG_FILE" ;;
        6) nmap -sU "$hedef" | tee -a "$LOG_FILE" ;;
        7) nmap -sX "$hedef" | tee -a "$LOG_FILE" ;;
        8) nmap -sN "$hedef" | tee -a "$LOG_FILE" ;;
        9) nmap -sA "$hedef" | tee -a "$LOG_FILE" ;;
        10) nmap -sW "$hedef" | tee -a "$LOG_FILE" ;;
        99) ana_menu ;;
        *) echo "Invalid choice"; sleep 1 ;;
    esac
    read -p "Press Enter to continue... " _
    kategori1
}

# ------------------------------------------------------------
# Category 2: Service & Version Detection
# ------------------------------------------------------------
kategori2() {
    clear
    echo -e "${BLUE}Service & Version Detection (Servis & Versiyon Bilgisi):${NC}"
    echo "1) Version detection -sV"
    echo "2) Scripts + version -sC -sV"
    echo "3) Version on specific ports"
    echo "4) SSL cipher scan"
    echo "5) Banner grabbing"
    echo "6) Version + OS detection"
    echo "7) All service info -A -sV"
    echo "8) Version + default NSE scripts"
    echo "9) Save version info to log"
    echo "10) List open services"
    echo "99) Main Menu"
    read -p "Choice: " secim
    if [[ "$secim" != "99" ]]; then read -p "Target IP: " hedef; fi

    case $secim in
        1) nmap -sV "$hedef" | tee -a "$LOG_FILE" ;;
        2) nmap -sC -sV "$hedef" | tee -a "$LOG_FILE" ;;
        3) read -p "Port(s): " port; nmap -sV -p "$port" "$hedef" | tee -a "$LOG_FILE" ;;
        4) nmap --script ssl-enum-ciphers -p 443 "$hedef" | tee -a "$LOG_FILE" ;;
        5) nmap --script=banner "$hedef" | tee -a "$LOG_FILE" ;;
        6) nmap -sV -O "$hedef" | tee -a "$LOG_FILE" ;;
        7) nmap -A -sV "$hedef" | tee -a "$LOG_FILE" ;;
        8) nmap -sV --script=default "$hedef" | tee -a "$LOG_FILE" ;;
        9) nmap -sV "$hedef" -oN "$LOG_FILE" ;;
        10) nmap -sV "$hedef" | grep open | tee -a "$LOG_FILE" ;;
        99) ana_menu ;;
        *) echo "Invalid choice"; sleep 1 ;;
    esac
    read -p "Press Enter to continue... " _
    kategori2
}

# ------------------------------------------------------------
# Category 3: OS Detection
# ------------------------------------------------------------
kategori3() {
    clear
    echo -e "${BLUE}OS Detection (Isletim Sistemi Tespiti):${NC}"
    echo "1) OS detection -O"
    echo "2) Aggressive scan -A"
    echo "3) OS guess --osscan-guess"
    echo "4) OS via specific port"
    echo "5) OS + traceroute"
    echo "6) OS + version -O -sV"
    echo "7) OS under firewall (fragmentation) -f"
    echo "8) ICMP based checks"
    echo "9) Save OS detection to log"
    echo "10) Full detail -A -O -sV -sC"
    echo "99) Main Menu"
    read -p "Choice: " secim
    if [[ "$secim" != "99" ]]; then read -p "Target IP: " hedef; fi

    case $secim in
        1) nmap -O "$hedef" | tee -a "$LOG_FILE" ;;
        2) nmap -A "$hedef" | tee -a "$LOG_FILE" ;;
        3) nmap -O --osscan-guess "$hedef" | tee -a "$LOG_FILE" ;;
        4) read -p "Port: " port; nmap -O -p "$port" "$hedef" | tee -a "$LOG_FILE" ;;
        5) nmap -O --traceroute "$hedef" | tee -a "$LOG_FILE" ;;
        6) nmap -O -sV "$hedef" | tee -a "$LOG_FILE" ;;
        7) nmap -O -f "$hedef" | tee -a "$LOG_FILE" ;;
        8) nmap --script=icmp-* "$hedef" | tee -a "$LOG_FILE" ;;
        9) nmap -O "$hedef" -oN "$LOG_FILE" ;;
        10) nmap -A -O -sV -sC "$hedef" | tee -a "$LOG_FILE" ;;
        99) ana_menu ;;
        *) echo "Invalid choice"; sleep 1 ;;
    esac
    read -p "Press Enter to continue... " _
    kategori3
}

# ------------------------------------------------------------
# Category 4: Firewall & Filter Checks
# ------------------------------------------------------------
kategori4() {
    clear
    echo -e "${BLUE}Firewall & Filter Checks (Firewall ve Filtre Kontrolleri):${NC}"
    echo "1) ACK scan (stateful FW detect)"
    echo "2) Null scan"
    echo "3) XMAS scan"
    echo "4) FIN scan"
    echo "5) Fragmented packets"
    echo "6) IP ID based analysis"
    echo "7) ICMP response check"
    echo "8) Filtered/unfiltered ports"
    echo "9) Traceroute filter analysis"
    echo "10) Aggressive FW bypass attempt"
    echo "99) Main Menu"
    read -p "Choice: " secim
    if [[ "$secim" != "99" ]]; then read -p "Target IP: " hedef; fi

    case $secim in
        1) nmap -sA "$hedef" | tee -a "$LOG_FILE" ;;
        2) nmap -sN "$hedef" | tee -a "$LOG_FILE" ;;
        3) nmap -sX "$hedef" | tee -a "$LOG_FILE" ;;
        4) nmap -sF "$hedef" | tee -a "$LOG_FILE" ;;
        5) nmap -f "$hedef" | tee -a "$LOG_FILE" ;;
        6) nmap --ip-options "-" "$hedef" | tee -a "$LOG_FILE" ;;
        7) nmap -PE "$hedef" | tee -a "$LOG_FILE" ;;
        8) nmap -sS "$hedef" | grep -i filtered | tee -a "$LOG_FILE" ;;
        9) nmap --traceroute "$hedef" | tee -a "$LOG_FILE" ;;
        10) nmap -A -f -sX "$hedef" | tee -a "$LOG_FILE" ;;
        99) ana_menu ;;
        *) echo "Invalid choice"; sleep 1 ;;
    esac
    read -p "Press Enter to continue... " _
    kategori4
}

# ------------------------------------------------------------
# Category 5: NSE Script Scans
# ------------------------------------------------------------
kategori5() {
    clear
    echo -e "${BLUE}NSE Script Scans (NSE Script Taramalari):${NC}"
    echo "1) Default scripts -sC"
    echo "2) Vulnerability scan (vuln)"
    echo "3) HTTP scripts (http-*)"
    echo "4) SSL/TLS analysis (ssl-*)"
    echo "5) SSH checks (ssh-*)"
    echo "6) FTP checks (ftp-*)"
    echo "7) Exploit-check scripts"
    echo "8) Brute-force tests (brute-*)"
    echo "9) Auth check scripts"
    echo "10) Save script scan to log"
    echo "99) Main Menu"
    read -p "Choice: " secim
    if [[ "$secim" != "99" ]]; then read -p "Target IP/domain: " hedef; fi

    case $secim in
        1) nmap -sC "$hedef" | tee -a "$LOG_FILE" ;;
        2) nmap --script vuln "$hedef" | tee -a "$LOG_FILE" ;;
        3) nmap --script "http-*" "$hedef" | tee -a "$LOG_FILE" ;;
        4) nmap --script "ssl-*" "$hedef" | tee -a "$LOG_FILE" ;;
        5) nmap --script "ssh-*" "$hedef" | tee -a "$LOG_FILE" ;;
        6) nmap --script "ftp-*" "$hedef" | tee -a "$LOG_FILE" ;;
        7) nmap --script "vuln" "$hedef" | tee -a "$LOG_FILE" ;;
        8) nmap --script "brute-*" "$hedef" | tee -a "$LOG_FILE" ;;
        9) nmap --script "auth" "$hedef" | tee -a "$LOG_FILE" ;;
        10) nmap -sC "$hedef" -oN "$LOG_FILE" ;;
        99) ana_menu ;;
        *) echo "Invalid choice"; sleep 1 ;;
    esac
    read -p "Press Enter to continue... " _
    kategori5
}

# ------------------------------------------------------------
# Category 6: Network Discovery & Topology
# ------------------------------------------------------------
kategori6() {
    clear
    echo -e "${BLUE}Network Discovery & Topology (Ag Kesfi ve Topoloji):${NC}"
    echo "1) Ping scan (live hosts)"
    echo "2) ARP scan (fast on LAN)"
    echo "3) Traceroute"
    echo "4) ICMP Echo scan"
    echo "5) TCP SYN ping scan"
    echo "6) UDP ping scan"
    echo "7) IP protocol scan"
    echo "8) Scan whole /24 block"
    echo "9) DNS reverse lookup discovery"
    echo "10) Topology map (traceroute)"
    echo "99) Main Menu"
    read -p "Choice: " secim
    if [[ "$secim" != "99" ]]; then read -p "Target IP/network (e.g. 192.168.1.0/24): " hedef; fi

    case $secim in
        1) nmap -sn "$hedef" | tee -a "$LOG_FILE" ;;
        2) sudo nmap -sn -PR "$hedef" | tee -a "$LOG_FILE" ;;
        3) nmap --traceroute "$hedef" | tee -a "$LOG_FILE" ;;
        4) nmap -PE "$hedef" | tee -a "$LOG_FILE" ;;
        5) nmap -PS "$hedef" | tee -a "$LOG_FILE" ;;
        6) nmap -PU "$hedef" | tee -a "$LOG_FILE" ;;
        7) nmap -PO "$hedef" | tee -a "$LOG_FILE" ;;
        8) nmap -sn "$hedef" | tee -a "$LOG_FILE" ;;
        9) nmap -sL "$hedef" | tee -a "$LOG_FILE" ;;
        10) nmap -sn --traceroute "$hedef" | tee -a "$LOG_FILE" ;;
        99) ana_menu ;;
        *) echo "Invalid choice"; sleep 1 ;;
    esac
    read -p "Press Enter to continue... " _
    kategori6
}

# ------------------------------------------------------------
# Category 7: Speed & Timing
# ------------------------------------------------------------
kategori7() {
    clear
    echo -e "${BLUE}Speed & Timing Settings (Hiz & Zamanlama Ayarlari):${NC}"
    echo "1) Slowest / stealthiest -T0"
    echo "2) Very slow but safe -T1"
    echo "3) Balanced -T3"
    echo "4) Fast -T4 (default-ish)"
    echo "5) Fastest -T5 (may crash a weak network)"
    echo "6) Lower host timeout"
    echo "7) Set parallelism"
    echo "8) Lower max RTT"
    echo "9) Custom manual parameters"
    echo "10) Timing + full port scan combined"
    echo "99) Main Menu"
    read -p "Choice: " secim
    if [[ "$secim" != "99" ]]; then read -p "Target IP: " hedef; fi

    case $secim in
        1) nmap -T0 "$hedef" | tee -a "$LOG_FILE" ;;
        2) nmap -T1 "$hedef" | tee -a "$LOG_FILE" ;;
        3) nmap -T3 "$hedef" | tee -a "$LOG_FILE" ;;
        4) nmap -T4 "$hedef" | tee -a "$LOG_FILE" ;;
        5) nmap -T5 "$hedef" | tee -a "$LOG_FILE" ;;
        6) nmap --host-timeout 30s "$hedef" | tee -a "$LOG_FILE" ;;
        7) nmap --min-parallelism 10 "$hedef" | tee -a "$LOG_FILE" ;;
        8) nmap --max-rtt-timeout 100ms "$hedef" | tee -a "$LOG_FILE" ;;
        9) read -p "Manual parameters: " param; nmap $param "$hedef" | tee -a "$LOG_FILE" ;;
        10) nmap -sS -T4 -p- "$hedef" | tee -a "$LOG_FILE" ;;
        99) ana_menu ;;
        *) echo "Invalid choice"; sleep 1 ;;
    esac
    read -p "Press Enter to continue... " _
    kategori7
}

# ------------------------------------------------------------
# Category 8: Target Specification
# ------------------------------------------------------------
kategori8() {
    clear
    echo -e "${BLUE}Target Specification (Hedef Belirleme Teknikleri):${NC}"
    echo "1) Single IP"
    echo "2) IP range (192.168.1.1-10)"
    echo "3) CIDR block (192.168.1.0/24)"
    echo "4) Read targets from a file"
    echo "5) Scan by domain name"
    echo "6) Exclude specific IPs"
    echo "7) IPv6 target"
    echo "8) Scan without DNS resolution"
    echo "9) Random IP targets"
    echo "10) Multiple comma-separated targets"
    echo "99) Main Menu"
    read -p "Choice: " secim

    case $secim in
        1) read -p "IP: " ip; nmap "$ip" | tee -a "$LOG_FILE" ;;
        2) read -p "IP range (e.g. 192.168.1.1-20): " ip; nmap "$ip" | tee -a "$LOG_FILE" ;;
        3) read -p "CIDR (e.g. 192.168.1.0/24): " ip; nmap "$ip" | tee -a "$LOG_FILE" ;;
        4) read -p "File name (e.g. targets.txt): " dosya; nmap -iL "$dosya" | tee -a "$LOG_FILE" ;;
        5) read -p "Domain (e.g. example.com): " domain; nmap "$domain" | tee -a "$LOG_FILE" ;;
        6) read -p "IP: " ip; read -p "Exclude IP: " ex; nmap "$ip" --exclude "$ex" | tee -a "$LOG_FILE" ;;
        7) read -p "IPv6 address: " ip6; nmap -6 "$ip6" | tee -a "$LOG_FILE" ;;
        8) read -p "IP: " ip; nmap -n "$ip" | tee -a "$LOG_FILE" ;;
        9) nmap -iR 5 | tee -a "$LOG_FILE" ;;
        10) read -p "Comma-separated IPs: " hedefler; nmap $hedefler | tee -a "$LOG_FILE" ;;
        99) ana_menu ;;
        *) echo "Invalid choice"; sleep 1 ;;
    esac
    read -p "Press Enter to continue... " _
    kategori8
}

# ------------------------------------------------------------
# Category 9: Spoofing / Fragmentation
# ------------------------------------------------------------
kategori9() {
    clear
    echo -e "${BLUE}Spoofing / Fragmentation Techniques:${NC}"
    echo "1) Spoofed source IP"
    echo "2) Random MAC spoof"
    echo "3) Fragmented packet scan"
    echo "4) Custom MTU"
    echo "5) TTL spoof"
    echo "6) Decoy scan"
    echo "7) Source port spoof (e.g. 53)"
    echo "8) Bad checksum"
    echo "9) Full stealth combo (fragment+decoy+MAC)"
    echo "10) Fuzzy fingerprint attempt"
    echo "99) Main Menu"
    read -p "Choice: " secim
    if [[ "$secim" != "99" ]]; then read -p "Target IP: " hedef; fi

    case $secim in
        1) read -p "Fake IP: " fake; nmap -S "$fake" "$hedef" | tee -a "$LOG_FILE" ;;
        2) nmap --spoof-mac 0 "$hedef" | tee -a "$LOG_FILE" ;;
        3) nmap -f "$hedef" | tee -a "$LOG_FILE" ;;
        4) read -p "MTU (e.g. 24): " mtu; nmap --mtu "$mtu" "$hedef" | tee -a "$LOG_FILE" ;;
        5) read -p "TTL (e.g. 42): " ttl; nmap --ttl "$ttl" "$hedef" | tee -a "$LOG_FILE" ;;
        6) read -p "Decoy IPs comma-separated: " d; nmap -D "$d" "$hedef" | tee -a "$LOG_FILE" ;;
        7) read -p "Source port (e.g. 53): " port; nmap --source-port "$port" "$hedef" | tee -a "$LOG_FILE" ;;
        8) nmap --badsum "$hedef" | tee -a "$LOG_FILE" ;;
        9) nmap -f -D RND:5 --spoof-mac 0 "$hedef" | tee -a "$LOG_FILE" ;;
        10) nmap --version-intensity 9 -sV "$hedef" | tee -a "$LOG_FILE" ;;
        99) ana_menu ;;
        *) echo "Invalid choice"; sleep 1 ;;
    esac
    read -p "Press Enter to continue... " _
    kategori9
}

# ------------------------------------------------------------
# Category 10: Combinations
# ------------------------------------------------------------
kategori10() {
    clear
    echo -e "${BLUE}Combination Examples:${NC}"
    echo "1) Full port + service + version"
    echo "2) Stealth + fragmented + MAC spoof"
    echo "3) Fast port scan + version check"
    echo "4) Aggressive OS + traceroute + scripts"
    echo "5) UDP + service version"
    echo "6) Web server analysis (80/443)"
    echo "7) DNS target analysis (port 53)"
    echo "8) Scripts + T5 speed + decoy IP"
    echo "9) Full IPv6 scan"
    echo "10) All combined (heaviest option)"
    echo "99) Main Menu"
    read -p "Choice: " secim
    if [[ "$secim" != "99" ]]; then read -p "Target IP/domain: " hedef; fi

    case $secim in
        1) nmap -p- -sV -sS -T4 "$hedef" | tee -a "$LOG_FILE" ;;
        2) nmap -sS -f --spoof-mac 0 "$hedef" | tee -a "$LOG_FILE" ;;
        3) nmap -F -sV "$hedef" | tee -a "$LOG_FILE" ;;
        4) nmap -A --traceroute "$hedef" | tee -a "$LOG_FILE" ;;
        5) nmap -sU -sV "$hedef" | tee -a "$LOG_FILE" ;;
        6) nmap -p 80,443 -sV --script=http-enum "$hedef" | tee -a "$LOG_FILE" ;;
        7) nmap -p 53 -sU -sV --script=dns-zone-transfer "$hedef" | tee -a "$LOG_FILE" ;;
        8) nmap -sC -T5 -D RND:5 "$hedef" | tee -a "$LOG_FILE" ;;
        9) nmap -6 -sS -sV "$hedef" | tee -a "$LOG_FILE" ;;
        10) nmap -A -T5 -f -sS -D RND:5 --spoof-mac 0 "$hedef" | tee -a "$LOG_FILE" ;;
        99) ana_menu ;;
        *) echo "Invalid choice"; sleep 1 ;;
    esac
    read -p "Press Enter to continue... " _
    kategori10
}

# ------------------------------------------------------------
# Category 11: Extra Features (Ek Ozellikler)
# ------------------------------------------------------------
ek_ozellikler() {
    clear
    echo -e "${BLUE}${BOLD}Extra Features (Ek Ozellikler):${NC}"
    echo "1) Admin panel finder (Admin panel bulma)"
    echo "2) Real-IP / subdomain lookup via crt.sh (CDN arkasindaki gercek IP icin ipucu)"
    echo "3) Service-version risk flagger (Versiyon risk kontrolu)"
    echo "4) Subdomain list via crt.sh"
    echo "99) Main Menu"
    read -p "Choice: " secim

    case $secim in
        1) admin_panel_bul ;;
        2) gercek_ip_ipucu ;;
        3) versiyon_risk ;;
        4) subdomain_bul ;;
        99) ana_menu ;;
        *) echo "Invalid choice"; sleep 1 ;;
    esac
    read -p "Press Enter to continue... " _
    ek_ozellikler
}

# --- Admin panel finder ---
# Checks a small list of common admin paths on the given target.
# Passive HTTP status check only - not a brute-force/exploit tool.
admin_panel_bul() {
    read -p "Target URL (e.g. http://example.com): " url
    url="${url%/}"
    paths=(
        "/admin" "/admin/login" "/administrator" "/wp-admin" "/wp-login.php"
        "/login" "/cpanel" "/panel" "/manager/html" "/user/login"
        "/adminpanel" "/dashboard" "/backend" "/controlpanel" "/webadmin"
    )
    echo -e "${YELLOW}Scanning common admin paths on $url ... (yaygin admin yollari kontrol ediliyor)${NC}"
    {
        echo "== Admin panel scan for $url =="
        for p in "${paths[@]}"; do
            code=$(curl -s -o /dev/null -m 5 -w "%{http_code}" "$url$p")
            if [[ "$code" =~ ^(200|301|302|401|403)$ ]]; then
                echo -e "${GREEN}[FOUND] $url$p -> HTTP $code${NC}"
            fi
        done
    } | tee -a "$LOG_FILE"
    echo -e "${CYAN}Done. Only publicly reachable status codes were checked (no login attempts made).${NC}"
}

# --- Real IP behind CDN hint ---
# Uses certificate transparency logs (crt.sh) to list historical/related
# hostnames, which can sometimes reveal an origin server not proxied by
# a CDN. This is passive OSINT, not a bypass of any protection.
gercek_ip_ipucu() {
    read -p "Domain (e.g. example.com): " domain
    echo -e "${YELLOW}Querying crt.sh certificate transparency logs... (crt.sh sorgulaniyor)${NC}"
    {
        echo "== crt.sh related hostnames for $domain =="
        curl -s -m 10 "https://crt.sh/?q=%25.${domain}&output=json" \
            | grep -o '"name_value":"[^"]*"' \
            | sed 's/"name_value":"//;s/"//' \
            | sort -u
    } | tee -a "$LOG_FILE"
    echo -e "${CYAN}Tip: resolve each hostname with 'host' or 'dig' and compare against known CDN IP ranges to spot a non-CDN origin. (Ipucu: her bir adi 'host'/'dig' ile cozup CDN IP araliklari disinda kalani ara.)${NC}"
}

# --- Subdomain finder via crt.sh ---
subdomain_bul() {
    read -p "Domain (e.g. example.com): " domain
    echo -e "${YELLOW}Fetching subdomains from crt.sh...${NC}"
    curl -s -m 10 "https://crt.sh/?q=%25.${domain}&output=json" \
        | grep -o '"name_value":"[^"]*"' \
        | sed 's/"name_value":"//;s/"//' \
        | sort -u | tee -a "$LOG_FILE"
}

# --- Version-based risk flagger ---
# Runs -sV and flags a small built-in list of historically risky /
# end-of-life banners. This is a heuristic hint, NOT a CVE database -
# always cross-check with nvd.nist.gov before drawing conclusions.
versiyon_risk() {
    read -p "Target IP/domain: " hedef
    tmpfile=$(mktemp)
    spinner_run "Running version scan (Versiyon taramasi yapiliyor)" nmap -sV "$hedef" -oN "$tmpfile"
    cat "$tmpfile" | tee -a "$LOG_FILE"
    echo -e "\n${MAGENTA}${BOLD}== Risk hints (Risk ipuclari) ==${NC}"
    declare -A risky=(
        ["vsftpd 2.3.4"]="Known backdoored version - high risk"
        ["Apache/2.2"]="End-of-life Apache branch - check for updates"
        ["OpenSSH 4"]="Very old OpenSSH - multiple known CVEs"
        ["OpenSSH 5"]="Old OpenSSH - check CVEs"
        ["ProFTPD 1.3.3"]="Known backdoor issue in this release"
        ["Microsoft IIS/6.0"]="Legacy IIS - end of support"
        ["Samba 3."]="Old Samba branch - check CVEs (e.g. related to EternalRed class issues)"
    )
    found=0
    for sig in "${!risky[@]}"; do
        if grep -qi "$sig" "$tmpfile"; then
            echo -e "${RED}[RISK] Matched '$sig' -> ${risky[$sig]}${NC}"
            found=1
        fi
    done
    if [[ $found -eq 0 ]]; then
        echo -e "${GREEN}No known-old signatures matched in this small local list.${NC}"
    fi
    echo -e "${YELLOW}This is only a heuristic hint list, not a full CVE lookup. Cross-check findings manually (e.g. nvd.nist.gov). (Bu sadece kucuk bir ipucu listesidir, gercek CVE taramasi degildir.)${NC}"
    rm -f "$tmpfile"
}

# ------------------------------------------------------------
# Category 12: About
# ------------------------------------------------------------
hakkinda() {
    clear
    banner
    echo -e "${CYAN}${BOLD}About AgarCyber (Hakkinda)${NC}"
    echo ""
    echo -e "${GREEN}Cybersecurity enthusiast dedicated to mastering Network Security, Linux,"
    echo "and Ethical Hacking. Passionate about continuous learning, building"
    echo "security solutions, and improving system defenses."
    echo -e "(Ag Guvenligi, Linux ve Etik Hacking konularinda uzmanlasmaya kararli bir"
    echo "siber guvenlik meraklisi. Surekli ogrenmeye, guvenlik cozumleri gelistirmeye"
    echo -e "ve sistem savunmalarini iyilestirmeye tutkulu.)${NC}"
    echo ""
    echo -e "${YELLOW}LinkedIn:${NC} https://www.linkedin.com/in/emir-sadiqov/"
    echo ""
    echo -e "${MAGENTA}Tool: AgarCyber - built on top of Nmap. (Nmap uzerine insa edilmis arac.)${NC}"
    echo ""
    read -p "Press Enter to return to the menu... " _
    ana_menu
}

boot_animation
ana_menu
