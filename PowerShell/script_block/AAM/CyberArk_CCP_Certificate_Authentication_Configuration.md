# ICR: CyberArk CCP Certificate Authentication IIS Configuration

## Scope

This review covers only the configuration shown in
`_DeployIISCCPCertAuth.ps1`.

The script configures the CyberArk CCP IIS site to support certificate
authentication when certificate information is forwarded by an approved
front-end proxy.

The apparent flow is:

``` text
Client Certificate
       |
       v
Front-End Proxy
       |
       | X-WF_CLIENTCERT_SERIALNUM
       v
IIS CCP Site
       |
       | URL Rewrite
       v
CERT_SERIALNUMBER
       |
       v
CyberArk CCP
```

## Reconstructed Script

``` powershell

Import-module WebAdministration

# Install URL Rewrite
$RewriteFilePath = 'C:\Temp\'
$RewriteFile = 'rewrite_amd64_en-US.msi'
$FileToInstall = "$RewriteFilePath\$RewriteFile"
Start-Porcess $FileToInstall  -ArgumentList "/q","/norestart" -wait ##??

# Add cert test code
$certTest = @'
    <h2>Client Certificate Items</h2>
    <br>
    <%
    response.write("CERT_SUBJECT=" & Request.ServerVariables("CERT_SUBJECT") & "<br>")
    response.write("CERT_SERIALNUMBER=" & Request.ServerVariables("CERT_SERIALNUMBER") & "<br>")
    response.write("CERT_ISSUER=" & Request.ServerVariables("CERT_ISSUER") & "<br>")
    response.write("CERT_FLAGS=" & Request.ServerVariables("CERT_FLAGS") & "<br>")
    response.write("CERT_KEYSIZE=" & Request.ServerVariables("CERT_KEYSIZE") & "<br>")
    response.write("CERT_SECRETKEYSIZE=" & Request.ServerVariables("CERT_SECRETKEYSIZE") & "<br>")
    %>

    <br>
    <h2>OS Auth Items</h2>
    <br>
    <%
    response.write("AUTH_TYPE=" & Request.ServerVariables("AUTH_TYPE") & "<br>")
    response.write("AUTH_USER=" & Request.ServerVariables("AUTH_USER") & "<br>")
    %>

    <br>
    <h2>LoadBalancer Variables</h2>
    <%
    response.write("HTTP_X_FORWARDED_FOR=" & Request.ServerVariables("HTTP_X_FORWARDED_FOR") & "<br>")
    response.write("HTTP_X_WF_CLIENTCERT_SERIALNUM=" & Request.ServerVariables("HTTP_X_WF_CLIENTCERT_SERIALNUM") & "<br>")
    %>

    <br>
    <h2>Other Variables</h2>
    <br>
    <%
    response.write("REMOTE_ADDR=" & Request.ServerVariables("REMOTE_ADDR") & "<br>")
    response.write("REMOTE_HOST=" & Request.ServerVariables("REMOTE_HOST") & "<br>")
    %>

    <%--
    response.write("<h2>All Variables</h2><br>")
    for each x in Request.ServerVariables
    response.write(x & "=" & Request.ServerVariables(x) & "<br>")
    next
    --%>
'@

$CerttestFilePath = ((Get-Website $Website).physicalPath + '\cert')
If (!(Test-Path $CerttestFilePath)){New-Item -Path $CerttestFilePath -ItemType Directory}
$certTest | Out-File "$CerttestFilePath\Default.aspx"


# IP's fopr VIPS
$envvars = $certAuthIPs

$certAuthIPs = ($envvars.ccpFSProxy -replace '\.','[.]') -replace ',','|'

Add-WebConfiguration /system.webServer/rewrite/allowedServerVariables -value @{name="CERT_FLAGS"}
Add-WebConfiguration /system.webServer/rewrite/allowedServerVariables -value @{name="CERT_SERIALNUMBER"}

$cmd = C:\Windows\System32\inetsrv\appcmd.exe unlock config "CCP" /section:system.webServer/security/access

Set-WebConfigurationProperty -pspath "IIS:\Sites\CCP" `
    -filter "system.webServer/security/access" `
    -name "sslFlags" `
    -value "SslNegotiateCert"

$cmd = C:\Windows\System32\inetsrv\appcmd.exe lock config "CCP" /section:system.webServer/security/access

Add-WebConfigurationProperty -pspath "IIS:\Sites\CCP" `
    -filter "system.webServer/rewrite/rules" `
    -name "." `
    -value @{name='CerificateSN'}

Set-WebConfigurationProperty -pspath "IIS:\Sites\CCP" `
    -filter "system.webServer/rewrite/rules/rule[@name='CerificateSN']/match" `
    -name "url" `
    -value "(.*)"

Add-WebConfigurationProperty -pspath "IIS:\Sites\CCP" `
    -filter "system.webServer/rewrite/rules/rule[@name='CerificateSN']/conditions" `
    -name "." `
    -value @{input='{QUERY_STRING}';pattern='(.+)'}

Add-WebConfigurationProperty -pspath "IIS:\Sites\CCP" `
    -filter "system.webServer/rewrite/rules/rule[@name='CerificateSN']/conditions" `
    -name "." `
    -value @{input='{REMOTE_ADDR}';pattern="$certAuthIPs"}

Add-WebConfigurationProperty -pspath "IIS:\Sites\CCP" `
    -filter "system.webServer/rewrite/rules/rule[@name='CerificateSN']/conditions" `
    -name "." `
    -value @{input='{HTTP_X_WF_CLIENTCERT_SERIALNUM}';pattern='.+'}

Add-WebConfigurationProperty -pspath "IIS:\Sites\CCP" `
    -filter "system.webServer/rewrite/rules/rule[@name='CerificateSN']/serverVariables" `
    -name "." `
    -value @{name='CERT_FLAGS';value='1'}

Add-WebConfigurationProperty -pspath "IIS:\Sites\CCP" `
    -filter "system.webServer/rewrite/rules/rule[@name='CerificateSN']/serverVariables" `
    -name "." `
    -value @{name='CERT_SERIALNUMBER';value='{HTTP_X_WF_CLIENTCERT_SERIALNUM}'}

############################################
### NOTES
############################################
<#

F5 IP's
$certAuthIPs = '162[.]28[.]75[.]252|162[.]28[.]75[.]253|162[.]28[.]75[.]254|162[.]28[.]35[.]252|162[.]28[.]35[.]253|162[.]28[.]35[.]254'

Need other IP's - examples (AVI lisy)


#>


```

The screenshot also contains a commented example of `$certAuthIPs`
containing six IP addresses expressed as regex-safe values.

## What the Script Does

### 1. Builds the Trusted Proxy List

``` powershell
$envvars = $certAuthIPs

$certAuthIPs = ($envvars.ccpFSProxy -replace '\.','[.]') -replace ',','|'
```

The script takes the `ccpFSProxy` value and converts a comma-separated
IP list into a regular-expression pattern.

For example:

``` text
10.10.1.10,10.10.1.11
```

becomes:

``` text
10[.]10[.]1[.]10|10[.]10[.]1[.]11
```

This pattern is later compared against IIS `REMOTE_ADDR`.

### 2. Allows Certificate Server Variables

The script allows IIS URL Rewrite to modify:

``` text
CERT_FLAGS
CERT_SERIALNUMBER
```

using:

``` powershell
Add-WebConfiguration /system.webServer/rewrite/allowedServerVariables -value @{name="CERT_FLAGS"}
Add-WebConfiguration /system.webServer/rewrite/allowedServerVariables -value @{name="CERT_SERIALNUMBER"}
```

This is required because the rewrite rule later populates these server
variables.

### 3. Configures the CCP Site for Certificate Negotiation

The script temporarily unlocks the IIS security/access section:

``` powershell
appcmd.exe unlock config "CCP" /section:system.webServer/security/access
```

It then sets:

``` powershell
sslFlags = "SslNegotiateCert"
```

and locks the configuration section again.

This configures the CCP IIS site to negotiate client certificates.

### 4. Creates the Certificate Serial Number Rewrite Rule

The script creates a URL Rewrite rule named:

``` text
CerificateSN
```

The rule matches:

``` text
(.*)
```

so it can process requests reaching the CCP site.

### 5. Checks the Query String

The first condition is:

``` powershell
@{input='{QUERY_STRING}';pattern='(.+)'}
```

This requires the request to contain a non-empty query string before the
rule proceeds.

### 6. Validates the Request Source

The next condition evaluates:

``` text
REMOTE_ADDR
```

against:

``` text
$certAuthIPs
```

This restricts the rewrite behavior to requests originating from an
approved proxy address.

### 7. Checks for the Forwarded Certificate Serial Number

The rule checks:

``` text
HTTP_X_WF_CLIENTCERT_SERIALNUM
```

using:

``` text
.+
```

The condition therefore requires the forwarded certificate serial-number
header to contain a value.

### 8. Creates the Certificate Variables Used by CCP

When all conditions match, the rule sets:

``` text
CERT_FLAGS = 1
```

and:

``` text
CERT_SERIALNUMBER = HTTP_X_WF_CLIENTCERT_SERIALNUM
```

The resulting transformation is:

``` text
X-WF_CLIENTCERT_SERIALNUM
          |
          v
HTTP_X_WF_CLIENTCERT_SERIALNUM
          |
          v
CERT_SERIALNUMBER
```

This appears to provide CCP with certificate information derived from
the front-end proxy request.

# ICR Findings

## ICR-01: `$envvars` Initialization Requires Verification

Severity: High

The screenshot shows:

``` powershell
$envvars = $certAuthIPs
```

followed by:

``` powershell
$envvars.ccpFSProxy
```

This requires `$certAuthIPs` to already contain an object exposing a
`ccpFSProxy` property.

Verify how `$certAuthIPs` is populated before this script runs.

The variable names make the data flow difficult to understand and create
a risk of incorrect configuration.

## ICR-02: Forwarded Certificate Header Is a Critical Trust Boundary

Severity: High

The script ultimately performs:

``` text
CERT_SERIALNUMBER = HTTP_X_WF_CLIENTCERT_SERIALNUM
```

This means the value supplied in the forwarded HTTP header becomes
certificate identity information consumed by the CCP path.

The upstream proxy must control this header.

The proxy should:

-   Remove any `X-WF_CLIENTCERT_SERIALNUM` supplied by the original
    client.
-   Populate the header from the authenticated client certificate.
-   Forward the request only after the required certificate validation
    succeeds.
-   Prevent untrusted clients from directly controlling the resulting
    header value.

## ICR-03: Trusted Proxy Regex Should Use Exact Matching

Severity: Medium

The generated pattern resembles:

``` text
10[.]10[.]1[.]10|10[.]10[.]1[.]11
```

The expression does not visibly contain start and end anchors.

A safer pattern would be:

``` text
^(?:10[.]10[.]1[.]10|10[.]10[.]1[.]11)$
```

This forces `REMOTE_ADDR` to equal one of the approved addresses instead
of matching the approved address as part of another string.

Using `[regex]::Escape()` for each address would also make the intent
clearer.

## ICR-04: Query String Condition Requires Verification

Severity: Medium

The rule requires:

``` powershell
{QUERY_STRING} = (.+)
```

A request with an empty query string will fail this condition.

As a result, the rule will not set:

``` text
CERT_FLAGS
CERT_SERIALNUMBER
```

for such a request.

Verify whether every CCP request using this certificate-authentication
method contains a query string. If this condition exists for a specific
CyberArk request format, document the reason.

## ICR-05: Rewrite Rule Name Appears Misspelled

Severity: Low

The rule appears to be named:

``` text
CerificateSN
```

rather than:

``` text
CertificateSN
```

The script references the same spelling throughout, so the typo does not
inherently stop the rule from working.

Correcting the name would improve readability if nothing external
depends on the current rule name.

## ICR-06: `appcmd.exe` Results Are Not Validated

Severity: Medium

The script stores the output from the unlock and lock commands:

``` powershell
$cmd = C:\Windows\System32\inetsrv\appcmd.exe ...
```

but does not visibly validate whether the command succeeded.

Check `$LASTEXITCODE` after each `appcmd.exe` operation and stop
execution when the operation fails.

## ICR-07: Configuration Could Remain Unlocked After Failure

Severity: Medium

The sequence is:

``` text
Unlock security/access
Set sslFlags
Lock security/access
```

If the configuration command fails between the unlock and lock
operations, the section could remain unlocked.

A `try/finally` structure would make the relock operation more reliable.

## ICR-08: Script Re-execution Could Create Duplicate Configuration

Severity: Medium

The script uses multiple:

``` powershell
Add-WebConfiguration
Add-WebConfigurationProperty
```

operations.

There are no visible checks for existing:

``` text
CERT_FLAGS
CERT_SERIALNUMBER
CerificateSN
rewrite conditions
server variables
```

Running the script more than once could generate duplicate entries or
errors depending on the existing IIS configuration.

The deployment should either test for each object before adding it or
explicitly manage the desired final state.

# Security Trust Model

The configuration creates the following trust chain:

``` text
Client
  |
  | Client certificate
  v
Trusted Front-End Proxy
  |
  | Validate certificate
  | Control X-WF_CLIENTCERT_SERIALNUM
  v
IIS CCP Site
  |
  | REMOTE_ADDR matches trusted proxy
  | Certificate serial header exists
  v
URL Rewrite
  |
  | CERT_FLAGS = 1
  | CERT_SERIALNUMBER = forwarded serial
  v
CyberArk CCP
```

The critical control is the relationship between:

``` text
REMOTE_ADDR
```

and:

``` text
X-WF_CLIENTCERT_SERIALNUM
```

IIS trusts the certificate serial number only when the request matches
the configured proxy-address condition.

# Recommended Validation Tests

## Test 1: Approved Proxy With Certificate

Send a valid CCP request through an approved proxy with a valid client
certificate.

Expected result:

``` text
REMOTE_ADDR matches $certAuthIPs.
X-WF_CLIENTCERT_SERIALNUM contains the expected serial number.
CERT_FLAGS becomes 1.
CERT_SERIALNUMBER contains the forwarded serial number.
CCP certificate authentication succeeds.
```

## Test 2: Approved Proxy Without Certificate Header

Send the request through an approved proxy without:

``` text
X-WF_CLIENTCERT_SERIALNUM
```

Expected result:

``` text
The rewrite condition fails.
CERT_SERIALNUMBER is not populated by the rule.
Certificate authentication does not succeed through this mechanism.
```

## Test 3: Unapproved Source With Forged Header

Send a request from an address outside `$certAuthIPs` while manually
supplying:

``` text
X-WF_CLIENTCERT_SERIALNUM
```

Expected result:

``` text
REMOTE_ADDR does not match.
The rewrite rule does not promote the supplied value into CERT_SERIALNUMBER.
```

## Test 4: Header Injection Through the Proxy

Send a client-created:

``` text
X-WF_CLIENTCERT_SERIALNUM
```

through the normal proxy path.

Expected result:

``` text
The front-end proxy removes or overwrites the client-supplied value.
The header reaching IIS contains only certificate information generated by the trusted proxy.
```

## Test 5: Request Without Query String

Send an otherwise valid certificate-authentication request without a
query string.

Expected result:

``` text
The observed behavior matches the intended CyberArk CCP request design.
```

This test determines whether the `{QUERY_STRING}` condition is required.

## Test 6: Re-run the Script

Execute the script against a system where the configuration already
exists.

Expected result:

``` text
No duplicate rules.
No duplicate allowed server variables.
No duplicate conditions.
No deployment failure.
The final configuration remains consistent.
```










