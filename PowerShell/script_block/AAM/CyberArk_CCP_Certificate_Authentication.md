
# Powershell script to run a test of the CyberArk AIM REST API using certificate authentication. The script sets up the necessary parameters, retrieves the certificate from the local store, constructs the URI for the API call, and invokes the REST method to get account information. The results are then displayed with additional details about the request and response.


``` powershell

####################################################
### Cert Auth
####################################################

# Cert Auth test
$Error.Clear()

Remove-variable RestResult*,cert*,thumbprint,ccp*,BaseURL*,uri*,AppID*,reason,safe*,polic* -ea 0
Clear-DnsClientCache
Clear-Host

# Force TLS 1.2
#[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12

############################################################################
# Target Host
############################################################################
$AppID          = 'CCP-xxx-N-AltNone'      # Alt Auth No Restrictions
#$AppID         = 'CCP-xxx-N-AltCert'      # Alt Auth Certificate


$CCPHost = 'Server1.contoso.com'
#$CCPHost = 'Server2.contoso.com'
#$CCPHost = 'Server3.contoso.com'

############################################################################
<#

Test-Connection -ComputerName $CCPHost -Count 1 | ft *
Tracert $CCPHost

Test-NetConnection -ComputerName $CCPHost -Port $CCPPort -outvariable Results
($Results | select *)
$results.NetAdapter | fl *
$results.AllNameResolutionResults

#>
############################################################################

$CCPPort = '443'    # Uncomment to override and force port 443
#$CCPPort = '8443'  # Uncomment to override and force port 8443

# Build base URL (server and port)
$BaseURL = ($CCPHost + ':' + $CCPPort)

#$BaseURL = ($CCPHost)
#If ($CCPPort -eq '443'){ $BaseURL = $CCPHost }

############################################################################

# Thumbprint installed in local computer store (if workstation in local user store)
$Thumbprint = 'F328FC3C94B0835520BEE63957C82AD3127F64B8'          # CCPTesting  *** EXPIRED!!!! *** SN: 6B00098C9E3B94FB114002E3CE0000000098C9E
$Thumbprint = '8842149DD27B482E5A1A655DF8C92B4ADC29B0E6'          # CCPTesting2  SN: 6A000F2835FDA11303E2FEBCC0500000000F18
#$Thumbprint = '93CFEFB20A3B6893785DEA706E453592367431A9A'         # Test Cert - Force a failed not in list error

# Information to build the URI for the password retrieval
$Username     = 'AltAuthValidate'
$Address      = 'contoso.com'
$SafeName     = 'xxx-N-Domain-xx-VALIDATE'
$Reason       = 'AltAuthValidation'

# $URI        = "https://$BaseURL/AIMWebService/api/Accounts?AppID=$AppID&UserName=$UserName&Address=$Address&Reason=$Reason"


$URI = "https://$BaseURL/AIMWebService/api/Accounts?AppID=$AppID"
# Append parameters used in search
$SearchParams = ''
If ( ($UserName -ne $Null) ) { $SearchParams = $SearchParams + "&UserName=$UserName" }
If ( ($Address -ne $Null) )  { $SearchParams = $SearchParams + "&Address=$Address" }
If ( ($SafeName -ne $Null) ) { $SearchParams = $SearchParams + "&SafeName=$SafeName" }
If ( ($PolicyID -ne $Null) ) { $SearchParams = $SearchParams + "&PolicyID=$PolicyID" }   ##??
If ( ($Reason -ne $Null) )   { $Reason       = ('ReasonNotGivenBy_' + $env:USERNAME) }  ##??
# Build final URI
$URI = $URI + $SearchParams + "&Reason=$Reason"


############################################################################
If ( ($Thumbprint -ne $Null) -and ($Thumbprint -ne 'NA') )
{
    # Clear cert to prevent bleedover from previous runs
    $cert = $null

    # Set cert stor depending if it's a server or not (your workstation)
    If ( ($env:COMPUTERNAME -match "^eps-") -or ($env:COMPUTERNAME -match "^ADIS-") )
    {$CertStore = 'LocalMachine\My'}
    else
    {$CertStore = 'CurrentUser\My'}

    # Pull cert with provided thumbprint from cert store
    #$CertStore = 'LocalMachine\My'  # Uncomment to override
    #$Cert = Get-ChildItem "Cert:\$CertStore\$Thumbprint"
    $cert = Get-ChildItem ('Cert:\' + $CertStore + '\' + $Thumbprint)
}

# Used to test if spoofing will be blocked
$Header = @{
    #'REMOTE_ADDR'                     = ''
    #'CERT_SERIALNUMBER'               = '6A000F1935FDA11303E2FBBCC0500000000F1935'
    #'CERT_SERIALNUMBER'               = '6A000F1935FDA11303E2FBBCC0500000000F1935'
    #'HTTP_X_WF_CLIENTCERT_SERIALNUM'   = '6A000F1935FDA11303E2FBBCC0500000000F1935'
    'X_WF_CLIENTCERT_SERIALNUM'        = 'F11BD00C934306DAA1C24F14E1E7FAA938BC9888' # CCPTesting2
    #'HTTP_X_WF_CLIENTCERT_SERIALNUM'  = '6A00098C9E3B94FB114002E3BE0000000098C9E' # CCPTesting - Expired
}

# Splatting param (HASH) to pass to REST Call
$InvokeParams = [ordered]@{
    'URI'         = $URI
    'ContentType' = 'application/json'
    'Method'      = 'GET'
    #'Headers'    = $Header
}

if ( ($cert -ne $Null) -and ($cert -ne 'NA') -and ($AppID -eq 'CCP-xxx-N-AltCert') ){
    $InvokeParams.Add('Certificate',$cert)
}

Invoke-RestMethod @InvokeParams -OutVariable +RestResult
#Invoke-Webrequest @InvokeParams -OutVariable +RestResults
# $RestResults

# Reload variable with custom values from Rest call
$AppIDNameUsed     = @{N='AppID';Expression={ $AppID }}
#$CertUsed         = @{N='Cert';E={$cert}}
$CertUsed          = @{N='CertUsed';E={'Look at $Cert Var'}}
#$restURIUsed      = @{N='URI';E={$URI}}
$CertStoreUsed     = @{N='CertStore';E={$CertStore}}
$ThumbprintUsed    = @{N='ThumbPrint';E={$Thumbprint}}
$restURIUsed       = @{N='RestURI';E={$URI}}
$HostUsed          = @{N='HostUsed';E={ ($BaseURL).split(':')[0] }}
$Port              = @{N='Port';E={ ($BaseURL).split(':')[1] }}
$BaseURIUsed       = @{N='BaseURI';E={$BaseURI}}
$RestResults2 = $RestResults[0] | Select-Object *,$HostUsed,$Port,$CertStoreUsed,$CertUsed,$ThumbprintUsed,$AppIDNameUsed,$restURIUsed -ExcludeProperty PasswordChangeInProcess
#-OutVariable Temp

#Write-Host "===== Details =====" -ForegroundColor Red -BackgroundColor Magenta
$RestResults2


```