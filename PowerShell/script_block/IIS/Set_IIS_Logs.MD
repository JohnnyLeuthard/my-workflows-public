
``` powershell

$error.clear()

$ServerName = @()
$ServerName += 'Server1'
$ServerName += 'Server2'
$ServerName += 'Server3'

$Command = @'
    $WebSites = Get-Website

    Foreach ($Website in $WebSites)
    {
        # Get IIS Log location at the server level
        $LogPathServer = (Get-WebConfigurationProperty "/system.applicationHost/sites/siteDefaults" -Name logFile.directory).value

        # Get IIS Log location at the website level
        $LogPathSite = (Get-ItemProperty -Path "IIS:\Sites\$($Website.name)" -Name logFile.directory).value

        # Get Log type
        $LogType = Get-ItemProperty -Path "IIS:\Sites\$($Website.name)" -Name logFile.logTargetW3C

        $Hash = [ordered]@{
            "$ServerName" = $env:COMPUTERNAME
            "Website"     = $Website.name
            "LogPathServer" = $LogPathServer
            "LogPathSite"   = $LogPathSite
            "LogType"       = $LogType
            "WebsitePath"   = $Website.physicalPath
            "AppPoolName"   = $Website.applicationPool
        }

        New-Object -TypeName psobject -Property $Hash
    }
'@

$ScriptBlock = [scriptblock]::Create($Command)

Invoke-Command -ComputerName $ServerName -ScriptBlock $ScriptBlock -OutVariable Temp #-Credential $CRDAll.CRDQAENT
# $Temp | ft -AutoSize

