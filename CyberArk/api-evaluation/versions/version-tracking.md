# Version Tracking

Status of each tracked CyberArk PAM Self-Hosted API version in this workspace.

## Status values

| Status | Meaning |
|---|---|
| `Framework only` | Folder scaffolded (api-catalog / changelog / endpoints/README). No endpoint content populated. |
| `Populated` | Endpoint files present and filled from live CyberArk docs. |
| `Stale` | Previously populated; CyberArk has published updates since last fetch. |
| `Retired` | No longer tracked; kept for historical comparison only. |

## Tracked versions

| Version | Folder | Build | Doc URL segment | Status | Last fetched | Notes |
|---|---|---|---|---|---|---|
| 12.2 | `v12.2/` | 8.2.5 | `12.2` | Framework only | — | Baseline for historical diffs |

> Update this table any time `New-APIVersion.ps1` or `Fetch-APIDocumentation.ps1` runs. Keep the `Last fetched` column in ISO date format (YYYY-MM-DD).
