```powershell

Import-Module WebAdministration

# Backup IIS configuration before making changes
$BackupName = "IISLoggingPolicyUpdate_{0}" -f (Get-Date -Format 'yyyyMMdd_HHmmss')
#Backup-WebConfiguration -Name $BackupName

# Get all websites
$Websites = Get-Website | Select-Object -ExpandProperty Name

# Required standard logging fields
$RequiredStandardLoggingFields = @(
    'Date'
    'Time'
    'ServerIP'
    'ComputerName'
    'Method'
    'UserName'
    'ClientIP'
    'ProtocolVersion'
    'UserAgent'
    'Cookie'
    'Referer'
    'Host'
    'BytesSent'
    'BytesRecv'
    'UriStem'
    'TimeTaken'
    'SiteName'
    'HttpStatus'
    'ServerPort'
) -join ','


# Required custom logging fields
$LoggingFieldsCustom = @(
    @{logFieldName = 'X-Forwarded-For'; sourceName = 'X-Forwarded-For'; sourceType = 'RequestHeader' },
    @{logFieldName = 'XX-Forwarded-For'; sourceName = 'XX-Forwarded-For'; sourceType = 'RequestHeader' },
    @{logFieldName = 'Content-Type'; sourceName = 'Content-Type'; sourceType = 'RequestHeader' }
)


# Preserve site-specific log directories
$SiteLogDirectories = @{}

foreach ($Website in $Websites)
{
    $WebsiteXPathName = $Website.Replace("'", "''")

    $GetDirectorySplat = @{
        PSPath = 'MACHINE/WEBROOT/APPHOST'
        Filter = "system.applicationHost/sites/site[@name='$WebsiteXPathName']/logFile"
        Name   = 'directory'
    }

    try
    {
        $Directory = (Get-WebConfigurationProperty @GetDirectorySplat).Value
        if ($Directory) {
            $SiteLogDirectories[$Website] = $Directory
        }
    }
    catch
    {
        Write-Error $_
    }
}

# Configure standard fields at siteDefaults
$SetDefaultsSplat = @{
    PSPath = 'MACHINE/WEBROOT/APPHOST'
    Filter = 'system.applicationHost/sites/siteDefaults/logFile'
    Name   = 'logExtFileFlags'
    Value  = $RequiredStandardLoggingFields
}

Set-WebConfigurationProperty @SetDefaultsSplat

# Remove existing default custom fields
$GetDefaultCustomFieldsSplat = @{
    PSPath = 'MACHINE/WEBROOT/APPHOST'
    Filter = 'system.applicationHost/sites/siteDefaults/logFile/customFields'
}

$DefaultFields = @(
    (Get-WebConfiguration @GetDefaultCustomFieldsSplat).Collection
)

for ($i = $DefaultFields.Count - 1; $i -ge 0; $i--)
{
    $RemoveCustomFieldSplat = @{
        PSPath  = 'MACHINE/WEBROOT/APPHOST'
        Filter  = 'system.applicationHost/sites/siteDefaults/logFile/customFields'
        Name    = '.'
        AtIndex = $i
    }
    Remove-WebConfigurationProperty @RemoveCustomFieldSplat
}


# Add required default custom fields
foreach ($Field in $LoggingFieldsCustom)
{
    $AddCustomFieldSplat = @{
        PSPath = 'MACHINE/WEBROOT/APPHOST'
        Filter = 'system.applicationHost/sites/siteDefaults/logFile/customFields'
        Name   = '.'
        Value  = $Field
    }

    Add-WebConfigurationProperty @AddCustomFieldSplat
}


# Remove ALL site-level logFile overrides
# This forces inheritance from siteDefaults
foreach ($Website in $Websites)
{
    $WebsiteXPathName = $Website.Replace("'", "''")

    $ClearLogFileSplat = @{
        PSPath = 'MACHINE/WEBROOT/APPHOST'
        Filter = "system.applicationHost/sites/site[@name='$WebsiteXPathName']/logFile"
    }
    try {Clear-WebConfiguration @ClearLogFileSplat}
    catch {Write-Error $_}
}


# Restore only the site-specific log directory
foreach ($Website in $SiteLogDirectories.Keys)
{
    $WebsiteXPathName = $Website.Replace("'", "''")

    $RestoreDirectorySplat = @{
        PSPath = 'MACHINE/WEBROOT/APPHOST'
        Filter = "system.applicationHost/sites/site[@name='$WebsiteXPathName']/logFile"
        Name   = 'directory'
        Value  = $SiteLogDirectories[$Website]
    }

    Set-WebConfigurationProperty @RestoreDirectorySplat
}


# Optional verification
#Get-WebConfiguration -PSPath 'MACHINE/WEBROOT/APPHOST' -Filter 'system.applicationHost/sites/siteDefaults/logFile/customFields'
```
