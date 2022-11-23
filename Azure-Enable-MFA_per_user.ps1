#Enable MFA for the user $strUPN

param (
[Parameter(Mandatory=$True)][String] $strUsername
)

#Definition
function FnEnableUserMFA {

    param(
    [Parameter(Mandatory=$true,  ValueFromPipeline = $true)][String] $xpsUPN
    )
    
    #Create setting
    $mf = New-Object -TypeName Microsoft.Online.Administration.StrongAuthenticationRequirement
    $mf.RelyingParty = "*"
    $mfa=@($mf)
    
    #Enable MFA for a user
    Write-Host "Attempting to set MFA for the user"
    Set-MsolUser -UserPrincipalName $xpsUPN -StrongAuthenticationRequirements $mfa -ErrorAction SilentlyContinue

}

#Execution
$StrUPN = $strUsername + "@corp"
Write-Host "Username is: $strUPN"

Connect-MsolService

$userMFAStatusPrior = (Get-msoluser -UserPrincipalName $strUPN).StrongAuthenticationRequirements.State
Write-Host "User MFA status BEFORE is: " $userMFAStatusPrior
if ($userMFAStatusPrior) {
            Write-Host "User MFA is already set"
            Exit 2
            Pause
}

FnEnableUserMFA -xpsUPN $strUPN

$userMFAStatusPosterior = (Get-msoluser -UserPrincipalName $strUPN).StrongAuthenticationRequirements.State
Write-Host "User MFA status AFTER is: " $userMFAStatusPosterior
if ($userMFAStatusPosterior -eq "Enabled") {
          Write-Host "Function worked"
          Exit 0
          Pause
} 
else {
          Write-Host "Function failed"
          Exit 1
          Pause
}
