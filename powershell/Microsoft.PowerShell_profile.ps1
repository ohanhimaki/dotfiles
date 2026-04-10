# Optimized PowerShell Profile with Lazy Loading
# This version loads modules only when needed for faster startup

# ============================================
# LOAD HELPER FUNCTIONS
# ============================================

# Load helper functions from dotfiles
. "$HOME\dotfiles\powershell\HelperFunctions.ps1"

# ============================================
# IMMEDIATE LOADS (Critical for prompt/basic functionality)
# ============================================

# Set UTF-8 encoding to fix Starship warnings with Finnish characters
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# Initialize Starship prompt (needed immediately for prompt display)
Invoke-Expression (&starship init powershell)
$ENV:STARSHIP_CONFIG = "$HOME\dotfiles\starship\starship.toml"

# Basic PSReadLine options (fast to set)
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows
Set-PSReadLineKeyHandler -Key Ctrl+LeftArrow -Function BackwardWord
Set-PSReadLineKeyHandler -Key Ctrl+RightArrow -Function NextWord
Set-PSReadLineKeyHandler -Key Ctrl+Backspace -Function BackwardKillWord
# Vaihda Windows-moodista Vi-moodiin

# Fix directory colors for better contrast
Set-PSReadLineOption -Colors @{
    Command = 'Yellow'
    Parameter = 'Gray'
    Operator = 'Magenta'
    Variable = 'Green'
    String = 'Cyan'
    Number = 'White'
    Type = 'DarkCyan'
    Comment = 'DarkGreen'
}

# Fix directory listing colors (Get-ChildItem / ls)
$PSStyle.FileInfo.Directory = "`e[1;36m"  # Bright Cyan for directories

# ============================================
# LAZY LOADING (Deferred until first use)
# ============================================

# Lazy load posh-git (only when you enter a git repo or use git commands)
$Global:PoshGitLoaded = $false
function Import-PoshGitOnce {
    if (-not $Global:PoshGitLoaded) {
        Import-Module posh-git -ErrorAction SilentlyContinue
        $Global:PoshGitLoaded = $true
    }
}

# Lazy load PSFzf (only when you use Ctrl+t or Ctrl+r)
$Global:PSFzfLoaded = $false
# function Import-PSFzfOnce {
#     if (-not $Global:PSFzfLoaded) {
#         Import-Module PSFzf -ErrorAction SilentlyContinue
#         Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
#         $Global:PSFzfLoaded = $true
#     }
# }
function Import-PSFzfOnce {
    if (-not $Global:PSFzfLoaded) {
        Import-Module PSFzf -ErrorAction SilentlyContinue
        # Asetetaan optiot vasta kun moduuli on varmasti ladattu
        Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
        $Global:PSFzfLoaded = $true
    }
}
# Auto-load posh-git when entering a directory with .git
$ExecutionContext.InvokeCommand.LocationChangedAction = {
    if (Test-Path .git) {
        Import-PoshGitOnce
    }
}

# # Trigger PSFzf load on first keybinding use
# Set-PSReadLineKeyHandler -Key Ctrl+t -ScriptBlock {
#     Import-PSFzfOnce
#     [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
# }
#
# Set-PSReadLineKeyHandler -Key Ctrl+r -ScriptBlock {
#     Import-PSFzfOnce
#     [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
# }
# PSFzf Lazy Load Keyhandlers
Set-PSReadLineKeyHandler -Key Ctrl+t -ScriptBlock {
    Import-PSFzfOnce
    # Kutsutaan PSFzf:n omaa funktiota suoraan latauksen jälkeen
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert(" ") # Pieni kikka purkamaan tila
    [Microsoft.PowerShell.PSConsoleReadLine]::Backspace(1)
    Invoke-FzfLocation # Tämä on PSFzf:n sisäinen komento Ctrl+t:lle
}

Set-PSReadLineKeyHandler -Key Ctrl+r -ScriptBlock {
    Import-PSFzfOnce
    Invoke-FzfHistory # Tämä on PSFzf:n sisäinen komento Ctrl+r:lle
}
# ============================================
# ALIASES
# ============================================

Set-Alias -Name vim -Value nvim

# ============================================
# CHOCOLATEY (Lazy load)
# ============================================

$Global:ChocolateyLoaded = $false
function Import-ChocolateyOnce {
    if (-not $Global:ChocolateyLoaded) {
        $ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
        if (Test-Path($ChocolateyProfile)) {
            Import-Module "$ChocolateyProfile"
        }
        $Global:ChocolateyLoaded = $true
    }
}

# Override common choco commands to trigger lazy load
function choco { Import-ChocolateyOnce; & choco.exe $args }
function cinst { Import-ChocolateyOnce; & choco.exe install $args }
function cup { Import-ChocolateyOnce; & choco.exe upgrade $args }

# ============================================
# CUSTOM ALIASES FILE
# ============================================

Push-Location (Split-Path -parent $profile)
"aliases" | Where-Object { Test-Path "$_.ps1" } | ForEach-Object -process { Invoke-Expression ". .\$_.ps1" }
Pop-Location

# ============================================
# CUSTOM FUNCTIONS
# ============================================

function printmylogs {
    $today = Get-Date -Format "yyyy-MM-dd"
    git log --all --branches --since="$today 00:00" --author="Olli Hanhimäki" --no-merges --pretty=format:"%s"
}

function nvimconfdir {
    cd $env:LOCALAPPDATA\nvim\
    nvim .
}
Set-Alias nconf nvimconfdir

function dotfiles-neovim {
    cd ~\dotfiles\
    nvim .
}
Set-Alias dconf dotfiles-neovim

# StowFile function is now loaded from HelperFunctions.ps1

Set-PSReadLineKeyHandler -Key Ctrl+Shift+s `
    -BriefDescription StartCurrentDirectory `
    -LongDescription "Start the current directory" `
    -ScriptBlock {
        [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
        if(Test-Path -Path ".\package.json") {
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert("npm start")
        }else {
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert("dotnet watch run")
        }
        [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
    }

function ned {
    $NED_FILE = "c:\projects\Notes\Drawings\$($args -join '-').excalidraw.png"

    if (Test-Path -Path $NED_FILE) {
        echo "File already exists: $NED_FILE"
    } else {
        echo "Created $NED_FILE"
        New-Item -Path $NED_FILE -ItemType File -Force
        code $NED_FILE
    }
}

function MakeSymlink {
    param (
        [string]$sourceFile,
        [string]$category
    )

    # Define dotfiles directory
    $dotfilesDir = "$HOME/dotfiles/$category"
    if (!(Test-Path $dotfilesDir)) {
        New-Item -ItemType Directory -Path $dotfilesDir -Force | Out-Null
    }

    # Extract filename
    $fileName = [System.IO.Path]::GetFileName($sourceFile)
    $destinationFile = "$dotfilesDir\$fileName"

    if (Test-Path $sourceFile) {
        # If source file exists, move it
        if (Test-Path $destinationFile) {
            $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
            $backupFile = "$dotfilesDir\$fileName-$timestamp"
            Move-Item -Path $sourceFile -Destination $backupFile -Force
            Write-Host "Existing file found. Renaming moved file to: $backupFile"
        } else {
            Move-Item -Path $sourceFile -Destination $destinationFile -Force
        }
    } elseif (!(Test-Path $destinationFile)) {
        Write-Host "Error: Neither the source file nor a backup exists in dotfiles." -ForegroundColor Red
        return
    }

    # Create symlink
    try {
        New-Item -ItemType SymbolicLink -Path $sourceFile -Target $destinationFile -Force | Out-Null
        Write-Host "Symlink created: $sourceFile -> $destinationFile"
    } catch {
        Write-Host "Failed to create symlink. Try running PowerShell as Administrator." -ForegroundColor Red
    }
}

# ============================================
# OPTIONAL: Uncomment to see startup time
# ============================================
# Write-Host "Profile loaded in $($MyInvocation.MyCommand.ScriptBlock.Ast.Extent.EndLineNumber) lines" -ForegroundColor Green

Invoke-Expression (& zoxide init powershell | Out-String)

$promptScript = (Get-Item function:prompt).ScriptBlock

function Prompt {
    # 1. Haetaan sijainti (käytetään $pwd joka on aina olemassa)
    $currentPath = $pwd.Path
    
    # 2. Päivitetään ikkunan otsikko
    $host.ui.RawUI.WindowTitle = $currentPath
    
    # 3. Lähetetään OSC 9;9 Windows Terminalille (käytetään heittomerkkejä polun ympärillä)
    Write-Host -NoNewline "$([char]27)]9;9;`"$currentPath`"$([char]7)"

    # 4. Kutsutaan Starship-skriptiä
    & $promptScript
}
