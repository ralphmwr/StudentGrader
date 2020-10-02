Add-Type -AssemblyName System.Windows.Forms
. (Join-Path $PSScriptRoot 'Main.designer.ps1')
$rubricloc = "."
Import-Csv -Path (Join-Path $PSScriptRoot 'Labs.csv') |
    ForEach-Object {$cbSelectLab.Items.Add($_) | Out-Null}

$GradeLab = {
    $rubric = Get-Content -Path (Join-Path $rubricloc $cbSelectLab.SelectedValue )
    Write-Host $rubric
}
$frmMain.ShowDialog()

