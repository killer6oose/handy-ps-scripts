# ReplaceBackground.ps1

A PowerShell script that replaces Windows' cached wallpaper file (`TranscodedWallpaper`) with an image you choose. No admin rights required.

## What it does

1. Prompts for the path to an image file.
2. Copies it over `%AppData%\Microsoft\Windows\Themes\TranscodedWallpaper`.
3. Asks whether you want to restart, refresh the wallpaper immediately, or do nothing.

## Usage

Run this from a normal (non-elevated) PowerShell console:

```powershell
irm https://raw.githubusercontent.com/killer6oose/handy-ps-scripts/main/scripts/ReplaceBackground.ps1 | iex
```
or even shorter!

```powershell
irm https://bit.ly/4gFB1iU | iex
```

You'll be prompted for an image path, then for how you'd like the change to take effect.

## Requirements

- Windows PowerShell 5.0+
- No admin/elevation needed
