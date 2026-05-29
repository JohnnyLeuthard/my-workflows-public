# Tailscale Upgrade Steps (OpenWrt / GL.iNet)

## Pre-Upgrade Checks

Confirm current version.
```
tailscale version
```

Verify available space.
```
df -h
```

Ensure /overlay is not full.

## Standard Upgrade

Use the built-in updater after cleanup.
```
tailscale update
```

Confirm version.
```
tailscale version
```

## RAM-Based Download Method

Avoid flash writes by using /tmp. Replace `1.92.3_arm64` with the current stable version.
```
cd /tmp
wget -O tailscale.tgz https://pkgs.tailscale.com/stable/tailscale_1.92.3_arm64.tgz
```

Validate archive.
```
tar -tzf tailscale.tgz | head
```

## opkg Reinstall Method

Use when GL.iNet feeds support the version.

```
opkg update
opkg remove tailscale
opkg install tailscale
```

## Post-Upgrade Validation

Check status.
```
tailscale status
```

Connectivity test.
```
tailscale netcheck
```

## Troubleshooting

If upgrade fails, see the Tailscale troubleshooting guide.
