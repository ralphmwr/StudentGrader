# Loading Rubric into memory
$testloc = "C:\Users\micha\OneDrive\Documents\GitHub\StudentGrader\StudentGrader"
$rubricxmlfile = "C:\Users\micha\OneDrive\Documents\GitHub\StudentGrader\StudentGrader\Rubric.xml"
$rubric = New-Object -TypeName System.xml.xmldocument
$rubric.LoadXml((Get-Content $rubricxmlfile))

# The GradeLab script block will run when the user clicks the Grade button
$GradeLab = {
    # Make sure something is selected in the drop down
    if ($cbSelectLab.SelectedItem){
        #assign current lab's rubric to a variable
        $curlabrubric = $rubric.rubric.Lab | Where-Object {$_.labname -eq $cbSelectLab.SelectedItem}
        
        #Use OwnCloud automation to look for file and retrieve it
        if (!(Test-Path -Path "$env:TEMP\occred.csv")) {
            $OCCreds = Get-Credential -Message "Enter your Owncloud Credentials:"
            $OCCreds |
                Select-Object UserName, @{n="Password";e={$_.Password | ConvertFrom-SecureString}} |
                    Export-Csv -Path "$env:TEMP\occred.csv"
        }
        else {
            $import = Import-Csv -Path "$env:TEMP\occred.csv"
            $OCCreds = New-Object -TypeName pscredential -ArgumentList $import.UserName, ($import.Password | ConvertTo-SecureString)
        }

        $studentfile = Import-Csv -Path ("{0}\{1}" -f $testloc, $curlabrubric.OwnCloudName)
        $studentprops = $studentfile |
                            Get-Member | 
                                Where-Object MemberType -eq "NoteProperty" | 
                                    Select-Object -ExpandProperty "Name"
        $studenthosts = $studentfile |
                            Sort-Object -Unique PSComputerName |
                                Select-Object -ExpandProperty "PSComputername"

        $splat = @{ReferenceObject  = $curlabrubric.RequiredProperties.Property
                DifferenceObject = $studentprops}
        $missingprops = @(Compare-Object @splat | 
                            Where-Object {$_.SideIndicator -eq "<="} | 
                                Select-Object -ExpandProperty InputObject)
        $splat.ReferenceObject  = $curlabrubric.RequiredHosts.Host
        $splat.DifferenceObject = $studenthosts
        $hostcheck = @(Compare-Object @splat |
                        Where-Object {$_.SideIndicator -eq "<="} |
                            Select-Object -ExpandProperty InputObject)
        $splat.ReferenceObject = $curlabrubric.RequiredHosts.IP
        $IPCheck = @(Compare-Object @splat |
                    Where-Object {$_.SideIndicator -eq "<="} |
                        Select-Object -ExpandProperty InputObject)
        if ($hostcheck.count -le $IPCheck.count) { 
            $missinghosts = $hostcheck
            $curlabrubric.RequiredData.ChildNodes |
                ForEach-Object {
                    $newnode = $rubric.CreateElement("PSComputerName")
                    $newnode.InnerXml = $_.Hostname
                    $_.AppendChild($newnode)
                    $_.RemoveChild(($_.SelectSingleNode("IP")))
                    $_.RemoveChild(($_.SelectSingleNode("Hostname")))
                } # ForEach-Object
            $splat.ReferenceObject = $curlabrubric.RequiredHosts.Host 
        } #if
        else { 
            $missinghosts = $IPCheck
            $curlabrubric.RequiredData.ChildNodes |
                ForEach-Object{
                    $newnode = $rubric.CreateElement("PSComputerName")
                    $newnode.InnerXml = $_.IP
                    $_.AppendChild($newnode)
                    $_.RemoveChild(($_.SelectSingleNode("IP")))
                    $_.RemoveChild(($_.SelectSingleNode("Hostname")))                    
                } # foreach-Object
        } #else
        $extrahosts = Compare-Object @splat |
                            Where-Object {$_.SideIndicator -eq "=>"} |
                                Select-Object -ExpandProperty InputObject
        if (!$missinghosts -and !$missingprops -and !$extrahosts) {
            #data search
            $missingdata = @()
            if ($studentfile.count -lt $curlabrubric.minimumrowcount) {$missingdata += "Minimum data threshold not met."}
            $props = $curlabrubric.RequiredData.ChildNodes | 
                        Get-Member | 
                            Where-Object MemberType -eq Property | 
                                Select-Object -expandproperty name -Unique
            $splat.ReferenceObject = $curlabrubric.RequiredData.ChildNodes | Select-Object $props
            $splat.DifferenceObject = $studentfile | Select-Object -Property $props
            $missingdata += @(Compare-Object @splat -PassThru -Property $props  |
                            Where-Object {$_.SideIndicator -eq "<="} |
                                Select-Object * -ExcludeProperty SideIndicator |
                                    Out-String)
            if (!$missingdata) {$missingdata = ,"None"}
        }
        else {$missingdata = "Not graded due to problems with hosts or properties. Correct these issues and grade again."}
        if (!$extrahosts)   {$extrahosts   = ,"None"}
        if (!$missingprops) {$missingprops = ,"None"}
        if (!$missinghosts) {$missinghosts = ,"None"}

        $results = "Grade Results for {0} Below:`n" -f $curlabrubric.labname
        $results += "-" * 50
        $results += ("`nMissing Properties: {0} `n" -f ($missingprops -join ", "))
        $results += ("Missing Hosts: {0} `n" -f ($missinghosts -join ", "))
        $results += ("Extra Hosts: {0} `n" -f ($extrahosts -join ", "))
        $results += ("Missing Data: {0}`n" -f ($missingdata -join "`n"))
        $splat.ReferenceObject = ($missingdata + $extrahosts + $missingprops + $missinghosts)
        $splat.DifferenceObject = @("None") * 4
        if (!(Compare-Object @splat)) {
            $results += "`n{0} - 100%" -f $curlabrubric.labname
        }
        $rtbResults.Text = $results  
    } #if
    else {$rtbResults.Text = "You must select a lab to grade!"}  
} # Grade script block

# adding form design code from file
Add-Type -AssemblyName System.Windows.Forms
. (Join-Path $PSScriptRoot 'Main.designer.ps1')

# Load Drop Box data
$rubric.rubric.lab |
    ForEach-Object {$cbSelectLab.Items.Add($_.labname) | Out-Null}

# Display form
$frmMain.ShowDialog()

