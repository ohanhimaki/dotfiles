

# Winget id:t
$apps = @(

# Terminal basics 
,"Git.Git"
,"Microsoft.PowerShell"
,"ajeetdsouza.zoxide"
,"sharkdp.fd"
,"sharkdp.bat"
,"eza-community.eza"
,"junegunn.fzf"
,"jqlang.jq"
,"BurntSushi.ripgrep.MSVC"
,"Starship.Starship"

# CLI tools
,"Neovim.Neovim"
,"JesseDuffield.lazygit"
,"GitHub.Copilot"
,"JohnMacFarlane.Pandoc"
,"sxyazi.yazi"

# Desktop
,"wez.wezterm"
,"glzr-io.glazewm"
,"Microsoft.PowerToys"
,"Microsoft.VisualStudioCode"
,"WinDirStat.WinDirStat"
,"Microsoft.Teams"
,"Logitech.OptionsPlus"
,"Obsidian.Obsidian"
,"Google.GoogleDrive"

# Desktop hupihupi
,"VideoLAN.VLC"
,"Spotify.Spotify"
,"Discord.Discord"

#sdk:t ja vim riippuvuuksia
,"tree-sitter.tree-sitter-cli"
,"BrechtSanders.WinLibs.POSIX.UCRT"
,"Python.Python.3.14"
,"OpenJS.NodeJS"

)

Write-Host "--- ALOITETAAN SOVELLUSTEN ASENNUS (WINGET) ---" -ForegroundColor Yellow

foreach ($appId in $apps) {
    Write-Host "Tarkistetaan: $appId..." -NoNewline
    
    # Tarkistetaan onko sovellus jo asennettu (vaimennetaan virheet)
    $installedApps = winget list --id $appId --exact -e 2>$null
    
    # Tarkistetaan löytyykö appId itse tulostekstistä
    if ($installedApps -match [regex]::Escape($appId)) {
        Write-Host "Löytyy jo. Skipataan." -ForegroundColor Gray
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
