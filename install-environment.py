#!/usr/bin/env -S uv run --script


# /// script
# requires-python = ">=3.13"
# dependencies = [
#     "typer",
# ]
# ///

"""

A simple, configurable dotfile linker script.

This script is designed to be run from within a dotfiles repository.
It reads a configuration map and symlinks files/directories from the
repository to their specified locations in the user's home directory.

It includes features for:

- Dry runs (to see what changes would be made).
- Backing up existing files before overwriting.
- Forcing overwrites of existing files/links.
- Creating necessary parent directories.
- Cross-platform support (Linux/macOS and Windows).
"""

import typer

import os
import platform
import shutil
import subprocess
import datetime
from pathlib import Path

# --- PLATFORM DETECTION ---

IS_WINDOWS = platform.system() == "Windows"

# --- CONFIGURATION ---


# Get the directory where this script is located (the root of your dotfiles repo).
# All source paths will be relative to this.
REPO_ROOT = Path(__file__).parent.resolve()

# Get the user's home directory.
# All destination paths will be relative to this.
HOME_DIR = Path.home()

# Configuration maps split by platform.
#
# "key" (source): The path to your file/directory *relative to this script*.
# "value" (destination): The path where it should be linked *relative to your HOME directory*.

COMMON_MAP = {
    "gitconfig": ".gitconfig",
    "gitignore": ".gitignore",
}

UNIX_MAP = {
    "bashrc": ".bashrc",
    "zshrc": ".zshrc",
    "oh-my-zsh": ".oh-my-zsh",
    "irssi": ".irssi",
    "xmonad": ".xmonad",
    "nvim.vim": ".config/nvim/init.vim",
    "vimrc": ".vimrc",
    "vim": ".vim",
    "alacritty/base.toml": ".config/alacritty/base.toml",
    "alacritty/linux.toml": ".config/alacritty/alacritty.toml",
    "fonts.conf": ".fonts.conf",
    "inputrc": ".inputrc",
    "Xdefaults": ".Xdefaults",
    "xmodmap": ".xmodmap",
}

WINDOWS_MAP = {
    "vimrc": "_vimrc",
    "vim": "vimfiles",
    "nvim.vim": "AppData/Local/nvim/init.vim",
    "alacritty/base.toml": "AppData/Roaming/alacritty/base.toml",
    "alacritty/windows.toml": "AppData/Roaming/alacritty/alacritty.toml",
}

# --- END CONFIGURATION ---


def _get_powershell_profile_path() -> Path | None:
    """Detect the PowerShell 7 profile path by asking pwsh."""
    try:
        # Pipe via stdin because $PROFILE gets lost when passed as a
        # command-line argument through Python subprocess on Windows.
        result = subprocess.run(
            ["pwsh", "-NoProfile", "-Command", "-"],
            input="$PROFILE",
            capture_output=True,
            text=True,
        )
        if result.returncode == 0 and result.stdout.strip():
            return Path(result.stdout.strip())
    except FileNotFoundError:
        pass
    return None


def _check_symlink_capability(dry_run: bool) -> bool:
    """Test that we can create symlinks on Windows. Returns True if OK."""
    if not IS_WINDOWS:
        return True

    if dry_run:
        return True

    test_target = REPO_ROOT / "install-environment.py"
    test_link = REPO_ROOT / ".symlink_test"
    try:
        os.symlink(test_target, test_link)
        os.remove(test_link)
        return True
    except OSError as e:
        if hasattr(e, "winerror") and e.winerror == 1314:
            typer.secho(
                "ERROR: Cannot create symlinks. "
                "Enable Developer Mode in Windows Settings or run as Administrator.",
                fg=typer.colors.RED,
                bold=True,
            )
        else:
            typer.secho(f"ERROR: Symlink test failed: {e}", fg=typer.colors.RED)
        return False


def _check_submodules() -> bool:
    """Check that git submodules have been initialized. Returns True if OK."""
    try:
        result = subprocess.run(
            ["git", "submodule", "status"],
            capture_output=True,
            text=True,
            cwd=REPO_ROOT,
        )
    except FileNotFoundError:
        typer.secho(
            "WARNING: git not found; skipping submodule check.",
            fg=typer.colors.YELLOW,
        )
        return True

    uninitialised = [
        line.strip().split()[1]
        for line in result.stdout.splitlines()
        if line.startswith("-")
    ]

    if uninitialised:
        typer.secho(
            "ERROR: The following git submodules are not initialised:",
            fg=typer.colors.RED,
            bold=True,
        )
        for name in uninitialised:
            typer.secho(f"  - {name}", fg=typer.colors.RED)
        typer.secho(
            "Run:  git submodule update --init --recursive",
            fg=typer.colors.YELLOW,
        )
        return False

    return True


def _build_dotfile_map() -> dict[str, str | Path]:
    """Build the dotfile map for the current platform."""
    dotfile_map: dict[str, str | Path] = {}
    dotfile_map.update(COMMON_MAP)

    if IS_WINDOWS:
        dotfile_map.update(WINDOWS_MAP)
    else:
        dotfile_map.update(UNIX_MAP)

    return dotfile_map


def main(
    dry_run: bool = typer.Option(
        False,
        "--dry-run",
        "-d",
        help="Print what would be done without actually making any changes.",
    ),
    force: bool = typer.Option(
        False,
        "--force",
        "-f",
        help="Forcefully overwrite/re-link existing files (backs them up first).",
    ),
):
    """
    Links dotfiles from this repository to your home directory.
    Automatically detects the platform and uses the appropriate file map.
    """

    if dry_run:
        typer.secho(
            "--- RUNNING IN DRY-RUN MODE (NO CHANGES WILL BE MADE) ---",
            fg=typer.colors.YELLOW,
            bold=True,
        )

    platform_name = "Windows" if IS_WINDOWS else "Unix"
    typer.secho(f"Platform:    {platform_name}", fg=typer.colors.CYAN)
    typer.secho(f"Source Repo: {REPO_ROOT}", fg=typer.colors.CYAN)
    typer.secho(f"Target Home: {HOME_DIR}", fg=typer.colors.CYAN)

    # Pre-flight checks
    if not _check_submodules():
        raise typer.Exit(code=1)

    if not _check_symlink_capability(dry_run):
        raise typer.Exit(code=1)

    # Build the map of source -> dest (relative to HOME)
    dotfile_map = _build_dotfile_map()

    # On Windows, dynamically detect the PowerShell profile path
    if IS_WINDOWS:
        ps_profile_path = _get_powershell_profile_path()
        if ps_profile_path:
            typer.secho(
                f"PowerShell profile: {ps_profile_path}", fg=typer.colors.CYAN
            )
            # Store as absolute path; we'll handle it specially below
            dotfile_map["powershell/profile.ps1"] = ps_profile_path
        else:
            typer.secho(
                "WARNING: Could not detect PowerShell profile path (is pwsh installed?). "
                "Skipping PowerShell profile link.",
                fg=typer.colors.YELLOW,
            )

    linked_count = 0
    skipped_count = 0
    error_count = 0

    for source_name, dest_name in dotfile_map.items():
        source_path = REPO_ROOT / source_name

        # dest_name is either relative to HOME (str) or absolute (Path)
        if isinstance(dest_name, Path):
            dest_path = dest_name
        else:
            dest_path = HOME_DIR / dest_name

        typer.secho("-" * 20, bold=True)

        typer.secho(f"Processing: {source_name} -> {dest_path}")

        # 1. Check if source exists
        if not source_path.exists():
            typer.secho(
                f"  [ERROR] Source not found: {source_path}", fg=typer.colors.RED
            )
            error_count += 1
            continue

        # 2. Check destination
        if dest_path.exists() or dest_path.is_symlink():
            # 2a. It's already a symlink
            if dest_path.is_symlink():
                current_target = os.path.realpath(dest_path)

                # Check if it's already linked to the *correct* source
                if current_target == str(source_path):
                    typer.secho(
                        "  [SKIP] Already linked correctly.", fg=typer.colors.GREEN
                    )
                    skipped_count += 1
                    continue

                else:
                    typer.secho(
                        "  [WARN] Already linked, but to a different target:",
                        fg=typer.colors.YELLOW,
                    )
                    typer.echo(f"           Target: {current_target}")
                    if not force:
                        typer.secho(
                            "  [SKIP] Use --force to re-link.", fg=typer.colors.YELLOW
                        )
                        skipped_count += 1
                        continue
                    # If --force, fall through to backup and relink

            # 2b. It's an existing file or directory
            else:
                typer.secho(
                    f"  [WARN] Destination exists and is not a link: {dest_path}",
                    fg=typer.colors.YELLOW,
                )
                if not force:
                    typer.secho(
                        "  [SKIP] Use --force to overwrite (will back up).",
                        fg=typer.colors.YELLOW,
                    )
                    skipped_count += 1
                    continue

            # 2c. Backup logic (only runs if --force and (exists or wrong symlink))

            try:
                backup_time = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
                backup_path = dest_path.with_suffix(
                    f"{dest_path.suffix}.bak.{backup_time}"
                )
                typer.secho(
                    f"  [ACTION] Backing up: {dest_path} -> {backup_path}",
                    fg=typer.colors.BLUE,
                )

                if not dry_run:
                    shutil.move(str(dest_path), str(backup_path))

            except Exception as e:
                typer.secho(f"  [ERROR] Failed to back up: {e}", fg=typer.colors.RED)

                error_count += 1
                continue

        # 3. Create parent directory for destination if it doesn't exist

        parent_dir = dest_path.parent
        if not parent_dir.exists():
            typer.secho(
                f"  [ACTION] Creating parent directory: {parent_dir}",
                fg=typer.colors.BLUE,
            )
            if not dry_run:
                try:
                    os.makedirs(parent_dir)
                except Exception as e:
                    typer.secho(
                        f"  [ERROR] Failed to create directory: {e}",
                        fg=typer.colors.RED,
                    )
                    error_count += 1

                    continue

        # 4. Create the symlink
        typer.secho(
            f"  [ACTION] Linking: {source_path} -> {dest_path}",
            fg=typer.colors.BRIGHT_GREEN,
        )
        if not dry_run:
            try:
                os.symlink(
                    source_path,
                    dest_path,
                    target_is_directory=source_path.is_dir(),
                )
                linked_count += 1
            except OSError as e:
                if IS_WINDOWS and hasattr(e, "winerror") and e.winerror == 1314:
                    typer.secho(
                        "  [ERROR] Insufficient privileges to create symlink. "
                        "Enable Developer Mode or run as Administrator.",
                        fg=typer.colors.RED,
                    )
                else:
                    typer.secho(
                        f"  [ERROR] Failed to create symlink: {e}",
                        fg=typer.colors.RED,
                    )
                error_count += 1

        else:
            # In dry-run, we count what *would* be linked
            linked_count += 1

    # --- Summary ---

    typer.echo("=" * 20)

    if dry_run:
        typer.secho("--- DRY-RUN COMPLETE ---", fg=typer.colors.YELLOW, bold=True)
        typer.secho(f"Would link: {linked_count}", fg=typer.colors.BRIGHT_GREEN)
    else:
        typer.secho("--- LINKING COMPLETE ---", fg=typer.colors.GREEN, bold=True)
        typer.secho(f"Linked: {linked_count}", fg=typer.colors.BRIGHT_GREEN)

    typer.secho(f"Skipped: {skipped_count}", fg=typer.colors.CYAN)
    typer.secho(f"Errors: {error_count}", fg=typer.colors.RED)

    if error_count > 0:
        typer.secho("Completed with errors.", fg=typer.colors.RED)
        raise typer.Exit(code=1)
    else:
        typer.secho("All tasks completed successfully.", fg=typer.colors.GREEN)


if __name__ == "__main__":
    typer.run(main)
