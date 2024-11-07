<#
.SYNOPSIS
Return list of Organization staff without MFA enforced to address and maintain cybersecurity posture.

.DESCRIPTION
MFACheck.ps1 connects to the Microsoft Online Service (Office 365) to retrieve a list of user accounts and the associated MFA status of that account.
This list is then filtered to only return those with an active O365 license, end in @microsoftdomain.com, and have the MFA status of "disabled" or "enabled"
Finally, this list is compared against a static list of user accounts to exclude from the search, which is then outputted to the terminal.

This script can be run using stored credentials and emails results to a user account. 

.NOTES
  Version:        1.0
  Author:         Krishan Sardana
  Creation Date:  18/10/2024   
  Purpose/Change: Initial sanitized script. 

.RUNNING REQUIREMENTS
  File Run location: \\Path\To\File\MFACheck\MFACheck.ps1 # Recommended to leave file inside dedicated folder for script as logs are stored in the script location. 
 
  # Make sure this user account doesn't need MFA. Service account with very long (impossible to remember) password recommended. Use password manager. 
  RunAs User: useraccount@microsoftdomain.com 
  
  #Secret text file - create using https://stackoverflow.com/questions/6239647/using-powershell-credentials-without-being-prompted-for-a-password
  Stored credential: C:\Path\To\File.txt 
#>

# Establish Credentials for MSOL
$MSOLUsername = "useraccount@microsoftdomain.com"
$Password = Get-Content "C:\Path\To\File.txt" | ConvertTo-SecureString
$MSOLCreds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $MSOLUsername, $Password

# Connect to Microsoft Online (O365). 
Connect-MsolService -Credential $MSOLCreds

# Create list of users to exclude from the search
$ExcludeArray = 
"auser@microsoftdomain.com", 
"testuser@microsoftdomain.com", 


### MFA Status = Disabled
# Create array of Microsoft Online User accounts that end in @microsoftdomain.com, have a Microsoft License, and have MFA status of disabled.
$DisabledArray = Get-MsolUser -All | Where-Object { $_.UserPrincipalName -like "*microsoftdomain.com" } | Where-Object { $_.IsLicensed -like "True" } | 
    Select-Object DisplayName, UserPrincipalName, @{Name='MFAStatus'; Expression={ If ($_.StrongAuthenticationRequirements.Count -ne 0) { $_.StrongAuthenticationRequirements[0].State } Else {'Disabled'} } } | Where-Object { $_.MFAStatus -eq 'Disabled' }

# Remove items from UserArray that exist in ExcludeArray
$DisabledArray = $DisabledArray | Where-Object { $ExcludeArray -notcontains $_.UserPrincipalName }

### MFA Status = Enabled
# Create array of Microsoft Online User accounts that end in @microsoftdomain.com, have a Microsoft License, and have MFA status of enabled.
$EnabledArray = Get-MsolUser -All | Where-Object { $_.UserPrincipalName -like "*microsoftdomain.com" } | Where-Object { $_.IsLicensed -like "True" } | 
    Select-Object DisplayName, UserPrincipalName, @{Name='MFAStatus'; Expression={ If ($_.StrongAuthenticationRequirements.Count -ne 0) { $_.StrongAuthenticationRequirements[0].State } Else {'Disabled'} } } | Where-Object { $_.MFAStatus -eq 'Enabled' }

# Remove items from UserArray that exist in ExcludeArray
$EnabledArray = $EnabledArray | Where-Object { $ExcludeArray -notcontains $_.UserPrincipalName }

# Define the path for the CSV file
$CsvPath = "C:\Path\To\File\CheckMFA\MFAResults.csv"

# Combine both Enabled and Disabled users into one array for exporting
$CombinedArray = @()

# Add Disabled users
foreach ($user in $DisabledArray) {
    $CombinedArray += [PSCustomObject]@{
        DisplayName = $user.DisplayName
        UserPrincipalName = $user.UserPrincipalName
        MFAStatus = "Disabled"
    }
}

# Add Enabled users
foreach ($user in $EnabledArray) {
    $CombinedArray += [PSCustomObject]@{
        DisplayName = $user.DisplayName
        UserPrincipalName = $user.UserPrincipalName
        MFAStatus = "Enabled"
    }
}

# Export to CSV
$CombinedArray | Export-Csv -Path $CsvPath -NoTypeInformation -Force

# Prepare email body
$EmailBody = "Please find the attached MFA Status report."

#### Send email with results
$EmailTo = "emailto@microsoftdomain.com"  # Change this to the recipient's email address
$EmailFrom = "useraccount@microsoftdomain.com"
$Subject = "MFA Status Report for {Organization} Staff"
$SMTPServer = "smtp_server@microsoftdomain.com"  # Change this to your SMTP server

Send-MailMessage -To $EmailTo -From $EmailFrom -Subject $Subject -Body $EmailBody -SmtpServer $SMTPServer -Attachments $CsvPath
