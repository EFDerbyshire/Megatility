# Gets a list of users from a given file and populates an array with its contents.
function Get-UserList {
    while($true) {
        $InputFilePath = Read-Host "Enter file path"
        Write-Output "Reading file..." 
        if (-not (Test-Path $InputFilePath -PathType Leaf)) {
            Write-Host "File not found or invalid path!" -ForegroundColor Red
        } else {
           $InputFile = Get-Content $InputFilePath
           Write-Host "Successfully grabbed list containing $($InputFile.Length) users."
           return $InputFile
        }
    }
}