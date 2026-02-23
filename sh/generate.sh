#!/usr/bin/env bash
# =============================================================================
#  aes_ecb_demo.sh
#  Install OpenSSL, generate a random key + plaintext, encrypt with AES-ECB
#
#  Usage: ./aes_ecb_demo.sh [KEY_BITS] [PLAINTEXT_BYTES]
# =============================================================================

set -euo pipefail

# ── Colors ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'
YELLOW='\033[1;33m'; BOLD='\033[1m'; RESET='\033[0m'

info()    { echo -e "${CYAN}[INFO]${RESET}  $*"; }
ok()      { echo -e "${GREEN}[OK]${RESET}    $*"; }
warn()    { echo -e "${YELLOW}[WARN]${RESET}  $*"; }
err()     { echo -e "${RED}[ERROR]${RESET} $*" >&2; }
section() { echo -e "\n${BOLD}── $* ──${RESET}"; }

usage() {
    echo -e "${BOLD}Usage:${RESET} $0 [KEY_BITS] [PLAINTEXT_BYTES]"
    echo ""
    echo -e "  ${CYAN}KEY_BITS${RESET}        AES key size in bits: 128, 192, or 256  (default: 128)"
    echo -e "  ${CYAN}PLAINTEXT_BYTES${RESET} Plaintext size in bytes                 (default: 64)"
    echo -e "                  Must be a multiple of 16 (AES block = 128-bit)"
    echo ""
    echo -e "${BOLD}Examples:${RESET}"
    echo "  $0               # AES-128,  64 bytes (4 blocks)"
    echo "  $0 256           # AES-256,  64 bytes (4 blocks)"
    echo "  $0 256 128       # AES-256, 128 bytes (8 blocks)"
    echo "  $0 192 32        # AES-192,  32 bytes (2 blocks)"
}

# ── Parse & validate arguments ────────────────────────────────────────────────
[[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && usage && exit 0

KEY_BITS="${1:-128}"
PLAINTEXT_BYTES="${2:-64}"

VALID=true

if [[ "${KEY_BITS}" != "128" && "${KEY_BITS}" != "192" && "${KEY_BITS}" != "256" ]]; then
    err "KEY_BITS must be 128, 192, or 256. Got: '${KEY_BITS}'"
    VALID=false
fi

if ! [[ "${PLAINTEXT_BYTES}" =~ ^[1-9][0-9]*$ ]]; then
    err "PLAINTEXT_BYTES must be a positive integer. Got: '${PLAINTEXT_BYTES}'"
    VALID=false
elif (( PLAINTEXT_BYTES % 16 != 0 )); then
    err "PLAINTEXT_BYTES must be a multiple of 16. Got: ${PLAINTEXT_BYTES} (remainder: $((PLAINTEXT_BYTES % 16)))"
    VALID=false
fi

if [[ "${VALID}" == "false" ]]; then
    echo ""
    usage
    exit 1
fi

# ── Derived config ────────────────────────────────────────────────────────────
KEY_BYTE_LEN=$(( KEY_BITS / 8 ))
BLOCKS=$(( PLAINTEXT_BYTES / 16 ))

OUT_DIR="./out"
KEY_HEX_FILE="${OUT_DIR}/key.hex"
PLAIN_FILE="${OUT_DIR}/plaintext.bin"
PLAIN_HEX_FILE="${OUT_DIR}/plaintext.hex"
CIPHER_FILE="${OUT_DIR}/ciphertext.bin"
CIPHER_HEX_FILE="${OUT_DIR}/ciphertext.hex"
DECRYPTED_FILE="${OUT_DIR}/decrypted.bin"

echo -e "${BOLD}AES-${KEY_BITS}-ECB Demo${RESET}  |  key=${KEY_BITS}-bit  plaintext=${PLAINTEXT_BYTES}B (${BLOCKS} blocks)"

# =============================================================================
# 1. Install OpenSSL
# =============================================================================
section "Step 1: Install OpenSSL"

SUDO=""; [[ "$(id -u)" != "0" ]] && command -v sudo &>/dev/null && SUDO="sudo"

install_openssl() {
    if command -v openssl &>/dev/null; then
        ok "openssl CLI already installed: $(openssl version)"
    else
        info "Installing openssl..."
        if command -v apt-get &>/dev/null; then
            ${SUDO} apt-get update -qq
            ${SUDO} apt-get install -y openssl libssl-dev xxd
        elif command -v dnf &>/dev/null; then
            ${SUDO} dnf install -y openssl openssl-devel
        elif command -v yum &>/dev/null; then
            ${SUDO} yum install -y openssl openssl-devel
        elif command -v brew &>/dev/null; then
            brew install openssl
        else
            err "Unsupported package manager. Install openssl manually."
            exit 1
        fi
        ok "openssl installed: $(openssl version)"
    fi

    # libssl-dev (C headers)
    if dpkg -s libssl-dev &>/dev/null 2>&1; then
        ok "libssl-dev already installed"
    elif command -v apt-get &>/dev/null; then
        info "Installing libssl-dev..."
        ${SUDO} apt-get install -y libssl-dev xxd -qq
        ok "libssl-dev installed"
    else
        warn "libssl-dev check skipped (non-Debian system)"
    fi
}

install_openssl

# =============================================================================
# 2. Prepare output directory
# =============================================================================
section "Step 2: Prepare output directory"
mkdir -p "${OUT_DIR}"
ok "Output directory: ${OUT_DIR}/"

# =============================================================================
# 3. Generate random AES key
# =============================================================================
section "Step 3: Generate random AES-${KEY_BITS} key"

openssl rand -hex ${KEY_BYTE_LEN} > "${KEY_HEX_FILE}"
KEY_HEX=$(cat "${KEY_HEX_FILE}")

ok "Key (${KEY_BITS}-bit, ${KEY_BYTE_LEN} bytes) saved to ${KEY_HEX_FILE}"
echo -e "    ${YELLOW}${KEY_HEX}${RESET}"

# =============================================================================
# 4. Generate random plaintext
# =============================================================================
section "Step 4: Generate random plaintext (${PLAINTEXT_BYTES} bytes, ${BLOCKS} blocks)"

openssl rand ${PLAINTEXT_BYTES} > "${PLAIN_FILE}"
xxd -p "${PLAIN_FILE}" | tr -d '\n' > "${PLAIN_HEX_FILE}"

ok "Plaintext saved to ${PLAIN_FILE}"
echo -e "    ${YELLOW}$(cat "${PLAIN_HEX_FILE}")${RESET}"
ok "${BLOCKS} x 128-bit AES blocks -- -nopad safe"

# =============================================================================
# 5. Encrypt with AES-ECB
# =============================================================================
section "Step 5: Encrypt with AES-${KEY_BITS}-ECB"

openssl enc \
    -aes-${KEY_BITS}-ecb \
    -in  "${PLAIN_FILE}" \
    -out "${CIPHER_FILE}" \
    -K   "${KEY_HEX}" \
    -nosalt \
    -nopad

xxd -p "${CIPHER_FILE}" | tr -d '\n' > "${CIPHER_HEX_FILE}"

ok "Ciphertext saved to ${CIPHER_FILE}"
echo -e "    ${YELLOW}$(cat "${CIPHER_HEX_FILE}")${RESET}"

# =============================================================================
# 6. Verify: decrypt and compare
# =============================================================================
section "Step 6: Verify -- decrypt and compare"

openssl enc \
    -aes-${KEY_BITS}-ecb \
    -d \
    -in  "${CIPHER_FILE}" \
    -out "${DECRYPTED_FILE}" \
    -K   "${KEY_HEX}" \
    -nosalt \
    -nopad

if cmp -s "${PLAIN_FILE}" "${DECRYPTED_FILE}"; then
    ok "Decrypt -> matches original plaintext"
else
    err "Decrypted output does NOT match plaintext!"
    exit 1
fi

# =============================================================================
# 7. Summary
# =============================================================================
section "Summary"
echo -e "  Algorithm  : AES-${KEY_BITS}-ECB"
echo -e "  Key        : ${KEY_BITS}-bit  ->  ${KEY_HEX_FILE}"
echo -e "  Plaintext  : ${PLAINTEXT_BYTES} bytes, ${BLOCKS} blocks  ->  ${PLAIN_FILE}"
echo -e "  Ciphertext : ${CIPHER_FILE}"
echo -e "  Decrypted  : ${DECRYPTED_FILE}"
echo ""
echo -e "  ${BOLD}Block-by-block view:${RESET}"

for (( i=0; i<BLOCKS; i++ )); do
    P_BLOCK=$(dd if="${PLAIN_FILE}"  bs=16 skip=${i} count=1 2>/dev/null | xxd -p | tr -d '\n')
    C_BLOCK=$(dd if="${CIPHER_FILE}" bs=16 skip=${i} count=1 2>/dev/null | xxd -p | tr -d '\n')
    printf "  Block %-3d : P=%b%s%b  ->  C=%b%s%b\n" \
        "$((i+1))" \
        "${CYAN}" "${P_BLOCK}" "${RESET}" \
        "${GREEN}" "${C_BLOCK}" "${RESET}"
done

echo ""
ok "Done."