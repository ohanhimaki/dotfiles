# NOTE: To create symlinks WITHOUT Administrator rights, enable Developer Mode:
# Settings > Privacy & security > For developers > Developer Mode: On

# Muuttujat (varmista että nämä vastaavat ympäristöäsi)
$dotfilesRoot = "$HOME\dotfiles"

# Simuloidaan AppRepositoryn Links-dataa (tämän voisi lukea jsonista tai suoraan C#:sta)
function Create-SymlinkSafe {
    param (
        [string]$Source, # Polku dotfiles-kansiossa
        [string]$Target  # Polku minne linkki luodaan
    )

    # Korvataan paikkamerkit oikeilla poluilla
    $Target = $Target -replace "{HOME}", $HOME # ~
    $Target = $Target -replace "{LOCALAPPDATA}", $env:LOCALAPPDATA # ~/AppData/Local
    $Target = $Target -replace "{APPDATA}", $env:APPDATA # ~/AppData/Roaming

    # Varmistetaan, että lähdetiedosto on olemassa
    $fullSource = Join-Path $dotfilesRoot $Source
    if (-not (Test-Path $fullSource)) {
        Write-Warning "Source not found: $fullSource"
        return
    }

    # Jos kohde on jo olemassa
    if (Test-Path $Target) {
        $item = Get-Item $Target
        # Jos se EI ole symlinkki, otetaan backup
        if ($item.Attributes -notlike "*ReparsePoint*") {
            $backup = $Target + "_" + (Get-Date -Format "yyyyMMddHHmmss") + ".bak"
            Write-Host "  ➔ Renaming existing real item to: $(Split-Path $backup -Leaf)" -ForegroundColor Cyan
            Rename-Item -Path $Target -NewName (Split-Path $backup -Leaf)
        } else {
            # Jos se ON jo symlinkki, poistetaan vanha alta
            Write-Host "  ➔ Removing old symlink: $Target" -ForegroundColor Gray
            Remove-Item $Target
        }
    }

    # Varmistetaan että kohdekansio on olemassa
    $targetDir = Split-Path $Target
    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    }

    # Luodaan uusi symlinkki
    # New-Item osaa käyttää unprivileged-lippua automaattisesti, jos Dev Mode on päällä
    Write-Host "  √ Linking: $Target -> $Source" -ForegroundColor Green
    New-Item -ItemType SymbolicLink -Path $Target -Value $fullSource -Force | Out-Null
}

# Junction reaalikansioon (ei dotfiles-tiedosto), esim. ~/projects -> C:\projects
function Create-JunctionSafe {
    param (
        [string]$Target,   # oikea kansio, minne osoitetaan
        [string]$LinkPath  # linkin sijainti, esim. {HOME}/projects
    )

    $LinkPath = $LinkPath -replace "{HOME}", $HOME
    $LinkPath = $LinkPath -replace "{LOCALAPPDATA}", $env:LOCALAPPDATA
    $LinkPath = $LinkPath -replace "{APPDATA}", $env:APPDATA

    if (-not (Test-Path $Target)) {
        New-Item -ItemType Directory -Path $Target -Force | Out-Null
    }

    if (Test-Path $LinkPath) {
        $item = Get-Item $LinkPath -Force
        if ($item.Attributes -like "*ReparsePoint*") {
            if ($item.Target -eq $Target) {
                Write-Host "  = Junction jo kohdallaan: $LinkPath -> $Target" -ForegroundColor Gray
                return
            }
            Write-Host "  ➔ Poistetaan vanha junction: $LinkPath" -ForegroundColor Gray
            Remove-Item $LinkPath -Force
        } else {
            Write-Warning "  $LinkPath on olemassa oleva oikea kansio/tiedosto - ei ylikirjoiteta. Siirrä/poista manuaalisesti."
            return
        }
    }

    New-Item -ItemType Junction -Path $LinkPath -Target $Target -Force | Out-Null
    Write-Host "  √ Junction: $LinkPath -> $Target" -ForegroundColor Green
}

# TÄSSÄ ON LISTA REPOSITORIOSTASI POIMITUISTA LINKEISTÄ
Write-Host "--- MUODOSTETAAN SYMLINKIT ---" -ForegroundColor Yellow


Create-SymlinkSafe "git/.gitconfig" "{HOME}/.gitconfig"

# PowerShell Profile
Create-SymlinkSafe "powershell/Microsoft.PowerShell_profile.ps1" "{HOME}/Documents/PowerShell/Microsoft.PowerShell_profile.ps1"
Create-SymlinkSafe "powershell/aliases.ps1" "{HOME}/Documents/PowerShell/aliases.ps1"

# WezTerm
Create-SymlinkSafe "wezterm" "{HOME}/.config/wezterm"

# GlazeWM
Create-SymlinkSafe "glazewm/config.yaml" "{HOME}/.glzr/glazewm/config.yaml"
Create-SymlinkSafe "glazewm/zebar/settings.json" "{HOME}/.glzr/zebar/settings.json"
Create-SymlinkSafe "glazewm/zebar/glzr-io.starter@0.0.0" "{HOME}/.glzr/zebar/glzr-io.starter@0.0.0"

# PowerToys
Create-SymlinkSafe "powertoys/settings.json" "{LOCALAPPDATA}/Microsoft/PowerToys/settings.json"
Create-SymlinkSafe "powertoys/fancyzones/settings.json" "{LOCALAPPDATA}/Microsoft/PowerToys/fancyzones/settings.json"
Create-SymlinkSafe "powertoys/fancyzones/zones-settings.json" "{LOCALAPPDATA}/Microsoft/PowerToys/fancyzones/zones-settings.json"

# Windows Terminal
Create-SymlinkSafe "windowsterminal/settings.json" "{LOCALAPPDATA}/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"

# Jetbrains Rider
Create-SymlinkSafe "idea/.ideavimrc" "{HOME}/.ideavimrc"
Create-SymlinkSafe "idea/.intellimacs" "{HOME}/.intellimacs"

# Neovim
Create-SymlinkSafe "nvim" "{LOCALAPPDATA}/nvim"
Create-SymlinkSafe "nvim-v2" "{LOCALAPPDATA}/nvim-v2"

# VS Code
Create-SymlinkSafe "vscode/settings.json" "{APPDATA}/Code/User/settings.json"
Create-SymlinkSafe "vscode/keybindings.json" "{APPDATA}/Code/User/keybindings.json"

Create-SymlinkSafe "lazygit\config.yml" "{LOCALAPPDATA}/lazygit\config.yml"

Create-SymlinkSafe "ai-hommat\.agents" "{HOME}/.agents"
Create-SymlinkSafe "ai-hommat\shared-instructions.md" "{HOME}/.copilot/copilot-instructions.md"

Create-SymlinkSafe "yazi" "{APPDATA}/yazi"

# Projects-kansio: yazin "gp" (cd ~/projects) toimii samoin ku Linuxilla
Create-JunctionSafe "C:\projects" "{HOME}/projects"

Write-Host "`nValmis!" -ForegroundColor Green
