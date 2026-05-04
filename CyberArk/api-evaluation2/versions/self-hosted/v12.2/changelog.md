# Changelog — v12.2

**Version**: 12.2  
**Build**: 8.2.5  
**Release Date**: November 2024  
**Status**: Baseline version

---

## Version Details

### Build Information

| Field | Value |
|-------|-------|
| **Version** | 12.2 |
| **Build** | 8.2.5 |
| **Release Date** | November 2024 |
| **Support Status** | Supported |
| **Type** | Baseline (first documented version in this workspace) |

### Notable Changes in v12.2

Since this is the baseline version for this documentation workspace, all endpoints listed in `api-catalog.md` represent features available in v12.2.

Key areas include:
- Core account and safe management
- User and group administration
- Session recording and monitoring
- Platform configuration
- Request workflow management
- Discovery and onboarding rules

---

## Endpoints Introduced (Complete List)

All ~26 endpoints documented in `api-catalog.md` were available as of v12.2.

See [api-catalog.md](api-catalog.md) for full endpoint listing.

---

## Known Limitations

### Features Coming in Later Versions

The following features are **NOT** available in v12.2:

- **v14.2.1 additions**:
  - Authentication Methods Configuration endpoints
  - Account Secret Version history endpoint
  - PTA Administration endpoints

- **v14.4 additions**:
  - Advanced authentication configuration
  - Advanced account search properties

---

## Migration Notes

**For new implementations**: v12.2 is suitable for most basic to intermediate use cases. Consider upgrading to v14.2.1+ if you need advanced authentication methods or secret rotation features.

**For existing implementations**: If running on v12.2, evaluate upgrade timing based on new feature needs and change impact analysis (see parent directory ALL-CHANGES.md).

---

## Documentation Status

All ~26 endpoints are **pending documentation** in this workspace. Run `Fetch-APIDocumentation.ps1 -Version 12.2` to populate endpoint files from live CyberArk documentation.

Estimated coverage: ~40% of endpoints documented from CyberArk source material.

---

## API Deprecations

None documented for v12.2 (baseline version).

---

## Bug Fixes & Improvements

(Information about specific bug fixes and improvements in v12.2 would be added here if documented separately from upstream CyberArk release notes)

---

## Compatibility

### Supported Client Environments

- **PowerShell**: 5.0+
- **Python**: 3.6+
- **Node.js**: 12+
- **Java**: 8+
- **Go**: 1.11+

### Vault Compatibility

- **CyberArk PAM 12.2**: Full compatibility
- **Older versions**: Not supported
- **Newer versions**: Some endpoints may be unavailable

---

## References

- Official Release Notes: [CyberArk v12.2 Release Notes](https://docs.cyberark.com/pam-self-hosted/12.2/en/content/release%20notes/release%20notes.htm)
- API Documentation: https://docs.cyberark.com/pam-self-hosted/12.2/en/content/webservices/implementing%20privileged%20account%20security%20web%20services.htm
- Administrator Guide: https://docs.cyberark.com/pam-self-hosted/12.2/

---

**Last Updated**: [Initial creation — awaiting documentation fetch]  
**Maintained By**: API Evaluation Workspace
