<#
    Local PowerShell profile
    Location: $HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
#>

if (!(Test-Path -Path "$HOME\scripts"))
{
    mkdir "$HOME\scripts"
}

if (!("$HOME\scripts" -in $Env:Path))
{
    $Env:Path += ";$HOME\scripts"
}

# Functions
Function .. { Set-Location ..\ }

Function ... { Set-Location ..\.. }

Function www { Set-Location ~\Dev }

Function Edit-Profile { code $PROFILE }

Function New-Guid { [guid]::NewGuid() }

$ENV:STARSHIP_DISTRO = "者 dominicc "
Invoke-Expression (&starship init powershell)
