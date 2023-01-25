function processDownload($application, $url, $extension) {
    Invoke-WebRequest $url -UseBasicParsing -OutFile "$application.$extension"

    if ($extension -eq "zip") 
    {
        Expand-Archive "$application.$extension" .
    }
    elseif ($extension -eq "tar.gz")
    {
        tar -xzf "$application.$extension" -C .
    }
    elseif ($extension -eq "tar")
    {
        tar -xf "$application.$extension" -C .
    }
    else 
    {
        Write-Host "Extension $extension not supported"
        exit 1
    }

    Remove-Item "$application.$extension"
}

function printResult($application) {
    if (-not (Test-Path -Path "$application.exe" -PathType Leaf)) 
    {
        Write-Host "Failed to download $application" -ForegroundColor Red
    }
    else 
    {
        Write-Host "Successfully downloaded $application" -ForegroundColor Green
    }
}

function cleanup() {
    Get-ChildItem * -Exclude @("*.exe", "*.ps1") | Remove-Item -Recurse -Force
}

# Prepare environment
$scriptsDir = "$HOME\bin"

if (!(Test-Path -Path $scriptsDir))
{
    New-Item -ItemType Directory $scriptsDir
}

if (!($scriptsDir -in $Env:Path))
{
    $Env:Path += ";$scriptsDir"
}

Set-Location $scriptsDir

# Get Terraform
$application = "terraform"
$version = ((curl -s "https://api.github.com/repos/hashicorp/terraform/releases/latest" | ConvertFrom-Json).tag_name) -Replace "v",""
$url = "https://releases.hashicorp.com/terraform/{0}/terraform_{0}_windows_amd64.zip" -f $version
processDownload -application $application -url $url -extension zip
printResult -application $application
cleanup

# Get Helm
$application = "helm"
$version = (curl -s "https://api.github.com/repos/helm/helm/releases/latest" | ConvertFrom-Json).tag_name
$url = "https://get.helm.sh/helm-{0}-windows-amd64.zip" -f $version
processDownload -application $application -url $url -extension "zip"

$tempDir = ".\windows-amd64"
Move-Item "$tempDir\helm.exe" .
Remove-Item "$tempDir" -Recurse -Force

printResult -application $application
cleanup

# Get Helmfile
$application = "helmfile"
$version = (curl -s "https://api.github.com/repos/helmfile/helmfile/releases/latest" | ConvertFrom-Json).tag_name
$url = "https://github.com/helmfile/helmfile/releases/download/{0}/helmfile_{1}_windows_amd64.tar.gz" -f  @($version, ($version -replace "v", ""))
processDownload -application $application -url $url -extension "tar.gz"
printResult -application $application
cleanup

# Get croc
$application = "croc"
$version = (curl -s "https://api.github.com/repos/schollz/croc/releases/latest" | ConvertFrom-Json).tag_name
$url = "https://github.com/schollz/croc/releases/download/{0}/croc_{1}_Windows-64bit.zip " -f  @($version, ($version -replace "v", ""))
processDownload -application $application -url $url -extension "zip"
printResult -application $application
cleanup
