function Show-Options {

    $items = @("Test","Test 2")
    for($i = 0; $i -lt $items.Length; $i++) {
        Write-Host "$($i+1): $($items[$i])"
    }

    $bIsValid = $false
    while(-not $bIsValid) {
        $choice = Read-Host "Select an option [1, 2, 3, 4]"

        if($choice -match '^\d+$' -and $choice -gt 0 -and $choice -le $items.Length) {
            $selection = $items[$choice - 1]
            Write-Host $selection
            $bIsValid = $true
        } else {
            Write-Host "Input unrecognised. Select an option [1, 2, 3, 4]"
        }
    }
}

Show-Options