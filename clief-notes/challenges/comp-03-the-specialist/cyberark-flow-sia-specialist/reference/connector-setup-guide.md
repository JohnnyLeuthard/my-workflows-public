# Reference: Connector Setup Guide

This guide covers the four phases of connecting CyberArk cloud (SIA + Flow) to an on-premises vault. Complete phases in order. Do not skip validation steps.

---

## Phase 1: Prepare the Environment

### 1.1 Create the Vault Service Account

On the **on-prem Vault** (via PrivateArk Client or PVWA):

1. Open PrivateArk Client → Tools → Administrative Tools → Users and Groups
2. Create a new user:
   - Name: `CyberArkConnectorSvc` (or your naming convention)
   - Type: CyberArk user (not LDAP/AD)
   - Set a strong password and record it securely
3. Add the user to the **Auditors** group (read access to audit logs)
4. Grant the user access to each safe that SIA sessions will target:
   - Safe → Members → Add member → `CyberArkConnectorSvc`
   - Permissions: **Use accounts**, **List accounts**, **Retrieve accounts**
   - Do NOT grant Owner, Manage Safe, or Delete permissions

### 1.2 Confirm Vault Connectivity from Connector Server

From the connector server, test:
```powershell
Test-NetConnection -ComputerName <VaultIP> -Port 1858
Test-NetConnection -ComputerName <PVWAhostname> -Port 443
```
Both must return `TcpTestSucceeded: True` before proceeding.

### 1.3 Confirm Cloud Connectivity from Connector Server

```powershell
Test-NetConnection -ComputerName connector.cyberark.cloud -Port 443
Invoke-WebRequest -Uri https://connector.cyberark.cloud -UseBasicParsing
```
If `Invoke-WebRequest` fails with a certificate error, resolve SSL inspection bypass before continuing (see troubleshooting.md).

---

## Phase 2: Download and Install the Connector

### 2.1 Download the Connector Installer

1. Log into your ISP tenant: `https://yourcompany.cyberark.cloud`
2. Navigate to: **Infrastructure** → **Connectors** → **Add Connector**
3. Select connector type: **CyberArk Connector**
4. Download the installer package (`.exe` or `.msi`)
5. Also copy the **Registration Token** displayed on screen — it expires in 60 minutes

> **Note:** Do not close or navigate away from this screen until the registration token is copied. Generate it only when you're ready to run the installer immediately.

### 2.2 Run the Installer

On the **connector server** (run as local administrator):

1. Run the downloaded installer
2. Accept the license agreement
3. Choose the installation directory (default: `C:\Program Files\CyberArk\Connector`)
4. When prompted, paste the **Registration Token** from step 2.1
5. Complete the installation

The installer:
- Installs the CyberArk Connector Windows Service
- Uses the registration token to authenticate to your cloud tenant
- Downloads tenant-specific configuration
- Starts the connector service

### 2.3 Verify Registration

1. Check the connector service: `Services.msc` → **CyberArk Connector** → Status: Running
2. Check the log: `C:\Program Files\CyberArk\Connector\Logs\connector.log`
   - Look for: `Successfully registered with tenant` or `Connector online`
3. In the ISP portal: **Infrastructure** → **Connectors**
   - Your connector should appear with status **Connected** (green)

✓ **Validation checkpoint:** Connector shows as Connected in the ISP portal before proceeding.

---

## Phase 3: Link the Connector to the On-Prem Vault

### 3.1 Configure the Vault Connection

In the ISP portal:

1. Go to **Infrastructure** → **Connectors** → click your connector
2. Select **Settings** or **Vault Connection** (label varies by ISP version)
3. Enter:
   - **Vault Address**: IP or FQDN of your on-prem vault
   - **Vault Port**: 1858
   - **Vault Username**: `CyberArkConnectorSvc` (created in Phase 1)
   - **Vault Password**: Password set in Phase 1
   - **PVWA URL**: `https://yourpvwa.yourdomain.com`
4. Save and apply

### 3.2 Verify Vault Connection

In the ISP portal, the connector's vault connection status should show **Connected**.

In the connector log (`connector.log`), look for:
```
Vault connection established: <VaultIP>:1858
PVWA API connection established: https://<PVWAhostname>
```

If vault connection fails: see troubleshooting.md → Vault Connectivity section.

---

## Phase 4: Configure SIA Access Policies and Test

### 4.1 Create a Target (SIA)

In the ISP portal → **Secure Infrastructure Access** → **Targets**:

1. Add a new target:
   - Name: Descriptive name for the target server
   - Address: IP or FQDN of the target machine
   - Protocol: RDP or SSH
   - Connector: Select your registered connector
   - Credential source: **From Vault** → select the safe and account
2. Save the target

### 4.2 Create an Access Policy

In **Secure Infrastructure Access** → **Policies**:

1. Create a policy:
   - Name: Descriptive (e.g., "Admins — Production RDP")
   - Users/Groups: Assign the users or directory groups allowed to use this
   - Targets: Select the target(s) from step 4.1
   - MFA requirement: Set as required (SIA enforces MFA)
   - Session recording: Enable (recommended)
2. Save and activate the policy

### 4.3 Run a Test Session

1. Log into the ISP portal as a user covered by the access policy
2. Navigate to **Secure Infrastructure Access** → your target
3. Click **Connect**
4. Complete MFA if prompted
5. An RDP or SSH session should launch

✓ **Validation checkpoint:** Session connects, screen appears, session is visible in ISP portal under Active Sessions.

---

## Phase 5: Configure Flow Integration (if applicable)

### 5.1 Enable Flow Connector Profile

In the ISP portal → **Flow** → **Connectors**:

1. Add a connector profile
2. Select your registered connector
3. Authenticate the profile with PVWA API credentials
4. Test the connection

### 5.2 Build or Import a Flow Workflow

Flow workflows are built in the Flow visual editor. For PAM-related workflows, common starting points:
- **Account Checkout**: User requests → approval → credential checked out from vault → returned after use
- **Access Request**: User requests SIA access → manager approval in Flow → SIA policy temporarily elevated
- **Onboarding**: New account trigger → vault account created → CPM rotates → SIA target added

CyberArk provides workflow templates in the Flow marketplace. Import the relevant template and configure it for your vault and connector.

### 5.3 Test a Flow Workflow

Trigger the workflow manually from the Flow editor and verify:
- The workflow progresses through all stages
- Vault actions (if any) complete successfully
- The audit log in the vault reflects the activity

---

## Post-Setup: Ongoing Maintenance

- **Connector updates**: CyberArk pushes connector updates automatically from the cloud. Verify update behavior in your change management process — some organizations configure manual approval for updates.
- **Second connector (HA)**: Repeat Phase 2–3 on a second server. Both connectors appear in the ISP portal and the cloud load-balances across them automatically.
- **Certificate renewal**: The connector uses a certificate issued by CyberArk during registration. It auto-renews while the connector is online. If the connector is offline for an extended period, re-registration may be required.
- **Vault password rotation**: If you rotate the `CyberArkConnectorSvc` password, update it in the ISP portal connector settings immediately or the vault connection will drop.
