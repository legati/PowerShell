#
Search-ADAccount -AccountDisabled -ComputersOnly | select -first 1 | 
Move-ADObject -TargetPath "OU=Disabled Computers,DC=corp,DC=lan" -WhatIf

#
Search-ADAccount -AccountDisabled -ComputersOnly | 
Where-Object -FilterScript {!$_.DistinguishedName.Contains("Disabled Computers")} | 
Move-ADObject -TargetPath "OU=Disabled Computers,DC=corp,DC=lan" -WhatIf

#
Search-ADAccount -AccountDisabled -UsersOnly | 
Where-Object -FilterScript {!$_.DistinguishedName.Contains("OU=Disabled,OU=Orionstone,DC=corp,DC=lan")} | 
Move-ADObject -TargetPath "OU=Disabled,OU=Orionstone,DC=corp,DC=lan" -WhatIf

#
dsquery user -inactive 12 -limit 200 | where-object -filterscript {!$_.contains('Disabled')} | 
dsmod user -Disabled Yes

#
dsquery computer -inactive 12 -limit 200 | 
where-object -filterscript {!$_.contains('Disabled') -and !$_.contains('Server')} 

#
dsquery user -inactive 12 -limit 1000 | 
where-object -filterscript {!$_.contains('Disabled') -and !$_.contains('Service Accounts') > users.txt

#
Search-ADAccount -AccountDisabled -UsersOnly | 
Where-Object -FilterScript {!$_.DistinguishedName.Contains("OU=Disabled Computers And Users,DC=EMECO,DC=INTERNAL")} | 
Move-ADObject -TargetPath "OU=Users,OU=Disabled Computers And Users,DC=EMECO,DC=INTERNAL" -WhatIf

#
get-content \\temp\corp.txt | Get-ADUser -Identity {$_.replace('"','')} | Disable-ADAccount -whatif

#
Search-ADAccount  -ComputersOnly -AccountInactive -TimeSpan 60.00:00:00 | FT Name -A

#
Get-CimInstance -ClassName Win32_Product | select Name #where {$_.Name -like "*Edge*"}

#
Import-Module 'C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1'

Get-CimInstance -ComputerName '' -ClassName Win32_OperatingSystem

#
Search-ADAccount -ComputersOnly -AccountInactive -TimeSpan 90.00:00:00| 
                  Where-Object -FilterScript {!($_.DistinguishedName -contains '*Disabled*') -and ($_.Name -like 'LT*')} | 
                  select Name,LastLogonDate, DistinguishedName | 
                  sort LastLogonDate

#
Get-ADComputer -id  -prop OperatingSystemVersion