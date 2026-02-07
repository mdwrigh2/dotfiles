#Requires -Version 5.1
<#
.SYNOPSIS
    Bootstrap script for a fresh Windows machine.
    Installs development tools via winget and PowerShell modules.
.DESCRIPTION
    Run this script in an elevated PowerShell session on a fresh Windows install.
    It will install CLI tools via winget and PowerShell modules from the Gallery.
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Continue"

# --- Check for Developer Mode ---
$devModeKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"
$devModeEnabled = (Get-ItemProperty -Path $devModeKey -Name AllowDevelopmentWithoutDevLicense -ErrorAction SilentlyContinue).AllowDevelopmentWithoutDevLicense -eq 1

if (-not $devModeEnabled) {
    Write-Host "ERROR: Developer Mode is not enabled." -ForegroundColor Red
    Write-Host "Developer Mode is required to create symlinks without exceeding path limits." -ForegroundColor Red
    Write-Host "Enable it in: Settings > Privacy & Security > For developers > Developer Mode" -ForegroundColor Yellow
    exit 1
}

Write-Host "Developer Mode is enabled." -ForegroundColor Green

# --- winget packages ---
# Python and uv are installed first since install-environment.py needs them.
$wingetPackages = @(
    "Python.Python.3.13"
    "astral-sh.uv"
    "Git.Git"
    "Neovim.Neovim"
    "Microsoft.PowerShell"
    "sharkdp.bat"
    "eza-community.eza"
    "sharkdp.fd"
    "dandavison.delta"
    "ajeetdsouza.zoxide"
    "junegunn.fzf"
    "BurntSushi.ripgrep.MSVC"
    "Alacritty.Alacritty"
    "Rustlang.Rustup"
)

# --- PowerShell modules ---
$psModules = @(
    "PSReadLine"
    "PSFzf"
    "posh-git"
    "Terminal-Icons"
)

# --- Install winget packages ---
Write-Host "`n=== Installing winget packages ===" -ForegroundColor Cyan

$wingetSuccess = @()
$wingetFailed = @()

$wingetAlreadyInstalled = @()

foreach ($pkg in $wingetPackages) {
    # Check if already installed before attempting install, so that winget
    # doesn't try to upgrade a running application (e.g. the terminal itself).
    winget list --id $pkg --accept-source-agreements | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "`n$pkg is already installed." -ForegroundColor DarkGray
        $wingetAlreadyInstalled += $pkg
        continue
    }

    Write-Host "`nInstalling $pkg..." -ForegroundColor Yellow
    winget install --id $pkg --accept-package-agreements --accept-source-agreements --silent
    if ($LASTEXITCODE -eq 0) {
        $wingetSuccess += $pkg
    } else {
        $wingetFailed += $pkg
    }
}

# --- Install PowerShell modules ---
Write-Host "`n=== Installing PowerShell modules ===" -ForegroundColor Cyan

$moduleSuccess = @()
$moduleFailed = @()
$moduleAlreadyInstalled = @()

foreach ($mod in $psModules) {
    if (Get-Module -ListAvailable -Name $mod) {
        Write-Host "`n$mod is already installed." -ForegroundColor DarkGray
        $moduleAlreadyInstalled += $mod
        continue
    }

    Write-Host "`nInstalling module $mod..." -ForegroundColor Yellow
    try {
        Install-Module -Name $mod -Force -Scope CurrentUser -AllowClobber
        $moduleSuccess += $mod
    } catch {
        Write-Host "  Failed to install ${mod}: $_" -ForegroundColor Red
        $moduleFailed += $mod
    }
}

# --- Summary ---
Write-Host "`n=== Summary ===" -ForegroundColor Cyan

Write-Host "`nwinget packages installed: $($wingetSuccess.Count)/$($wingetPackages.Count)" -ForegroundColor Green
if ($wingetAlreadyInstalled.Count -gt 0) {
    Write-Host "  Already installed: $($wingetAlreadyInstalled -join ', ')" -ForegroundColor DarkGray
}
if ($wingetFailed.Count -gt 0) {
    Write-Host "  Failed: $($wingetFailed -join ', ')" -ForegroundColor Red
}

Write-Host "PowerShell modules installed: $($moduleSuccess.Count)/$($psModules.Count)" -ForegroundColor Green
if ($moduleAlreadyInstalled.Count -gt 0) {
    Write-Host "  Already installed: $($moduleAlreadyInstalled -join ', ')" -ForegroundColor DarkGray
}
if ($moduleFailed.Count -gt 0) {
    Write-Host "  Failed: $($moduleFailed -join ', ')" -ForegroundColor Red
}

Write-Host "`nDone! Restart your terminal to pick up PATH changes." -ForegroundColor Green
Write-Host "Then run: uv run install-environment.py" -ForegroundColor Yellow
