#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# install.sh — Stage 1 Linux: install all dependencies and link dotfiles
#
# Can be run standalone from inside the repo or called by bootstrap.sh.
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

# --- Packages -----------------------------------------------------------------

ARCH_PACKAGES=(
    base-devel
    clang
    curl
    fzf
    git
    go
    gzip
    less
    man-db
    neovim
    openssh
    python
    rustup
    sudo
    tar
    unzip
    which
    zsh
)

DEBIAN_PACKAGES=(
    build-essential
    clang
    curl
    fzf
    git
    golang-go
    gzip
    less
    man-db
    neovim
    openssh-client
    python3
    sudo
    tar
    unzip
    zsh
)

CARGO_PACKAGES=(
    bat
    eza
    fd-find
    git-delta
    tree-sitter-cli
    uv
    zoxide
)

# --- System packages ----------------------------------------------------------

install_system_packages() {
    local distro="$1"

    info "Installing system packages..."
    case "$distro" in
        arch)
            sudo pacman -Sy --needed --noconfirm "${ARCH_PACKAGES[@]}"
            ;;
        debian)
            sudo apt-get update -y
            sudo apt-get install -y "${DEBIAN_PACKAGES[@]}"
            ;;
    esac
    ok "System packages installed"
}

# --- Rustup / Cargo ----------------------------------------------------------

setup_rust() {
    local distro="$1"

    # On Debian, rustup isn't in the repos — install via the official script
    if [[ "$distro" == "debian" ]] && ! command -v rustup &>/dev/null; then
        info "Installing rustup..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
        ok "rustup installed"
    fi

    # Source cargo env so we can use cargo/rustup in this session
    if [[ -f "$HOME/.cargo/env" ]]; then
        # shellcheck disable=SC1091
        source "$HOME/.cargo/env"
    fi

    # Set default toolchain if none is set
    if ! rustup default &>/dev/null; then
        info "Setting default Rust toolchain to stable..."
        rustup default stable
        ok "Default toolchain set to stable"
    else
        ok "Rust default toolchain already set"
    fi
}

# --- Cargo packages -----------------------------------------------------------

install_cargo_packages() {
    local installed
    installed="$(cargo install --list)"

    for pkg in "${CARGO_PACKAGES[@]}"; do
        if echo "$installed" | grep -q "^${pkg} "; then
            ok "cargo: $pkg already installed"
        else
            info "cargo: installing $pkg..."
            cargo install "$pkg"
            ok "cargo: $pkg installed"
        fi
    done
}

# --- nvm + Node ---------------------------------------------------------------

setup_nvm() {
    export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

    if [[ ! -d "$NVM_DIR" ]]; then
        info "Installing nvm..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | PROFILE=/dev/null bash
        ok "nvm installed"
    else
        ok "nvm already installed"
    fi

    # Source nvm for this session
    # shellcheck disable=SC1091
    [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

    info "Installing latest LTS Node..."
    nvm install --lts
    ok "Node LTS installed"
}

# --- Dotfile linking ----------------------------------------------------------

link_dotfiles() {
    info "Linking dotfiles..."
    uv run "$SCRIPT_DIR/install-environment.py" --force
    ok "Dotfiles linked"
}

# --- Default shell ------------------------------------------------------------

maybe_change_shell() {
    local current_shell
    current_shell="$(getent passwd "$(whoami)" | cut -d: -f7)"
    local zsh_path
    zsh_path="$(command -v zsh)"

    if [[ "$current_shell" == "$zsh_path" ]]; then
        ok "Default shell is already zsh"
        return
    fi

    echo ""
    read -r -p "Change default shell to zsh? [Y/n] " answer </dev/tty
    answer="${answer:-Y}"
    if [[ "$answer" =~ ^[Yy] ]]; then
        info "Changing default shell to zsh..."
        chsh -s "$zsh_path"
        ok "Default shell changed to zsh"
    else
        warn "Skipping shell change"
    fi
}

# --- Main ---------------------------------------------------------------------

main() {
    info "Dotfiles install — Stage 1 (Linux)"
    echo ""

    local distro
    distro="$(detect_distro)"
    info "Detected distro: $distro"

    install_system_packages "$distro"
    setup_rust "$distro"
    install_cargo_packages
    setup_nvm
    link_dotfiles
    maybe_change_shell

    echo ""
    echo "========================================"
    ok "Installation complete!"
    echo "========================================"
    info "Open a new terminal (or run 'exec zsh') to start using your environment."
}

main
