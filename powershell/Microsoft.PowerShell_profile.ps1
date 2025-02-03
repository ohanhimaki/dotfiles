Import-Module posh-git
# Import-Module ZLocation
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

function do-easyopp-start-api {
  Push-Location C:\coding\easyopp-app\easyopp-app\Aiddo.Aw
  dotnet watch run --project .\EasyOpp.Api\EasyOpp.Api.csproj --property:SolutionDir=$PWD
}
Set-Alias easyopp-start-api do-easyopp-start-api


function do-easyopp-start {
  Push-Location C:\coding\easyopp-app\easyopp-app\Aiddo.Aw
  dotnet watch run --project .\Aiddo.Aw.Web\Aiddo.Aw.Web.csproj --property:SolutionDir=$PWD
}
Set-Alias easyopp-start do-easyopp-start


function do-easyopp-start-mobile {
  Push-Location C:\coding\easyopp-app\easyopp-app\Aiddo.Aw
  dotnet watch run --project .\Aiddo.Aw.Mobile\Aiddo.Aw.Mobile.csproj --property:SolutionDir=$PWD
}
Set-Alias easyopp-start-mobile do-easyopp-start-mobile

function print-my-logs {
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

