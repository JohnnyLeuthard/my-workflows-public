# NOTES



---
## Layer 1

This is the `CLAUDE.md` file. Or whatevr you want to call it. 
This is read every time it is in ANY folder and AI enters it. Always reads it. 
Think of it as you copy and paste it in there every time you open it [CLAUDE].

Claude does this automaticaly but you could say to it [AI] read the Claude.md file. Immediaty will uderstand the process, the product what is going on, knows where to find each, what the file names are.

- This is the "Floor Plan"
- The file structure
- Where do you want to go
- What do you want to do
- This is the map
---
---
# Example:


## Folder Structure

```text
acme-devrel/
├── CLAUDE.md                 # You are here (always loaded)
├── CONTEXT.md                # Task router
│
├── writing-room/             # Write blog posts, tutorials, docs
│   ├── CONTEXT.md
│   ├── docs/                 # Voice guide, style rules, audience
│   ├── profiles/
│   │   ├── voice.md
│   │   ├── style-guide.md
│   │   └── audience.md
│   ├── drafts/               # Work in progress
│   └── final/                # Ready for production or publishing
│
├── production/               # Build things: videos, demos, samples
│   ├── CONTEXT.md
│   ├── docs/                 # Technical standards, components
│   │   ├── tech-standards.md
│   │   ├── component-library.md
│   │   └── design-system.md
│   │
│   ├── workflows/            # The 4-stage pipeline
│   │   ├── CONTEXT.md        # Pipeline routing
│   │   ├── 01-briefs/        # What to build (input)
│   │   ├── 02-specs/         # How to build it (plan)
│   │   ├── 03-builds/        # The actual work (execution)
│   │   └── 04-output/        # Finished deliverables
│   │
│   └── src/                  # Source code for demos/apps
│
├── community/                # Social posts, newsletters, events
│   ├── CONTEXT.md
│   ├── docs/
│   │
│   ├── guidelines/           # Platform specs, content calendar
│   │   ├── platforms.md
│   │   └── calendar-rules.md
│   │
│   ├── content/
│   │   ├── newsletters/
│   │   ├── social/
│   │   ├── events/
│   │   └── templates/
│   │
│   └── _examples/            # Teaching examples (not real work)
│
└── ...
```


---
# Layer 2

The actual rooms
- what folders to go to and what MD to read
The actual rooms
- Where the floor plan tells you to go

---
---
## Example:

## Quick Navigation

| Want to...                      | Go here                                      |
|--------------------------------|----------------------------------------------|
| Write a blog post or tutorial  | `writing-room/CONTEXT.md`                    |
| Learn the voice/style          | `writing-room/docs/voice.md`                 |
| Build a demo or video          | `production/CONTEXT.md`                      |
| Generate a build spec          | `production/workflows/CONTEXT.md`            |
| Look up components             | `production/docs/component-library.md`       |
| Create social content          | `community/CONTEXT.md`                       |
| Write a newsletter             | `community/CONTEXT.md`                       |
| Understand the template        | `START-HERE.md`                              |
---



# Layer 3
The acual workspace. The actual drectorty structure on the `file system`.
- where do you want newsletters to be
- Where do you want social to be








---
---
---
Usage example:
Type in something like...
"Go to writing room lets stat making something"
- it will go to the CONTEXT.md in the `writing room`
That context file 
- describes what it is,
- what to load and not load 
- Decribes the folder structue
- What the process is...
- MCP servers to use
- Skills to load

## Example:

| Skill / Tool         | When to Use                                                                 | How                                                                 |
|---------------------|------------------------------------------------------------------------------|----------------------------------------------------------------------|
| `/humanizer`        | **Before any draft moves to `final/`. Non-negotiable.** Catches AI-isms that `voice.md` might miss. | Run on the full draft. Apply suggestions. Re-check `voice.md` compliance after. |
| `/doc-coauthoring`  | **Long-form pieces only** (2000+ words). Tutorials, technical guides, whitepapers. | Activates a structured co-writing workflow. Not needed for blog posts or short pieces. |
| Web Search MCP      | **Research phase**. When the topic needs current data, competitor analysis, or technical accuracy verification. | Agent will search autonomously. Provide search terms or let it derive them from the topic. |









