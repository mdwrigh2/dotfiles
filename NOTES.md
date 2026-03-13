# Notes

Quick reference for what the install scripts set up. See `install.sh` (Linux)
and `install.ps1` (Windows) for the full details.

## Linux

### System packages

Arch:
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

Debian/Ubuntu:
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

### Cargo packages

    bat
    eza
    fd-find
    git-delta
    tree-sitter-cli
    uv
    zoxide

### nvm

Installed via the official install script. Provides Node LTS.

### Dotfile linking

`install-environment.py` symlinks configs from this repo into `$HOME`.

## Windows

### winget packages

    Python.Python.3.13
    astral-sh.uv
    Git.Git
    Neovim.Neovim
    Microsoft.PowerShell
    sharkdp.bat
    eza-community.eza
    sharkdp.fd
    dandavison.delta
    ajeetdsouza.zoxide
    junegunn.fzf
    BurntSushi.ripgrep.MSVC
    Alacritty.Alacritty
    Rustlang.Rustup

### PowerShell modules

    PSReadLine
    PSFzf
    posh-git
    Terminal-Icons
