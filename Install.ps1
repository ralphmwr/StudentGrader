$ErrorActionPreference = "Stop"
Expand-Archive -Path .\StudentFiles.zip -DestinationPath $env:HOMEPATH -Force
Remove-Item -Path ".\StudentFiles.zip"
$splat = @{
    FilePath = "$env:HOMEPATH\StudentFiles\rubricpfx.pfx"
    Password = Read-Host -Prompt "Enter Password for Install:" -AsSecureString
    CertStoreLocation = "Cert:\CurrentUser\My"
}
Import-PfxCertificate @splat
Remove-Item -Path "$env:HOMEPATH\StudentFiles\rubricpfx.pfx"

$WScriptShell = New-Object -ComObject WScript.Shell
#Update paths
$Shortcut = $WScriptShell.CreateShortcut("C:\Users\micha\OneDrive\Desktop\Grade-Labs.lnk")
$Shortcut.TargetPath = "C:\Windows\System32\WindowsPowerShell\v1.0\PowerShell.exe"
$Shortcut.Arguments = "-NoProfile -WindowStyle Hidden -File C:\Users\micha\OneDrive\Documents\GitHub\StudentGrader\StudentGrader\Main.ps1"
$Shortcut.Save()
$ErrorActionPreference = "Continue"



