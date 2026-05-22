# Fix n8n Credential Encryption Key Error

## Purpose
Fix the credential error in n8n:
```
Credentials could not be decrypted. The likely reason is that a different "encryptionKey" was used to encrypt the data.
```

This applies when:
- All existing credentials work
- A new credential fails after creation
- VM or key settings were not changed
- The n8n container shows `unhealthy` status

## Root Cause
A credential was created while n8n was still initializing. During early startup, the encryption key may not be loaded yet. Any credentials created during that window are encrypted incorrectly and will always fail to decrypt.

This is likely if:
- You created the credential right after n8n started
- The n8n container reports `unhealthy`

## Fix Steps

### 1. Delete the Failed Credential
Remove the single problematic credential from the Credentials screen in n8n.

### 2. Restart N8n Cleanly
Run:
```
docker compose down
docker compose up -d
```

### 3. Wait Until Healthy
Confirm status:
```
docker ps | grep n8n
```
Ensure the container shows:
```
STATUS ... (healthy)
```

### 4. Recreate the Credential
Create the credential again and attach it to the HTTP request node.

### 5. Test Without Credentials (Optional)
To confirm the API works, temporarily set HTTP Request credentials to "None" and manually add headers:
```
Authorization: Bearer <API_KEY>
```

## Diagnostic Check

### Verify Only One N8n Instance is Running
```
docker ps | grep n8n
```

### Confirm Encryption Key in Use
```
docker exec -it n8n-n8n-1 printenv N8N_ENCRYPTION_KEY
```

### Inspect Logs if `unhealthy`
```
docker logs n8n-n8n-1
```

## Notes
- Never create credentials before the n8n container is healthy.
- Never run multiple n8n instances against the same DB with different keys.
- Always store `N8N_ENCRYPTION_KEY` in a secrets vault or `.env` file and keep it consistent across workers if scale-up occurs.
