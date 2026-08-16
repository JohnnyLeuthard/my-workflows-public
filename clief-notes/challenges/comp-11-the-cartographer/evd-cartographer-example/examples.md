# Examples — What Good Maps Look Like

## Example 1: EVD Pipeline Map

This is what the cartographer produces when handed the EVD folder.

### File: output/EVD_PIPELINE_MAP.md

```
# EVD Pipeline Map

## ENTER HERE

Read: `QUICKSTART.md` (2-minute overview)
Then: `USAGE.md` (detailed walkthrough)

## MANDATORY FLOW (Read in sequence)

### Stage 01: SQL Generation
Purpose: Translate your request into a SQL query
Entry: `stages/01_sql_gen/CLAUDE.md`
Output: `stages/01_sql_gen/output/query.sql`
Next: Human reviews the SQL, then Stage 02

### Stage 02: Data Fetch
Purpose: Execute the SQL and export results to CSV
Entry: `stages/02_data_fetch/CLAUDE.md`
Input: `stages/01_sql_gen/output/query.sql` (from Stage 01)
Output: `stages/02_data_fetch/output/vault_data.csv`
Next: Human reviews the data, then Stage 03

### Stage 03: Compliance Parsing
Purpose: Analyze vault data against naming standards
Entry: `stages/03_parsing/CLAUDE.md`
Input: `stages/02_data_fetch/output/vault_data.csv` (from Stage 02)
Output: `stages/03_parsing/output/compliance_report.md`
Next: Human reviews findings, then decide on Stage 04

### Stage 04: Remediation Planning (Optional)
Purpose: Turn findings into an action plan
Entry: `stages/04_remediation/CLAUDE.md`
Input: `stages/03_parsing/output/compliance_report.md` (from Stage 03)
Output: `stages/04_remediation/output/remediation_plan.md`
Next: Use for manual fixes or hand off to psPAS automation

## TASK-TO-REFERENCE MAP

Use this table to find the right documentation for your current task.

| Your Task | Read This |
|-----------|-----------|
| I need a pre-built query | `references/query_templates/_INDEX.md` |
| I'm writing a custom SQL query | `references/eva_query_patterns.md` |
| I need to understand the vault schema | `references/_Schema_EVD_CyberArk_DB.md` |
| I need to understand EAV properties | `references/_Schema_EVD_CAOObjectProperties_Table.md` |
| I'm confused about what a column means | `references/vendor_schema/_INDEX.md` |
| I want to know which safes to exclude | `references/system_safe_exclusions.md` |
| I need compliance naming rules | `references/naming_standards.md` |

## DECISION TREE: "What do I do now?"

**Q: I have a question but don't know which stage I'm in.**
A: Are you writing SQL? → Stage 01
   Did you run a query and have CSV results? → Stage 03
   Do you have findings and need a plan? → Stage 04

**Q: Can I skip Stage 04?**
A: Yes. Stages 01-03 are mandatory and sequential. Stage 04 is only if you want a pre-built remediation plan. You can take Stage 03 output directly to psPAS for execution.

**Q: I'm in Stage 02 and need to execute the query. What do I do?**
A: Run: `scripts/Invoke-EVDQuery.ps1` with the query from Stage 01 output.
   Load: `stages/02_data_fetch/CLAUDE.md` for detailed instructions.

**Q: My stage produced an output. What happens next?**
A: Human reviews the output. Only after approval does the next stage begin.
```

---

## Example 2: What Makes This Map Useful

**Without a map**, someone new asks:
- "Where do I start?" → Confusion
- "What's the output of Stage 02?" → Hunting through files
- "Which query template should I use?" → Wrong file
- "Can I skip a stage?" → Wrong answer

**With this map**, they ask the same questions and get:
- "Start with QUICKSTART.md" ✓
- "CSV file at stages/02_data_fetch/output/vault_data.csv" ✓
- "Check references/query_templates/_INDEX.md" ✓
- "Yes, Stage 04 is optional. Stages 01-03 are required." ✓

---

## Example 3: Map Format Principles

A good map:
1. **Scannable** — Headers and tables, not paragraphs
2. **Specific** — Points to exact files and folders, not vague areas
3. **Task-driven** — Organized by "what do I want to do" not "here are our files"
4. **Executable** — Someone can read it and immediately know their next action
5. **Visual** — Uses ASCII diagrams, indentation, and tables to show relationships
