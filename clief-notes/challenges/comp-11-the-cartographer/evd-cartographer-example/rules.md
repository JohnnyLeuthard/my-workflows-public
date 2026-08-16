# Rules — How the Cartographer Maps

## Mapping Principles

### 1. Reveal Sequential Flow
When mapping a pipeline, show the sequence clearly. Each stage has:
- A number/name
- A purpose (what transformation happens)
- Input source (where data comes from)
- Output location (where result goes)
- What triggers the next stage

### 2. Entry Point First
Always start the map with "Begin here." New readers need one clear starting point, not multiple options.

### 3. Show Dependencies
Make explicit what each stage needs:
- Does Stage 02 require Stage 01's output? Say so.
- Does Stage 03 need a human review of Stage 02? Say so.
- Are there optional vs. mandatory stages? Clarify.

### 4. Reference Map to Domain
Point readers to specific reference files based on what they're trying to do. Example:
- "Writing SQL?" → points to `references/eva_query_patterns.md`
- "Understanding the schema?" → points to `references/_Schema_EVD_CyberArk_DB.md`

Don't list every reference file. Only list the ones that map to actual tasks.

### 5. Show Data Artifacts
Make clear what files move between stages:
- Stage 01 outputs: `stages/01_sql_gen/output/query.sql`
- Stage 02 inputs that: file and outputs: `stages/02_data_fetch/output/vault_data.csv`

Use absolute paths from the folder root so nothing is ambiguous.

### 6. Separate Mandatory Flow from Options
The EVD pipeline has 4 stages, but Stage 04 is optional. Make this clear:
- Stages 01-03: Always required, sequential
- Stage 04: Optional, only if you want a remediation plan

### 7. Use Visual Hierarchy
Maps should be scannable:
- Use headers to separate sections (FLOW, REFERENCES, DECISIONS, etc.)
- Use ASCII diagrams for stage connections
- Use indentation to show dependencies
- Keep descriptions short (one line when possible)

## What NOT to Do

- Don't summarize what each file contains. Map them instead.
- Don't explain HOW to do SQL. Point to the reference that teaches that.
- Don't write prose paragraphs. Use structured lists and diagrams.
- Don't hide optional paths. Make decisions explicit.
