#Script to enable and disable calendar access.
#Author: KineticByte
#Date of creation: 19/03/2024
#Version 1.0


#Examples below
# Script provides UserB with access to edit UserA's Calendar - particularly useful for onboarding prior to staff start date.
##.\O365Calendar.ps1 -CalendarName "Firstname LastName" -Add -User "FirstName LastName"
##.\O365Calendar.ps1 -CalendarName "UserA" -Add -User "UserB"
##.\O365Calendar.ps1 -CalendarName "UserA" -Remove -User "UserB"
##C:\path\to\file\O365Calendar.ps1 -CalendarName "John Doe" -Add -User "HR Admin"

param(
[String]$CalendarName,
[switch]$Add,
[switch]$Remove,
[String]$User
)

# - Requires an administrator with access to all staff calendars to edit access rights. 
$UPN = "<UPN of User with privileges>"

Connect-ExchangeOnline -UserPrincipalName $UPN

If($Add){
    Write-Output "Adding Edit access to $CalendarName's calendar for $User"
    Add-MailboxFolderPermission -Identity "${CalendarName}:\Calendar" -User "$User" -AccessRights Editor
    Write-Output "Result after operation"
    Get-MailboxFolderPermission -Identity "${CalendarName}:\Calendar" | ft Identity,FolderName,User,AccessRights   
}

If($Remove){
    Write-Output "Removing Edit access from $CalendarName's Calendar for $User"
    Remove-MailboxFolderPermission -Identity "${CalendarName}:\Calendar" -User "$User"
    Write-Output "Result after operation"
    Get-MailboxFolderPermission -Identity "${CalendarName}:\Calendar" | ft Identity,FolderName,User,AccessRights  

}
