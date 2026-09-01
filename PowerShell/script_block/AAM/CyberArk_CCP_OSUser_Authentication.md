
# OS User Auth

``` powershell

Remove-Variable rest*,results*,InvokePa*,base*,ccp*,ur*,BaseURL*
Clear-DnsClientCache
Clear-Host

# Force TLS 1.2
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12


######################################################################
# Target Host
######################################################################
$AppID = 'CCP-xxx-N-AltOS'

#----------------------------------

$CCPHost = 'Server1.contoso.com'
######################################################################
<#
Test-Connection -ComputerName $CCPHost -Count 1 | ft *
Tracert $CCPHost

Test-NetConnection -ComputerName $CCPHost -Port $CCPPort -OutVariable Results
($Results | select *)
$results.NetAdapter | fl *
$results.AllNameResolutionResults
#>
######################################################################
# Set destination Port
If ( ($CCPHost -match 'CNAME') ){$CCPPort = '8443'}
ElseIf ( ($CCPHost -match 'gslb') -or ($CCPHost -match 'epvccp-') ){$CCPPort = '443'}
Else {$CCPPort = '8443'}

# Use these to force a port
$CCPPort = '443'   # Uncomment to override and force port 8443
$CCPPort = '8443'  # Uncomment to override and force port 8443

# Build base URL (server and port)
$BaseURL = $CCPHost
$BaseURL = ($CCPHost + ':' + $CCPPort)

#$BaseURL = ($CCPHost)
#If ($CCPPort -eq '443'){ $BaseURL = $CCPHost }

######################################################################


# CCP target account details
$AppID      = 'CCP-xxx-N-AltOS'        # Alt Auth OS User
$UserName   = 'AltAuthValidate'
$Address    = 'contoso.com'
$SafeName   = 'xxx-N-Windows-VALIDATE'
$Reason     = 'AltAuthUser'


# URI
$URI = "https://$BaseURL/AIMWebService/api/Accounts?AppID=$AppID&UserName=$UserName&Address=$Address&Reason=$Reason"


# parameters passd to the Invoke-Restmethod PowerShell cmdlet
$InvokeParams = [ordered]@{
    'URI'                   = $URI
    'ContentType'           = 'application/json'
    'Method'                = 'Get'
    'UseDefaultCredentials' = $true
}


# Initiate connection
Invoke-RestMethod @InvokeParams -OutVariable +RestResults

#$RestResults = $RestResults | select *,@{Name='AppID';E={ $AppID}},@{N='BaseURI';E={$BaseURL}}
$RestResults


#<#
# Reload variable with custom values from Rest call
$AppIDNameUsed = @{N='AppID';E={ $AppID}}
$RestURIUsed   = @{N='RestURI';E={$URI}}
$BaseURIUsed   = @{N='BaseURI';E={$BaseURL}}
$HostUsed      = @{N='HostUsed';E={ ($BaseURL).split(':')[0] }}
$Port          = @{N='Port';E={ ($BaseURL).split(':')[1] }}
$RestResults2  = $RestResults[0] | Select-Object *,$BaseURIUsed,$HostUsed,$Port,$AppIDNameUsed,$restURIUsed #-OutVariable Temp

########################

Write-Host "===== Details =====" -ForegroundColor Red -BackgroundColor Magenta
$RestResults2
#>

```

