# PowerShell 7 Profile
# Mirrors modern CLI tool aliases from zshrc

# --- Editor ---
$env:EDITOR = "nvim"

# --- Modern CLI aliases ---

# Swap out cat for bat
# https://github.com/sharkdp/bat
if (Get-Command bat -ErrorAction SilentlyContinue) {
    Set-Alias -Name cat -Value bat -Option AllScope
}

# Swap out ls for eza
# https://github.com/eza-community/eza
if (Get-Command eza -ErrorAction SilentlyContinue) {
    Remove-Item Alias:ls -ErrorAction SilentlyContinue
    function ls { eza @args }
}

# --- Convenience aliases ---
Set-Alias -Name g -Value git
Set-Alias -Name vim -Value nvim

function .. { Set-Location .. }
function ... { Set-Location ..\.. }

# --- PSReadLine ---
if (Get-Module -ListAvailable -Name PSReadLine) {
    Set-PSReadLineOption -EditMode Emacs
    Set-PSReadLineOption -BellStyle None
    Set-PSReadLineOption -PredictionSource None
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
}

# --- fzf integration ---
# https://github.com/junegunn/fzf
if (Get-Module -ListAvailable -Name PSFzf) {
    Import-Module PSFzf
    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
}

# --- zoxide ---
# https://github.com/ajeetdsouza/zoxide
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

# --- posh-git ---
if (Get-Module -ListAvailable -Name posh-git) {
    Import-Module posh-git
}

# --- Terminal-Icons ---
if (Get-Module -ListAvailable -Name Terminal-Icons) {
    Import-Module Terminal-Icons
}
