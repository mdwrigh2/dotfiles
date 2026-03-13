#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# bootstrap.sh — Stage 0: get the dotfiles repo onto a bare machine
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/mdwrigh2/dotfiles/main/bootstrap.sh | bash
# =============================================================================

# --- Colors & logging --------------------------------------------------------

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

info()  { printf "${CYAN}[INFO]${NC}  %s\n" "$*"; }
ok()    { printf "${GREEN}[OK]${NC}    %s\n" "$*"; }
warn()  { printf "${YELLOW}[WARN]${NC}  %s\n" "$*"; }
error() { printf "${RED}[ERROR]${NC} %s\n" "$*" >&2; }

# --- Distro detection --------------------------------------------------------

detect_distro() {
    if [[ -f /etc/os-release ]]; then
        # shellcheck disable=SC1091
        . /etc/os-release
        case "$ID" in
            arch)           echo "arch" ;;
            debian|ubuntu)  echo "debian" ;;
            *)
                error "Unsupported distro: $ID"
                exit 1
                ;;
        esac
    else
        error "Cannot detect distro (/etc/os-release not found)"
        exit 1
    fi
}

# --- Install git + openssh if missing ----------------------------------------

install_prerequisites() {
    local distro="$1"

    if command -v git &>/dev/null && command -v ssh &>/dev/null; then
        ok "git and ssh already installed"
        return
    fi

    info "Installing git and openssh..."
    case "$distro" in
        arch)
            sudo pacman -Sy --needed --noconfirm git openssh
            ;;
        debian)
            sudo apt-get update -y
            sudo apt-get install -y git openssh-client
            ;;
    esac
    ok "git and ssh installed"
}

# --- SSH key generation -------------------------------------------------------

setup_ssh_key() {
    local key="$HOME/.ssh/id_ed25519"

    if [[ -f "$key" ]]; then
        ok "SSH key already exists: $key"
    else
        read -r -p "Email address for SSH key [m@mdw.dev]: " email </dev/tty
        email="${email:-m@mdw.dev}"
        info "Generating SSH key..."
        ssh-keygen -t ed25519 -C "$email" </dev/tty
        ok "SSH key generated"
    fi

    echo ""
    info "Public key:"
    echo ""
    cat "${key}.pub"
    echo ""
    info "Add this key to GitHub: https://github.com/settings/ssh/new"
    echo ""
    read -r -p "Press Enter once the key is registered with GitHub..." </dev/tty
}

# --- Clone dotfiles -----------------------------------------------------------

clone_dotfiles() {
    local default_dir="$HOME/code/personal/dotfiles"

    echo ""
    read -r -p "Dotfiles directory [$default_dir]: " dotfiles_dir </dev/tty
    dotfiles_dir="${dotfiles_dir:-$default_dir}"

    if [[ -d "$dotfiles_dir/.git" ]]; then
        ok "Dotfiles already cloned at $dotfiles_dir"
    else
        info "Cloning dotfiles to $dotfiles_dir..."
        mkdir -p "$(dirname "$dotfiles_dir")"
        git clone git@github.com:mdwrigh2/dotfiles.git "$dotfiles_dir"
        ok "Dotfiles cloned"
    fi

    info "Initializing submodules..."
    git -C "$dotfiles_dir" submodule update --init --recursive
    ok "Submodules initialized"

    echo "$dotfiles_dir"
}

# --- Main ---------------------------------------------------------------------

main() {
    info "Dotfiles bootstrap — Stage 0"
    echo ""

    local distro
    distro="$(detect_distro)"
    info "Detected distro: $distro"

    install_prerequisites "$distro"
    setup_ssh_key

    local dotfiles_dir
    dotfiles_dir="$(clone_dotfiles)"

    echo ""
    info "Handing off to install.sh..."
    exec bash "$dotfiles_dir/install.sh"
}

main
