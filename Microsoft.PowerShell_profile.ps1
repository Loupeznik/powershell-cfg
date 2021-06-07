<#
    Local PowerShell profile
    Location: $HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
#>

Set-PoshPrompt -Theme ~\.custom.omp.json
$Host.ui.RawUI.WindowTitle = "[PS] $PWD"

if (!(Test-Path -Path "$HOME\scripts"))
{
    mkdir "$HOME\scripts"
}

if (!("$HOME\scripts" -in $Env:Path))
{
    $Env:Path += ";$HOME\scripts"
}

# Functions
Function .. { cd ..\ }
Function ... { cd ..\.. }
Function www { cd ~\Documents\www }
Function Edit-Profile { atom $PROFILE }
Function Generate-Guid { [guid]::NewGuid() }

Function Update-Posh-Theme { atom ~\.custom.omp.json }

Function Start-Artisan-Server
{
    if (!(Test-Path ".\artisan" -PathType Leaf)) {
        Write-Host "Artisan not found in this directory" -ForegroundColor red
    }
    else
    {
        if ((Get-Process "wampmanager" -ea SilentlyContinue) -eq $Null)
        {
            Write-Host "Starting WAMP server" -ForegroundColor green
            Start-Process -FilePath "C:\wamp64\wampmanager.exe"
        }
        php artisan serve
    }
}

# Aliases
Set-Alias -Name serve -Value Start-Artisan-Server
