<#
    Local PowerShell profile
    Location: $HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
    Source: https://github.com/Loupeznik/powershell-cfg/blob/master/Microsoft.PowerShell_profile.ps1
#>

if (!("$HOME\.krew\bin" -in $Env:Path) -and (Test-Path -Path "$HOME\.krew\bin")) {
    $Env:Path += ";$HOME\.krew\bin"
}

# Add script folder to PATH
if (!(Test-Path -Path "$HOME\bin")) {
    New-Item -ItemType Directory "$HOME\bin"
}

if (!("$HOME\bin" -in $Env:Path)) {
    $Env:Path += ";$HOME\bin"
}

$vimPath = "$HOME\bin\vim91"
$pythonScriptsPath = "$((Get-Command python -ErrorAction SilentlyContinue).Source | Split-Path -ErrorAction SilentlyContinue)\Scripts"

if ((Test-Path $vimPath) -and !($vimPath -in ($Env:Path -split ';'))) {
    $Env:Path += ";$vimPath"
}

if ((Test-Path $pythonScriptsPath) -and !($pythonScriptsPath -in ($Env:Path -split ';'))) {
    $Env:Path += ";$pythonScriptsPath"
}

if (Get-Command "flutter" -ErrorAction SilentlyContinue) {
    $pubPackagesPath = Join-Path -Path $env:LocalAppData -ChildPath "Pub\Cache\bin"

    $Env:Path += ";$pubPackagesPath"
}

# Functions
Function Edit-Profile { code $PROFILE }
Function New-Guid { [guid]::NewGuid() }
Function Open-VSCode { code . }

Function Open-Explorer {
    $dir = $args[0]

    if ($null -eq $dir) {
        explorer .
    }
    else {
        explorer $dir
    }
}

Function which {
    cmd /c where $args[0]
}

Function dev { Set-Location C:\Dev }
Function cdssh { Set-Location ~\.ssh }
Function .. { Set-Location ..\ }
Function ... { Set-Location ..\.. }
Function .... { Set-Location ..\..\.. }

# Go
Function gor { go run . }
Function gog { go get . }

# Git
Function gcp { git cherry-pick $args[0] }

# Node
Function prd { pnpm run dev }
Function prb { pnpm run build }
Function prs { pnpm run build }
Function nrd { npm run dev }
Function nrb { npm run build }
Function nrs { npm run build }

# Kubernetes
Function kns {
    $ns = $args[0]

    if (-not $ns) {
        kubectl config set-context --current --namespace=default
    }
    else {
        kubectl config set-context --current --namespace=$ns
    }
}

Function kctx {
    $action = $args[0]
    $context = $args[1]

    Switch ($action) {
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

Function kdf {
    $type = $args[0]

    Switch ($type) {
        { $_ -eq "pod" -or $_ -eq "pods" } {
            kubectl delete pods --field-selector status.phase=Failed
        }
        { $_ -eq "job" -or $_ -eq "jobs" } {
            kubectl delete jobs --field-selector status.successful=0
        }
        default {
            Write-Error "Type '$type' was not recognized. Supported types: pod, pods, job, jobs"
        }
    }
}

Function kgp { kubectl get pod }

Function kgns { kubectl get ns }

Function kgd { kubectl get deploy }

Function kgpv { kubectl get pv }

Function kgpvc { kubectl get pvc }

Function kgsv {
    $resource = $args[0]

    if ($null -eq $resource) {
        Write-Error "No resource specified. Usage: kgsv <service-name>"
        return
    }

    kubectl get secret $resource -o json | ConvertFrom-Json | ForEach-Object { $_.data.PSObject.Properties } | ForEach-Object { "$($_.Name): $([System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($_.Value)))" }
}

# WSL
Function almalinux { wsl -d AlmaLinux9 }

# Common
Function Stop-Paint { Get-Process -Name "mspaint" | Stop-Process }

Function Get-YT-MP3 {
    if ($null -eq (Get-Command "yt-dlp" -ErrorAction SilentlyContinue)) {
        Write-Host "yt-dlp is not installed" -ForegroundColor Red
        return
    }

    $url = $args[0]

    yt-dlp $url -x --audio-format mp3
}

Function Get-YT-MP4 {
    if ($null -eq (Get-Command "yt-dlp" -ErrorAction SilentlyContinue)) {
        Write-Host "yt-dlp is not installed" -ForegroundColor Red
        return
    }

    $url = $args[0]

    yt-dlp $url -f mp4
}

Function gpush {
    $remote = $args[0]
    $branch = $args[1]

    if ($null -eq $remote) {
        $remote = 'origin'
    }

    if (($remote -eq 'current' -or $remote -eq 'origin' ) -and ($null -eq $branch)) {
        git push origin $(git branch --show-current)
        return
    }

    git push $remote $branch
}

Function gpull {
    $remote = $args[0]
    $branch = $args[1]

    if ($null -eq $remote) {
        $remote = 'origin'
    }

    if (($remote -eq 'current' -or $remote -eq 'origin' ) -and ($null -eq $branch)) {
        git pull origin $(git branch --show-current)
        return
    }

    git pull $remote $branch
}

Function gs {
    git status
}

Function Convert-Base64 {
    process {
        $action = $args[0]
        $inputText = $args[1]

        if ($null -eq $inputText) {
            $inputText = $_
        }
  
        $encodeActions = @("-e", "--encode")
        $decodeActions = @("-d", "--decode")
  
        if ($encodeActions -contains $action) {
            [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($inputText))
        }
        elseif ($decodeActions -contains $action) {
            [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($inputText))
        }
        else {
            Write-Host "Unrecognized action" -ForegroundColor Red
        }
    }
}

Function x {
    exit
}

Function whatsmyip {
    (Invoke-WebRequest 'https://ipinfo.io/ip').Content
}

# Aliases
Remove-Alias h
Set-Alias -Name k -Value kubectl
Set-Alias -Name h -Value helm
Set-Alias -Name u -Value ubuntu
Set-Alias -Name c -Value Open-VSCode
Set-Alias -Name grep -Value Select-String
Set-Alias -Name e -Value Open-Explorer
Set-Alias -Name cl -Value clear
Set-Alias -Name tf -Value terraform
Set-Alias -Name unzip -Value Expand-Archive
Set-Alias -Name zip -Value Compress-Archive
Set-Alias -Name base64 -Value Convert-Base64
Set-Alias -Name sscm -Value SQLServerManager15.msc
Set-Alias -Name vi -Value vim

# PSReadLine
Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows

# Init Starship
if (Get-Command "starship" -ErrorAction SilentlyContinue) {
    $ENV:STARSHIP_DISTRO = "$Env:username on 者 "
    Invoke-Expression (&starship init powershell)
}

# Init fnm
if (Get-Command "fnm" -ErrorAction SilentlyContinue) {
    fnm env --use-on-cd | Out-String | Invoke-Expression
}
