#Requires -Version 5.0
$ErrorActionPreference = 'Stop'

$sourcePath = Read-Host 'Enter the full path to the image file'

if (-not (Test-Path -LiteralPath $sourcePath -PathType Leaf)) {
    Write-Error "File not found: $sourcePath"
    exit 1
}

$themesDir = Join-Path $env:APPDATA 'Microsoft\Windows\Themes'
$targetPath = Join-Path $themesDir 'TranscodedWallpaper'

if (-not (Test-Path -LiteralPath $themesDir)) {
    New-Item -ItemType Directory -Path $themesDir -Force | Out-Null
}

Copy-Item -LiteralPath $sourcePath -Destination $targetPath -Force

Write-Host "Done. Replaced $targetPath with $sourcePath" -ForegroundColor Green

Write-Host ''
Write-Host 'Do you want to restart or just refresh the wallpaper?'
Write-Host '  1) Restart now'
Write-Host '  2) Refresh wallpaper now (no restart)'
Write-Host '  3) Do nothing / will restart later'
$choice = Read-Host 'Enter 1, 2, or 3'

switch ($choice) {
    '1' {
        Write-Host 'Restarting now...' -ForegroundColor Yellow
        Restart-Computer
    }
    '2' {
        Write-Host 'Refreshing wallpaper...' -ForegroundColor Yellow

        $signature = @'
[DllImport("user32.dll", CharSet = CharSet.Auto)]
public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
'@
        $type = Add-Type -MemberDefinition $signature -Name 'WallpaperHelper' -Namespace Win32Api -PassThru

        $SPI_SETDESKWALLPAPER = 0x0014
        $SPIF_UPDATEINIFILE = 0x01
        $SPIF_SENDCHANGE = 0x02

        $type::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $targetPath, $SPIF_UPDATEINIFILE -bor $SPIF_SENDCHANGE) | Out-Null

        Write-Host 'Wallpaper refreshed.' -ForegroundColor Green
    }
    default {
        Write-Host 'No action taken. Remember to restart or refresh for the change to appear.' -ForegroundColor Yellow
    }
}
