function Start-GetUsernames {
    # Begins program
    $InputFile = Get-UserList
    $ListType = Get-ListType
    Write-UserList -InputFile $InputFile -ListType $ListType
}

function Get-ListType {
    $strInput = Read-Host "Which list type do you want?`n
        [1] SamAccountName - ID used for AD operations.`n
        [2] Legal Name - Maps login names to legal name.`n
        [3] SAN & Legal Name - Maps login names and legal names.`n
        Enter a value [1, 2, 3] (Default: [1])"
    switch ($strInput) {
        "2" { return $ListType = 2 }
        "3" { return $ListType = 3 }
        default { return $ListType = 1}
    }
}

function Resolve-Names {
    param (
        [string[]]$InputFile,
        [int]$ListType
    )
    $timestamp = Get-Date -Format "dd-MM hh-MM-ss"
    $LogPath = Join-Path $PSScriptRoot -ChildPath "../logs/userlist - $timestamp.txt"
    ForEach ($User in $InputFile) {
        while($true) {
            try {
                $ADUser = Get-ADUser -Filter 'Name -eq $User'
                if (-not $ADUser) {
                    throw "User $User not found!" | Out-File -Path $LogPath -Append
                }
                if ($ListType = 1) {
                    "$($ADUser.SamAccountName)" | Out-File -Path $LogPath -Append
                    return
                }
                if ($ListType = 2) {
                    "$($ADUser.Name)" | Out-File -Path $LogPath -Append
                    return
                }
                if ($ListType = 3) {
                    "$($ADUser.SamAccountName - $ADUser.Name)" | Out-File -Path $LogPath -Append
                    return
                }
            }
            catch {
                Write-Host "Error: $($_)" -ForegroundColor Red
            }
        }
    }
}