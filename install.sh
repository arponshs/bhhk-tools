#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# BHHK TOOLS — Installer
# ============================================================

CYAN='\033[0;36m'; PINK='\033[0;35m'; GREEN='\033[0;32m'
YELLOW='\033[1;33m'; RED='\033[0;31m'; WHITE='\033[1;37m'
DIM='\033[2m'; NC='\033[0m'

clear
echo ""
echo -e "${CYAN}    ╔══════════════════════════════════════════╗${NC}"
echo -e "${CYAN}    ║${NC}  ${PINK}🛠️   B H H K   T O O L S   v1.0   🛠️${NC}   ${CYAN}║${NC}"
echo -e "${CYAN}    ╚══════════════════════════════════════════╝${NC}"
echo ""

echo -e "${CYAN}▸${NC} ${WHITE}Updating packages...${NC}"
pkg update -y > /dev/null 2>&1

echo -e "${CYAN}▸${NC} ${WHITE}Installing dependencies...${NC}"
for pkg in bash curl coreutils bc xxd; do
    if command -v "${pkg/coreutils/coreutils}" > /dev/null 2>&1 || dpkg -l "$pkg" > /dev/null 2>&1; then
        echo -e "  ${DIM}✓ ${pkg} already installed${NC}"
    else
        echo -e "  ${DIM}▸ installing ${pkg}...${NC}"
        pkg install -y "$pkg" > /dev/null 2>&1
        echo -e "  ${GREEN}✓${NC} ${WHITE}${pkg} installed${NC}"
    fi
done
echo ""

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
MAIN_SCRIPT="$SCRIPT_DIR/bhhk-tools.sh"

if [ ! -f "$MAIN_SCRIPT" ]; then
    echo -e "${RED}✗ bhhk-tools.sh not found${NC}"
    exit 1
fi

chmod +x "$MAIN_SCRIPT"
echo -e "${GREEN}✓${NC} ${WHITE}bhhk-tools.sh ready${NC}"

BIN_DIR="$PREFIX/bin"
if [ -z "$PREFIX" ]; then
    echo -e "${RED}✗ Termux not detected${NC}"
    exit 1
fi

cat > "$BIN_DIR/bhhk-tools" << EOF
#!/data/data/com.termux/files/usr/bin/bash
exec bash "$MAIN_SCRIPT" "\$@"
EOF

chmod +x "$BIN_DIR/bhhk-tools"
echo -e "${GREEN}✓${NC} ${WHITE}Command registered:${NC} ${PINK}bhhk-tools${NC}"
echo ""

echo -e "${CYAN}    ╔══════════════════════════════════════════╗${NC}"
echo -e "${CYAN}    ║${NC}  ${GREEN}✓ INSTALLATION COMPLETE${NC}                ${CYAN}║${NC}"
echo -e "${CYAN}    ║${NC}                                          ${CYAN}║${NC}"
echo -e "${CYAN}    ║${NC}  ${WHITE}Run:${NC} ${PINK}bhhk-tools${NC}                      ${CYAN}║${NC}"
echo -e "${CYAN}    ╚══════════════════════════════════════════╝${NC}"
echo ""

printf "  ${DIM}Launch now? [Y/n]: ${NC}"
read -r ans
case "$ans" in
    n|N) echo -e "\n  ${DIM}Run 'bhhk-tools' anytime.${NC}\n";;
    *) bash "$MAIN_SCRIPT";;
esac