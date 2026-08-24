# CyberArk CCP User Authentication Configuration

## Scope


The script configures IIS authentication for the CyberArk CCP site and
its `AIMWebService` application. It also configures the IIS application
virtual directories to run with a service account.

## Reconstructed PowerShell

``` powershell
##### OS Auth configure
Import-Module WebAdministration

$iisSiteName = "CCP"
$iisAppName = "AIMWebService"

# Auth providers list
$AuthMethods = @()
$AuthMethods += 'AnonymousAuthentication'
#$AuthMethods += 'FormsAuthentication'
$AuthMethods += 'BasicAuthentication'
$AuthMethods += 'windowsAuthentication'
#$AuthMethods += 'APSNetImpersonation'

# Get service account as username and password
$CredFile = "$env:USERPROFILE\Creds.xml"
$ServiceAccountCredsName = 'Contoso.com\SvsAcct1'
# $ServiceAccountCreds = Get-Credential -Message 'Enter service account creds' -UserName $ServiceAccountCredsName
# $ServiceAccountCreds | Export-Clixml $CredFile
$ServiceAccountCreds = Import-Clixml -Path $CredFile
#$ServiceAccountCreds.GetNetworkCredential().password | Set-Clipboard

# Set auth providers Run As on CCP site
$AuthMethods | % {
    If ($_ -eq "AnonymousAuthentication"){$EnableValue = $true}Else{$EnableValue = $false}
    #"auth method: $_ is $EnableValue"
    Set-WebConfigurationProperty -Filter "/system.webServer/security/authentication/$_" -Name 'enabled' -Value $EnableValue -PSPath 'IIS:\' -Location "$iisSiteName"
}

# Set auth providers Run As on AIMWebService webapp
$AuthMethods | % {
    If ($_ -eq "WindowsAuthentication"){$EnableValue = $true}Else{$EnableValue = $false}
    #"auth method: $_ is $EnableValue"
    Set-WebConfigurationProperty -Filter "/system.webServer/security/authentication/$_" -Name 'enabled' -Value $EnableValue -PSPath 'IIS:\' -Location "$iisSiteName/$iisAppName"
}

#Remove all providers
#Remove-WebConfigurationProperty -Filter 'system.webServer/security/authentication/WindowsAuthentication' -Location "$iisSiteName/$iisAppName" -Name providers.Collection -AtElement @{Value="NTLM"}
#Remove-WebConfigurationProperty -Filter 'system.webServer/security/authentication/WindowsAuthentication' -Location "$iisSiteName/$iisAppName" -Name providers.Collection -AtElement @{Value="Negotiate"}

Get-WebConfigurationProperty -Filter system.webServer/security/authentication/WindowsAuthentication `
    -Location "$iisSiteName/$iisAppName" `
    -Name providers.Collection |
        Select-Object -ExpandProperty Value |
        ForEach-Object
        {
            Remove-WebConfigurationProperty -Filter system.webServer/security/authentication/WindowsAuthentication `
                -Location "$iisSiteName/$iisAppName" `
                -Name providers.Collection `
                -AtElement @{Value="$_"}
        }

# Set AIMWebService Providers to 'Negotiate:Kerberos'
$ProviderType = 'Negotiate:Kerberos'
Add-WebConfiguration -Filter system.webServer/security/authentication/windowsAuthentication/providers -PSPath IIS:\ -Location "$iisSiteName/$iisAppName" -Value $ProviderType

# Disable require SSL and ignore certificates
Set-WebConfigurationProperty -location "$iisSiteName/$iisAppName" -filter "system.webServer/security/access" -name "sslFlags" -Value $false
Set-WebConfigurationProperty -location "$iisSiteName" -filter "system.webServer/security/access" -name "sslFlags" -Value $false

$webSites = Get-Website 'CCP'
ForEach($webSite in $webSites)
{
    $siteName = ($webSite | Select-Property "Name").name
    $fullPath = "system.applicationHost/sites/site[@name='$siteName']/application[@path='/']/virtualDirectory[@path='/']"
    #$fullPath
    Set-WebConfigurationProperty $fullPath -Name "username" -Value $ServiceAccountCredsName.username
    Set-WebConfigurationProperty $fullPath -Name "password" -Value $ServiceAccountCredsName.GetNetworkCredential().password
}

# Set AimWebService, Authentication Windows Authentication, Extended
####################################


####################################
### NOTES
####################################
<#

#>
```

## What the Script Does

### 1. Loads IIS Administration Support

``` powershell
Import-Module WebAdministration
```

This provides the PowerShell cmdlets and `IIS:\` provider used
throughout the script.

### 2. Defines the CyberArk IIS Targets

``` powershell
$iisSiteName = "CCP"
$iisAppName = "AIMWebService"
```

The configuration targets:

``` text
CCP
└── AIMWebService
```

### 3. Defines Authentication Methods

The active authentication list is:

``` text
AnonymousAuthentication
BasicAuthentication
WindowsAuthentication
```

The script later handles the CCP site and `AIMWebService` differently.

### 4. Loads the Service Account Credential

The script references:

``` text
%USERPROFILE%\Creds.xml
```

and imports the credential with:

``` powershell
Import-Clixml
```

The screenshot also contains commented commands for interactively
collecting the credential and exporting it to the XML file.

### 5. Configures Authentication on the CCP Site

For the parent `CCP` site, the loop enables Anonymous Authentication and
disables the other authentication methods included in `$AuthMethods`.

Resulting intent:

``` text
CCP
├── Anonymous Authentication: Enabled
├── Basic Authentication: Disabled
└── Windows Authentication: Disabled
```

### 6. Configures Authentication on AIMWebService

For `CCP/AIMWebService`, the second loop enables Windows Authentication
and disables the other methods in `$AuthMethods`.

Resulting intent:

``` text
CCP/AIMWebService
├── Anonymous Authentication: Disabled
├── Basic Authentication: Disabled
└── Windows Authentication: Enabled
```

This separates the authentication behavior of the parent CCP site from
the `AIMWebService` application.

### 7. Removes Existing Windows Authentication Providers

The script retrieves every configured Windows Authentication provider
for `AIMWebService`:

``` powershell
Get-WebConfigurationProperty ...
```

It then loops through the returned values and removes each provider.

This clears the existing provider list before the desired provider is
added.

### 8. Configures Kerberos

The desired provider is:

``` powershell
$ProviderType = 'Negotiate:Kerberos'
```

It is added to the Windows Authentication provider list for:

``` text
CCP/AIMWebService
```

The intent is to force the application toward Kerberos-based Windows
Authentication rather than leaving the default IIS provider set in
place.

### 9. Changes SSL Flags

The script sets `sslFlags` to `$false` at both:

``` text
CCP
CCP/AIMWebService
```

The source comment describes this as:

``` text
Disable require SSL and ignore certificates
```

This deserves specific validation because `sslFlags` controls IIS
SSL/client-certificate behavior.

### 10. Configures the IIS Virtual Directory Identity

The script retrieves the `CCP` website and constructs the root
virtual-directory configuration path.

It then attempts to assign a username and password to the root virtual
directory.

The apparent goal is for the CCP content path to access resources using
the supplied service account credentials.

# ICR Findings

## ICR-01: Credential Variable Usage Appears Inconsistent

Severity: High

The script defines:

``` powershell
$ServiceAccountCredsName = 'Contoso.com\SvcAcct01T-CCPAUTH'
```

which appears to be a string.

It separately imports:

``` powershell
$ServiceAccountCreds = Import-Clixml -Path $CredFile
```

which should contain the `PSCredential`.

Later, the script appears to use:

``` powershell
$ServiceAccountCredsName.username
$ServiceAccountCredsName.GetNetworkCredential().password
```

If the screenshot has been transcribed correctly, this is inconsistent.

The credential object would normally be the variable exposing properties
or methods such as:

``` powershell
$ServiceAccountCreds.UserName
$ServiceAccountCreds.GetNetworkCredential().Password
```

Verify these two lines against the source script before execution.

## ICR-02: Authentication Method Names Should Be Validated

Severity: Medium

The array includes:

``` text
AnonymousAuthentication
BasicAuthentication
windowsAuthentication
```

The script dynamically inserts each value into the IIS configuration
filter.

Verify the exact IIS section names and casing used in the deployed
Windows/IIS version.

The commented entry:

``` text
APSNetImpersonation
```

also appears unusual and could be a typo for an ASP.NET
impersonation-related setting.

## ICR-03: Parent and Child Authentication Settings Are Intentionally Different

Severity: Informational

The script appears designed to produce:

``` text
CCP Site
    Anonymous = Enabled
    Windows   = Disabled

AIMWebService
    Anonymous = Disabled
    Windows   = Enabled
```

This distinction is important.

Any future cleanup or consolidation of the script should preserve the
separate authentication behavior unless the CyberArk design changes.

## ICR-04: Existing Windows Authentication Providers Are Completely Removed

Severity: Medium

The script enumerates and removes every existing Windows Authentication
provider before adding:

``` text
Negotiate:Kerberos
```

This is more deterministic than removing only `NTLM` and `Negotiate`,
but it also removes any other provider already configured.

Confirm `Negotiate:Kerberos` should be the only provider for this
application.

## ICR-05: Kerberos Configuration Requires Supporting Identity Configuration

Severity: High

Setting:

``` text
Negotiate:Kerberos
```

in IIS does not independently establish a working Kerberos
authentication path.

The surrounding environment must have the correct service identity, SPN
configuration, DNS/name usage, and IIS Windows Authentication settings
required by the CyberArk deployment.

Validate the full Kerberos path before production use.

## ICR-06: `sslFlags = $false` Requires Verification

Severity: High

The script sets:

``` powershell
sslFlags = $false
```

for both the CCP site and `AIMWebService`.

The source comment says:

``` text
Disable require SSL and ignore certificates
```

Because this changes IIS transport/client-certificate requirements,
confirm the setting is intentional for this specific CyberArk
authentication design.

Do not treat the source comment alone as sufficient documentation of the
resulting IIS behavior.

## ICR-07: Credential File Protection Is Important

Severity: High

The script imports a credential from:

``` text
$env:USERPROFILE\Creds.xml
```

PowerShell CLIXML credential protection is tied to its Windows
protection context.

The deployment should verify:

``` text
Who created the file
Which account executes the script
Who can read the file
Whether the credential can be decrypted under the execution context
How the file is created, rotated, and removed
```

The commented clipboard command should remain disabled:

``` powershell
#$ServiceAccountCreds.GetNetworkCredential().password | Set-Clipboard
```

Copying a service-account password to the clipboard creates unnecessary
credential exposure.

## ICR-08: Script Does Not Show Error Handling

Severity: Medium

The visible script does not check whether:

``` text
Creds.xml exists
Credential import succeeds
CCP site exists
AIMWebService exists
Authentication configuration changes succeed
Provider removal succeeds
Kerberos provider creation succeeds
Virtual-directory credential assignment succeeds
```

A failure midway through execution could leave IIS partially configured.

## ICR-09: Re-Execution Behavior Should Be Tested

Severity: Medium

The script removes the existing Windows Authentication providers before
adding `Negotiate:Kerberos`, which helps make that portion repeatable.

Other configuration operations should still be tested through multiple
executions to confirm the final IIS state remains consistent.

# Expected Authentication State

Based on the visible script, the intended end state appears to be:

``` text
CCP
│
├── Anonymous Authentication
│   └── Enabled
│
├── Basic Authentication
│   └── Disabled
│
├── Windows Authentication
│   └── Disabled
│
└── AIMWebService
    │
    ├── Anonymous Authentication
    │   └── Disabled
    │
    ├── Basic Authentication
    │   └── Disabled
    │
    ├── Windows Authentication
    │   └── Enabled
    │
    └── Provider
        └── Negotiate:Kerberos
```

# Recommended Validation

1.  Verify the service-account credential variable used for the
    virtual-directory username and password.
2.  Confirm the expected authentication state in IIS Manager after
    execution.
3.  Confirm `Negotiate:Kerberos` is the only Windows Authentication
    provider on `AIMWebService`.
4.  Verify the required SPN configuration for the service identity.
5.  Confirm Kerberos is used during an actual authentication request
    rather than an unexpected fallback mechanism.
6.  Verify the purpose and effect of setting `sslFlags` to `$false`.
7.  Confirm `Creds.xml` can only be decrypted by the intended execution
    identity and is protected by appropriate filesystem permissions.
8.  Execute the script twice in a test environment and compare the
    resulting IIS configuration.
9.  Test a successful CyberArk CCP OS-authentication request end to end.
10. Test failed authentication with invalid or unauthorized credentials
    and confirm access is denied.

# ICR Disposition

Status: REVIEW REQUIRED

The script establishes a clear split between anonymous access at the CCP
site and Windows Authentication for `AIMWebService`, then restricts the
Windows Authentication provider to `Negotiate:Kerberos`.

The highest-priority items to verify are the service-account credential
variable usage, the Kerberos identity/SPN configuration, and the
intended effect of the `sslFlags` changes.
