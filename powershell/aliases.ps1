# Easier Navigation: .., ..., ...., ....., and ~
${function:~} = { Set-Location ~ }
# PoSh won't allow ${function:..} because of an invalid path error, so...
${function:Set-ParentLocation} = { Set-Location .. }; Set-Alias ".." Set-ParentLocation
${function:...} = { Set-Location ..\.. }
${function:....} = { Set-Location ..\..\.. }
${function:.....} = { Set-Location ..\..\..\.. }
${function:......} = { Set-Location ..\..\..\..\.. }


${function:lg} = { lazygit }
${function:zz} = {
    $result = zoxide query -i
    if ($result) {
        Set-Location $result
    }
}

# Navigation Shortcuts
${function:drop} = { Set-Location ~\Documents\Dropbox }
${function:dt} = { Set-Location ~\Desktop }
${function:docs} = { Set-Location ~\Documents }
${function:dl} = { Set-Location ~\Downloads }
${function:dotf} = { Set-Location ~\dotfiles }

# Directory Listing: Use `ls.exe` if available
if (Get-Command ls.exe -ErrorAction SilentlyContinue | Test-Path) {
    rm alias:ls -ErrorAction SilentlyContinue
    # Set `ls` to call `ls.exe` and always use --color
    ${function:ls} = { ls.exe --color @args }
    # List all files in long format
    ${function:l} = { ls -lF @args }
    # List all files in long format, including hidden files
    ${function:la} = { ls -laF @args }
    # List only directories
    ${function:lsd} = { Get-ChildItem -Directory -Force @args }
} else {
    # List all files, including hidden files
    ${function:la} = { ls -Force @args }
    # List only directories
    ${function:lsd} = { Get-ChildItem -Directory -Force @args }
}


# eza aliases (if eza is installed)
if (Get-Command eza -ErrorAction SilentlyContinue | Test-Path) {
    rm alias:ls -ErrorAction SilentlyContinue
    ${function:ls} = { eza -a --color=always --icons @args }
    ${function:ll} = { eza -lF @args }
    ${function:la} = { eza -laF @args }
    ${function:lsd} = { eza -lF --directories-only @args }
}

 # Lisää PowerShell profiiliisi
 function which($name) {
   Get-Command $name -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source
 }

# nvim
${function:v} = { nvim @args }
${function:v2} = { $env:NVIM_APPNAME = "nvim-v2"; nvim @args; $env:NVIM_APPNAME = $null }


${function:oo} = { cd ~/life/; nvim .\00_Inbox\skratch.md  }
# G:\My Drive\Obsidian\Testi
#
function New-Note {
    # 1. Määrittele polut (Vaihda nämä omiisi)
    $basePath = "G:\My Drive\Obsidian\Testi"
    $inboxPath = "$basePath\0. Inbox"
    
    # 2. Luo tiedostonimi aikaleimalla (esim. note_20240318_0945.md)
    $timestamp = Get-Date -Format "yyyyMMdd_HHmm"
    $fileName = "note_$timestamp.md"
    $fullPath = Join-Path $inboxPath $fileName

    # 3. Navigoi kansioon
    Set-Location $inboxPath

    # 4. Luo tiedosto jos sitä ei ole, ja avaa Neovimillä
    if (-not (Test-Path $fullPath)) {
        New-Item -Path $fullPath -ItemType File | Out-Null
      $template = @"
---
date: $(Get-Date -Format "yyyy-MM-dd HH:mm")
tags: [inbox]
project: 
---
# Otsikko

"@
        $template | Out-File $fullPath -Encoding utf8
    }
    
    nvim $fullPath
}

# Luo lyhyt alias funktiolle, esim. 'nn' (New Note)
Set-Alias oww New-Note

# open worknotes folder 
${function:ow} = {
    Set-Location "G:\My Drive\Obsidian\Testi";
    nvim
}
