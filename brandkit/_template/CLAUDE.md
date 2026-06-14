# Brand Kit Template — Setup Protocol

You are in the `_template/` workspace. This is a guided brand creation template that works for any brand — corporate, personal, product, or community.

## Purpose

Use this template to build a complete brand kit from scratch. Two modes:

- **AI-guided mode**: Say "set up my brand" and the AI walks you through [SETUP.md](SETUP.md), collects your answers, and populates the brand files.
- **Manual mode**: Fill in [SETUP.md](SETUP.md) yourself, then edit each brand file directly, replacing `{{PLACEHOLDER}}` tokens with your answers.

## How to Start a New Brand

1. Copy this entire `_template/` folder to a new sub-folder inside `brandkit/` (e.g., `personal-jane/` or `acme-product/`).
2. Add a row to [brandkit/CONTEXT.md](../CONTEXT.md) pointing to the new folder.
3. Choose AI-guided or manual mode and work through `SETUP.md`.
4. Remove all `{{PLACEHOLDER}}` tokens and placeholder language before using files in downstream workflows.

## AI-Guided Setup Protocol

When a user says "set up my brand," "walk me through brand setup," or similar, follow these steps in order.

### Step 1 — Brand Basics
Ask the following (one at a time, conversationally):

1. "What is the name of this brand?" *(A company, product, team, or your own name.)*
2. "Is this a corporate, personal, product, or community brand?"
3. "In one sentence — what does this brand do or offer?"
4. "Who is the primary audience? Be as specific as you can."
5. "Do you have a main URL or link for this brand?" *(Skip is fine.)*

### Step 2 — Personality and Voice
6. "Choose 3–5 words that describe how this brand should feel." *(Examples: bold, calm, playful, expert, warm, direct, minimal, creative, human, precise)*
7. "On a scale of 1 to 5, how formal or casual should the tone be?" *(1 = very formal, 5 = very casual)*
8. "Is there a brand whose voice you admire, and why?" *(Optional.)*

### Step 3 — Visual Identity
9. "Do you have a primary brand color? Give me a HEX, RGB, or just a color name — or say 'use defaults.'"
10. "Do you have a secondary or accent color?" *(Optional.)*
11. "Do you have a logo or wordmark yet?" *(Yes / No / In progress)*
12. "Is there a specific icon library you use?" *(Lucide, Heroicons, Material Symbols, etc. — or say 'use defaults.')*

### Step 4 — Finalize and Review
After collecting answers:
- Replace all `{{PLACEHOLDER}}` tokens in each brand file (01–06) with the user's answers.
- Where the user said "skip" or "use defaults," leave the default value in place.
- Present a summary table of what was set and what remains as a placeholder.
- Ask: "Anything you'd like to change before we're done?"

## Placeholder Format

Placeholders in all template files use this format:

```
{{TOKEN_NAME | Default value or guidance}}
```

When populating, replace the entire `{{...}}` block — token name, pipe, and default — with the real answer or the stated default.

## Rules

- Do not invent brand decisions on the user's behalf.
- Do not use fake names, fake metrics, or invented social proof.
- Do not commit private contact details, passwords, or proprietary assets to a public repo.
- Keep each brand file short enough to load as AI context in downstream workflows.
