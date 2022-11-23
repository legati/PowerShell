param([Parameter(Mandatory=$true)][string]$Username, 
      [Parameter(Mandatory=$true)][string]$ADGroupName)


#Function definition

Function FnStopPSSession {
    if($Global:DCsession) 
    {
        Disconnect-PSSession -Session $Global:DCsession
        Remove-PSSession -Session $Global:DCsession
    } 
}


### EXECUTION

#Prompt for admin credentials
$AdminCred = Get-Credential -Message "Please provide Admin credentials"


$Global:DCsession = New-PSSession -ComputerName "Server01" -Credential $AdminCred
#Start-Sleep -Seconds 2


#Test if the user is a member of the group already. If NOT add the user
$members = Invoke-Command  -Session $Global:DCsession -ScriptBlock {Get-ADGroupMember -Identity $using:ADGroupName -Recursive | Select -ExpandProperty SamAccountName}

 If ($members -contains $Username) {
        Write-Host "$Username is already a member of $ADGroupName, terminating the script"
        #Pause
        FnStopPSSession
        Exit 2
        } 
 Else {
        Invoke-Command  -Session $Global:DCsession -ScriptBlock {Add-ADGroupMember -Identity $using:ADGroupName -Members $using:Username}
        
        #Confirm the user is a member of the group
        $memberscheck = Invoke-Command  -Session $Global:DCsession -ScriptBlock {Get-ADGroupMember -Identity $using:ADGroupName -Recursive | Select -ExpandProperty SamAccountName}
        If ($memberscheck -contains $Username) {
            Write-Host "$Username is now a member of $ADGroupName"
            #Pause
            FnStopPSSession
            Exit 0
        } 
        Else {
            Write-Host "Something went wrong. $Username is has not been added to $ADGroupName"
            #Pause
            FnStopPSSession
            Exit 1
        }
}
