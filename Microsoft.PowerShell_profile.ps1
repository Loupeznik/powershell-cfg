<#
    Local PowerShell profile
    Location: $HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
    Source: https://github.com/Loupeznik/powershell-cfg/blob/master/Microsoft.PowerShell_profile.ps1
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

Function Open-Explorer {
    $dir = $args[0]

    if ($null -eq $dir)
    {
        explorer .
    }
    else 
    {
        explorer $dir
    }
}

Function dev { Set-Location C:\Dev }
Function cdssh { Set-Location ~\.ssh }
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

Function ka {
    $config = $args[0]

    kubectl apply -f $config
}

Function kd {
    $config = $args[0]

    kubectl delete -f $config
}

Function kg {
    $resource = $args[0]

    kubectl get $resource
}

Function kexec {
   $pod = $args[0]

   kubectl exec -it $pod sh
}

Function kgp { kubectl get pod }

Function kgns { kubectl get ns }

Function kgd { kubectl get deploy }

Function kgpv { kubectl get pv }

Function kgpvc { kubectl get pvc }

# Aliases
Remove-Alias h
Set-Alias -Name k -Value kubectl
Set-Alias -Name h -Value helm
Set-Alias -Name u -Value ubuntu
Set-Alias -Name c -Value Open-VSCode
Set-Alias -Name grep -Value Select-String
Set-Alias -Name e -Value Open-Explorer
Set-Alias -Name cl -Value clear

# PSReadLine
Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History

# Starship
$ENV:STARSHIP_DISTRO = "$Env:username on 者 "
Invoke-Expression (&starship init powershell)
