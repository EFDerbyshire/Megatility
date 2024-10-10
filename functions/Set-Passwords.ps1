function Set-Passwords {
    param (
        [string]$ul, # user list
        [string]$pw  # password
    )
    # validate input
    if(Get-Item $ul -is [System.IO.FileInfo]) {
        break
        else { Write-Error "Specified path does not point to a file!"}
    }

    [string[]] $uList = Get-Content -Path $ul # convert user list to array
    $uCount = 0

    ForEach($u in $uList) { $uCount++ } # get number of users in list, might use this data for a progress readout later

    ForEach($u in $uList) {
        $uObject = Get-ADUser -Filter 'Name -eq $u'
        $uSAN = $uObject.SamAccountName
        if($uObject) {
            Set-ADAccountPassword -Identity $uSAN -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $pw -Force)
            Write-Line "Password for $u changed successfully."
        } 
        else { Write-Host "Failed to change password for $u!" -ForeGroundColor Red }
    }
}