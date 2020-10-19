##Import-Module C:\Users\nickk\Documents\Import-Xls.psm1
Write-Output (Get-Date) #`n

#Importing the list of PCs from the input.txt file
$names = Get-Content -Path "C:\temp\input.txt"

$names | % {Get-ADcomputer -Identity $_ -Properties Name,OperatingSystemVersion,Description, LastLogonDate, DistinguishedName, MemberOf |
select Name,OperatingSystemVersion,Description, LastLogonDate} | Sort-Object -Property LastLogonDate | ft -A

#$names | ForEach-Object {Test-Connection -ComputerName $_ -count 1 -ErrorAction SilentlyContinue}

#Trying to determine each PC's last user
$names | ForEach-Object -Process {
    $A = $null
    if(Test-Connection $_ -Count 1 -Quiet) { #check if the machine responds to ping
               Write-Host $_ + " is ON"
               $A = Get-ChildItem -Path \\$_\c$\Users -ErrorAction SilentlyContinue | #get the list of the user folders
                                                where {$null -ne $_} | 
                                                sort -Property LastWriteTime -Descending | #sort by modification time
                                                where {$_.Name -notlike 'Public'} |
                                                where {$null -ne $_} |
                                                select -First 1 -Property Name,LastWriteTime #get the most recently changed folders                                                           
               if ($null -ne $A.Name) {
                      $_ + ' | ' + 
                      (Get-ADComputer -Identity $_ -Properties OperatingSystemVersion | select -ExpandProperty OperatingSystemVersion) + ' | ' +
                      (Get-ADComputer -Identity $_ -Properties LastLogonDate | select -Expand LastLogonDate) 
                      
                      Get-ADUser -Identity $A.Name -ErrorAction SilentlyContinue -Properties * | 
                                    select -Property DisplayName, SamAccountName, Office, StreetAddress | 
                                    ft -Property *

                      Write-Output ""
                }
    } 
}

