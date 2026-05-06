# Reference: Troubleshooting — CyberArk Flow & SIA

Common failure patterns, their causes, and how to resolve them. Organized by the phase where the failure occurs.

---

## Connector Registration Failures

### Symptom: Registration command times out or hangs

**Most likely cause:** Outbound port 443 is blocked to CyberArk cloud, or an SSL-inspecting proxy is breaking the connection.

**Diagnosis:**
```powershell
# Test basic connectivity
Test-NetConnection -ComputerName connector.cyberark.cloud -Port 443

# Test HTTPS (will reveal proxy/cert issues that TCP test won't)
Invoke-WebRequest -Uri https://connector.cyberark.cloud -UseBasicParsing
```

**Resolution:**
- If `Test-NetConnection` fails: Work with network team to open port 443 outbound to `*.cyberark.cloud`
- If `Test-NetConnection` succeeds but `Invoke-WebRequest` gives a certificate error: SSL inspection is breaking the connection. Bypass SSL inspection for `*.cyberark.cloud` at the proxy, or import the proxy's root CA into the connector server's Windows Trusted Root Certificate Store.

---

### Symptom: Registration fails with "401 Unauthorized" or "Invalid token"

**Most likely cause:** The registration token expired (tokens expire 60 minutes after generation).

**Resolution:**
1. Log into the ISP portal
2. Navigate to Infrastructure → Connectors → Add Connector
3. Generate a **new** registration token
4. Immediately run the registration step — do not wait
5. Confirm the connector server's time is synchronized (clock drift > 5 min will cause token validation failures)

---

### Symptom: Connector installs but never shows as "Connected" in the ISP portal

**Check in this order:**

1. **Connector service status**: `Get-Service -Name "CyberArkConnector"` — should be Running
2. **Connector log**: `C:\Program Files\CyberArk\Connector\Logs\connector.log` — look for the last error
3. **WebSocket connectivity**: Standard HTTPS tests may pass even when WebSocket is blocked. Ask your network team to confirm WebSocket (WSS) is allowed on the path to `*.cyberark.cloud`
4. **Proxy authentication**: If your proxy requires authentication, the connector service account may not have credentials to authenticate to the proxy. Configure the proxy settings in the connector's config file or use a proxy bypass.

---

## Vault Connectivity Failures

### Symptom: Vault connection shows "Failed" in the ISP portal

**Diagnosis in connector log:**
```
Vault connection failed: <error>
```

**Common errors and resolutions:**

| Error | Cause | Resolution |
|---|---|---|
| `Connection timed out to <VaultIP>:1858` | Firewall blocking port 1858 | Open TCP 1858 from connector to vault |
| `Authentication failed for user CyberArkConnectorSvc` | Wrong password or account locked | Reset password in PrivateArk, update in ISP portal |
| `User is not authorized` | Vault user lacks required permissions | Grant Use/List/Retrieve on target safes |
| `SSL certificate error` | Vault certificate issue | Verify vault certificate is valid; check if vault root CA needs to be imported to connector |
| `Vault is not responding` | Vault service down | Check vault health in PVWA → Administration → System Health |

---

### Symptom: PVWA API connection fails

**Check:**
1. PVWA URL is correct (include `https://` and no trailing slash)
2. PVWA REST API is enabled: PVWA → Administration → Options → General → Allow REST API
3. The PVWA API user (`CyberArkConnectorSvc` or your designated user) is not locked out — check in PrivateArk Client
4. PVWA server certificate is trusted by the connector server — if self-signed, import the cert to Windows Trusted Root store on the connector

---

## Session Launch Failures

### Symptom: User clicks Connect in SIA but session never opens

**Step 1 — Check the ISP session log:**
ISP portal → Secure Infrastructure Access → Session History → find the failed session → view error

**Common errors:**

| Error | Cause | Resolution |
|---|---|---|
| `Connector unreachable` | Connector service is down | Restart CyberArk Connector service; check connector log |
| `Account not found in safe` | The target account doesn't exist or the connector user can't see it | Verify the safe/account in PVWA; confirm connector user has List permission |
| `Account is locked` | Another session has the account checked out exclusively | Wait for release, or configure account for concurrent use |
| `PSM connection failed` | PSM service is down or unreachable from connector | Check PSM service health; verify connector can reach PSM on port 3389/22 |
| `Target unreachable` | Target machine is down or firewall blocking the connector | Test connectivity from connector to target: `Test-NetConnection -ComputerName <TargetIP> -Port 3389` |
| `MFA not satisfied` | User's MFA is not enrolled or expired | User needs to re-enroll MFA in the ISP identity portal |

---

### Symptom: Session opens but immediately disconnects

**Possible causes:**
- Target machine's RDP or SSH service is overloaded or misconfigured
- Credentials retrieved from vault are incorrect (password not in sync) — trigger a CPM password verify/change
- PSM session limit reached — check PSM capacity in PVWA → Administration → System Health
- Network path between PSM and target is unstable — check PSM → target connectivity

---

## Flow Integration Failures

### Symptom: Flow workflow completes but vault action doesn't execute

**Check:**
1. Flow connector profile is connected (Flow → Connectors → status)
2. The vault account referenced in the workflow exists and is accessible by the connector service account
3. The workflow step has the correct safe name and account name — these are case-sensitive in the CyberArk API
4. Check the Flow execution log for the specific step error: Flow → Workflows → Execution History

### Symptom: Flow approval workflow doesn't trigger SIA access elevation

**Check:**
1. The SIA policy referenced in the Flow workflow is active
2. The user receiving the elevated access is in the directory that the ISP tenant recognizes
3. The connector referenced in the SIA policy is the same connector profile used in Flow

---

## Log File Locations

| Component | Log Location |
|---|---|
| CyberArk Connector | `C:\Program Files\CyberArk\Connector\Logs\connector.log` |
| PVWA | `C:\inetpub\wwwroot\PasswordVault\Logs\` |
| PSM | `C:\Program Files (x86)\CyberArk\PSM\Logs\` |
| Vault | On vault server: `C:\Program Files (x86)\PrivateArk\Server\Logs\` |
| ISP Audit | ISP portal → Audit → Activity Log |
| SIA Session Log | ISP portal → Secure Infrastructure Access → Session History |

---

## When to Escalate to CyberArk Support

Escalate when:
- Connector repeatedly fails to register despite correct network and token configuration
- Vault connection drops intermittently without any log-level error
- ISP portal shows connector as Connected but sessions consistently fail with no clear error
- You're seeing a `CyberArkException` in the vault log related to the connector service account

Before opening a support ticket, gather:
- `connector.log` (last 500 lines)
- PVWA log from the time of the failure
- Vault log from the time of the failure
- Screenshot of the ISP portal connector status and any error messages
- Output of `Test-NetConnection` tests from the connector server
