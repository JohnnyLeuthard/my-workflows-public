# Add Required IIS Log Headers


``` powershell
Import-Module WebAdministration

$Websites = (Get-Website | Select-Object -ExpandProperty Name)

#-------------------- Custom log headers
# Get default log file headers that are selected (backup) - ###? save to a file??
$BackupDefaultLogHeaders = (Get-ItemProperty "IIS:\Sites\$Website" -Name logFile).logExtFileFlags

#-----------------------------------------------------------------------
#-------------------- Default Standard Fields
#-----------------------------------------------------------------------

$DefaultStandardLoggingFields = @()
#$DefaultStandardLoggingFields += 'Date'
$DefaultStandardLoggingFields += 'Time'
$DefaultStandardLoggingFields += 'ClientIP'
$DefaultStandardLoggingFields += 'UserName'
$DefaultStandardLoggingFields += 'SiteName'
$DefaultStandardLoggingFields += 'ComputerName'
$DefaultStandardLoggingFields += 'ServerIP'
$DefaultStandardLoggingFields += 'Method'
$DefaultStandardLoggingFields += 'UriStem'
$DefaultStandardLoggingFields += 'HttpStatus'
$DefaultStandardLoggingFields += 'BytesSent'
$DefaultStandardLoggingFields += 'BytesRecv'
$DefaultStandardLoggingFields += 'TimeTaken'
$DefaultStandardLoggingFields += 'ServerPort'
$DefaultStandardLoggingFields += 'ProtocolVersion'
$DefaultStandardLoggingFields += 'Referer'
$DefaultStandardLoggingFields += 'UserAgent'
$DefaultStandardLoggingFields += 'Cookie'
$DefaultStandardLoggingFields += 'Host'
#$DefaultStandardLoggingFields += 'UriQuery'
#$DefaultStandardLoggingFields += 'Win32Status'
#$DefaultStandardLoggingFields += 'HttpSubStatus'

#-- Convert $DefaultStandardLoggingFields array to comma seperated string
$RequiredStandardLoggingFields = $DefaultStandardLoggingFields -join ','

#-----------------------------------------------------------------------
#-------------------- Custom log headers
#-----------------------------------------------------------------------

# Custom Logging Fields  ##??
$LoggingFieldsCustom = @()
$LoggingFieldsCustom += New-Object -TypeName psobject -Property @{logFieldName='X-Forwarded-For';sourceName='X-Forwarded-For';sourceType='RequestHeader'}
$LoggingFieldsCustom += New-Object -TypeName psobject -Property @{logFieldName='Content-Type';sourceName='Content-Type';sourceType='RequestHeader'}

#-----------------------------------------------------------------------

# Remove $DefaultStandardLoggingFields from server level
##??

# Apply Custom log header values to server level
$LoggingFieldsCustom | ForEach-Object {

    # Remove all custom headers from server level
    ##??

    # Add custom headers at server level
    Add-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' `
        -filter "system.applicationHost/sites/siteDefaults/logFile/customFields" `
        -name "." `
        -value @{logFieldName=$_.logFieldName;sourceName=$_.sourceName;sourceType=$_.sourceType}
}

# Apply Custom log header to existing websites
Foreach ($ExistingWebsite in $Websites)
{
    # Apply standard log header values
    Set-ItemProperty "IIS:\Sites\$ExistingWebsite" -Name logFile -Value @{logExtFileFlags=$RequiredStandardLoggingFields}

    # Remove all current custom headers
    $CurrentCustomLogHeaders | ForEach-Object {
        Remove-WebConfigurationProperty -PSPath 'MACHINE/WEBROOT/APPHOST' `
            -filter "system.applicationHost/sites/site[@name='$ExistingWebsite']/logFile/customFields" `
            -name "." `
            -AtElement @{logFieldName=$_.logFieldName}
    }

    # Add all the required custom headers
    $LoggingFieldsCustom | ForEach-Object {
        Add-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' `
            -filter "system.applicationHost/sites/site[@name='$ExistingWebsite']/logFile/customFields" `
            -name "." `
            -value @{logFieldName=$_.logFieldName;sourceName=$_.sourceName;sourceType=$_.sourceType}
    }
}

# Move IIS log folder if it's not in right location
##??

# Reset IIS to apply settings
IISReset

