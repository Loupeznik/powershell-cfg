param (    
    [Parameter(Mandatory)]
    [ValidateSet("Essentials", "Optional", "All")]
    [string]$Type
)

function Install-Essentials {
    Get-Content essentials.source | ForEach-Object { winget install $_ }
}

function Install-Optional {
    Get-Content optional.source | ForEach-Object { winget install $_ }
}

switch ($Type) {
    "Essentials" { Install-Essentials }
    "Optional" { Install-Optional }
    "All" { Install-Essentials; Install-Optional }
    Default { Write-Host "Invalid type: $Type" }
}
