$rubricloc = "C:\Users\micha\OneDrive\Documents\GradeInput"
$GradeLab = {
    $rubric = New-Object -TypeName System.xml.xmldocument
    $rubric.LoadXml((Get-Content -Path (Join-Path $rubricloc $cbSelectLab.SelectedItem.File)))
    #Use OwnCloud automation to look for file and retrieve it
    $studentfile = Import-Csv -Path (Join-Path $rubricloc $rubric.rubric.FileName) #assign to student file
    $rubricfile = Import-Csv -Path (Join-Path $rubricloc $rubric.rubric.FileName)
    $studentprops = $studentfile | 
                        Get-Member | 
                            Where-Object MemberType -eq "NoteProperty" | 
                                Select-Object -ExpandProperty "Name"
    $studenthosts = $studentfile |
                        Sort-Object -Unique PSComputerName |
                            Select-Object -ExpandProperty "PSComputername"

    $missingprops = @()
    $missinghosts = @()
    $extrahosts   = @()
    $splat = @{ReferenceObject  = $rubric.rubric.RequiredProperties.Property
               DifferenceObject = $studentprops}
    $missingprops = Compare-Object @splat | 
                        Where-Object {$_.SideIndicator -eq "<="} | 
                            Select-Object -ExpandProperty InputObject
    $splat.ReferenceObject  = $rubric.rubric.RequiredHosts.Host
    $splat.DifferenceObject = $studenthosts
    $missinghosts = Compare-Object @splat |
                        Where-Object {$_.SideIndicator -eq "<="} |
                            Select-Object -ExpandProperty InputObject
    $extrahosts = Compare-Object @splat |
                        Where-Object {$_.SideIndicator -eq "=>"} |
                            Select-Object -ExpandProperty InputObject
    
    $results  = ("Missing Properties: {0} `n" -f ($missingprops -join ", "))
    $results += ("Missing Hosts: {0} `n" -f ($missinghosts -join ", "))
    $results += ("Extra Hosts: {0} `n" -f ($extrahosts -join ", "))
    if (!($missinghosts -and $missingprops -and $extrahosts)) {
        $splat.ReferenceObject = $rubricfile
        $splat.DifferenceObject = $studentfile
        $missingdata = Compare-Object @splat -PassThru |
                        Where-Object {$_.SideIndicator -eq "<=" }
        if (! $missingdata) {
            $missingdata = "None"
        }
    }
    else {$missingdata = "Not graded due to problems with hosts or properties. Correct these issues and grade again."}
    $results += "Missing Data: {0}" -f $missingdata
    $rtbResults.Text = $results    
}
Add-Type -AssemblyName System.Windows.Forms
. (Join-Path $PSScriptRoot 'Main.designer.ps1')
Import-Csv -Path (Join-Path $PSScriptRoot 'Labs.csv') |
    ForEach-Object {$cbSelectLab.Items.Add($_) | Out-Null}


$frmMain.ShowDialog()

