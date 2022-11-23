$crd_path = '\\corp\data\34_CD'
$mtw_path = '\\corp.atlasiron.com.au\data\30 - MW'

get-acl (Get-DfsnFolder -Path "\\corp\data\30 - MW" | Get-dfsnfoldertarget).TargetPath

$crd_acl = (get-acl -Path $crd_path).Access
$crd_acl[1] | FL
$crd_acl.FileSystemRights

(get-acl -Path $folder).Access | FT

Get-ADGroupMember -id File-Finance -Recursive | FT

$groups = Get-ADGroup -filter 'Name -like "File-MW-*"'
$groups | FT

get-help Set-Acl -Examples

#ACL
$AccessControlType = "Allow"
$FileSystemRights = "ReadData, ExecuteFile, Synchronize"
$IsInherited = "False"

$testfolder = 'C:\temp\TestFolder'

$currentACL = get-acl -path $mtw_path

$NewACL = get-acl -path $mtw_path
$NewACL | FL

#New rule
foreach ($group in $groups) {
        Write-Host "Group: $group"
        $Identity = "CORP\" + $group.Name
        if (!($Identity -in $currentACl.Access.IdentityReference)) {
            $ACLarguments = $Identity,$FileSystemRights,$AccessControlType
            Write-Host "Arguments: $ACLarguments"
            $ACLrule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $ACLarguments
            $NewACL.SetAccessRule($ACLrule)
            #Write-Host "ACL: $NewACL.Access"
            #Set-Acl -Path $mtw_path -AclObject $NewACL -Verbose
        }
        else {
            Write-Host "Already in the group"
        }
}


get-acl -path $mtw_path | FL
