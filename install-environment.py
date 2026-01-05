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
It reads a configuration map (DOTFILE_MAP) and symlinks files/directories
from the repository to their specified locations in the user's home directory.

It includes features for:

- Dry runs (to see what changes would be made).
- Backing up existing files before overwriting.

- Forcing overwrites of existing files/links.
- Creating necessary parent directories.
"""

import typer

import os
import shutil
import datetime
from pathlib import Path

# --- CONFIGURATION ---


# Get the directory where this script is located (the root of your dotfiles repo).
# All source paths will be relative to this.
REPO_ROOT = Path(__file__).parent.resolve()

# Get the user's home directory.
# All destination paths will be relative to this.
HOME_DIR = Path.home()

# This is the main configuration map.
#
# "key": "value"
#
# "key" (source): The path to your file/directory *relative to this script*.
#                 (e.g., "nvim" for <repo_root>/nvim)
#
# "value" (destination): The path where it should be linked *relative to your HOME directory*.
#                        (e.g., ".config/nvim" for /home/user/.config/nvim)
#
DOTFILE_MAP = {
    "bashrc": ".bashrc",
    "zshrc": ".zshrc",
    "oh-my-zsh": ".oh-my-zsh",

    "gitconfig": ".gitconfig",
    "irssi": ".irssi",
    "xmonad": ".xmonad",

    "nvim.vim": ".config/nvim/init.vim",
    "vimrc": ".vimrc",
    "vim": ".vim",

    "fonts.conf": ".fonts.conf",
    "inputrc": ".inputrc",
    "Xdefaults": ".Xdefaults",
    "xmodmap": ".xmodmap",
}

# --- END CONFIGURATION ---


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
    Links dotfiles from this repository to your home directory based on DOTFILE_MAP.
    """

    if dry_run:
        typer.secho(
            "--- RUNNING IN DRY-RUN MODE (NO CHANGES WILL BE MADE) ---",
            fg=typer.colors.YELLOW,
            bold=True,
        )

    typer.secho(f"Source Repo: {REPO_ROOT}", fg=typer.colors.CYAN)
    typer.secho(f"Target Home: {HOME_DIR}", fg=typer.colors.CYAN)

    linked_count = 0
    skipped_count = 0
    error_count = 0

    for source_name, dest_name in DOTFILE_MAP.items():
        source_path = REPO_ROOT / source_name
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
                os.symlink(source_path, dest_path)
                linked_count += 1
            except Exception as e:
                typer.secho(
                    f"  [ERROR] Failed to create symlink: {e}", fg=typer.colors.RED
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
