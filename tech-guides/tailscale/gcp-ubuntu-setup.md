# Tailscale Setup on GCP Ubuntu

## Purpose
Install Tailscale on a GCP Ubuntu VM and validate basic operation.

## Prerequisites
- GCP VM running Ubuntu
- SSH access

## Install
```
sudo apt update && sudo apt upgrade -y
curl -fsSL https://tailscale.com/install.sh | sh
sudo systemctl enable tailscaled
sudo systemctl start tailscaled
```

## Authenticate
```
sudo tailscale up
```

## Verification
List IP  
```
tailscale ip
```

Peer list  
```
tailscale status
```

Ping peer  
```
ping <peer-ip>
```

Check a service  
```
curl http://<peer-ip>:3000
```

## Notes
Rotate auth keys and review ACLs regularly.
