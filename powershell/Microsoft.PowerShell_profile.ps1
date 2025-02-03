Import-Module posh-git
#Import-Module ZLocation
Import-Module PSFzf

Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

Set-Alias -Name vim -value nvim

oh-my-posh --init --shell pwsh --config ~/dotfiles/powershell/ohmyposh-theme.json | Invoke-Expression


# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}


Push-Location (Split-Path -parent $profile)

"aliases" | Where-Object { Test-Path "$_.ps1" } | ForEach-Object -process { Invoke-Expression ". .\$_.ps1" }
Pop-Location

function mylogstoday {
  $today = Get-Date -Format "yyyy-MM-dd"
  git log --all --branches --since="$today 00:00" --author="Olli Hanhimäki" --no-merges --pretty=format:"%s"
}

Set-Alias printmylogs print-my-logs



function StowFile([String]$link, [String]$target) {
	$file = Get-Item $link -ErrorAction SilentlyContinue

	if ($file) {
		if ($file.LinkType -ne "SymbolicLink") {
			Write-Error "$($file.FullName) already exists and is not a symbolic link"
			return
		}
		elseif ($file.Target -ne $target) {
			Write-Error "$($file.FullName) already exists and points to '$($file.Target)', it should point to '$target'"
			return
		}
		else {
			Write-Verbose "$($file.FullName) already linked"
			return
		}
	}
 else {
		$folder = Split-Path $link
		if (-not (Test-Path $folder)) {
			Write-Verbose "Creating folder $folder"
			New-Item -Type Directory -Path $folder
		}
	}
	
	Write-Verbose "Creating link $link to $target"
	(New-Item -Path $link -ItemType SymbolicLink -Value $target -ErrorAction Continue).Target
}

Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows

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

