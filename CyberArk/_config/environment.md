# CyberArk Environment Configuration

> **How to use this file:**
> Fill in your actual versions. Mark anything not deployed in your environment as `N/A`.
> Claude loads this file to ensure suggestions match your actual environment — versions,
> deployment model, and component availability all affect what commands and features are valid.

---

## Deployment Model

Enter `Self-hosted` or `Privilege Cloud` for each tier. Use `N/A` if that tier does not exist.

| Environment | Model       | Tier | Notes                          |
|------------|-------------|------|--------------------------------|
| DEV        |             | dev  |                                |
| UAT        |             | uat  |                                |
| PROD       |             | prod |                                |

> REST API paths, cmdlet behavior, and feature availability differ significantly between
> Self-hosted and Privilege Cloud.

---

## CyberArk Platform Components

| Component   | DEV  | UAT  | PROD | Notes                                       |
|------------|------|------|------|---------------------------------------------|
| Vault       | 14.4.2 | 14.4.2 | 14.4.2 | Core vault server version                   |
| PVWA        | 14.4.2 | 14.4.2 | 14.4.2 | REST API paths and parameters vary by version |
| CPM         |      |      |      | Plugin behavior and policy options          |
| PSM         |      |      |      | Session recording and connection configuration |
| PSMP        | N/A  | N/A  | N/A  | SSH Proxy — mark N/A if not deployed        |
| AAM / CCP   | N/A  | N/A  | N/A  | App credential retrieval — mark N/A if not deployed |
| PTA         | N/A  | N/A  | N/A  | Privileged Threat Analytics — mark N/A if not in scope |
| Conjur      | N/A  | N/A  | N/A  | Secrets Hub / DevOps secrets — mark N/A if not in scope |

---

## Client Tools & Modules

| Tool       | Version | Notes                                                   |
|-----------|---------|----------------------------------------------------------|
| psPAS     |         | Cmdlet availability and parameters vary significantly by version |
| PowerShell |         | 5.1 vs 7.x affects syntax and module loading behavior   |
| Python     |         | Used in EVD parsing stage — affects script compatibility |

---

## Authentication

Enter the auth method used for each tier (`CyberArk`, `LDAP`, `SAML`, or `PKI`) and set MFA to `Yes` or `No`. Use `N/A` if that tier does not exist.

| Environment | Method | MFA Enforced | Notes                        |
|------------|--------|--------------|------------------------------|
| DEV        |        |              |                              |
| UAT        |        |              |                              |
| PROD       |        |              |                              |

> Auth method affects which `New-PASSession` parameters are required and how session setup works.

---

## Claude Guidance Rules

- **Version authority**: Do not suggest cmdlets, REST API endpoints, or features that require a higher version than listed above.
- **N/A components**: Do not reference or suggest anything related to components marked `N/A` — they are not deployed.
- **Deployment model**: Apply the correct guidance for the deployment model listed (self-hosted vs Privilege Cloud) — they have different API paths, feature sets, and behaviors.
- **Environment ambiguity**: If the user has not specified which environment tier (DEV / UAT / PROD) they are working in, ask before proceeding with any destructive or high-consequence actions.
- **Blank fields**: If a version field is blank, do not assume a version — ask the user to fill it in before giving version-dependent guidance.
