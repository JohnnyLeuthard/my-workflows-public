# Reference: Prerequisites Checklist

Complete every item before starting connector installation. Skipping items here is the #1 cause of failed or unstable deployments.

---

## 1. Licensing & Tenant

- [ ] CyberArk SIA license is activated on your ISP tenant
- [ ] CyberArk Flow license is activated (if using Flow)
- [ ] You have Tenant Admin access to your CyberArk ISP portal (`yourcompany.cyberark.cloud`)
- [ ] You know your tenant region (US, EU, APAC) — affects endpoint URLs
- [ ] Your CyberArk PAM version is supported for cloud integration (v12.1+ recommended; v13+ preferred)

---

## 2. Connector Server

- [ ] Dedicated Windows Server available (2016, 2019, or 2022)
- [ ] Server is NOT a Domain Controller
- [ ] Server is NOT currently running other CyberArk components (Vault, PVWA, PSM, CPM)
- [ ] Minimum specs met: 4 vCPU, 8 GB RAM, 50 GB disk (increase for high-session-volume environments)
- [ ] .NET Framework 4.8 or later installed
- [ ] Windows PowerShell 5.1 or later
- [ ] Local Administrator access to the connector server
- [ ] Server has a static IP or DNS-resolvable hostname
- [ ] Server time is synchronized (NTP) — certificate validation fails if clock drift > 5 minutes

---

## 3. Network & Firewall

### Outbound from Connector Server
- [ ] Port 443 (HTTPS/WSS) to `*.cyberark.cloud` (or `*.cyberark.eu` for EU tenants)
- [ ] Port 443 to `*.privilegecloud.cyberark.cloud`
- [ ] Port 443 to `connector.cyberark.cloud`
- [ ] WebSocket (WSS) connections are NOT blocked or stripped by proxy/firewall

### Outbound from Connector Server to On-Prem PAM
- [ ] Port 1858 (TCP) to Vault server IP
- [ ] Port 443 (HTTPS) to PVWA server(s)
- [ ] Port 3389 (RDP) to PSM server(s) — if using PSM-based sessions
- [ ] Port 22 (SSH) to PSM server(s) — if using PSM for SSH

### Outbound from Connector Server to Targets (agentless only)
- [ ] Port 3389 to RDP target servers
- [ ] Port 22 to SSH target servers

### SSL Inspection
- [ ] Confirmed whether an SSL-inspecting proxy sits between the connector and the internet
- [ ] If yes: `*.cyberark.cloud` is bypassed from SSL inspection OR proxy CA cert is imported to the connector server's Trusted Root store

---

## 4. CyberArk On-Prem PAM Health

- [ ] Vault service is running and healthy (check PVWA → Administration → System Health)
- [ ] PVWA is accessible and REST API is enabled
- [ ] PSM service is running (if using PSM-based sessions)
- [ ] CPM is running (credentials on target accounts must be valid for sessions to work)
- [ ] Vault has available space (full vault disk = failed operations)

---

## 5. Service Accounts

### Vault Service Account (for Connector → Vault communication)
- [ ] A dedicated CyberArk vault user created for the connector (do NOT use the built-in Administrator account)
- [ ] Vault user is an Application account type (not a human user)
- [ ] Vault user has at minimum:
  - List accounts permission on target safes
  - Use password permission on target safes
  - Access Safe without confirmation (or approval workflow configured in Flow)
- [ ] Vault user credentials are stored securely — they will be entered during connector config

### PVWA API Account (for Connector → PVWA communication)
- [ ] A dedicated PVWA user created for the connector's API calls
- [ ] User is a member of the Vault Admins group OR has specific PVWA API permissions
- [ ] User has access to the safes that SIA will manage sessions for

---

## 6. CyberArk ISP Tenant Pre-Config

- [ ] At least one Identity Provider (IdP) or CyberArk Identity directory configured for user authentication in the ISP tenant
- [ ] Users who will use SIA exist in the directory
- [ ] MFA is configured for SIA users (SIA requires MFA by design)
- [ ] Tenant admin can access: Infrastructure → Connectors (confirms SIA module is enabled)

---

## Version Compatibility Notes

| PAM Version | Connector Compatibility | Notes |
|---|---|---|
| v12.1 – v12.6 | Supported | Some SIA features limited |
| v13.x | Fully supported | Recommended minimum |
| v14.x | Fully supported | Current; best Flow integration |
| Below v12 | Not supported | Upgrade required |

Always confirm the connector version downloaded from the ISP portal matches your PAM version requirements. CyberArk releases connector updates independently of PAM.
