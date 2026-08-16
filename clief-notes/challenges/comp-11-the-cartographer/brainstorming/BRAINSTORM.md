# Challenge 11: The Cartographer — Brainstorming

## Understanding the Challenge

**Core Task:** Build a system that walks a folder structure and creates a navigable map.

The cartographer should:
- Navigate any organized collection (codebase, docs, files, projects)
- Generate an index showing what's there and how pieces connect
- Work for both humans and AI readers
- Reveal structure, NOT flatten/summarize

Key distinction: Like a floor plan showing how to move through space, not a description of the space.

## Domain Options to Explore

### Technical
- **Codebase mapper** — For a specific repo type (React, Python, Go), map module hierarchy and dependencies
- **API documentation cartographer** — Map endpoint structures, auth flows, patterns
- **Database schema mapper** — Visual overview of tables, relationships, data flows

### Business
- **Deal flow mapper** — Map companies, stages, decision trees for VC/startup
- **Client project mapper** — Map deliverables, timelines, dependencies across complex projects
- **Process mapper** — Map specific business workflows (hiring, sales, onboarding)

### Creator
- **Content series mapper** — Show how your writing/videos connect, prerequisites, progression
- **Research project mapper** — Map papers, findings, open questions, synthesis
- **Portfolio mapper** — Navigate past work by theme, skill, impact

## What Does a Map Actually Look Like?

**Simple answer:** Imagine you walk into a huge library with 1,000 books scattered around. You get lost.

The cartographer creates a **guide** that says:
- "Section A has books about history — they're on shelves 1-5, in this order"
- "Section B has books about science — they're on shelves 6-10"
- "Section C has reference books that support both A and B — they're over here"
- "If you want to learn history, start with Book X, then Book Y, then Book Z"

**The map is usually ONE file** (or a few connected files) that **shows what exists and how to navigate it**.

---

## ICM Connection (Interpretable Context Methodology)

ICM says: "Folders = architecture. Each file does one job."

The cartographer READS that folder structure and creates a guide showing:
- What each folder/file does
- How they relate (A depends on B, C supports both)
- The "story" of navigating from beginning to end

**Example:**

You have a folder like:
```
my-project/
  ├─ identity.md (WHO are we)
  ├─ rules.md (HOW we work)
  ├─ examples.md (WHAT good looks like)
  └─ reference/
     ├─ template-1.md
     ├─ template-2.md
```

The cartographer creates a **MAP.md** that says:
- "Start here: identity.md tells you what this project is"
- "Then read rules.md to understand the system"
- "examples.md shows you how it works in practice"
- "reference/ has templates you'll use"

**That MAP.md = the cartographer's output.**

---

## For Your Comp Entry

You'd build a tool that:
1. Takes any folder (with multiple files/subfolders)
2. **Analyzes** it (reads structure, understands how files relate)
3. **Creates a MAP.md** that helps someone new understand the terrain

The map is the thing you're building. One or a few files that navigate the reader through the structure.

---

## Next Steps

1. What body of work do you actually have that needs mapping?
2. Who's the reader? (Developers? Stakeholders? Your future self?)
3. What's hard about navigating it NOW?

---

## KEY INSIGHT: ICM Connection Reframed

**The user caught something important:**

ICM IS about setting up folder structure and navigation. You can't build an ICM system without thinking about how someone will navigate it.

So the question is: **What does the Cartographer ADD?**

**Two possible interpretations:**

### Option 1: Document & Navigate Existing Chaos
- You have a messy project/codebase/pile of files (NOT yet organized in ICM)
- The cartographer ANALYZES that chaos
- Creates a MAP showing "here's how this COULD be organized" or "here's what's actually here and how it connects"
- That map helps you either understand the mess OR build the ICM structure to organize it

### Option 2: Create Navigation Guides for ICM Structures
- You already have an ICM-organized folder (with identity.md, rules.md, reference/, etc.)
- The cartographer reads that structure
- Creates a navigation guide/INDEX that helps people (and AI) quickly understand:
  - What files to read first
  - How files connect
  - Where specific things are
  - The "path" through the structure

**Likely answer:** The cartographer is the tool that helps communicate/navigate an ICM structure to newcomers. It's the "tour guide" for an already-built ICM system.

---

## CONCRETE EXAMPLE: EVD Cartographer

The EVD pipeline has 4 sequential stages:
- Stage 01: SQL Gen (translate request → SQL query)
- Stage 02: Data Fetch (run query → CSV results)
- Stage 03: Compliance Parsing (analyze CSV → compliance report)
- Stage 04: Remediation (findings → action plan)

**Current problem:** Someone opens the EVD folder. Questions:
- "Where do I start?"
- "How do these stages connect?"
- "What do I read first?"
- "What files feed into what?"
- "If I want to do X, which stage do I need?"

**What a Cartographer Map would show:**

```
EVD PIPELINE MAP

ENTRY: Read QUICKSTART.md first

FLOW (read in order):
1. USAGE.md — full pipeline explanation
2. Pick your use case → See query_templates/_INDEX.md
3. Stage 01 — Write SQL (load stages/01_sql_gen/CLAUDE.md)
   └─ Output: stages/01_sql_gen/output/query.sql
4. Stage 02 — Execute query (load stages/02_data_fetch/CLAUDE.md)
   └─ Output: stages/02_data_fetch/output/vault_data.csv
5. Stage 03 — Check compliance (load stages/03_parsing/CLAUDE.md)
   └─ Output: stages/03_parsing/output/compliance_report.md
6. Stage 04 — Create remediation plan (load stages/04_remediation/CLAUDE.md)
   └─ Output: stages/04_remediation/output/remediation_plan.md

KEY REFERENCES BY TASK:
- Writing SQL? See references/eva_query_patterns.md
- Need a pre-built query? See references/query_templates/_INDEX.md
- Check database schema? See references/_Schema_EVD_CyberArk_DB.md
- Understand EAV properties? See references/_Schema_EVD_CAOObjectProperties_Table.md
- What columns mean? See references/vendor_schema/_INDEX.md

DEPENDENCIES:
- Stage 02 needs Stage 01 output
- Stage 03 needs Stage 02 output
- Stage 04 needs Stage 03 output
```

**That map = what a Cartographer creates.** Not the folder structure (that already exists). Not a summary. But a **navigable guide** that shows:
- Where to start
- How pieces connect
- What to read when
- Where data flows

---

## Working Example: EVD Cartographer

**Created in:** `evd-cartographer-example/`

**What it contains:**
- `identity.md` — Who this cartographer is (maps multi-stage pipelines)
- `rules.md` — How it creates maps (7 mapping principles)
- `examples.md` — What good maps look like (with actual examples from EVD)
- `README.md` — How to use this cartographer
- `output/EVD_PIPELINE_MAP.md` — The actual map the cartographer produces

**The key file:** `output/EVD_PIPELINE_MAP.md`

This is what someone sees when they want to understand the EVD pipeline. It shows:
- Enter here (start with QUICKSTART.md)
- The pipeline flow (Stage 01 → 02 → 03 → optional 04)
- What each stage needs and produces
- A task-to-reference table (if you need X, read this file)
- A decision tree (common questions and how to navigate)
- Common questions answered

**This is the cartographer's output.** Someone opens it, reads it in 5 minutes, and understands how to navigate the entire EVD system.

---

## Decision Log

**Key insights:**
1. The cartographer challenge = build a system that creates navigation maps
2. A map is NOT a summary; it's a guide showing how to navigate
3. For your comp entry:
   - Build an ICM folder (identity, rules, examples, reference, README)
   - Your cartographer maps a specific domain you actually use
   - Create a concrete example map showing what it produces
   - Show it working on real data/structure

**Decision:** Use EVD as the example for now to understand what this looks like. If you like it, this becomes your comp entry. If not, you can pick a different domain.
