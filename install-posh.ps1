<#
    Install Oh my Posh for current user
#>

Install-Module oh-my-posh -Scope CurrentUser
Get-PoshThemes
Copy-Item .\conf\.custom.omp.json $HOME
