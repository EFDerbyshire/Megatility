# Utility to update many users to the same password.
function Start-SetPasswords {
    Write-Host "Bulk Password Set Utility v1.1"
    $InputPassword = Get-Password
    $InputFile = Get-UserList
    Confirm-PasswordSet $InputPassword $InputFile
}
function Get-Password {
    while ($true) {
        $InputPassword = Read-Host "Enter a password" -AsSecureString
        if (Test-Password $InputPassword) {
            return $InputPassword
        } else {
            Write-Host "Password check failed! Must contain a digit and be at least 8 characters." -ForegroundColor Red
        }
    }
}
function Confirm-PasswordSet($InputPassword, $InputFile) {
    $Confirmation = Read-Host "OK to run password set? This cannot be undone! (y/N)"
    switch ($Confirmation) {
        'y' { 
            Set-Passwords -Password $InputPassword -UserList $InputFile 
        }
        default { 
            Write-Host "Terminating." -ForegroundColor Red 
            exit
        }
    }
}
function Set-Passwords {
    param (
        [SecureString]$Password,
        [string[]]$UserList
    )
    $ErrorCount = 0
    ForEach ($User in $UserList) {
        $timestamp = Get-Date -Format "hh:MM:ss"
        $ActiveDirectoryUser = Get-ADUser -Filter "SamAccountName -eq '$User'"
        try {
            if (-not $ActiveDirectoryUser) {
                throw "User $User not found!"
            }
            Set-ADAccountPassword -Identity $ActiveDirectoryUser.SamAccountName -Reset -NewPassword $Password -Force
            Write-Output "Successfully changed password for $User"
        } 
        catch {
            Write-Host "$timestamp [ERROR] $($_)" -ForegroundColor Red
            $ErrorCount++
        }
    }
    Write-Host "Passwords changed for $($UserList.Length - $ErrorCount) / $($UserList.Length) users."
}
Start-SetPasswords