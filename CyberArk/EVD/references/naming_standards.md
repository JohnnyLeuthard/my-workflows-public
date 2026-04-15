# Vault Naming Standards

> Layer 3 shared reference. Consumed by EVD/01_sql_gen, EVD/03_parsing, and psPAS/01_planning.
> Configure once during workspace setup. Stays the same across every pipeline run.

---

## Safe Naming Convention

### Pattern

`{AccountType}-{Technology}-{Environment}`

### Components

| Position | Component | Allowed Values | Description |
|----------|-----------|----------------|-------------|
| 1 | AccountType | <!-- FILL IN: e.g., SA, PA, APP, SVC --> | Account category prefix |
| 2 | Technology | <!-- FILL IN: e.g., Linux, Windows, Oracle, Network --> | Target technology or platform group |
| 3 | Environment | <!-- FILL IN: e.g., Prod, UAT, Dev, DR --> | Deployment environment |

### Delimiter

Hyphen (`-`)

### Examples

<!-- FILL IN: Replace these examples with your actual safe names -->

| Safe Name | AccountType | Technology | Environment |
|-----------|-------------|------------|-------------|
| SA-Linux-Prod | SA (Service Account) | Linux | Production |
| PA-Windows-UAT | PA (Privileged Account) | Windows | UAT |
| APP-Oracle-Dev | APP (Application) | Oracle | Development |

### Known Exceptions / Legacy Patterns

<!-- FILL IN: List safes that don't follow the convention but are intentionally kept -->
<!-- Example: "OldLinuxSafe — legacy safe from pre-migration, to be renamed in Q3" -->

| Safe Name | Reason | Planned Action |
|-----------|--------|----------------|
| <!-- legacy safe --> | <!-- why it exists --> | <!-- rename / keep / decommission --> |

---

## Platform Naming Convention

### Expected Platform IDs by Technology

<!-- FILL IN: Map each technology to its valid CyberArk Platform IDs (PolicyID values) -->

| Technology | Expected Platform IDs |
|------------|----------------------|
| Linux | <!-- e.g., LinuxSSH, LinuxSSHKeys --> |
| Windows | <!-- e.g., WinServerLocal, WinDomain --> |
| Oracle | <!-- e.g., OracleDB --> |
| Network | <!-- e.g., CiscoIOS, F5BigIP, PaloAlto --> |
| <!-- add rows --> | <!-- add platform IDs --> |

---

## Account Object Naming Convention

### Pattern

<!-- FILL IN: Define your organization's account object naming pattern -->
<!-- Common pattern: {PlatformCategory}-{PlatformID}-{UserName}-{Address} -->

`{Segment1}-{Segment2}-{Segment3}-{Segment4}`

### Segment Definitions

| Position | Segment | Source | Description |
|----------|---------|--------|-------------|
| 1 | <!-- e.g., PlatformCategory --> | <!-- e.g., derived from PolicyID --> | <!-- description --> |
| 2 | <!-- e.g., PlatformID --> | <!-- e.g., PolicyID property --> | <!-- description --> |
| 3 | <!-- e.g., UserName --> | <!-- e.g., UserName property --> | <!-- description --> |
| 4 | <!-- e.g., Address --> | <!-- e.g., Address property --> | <!-- description --> |

---

## Compliance Rules

> Stage 3 (EVD/03_parsing) cites these rule IDs in compliance findings.
> psPAS/01_planning uses them to determine remediation targets.

### Safe Rules

| Rule ID | Description | Severity | Check |
|---------|-------------|----------|-------|
| NS-S01 | Safe name matches `{AccountType}-{Technology}-{Environment}` pattern | High | Parse safe name by delimiter, validate each segment against allowed values above |
| NS-S02 | Environment segment matches the actual deployment environment | High | Cross-reference the Environment segment with the target environment |
| NS-S03 | Technology segment has at least one matching platform ID configured | Medium | Look up Technology in the platform mapping table above |

### Platform Rules

| Rule ID | Description | Severity | Check |
|---------|-------------|----------|-------|
| NS-P01 | Account PolicyID matches an expected platform for its safe's Technology | Medium | Compare the account's PolicyID property against the platform mapping for the safe's Technology segment |
| NS-P02 | PolicyID is not blank or missing | High | Flag accounts where PolicyID property is NULL or absent |

### Account Object Rules

| Rule ID | Description | Severity | Check |
|---------|-------------|----------|-------|
| NS-A01 | Object name follows the defined naming pattern | Medium | Parse object name by delimiter, validate segment count and format |
| NS-A02 | UserName segment matches the UserName property value | Low | Compare the parsed segment against the UserName property from CAObjectProperties |
| NS-A03 | Address segment matches the Address property value | Low | Compare the parsed segment against the Address property from CAObjectProperties |

---

## How to Fill In This File

1. **Safe naming**: List every AccountType prefix your organization uses (e.g., SA, PA, APP). List every Technology grouping. List every Environment label.
2. **Platform mapping**: For each Technology, list the CyberArk Platform IDs (PolicyID values) that are valid. You can find these in the PVWA under Administration > Platform Management.
3. **Account naming**: Document how account objects are named in your vault. Look at a few examples in the PVWA or run an EVD query for `CAFFileName` values to see the pattern.
4. **Exceptions**: Add any legacy safes or accounts that intentionally break the rules. This prevents Stage 3 from flagging known exceptions as violations.
5. **Severity levels**: Adjust High/Medium/Low to match your organization's priorities. High = must fix, Medium = should fix, Low = nice to fix.
