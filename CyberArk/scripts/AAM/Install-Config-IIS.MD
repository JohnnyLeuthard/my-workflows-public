<#
Uninstall-WindowsFeature "WAS","WAS-Config-APIs","Web-Server","Web-WebServer","Web-Common-Http","Web-Static-Content","Web-Default-Doc","Web-Dir-Browsing",
    "Web-Http-Errors","Web-Http-Redirect","Web-App-Dev",
    "Web-ASP","Web-ISAPI-Ext","Web-ISAPI-Filter","Web-Health","Web-Http-Logging","Web-Request-Monitor",
    "Web-Security","Web-Basic-Auth","Web-Windows-Auth","Web-Filtering","Web-Mgmt-Tools","Web-Mgmt-Console","Web-Scripting-Tools",
    "Web-Mgmt-Compat","Web-Metabase","Web-WMI"
#>

################################
# Variables Used
################################
$inetPubFolder           = "D:\inetpub"
$baseLogFolder           = "D:\logs\ARK"
$WebsiteName             = "Default Web Site"
$WebsitePhysicalPath     = "$inetPubFolder\wwwroot"

#- Path info used to move IIS folder
$oldpath = "%SystemDrive%\inetpub"
$newpath = $inetPubFolder

#- Health check
$HealthCheckFolder = "$WebsitePhysicalPath\adcs-health"
$HealthCheckFile   = "index.html"

################################
# Install IIS
################################
$InstallApps = 'WAS','WAS-Config-APIs','Web-Server','Web-WebServer','Web-Common-Http','Web-Static-Content','Web-Default-Doc','Web-Dir-Browsing','Web-Http-Errors'
$InstallApps += 'Web-Security','Web-Basic-Auth','Web-Windows-Auth','Web-Filtering','Web-Mgmt-Tools','Web-Mgmt-Console','Web-Scripting-Tools','Web-Mgmt-Compat','Web-Metabase'
$InstallApps += 'Web-WMI','Web-ASP','Web-Asp-Net45'

Install-WindowsFeature $InstallApps

################################
# Move IIS
################################
&iisreset /stop
&robocopy c:\inetpub $newpath *.* /MOVE /S /E /COPYALL /R:1 /W:1

New-ItemProperty -Path "HKLM:\Software\Microsoft\InetStp" -Name "PathWWWRoot" -Value $newpath"\wwwroot" -PropertyType ExpandString -Force
New-ItemProperty -Path "HKLM:\System\CurrentControlSet\Services\WAS\Parameters" -Name "ConfigIsolationPath" -Value $newpath"\temp\AppPools" -PropertyType String -Force
New-ItemProperty -Path "HKLM:\Software\Wow6432Node\Microsoft\InetStp" -Name "PathWWWRoot" -Value $newpath"\wwwroot" -PropertyType ExpandString -Force

$rand = Get-Random
copy-item "C:\Windows\System32\inetsrv\config\applicationHost.config" "C:\Windows\System32\inetsrv\config\applicationHost.config.$($rand).bak"
sleep -s 5

(Get-Content "C:\Windows\System32\inetsrv\config\applicationHost.config").replace("$oldpath","$newpath") | Set-Content "C:\Windows\System32\inetsrv\config\applicationHost.config"
&C:\Windows\System32\inetsrv\appcmd set config -section:system.applicationhost/configHistory -path:$newpath\history
&iisreset /start

New-WebBinding -name "Default Web Site" -Protocol https -Port 443
Remove-WebBinding -name "Default Web Site" -Port 80 -ErrorAction SilentlyContinue

Add-WebConfigurationProperty /system.webServer/httpProtocol/customHeaders "IIS:" -Name collection -Value @{name='X-Frame-Options';value='SAMEORIGIN'}
Add-WebConfigurationProperty /system.webServer/httpProtocol/customHeaders "IIS:" -Name collection -Value @{name='Content-Security-Policy';value="default-src https: data: 'unsafe-inline' 'unsafe-eval'"}
Add-WebConfigurationProperty /system.webServer/httpProtocol/customHeaders "IIS:" -Name collection -Value @{name='Strict-Transport-Security';value='max-age=31536000; includeSubDomains'}
Add-WebConfigurationProperty /system.webServer/httpProtocol/customHeaders "IIS:" -Name collection -Value @{name='X-Content-Type-Options';value='nosniff'}
Add-WebConfigurationProperty /system.webServer/httpProtocol/customHeaders "IIS:" -Name collection -Value @{name='X-Xss-Protection';value='1; mode=block'}

Add-WebConfigurationProperty -PSPath 'MACHINE/WEBROOT/APPHOST' -name "." `
    -filter "system.applicationHost/sites/siteDefaults/logFile/customFields" `
    -value @{logFieldName='X-Forwarded-For';sourceName='X-Forwarded-For';sourceType='RequestHeader'}

if ([System.Environment]::OSVersion.Version.Major -ge "10")
{
    C:\Windows\System32\inetsrv\appcmd.exe set config /section:requestfiltering /removeServerHeader:True
}
else
{
    Add-WebConfiguration /system.webServer/rewrite/allowedServerVariables -atIndex 0 -value @{name="RESPONSE_SERVER"}
    Set-WebConfigurationProperty -pspath "IIS:" -filter "system.webServer/rewrite/outboundRules" -name "." -value @{name='Remove Server Header'}
    Set-WebConfigurationProperty -pspath "IIS:" -filter "system.webServer/rewrite/outboundRules/rule[@name='Remove Server Header']/match" -name "serverVariable" -value "RESPONSE_SERVER"
    Set-WebConfigurationProperty -pspath "IIS:" -filter "system.webServer/rewrite/outboundRules/rule[@name='Remove Server Header']/match" -name "pattern" -value ".*"
    Set-WebConfigurationProperty -pspath "IIS:" -filter "system.webServer/rewrite/outboundRules/rule[@name='Remove Server Header']/action" -name "type" -value "Rewrite"
}

C:\Windows\System32\inetsrv\appcmd.exe set config /section:requestfiltering /allowHighBitCharacters:false


################################
# Apply Splunk ACL (maybe only on log move location?)
################################

$Identity = "$($env:USERDOMAIN)\gMSA-SplunkUFS"

$Rights = ($Identity,'ReadAndExecute','ContainerInherit,ObjectInherit','None','Allow')
#$Rights = ($Identity,'FullControl','ContainerInherit,ObjectInherit','None','Allow')
#$Rights = ($Identity,'Modify','ContainerInherit,ObjectInherit','None','Allow')

$Acl = Get-Acl $newpath
$Rule = New-Object System.Security.AccessControl.FileSystemAccessRule($Rights)

$Acl.AddAccessRule($Rule)
Set-Acl -Path $newpath -AclObject $Acl
#icacls.exe "D:\inetpub" /grant "$($env:USERDOMAIN)\gMSA-SplunkUFS`$:(OI)(CI)(F)"


################################
# Move IIS Log folder
################################

#- Create log folder if missing
If (!(Test-Path $baseLogFolder)){ New-Item -Path $baseLogFolder -ItemType Directory }

# Set IIS Log location at the server level
Set-WebConfigurationProperty "/system.applicationHost/sites/siteDefaults" -name logFile.directory -value "$baseLogFolder"
# Get-WebConfigurationProperty "/system.applicationHost/sites/siteDefaults" -name logFile.directory

# Set IIS Log folder for Default Website
#Get-ItemProperty -Path "IIS:\Sites\$WebsiteName" -Name logFile.directory
Set-ItemProperty -Path "IIS:\Sites\$WebsiteName" -Name logFile.directory -Value "$baseLogFolder\$WebsiteName"


# Start IIS
&iisreset /restart | Out-Null

################################
# Set ACL to allow Splunk
################################
#- Add splunk account to read right
#$UserID = 'UserID1'

$Identity = "$($env:USERDOMAIN)\UserID1"

#$Rights = ($Identity,'FullControl','ContainerInherit,ObjectInherit','None','Allow')
#$Rights = ($Identity,'Modify','ContainerInherit,ObjectInherit','None','Allow')
$Rights = ($Identity,'ReadAndExecute','ContainerInherit,ObjectInherit','None','Allow')

#--- Set ACL on IIS folder
$Acl = Get-Acl $newpath
$Rule = New-Object System.Security.AccessControl.FileSystemAccessRule($Rights)
$Acl.AddAccessRule($Rule)
#Set-Acl -Path $newpath -AclObject $Acl

#--- Set ACL on Logs folder
$LogFolder = "D:\Logs"
$Acl = Get-Acl $LogFolder
$Rule = New-Object System.Security.AccessControl.FileSystemAccessRule($Rights)
$Acl.AddAccessRule($Rule)
Set-Acl -Path $LogFolder -AclObject $Acl

# Old method
#icacls.exe "D:\inetpub" /grant "$($env:USERDOMAIN)\gMSA-SplunkUFS`$:(OI)(CI)(F)"


################################
# AVI Health Check File
################################
If ((Test-Path "$HealthCheckFolder\$HealthCheckFile") -eq $false){New-Item "$HealthCheckFolder\$HealthCheckFile" -Force}
'This Server Is Healthy' | Out-File "$HealthCheckFolder\$HealthCheckFile" -Encoding ascii -Force


################################
# Deploy URL REWRITE (CCP Cert Auths) ###?
################################
$FilePath   = ""
$RewriteFile = ""

Start-Process $FilePath\$RewriteFile -ArgumentList "/q","/norestart" -Wait