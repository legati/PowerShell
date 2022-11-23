$paths = "C:\ProgramData\Maptek\features\Default.json","C:\ProgramData\Maptek\geotechnical attributes\Default.json", "C:\ProgramData\Maptek\geotechnical attributes\settings.json",
"C:\ProgramData\Maptek\coordinateSystems.json","C:\ProgramData\Maptek\coordinateSystemTransforms.json"

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