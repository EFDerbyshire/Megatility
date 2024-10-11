function Start-Utility {
    Write-Host "Bulk Password Set Utility v1.3"
    Get-Params
}

function Get-Params {

    $CheckPassword = $true
    while ($true) {
        if ($CheckPassword) {
            $InputPassword = Read-Host "Enter a password" -AsSecureString
            if (Test-Password $InputPassword) {
                # Write-Host "Password check successful!"
                $CheckPassword = $false
            } else {
                Write-Host "Password check failed!" -ForegroundColor Red
            }
        } else {
            $InputFilePath = Read-Host "Enter a file path"
            if (Test-Path $InputFilePath -PathType Leaf) {
                # Write-Host "Filepath check successful!"
                [string[]]$InputFile = Get-Content $InputFilePath
                Write-Output "Successfully added list containing $($InputFile.Length) users."
                break
            } else {
                Write-Host "Filepath check failed!" -ForegroundColor Red
            }
        }
    }
    $YayOrNay = Read-Host "OK to run password set? (y/N)"
    switch ($YayOrNay) {
        "y" { Set-Passwords $InputPassword $InputFile }
        default { Write-Host "Terminating." -ForegroundColor Red | exit }
    }
}

function Test-Password {
    param (
        [SecureString]$securePassword
    )
    $strPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword))
    if ($strPassword -match '\d' -and $strPassword.Length -ge 8 ) { 
        return $true 
    }
    return $false
}

function Set-Passwords {
    params (
        [SecureString]$Password,
        [string[]]$UserList
    )

    ForEach($User in $UserList) {
        $ActiveDirectoryUser = Get-ADUser -Filter 'Name -eq $User'
        if($ActiveDirectoryUser) {
            Set-ADAccountPassword -Identity $ActiveDirectoryUser.SamAccountName -Reset -NewPassword $Password -Force
            Write-Output "Successfuly changed password for $User"
        } else {
            Write-Host "User $User not found!" -ForegroundColor Red
        }
    }
}
Start-Utility