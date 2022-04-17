<#
    Local PowerShell profile
    Location: $HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
#>

# Add script folder to PATH
if (!(Test-Path -Path "$HOME\scripts"))
{
    New-Item -ItemType Directory "$HOME\scripts"
}

if (!("$HOME\scripts" -in $Env:Path))
{
    $Env:Path += ";$HOME\scripts"
}

# Functions
Function Edit-Profile { code $PROFILE }
Function New-Guid { [guid]::NewGuid() }

Function Open-VSCode { code . }

Function dev { Set-Location C:\Dev }
Function .. { Set-Location ..\ }
Function ... { Set-Location ..\.. }

# Remote servers
Function sshmaster { ssh master@master.local }

# Go
Function gor { go run . }
Function gog {go get .}

# Kubernetes
Function kns {
    $ns = $args[0]

    if (-not $ns) {
        kubectl config set-context --current --namespace=default
    } else {
        kubectl config set-context --current --namespace=$ns
    }
}

Function kctx {
    $action = $args[0]
    $context = $args[1]

    Switch ($action)
    {
        "get" {
            kubectl config get-contexts
        }
        "set" {
            kubectl config use-context $context
        }
        default {
            Write-Host "Unrecognized action" -ForegroundColor Red
        }
    }
}

# Aliases
Remove-Alias h
Set-Alias -Name k -Value kubectl
Set-Alias -Name h -Value helm
Set-Alias -Name u -Value ubuntu
Set-Alias -Name c -Value Open-VSCode

# PSReadLine
Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History

# Starship
$ENV:STARSHIP_DISTRO = "$Env:username on 者 "
Invoke-Expression (&starship init powershell)
