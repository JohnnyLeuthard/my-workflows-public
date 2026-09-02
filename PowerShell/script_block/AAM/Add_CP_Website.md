

``` powershell

####################################
# Add CCP Website
####################################

if (!(Get-Website "CCP"))
{
    If ((Test-Path 'D:\inetpub\EPVCCP') -eq $false){
        # Create CCP site dir
        New-Item -ItemType Directory -Force -Path "D:\inetpub\EPVCCP"

        # Set CCP folder permissions
        ##??
    }

    # If no app pool create it
    if (!(Get-IISAppPool "CentralCredentialProvider"))
    {
        New-WebAppPool -Name "CentralCredentialProvider" -Force
    }

    # Set app pool for CCP website
    Set-ItemProperty "IIS:\AppPools\CentralCredentialProvider" -managedRuntimeVersion v4.0

    New-Website -Name "CCP" -PhysicalPath "D:\inetpub\EPVCCP" -Port 8443 -Ssl -ApplicationPool "CentralCredentialProvider" -Force

    # Create firewall rule for Self-Service site if it isn't already there
    if (!(Get-NetFirewallRule -Name "CyberArk CCP Service"))
    {
        New-NetFirewallRule -Action "Allow" -Name "CyberArk CCP Service" -DisplayName "CyberArk CCP Service" -Direction Inbound -Protocol TCP -LocalPort 8443 -Enabled True
    }
}
else
{
    Write-Host "CCP website already created" -ForegroundColor Green
}

```


