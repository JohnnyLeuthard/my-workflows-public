# psPAS Demo Training Script (v3.3.5.6)


Stitched OCR transcription from `IMG_0697.jpeg` through `IMG_0715.jpeg`.

```powershell
##################################################
### Authenticate
##################################################
#$Environment = 'DEV'
#$Environment = 'QA'

# The REST endpoint (this example is Dev. If you change the URI to UAT or Prod you can plagiarize additional code)
$BASEURL = 'https://eps-darkalbh2i.contoso.dev'   # DEV
#$BASEURL = 'https://passwordvault-qa.contoso.com' # UAT
#$BASEURL = 'https://EPS-QPVAB081329.ent.wb.bank.qa' # UAT 14.6
#$BASEURL = 'https://EPS-QPVAF681825.contoso.uat'    # UAT 14.6
#$BASEURL = 'https://ark302admin99934.contoso.uat'   # UAT 14.6
#$BASEURL = 'https://passwordvault-qa.contoso.com'   # UAT VIP


# CyberArk Authentication (requires checking out a priv ID EPVSysAdmin - you can go without this and use just your ID with RADIUS)
New-PASSession -BaseURI $BASEURL -type CyberArk -Credential (Get-Credential -Message 'Enter RADIUS credential' -UserName 'Admin001')
$CyberArkCreds = Get-PASSession # Save session to a variable for fast switching

# OR

# RADIUS authentication
New-PASSession -BaseURI $BASEURL -type RADIUS -Credential (Get-Credential -Message 'Enter CyberArk Credentials' -UserName $env:USERNAME)
$RadiusCreds = Get-PASSession # Save session to a variable for fast switching


# Switch between sessions - if using multiple - not required just good to know.
# Feel free to use throughout if you have a cyberark and RADIUS account so you can switch between logged in accounts
Use-PASSession $CyberArkCreds
#-or
Use-PASSession $RadiusCreds

# See info on your current session
Get-PASSession | Format-List

# Get current logged in user info
Get-PASLoggedOnUser


##################################################
### Some basic info commands
##################################################
<#

Many commands that start with "Get" also have a set,
of commands for modifying and creating new-xxxx, remove-xxx, etc.
Explore and play

# Get all commands list
Get-Command -Module psPAS

# See info on your current session
Get-PASSession | Format-List

# Get vault info
Get-PASServer

# Get a list of vault authentication methods
Get-PASAuthenticationMethod | Format-Table -AutoSize

# get a full list of groups
Get-PASGroup

# get a list of all platforms
Get-PASPlatform

# Get a list of configured PSM Servers
Get-PASPSMServer

# Get a list of Application IDs
Get-PASApplication

# Get LDAP Directories configured in the Vault
Get-PASDirectory

#>


##################################################
### Get in-line help on commands
##################################################
<#

all these commands and any well written cmdlet have help associated with them

Use Get-Help <command name>

I prefer
Use Get-Help <command name> -full

Use Get-Help <command name> -ShowWindow

# basic help
Get-Help Get-PASPlatform

# show examples
Get-Help Get-PASPlatform -Examples

# Full help (examples and all help)
Get-Help Get-PASPlatform -Full

# full help (examples and all) in a window
Get-Help Get-PASPlatform -ShowWindow

# Get help on using "get-help"
Get-Help get-help -ShowWindow

# Lists all connection components configured in the environment
Get-PASConnectionComponent

# Get PSM Sessions (might fail if there are no recordings. Good chance in Dev)
Get-PASPSMRecording -Sort +Filename

#>


##################################################
### Misc variables (load all of these into memory before proceeding)
##################################################

# Create datestamp to append to export file names
$DateStamp = (Get-Date -f MMddyy)

# Variable used to make these actions unique to you
$MyCustom = 'pspasJL' # no more than 8 in length ***** change JL to your initials *****

# Safe name that is unique to you used throughout
$SafeName = 'xxxx-L-APP-SV-$MyCustom'

# Dummy account name used when on-boarding and modifying on-boarded attributes.
$AccountUsername = 'DummyAccount-$MyCustom'

# AppID that will be used later
$AppIDName = 'CCP-xxxx-N-$MyCustom'

# Create a variable with demo user ID (ID to create in vault)
$TempDemoUser = 'DemoUser-$MyCustom'
$AccountUsername = $TempDemoUser # temp variable while redoing some code

# Create a secure password (used to seed account created later)
$SecurePass = Read-Host -AsSecureString -Prompt ("password for your TempDemoUser account named - " + "'" + $TempDemoUser + "'")

# If you know how the platform assigned to an account you can aut generate a random password based off the platform requirements like this
#$SecurePass = ConvertTo-SecureString (New-PASAccountPassword -AccountID (Account ID)).password -AsPlainText -Force


##################################################
### Setup your personalized Environment
##################################################

# Create folder where files will be saved
$WorkingFolderBase = 'D:\Temp\psPasLearning'

# Create personal working folder
$PersonalFolder = "$WorkingFolderBase\$MyCustom"
If (!(Test-Path $PersonalFolder)){New-Item -Path $PersonalFolder -ItemType Directory -Force}

# Open working folder
explorer $PersonalFolder

<#
# Create safe permissions XML file

Use the code to create the XML by using the script found here.
Adjust as you like just don't use in Production without having proper permissions.
Just copy and paste the code in to the ISE and run it. The default save location will be your personal learning folder just created

https://confluence.contoso.net/display/PSI/Create+Safe+Permissions+XML
#>


##################################################
### Start a transaction log of the commands and results that will be saved to your personal folder
##################################################
$TranscriptFile = "$PersonalFolder\$MyCustom-Transcript-$DateStamp.txt"
Start-Transcript -LiteralPath $TranscriptFile


##################################################
### create a demo user in vault
##################################################

# Verify if it exists already
Get-PASUser -UserName $TempDemoUser

# Create a HASH with the details of the account to add
$VaultUserHash = @{
    'username'                     = $TempDemoUser
    'InitialPassword'              = $SecurePass
    'userType'                     = 'EPVUser'
    'enableUser'                   = $false # Account created in a disabled state.
    'ChangePassOnNextLogon'        = $false
    'passwordNeverExpires'         = $false
    'description'                  = "psPAS demo learning - $MyCustom"
    'ExpiryDate'                   = (get-date).AddDays(90)
}

# Create a new temp user in the vault with the above values
New-PASUser @VaultUserHash

# Query vault for user just created and save metadata to a variable named $TempDemoUserDetails. make note of your "username"
Get-PASUser -UserName $TempDemoUser -OutVariable TempDemoUserDetails


##################################################
### Group Actions
##################################################

# Verify it is not already created
$GroupName = "Group-$MyCustom" # Variable for the group name
Get-PASGroup -groupName $GroupName

# Create a HASH with the details of the vault group to add
$GroupHash = @{
    'GroupName'   = $GroupName
    'Description' = "Group - $MyCustom"
    'Location'    = '\'
}

# Create the group
New-PASGroup @GroupHash

# verify it was created and save details to a variable named $TempDemoGroupDetails
Get-PASGroup -groupName $GroupName -OutVariable TempDemoGroupDetails

# Add you demo demo user created above to group you just created
Add-PASGroupMember -groupId $TempDemoGroupDetails.ID -memberId $TempDemoUserDetails.username

# Remove temp user from group
Remove-PASGroupMember -GroupID $TempDemoGroupDetails.id -Member $TempDemoUserDetails.username


##################################################
### Application Actions
##################################################

# Get list of all application ID's
Get-PASApplication

# Add a New AppID
Add-PASApplication -Location '\Applications' -AppID $AppIDName -Description 'Learning psPAS - Applications' -Disabled $false

# Verify it was created
Get-PASApplication -AppID $AppIDName

Get-PASApplicationAuthenticationMethod -AppID $AppIDName | Format-Table -AutoSize
### tip: re-run the get auth methods command to verify after each action.

# Add auth method(s)

# Add serial number - We could tailor this to add multiple SN & comments with a loop
Add-PASApplicationAuthenticationMethod -AppID $AppIDName -certificateSerialNumber '3C002486DE1246BA635C5E4S1F000000146DE' -Comment 'my dummy cert'

# Add a list of IP's
$IPList = @()
$IPList += '1.2.3.4'
$IPList += '5.6.7.8'
$IPList | ForEach-Object { Add-PASApplicationAuthenticationMethod -AppID $AppIDName -machineAddress $_ }

# Add OS User
$OSUserList = @()
$OSUserList = (whoami)
$OSUserList = 'contoso.com\User01'
$OSUserList = 'contoso.com\User02'
Add-PASApplicationAuthenticationMethod -AppID $AppIDName -osUser 'contoso.dev\User01'
$OSUserList | ForEach-Object { Add-PASApplicationAuthenticationMethod -AppID $AppIDName -osUser $_ }

# Export all auth methods to a CSV
$AuthMethodsCSVFile = "$PersonalFolder\$AppIDName-AuthMethods.csv"
Get-PASApplicationAuthenticationMethod -AppID $AppIDName | Export-Csv $AuthMethodsCSVFile -NoTypeInformation

# Import CSV to verify by opening in a grid view (any object can be sent to Out-GridView for a searchable GUI)
Import-Csv $AuthMethodsCSVFile | Out-GridView -PassThru

# Remove an AppID auth method
Get-PASApplicationAuthenticationMethod -AppID $AppIDName | Format-Table -AutoSize
# make note of the AuthID for the auth method you want to remove and update below

$AuthID = 11 # change this to the # of the auth method to remove
Remove-PASApplicationAuthenticationMethod -AppID $AppIDName -AuthID $AuthID -Confirm

# Verify it was removed
Get-PASApplicationAuthenticationMethod -AppID $AppIDName | Format-Table -AutoSize

# Remove ALL restrictions from an AppID - this one will not prompt to confirm
Get-PASApplicationAuthenticationMethod -AppID $AppIDName | ForEach-Object {
    Remove-PASApplicationAuthenticationMethod -AppID $_.AppID -AuthID $_.AuthID
}

# Verify AppID has no auth methods
Get-PASApplicationAuthenticationMethod -AppID $AppIDName | Format-Table -AutoSize
### Note: Dont leave auth methods empty in ANY prod AppID. There must be at least an IP or it will be wide open


##################################################
### Add a Safe
##################################################

# Search/check for safe (safe name defined at start of script)
Get-PASSafe -SafeName $SafeName # Should error with safe not found

# Safe details make sure there is a valid CPM Name (valid at the time of this file for DEV)
$CPMName = 'CPM_NCCP01'
$CPMName = 'CPM_ALBH03'
$SafeCreationHash = [ordered]@{
    'SafeName'                  = $SafeName.ToUpper()
    'Description'               = "Learning psPAS - $env:USERNAME"
    'ManagingCPM'               = $CPMName
    'NumberOfDaysRetention'     = 365 # This will change later
    'NumberOfVersionsRetention' = 90  # This will change later in the script
}

# Add safe using the above details
Add-PASSafe @SafeCreationHash

# Bonus - see who created a safe
(Get-PASSafe -SafeName $SafeName).creator # | Select @{N='SafeName';e={ $SafeName }}


##################################################
### Modify a Safe
##################################################
$ManagingCPM = '' # Set the CPM to NULL (storage only)
$NewSafeName = ($SafeName + '2') # used in safe rename

# Change to retention days, type and amount and no CPM
$NumberOfDaysRetention = 1
Get-PASSafe -SafeName $SafeName | Set-PASSafe -NumberOfDaysRetention $NumberOfDaysRetention -ManagingCPM $ManagingCPM
# **** NOTE: make sure this is completed so retention days is 1 day before creating an account so you don't have to wait 365 days to do cleanup of the safe

# Update description on safe
Set-PASSafe -SafeName $SafeName -NumberOfDaysRetention $NumberOfDaysRetention -ManagingCPM $ManagingCPM -Description "Learning psPAS - $env:USERNAME - Updated"

# rename a safe
Set-PASSafe -SafeName $SafeName -NumberOfDaysRetention $NumberOfDaysRetention -ManagingCPM $ManagingCPM -NewSafeName $NewSafeName

# rename it back to the original name
Set-PASSafe -SafeName $NewSafeName -NumberOfDaysRetention $NumberOfDaysRetention -ManagingCPM $ManagingCPM -NewSafeName $SafeName
Get-PASSafe -SafeName $NewSafeName # Should fail since it was named back

### extra - validate change
Get-PASSafe -SafeName $SafeName


##################################################
### Get safe membership info
##################################################

# Get safe members (including defaults)
Get-PASSafe -SafeName $SafeName | Get-PASSafeMember -includePredefinedUsers $true

# Get access details of a specific member
$MemberName = 'Administrator' # change this to the username you want to see access for
$MemberName = 'Auditors'
(Get-PASSafe -SafeName $SafeName | Get-PASSafeMember -IncludePredefinedUsers $true | Where-Object { $_.username -eq $MemberName }).Permissions


##################################################
### Add safe members permissions
##################################################

# The use you will use to add/remove permissions on the safe.
# Default is the demo user we created. If you want to use a different account change the variable accordingly
$SafeMemberForTesting = $TempDemoUser
#$SafeMemberForTesting = 'testuser1'

# Verify it exists 1st
Get-PASUser -UserName $TempDemoUser

# Add default safe members by using input XML
# Import the XML that contains the safe permissions
$XMLFile = "$PersonalFolder\AccessRights.xml" # make sure this file has been created here. See value of the variable $PersonalFolder for your working path
$SafeMemberAccessRights = Import-Clixml $XMLFile

# view contents of the $SafeMemberAccessRights variable
$SafeMemberAccessRights

# Apply default safe permissions (keep in mind the group names and that they reflect DEV, Adjust accordingly)
New-Object -TypeName psobject -Property $SafeMemberAccessRights.Administrators | Add-PASSafeMember -SafeName $SafeName -MemberName 'EPVSysAdmins'
New-Object -TypeName psobject -Property $SafeMemberAccessRights.VaultAdmins    | Add-PASSafeMember -SafeName $SafeName -MemberName 'EPV-$Environment-Vault-admin'
New-Object -TypeName psobject -Property $SafeMemberAccessRights.VaultOperators | Add-PASSafeMember -SafeName $SafeName -MemberName 'EPV-$Environment-Operators'
New-Object -TypeName psobject -Property $SafeMemberAccessRights.VaultAuditors  | Add-PASSafeMember -SafeName $SafeName -MemberName 'EPV-$Environment-Auditors'
New-Object -TypeName psobject -Property $SafeMemberAccessRights.Administrator   | Add-PASSafeMember -SafeName $SafeName -MemberName 'Administrator'

# Uncomment to add your ID (change the id at the end) if you want to be able to search in PVWA. Keep in mind logging into PVWA kills your session here
#$MyID = $env:USERNAME
#New-Object -TypeName psobject -Property $SafeMemberAccessRights.ReadOnly | Add-PASSafeMember -SafeName $SafeName -MemberName $MyID

# TIP: Run the get safe members again to validate success


# ---- Add an individual safe member

# Create an array with permissions to assign (you could just include the $true and leave out the false)
$Role = [PSCustomObject]@{
    retrieveAccounts                       = $true
    listAccounts                           = $true
    addAccounts                            = $true
    updateAccountContent                   = $false
    updateAccountProperties                = $false
    initiateCPMAccountManagementOperations = $false
    specifyNextAccountContent              = $false
    renameAccounts                         = $false
    deleteAccounts                         = $false
    unlockAccounts                         = $false
    manageSafe                             = $false
    manageSafeMembers                      = $false
    backupSafe                             = $true
    viewAuditLog                           = $true
    viewSafeMembers                        = $true
    accessWithoutConfirmation              = $false
    createFolders                          = $false
    deleteFolders                          = $false
    moveAccountsAndFolders                 = $false
    requestsAuthorizationLevel1            = $false
    requestsAuthorizationLevel2            = $false
}

# Add group you created with above permissions
$Role | Add-PASSafeMember -SafeName $SafeName -MemberName $TempDemoGroupDetails.groupName -SearchIn Vault

# This is how you would do just a user
#$Role | Add-PASSafeMember -SafeName $SafeName -MemberName $TempDemoUser -SearchIn Vault

# Add CCP Access (using the AppID you created)
$ProviderIDGroup = 'ProvGroup-xxxx-N-CCPProviders' # The name of the provider group that contains all the provider ID's
New-Object -TypeName psobject -Property $SafeMemberAccessRights.CredProvider | Add-PASSafeMember -SafeName $SafeName -MemberName $ProviderIDGroup

# Add your appid created in the beginning
New-Object -TypeName psobject -Property $SafeMemberAccessRights.AppID | Add-PASSafeMember -SafeName $SafeName -MemberName $AppIDName

# TIP: verify after add
Get-PASSafe -SafeName $SafeName | Get-PASSafeMember -includePredefinedUsers $true
(Get-PASSafe -SafeName $SafeName | Get-PASSafeMember -includePredefinedUsers $true | Where-Object {$_.username -eq $TempDemoGroupDetails.groupName}).Permissions


##################################################
### Modify members permissions
##################################################

# Set a variable with desired permissions (those different from previous add marked with 'Change')
$Role = [PSCustomObject]@{
    retrieveAccounts                       = $true
    listAccounts                           = $true
    addAccounts                            = $true
    updateAccountContent                   = $true  # Change
    updateAccountProperties                = $false
    initiateCPMAccountManagementOperations = $false
    specifyNextAccountContent              = $false
    renameAccounts                         = $false
    deleteAccounts                         = $false
    unlockAccounts                         = $true  # Change
    manageSafe                             = $false
    manageSafeMembers                      = $false
    backupSafe                             = $false
    viewAuditLog                           = $true
    viewSafeMembers                        = $true  # Change
    accessWithoutConfirmation              = $false
    createFolders                          = $false
    deleteFolders                          = $false
    moveAccountsAndFolders                 = $false
    requestsAuthorizationLevel1            = $false # Change
    requestsAuthorizationLevel2            = $true  # Change
}

# Set temp demo user group with above changed permissions
$Role | Set-PASSafeMember -SafeName $SafeName -MemberName $TempDemoGroupDetails.groupName

# OR see all permissions for temp demo user to verify they changed
(Get-PASSafe -SafeName $SafeName | Get-PASSafeMember | Where-Object {$_.username -eq $TempDemoGroupDetails.groupName}).Permissions


##################################################
### Remove test demo member(s) from safe membership
##################################################

# Reusing a variable already set
Remove-PASSafeMember -SafeName $SafeName -MemberName $TempDemoGroupDetails.groupName

# Show all safe members to verify
Get-PASSafe -SafeName $SafeName | Get-PASSafeMember


##################################################
### Duplicate a Platform
##################################################
#???

# define platform to copy Platform variables
$SourcePlatform = 'WIND-SV-N-R'

# Verify Source Platform exists
Get-PASPlatform | Where-Object {$_.PlatformID -eq $SourcePlatform} -OutVariable SourcePlatformDetails

# Duplicate a platform (will use and delete later)
$MyNewPlatform = "$SourcePlatform-$MyCustom" # use existing platform name and append $MyCustom variable name
Copy-PASPlatform -TargetPlatform-ID $SourcePlatformDetails.details.id -name $MyNewPlatform -description "psPAS learning - $MyCustom - $DateStamp"
# Note: You will need to modify the allowed safes manually, the GUI. Or use the export function, edit the exported data, then import? As well as recon later

# Verify new platform was created
Get-PASPlatform | Where-Object {$_.PlatformID -eq $MyNewPlatform} -OutVariable MyNewPlatformDetails

# Save/export new platform to ZIP. This can be done to all for backups and this can be imported by the psPAS tools or PVWA
Export-PASPlatform -PlatformID $MyNewPlatform -path $PersonalFolder

# List all safes platform can see (using platform you just created)
Get-PASPlatformSafe -PlatformID $MyNewPlatform

# TIPS (not required for other steps but handy to know)
# View new platform details
(Get-PASPlatform -PlatformID $MyNewPlatform)
(Get-PASPlatform -PlatformID $MyNewPlatform).details

# See other platform related commands
Get-Command -Module psPAS *platform*

# Returns all safes for a given platform ID (this example shows the platform just created)
#Get-PASPlatformSafe -PlatformID 'Windows-N-R-X'


##################################################
### On-board Account to safe
##################################################

# Create a Hash table with info on account to on-board
$OnboardHash = @{
    'password'   = $SecurePass
    'userName'   = $AccountUsername
    'address'    = 'dummy.address.corp'
    'safename'   = $SafeName
    'platformID' = $SourcePlatform
}

Add-PASAccount @OnboardHash

# make note of the settings
Get-PASAccount -search $AccountUsername


##################################################
### Modify on-boarded account properties
##################################################

# The following code will build a variable containing the various actions to add, remove, change and then apply in a single command

# Get the ID number for EPV for your temp demo user ID from variable created earlier
$AccountID = (Get-PASAccount -search $AccountUsername).id

# View account details before the change
(Get-PASAccount -search $AccountUsername)
(Get-PASAccount -search $AccountUsername).platformAccountProperties
(Get-PASAccount -search $AccountUsername).secretManagement

# ---- Build the variable containing changes
$actions = @() # Create an empty array variable

# properties to Add (WARNING: the platform MUST have the file categories added and platform properties add to optional if missing)
$Addprops = @{
    'Port'                = '1234'
    'UnlockUserOnReconcile' = $true
    'WF-Description'      = 'Testing psPAS apiV2'
    'UseSSL'              = $true
    'UserDN'              = 'SomeDN'
}
# Append the platform properties to add to the $actions variable
$actions += @{"op"="add";"path"="/platformAccountProperties";"value"=$Addprops}

# properties to remove (assumes they are already defined on the account)
$removeprops = @{
    'AuthenticationType' = 'RADIUS'
}
# Append the platform properties to remove to the $actions variable
$actions += @{"op"="remove";"path"="/platformAccountProperties";"value"=$removeprops}

# Append updated address to the $actions variable
$NewAccountAddress = 'NEW.address.corp'
$actions += @{"op"="replace";"path"="/Address";"value"=$NewAccountAddress}

# Append an updated platform (the one we created when duplicating)
$actions += @{"op"="replace";"path"="/platformId";"value"=$MyNewPlatform}

# ---- Apply the changes to the target account
Set-PASAccount -AccountID $AccountID -operations $actions

# verify account details changed
(Get-PASAccount -search $AccountUsername)
(Get-PASAccount -search $AccountUsername).platformAccountProperties
(Get-PASAccount -search $AccountUsername).secretManagement


##################################################
### Demo account password actions
##################################################
#???

# Set A variable to use for the "reason" of a test password pulls.
$PasswordPullReason = "psPAS-Learning-$MyCustom"

# get account password by passing the get account command to the get password cmdlet through the pipeline (this is not the CCP)
Get-PASAccount -search $AccountUsername | Get-PASAccountPassword -reason $PasswordPullReason
# note: there is a ticketing system switch for SNOW enabled platforms but that is not covered here in this demo (yet)

#??? unlock account
<#
This isn't setup yet. Need to configure a platform with exclusive access so it locks on checkout
#>
#??? Unlock-PASAccount -AccountID $AccountUsername.ID -Unlock

# get activity on account
Get-PASAccountActivity -AccountID $AccountID

# Change the password in the vault
# -- set password on vault object
$NewSecurePassword = (Read-Host -AsSecureString -Prompt ('New password for ' + "'" + $TempDemoUser + "'"))
Set-PASUserPassword -id $TempDemoUserDetails.ID -NewPassword $NewSecurePassword

# Set CPM password in Vault only (so it matches what the vault password is)
Invoke-PASCPMOperation -AccountID $AccountID -ChangeTask -NewCredentials $NewSecurePassword #(aka: CPM set password in vault only action)
#Note: $AccountID is the string ID on the on-board object created when you searched the safes for the account. That's when it was stored here.

# Schedule CPM scheduled change (so it is randomized) - NOTE: If using this you will need to wait until the CPM rotates it
Invoke-PASCPMOperation -AccountID $AccountID -ChangeTask
### Quiz: Why did it fail? try to fix it and make it work. Anything you need to be successful can be found above

# verify password rotation
Get-PASAccount -search $AccountUsername | Get-PASAccountPassword -reason $PasswordPullReason

# get activity on account again (validate new actions) - displayed in a grid like view. Actions selected will pass across pipeline when you click OK
(Get-PASAccountActivity -AccountID $AccountID) | Select-Object * | Out-GridView -PassThru


##################################################
### Pull password with CCP
##################################################

# Read IP allow list (this host only) for CCP test later

# what's this servers IP
(Test-Connection -ComputerName (hostname) -Count 1).IPV4Address.IPAddressToString | Out-String -OutVariable MyIP

# add IP to AppID
$IPList = @()
$IPList += $MyIP.Trim()
# This will add the IP from the current host
$IPList | ForEach-Object { Add-PASApplicationAuthenticationMethod -AppID $AppIDName -machineAddress $_ }

# verify only auth method is this hosts IP
Get-PASApplicationAuthenticationMethod -AppID $AppIDName | Format-Table -AutoSize

# Create CCP URI for the CCP call

# -- Target Host (uncomment the one you want to use)
#$CCPHost = 'epvccp-dev-certificate.contoso.com'
#$CCPHost = 'ZServer01.contoso.com'
$CCPHost = 'epvccp-UAT-certificate.contoso.com'

# Build the URI
$BASEURI = ($CCPHost + ':8443')
$URI = "https://$BASEURI/AIMWebService/api/Accounts?AppID=$AppIDName&UserName=$AccountUsername&AltAuth/Validate&Address=$NewAccountAddress&SafeName=$SafeName"

# verify URI looks right
$URI

# Invoke the CCP Call ("content" is the actual object)
Invoke-RestMethod -Uri $URI

<#
Note: when adding an Auth method to the CCP the effect takes effect when the cach refresh interval hits. Default time is 25 min.
      This can be expedited by resetting the CP service on the server you are connecting to.
      If using a VIP or alias you can change that target host to a physical server address to know what server you are connecting to.
      Customers should use the Alias or VIP not direct to server
#>


##################################################
### Health Check
##################################################
#???

# Create an array variable with the different components (comment out the ones you don't want included)
$ComponentID = @()
$ComponentID += 'CPM'
$ComponentID += 'PVWA'
$ComponentID += 'SessionManagement'
$ComponentID += 'AIM'

# Get a list of registered account and their status
$ComponentID | ForEach-Object { Get-PASComponentDetail -ComponentID $_ } -OutVariable PSPSData

# Display the components from previous command in a grid like view (note: dates are unix time)
$PSPSData | Out-GridView -PassThru | Select-Object ComponentUserName

# Create some custom header columns that format dates in a more readable format
$LastLogonDate = @{N='LastLogonDate';E={ (get-date '1/1/1970').addseconds($_.LastLogonDate) }} # Convert unix time to readable, local server time
$IPHostName = @{N='IPHostName';E={ If ( $_.ComponentIP -eq ''){'N/A'}Else{[System.Net.Dns]::GetHostEntry($_.ComponentIP).HostName } }} # Get host name
# Display results based on above custom fields (good one to use to determine if a re-cred is needed)
$PSPSData | Select-Object ComponentIP,ComponentUserName,ComponentVersion,IsLoggedOn,$LastLogonDate,ComponentSpecificStat | Sort-Object LastLogonDate -Descending

# Same view but in an excel like grid view
$PSPSData | Select-Object ComponentIP,$IPHostName,ComponentUserName,ComponentVersion,IsLoggedOn,$LastLogonDate,ComponentSpecificStat | Out-GridView -PassThru

# Export Health Check data to a CSV
$CSVFileName = "$PersonalFolder\HealthCheck.csv"
$PSPSData | Select-Object ComponentIP,$IPHostName,ComponentUserName,ComponentVersion,IsLoggedOn,$LastLogonDate,ComponentSpecificStat | Export-Csv $CSVFileName


##################################################
### Stop transcript recording
##################################################

# Stop transaction recording
Stop-Transcript

# Open transcript in Notepad if you want to review
Notepad $TranscriptFile


##################################################
### Cleanup
##################################################
#???
# $TempDemoUserDetails | fl *

# Remove user created in vault
Remove-PASUser -id $TempDemoUserDetails.id

# verify user deleted
Get-PASUser -UserName $TempDemoUser

# Remove safe members added (no need to do this if you are going to remove the safe)
# 'EPV-DEV-Vault-Admins'; 'EPV-DEV-Vault-Operators'; 'ProvGrp-xxxx-N-CCPProviders'; 'CCP-xxxx-N-AltCert'; 'EPV-DEV-Vault-Auditors' | % {Remove-PASSafeMember ...}

# Remove the platform you created
Remove-PASPlatform -TargetPlatform -ID $MyNewPlatformDetails.details.ID

# remove an AppID (**** WARNING **** no prompt)
Remove-PASApplication -AppID $AppIDName

# remove on-boarded Account from safe
Remove-PASAccount -AccountID $AccountID

# remove temp group
Remove-PASGroup $TempDemoGroupDetails.groupName

# Delete safe (must wait until expiration period expires)
Remove-PASSafe -SafeName $SafeName

# Use to remove your personal working folder (if not manually deleting)
Remove-Item $PersonalFolder -Confirm


##################################################
### NOTES
##################################################
<#

#>
```

## OCR notes

The 19 screenshots form one continuous PowerShell training/demo script of roughly 800 source lines. Overlapping sections between screenshots were removed during stitching.

A few values are environment-specific examples, including server names, URLs, group names, CPM names, application IDs, and certificate serial numbers. I preserved them as they appeared where the image was readable.

A small number of characters in long environment-specific strings were difficult to distinguish from the screenshots. Review those values against the original source before executing the script.
