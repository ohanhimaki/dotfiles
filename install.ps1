

# Winget id:t
$apps = @(
    "Git.Git",
    "wez.wezterm",
    "glzr-io.glazewm",
    "Microsoft.PowerToys",
    "Starship.Starship",
    "Neovim.Neovim",
    "JesseDuffield.lazygit",
    "BurntSushi.ripgrep.MSVC",
    "sharkdp.fd",
    "sharkdp.bat",
    "eza-community.eza",
    "junegunn.fzf",
    "ajeetdsouza.zoxide",
    "Microsoft.VisualStudioCode",
    "VideoLAN.VLC",
    "Spotify.Spotify",
    "Discord.Discord",
    "WinDirStat.WinDirStat",
    "GitHub.Copilot",
    "Python.Python.3.14",
    "Microsoft.PowerShell",
    "OpenJS.NodeJS",
    "ajeetdsouza.zoxide",
    "jqlang.jq",
 "Microsoft.Teams",
 "Logitech.OptionsPlus",
 "JohnMacFarlane.Pandoc",
 "Obsidian.Obsidian",
 "Google.GoogleDrive",
"tree-sitter.tree-sitter-cli",
"BrechtSanders.WinLibs.POSIX.UCRT"
)

Write-Host "--- ALOITETAAN SOVELLUSTEN ASENNUS (WINGET) ---" -ForegroundColor Yellow

foreach ($appId in $apps) {
    Write-Host "Tarkistetaan: $appId..." -NoNewline
    
    # Tarkistetaan onko sovellus jo asennettu (vaimennetaan virheet)
    $installedApps = winget list --id $appId --exact -e 2>$null
    
    # Tarkistetaan löytyykö appId itse tulostekstistä
    if ($installedApps -match [regex]::Escape($appId)) {
        Write-Host "Löytyy jo. Skitataan." -ForegroundColor Gray
    } else {
        Write-Host " Ei löydy. Asennetaan..." -ForegroundColor Cyan
        # --silent: ei turhia kyselyitä
        # --accept-package-agreements: hyväksyy lisenssit automaattisesti
        winget install --id $appId -e --silent --accept-source-agreements --accept-package-agreements
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  √ Asennus onnistui!" -ForegroundColor Green
        } else {
            Write-Host "  × Virhe asennuksessa (Koodi: $LASTEXITCODE)" -ForegroundColor Red
        }
    }
}

Write-Host "`nKaikki asennukset käsitelty!" -ForegroundColor Green
