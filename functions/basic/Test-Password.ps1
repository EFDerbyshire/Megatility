# Checks if a given String fulfils password policy.
function Test-Password ([SecureString]$PasswordToTest) {
    $strPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($PasswordToTest))
    return ($strPassword -match '\d' -and $strPassword.Length -ge 8)
}