#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# BHHK TOOLS v1.0 — Termux Multi Tool Collection
# 200+ Tools | Pure CLI
# ============================================================

CYAN='\033[0;36m'; PINK='\033[0;35m'; GREEN='\033[0;32m'
YELLOW='\033[1;33m'; RED='\033[0;31m'; WHITE='\033[1;37m'
BLUE='\033[0;34m'; DIM='\033[2m'; BOLD='\033[1m'; NC='\033[0m'

DATA_DIR="$HOME/.bhhk_tools"
mkdir -p "$DATA_DIR"

# ============================================================
# HELPERS
# ============================================================
pause() { printf "\n  ${DIM}Press ENTER...${NC}"; read -r; }
title() {
    clear
    echo ""
    echo -e "${CYAN}    ╔══════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}    ║${NC}  ${PINK}🛠️   B H H K   T O O L S   v1.0   🛠️${NC}   ${CYAN}║${NC}"
    echo -e "${CYAN}    ║${NC}      ${DIM}Multi Tool Collection${NC}              ${CYAN}║${NC}"
    echo -e "${CYAN}    ╚══════════════════════════════════════════╝${NC}"
    echo ""
}
sub() {
    clear
    echo ""
    echo -e "${CYAN}  ╔══════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}  ║${NC}  ${PINK}$1${NC}${CYAN}║${NC}"
    echo -e "${CYAN}  ╚══════════════════════════════════════════╝${NC}"
    echo ""
}
line() { echo -e "  ${DIM}──────────────────────────────────────────${NC}"; }

ask() { printf "  ${PINK}➜${NC} ${WHITE}$1${NC}: "; }

# ============================================================
# ENCODERS / DECODERS
# ============================================================
t_b64enc() {
    sub "🔐 Base64 Encode"
    ask "Text"; read -r t
    echo ""; echo -e "  ${GREEN}✓${NC} ${WHITE}$(printf '%s' "$t" | base64 -w0)${NC}"
    pause
}
t_b64dec() {
    sub "🔓 Base64 Decode"
    ask "Base64"; read -r t
    local out=$(printf '%s' "$t" | base64 -d 2>/dev/null)
    [ -z "$out" ] && echo -e "  ${RED}✗ Invalid${NC}" || echo -e "  ${GREEN}✓${NC} ${WHITE}$out${NC}"
    pause
}
t_hexenc() {
    sub "🔐 HEX Encode"
    ask "Text"; read -r t
    local out=$(printf '%s' "$t" | xxd -p | tr -d '\n')
    echo ""; echo -e "  ${GREEN}✓${NC} ${WHITE}$out${NC}"
    pause
}
t_hexdec() {
    sub "🔓 HEX Decode"
    ask "HEX"; read -r t
    local out=$(printf '%s' "$t" | xxd -r -p 2>/dev/null)
    echo ""; echo -e "  ${GREEN}✓${NC} ${WHITE}$out${NC}"
    pause
}
t_urlenc() {
    sub "🔐 URL Encode"
    ask "Text"; read -r t
    # Bash-based URL encode
    local out=$(printf '%s' "$t" | od -An -tx1 | tr ' ' '\n' | grep . | while read -r h; do printf '%%%s' "$h"; done)
    echo ""; echo -e "  ${GREEN}✓${NC} ${WHITE}$out${NC}"
    pause
}
t_urldec() {
    sub "🔓 URL Decode"
    ask "Encoded"; read -r t
    local out=$(printf '%b' "${t//%/\\x}")
    echo ""; echo -e "  ${GREEN}✓${NC} ${WHITE}$out${NC}"
    pause
}
t_rot13() {
    sub "🔄 ROT13"
    ask "Text"; read -r t
    local out=$(echo "$t" | tr 'A-Za-z' 'N-ZA-Mn-za-m')
    echo ""; echo -e "  ${GREEN}✓${NC} ${WHITE}$out${NC}"
    pause
}
t_morse() {
    sub "📻 Text → Morse"
    ask "Text"; read -r t
    echo ""
    # Simple morse mapping
    local out=""
    local up=$(echo "$t" | tr 'a-z' 'A-Z')
    for ((i=0; i<${#up}; i++)); do
        c="${up:$i:1}"
        case "$c" in
            A) out="$out.- ";; B) out="$out-... ";; C) out="$out-.-. ";; D) out="$out-.. ";;
            E) out="$out. ";; F) out="$out..-. ";; G) out="$out--. ";; H) out="$out.... ";;
            I) out="$out.. ";; J) out="$out.--- ";; K) out="$out-.- ";; L) out="$out.-.. ";;
            M) out="$out-- ";; N) out="$out-. ";; O) out="$out--- ";; P) out="$out.--. ";;
            Q) out="$out--.- ";; R) out="$out.-. ";; S) out="$out... ";; T) out="$out- ";;
            U) out="$out..- ";; V) out="$out...- ";; W) out="$out.-- ";; X) out="$out-..- ";;
            Y) out="$out-.-- ";; Z) out="$out--.. ";;
            0) out="$out----- ";; 1) out="$out.---- ";; 2) out="$out..--- ";; 3) out="$out...-- ";;
            4) out="$out....- ";; 5) out="$out..... ";; 6) out="$out-.... ";; 7) out="$out--... ";;
            8) out="$out---.. ";; 9) out="$out----. ";;
            " ") out="$out/ ";;
            *) out="$out? ";;
        esac
    done
    echo -e "  ${GREEN}✓${NC} ${WHITE}$out${NC}"
    pause
}
t_bin() {
    sub "💻 Text → Binary"
    ask "Text"; read -r t
    echo ""
    local out=""
    for ((i=0; i<${#t}; i++)); do
        c=$(printf '%d' "'${t:$i:1}")
        out="$out$(printf '%08d' "$(echo "obase=2;$c" | bc)") "
    done
    echo -e "  ${GREEN}✓${NC} ${WHITE}$out${NC}"
    pause
}
t_rev() {
    sub "🔄 Reverse Text"
    ask "Text"; read -r t
    echo ""; echo -e "  ${GREEN}✓${NC} ${WHITE}$(echo "$t" | rev)${NC}"
    pause
}

# ============================================================
# GENERATORS
# ============================================================
t_pass() {
    sub "🔑 Password Generator"
    ask "Length (default 16)"; read -r len
    len=${len:-16}
    local p=$(cat /dev/urandom | tr -dc 'A-Za-z0-9!@#$%^&*()_+-=' | head -c "$len")
    echo ""; echo -e "  ${GREEN}✓${NC} ${WHITE}${BOLD}$p${NC}"
    pause
}
t_randstr() {
    sub "🎲 Random String"
    ask "Length (default 16)"; read -r len
    len=${len:-16}
    local p=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c "$len")
    echo ""; echo -e "  ${GREEN}✓${NC} ${WHITE}$p${NC}"
    pause
}
t_uuid() {
    sub "🆔 UUID Generator"
    ask "Count (default 5)"; read -r c
    c=${c:-5}
    echo ""
    for ((i=0; i<c; i++)); do
        cat /proc/sys/kernel/random/uuid
    done | while read -r u; do echo -e "  ${CYAN}▸${NC} ${WHITE}$u${NC}"; done
    pause
}
t_randnum() {
    sub "🎲 Random Number"
    ask "Min (default 1)"; read -r min
    ask "Max (default 100)"; read -r max
    min=${min:-1}; max=${max:-100}
    if [ "$min" -gt "$max" ]; then t=$min; min=$max; max=$t; fi
    local n=$((RANDOM % (max - min + 1) + min))
    echo ""; echo -e "  ${GREEN}✓${NC} ${WHITE}${BOLD}$n${NC}  ${DIM}(${min} - ${max})${NC}"
    pause
}
t_randcolor() {
    sub "🎨 Random Color"
    echo ""
    for ((i=0; i<5; i++)); do
        local c=$(printf '#%06X' $((RANDOM * RANDOM % 16777215)))
        echo -e "  ${CYAN}▸${NC} ${WHITE}$c${NC}"
    done
    pause
}
t_hashtag() {
    sub "#️⃣ Hashtag Generator"
    ask "Text"; read -r t
    echo ""
    for w in $t; do
        local c=$(echo "$w" | tr -cd 'a-zA-Z0-9')
        [ ${#c} -gt 2 ] && echo -e "  ${CYAN}▸${NC} ${WHITE}#$(echo "$c" | tr 'A-Z' 'a-z')${NC}"
    done
    pause
}
t_hash() {
    sub "🔐 Hash Generator"
    ask "Text"; read -r t
    echo ""
    echo -e "  ${CYAN}MD5   :${NC} ${WHITE}$(printf '%s' "$t" | md5sum | cut -d' ' -f1)${NC}"
    echo -e "  ${CYAN}SHA1  :${NC} ${WHITE}$(printf '%s' "$t" | sha1sum | cut -d' ' -f1)${NC}"
    echo -e "  ${CYAN}SHA256:${NC} ${WHITE}$(printf '%s' "$t" | sha256sum | cut -d' ' -f1)${NC}"
    pause
}
t_lorem() {
    sub "📝 Lorem Ipsum"
    ask "Paragraphs (default 1)"; read -r p
    p=${p:-1}
    echo ""
    local words=(lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua)
    for ((k=0; k<p; k++)); do
        for ((s=0; s<5; s++)); do
            local line=""
            for ((w=0; w<10; w++)); do
                line="$line ${words[$((RANDOM % ${#words[@]}))]}"
            done
            echo -e "  ${WHITE}$(echo "${line:1}" | sed 's/^\(.\)/\U\1/').${NC}"
        done
        echo ""
    done
    pause
}

# ============================================================
# CONVERTERS
# ============================================================
t_base() {
    sub "🔢 Base Converter"
    ask "Number"; read -r n
    ask "From base (2/8/10/16)"; read -r f
    ask "To base (2/8/10/16)"; read -r tt
    local out=$(echo "obase=$tt; ibase=$f; $n" | bc 2>/dev/null)
    [ -z "$out" ] && echo -e "  ${RED}✗ Invalid${NC}" || echo -e "  ${GREEN}✓${NC} ${WHITE}$out${NC}"
    pause
}
t_case() {
    sub "🔠 Case Converter"
    echo -e "  ${PINK}[1]${NC} UPPER"
    echo -e "  ${PINK}[2]${NC} lower"
    echo -e "  ${PINK}[3]${NC} Title"
    echo -e "  ${PINK}[4]${NC} reverse"
    echo -e "  ${PINK}[5]${NC} swap"
    ask "Option"; read -r opt
    ask "Text"; read -r t
    case "$opt" in
        1) out=$(echo "$t" | tr 'a-z' 'A-Z');;
        2) out=$(echo "$t" | tr 'A-Z' 'a-z');;
        3) out=$(echo "$t" | sed 's/\b\(.\)/\U\1/g');;
        4) out=$(echo "$t" | rev);;
        5) out=$(echo "$t" | tr 'A-Za-z' 'a-zA-Z');;
        *) out="$t";;
    esac
    echo ""; echo -e "  ${GREEN}✓${NC} ${WHITE}$out${NC}"
    pause
}
t_temp() {
    sub "🌡️ Temperature Converter"
    ask "Value"; read -r v
    ask "From (c/f/k)"; read -r f
    ask "To (c/f/k)"; read -r tt
    local c
    case "$f" in
        c|C) c=$v;;
        f|F) c=$(echo "scale=2; ($v - 32) * 5 / 9" | bc);;
        k|K) c=$(echo "scale=2; $v - 273.15" | bc);;
        *) echo -e "  ${RED}✗ Invalid${NC}"; pause; return;;
    esac
    case "$tt" in
        c|C) out=$c;;
        f|F) out=$(echo "scale=2; $c * 9 / 5 + 32" | bc);;
        k|K) out=$(echo "scale=2; $c + 273.15" | bc);;
        *) echo -e "  ${RED}✗ Invalid${NC}"; pause; return;;
    esac
    echo ""; echo -e "  ${GREEN}✓${NC} ${WHITE}${out}°${tt}${NC}"
    pause
}
t_unit() {
    sub "📏 Unit Converter"
    echo -e "  ${PINK}[1]${NC} km → mile      ${PINK}[2]${NC} mile → km"
    echo -e "  ${PINK}[3]${NC} kg → lb        ${PINK}[4]${NC} lb → kg"
    echo -e "  ${PINK}[5]${NC} m → ft         ${PINK}[6]${NC} ft → m"
    echo -e "  ${PINK}[7]${NC} cm → inch      ${PINK}[8]${NC} inch → cm"
    echo -e "  ${PINK}[9]${NC} GB → MB        ${PINK}[10]${NC} MB → GB"
    ask "Choice"; read -r c
    ask "Value"; read -r v
    case "$c" in
        1) out=$(echo "scale=4; $v * 0.621371" | bc);;
        2) out=$(echo "scale=4; $v * 1.60934" | bc);;
        3) out=$(echo "scale=4; $v * 2.20462" | bc);;
        4) out=$(echo "scale=4; $v * 0.453592" | bc);;
        5) out=$(echo "scale=4; $v * 3.28084" | bc);;
        6) out=$(echo "scale=4; $v * 0.3048" | bc);;
        7) out=$(echo "scale=4; $v * 0.393701" | bc);;
        8) out=$(echo "scale=4; $v * 2.54" | bc);;
        9) out=$(echo "scale=2; $v * 1024" | bc);;
        10) out=$(echo "scale=4; $v / 1024" | bc);;
        *) out="?";;
    esac
    echo ""; echo -e "  ${GREEN}✓${NC} ${WHITE}$out${NC}"
    pause
}
t_roman() {
    sub "📜 Number → Roman"
    ask "Number (1-3999)"; read -r n
    if [ "$n" -lt 1 ] || [ "$n" -gt 3999 ]; then
        echo -e "  ${RED}✗ Out of range${NC}"; pause; return
    fi
    local vals=(1000 900 500 400 100 90 50 40 10 9 5 4 1)
    local syms=(M CM D CD C XC L XL X IX V IV I)
    local out=""
    local r=$n
    for ((i=0; i<13; i++)); do
        while [ $r -ge ${vals[$i]} ]; do
            out="$out${syms[$i]}"
            r=$((r - ${vals[$i]}))
        done
    done
    echo ""; echo -e "  ${GREEN}✓${NC} ${WHITE}$n = $out${NC}"
    pause
}
t_slug() {
    sub "🔤 Text → Slug"
    ask "Text"; read -r t
    local out=$(echo "$t" | tr 'A-Z' 'a-z' | tr -cd 'a-z0-9 ' | tr ' ' '-')
    echo ""; echo -e "  ${GREEN}✓${NC} ${WHITE}$out${NC}"
    pause
}

# ============================================================
# ANALYZERS
# ============================================================
t_stats() {
    sub "📈 Text Statistics"
    ask "Text"; read -r t
    local chars=${#t}
    local words=$(echo "$t" | wc -w)
    local lines=$(echo "$t" | wc -l)
    local nows=$(echo "$t" | tr -d ' ' | wc -c)
    echo ""
    echo -e "  ${CYAN}▸${NC} Characters   : ${WHITE}${chars}${NC}"
    echo -e "  ${CYAN}▸${NC} No space     : ${WHITE}${nows}${NC}"
    echo -e "  ${CYAN}▸${NC} Words        : ${WHITE}${words}${NC}"
    echo -e "  ${CYAN}▸${NC} Lines        : ${WHITE}${lines}${NC}"
    pause
}
t_passstrength() {
    sub "🔐 Password Strength"
    ask "Password"; read -rs p; echo ""
    local score=0
    [ ${#p} -ge 8 ] && score=$((score+1))
    [ ${#p} -ge 12 ] && score=$((score+1))
    echo "$p" | grep -q '[a-z]' && score=$((score+1))
    echo "$p" | grep -q '[A-Z]' && score=$((score+1))
    echo "$p" | grep -q '[0-9]' && score=$((score+1))
    echo "$p" | grep -q '[^a-zA-Z0-9]' && score=$((score+1))
    local lbl
    [ $score -le 2 ] && lbl="${RED}🔴 Weak${NC}"
    [ $score -gt 2 ] && [ $score -le 4 ] && lbl="${YELLOW}🟡 Medium${NC}"
    [ $score -gt 4 ] && [ $score -le 5 ] && lbl="${GREEN}🟢 Strong${NC}"
    [ $score -gt 5 ] && lbl="${GREEN}💎 Very Strong${NC}"
    echo ""; echo -e "  Result: $lbl  ${DIM}(${score}/6)${NC}"
    pause
}
t_phone() {
    sub "📱 BD Phone Info"
    ask "Phone (01XXXXXXXXX)"; read -r p
    p=$(echo "$p" | tr -cd '0-9')
    [ ${#p} -ne 11 ] && { echo -e "  ${RED}✗ Need 11 digits${NC}"; pause; return; }
    local pre=${p:0:3}
    local op="Unknown"
    case "$pre" in
        013|017) op="Grameenphone";;
        014|019) op="Banglalink";;
        015) op="Teletalk";;
        016) op="Airtel";;
        018) op="Robi";;
    esac
    echo ""
    echo -e "  ${CYAN}▸${NC} Number   : ${WHITE}$p${NC}"
    echo -e "  ${CYAN}▸${NC} Operator : ${GREEN}$op${NC}"
    echo -e "  ${CYAN}▸${NC} Prefix   : ${WHITE}$pre${NC}"
    pause
}
t_prime() {
    sub "🔢 Prime Checker"
    ask "Number"; read -r n
    if [ "$n" -lt 2 ]; then
        echo -e "  ${RED}✗ Not prime${NC}"; pause; return
    fi
    for ((i=2; i*i<=n; i++)); do
        if [ $((n % i)) -eq 0 ]; then
            echo -e "  ${RED}✗ Not prime (divisible by $i)${NC}"; pause; return
        fi
    done
    echo -e "  ${GREEN}✓ Prime!${NC}"
    pause
}
t_age() {
    sub "📅 Age Calculator"
    ask "Birthdate (YYYY-MM-DD)"; read -r d
    local birth=$(date -d "$d" +%s 2>/dev/null)
    [ -z "$birth" ] && { echo -e "  ${RED}✗ Invalid date${NC}"; pause; return; }
    local now=$(date +%s)
    local diff=$((now - birth))
    local years=$((diff / 31536000))
    local days=$((diff / 86400))
    echo ""
    echo -e "  ${CYAN}▸${NC} Years : ${WHITE}${years}${NC}"
    echo -e "  ${CYAN}▸${NC} Days  : ${WHITE}${days}${NC}"
    pause
}
t_bmi() {
    sub "⚖️ BMI Calculator"
    ask "Weight (kg)"; read -r w
    ask "Height (cm)"; read -r h
    local bmi=$(echo "scale=2; $w / (($h/100)^2)" | bc)
    local cat
    if (( $(echo "$bmi < 18.5" | bc) )); then cat="🔵 Underweight"
    elif (( $(echo "$bmi < 25" | bc) )); then cat="🟢 Normal"
    elif (( $(echo "$bmi < 30" | bc) )); then cat="🟡 Overweight"
    else cat="🔴 Obese"; fi
    echo ""
    echo -e "  ${CYAN}▸${NC} BMI      : ${WHITE}${bmi}${NC}"
    echo -e "  ${CYAN}▸${NC} Category : ${WHITE}${cat}${NC}"
    pause
}
t_percent() {
    sub "📊 Percentage Calculator"
    ask "Value"; read -r a
    ask "Total"; read -r b
    [ "$b" = "0" ] && { echo -e "  ${RED}✗ Cannot divide by zero${NC}"; pause; return; }
    local pct=$(echo "scale=2; $a * 100 / $b" | bc)
    local of=$(echo "scale=2; $a * $b / 100" | bc)
    echo ""
    echo -e "  ${CYAN}▸${NC} ${a} is ${WHITE}${pct}%${NC} of ${b}"
    echo -e "  ${CYAN}▸${NC} ${a}% of ${b} = ${WHITE}${of}${NC}"
    pause
}
t_fib() {
    sub "🔢 Fibonacci Sequence"
    ask "Count (default 10)"; read -r n
    n=${n:-10}
    local a=0 b=1
    echo ""
    for ((i=0; i<n; i++)); do
        echo -n -e "  ${WHITE}$a${NC}"
        [ $i -lt $((n-1)) ] && echo -n ","
        local t=$a; a=$b; b=$((t + b))
    done
    echo ""; pause
}
t_mult() {
    sub "📊 Multiplication Table"
    ask "Number"; read -r n
    echo ""
    for ((i=1; i<=15; i++)); do
        echo -e "  ${WHITE}$n × $i = $((n * i))${NC}"
    done
    pause
}

# ============================================================
# ONLINE TOOLS
# ============================================================
t_iplookup() {
    sub "🌐 IP Lookup"
    ask "IP (leave empty for own)"; read -r ip
    [ -z "$ip" ] && ip=$(curl -s --max-time 8 https://api.ipify.org)
    echo ""
    echo -e "  ${CYAN}▸${NC} ${DIM}Fetching...${NC}"
    local data=$(curl -s --max-time 12 "http://ip-api.com/json/${ip}?fields=status,country,countryCode,regionName,city,zip,lat,lon,timezone,isp,org,as,query")
    if echo "$data" | grep -q '"status":"success"'; then
        for k in country city regionName zip lat lon timezone isp org as query; do
            local v=$(echo "$data" | grep -o "\"$k\":[^,}]*" | sed 's/.*://;s/"//g')
            [ -n "$v" ] && echo -e "  ${CYAN}▸${NC} ${DIM}${k}${NC}: ${WHITE}${v}${NC}"
        done
    else
        echo -e "  ${RED}✗ Failed${NC}"
    fi
    pause
}
t_domain() {
    sub "🌐 Domain Info"
    ask "Domain"; read -r d
    d=$(echo "$d" | sed 's|https\?://||;s|www\.||;s|/.*||')
    echo ""
    local ip=$(getent hosts "$d" 2>/dev/null | head -1 | awk '{print $1}')
    [ -z "$ip" ] && ip=$(nslookup "$d" 2>/dev/null | grep 'Address:' | tail -1 | awk '{print $2}')
    echo -e "  ${CYAN}▸${NC} Domain : ${WHITE}$d${NC}"
    echo -e "  ${CYAN}▸${NC} IP     : ${WHITE}${ip:-N/A}${NC}"
    pause
}
t_shorten() {
    sub "🔗 URL Shortener"
    ask "URL"; read -r u
    echo ""
    local out=$(curl -s --max-time 10 "https://tinyurl.com/api-create.php?url=$(printf '%s' "$u" | jq -sRr @uri 2>/dev/null || printf '%s' "$u")")
    [ -z "$out" ] && echo -e "  ${RED}✗ Failed${NC}" || echo -e "  ${GREEN}✓${NC} ${WHITE}$out${NC}"
    pause
}
t_emailval() {
    sub "📧 Email Validator"
    ask "Email"; read -r e
    if echo "$e" | grep -qE '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'; then
        echo -e "  ${GREEN}✓ Valid${NC}"
    else
        echo -e "  ${RED}✗ Invalid${NC}"
    fi
    pause
}
t_qr() {
    sub "📱 QR Code Generator"
    ask "Text/URL"; read -r t
    echo ""
    echo -e "  ${CYAN}▸${NC} ${WHITE}QR URL:${NC}"
    # URL encode
    local enc=$(printf '%s' "$t" | while IFS= read -rn1 c; do printf '%%%02X' "'$c"; done)
    echo -e "  ${DIM}https://api.qrserver.com/v1/create-qr-code/?size=400x400&data=${enc}${NC}"
    pause
}
t_myip() {
    sub "📍 My IP Address"
    echo ""
    local ip=$(curl -s --max-time 8 https://api.ipify.org)
    echo -e "  ${GREEN}✓${NC} ${WHITE}${BOLD}$ip${NC}"
    pause
}

# ============================================================
# UTILITIES
# ============================================================
t_progress() {
    sub "📊 Progress Bar"
    ask "Percent (0-100)"; read -r p
    p=$((p > 100 ? 100 : (p < 0 ? 0 : p)))
    local filled=$((p * 20 / 100))
    local bar=""
    for ((i=0; i<20; i++)); do
        if [ $i -lt $filled ]; then bar="${bar}█"; else bar="${bar}░"; fi
    done
    echo ""; echo -e "  ${CYAN}${bar}${NC}  ${WHITE}${p}%${NC}"
    pause
}
t_stars() {
    sub "⭐ Star Rating"
    ask "Rating (0-5)"; read -r r
    local full=${r%.*}
    local stars=""
    for ((i=0; i<full; i++)); do stars="${stars}⭐"; done
    for ((i=full; i<5; i++)); do stars="${stars}☆"; done
    echo ""; echo -e "  ${stars}  ${DIM}(${r}/5)${NC}"
    pause
}
t_dice() {
    sub "🎲 Dice Roller"
    ask "Sides (default 6)"; read -r s
    ask "Count (default 1)"; read -r c
    s=${s:-6}; c=${c:-1}
    echo ""
    for ((i=0; i<c; i++)); do
        local r=$((RANDOM % s + 1))
        echo -e "  ${CYAN}▸${NC} Roll $((i+1)): ${WHITE}${BOLD}$r${NC}"
    done
    pause
}
t_coin() {
    sub "🪙 Coin Flip"
    ask "Count (default 1)"; read -r c
    c=${c:-1}
    echo ""
    for ((i=0; i<c; i++)); do
        local r=$((RANDOM % 2))
        [ $r -eq 0 ] && echo -e "  ${CYAN}▸${NC} ${WHITE}Heads${NC}" || echo -e "  ${CYAN}▸${NC} ${WHITE}Tails${NC}"
    done
    pause
}
t_repeat() {
    sub "🔁 Text Repeater"
    ask "Text"; read -r t
    ask "Times (default 5)"; read -r n
    n=${n:-5}
    echo ""
    for ((i=0; i<n; i++)); do echo -e "  ${WHITE}$t${NC}"; done
    pause
}
t_wordfreq() {
    sub "📊 Word Frequency"
    ask "Text"; read -r t
    echo ""
    echo "$t" | tr ' ' '\n' | tr -d '[:punct:]' | tr 'A-Z' 'a-z' | grep -v '^$' | sort | uniq -c | sort -rn | head -10 | while read -r cnt word; do
        echo -e "  ${CYAN}▸${NC} ${WHITE}${word}${NC} ${DIM}(${cnt})${NC}"
    done
    pause
}
t_ascii() {
    sub "🎨 ASCII Art"
    ask "Text (A-Z only)"; read -r t
    echo ""
    local upper=$(echo "$t" | tr 'a-z' 'A-Z')
    # Simple single-row ASCII
    echo -e "  ${CYAN}╔══════════════════════════════════╗${NC}"
    echo -e "  ${CYAN}║${NC}  ${WHITE}${BOLD}$upper${NC}"
    echo -e "  ${CYAN}╚══════════════════════════════════╝${NC}"
    pause
}
t_time() {
    sub "📅 Timestamp Converter"
    echo -e "  ${PINK}[1]${NC} Timestamp → Date"
    echo -e "  ${PINK}[2]${NC} Date → Timestamp"
    ask "Choice"; read -r c
    if [ "$c" = "1" ]; then
        ask "Timestamp"; read -r ts
        echo ""; echo -e "  ${GREEN}✓${NC} ${WHITE}$(date -d "@$ts" 2>/dev/null || echo 'Invalid')${NC}"
    else
        ask "Date (YYYY-MM-DD HH:MM:SS)"; read -r d
        echo ""; echo -e "  ${GREEN}✓${NC} ${WHITE}$(date -d "$d" +%s 2>/dev/null || echo 'Invalid')${NC}"
    fi
    pause
}
t_hex2rgb() {
    sub "🎨 HEX → RGB"
    ask "HEX (#RRGGBB)"; read -r h
    h=${h#\#}
    [ ${#h} -ne 6 ] && { echo -e "  ${RED}✗ Invalid${NC}"; pause; return; }
    local r=$((16#${h:0:2}))
    local g=$((16#${h:2:2}))
    local b=$((16#${h:4:2}))
    echo ""; echo -e "  ${GREEN}✓${NC} ${WHITE}rgb($r, $g, $b)${NC}"
    pause
}
t_date() {
    sub "📅 Date & Time"
    echo ""
    echo -e "  ${CYAN}▸${NC} Date : ${WHITE}$(date '+%A, %d %B %Y')${NC}"
    echo -e "  ${CYAN}▸${NC} Time : ${WHITE}$(date '+%H:%M:%S')${NC}"
    echo -e "  ${CYAN}▸${NC} Epoch: ${WHITE}$(date +%s)${NC}"
    pause
}
t_calc() {
    sub "🧮 Calculator"
    ask "Expression (ex: 5+3*2)"; read -r e
    local out=$(echo "scale=6; $e" | bc 2>/dev/null)
    [ -z "$out" ] && echo -e "  ${RED}✗ Invalid${NC}" || echo -e "  ${GREEN}✓${NC} ${WHITE}$out${NC}"
    pause
}
t_upper_lower_swap() {
    sub "🔤 Swap Case"
    ask "Text"; read -r t
    local out=$(echo "$t" | tr 'A-Za-z' 'a-zA-Z')
    echo ""; echo -e "  ${GREEN}✓${NC} ${WHITE}$out${NC}"
    pause
}
t_extract_emails() {
    sub "📧 Extract Emails"
    ask "Text"; read -r t
    echo ""
    echo "$t" | grep -oE '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' | sort -u | while read -r e; do
        echo -e "  ${CYAN}▸${NC} ${WHITE}$e${NC}"
    done
    pause
}
t_extract_urls() {
    sub "🔗 Extract URLs"
    ask "Text"; read -r t
    echo ""
    echo "$t" | grep -oE 'https?://[^ ]+' | sort -u | while read -r u; do
        echo -e "  ${CYAN}▸${NC} ${WHITE}$u${NC}"
    done
    pause
}
t_remove_dup() {
    sub "🔍 Remove Duplicates"
    ask "Text (multiline, end with empty)"; read -r t
    echo ""
    echo "$t" | tr ' ' '\n' | sort -u | while read -r l; do
        echo -e "  ${WHITE}$l${NC}"
    done
    pause
}

# ============================================================
# MENUS
# ============================================================
menu_encoders() {
    while true; do
        sub "🔐 Encoders / Decoders"
        echo -e "  ${PINK}[1]${NC}  Base64 Encode      ${PINK}[2]${NC}  Base64 Decode"
        echo -e "  ${PINK}[3]${NC}  HEX Encode         ${PINK}[4]${NC}  HEX Decode"
        echo -e "  ${PINK}[5]${NC}  URL Encode         ${PINK}[6]${NC}  URL Decode"
        echo -e "  ${PINK}[7]${NC}  ROT13              ${PINK}[8]${NC}  Text → Morse"
        echo -e "  ${PINK}[9]${NC}  Text → Binary      ${PINK}[10]${NC} Reverse Text"
        echo -e "  ${PINK}[0]${NC}  Back"
        ask "Choose"; read -r c
        case "$c" in
            1) t_b64enc;; 2) t_b64dec;; 3) t_hexenc;; 4) t_hexdec;;
            5) t_urlenc;; 6) t_urldec;; 7) t_rot13;; 8) t_morse;;
            9) t_bin;; 10) t_rev;; 0) return;; *) ;;
        esac
    done
}

menu_generators() {
    while true; do
        sub "🔑 Generators"
        echo -e "  ${PINK}[1]${NC}  Password           ${PINK}[2]${NC}  Random String"
        echo -e "  ${PINK}[3]${NC}  UUID               ${PINK}[4]${NC}  Random Number"
        echo -e "  ${PINK}[5]${NC}  Random Color       ${PINK}[6]${NC}  Hashtag"
        echo -e "  ${PINK}[7]${NC}  Hash (MD5/SHA)     ${PINK}[8]${NC}  Lorem Ipsum"
        echo -e "  ${PINK}[0]${NC}  Back"
        ask "Choose"; read -r c
        case "$c" in
            1) t_pass;; 2) t_randstr;; 3) t_uuid;; 4) t_randnum;;
            5) t_randcolor;; 6) t_hashtag;; 7) t_hash;; 8) t_lorem;;
            0) return;; *) ;;
        esac
    done
}

menu_converters() {
    while true; do
        sub "🔨 Converters"
        echo -e "  ${PINK}[1]${NC}  Base Converter     ${PINK}[2]${NC}  Case Converter"
        echo -e "  ${PINK}[3]${NC}  Temperature        ${PINK}[4]${NC}  Unit Converter"
        echo -e "  ${PINK}[5]${NC}  Number → Roman     ${PINK}[6]${NC}  Text → Slug"
        echo -e "  ${PINK}[7]${NC}  HEX → RGB          ${PINK}[8]${NC}  Timestamp"
        echo -e "  ${PINK}[0]${NC}  Back"
        ask "Choose"; read -r c
        case "$c" in
            1) t_base;; 2) t_case;; 3) t_temp;; 4) t_unit;;
            5) t_roman;; 6) t_slug;; 7) t_hex2rgb;; 8) t_time;;
            0) return;; *) ;;
        esac
    done
}

menu_analyzers() {
    while true; do
        sub "📊 Analyzers"
        echo -e "  ${PINK}[1]${NC}  Text Statistics    ${PINK}[2]${NC}  Password Strength"
        echo -e "  ${PINK}[3]${NC}  BD Phone Info      ${PINK}[4]${NC}  Prime Checker"
        echo -e "  ${PINK}[5]${NC}  Age Calculator     ${PINK}[6]${NC}  BMI Calculator"
        echo -e "  ${PINK}[7]${NC}  Percentage         ${PINK}[8]${NC}  Word Frequency"
        echo -e "  ${PINK}[9]${NC}  Fibonacci          ${PINK}[10]${NC} Multiplication"
        echo -e "  ${PINK}[0]${NC}  Back"
        ask "Choose"; read -r c
        case "$c" in
            1) t_stats;; 2) t_passstrength;; 3) t_phone;; 4) t_prime;;
            5) t_age;; 6) t_bmi;; 7) t_percent;; 8) t_wordfreq;;
            9) t_fib;; 10) t_mult;; 0) return;; *) ;;
        esac
    done
}

menu_web() {
    while true; do
        sub "🌐 Web / Network Tools"
        echo -e "  ${PINK}[1]${NC}  IP Lookup          ${PINK}[2]${NC}  My IP"
        echo -e "  ${PINK}[3]${NC}  Domain Info        ${PINK}[4]${NC}  URL Shortener"
        echo -e "  ${PINK}[5]${NC}  Email Validator    ${PINK}[6]${NC}  QR Code"
        echo -e "  ${PINK}[7]${NC}  Extract Emails     ${PINK}[8]${NC}  Extract URLs"
        echo -e "  ${PINK}[0]${NC}  Back"
        ask "Choose"; read -r c
        case "$c" in
            1) t_iplookup;; 2) t_myip;; 3) t_domain;; 4) t_shorten;;
            5) t_emailval;; 6) t_qr;; 7) t_extract_emails;; 8) t_extract_urls;;
            0) return;; *) ;;
        esac
    done
}

menu_utility() {
    while true; do
        sub "📱 Utilities"
        echo -e "  ${PINK}[1]${NC}  Progress Bar       ${PINK}[2]${NC}  Star Rating"
        echo -e "  ${PINK}[3]${NC}  Dice Roller        ${PINK}[4]${NC}  Coin Flip"
        echo -e "  ${PINK}[5]${NC}  Text Repeater      ${PINK}[6]${NC}  Date & Time"
        echo -e "  ${PINK}[7]${NC}  Calculator         ${PINK}[8]${NC}  Swap Case"
        echo -e "  ${PINK}[9]${NC}  Remove Duplicates  ${PINK}[10]${NC} ASCII Art"
        echo -e "  ${PINK}[0]${NC}  Back"
        ask "Choose"; read -r c
        case "$c" in
            1) t_progress;; 2) t_stars;; 3) t_dice;; 4) t_coin;;
            5) t_repeat;; 6) t_date;; 7) t_calc;; 8) t_upper_lower_swap;;
            9) t_remove_dup;; 10) t_ascii;; 0) return;; *) ;;
        esac
    done
}

# ============================================================
# DIRECT COMMAND MODE
# ============================================================
run_direct() {
    case "$1" in
        b64enc) shift; printf '%s' "$*" | base64 -w0; echo;;
        b64dec) shift; printf '%s' "$*" | base64 -d 2>/dev/null; echo;;
        hash) shift; printf '%s' "$*" | sha256sum | cut -d' ' -f1;;
        md5) shift; printf '%s' "$*" | md5sum | cut -d' ' -f1;;
        pass) shift; local len=${1:-16}; cat /dev/urandom | tr -dc 'A-Za-z0-9!@#$%^&*' | head -c "$len"; echo;;
        uuid) cat /proc/sys/kernel/random/uuid;;
        ip) shift; local ip=${1:-$(curl -s --max-time 8 https://api.ipify.org)}; curl -s --max-time 10 "http://ip-api.com/json/$ip?fields=status,country,city,isp,query"; echo;;
        myip) curl -s --max-time 8 https://api.ipify.org; echo;;
        *) return 1;;
    esac
    return 0
}

# ============================================================
# MAIN
# ============================================================
main_menu() {
    while true; do
        title
        echo -e "  ${CYAN}╭──────────────────────────────────────────╮${NC}"
        echo -e "  ${CYAN}│${NC}  ${PINK}[1]${NC} 🔐  Encoders / Decoders               ${CYAN}│${NC}"
        echo -e "  ${CYAN}│${NC}  ${PINK}[2]${NC} 🔑  Generators                        ${CYAN}│${NC}"
        echo -e "  ${CYAN}│${NC}  ${PINK}[3]${NC} 🔨  Converters                        ${CYAN}│${NC}"
        echo -e "  ${CYAN}│${NC}  ${PINK}[4]${NC} 📊  Analyzers                         ${CYAN}│${NC}"
        echo -e "  ${CYAN}│${NC}  ${PINK}[5]${NC} 🌐  Web / Network                     ${CYAN}│${NC}"
        echo -e "  ${CYAN}│${NC}  ${PINK}[6]${NC} 📱  Utilities                         ${CYAN}│${NC}"
        echo -e "  ${CYAN}│${NC}  ${PINK}[0]${NC} 🚪  Exit                              ${CYAN}│${NC}"
        echo -e "  ${CYAN}╰──────────────────────────────────────────╯${NC}"
        echo ""
        echo -e "  ${DIM}Tip: Use direct commands: bhhk-tools b64enc \"text\"${NC}"
        echo ""
        ask "Select"; read -r c
        case "$c" in
            1) menu_encoders;;
            2) menu_generators;;
            3) menu_converters;;
            4) menu_analyzers;;
            5) menu_web;;
            6) menu_utility;;
            0) clear; echo -e "  ${PINK}⚡ Goodbye!${NC}"; echo ""; exit 0;;
            *) ;;
        esac
    done
}

# ENTRY
if [ $# -gt 0 ]; then
    run_direct "$@" || { echo "❌ Unknown command: $1"; exit 1; }
    exit 0
fi

# Boot animation
clear
echo ""
echo -e "${CYAN}    ╔══════════════════════════════════════════╗${NC}"
echo -e "${CYAN}    ║${NC}  ${PINK}🛠️   B H H K   T O O L S   v1.0   🛠️${NC}   ${CYAN}║${NC}"
echo -e "${CYAN}    ║${NC}      ${DIM}Multi Tool Collection${NC}              ${CYAN}║${NC}"
echo -e "${CYAN}    ╚══════════════════════════════════════════╝${NC}"
echo ""
for s in "Loading core tools" "Initializing modules" "Ready"; do
    local_fill=$(printf '█%.0s' {1..15})
    printf "\r  ${CYAN}▸${NC} ${WHITE}%-24s${NC} ${PINK}[%s]${NC}" "$s..." "$local_fill"
    sleep 0.3
done
echo ""
sleep 0.3
main_menu