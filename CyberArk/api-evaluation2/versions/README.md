# CyberArk PAM API Versions

This directory contains API endpoint documentation organized by platform type and version.

## Self-Hosted (PAM Self-Hosted / On-Premises)

**Documentation base**: `https://docs.cyberark.com/pam-self-hosted/{VERSION}/en/content/webservices/`

| Version | Status | Build | Endpoints | Last Updated | Files |
|---------|--------|-------|-----------|--------------|-------|
| v12.2 | Complete | 8.2.5 | 25 | 2026-05-03 | [api-catalog.md](self-hosted/v12.2/api-catalog.md) • [changelog.md](self-hosted/v12.2/changelog.md) • [endpoints/](self-hosted/v12.2/endpoints/) |
| v14.2 | Complete | 8.3.6 | 28 | 2026-05-03 | [api-catalog.md](self-hosted/v14.2/api-catalog.md) • [changelog.md](self-hosted/v14.2/changelog.md) • [endpoints/](self-hosted/v14.2/endpoints/) |

## Privilege Cloud

**Documentation base**: `https://docs.cyberark.com/privilege-cloud/{VERSION}/en/content/webservices/`

| Version | Status | Build | Endpoints | Last Updated | Files |
|---------|--------|-------|-----------|--------------|-------|
| (none yet) | — | — | — | — | Add first PC version using `New-APIVersion.ps1 -Version {X.X} -Platform PC` |

## Quick Navigation

- **Self-Hosted v12.2**: [endpoints/](self-hosted/v12.2/endpoints/) | [api-catalog](self-hosted/v12.2/api-catalog.md) | [changelog](self-hosted/v12.2/changelog.md)
- **Self-Hosted v14.2**: [endpoints/](self-hosted/v14.2/endpoints/) | [api-catalog](self-hosted/v14.2/api-catalog.md) | [changelog](self-hosted/v14.2/changelog.md)
- **Privilege Cloud**: See [version-tracking.md](version-tracking.md) for status

## Comparing Versions

To see what changed between versions (same platform only), run:

```powershell
# Self-Hosted comparison
.\scripts\Compare-APIVersions.ps1 -From 12.2 -To 14.2

# Privilege Cloud comparison (when PC versions exist)
.\scripts\Compare-APIVersions.ps1 -From 14.2 -To 24.1 -Platform PC
```

Output will be saved to `exports/comparison_[platform]_v[X.X]_to_v[X.X]_YYYYMMDD.md`.

For polished reports (manager-level and developer-level), see the `../reports/` folder.

## Adding a New Version

### Self-Hosted

```powershell
.\scripts\New-APIVersion.ps1 -Version 14.4 -CopyFrom 14.2
```

This creates `self-hosted/v14.4/` folder structure and copies v14.2 as a starting point.

### Privilege Cloud

```powershell
.\scripts\New-APIVersion.ps1 -Version 24.1 -Platform PC
```

This creates `privilege-cloud/v24.1/` folder structure.

After creating, populate the endpoints folder with complete endpoint documentation following the [endpoint-template.md](../references/endpoint-template.md) structure.

## Tracking Completeness

See [version-tracking.md](version-tracking.md) for detailed endpoint completion checklist across all versions and platforms.

---

**Last Updated**: 2026-05-03
