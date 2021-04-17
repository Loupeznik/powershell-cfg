<#
    Local PowerShell profile
    Location: $HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
#>

Set-PoshPrompt -Theme ~\.custom.omp.json

if (!(Test-Path -Path "$HOME\scripts"))
{
    mkdir "$HOME\scripts"
}

if (!("$HOME\scripts" -in $Env:Path))
{
    $Env:Path += ";$HOME\scripts"
}
