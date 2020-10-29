$OC_url = "http://localhost"
class HTMLReport {
    [System.Xml.XmlDocument]$xmldoc
    HTMLReport() {
        $this.xmldoc = New-Object -TypeName System.Xml.XmlDocument
        $doctype = $this.xmldoc.CreateDocumentType("html", $null, $null, $null)
        $this.xmldoc.AppendChild($doctype)
        $elem = $this.xmldoc.CreateElement("html")
        $elem.SetAttribute("xmlns", "http://www.w3.org/1999/xhtml")
        $this.xmldoc.AppendChild($elem)
        $head = $this.xmldoc.CreateElement("head")
        $elem.AppendChild($head)
        $style = $this.xmldoc.CreateElement("style")
        $styledef = $this.xmldoc.CreateTextNode("table, th, td {border: 1px solid black; } 
        table.center {margin-left: auto; margin-right: auto; }
        pre{font-family: courier;}")
        $style.AppendChild($styledef)
        $head.AppendChild($style)
        $body = $this.xmldoc.CreateElement("body")
        $title = $this.xmldoc.CreateElement("h1")
        $text = $this.xmldoc.CreateTextNode("Grade Report:")
        $title.AppendChild($text)
        $body.AppendChild($title)
        $elem.AppendChild($body)        
    }
    AddStudent([string]$Student, [string]$loc){
        $body = $this.xmldoc.GetElementsByTagName("body")
        $elembr = $this.xmldoc.CreateElement("br")
        $body.AppendChild($elembr)
        $elemtbl = $this.xmldoc.CreateElement("table")
        $elemtbl.SetAttribute("Student",$student)
        $body.AppendChild($elemtbl)
        $elemcaption = $this.xmldoc.CreateElement("caption")
        $elemtbl.AppendChild($elemcaption)
        $captiontext = $this.xmldoc.CreateElement("a")
        $captiontext.SetAttribute("href", $loc)
        $innercaption = $this.xmldoc.CreateTextNode($student)
        $captiontext.AppendChild($innercaption)
        $elemcaption.AppendChild($captiontext)  
        $elemtr = $this.xmldoc.CreateElement("tr")
        $elemtbl.AppendChild($elemtr)
        foreach ($th in "Item", "Result") {
            $elemth = $this.xmldoc.CreateElement("th")
            $headertxt = $this.xmldoc.CreateTextNode($th)
            $elemth.AppendChild($headertxt)
            $elemtr.AppendChild($elemth)
        }
    }
    AddRubricItem([string]$studentname,[string]$ItemName, [string]$rslt) {
        $table = $this.xmldoc.GetElementsByTagName("table") | 
            Where-Object {$_.GetAttributeNode("Student").value -eq $studentname}
        $row = $this.xmldoc.CreateElement("tr")
        $item = $this.xmldoc.CreateElement("td")
        $itemtext = $this.xmldoc.CreateTextNode($ItemName)
        $item.AppendChild($itemtext)
        $result = $this.xmldoc.CreateElement("td")
        $pre = $this.xmldoc.CreateElement("pre")
        $resulttext = $this.xmldoc.CreateTextNode(($rslt -replace "\t", ""))
        $pre.AppendChild($resulttext)
        $result.AppendChild($pre)
        $row.AppendChild($item)
        $row.AppendChild($result)
        $table.AppendChild($row)
    }
}

$Grade = {
    $report = New-Object -TypeName HTMLReport    
    $downloadloc = New-Item -Path $env:TEMP -Name ((Get-Date).ToString("yyMMddhhmm")) -ItemType Directory | Select-Object -ExpandProperty fullname
    $rtbStatus.Visible = $true
    $btnGrade.Text = "In Progress"
    $btnGrade.Enabled = $false
    $rtbStatus.Text = "Starting Grading Process...`n"
    foreach ($student in $lbRoster.SelectedItems) {
        $rtbStatus.Text += "`nGrading $student `n"
        $report.AddStudent($student, ("O:\{0}\{1}" -f $cbSelectRoster.SelectedItem, $student))
        foreach ($rubricItem in $lbRubricItems.SelectedItems) {
            $workingrubric = $script:rubric.Clone()
            $rtbStatus.Text += "`t$rubricItem`n"
            $curlabrubric = $workingrubric.rubric.ChildNodes | 
                    Where-Object {$_.name -eq $rubricItem}
            $filepath = "O:\{0}\{1}\{3}\{2}" -f $cbSelectRoster.SelectedItem, $student, $curlabrubric.OwnCloudName, $curlabrubric.OwnCloudLocation
            $rtbStatus.Text += "`t`tLooking for {0}`n" -f $filepath
            if (!(Test-Path -Path $filepath)){
                $rtbStatus.Text += "`t`tCannot find {0}`n" -f $filepath
                $report.AddRubricItem($student, $rubricItem, "Cannot find $filepath")
                Continue
            }
            $studentfilepath = Get-Item -path $filepath | Select-Object -ExpandProperty fullname
            switch ($curlabrubric.type) {
                "csv" {  
                    $studentfile = Import-Csv -Path $studentfilepath
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
                    $splat.ReferenceObject  = $curlabrubric.RequiredHost.Hostname
                    $splat.DifferenceObject = $studenthosts
                    $hostcheck = @(Compare-Object @splat |
                                    Where-Object {$_.SideIndicator -eq "<="} |
                                        Select-Object -ExpandProperty InputObject)
                    $splat.ReferenceObject = $curlabrubric.RequiredHost.IP
                    $IPCheck = @(Compare-Object @splat |
                                    Where-Object {$_.SideIndicator -eq "<="} |
                                        Select-Object -ExpandProperty InputObject)
                    if ($hostcheck.count -le $IPCheck.count) { 
                        $missinghosts = $hostcheck
                        $curlabrubric.RequiredData.ChildNodes |
                            ForEach-Object {
                                $newnode = $workingrubric.CreateElement("PSComputerName")
                                $newnode.InnerXml = $_.Hostname
                                $_.AppendChild($newnode)
                                $_.RemoveChild(($_.SelectSingleNode("IP")))
                                $_.RemoveChild(($_.SelectSingleNode("Hostname")))
                            } # ForEach-Object
                        $splat.ReferenceObject = $curlabrubric.RequiredHost.Hostname 
                    } #if
                    else { 
                        $missinghosts = $IPCheck
                        $curlabrubric.RequiredData.ChildNodes |
                            ForEach-Object{
                                $newnode = $workingrubric.CreateElement("PSComputerName")
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
                        if ($missingdata) {$missingdata -replace "\r\n","`n`t`t"}
                    } #if nothing wrong
                    else {$missingdata = "Not graded."}
                    $results = ""
                    if($missingprops){$results += ("`t`tMissing Properties: {0} `n" -f ($missingprops -join ", "))}
                    if($missinghosts){$results += ("`t`tMissing Hosts: {0} `n" -f ($missinghosts -join ", "))}
                    if($extrahosts){$results += ("`t`tExtra Hosts: {0} `n" -f ($extrahosts -join ", "))}
                    if($missingdata){$results += ("`t`tMissing Data: {0}`n" -f ($missingdata -join "`n`t`t"))}                   
                    if(!$missingdata -and !$extrahosts -and !$missingprops -and !$missinghosts) {$results += "`t`t100%"}
                    $splat.DifferenceObject = @("None") * 4
                    $rtbStatus.Text += $results 
                } #csv file
                "txt" { 
                    $results = ""
                    $studentfile = Get-Content -Path $studentfilepath
                    foreach ($item in $curlabrubric.RequiredText.ChildNodes) {
                        $valid = foreach ($re in $item.re) {
                            if ($studentfile -match $re) {$true; break}
                        }
                        if (!$valid) {
                            $results += "Invalid {0}`n" -f $item.name
                        }
                    }
                    foreach ($item in $curlabrubric.WrongText.ChildNodes) {
                        $invalid = foreach ($re in $item.re) {
                            if ($studentfile -match $re) {$true; break}
                        }
                        if ($invalid) {
                            $results += "Contains {0}`n" -f $item.name
                        }
                    }
                } #txt file
            } #switch 
            $report.AddRubricItem($student, $rubricItem, $results)
        } #foreach rubricitem
    } #foreach student
    $writer = New-Object -TypeName System.Xml.XmlTextWriter -ArgumentList "$downloadloc\Report.html", $null
    $writer.Formatting = [System.Xml.Formatting]::Indented
    $report.xmldoc.WriteTo($writer)
    $writer.Flush()   
    $writer.Close()
    Invoke-Item "$downloadloc\Report.html"
    $btnGrade.Text = "Grade"
    $btnGrade.Enabled = $true
    $rtbStatus.Visible = $false
} #Grade Script Block

$SelectAllRoster = {
    0..($lbRoster.Items.count - 1) | ForEach-Object {
        $lbRoster.SetSelected($_, $True)
    }
} # SelectAllRoster Script Block

$LoadRoster = {
    $roster = Get-ChildItem -Name -Directory -Path ("O:\{0}" -f $cbSelectRoster.SelectedItem)
    $lbRoster.Items.AddRange($roster)
    $SelectAllRoster.Invoke()
} # LoadRoster Script Block

$OwnCloudCredsScript = {
    $OCCreds = Get-Credential -Message "Enter your Owncloud Credentials:"
    $OCCreds |
        Select-Object UserName, @{n="Password";e={$_.Password | ConvertFrom-SecureString}} |
            Export-Csv -Path "$env:TEMP\occred.csv"
    $lblCreds.Text = "OwnCloud Credentials Loaded"
    $lblCreds.ForeColor = [System.Drawing.Color]::Green
    $btnLoadCreds.Text = "Re-load OwnCloud Credentials"
} # OwnCloudCredsScript Script Block

$SelectAllRubric = {
    0..($lbRubricItems.Items.count - 1) | ForEach-Object {
        $lbRubricItems.SetSelected($_, $True)
    }
} # SelectAllRubric Script Block

$LoadRubric = {
    $openfiledialog = New-Object -TypeName System.Windows.Forms.OpenFileDialog 
    $openfiledialog.InitialDirectory = $PSScriptRoot
    $openfiledialog.Multiselect = $false
    $openfiledialog.Title = "Select Rubric File"
    $openfiledialog.Filter = "XML Files (*.xml)|*.xml"
    $openfiledialog.FilterIndex = 2
    $openfiledialog.ShowDialog()
    $script:rubric = New-Object -TypeName System.xml.xmldocument
    $script:rubric.LoadXml((Get-Content -Path $openfiledialog.FileName))
    $RubricItemNames = $rubric.rubric.ChildNodes | Select-Object -ExpandProperty Name
    $RubricItemNames | ForEach-Object {$lbRubricItems.Items.Add($_)}
    $SelectAllRubric.Invoke()
    $lblRubricLoad.ForeColor = [System.Drawing.Color]::Green
    $lblRubricLoad.Text = $Rubric.rubric.id    
} # LoadRubric Script Block


# adding form design code from file
Add-Type -AssemblyName System.Windows.Forms
. (Join-Path $PSScriptRoot 'Instr_Grade.designer.ps1')

# Loading Creds
if (!(Test-Path -Path "$env:TEMP\occred.csv")) {
    $OwnCloudCredsScript.Invoke()
} #if 
else {
    $ErrorActionPreference = "Stop"
    try {
        $import = Import-Csv -Path "$env:TEMP\occred.csv"
        $OCCreds = New-Object -TypeName pscredential -ArgumentList $import.UserName, ($import.Password | ConvertTo-SecureString)
        $lblCreds.Text = "OwnCloud Credentials Loaded"
        $lblCreds.ForeColor = [System.Drawing.Color]::Green
        $btnLoadCreds.Text = "Re-load OwnCloud Credentials"
    }
    catch {
        $OwnCloudCredsScript.Invoke()
    }    
    $ErrorActionPreference = "Continue"
} # Loading Creds else

$RootPath = "\\{0}\DavWWWRoot\remote.php\webdav" -f ($OC_url -replace "http.*://","")
if (!(Test-Path -Path "O:")) {
    net use O: "$RootPath" /user:"$($OCCreds.UserName)" $($OCCreds.GetNetworkCredential().Password)
}
# Loading Rosters for Test Purposes. Replace with OwnCloud Code
$rosterlist = @(Get-ChildItem -Directory -Name -Path "O:\??-??")
$cbSelectRoster.Items.AddRange($rosterlist)

$frmInstr_Grade.ShowDialog()