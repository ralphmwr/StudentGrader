$frmMain = New-Object -TypeName System.Windows.Forms.Form
[System.Windows.Forms.ComboBox]$cbSelectLab = $null
[System.Windows.Forms.Label]$lblSelectLab = $null
[System.Windows.Forms.Button]$btnGrade = $null
[System.Windows.Forms.RichTextBox]$rtbResults = $null
[System.Windows.Forms.Label]$lblCreds = $null
[System.Windows.Forms.Button]$btnLoadCreds = $null
function InitializeComponent
{
$cbSelectLab = (New-Object -TypeName System.Windows.Forms.ComboBox)
$lblSelectLab = (New-Object -TypeName System.Windows.Forms.Label)
$btnGrade = (New-Object -TypeName System.Windows.Forms.Button)
$rtbResults = (New-Object -TypeName System.Windows.Forms.RichTextBox)
$lblCreds = (New-Object -TypeName System.Windows.Forms.Label)
$btnLoadCreds = (New-Object -TypeName System.Windows.Forms.Button)
$frmMain.SuspendLayout()
#
#cbSelectLab
#
$cbSelectLab.DisplayMember = [System.String]'Name'
$cbSelectLab.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$cbSelectLab.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Consolas',[System.Single]9.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$cbSelectLab.FormattingEnabled = $true
$cbSelectLab.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]230,[System.Int32]120))
$cbSelectLab.Name = [System.String]'cbSelectLab'
$cbSelectLab.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]409,[System.Int32]23))
$cbSelectLab.Sorted = $true
$cbSelectLab.TabIndex = [System.Int32]0
$cbSelectLab.ValueMember = [System.String]'File'
#
#lblSelectLab
#
$lblSelectLab.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Tahoma',[System.Single]9.75,[System.Drawing.FontStyle]::Bold,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$lblSelectLab.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]63,[System.Int32]120))
$lblSelectLab.Name = [System.String]'lblSelectLab'
$lblSelectLab.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]161,[System.Int32]23))
$lblSelectLab.TabIndex = [System.Int32]1
$lblSelectLab.Text = [System.String]'Select Lab to Grade'
$lblSelectLab.UseCompatibleTextRendering = $true
#
#btnGrade
#
$btnGrade.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Tahoma',[System.Single]9.75,[System.Drawing.FontStyle]::Bold,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$btnGrade.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]230,[System.Int32]226))
$btnGrade.Name = [System.String]'btnGrade'
$btnGrade.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]409,[System.Int32]36))
$btnGrade.TabIndex = [System.Int32]2
$btnGrade.Text = [System.String]'Grade Lab'
$btnGrade.UseCompatibleTextRendering = $true
$btnGrade.UseVisualStyleBackColor = $true
$btnGrade.add_Click($GradeLab)
#
#rtbResults
#
$rtbResults.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Consolas',[System.Single]14.25,[System.Drawing.FontStyle]::Bold,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$rtbResults.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]30,[System.Int32]292))
$rtbResults.Name = [System.String]'rtbResults'
$rtbResults.ReadOnly = $true
$rtbResults.ScrollBars = [System.Windows.Forms.RichTextBoxScrollBars]::Vertical
$rtbResults.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]816,[System.Int32]328))
$rtbResults.TabIndex = [System.Int32]4
$rtbResults.Text = [System.String]''
$rtbResults.add_TextChanged($rtbResults_TextChanged)
#
#lblCreds
#
$lblCreds.ForeColor = [System.Drawing.Color]::Red
$lblCreds.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]617,[System.Int32]9))
$lblCreds.Name = [System.String]'lblCreds'
$lblCreds.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]254,[System.Int32]23))
$lblCreds.TabIndex = [System.Int32]5
$lblCreds.Text = [System.String]'OwnCloud Credentiials NOT Loaded'
$lblCreds.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$lblCreds.UseCompatibleTextRendering = $true
#
#btnLoadCreds
#
$btnLoadCreds.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]617,[System.Int32]35))
$btnLoadCreds.Name = [System.String]'btnLoadCreds'
$btnLoadCreds.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]254,[System.Int32]31))
$btnLoadCreds.TabIndex = [System.Int32]6
$btnLoadCreds.Text = [System.String]'Load OwnCloud Credentials'
$btnLoadCreds.UseCompatibleTextRendering = $true
$btnLoadCreds.UseVisualStyleBackColor = $true
$btnLoadCreds.add_Click($OwnCloudCredsScript)
#
#frmMain
#
$frmMain.ClientSize = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]883,[System.Int32]644))
$frmMain.Controls.Add($btnLoadCreds)
$frmMain.Controls.Add($lblCreds)
$frmMain.Controls.Add($rtbResults)
$frmMain.Controls.Add($btnGrade)
$frmMain.Controls.Add($lblSelectLab)
$frmMain.Controls.Add($cbSelectLab)
$frmMain.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Tahoma',[System.Single]9.75,[System.Drawing.FontStyle]::Bold,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$frmMain.Text = [System.String]'Lab Grader'
$frmMain.ResumeLayout($false)
Add-Member -InputObject $frmMain -Name base -Value $base -MemberType NoteProperty
Add-Member -InputObject $frmMain -Name cbSelectLab -Value $cbSelectLab -MemberType NoteProperty
Add-Member -InputObject $frmMain -Name lblSelectLab -Value $lblSelectLab -MemberType NoteProperty
Add-Member -InputObject $frmMain -Name btnGrade -Value $btnGrade -MemberType NoteProperty
Add-Member -InputObject $frmMain -Name rtbResults -Value $rtbResults -MemberType NoteProperty
Add-Member -InputObject $frmMain -Name lblCreds -Value $lblCreds -MemberType NoteProperty
Add-Member -InputObject $frmMain -Name btnLoadCreds -Value $btnLoadCreds -MemberType NoteProperty
}
. InitializeComponent
