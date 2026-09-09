# CyberArk URL Test Script

``` powershell
$urls = @(
    'https://Server1.contoso.com/PasswordVault/v10/logon/cyberark/',
    'https://Server2.contoso.com/PasswordVault/v10/logon/cyberark/',
    'https://Server3.contoso.com/PasswordVault/v10/logon/cyberark/'
)

$Results = @()
foreach ($url in $urls) {
    try {
        $response = Invoke-WebRequest -Uri $url -Method GET -TimeoutSec 5 -SkipCertificateCheck
        #Write-Host "✓ SUCCESS: $url (Status: $($response.StatusCode))"
        $Success = $true
        $URL     = $url
        $Message = $($response.StatusCode)
    }
    catch {
        #Write-Host "X FAILED: $url (Error: $($_.Exception.Message))"
        $Success = $false
        $URL     = $url
        $Message = $($_.Exception.Message)
    }

    $Hash = [ordered]@{
        'Success' = $Success
        'URL'     = $url
        'Message' = $Message
    }

    New-Object -TypeName PSCustomObject -Property $Hash -OutVariable +Results
}
```
