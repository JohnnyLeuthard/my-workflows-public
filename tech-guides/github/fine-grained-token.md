# Create Repo-Scoped GitHub API Token

Create a fine-grained GitHub Personal Access Token (PAT) scoped to a single repository. Use this pattern for giving automation tools, AI systems, and CI/CD pipelines access to a specific repo without opening up your entire GitHub account.

## Overview

Fine-grained tokens are repo-specific by design — they grant minimal permissions and are safer than classic PATs that often have account-wide access.

## Dependencies
- GitHub account with the target repository already created

## Steps

1. Go to `github.com` → click your avatar (top right) → **Settings**
2. Scroll to the bottom of the left sidebar → **Developer settings**
3. **Personal access tokens** → **Fine-grained tokens** → **Generate new token**
4. Set **Token name** — use a descriptive name (e.g. `my-automation-read-only`, `n8n-prod`)
5. Set **Expiration** — 90 days recommended for rotation, or "No expiration" for permanent tools
6. Under **Repository access** → select **Only select repositories** → choose your target repo
7. Under **Permissions** → set:
   - **Contents** → `Read-only` (or `Read and write` if you need to create/update files)
   - **Metadata** → `Read-only` (auto-selected, required)
   - Everything else → `No access`
8. Click **Generate token**
9. Copy the token immediately — GitHub will not show it again

## Commands

Test the token from terminal (replace TOKEN and REPO values):
```bash
curl -H "Authorization: Bearer YOUR_TOKEN" \
  https://api.github.com/repos/YOUR-USERNAME/REPO-NAME
```

Fetch a raw file from a private repo:
```bash
curl -H "Authorization: Bearer YOUR_TOKEN" \
  https://raw.githubusercontent.com/YOUR-USERNAME/REPO-NAME/main/FILE.md
```

## Verification

- Token appears in **Fine-grained tokens** list on GitHub
- `curl` command above returns repo metadata (not a 401 error)
- Token is NOT visible under classic Personal access tokens (they are separate)

## Notes

- Fine-grained tokens are repo-specific by design — never grant "All repositories" unless absolutely necessary
- Store the token in your secure credentials vault, not in the target repository itself
- If a tool asks for a username + password, use your GitHub username and the token as the password
- For HTTP/REST API use: pass as HTTP header `Authorization: Bearer YOUR_TOKEN`
- Create one token per repository to isolate blast radius

## Using the Token in n8n

If you are integrating this token with n8n automation:

1. In n8n, go to **Credentials** → **New** → select **GitHub API**
2. Set:
   - **GitHub Server:** `https://api.github.com`
   - **User:** your GitHub username
   - **Access Token:** paste the token you copied
3. Click **Test** → it should say *Connection tested successfully*
4. Save the credential

### Test by Creating a File in n8n

1. Add a **GitHub** node to your workflow
2. Configure as follows:
   - **Resource:** File
   - **Operation:** Create
   - **Repository Owner:** `your-github-username`
   - **Repository Name:** `target-repo-name`
   - **File Path:** `test-folder/test.json` (no leading slash)
   - **File Content:** `{"source":"automation test"}`
   - **Commit Message:** `test write`
3. Run the node.  
   You should see the file appear in your GitHub repository.

## Troubleshooting

| Problem | Likely Cause | Fix |
|----------|---------------|-----|
| **401 Unauthorized** | Token is wrong or revoked | Recreate the token and verify it appears in GitHub's Fine-grained tokens list |
| **404 Not Found** | Token cannot access the repo | Recheck that the token was scoped to the correct repo during creation |
| **Commit message required** | Missing message field | Add a message under *Commit Message* in the GitHub node |
| **Path must not start with a slash** | File path syntax error | Use `folder/file.json`, not `/folder/file.json` |
| **Token works only in one repo** | Expected behavior | Create a new token for other repos |

## Security Best Practices

- Create one token per repository
- Use short expirations (90 days) and rotate regularly for production use
- Store tokens securely in credential management (n8n Credentials, GitHub Secrets, etc)
- Avoid committing tokens to any repo
- Revoke tokens immediately if exposed
