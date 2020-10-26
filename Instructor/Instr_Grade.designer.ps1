$frmInstr_Grade = New-Object -TypeName System.Windows.Forms.Form
[System.Windows.Forms.Label]$lblCreds = $null
[System.Windows.Forms.Button]$btnLoadCreds = $null
[System.Windows.Forms.Label]$lblRubricLoad = $null
[System.Windows.Forms.Button]$btnLoadRubric = $null
[System.Windows.Forms.ComboBox]$cbSelectRoster = $null
[System.Windows.Forms.ListBox]$lbRoster = $null
[System.Windows.Forms.Label]$lblSelRoster = $null
[System.Windows.Forms.ListBox]$lbRubricItems = $null
[System.Windows.Forms.Label]$lblRubricItems = $null
[System.Windows.Forms.Button]$btnGrade = $null
[System.Windows.Forms.Button]$btnSelectAllRoster = $null
[System.Windows.Forms.Button]$btnSelectAllRubric = $null
[System.Windows.Forms.RichTextBox]$rtbStatus = $null
function InitializeComponent
{
$lblCreds = (New-Object -TypeName System.Windows.Forms.Label)
$btnLoadCreds = (New-Object -TypeName System.Windows.Forms.Button)
$lblRubricLoad = (New-Object -TypeName System.Windows.Forms.Label)
$btnLoadRubric = (New-Object -TypeName System.Windows.Forms.Button)
$cbSelectRoster = (New-Object -TypeName System.Windows.Forms.ComboBox)
$lbRoster = (New-Object -TypeName System.Windows.Forms.ListBox)
$lblSelRoster = (New-Object -TypeName System.Windows.Forms.Label)
$lbRubricItems = (New-Object -TypeName System.Windows.Forms.ListBox)
$lblRubricItems = (New-Object -TypeName System.Windows.Forms.Label)
$btnGrade = (New-Object -TypeName System.Windows.Forms.Button)
$btnSelectAllRoster = (New-Object -TypeName System.Windows.Forms.Button)
$btnSelectAllRubric = (New-Object -TypeName System.Windows.Forms.Button)
$rtbStatus = (New-Object -TypeName System.Windows.Forms.RichTextBox)
$frmInstr_Grade.SuspendLayout()
#
#lblCreds
#
$lblCreds.ForeColor = [System.Drawing.Color]::Red
$lblCreds.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]10))
$lblCreds.Name = [System.String]'lblCreds'
$lblCreds.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]335,[System.Int32]44))
$lblCreds.TabIndex = [System.Int32]1
$lblCreds.Text = [System.String]'OwnCloud Credentiials NOT Loaded'
$lblCreds.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$lblCreds.UseCompatibleTextRendering = $true
#
#btnLoadCreds
#
$btnLoadCreds.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]57))
$btnLoadCreds.Name = [System.String]'btnLoadCreds'
$btnLoadCreds.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]335,[System.Int32]46))
$btnLoadCreds.TabIndex = [System.Int32]2
$btnLoadCreds.Text = [System.String]'Load OwnCloud Credentials'
$btnLoadCreds.UseCompatibleTextRendering = $true
$btnLoadCreds.UseVisualStyleBackColor = $true
$btnLoadCreds.add_Click($OwnCloudCredsScript)
#
#lblRubricLoad
#
$lblRubricLoad.ForeColor = [System.Drawing.Color]::Red
$lblRubricLoad.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]384,[System.Int32]10))
$lblRubricLoad.Name = [System.String]'lblRubricLoad'
$lblRubricLoad.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]335,[System.Int32]44))
$lblRubricLoad.TabIndex = [System.Int32]3
$lblRubricLoad.Text = [System.String]'Rubric Not Loaded'
$lblRubricLoad.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$lblRubricLoad.UseCompatibleTextRendering = $true
#
#btnLoadRubric
#
$btnLoadRubric.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]384,[System.Int32]57))
$btnLoadRubric.Name = [System.String]'btnLoadRubric'
$btnLoadRubric.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]335,[System.Int32]46))
$btnLoadRubric.TabIndex = [System.Int32]4
$btnLoadRubric.Text = [System.String]'Load Rubric'
$btnLoadRubric.UseCompatibleTextRendering = $true
$btnLoadRubric.UseVisualStyleBackColor = $true
$btnLoadRubric.add_Click($LoadRubric)
#
#cbSelectRoster
#
$cbSelectRoster.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$cbSelectRoster.FormattingEnabled = $true
$cbSelectRoster.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]168))
$cbSelectRoster.Name = [System.String]'cbSelectRoster'
$cbSelectRoster.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]335,[System.Int32]26))
$cbSelectRoster.TabIndex = [System.Int32]5
$cbSelectRoster.add_SelectedIndexChanged($LoadRoster)
#
#lbRoster
#
$lbRoster.FormattingEnabled = $true
$lbRoster.ItemHeight = [System.Int32]18
$lbRoster.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]217))
$lbRoster.MultiColumn = $true
$lbRoster.Name = [System.String]'lbRoster'
$lbRoster.SelectionMode = [System.Windows.Forms.SelectionMode]::MultiExtended
$lbRoster.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]335,[System.Int32]436))
$lbRoster.TabIndex = [System.Int32]6
#
#lblSelRoster
#
$lblSelRoster.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]142))
$lblSelRoster.Name = [System.String]'lblSelRoster'
$lblSelRoster.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]335,[System.Int32]23))
$lblSelRoster.TabIndex = [System.Int32]7
$lblSelRoster.Text = [System.String]'Select Roster'
$lblSelRoster.UseCompatibleTextRendering = $true
#
#lbRubricItems
#
$lbRubricItems.FormattingEnabled = $true
$lbRubricItems.ItemHeight = [System.Int32]18
$lbRubricItems.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]384,[System.Int32]217))
$lbRubricItems.Name = [System.String]'lbRubricItems'
$lbRubricItems.SelectionMode = [System.Windows.Forms.SelectionMode]::MultiExtended
$lbRubricItems.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]335,[System.Int32]436))
$lbRubricItems.TabIndex = [System.Int32]8
#
#lblRubricItems
#
$lblRubricItems.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]384,[System.Int32]191))
$lblRubricItems.Name = [System.String]'lblRubricItems'
$lblRubricItems.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]335,[System.Int32]23))
$lblRubricItems.TabIndex = [System.Int32]9
$lblRubricItems.Text = [System.String]'Rubric Items'
$lblRubricItems.UseCompatibleTextRendering = $true
#
#btnGrade
#
$btnGrade.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Courier New',[System.Single]18,[System.Drawing.FontStyle]::Bold,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$btnGrade.ForeColor = [System.Drawing.Color]::Green
$btnGrade.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]279,[System.Int32]710))
$btnGrade.Name = [System.String]'btnGrade'
$btnGrade.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]165,[System.Int32]66))
$btnGrade.TabIndex = [System.Int32]10
$btnGrade.Text = [System.String]'GRADE'
$btnGrade.UseCompatibleTextRendering = $true
$btnGrade.UseVisualStyleBackColor = $true
$btnGrade.add_Click($Grade)
#
#btnSelectAllRoster
#
$btnSelectAllRoster.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]659))
$btnSelectAllRoster.Name = [System.String]'btnSelectAllRoster'
$btnSelectAllRoster.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]164,[System.Int32]31))
$btnSelectAllRoster.TabIndex = [System.Int32]11
$btnSelectAllRoster.Text = [System.String]'Select All'
$btnSelectAllRoster.UseCompatibleTextRendering = $true
$btnSelectAllRoster.UseVisualStyleBackColor = $true
$btnSelectAllRoster.add_Click($SelectAllRoster)
#
#btnSelectAllRubric
#
$btnSelectAllRubric.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]555,[System.Int32]659))
$btnSelectAllRubric.Name = [System.String]'btnSelectAllRubric'
$btnSelectAllRubric.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]164,[System.Int32]31))
$btnSelectAllRubric.TabIndex = [System.Int32]12
$btnSelectAllRubric.Text = [System.String]'Select All'
$btnSelectAllRubric.UseCompatibleTextRendering = $true
$btnSelectAllRubric.UseVisualStyleBackColor = $true
$btnSelectAllRubric.add_Click($SelectAllRubric)
#
#rtbStatus
#
$rtbStatus.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]109))
$rtbStatus.Name = [System.String]'rtbStatus'
$rtbStatus.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]707,[System.Int32]544))
$rtbStatus.TabIndex = [System.Int32]13
$rtbStatus.Text = [System.String]''
$rtbStatus.Visible = $false
#
#frmInstr_Grade
#
$frmInstr_Grade.ClientSize = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]744,[System.Int32]788))
$frmInstr_Grade.Controls.Add($rtbStatus)
$frmInstr_Grade.Controls.Add($btnSelectAllRubric)
$frmInstr_Grade.Controls.Add($btnSelectAllRoster)
$frmInstr_Grade.Controls.Add($btnGrade)
$frmInstr_Grade.Controls.Add($lblRubricItems)
$frmInstr_Grade.Controls.Add($lbRubricItems)
$frmInstr_Grade.Controls.Add($lblSelRoster)
$frmInstr_Grade.Controls.Add($lbRoster)
$frmInstr_Grade.Controls.Add($cbSelectRoster)
$frmInstr_Grade.Controls.Add($btnLoadRubric)
$frmInstr_Grade.Controls.Add($lblRubricLoad)
$frmInstr_Grade.Controls.Add($btnLoadCreds)
$frmInstr_Grade.Controls.Add($lblCreds)
$frmInstr_Grade.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Courier New',[System.Single]12,[System.Drawing.FontStyle]::Bold,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$frmInstr_Grade.ImeMode = [System.Windows.Forms.ImeMode]::Disable
$frmInstr_Grade.Text = [System.String]'Grader (Instructor Version)'
$frmInstr_Grade.ResumeLayout($false)
Add-Member -InputObject $frmInstr_Grade -Name base -Value $base -MemberType NoteProperty
Add-Member -InputObject $frmInstr_Grade -Name lblCreds -Value $lblCreds -MemberType NoteProperty
Add-Member -InputObject $frmInstr_Grade -Name btnLoadCreds -Value $btnLoadCreds -MemberType NoteProperty
Add-Member -InputObject $frmInstr_Grade -Name lblRubricLoad -Value $lblRubricLoad -MemberType NoteProperty
Add-Member -InputObject $frmInstr_Grade -Name btnLoadRubric -Value $btnLoadRubric -MemberType NoteProperty
Add-Member -InputObject $frmInstr_Grade -Name cbSelectRoster -Value $cbSelectRoster -MemberType NoteProperty
Add-Member -InputObject $frmInstr_Grade -Name lbRoster -Value $lbRoster -MemberType NoteProperty
Add-Member -InputObject $frmInstr_Grade -Name lblSelRoster -Value $lblSelRoster -MemberType NoteProperty
Add-Member -InputObject $frmInstr_Grade -Name lbRubricItems -Value $lbRubricItems -MemberType NoteProperty
Add-Member -InputObject $frmInstr_Grade -Name lblRubricItems -Value $lblRubricItems -MemberType NoteProperty
Add-Member -InputObject $frmInstr_Grade -Name btnGrade -Value $btnGrade -MemberType NoteProperty
Add-Member -InputObject $frmInstr_Grade -Name btnSelectAllRoster -Value $btnSelectAllRoster -MemberType NoteProperty
Add-Member -InputObject $frmInstr_Grade -Name btnSelectAllRubric -Value $btnSelectAllRubric -MemberType NoteProperty
Add-Member -InputObject $frmInstr_Grade -Name rtbStatus -Value $rtbStatus -MemberType NoteProperty
}
. InitializeComponent
