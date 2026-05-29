# n8n Airtable Setup

## Goal
Connect n8n to Airtable using an Airtable Personal Access Token (PAT), then validate with a simple list or read operation.

## What you need
- An Airtable account with access to a Base
- n8n running (self-hosted or n8n cloud)
- A Base and at least one Table with at least one record

## Airtable side
### 1) Create a Personal Access Token (PAT)
1. Open Airtable.
2. Go to your account tokens page:
   - Profile icon
   - Developer hub or Personal access tokens
3. Create a new token.

Recommended scopes (minimum)
- data.records:read
- schema.bases:read

If you will write data from n8n, also add
- data.records:write

Token naming
- Use a name like: n8n-prod or n8n-lab
- Add notes in Airtable describing which n8n instance uses it.

Copy the token now.
You will not be able to view it again.

### 2) Get Base ID
You have two common options.

Option A (fast)
- Open the Base in Airtable.
- Look at the URL.
- Base ID often starts with: app

Option B (reliable)
- Use Airtable API docs page for the Base.
- Find the Base ID in the docs panel.

### 3) Get Table name and Field names
- In Airtable, confirm the exact table name.
- Confirm field names.
- Airtable field names are case sensitive in formulas and mapping.

## n8n side
### 4) Create Airtable credentials in n8n
1. In n8n, go to Credentials.
2. Create new credential: Airtable.
3. Auth method: Personal Access Token.
4. Paste your Airtable PAT.
5. Save.

Security
- Do not paste tokens into nodes.
- Use Credentials only.
- Limit scopes in Airtable.

### 5) Build a validation workflow
Create a new workflow with two nodes.

Node 1: Manual Trigger  
Node 2: Airtable

In the Airtable node:
- Resource: Record (or Table, depending on your node version)
- Operation: List (or Get Many)
- Base ID: your appXXXXXXXXXXXXXX
- Table: exact table name
- Return All: false
- Limit: 5

Run the workflow.
You want to see up to 5 records returned.

## Common mapping patterns
### Read a single record by ID
- Operation: Get
- Record ID: recXXXXXXXXXXXXXX

### Filter records
- Operation: List
- Use a Filter formula (Airtable formula syntax), examples:
  - {Status} = "Open"
  - AND({Status}="Open", {Priority}="High")

### Create a record
- Operation: Create
- Fields: map JSON into Airtable fields
- Only send fields that exist in the table schema

### Update a record
- Operation: Update
- Record ID: rec...
- Fields: only the fields you want to change

## Troubleshooting
### 401 Unauthorized
Likely causes
- Token is wrong
- Token revoked
- Missing scopes

Fix
- Recreate token
- Confirm scopes include data.records:read (and write if needed)
- Update the n8n credential

### 403 Forbidden
Likely causes
- Token exists but lacks access to the Base
- Base is in a workspace you do not have access to

Fix
- Confirm your Airtable user can open the Base
- Confirm the token belongs to the same user
- Reissue token

### 404 Not Found
Likely causes
- Wrong Base ID
- Wrong Table name

Fix
- Re-check Base ID starts with app
- Copy the exact table name from Airtable

### Empty results
Likely causes
- Filter formula excludes all rows
- Table has no records
- Using the wrong view (if you set a View)

Fix
- Remove filter
- Remove view selection
- Validate there are records in Airtable

## Best practices
- Use separate tokens for lab and prod.
- Scope tokens to least privilege.
- Rotate tokens on a schedule.
- Store Base ID and Table name in n8n variables (Set node) so you can reuse workflows.
- Add an Error Trigger workflow to alert you when Airtable calls fail.

## Quick checklist
- [ ] PAT created and saved
- [ ] Scopes include data.records:read
- [ ] Base ID confirmed (app...)
- [ ] Table name confirmed (exact)
- [ ] n8n credential created and selected in node
- [ ] List operation returns records
