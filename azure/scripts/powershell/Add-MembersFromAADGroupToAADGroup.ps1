<#
.SYNOPSIS
    Add members from one AD group to another Azure AD Group.

.DESCRIPTION
    Add-MembersFromAADGroupToAADGroup adds members from one AD group to another Azure AD Group.
    This script will only add type of users and ignore all other types, like groups. 

.PARAMETER FromGroupDisplayName
    Specifies a the displayname of the group you want to add the members from. 

.PARAMETER TargetGroupDisplayName
    Specifies a the displayname of the group you want to add the members to. 

.EXAMPLE
     \Add-MembersFromAADGroupToAADGroup.ps1 -FromGroupDisplayName "GroupOne" -TargetGroupDisplayName "GroupAdd"

.INPUTS
    String

.OUTPUTS
    Object[]

.NOTES
    Author:  Øystein Stræte
    Website: https://me.qbits.no/
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]$FromGroupDisplayName,
    [Parameter(Mandatory)]
    [string]$TargetGroupDisplayName
)

$members = Get-AzAdGroupMember -GroupDisplayName $FromGroupDisplayName
$TargetGroupMembers = Get-AzAdGroupMember -GroupDisplayName $TargetGroupDisplayName 

$addedMembers = @()

foreach ( $m in $members ) {

    if ( $m.type -eq 'User' ) {

        if ( $m.id -notin $TargetGroupMembers.id ) {
            Write-Host "Adding $( $m.UserPrincipalName ) to $TargetGroupDisplayName"
            $addedMembers += Add-AzADGroupMember -MemberObjectId $m.id -TargetGroupDisplayName $TargetGroupDisplayName
        }
        
        else {
            Write-Host "$( $m.UserPrincipalName ) is already member of group $TargetGroupDisplayName."
        }
    }
    
    else {
        "Write-Host $($m.DisplayName) is not a type user. This will not be added . . ."
    }
}

Write-OutPut $addedMembers