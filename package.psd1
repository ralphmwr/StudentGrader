@{
        Root = 'c:\Users\micha\OneDrive\Documents\GitHub\StudentGrader\StudentGrader\Instructor\Instr_Grade.ps1'
        OutputPath = 'c:\Users\micha\OneDrive\Documents\GitHub\StudentGrader\StudentGrader\out'
        Package = @{
            Enabled = $true
            Obfuscate = $false
            HideConsoleWindow = $false
            DotNetVersion = 'v4.6.2'
            FileVersion = '1.0.0'
            FileDescription = ''
            ProductName = ''
            ProductVersion = ''
            Copyright = ''
            RequireElevation = $false
            ApplicationIconPath = ''
            PackageType = 'Console'
        }
        Bundle = @{
            Enabled = $true
            Modules = $true
            # IgnoredModules = @()
        }
    }
    