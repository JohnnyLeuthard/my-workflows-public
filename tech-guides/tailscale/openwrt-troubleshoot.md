# Tailscale Troubleshooting (OpenWrt / GL.iNet)

## Symptoms

- no space left on device during update
- update download starts then fails
- tailscaled fails to restart after upgrade attempt

Common on OpenWrt and GL.iNet routers with limited overlay storage.

## Disk State Verification

Check flash and overlay usage.
```
df -h
```

Problem state indicators:
- /overlay at 100%
- 0 bytes available

## Identify Overlay Usage

BusyBox does not support human-readable sort.
```
du -k /overlay/upper 2>/dev/null | sort -n | tail -40
```

Focused checks.
```
du -k -d 2 /overlay/upper/root 2>/dev/null | sort -n | tail -40
du -k -d 2 /overlay/upper/usr  2>/dev/null | sort -n | tail -40
du -k -d 2 /overlay/upper/etc  2>/dev/null | sort -n | tail -40
```

## Clear Tailscale Update Cache

```
rm -rf /root/.cache/tailscale-update
rm -rf /overlay/upper/root/.cache/tailscale-update
```

## Clear Package Caches

```
rm -rf /tmp/opkg-lists/*
rm -rf /var/opkg-lists/*
```

## Reduce Zoneinfo Footprint

Keep only required regions.
```
opkg remove zoneinfo-africa zoneinfo-asia zoneinfo-atlantic zoneinfo-australia-nz zoneinfo-europe zoneinfo-indian zoneinfo-pacific zoneinfo-poles zoneinfo-simple
```

Verify space.
```
df -h
```

## Optional Package Removal

Remove only unused services.

Examples:
```
opkg remove tor tor-geoip
```

Do not remove Samba if Windows SMB access to USB storage is required.

## Reset and Recover

Reboot to stabilize services.
```
reboot
```

Restart Tailscale if needed.
```
tailscale up --reset
```
