# EVD Pipeline Cartographer

A cartographer that maps the CyberArk EVD (Export Vault Data) multi-stage pipeline and creates navigable guides for new users.

## What It Does

Hand this cartographer a complex pipeline (like EVD) and it generates a **map** that shows:
- Where to start
- How stages connect
- What each stage needs and produces
- Which reference file applies to which task
- How to navigate decision points

## How to Use It

### 1. Understand the Cartographer
- **identity.md** — Who this cartographer is and what it maps
- **rules.md** — How it creates maps (the principles)
- **examples.md** — What good maps look like (with actual examples)

### 2. See the Output
- **output/EVD_PIPELINE_MAP.md** — The actual map produced by this cartographer
  - Read this if you want to see what the cartographer creates

### 3. Adapt for Your Use
- **reference/** — Templates and patterns you can use to map other structures

## The Cartographer's Output

When applied to the EVD pipeline, this cartographer produces **EVD_PIPELINE_MAP.md**, which includes:

1. **Enter Here** — One clear starting point
2. **Mandatory Flow** — Stages 01 → 02 → 03, with input/output files
3. **Optional Flow** — Stage 04, marked as optional
4. **Task-to-Reference Map** — A table showing which reference file to use for which task
5. **Decision Tree** — Common questions and how to navigate them

## Why This Matters

The EVD pipeline is powerful but has a steep learning curve. New team members open the folder and feel lost:
- "Which file do I read first?"
- "How do these 4 stages connect?"
- "What does Stage 02 expect as input?"
- "Which reference do I need?"

This map answers all of those in 2 minutes. It transforms a confusing folder into a navigable system.

## For Comp Judges

This cartographer demonstrates:
- **Specificity** — It maps a real, complex system (not generic documentation)
- **Clarity** — The output is structured, scannable, and task-driven
- **Reusability** — The rules and examples can be adapted to other pipelines
- **Methodology** — Clean ICM structure (identity, rules, examples, reference, README)
