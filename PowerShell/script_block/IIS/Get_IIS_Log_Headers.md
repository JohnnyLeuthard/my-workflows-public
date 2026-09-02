
``` powershell

Import-Module WebAdministration

Get-Website | ForEach-Object {

    $WebConfigurationHash = @{
        PSPath = 'MACHINE/WEBROOT/APPHOST'
        Filter = "system.applicationHost/sites/site[@name='$($_.Name)']/logFile/customFields"
    }

    $SiteCustomFields = (Get-WebConfiguration @WebConfigurationHash).Collection

    [PSCustomObject]@{
        ServerName          = $env:COMPUTERNAME
        Website             = $_.Name
        LogPathSite         = (Get-ItemProperty "IIS:\Sites\$($_.Name)" -Name logFile.directory).Value
        StandardFieldsSite  = (Get-ItemProperty "IIS:\Sites\$($_.Name)" -Name logFile).logExtFileFlags
        CustomFieldsSite    = ($SiteCustomFields | ForEach-Object { $_.Attributes['logFieldName'].Value }) -join ';'
    }
}


#$ServerDefaults = Get-WebConfiguration -PSPath 'MACHINE/WEBROOT/APPHOST' -Filter 'system.applicationHost/sites/siteDefaults/logFile/customFields'
#$ServerCustomFields = (($ServerDefaults.Collection | ForEach-Object { $_.Attributes['logFieldName'].Value }) -join ';'
#$ServerCustomFields

```

