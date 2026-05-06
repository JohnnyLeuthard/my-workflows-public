# Reference: Architecture Overview — CyberArk Cloud to On-Prem

## The Big Picture

CyberArk's cloud Identity Security Platform (ISP) manages policy, access decisions, and workflow orchestration. The on-premises CyberArk PAM Vault remains the authoritative store for privileged credentials. The **CyberArk Connector** is the bridge between them.

```
[CyberArk ISP Cloud Tenant]
        |
        | HTTPS/WSS outbound (port 443)
        |
[CyberArk Connector — on-prem Windows Server]
        |                        |
        | TCP 1858               | HTTPS 443
        |                        |
  [CyberArk Vault]         [PVWA / PSM]
```

No inbound ports are opened to the connector. All communication is initiated outbound from the connector to the cloud.

---

## Component Roles

### CyberArk Identity Security Platform (Cloud Tenant)
- Hosts SIA policy engine: who can access what, under what conditions
- Hosts Flow: approval workflows, automation triggers
- Manages connector fleet: registration, health monitoring, version updates
- Brokers session requests: receives access request → validates policy → instructs connector to establish session

### CyberArk Connector (On-Prem)
- Installed on a Windows Server in your environment
- Maintains a persistent outbound WebSocket connection to the cloud tenant
- Receives session instructions from the cloud and executes them locally
- Connects to the vault via the Vault SDK (port 1858) to retrieve credentials
- Connects to PVWA APIs for session management
- Can serve multiple functions: SIA sessions, Flow integration, directory bridge

### On-Premises CyberArk PAM
- **Vault**: Stores privileged credentials. The connector authenticates to the vault using a dedicated service account (CyberArk application identity, not a human account).
- **PVWA**: Web interface + REST API. The connector uses PVWA APIs to create/launch sessions.
- **PSM** (Privileged Session Manager): Proxies RDP/SSH sessions to targets. SIA can use PSM-based sessions (where PSM connects to the target) or agentless sessions (where the connector connects directly to the target).
- **CPM** (Central Policy Manager): Rotates credentials. Not directly involved in SIA/Flow setup but must be healthy for credentials to be valid.

---

## SIA Session Flow (Step by Step)

1. User requests access to a target server via SIA (web portal or native client)
2. ISP cloud evaluates the access policy: Is this user allowed? Is MFA satisfied? Is an approval required?
3. If approved: ISP instructs the connector to establish a session
4. Connector retrieves the target's credentials from the on-prem vault via port 1858
5. Connector establishes session: either via PSM (connector → PSM → target) or agentlessly (connector → target directly)
6. User's session is tunneled through the connector back to the cloud, then to the user's client
7. Session recording (if configured) flows through PSM or CyberArk's cloud session recording

---

## Flow Integration Architecture

CyberArk Flow connects to on-prem PAM primarily via:
- **PVWA REST API**: Flow can trigger account actions (check out credentials, create accounts, run CPM tasks)
- **Connector**: Flow workflows that require on-prem execution route through the connector

A Flow connector profile maps a cloud workflow trigger to an on-prem vault action. Example: "New employee onboarded" → Flow → creates PAM account → CPM rotates initial password → SIA policy created.

---

## Key Design Decisions

**How many connectors do you need?**
- Minimum 1 per site/network segment that needs SIA access
- Recommended: 2 per site for high availability (connectors form a pool; the cloud load-balances across them)
- Connectors do not replicate data between themselves — they are stateless proxies

**PSM-based vs. agentless sessions**
- PSM-based: Session traffic goes Connector → PSM → Target. Recordings stored in vault. Requires PSM to be reachable from the connector.
- Agentless (Direct): Session traffic goes Connector → Target directly. Simpler network path, but fewer recording/control options. Suitable for SSH-heavy environments.

**Connector placement**
- Must reach CyberArk cloud (port 443 outbound)
- Must reach vault (port 1858)
- Must reach PVWA (port 443)
- Must reach PSM (port 3389/22) if using PSM-based sessions
- Must reach target servers (port 3389/22) if using agentless sessions
- Typically placed in a DMZ or a dedicated PAM network segment
- Should NOT be a domain controller, DNS server, or shared-purpose server
