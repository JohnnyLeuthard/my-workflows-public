# Explain It To Me: What Is ICM?

*A plain-language guide for someone brand new to AI and ICM. Self-contained — you don't need
any other document to understand this one.*

---

## The One-Sentence Version

ICM is a way of organizing folders and plain text files so that an AI agent always knows where
it is, what to do, and what rules to follow — **the folder structure is the program**.

---

## The Assistant With No Memory

Imagine you hired a very capable assistant, but with one catch: they have no memory. Every time
they sit down at the desk, they know only what's written on the papers in front of them.

That's an AI agent. ICM — **Interpretable Context Methodology** (also called the Model
Workspace Protocol, from Jake Van Clief and David McDermott) — is simply a disciplined way of
**arranging the papers on the desk**, so the assistant always finds the answers to five
questions, in order:

| # | Question | Answered by |
|---|----------|-------------|
| 0 | *Where am I?* | `CLAUDE.md` / `AGENTS.md` — "you're in the invoice-review workspace, here's what it's for" |
| 1 | *Where do I go?* | `CONTEXT.md` — a router table: "for this kind of request, go to that folder" |
| 2 | *What do I do here?* | Each stage folder's own `AGENTS.md` — "read this file, do this work, write that file" |
| 3 | *What rules apply?* | `reference/` — style guides, quality bars, checklists you can edit |
| 4 | *What am I working with?* | `input/` and `output/` — the actual materials and results |

Those numbers are ICM's **layers**. An agent starts at layer 0 and reads its way down, loading
only what the current request needs. No code. No app. Just folders and markdown files you can
open, read, and change yourself.

---

## A Tour of a Typical ICM Workspace

```
my-workspace/
├── CLAUDE.md        ← one line: "go read AGENTS.md" (the doorknob)
├── AGENTS.md        ← identity: what this workspace is and how to behave (layer 0)
├── CONTEXT.md       ← the router: request → the right folder (layer 1)
├── 01-some-stage/   ← a stage: one folder, one job, one AGENTS.md (layer 2)
├── 02-next-stage/   ← another stage
├── reference/       ← the rules: standing, human-editable (layer 3)
├── input/           ← what you feed it (layer 4)
└── output/          ← what it produces (layer 4)
```

A few ideas make this work:

- **One folder, one job.** A stage folder does one thing. Its `AGENTS.md` says what to read,
  what to do, and what to write. Complex work is a chain (or fan-out) of simple stages.
- **The router keeps context small.** The agent doesn't read everything — `CONTEXT.md` sends
  it only where the request belongs. A workspace can grow large without the agent drowning.
- **Rules live in files you edit.** Want a different tone, a stricter quality bar, an extra
  check? Edit the file in `reference/`. The behavior changes; no stage logic is touched.
- **State lives on disk, not in the AI's head.** Every meaningful step writes a file. If a
  session dies mid-job, the next session reads the files and continues. Nothing important ever
  exists only in a conversation.
- **Underscore folders are scaffolding.** `_template/`, `_design/`, `_setup/`, `_tmp/` — the
  underscore means "not a work stage": templates to copy, records to keep, scratch to ignore.

---

## Why Plain Markdown?

Because you can **read it**. Every instruction the agent follows is a file you can open, audit,
and edit — that's the "interpretable" in the name. There is no hidden prompt, no framework
buried in code. It also means:

- **Any AI can run it.** Claude today, something else tomorrow — anything that reads files.
- **You can take over at any point.** The agent and you work on the same files; there is
  nothing it can do that you can't do by hand.
- **It versions beautifully.** Folders of markdown fit git, backups, and sharing — the whole
  "program" is diffable text.

---

## How to Read Any ICM Workspace

Dropped into one you've never seen? The chain is always the same:

1. Open `CLAUDE.md` — it points you to `AGENTS.md`.
2. Read `AGENTS.md` — now you know what the workspace is and its ground rules.
3. Read `CONTEXT.md` — now you know what lives where and where your request goes.
4. Follow the route, and read that folder's `AGENTS.md` before touching anything.

That's it. That's also exactly what the AI does — which is the point: **you and the agent
navigate by the same map.**
