$paths = "C:\ProgramData\MT\features\Default.json","C:\ProgramData\MT\geotechnical attributes\Default.json", "C:\ProgramData\MT\geotechnical attributes\settings.json",
"C:\ProgramData\MT\coordinateSystems.json","C:\ProgramData\MT\coordinateSystemTransforms.json"

###ACL Object
$Identity = "BUILTIN\Users"
$fileSysemRights = "Modify, Synchronize"
$type = "Allow"
$fileSystemAccessRuleArgumentList = $identity,$fileSysemRights,$type
$fileSystemAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $fileSystemAccessRuleArgumentList

$isProtected = $false
$preserveInheritance = $false

foreach ($path in $paths){

        $NewAcl = Get-Acl -Path $path
        $NewAcl.SetAccessRule($fileSystemAccessRule)
        $NewAcl.SetAccessRuleProtection($isProtected,$preserveInheritance)

        ###Apply to the file
        Set-Acl -Path $path -AclObject $NewAcl -Confirm
}
