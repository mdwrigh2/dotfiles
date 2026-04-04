#!/usr/bin/env bash
# Claude Code notification hook — platform dispatcher.
# Called by the Notification hook event with JSON on stdin.
# Always exits 0 so notification failures never block Claude.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INPUT="$(cat)"

notify_windows() {
    local ps_script
    # Convert to Windows path if running under MSYS/Git Bash
    ps_script="$(cygpath -w "$SCRIPT_DIR/notify-windows.ps1" 2>/dev/null || echo "$SCRIPT_DIR/notify-windows.ps1")"
    echo "$INPUT" | powershell.exe -ExecutionPolicy Bypass -NoProfile -File "$ps_script"
}

notify_wsl() {
    local ps_script
    ps_script="$(wslpath -w "$SCRIPT_DIR/notify-windows.ps1")"
    echo "$INPUT" | powershell.exe -ExecutionPolicy Bypass -NoProfile -File "$ps_script"
}

notify_linux() {
    local title message
    title="$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('title','Claude Code'))" 2>/dev/null || echo "Claude Code")"
    message="$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('message',''))" 2>/dev/null || echo "")"
    notify-send "$title" "$message" 2>/dev/null || true
}

{
    if [[ "${OSTYPE:-}" == msys* || "${OSTYPE:-}" == mingw* || "${OSTYPE:-}" == cygwin* ]]; then
        notify_windows
    elif grep -qi microsoft /proc/version 2>/dev/null; then
        notify_wsl
    else
        notify_linux
    fi
} || true

exit 0
