# Content Lab — Build Spec

**Status**: Design locked (2026-07-05). All open questions were answered with the human and folded
into this spec; `DECISIONS.md` alongside this file records the reasoning and rejected
alternatives. Ready to build on the human's go.

**This folder is also a drop-in build seed**: copy `_design/` into any workspace and ask the agent
to build it out — the **Build & Integration Protocol** section at the end tells the builder where
to build and how to plug the lab into the surrounding workspace.

---

## Goal

Rebuild the social-media workspace as a **blog-first content lab**. One pipeline turns supplied
material — the human's own text, links, research documents, media, and steering instructions —
into a comprehensive, cited **blog post**, then **hard-stops**. The finished post and its
supporting record (sources, assets, repurposing notes) become the hub. Platform **channels** —
LinkedIn and a Remotion video spec in v1; Instagram, YouTube, and eventually a faceless-YouTube
spec generator later — are the spokes: separate mini-pipelines that rewrite a closed post for
their platform, run only when the human explicitly asks.

This is the **hub-and-spoke** pattern: the pipeline shape of each leg comes from the teaching
lab (numbered stages, per-job outputs), and the record-keeping comes from the debate lab
(per-job `STATUS.md`, human checkpoints with the `> COMMENT:` convention, the job folder as the
permanent record). Everything the blog collects is structured so a downstream channel can build
its output — a LinkedIn post, a Remotion scene list, a YouTube script spec — without revisiting
the raw material.

Research and fact-checking are **not** part of this lab (see requirement 8): they happen before
or beside it, by whatever means the human chooses, and their results arrive as input files.

## Core Requirements

### 1. Per-post input folders, started from a template

Each post begins as a folder under `input/` — the staging area. The **job name is the folder
name** (`input/zero-trust-myths/` → `output/zero-trust-myths/`), lowercase with hyphens. Input
stays in `input/` while the post is live; when the post closes, the folder **moves** into the
post record at `output/<post>/input/` — the record carries its own source material.

**`input/_template/` is a ready-to-copy framework** for starting a post — same copy/rename
pattern as a persona template, underscore marks it as scaffolding, and it is never processed as
a post:

| File | Purpose |
|------|---------|
| `HOW-TO-START.md` | Steps to start a post: copy, rename, fill in, say "write this post" (deleted from the copy) |
| `instructions.md` | **Required** — the steer for this post: angle, audience, required points, steps to take, and what to do with each supplied file |
| `my-text.md` | Text the human already wrote — fragments, an outline, or the whole post if it exists |
| `links.md` | URLs the human already has, each with a note on why it matters |
| `rules.md` | Post-specific rules (tone, length, do/don't) — supplements, and where it conflicts overrides, the standing `reference/` rules |
| `research-request.md` | The outside-research handoff point (see requirement 8) — what needs researching or fact-checking, who/what will do it, and where returned material gets dropped in this folder |

Verbatim skeletons for all six files are in the **Template Scaffolds** section below.

Beyond the template files, anything else can be added: research documents, fact-check results,
notes, images, video links. Empty template files are fine — the intake stage treats an empty
file as "nothing supplied," never as an error. Only `instructions.md` must have content.

### 2. The post record — one subfolder per post

Every post gets its own subfolder **`output/<post>/`, named identically to its `input/<post>/`
folder**, so any number of posts can be in process side by side without collisions. The folder
is the complete, permanent, self-contained record of the post:

```
output/<post>/
├── STATUS.md            ← snapshot + event log (see requirement 6)
├── sources.md           ← every URL/citation from the input, organized by what it supports
├── assets/              ← images, video links, captions, alt text
├── drafts/              ← draft-1.md, draft-2.md … (one per loop; checkpoint comments live in these)
├── blog-post.md         ← the final post (once written, the post is closed)
├── repurpose-notes.md   ← structured seed for downstream channels (see requirement 4)
├── input/               ← the staged input folder, moved here at close
└── channels/            ← channel outputs, added later on request (see requirement 5)
    └── <channel>/
```

Once `blog-post.md` exists, the post is **closed**: the blog pipeline never reruns under the
same name (a rework is a new post, e.g. `zero-trust-myths-v2`), and only channel passes may add
to the folder — under `channels/`, never touching the post itself. This protects a published
post from ever silently changing.

### 3. The blog pipeline — stages, loop, and human checkpoint

The pipeline runs these stages (each a numbered folder with its own `AGENTS.md`, teaching-lab
style):

1. **`01-intake/`** — verify the input folder: `instructions.md` exists and has content; list
   what was supplied and what is empty; create `output/<post>/` and `STATUS.md`. If
   `instructions.md` (or the prompt) asks for research or fact-checking, do it now per
   requirement 8 and file the results into the input folder before proceeding.
2. **`02-organize/`** — build the record's working files from the input: `sources.md` (every
   link and citation, grouped by the claim or section it supports) and `assets/` (every image
   and video reference, with captions). **Flag** gaps, unsupported claims, and contradictions
   for the human in a `## Flags` section of `sources.md` — flagging, not fact-checking; the lab
   never invents verification.
3. **`03-draft/`** — write `drafts/draft-N.md` per `reference/blog-format.md`, the standing
   `reference/` rules, and the post's own `rules.md`. Every factual claim in the draft must
   trace to `sources.md`; claims with no source are marked `[UNSOURCED]` inline so the human
   can't miss them.
4. **Human checkpoint — the pipeline stops here.** The human reviews the draft and `sources.md`
   for accuracy, adds comments directly in the draft using `> COMMENT:` blockquote lines under
   the point being addressed, then gives one of two verdicts:
   - **finalize** → stage 5.
   - **loop** → the human adds or adjusts input material (more research results, new links,
     edited `my-text.md`) and/or steers via comments; the pipeline re-runs from `02-organize/`
     (updating, not rebuilding, `sources.md`) and produces `drafts/draft-N+1.md`. Loops are
     unlimited but counted in `STATUS.md`; earlier drafts are never deleted.
5. **`04-final/`** — apply the checkpoint comments, polish, and write `blog-post.md`; write
   `repurpose-notes.md` (requirement 4); append a brand-notes entry (requirement 9); move
   `input/<post>/` into `output/<post>/input/`; update `STATUS.md` and the tracker
   (requirement 6). The post is now closed.

**Hard stop: the pipeline never continues into a channel.** Finishing the blog post ends the
run, always. Channels run only on a later, explicit request (requirement 5).

Prerequisite checks: every stage verifies its upstream artifact exists before working (intake →
input folder with instructions; organize → intake logged in `STATUS.md`; draft → `sources.md`;
final → a checkpoint verdict of finalize). On failure — re-run the missing step once, then stop
and report; never write from a guess (auto-heal once, then stop).

### 4. Data collected for downstream reuse — `repurpose-notes.md`

The record must let a channel build its output **without revisiting the raw input**. Written at
finalize, `repurpose-notes.md` captures, in this order:

1. **Core message** — the post's thesis in one or two sentences.
2. **Key claims** — each with its citation from `sources.md` (these become LinkedIn hooks,
   video narration lines, YouTube script beats).
3. **Stats & numbers** — every figure in the post, with source.
4. **Hooks & quotable lines** — sentences that stand alone (openers, pull-quotes, captions).
5. **Visual suggestions** — which assets in `assets/` fit which claim; described visuals that
   don't exist yet.
6. **Video treatment** — a rough scene-by-scene idea: what to show, what to say, drawn from the
   claims above (this is the seed a Remotion or YouTube spec grows from).
7. **Audience & tone notes** — who this was written for, per the brief and `rules.md`.

A skeleton is in the Template Scaffolds section. `sources.md` and `assets/` follow the same
principle: structured enough that a channel stage can pull what it needs by section name.

### 5. Channels — separate mini-pipelines, run on request only

Each channel is a self-contained folder under `channels/`, with its own `AGENTS.md` and numbered
stages, teaching-lab style. A channel:

- runs only on an explicit request naming a **closed** post ("make a LinkedIn post from
  `zero-trust-myths`") — it refuses posts that aren't closed;
- reads **only** the post's record (`blog-post.md`, `repurpose-notes.md`, `sources.md`,
  `assets/`) plus the shared `reference/` files and the brand chain (requirement 7) — never the
  raw input, never another channel's output;
- writes everything into `output/<post>/channels/<channel>/` — the record stays the one home;
- on publish, updates the post's `STATUS.md`, adds a tracker row (requirement 6), and appends a
  brand-notes entry (requirement 9).

**v1 ships two channels, built and ready:**

- **`channels/linkedin/`** — stages: `01-adapt/` (turn the post into a LinkedIn-length piece
  per `reference/platform-rules.md`: hook from repurpose-notes, tightened body, hashtags, a
  link back to the published blog) → `02-review/` (human checkpoint, same `> COMMENT:`
  convention) → `03-publish/` (final text ready to paste; record the publish date and URL).
- **`channels/remotion/`** — stages: `01-spec/` (write a Remotion video spec per
  `reference/remotion-spec-format.md`: scene list with durations, on-screen text and visuals
  drawn from `assets/` and the visual suggestions, narration lines drawn from the key claims,
  and the data/props each scene needs) → `02-review/` (human checkpoint) → `03-final/` (the
  locked spec, ready to hand to a Remotion project). The deliverable is a **spec document**,
  not rendered video — rendering happens outside the lab.

**Adding a channel is a recipe, not a rebuild**: copy an existing channel folder (LinkedIn is
the reference shape), rename it, rewrite its stage instructions for the platform, add any
platform rules to `reference/platform-rules.md`, and add a routing row to the lab's
`CONTEXT.md`. Instagram and YouTube are the named next channels; the eventual faceless-YouTube
spec generator is a channel too — same pattern, its spec format file added to `reference/` when
it arrives.

### 6. Tracking — per-post STATUS.md plus a config-driven tracker

**`output/<post>/STATUS.md` is the source of truth** for one post, debate-lab style, updated at
every stage transition and every channel event:

- **Snapshot** (top, overwritten): current stage, loop count, checkpoint awaited or verdict
  given, and a per-platform table — channel, status (not started / drafted / published), date,
  URL.
- **Event log** (below, append-only, one line per event): intake, organize, each draft, each
  checkpoint verdict, finalize, each channel run, each publish. A fresh session resumes any
  post from this file alone.

**The tracker is the cross-post view**, and its shape is configuration, not code:
`_config/tracker-settings.md` defines the rotation period (default **monthly**), the file-name
pattern (default `YYYY-MM.md`), and the folder (default `tracker/`). Changing any of them is a
one-line edit; every stage that writes tracker rows reads this file first. `tracker/index.md`
lists the tracker files with a one-line summary each. A tracker row is one publish event: date,
post, platform, link. Rows are appended at blog close (platform "blog", if the human records
where it was published) and at every channel publish.

### 7. Brand chain — brandkit hook with a generic fallback

Writing stages resolve brand voice through a three-step chain, and **no stage may fail or stall
for lack of a brand**:

1. **`_config/brandkit.md`** — in v1 a placeholder pointing nowhere. When the human later fills
   it in (pointing at a brandkit with several brand styles), writing stages consult it, and a
   post's `rules.md` or `instructions.md` may name which brand style applies.
2. **`reference/brand-voice.md`** — the standing voice file (carried forward from the existing
   workspace where it fits). Used whenever the brandkit is unset or names no style for this post.
3. **Generic** — if both are empty, write in a clean, professional, platform-appropriate style
   and note in `STATUS.md` that no brand was applied.

The brandkit stays a *pointer* — no standing cross-project connection; the lab never reaches
into another workspace uninvited.

### 8. Research hook — generic, no dependency

By default the pipeline works from supplied material only. Research and fact-checking are
available two ways, **both user-triggered**:

- **The agent researches directly when asked**: if `instructions.md` or the spoken prompt says
  "research X" or "fact-check Y", the agent does that work itself (web search, reading the
  supplied links, whatever the request needs) during `01-intake/`, and files the results into
  the input folder as new files — from then on they are ordinary supplied material, cited
  through `sources.md` like everything else.
- **The user routes it through an external workflow** via `research-request.md`: the file names
  what to investigate, who or what will do it (any workflow, any tool — the lab does not care),
  and where the returned material should be dropped in the input folder.

The spec names no specific research system and depends on none — the lab works standalone. A
dedicated research/fact-checking workspace is a separate future project; when it exists, its
outputs arrive through the same two doors.

### 9. Brand learning loop — low-token by design

`reference/brand-notes.md` is an **append-only inbox** of brand observations. Every time an
artifact is finished — blog finalized, LinkedIn post published, Remotion spec locked — the
closing stage appends **one short entry** (a few lines, dated, naming the post and channel):
voice and phrasing choices the human approved, corrections the human made at the checkpoint,
topics and angles that worked.

On request ("update my brand"), the agent reads **only this file**, merges its entries into
`reference/brand-voice.md` (or the brandkit, once it exists), replaces the entries with a
`Last merged: <date>` stamp, and reports what changed. The brand improves continuously without
ever rereading the whole structure — the notes file is the only thing consumed, and it is
cleared on every merge, so it stays small.

### 10. Conventions carried over

- Front-door chain: `CLAUDE.md` → `AGENTS.md` → `CONTEXT.md` router; humans get `HOW-TO-USE.md`.
- Per-job outputs under `output/<post>/`, mirroring the input folder name; never write into
  `output/` root.
- Reference files are standing and human-editable; behavior changes are made by editing
  reference/config files, never by rewriting stage logic. The v1 reference set:
  `brand-voice.md`, `platform-rules.md`, `blog-format.md`, `citation-rules.md`,
  `remotion-spec-format.md`, `brand-notes.md` — carrying forward content from the existing
  workspace's `reference/` where a file matches.
- Prerequisite checks before every stage; auto-heal once, then stop and report.
- Resumption: any session touching an existing post reads its `STATUS.md` first and continues
  from what the files show — state lives on disk, not in a session.

### 11. `HOW-TO-USE.md` — the human's manual

Ships at the lab root, written in plain language for a person, never routed through by agents.
Four sections, in order:

1. **What this is** — the blog-first idea in everyday words: material goes in a folder, the lab
   organizes and drafts, you check the facts and steer, it finishes the post and stops; later
   you can ask for platform versions, and everything is tracked.
2. **Your first post** — point at the shipped sample and give the exact thing to say ("write
   the post in `input/sample-…`"), so the first run tests the machine, not the reader's setup.
3. **Step by step** — copy `input/_template/`, what each file is for, how to trigger research
   (ask directly, or hand off `research-request.md`), what the checkpoint looks like and how to
   respond (`> COMMENT:` lines, then *finalize* or *loop*), where the final post and record
   land, how to request a channel pass, where publish dates are tracked.
4. **Quick recipes** — add a channel; change tracker rotation (`_config/tracker-settings.md`);
   resume an interrupted post (just ask — state is in `STATUS.md`); run another platform pass
   on an old post; "update my brand" (the brand-notes merge); point the lab at a brandkit.

Kept-current rule: any design change that alters how the human interacts with the lab must
update `HOW-TO-USE.md` in the same change.

### 12. Shipped sample input

The lab ships with one prefilled post folder, `input/sample-passwordless-myths/` (topic
illustrative — the builder may choose another evergreen, non-controversial tech topic): a copy
of the template filled in end-to-end — real `instructions.md` steer, a few paragraphs of
`my-text.md`, three or four genuine `links.md` entries, one line in `rules.md`, and a filled-in
`research-request.md` example marked "already satisfied — results below" so the handoff pattern
is demonstrated without requiring live research. The sample doubles as the worked example the
template files refer to.

## Template Scaffolds

Verbatim skeletons — where the builder creates these files, copy them; placeholder text in
`<angle brackets>` is guidance for the human, kept in the shipped files.

### `input/_template/HOW-TO-START.md` *(deleted from every copy)*

```markdown
# How to Start a Post

1. Copy this whole `_template/` folder to `input/<your-post-name>/` — lowercase-with-hyphens;
   the folder name becomes the post's name everywhere.
2. Fill in `instructions.md` (required). Everything else is optional — empty files are fine.
3. Add anything extra to the folder: research docs, fact-check results, notes, images.
4. Delete this file from your copy.
5. Say: "write the post in input/<your-post-name>/".
```

### `input/_template/instructions.md`

```markdown
# Instructions — <post name>

## What this post is about
<the topic and the angle you want>

## Audience
<who this is for>

## Must include
<points, arguments, or sections that must appear>

## Steps to take
<anything you want done before drafting — e.g. "research X", "fact-check the claims in
my-text.md", "summarize the PDF in this folder". Delete if none.>

## What to do with each file
<e.g. "my-text.md is a rough outline — expand it", "the notes file is background only">
```

### `input/_template/my-text.md`

```markdown
# My Text

<anything you already wrote: fragments, an outline, or the full post. Leave empty if nothing.>
```

### `input/_template/links.md`

```markdown
# Links

| URL | Why it matters |
|-----|----------------|
| <url> | <what it supports or shows> |
```

### `input/_template/rules.md`

```markdown
# Rules for This Post

<post-specific rules: tone, length, do/don't, brand style to use. These supplement the standing
reference/ rules and win where they conflict. Leave empty to use the defaults.>
```

### `input/_template/research-request.md`

```markdown
# Research Request

<the outside-research handoff. Fill in when something needs researching or fact-checking; hand
it to whatever will do the work — another workflow, another tool, or just tell the AI here to
"go research this". Leave empty if the material in this folder is complete.>

## What needs researching or fact-checking
-

## Who/what will do it
<e.g. "the AI, directly" / "my research workspace" / "me, manually">

## Where results go
Drop returned files into this folder and list them here:
-
```

### `output/<post>/STATUS.md`

```markdown
# STATUS — <post>

## Snapshot
- Stage: <01-intake | 02-organize | 03-draft | awaiting checkpoint | 04-final | closed>
- Loop count: <n>
- Awaiting: <e.g. "human checkpoint on drafts/draft-2.md" | "nothing — closed">

| Channel | Status | Date | URL |
|---------|--------|------|-----|
| blog    | <not started / drafted / published> | | |

## Event Log
- <YYYY-MM-DD> intake complete: <files supplied / empty>
- …
```

### `output/<post>/sources.md`

```markdown
# Sources — <post>

## <claim or section it supports>
- <url or document in input/> — <what it establishes>

## Flags
- <gaps, unsourced claims, contradictions the human should resolve>
```

### `output/<post>/repurpose-notes.md`

```markdown
# Repurpose Notes — <post>

## Core message
## Key claims (with citations)
## Stats & numbers (with sources)
## Hooks & quotable lines
## Visual suggestions
## Video treatment (scene-by-scene idea)
## Audience & tone notes
```

### `_config/tracker-settings.md`

```markdown
# Tracker Settings

Read by every stage that writes tracker rows. Edit values; do not rename keys.

- rotation: monthly            # how often a new tracker file starts (monthly | quarterly | yearly | never)
- file-pattern: YYYY-MM.md     # tracker file names; must match the rotation period
- folder: tracker/             # where tracker files and index.md live
```

### `tracker/<period>.md` (e.g. `tracker/2026-07.md`)

```markdown
# Tracker — <period>

| Date | Post | Platform | Link |
|------|------|----------|------|
```

### `reference/brand-notes.md`

```markdown
# Brand Notes (append-only inbox)

One short entry per finished artifact. Merged into brand-voice.md on "update my brand", then
cleared. Last merged: <date | never>.

---

## <YYYY-MM-DD> — <post> — <blog | linkedin | remotion | …>
- Approved: <voice/phrasing choices the human kept>
- Corrected: <what the human changed at the checkpoint>
- Worked: <topics, angles, hooks that landed>
```

## Proposed Folder Structure

```
social-media/                        ← or whatever folder the seed lands in
├── CLAUDE.md                        ← pointer to AGENTS.md
├── AGENTS.md                        ← workspace identity (Layer 0): blog-first hub-and-spoke
├── CONTEXT.md                       ← router (Layer 1): new post → blog pipeline; channel pass → channels/<name>; design → _design/
├── HOW-TO-USE.md                    ← the human's manual (people read it; agents never route through it)
│
├── blog/                            ← Layer 2: the hub pipeline
│   ├── 01-intake/AGENTS.md          ← verify input, run requested research, create the record
│   ├── 02-organize/AGENTS.md        ← build sources.md + assets/, flag gaps
│   ├── 03-draft/AGENTS.md           ← draft-N.md; stop at the human checkpoint
│   └── 04-final/AGENTS.md           ← apply comments, blog-post.md, repurpose-notes.md, close
│
├── channels/                        ← Layer 2: the spokes (run on request only, closed posts only)
│   ├── linkedin/
│   │   ├── AGENTS.md
│   │   ├── 01-adapt/AGENTS.md
│   │   ├── 02-review/AGENTS.md
│   │   └── 03-publish/AGENTS.md
│   └── remotion/
│       ├── AGENTS.md
│       ├── 01-spec/AGENTS.md
│       ├── 02-review/AGENTS.md
│       └── 03-final/AGENTS.md
│
├── reference/                       ← Layer 3, standing rules (all human-editable)
│   ├── brand-voice.md               ← carried forward from the legacy workspace where it fits
│   ├── brand-notes.md               ← append-only brand inbox (requirement 9)
│   ├── platform-rules.md            ← per-platform constraints (carried forward + extended)
│   ├── blog-format.md               ← blog post structure, citation style in-text
│   ├── citation-rules.md            ← what counts as a source, how claims map to sources.md
│   └── remotion-spec-format.md      ← what a Remotion video spec must contain
│
├── _config/                         ← Layer 3, machine-read settings
│   ├── tracker-settings.md          ← rotation, file pattern, folder (requirement 6)
│   └── brandkit.md                  ← placeholder pointer; generic fallback applies while empty
│
├── tracker/                         ← Layer 4: cross-post publish log
│   ├── index.md                     ← lists tracker files, one line each
│   └── 2026-07.md …                 ← per tracker-settings.md
│
├── input/                           ← Layer 4: staging — one folder per LIVE post
│   ├── _template/                   ← ready-to-copy framework (requirement 1; never processed)
│   └── sample-passwordless-myths/   ← shipped worked example (requirement 12)
│
├── output/                          ← Layer 4: one subfolder per post = the permanent record
│   └── <post>/                      ← see requirement 2 for contents
│
├── _archive/                        ← created at build only if legacy folders exist (see Build Protocol)
└── _design/                         ← this seed (CLAUDE/AGENTS/CONTEXT + SPEC.md + DECISIONS.md); not part of the run
```

## Flow Summary

1. Human copies `input/_template/` to `input/<post>/`, fills in `instructions.md` and whatever
   else exists, and gathers research beforehand if needed — either by telling the agent to
   research (requirement 8a) or by handing `research-request.md` to any external workflow (8b).
2. "Write this post" → router sends the run to `blog/01-intake/`: verify input, run any
   requested research into the input folder, create `output/<post>/` + `STATUS.md`.
3. `02-organize/` builds `sources.md` and `assets/`, flagging gaps and unsourced claims.
4. `03-draft/` writes `drafts/draft-1.md`, every claim traced to a source, then **stops**.
5. **Human checkpoint**: review draft + sources, add `> COMMENT:` lines, verdict —
   **finalize** (→ 6) or **loop** (add/adjust input material and steer → back to step 3 via a
   refreshed organize pass; loop count logged).
6. `04-final/` applies comments, writes `blog-post.md` and `repurpose-notes.md`, appends a
   brand-notes entry, moves the input folder into the record, updates `STATUS.md` and the
   tracker. **The post is closed and the run ends — no channel runs.**
7. Later, on explicit request ("make a LinkedIn post from `<post>`" / "build the Remotion spec
   for `<post>`"): the named channel reads the record, drafts into
   `output/<post>/channels/<channel>/`, stops at its own review checkpoint, then finishes —
   updating `STATUS.md`, adding a tracker row, and appending a brand-notes entry on publish.
8. Occasionally: "update my brand" → merge `reference/brand-notes.md` into
   `reference/brand-voice.md` (or the brandkit), stamp the date, clear the entries.

Throughout, `STATUS.md` is updated at every transition; any fresh session resumes a post from
that file alone.

## Build & Integration Protocol *(for building from this seed)*

Follow this when asked to build (or rebuild) the lab from `_design/`.

### Where to build

1. **`_design/` sits inside a project folder** (its parent is the lab folder itself — empty,
   holding the legacy Writing/LinkedIn structure, partial, or complete): build into the parent.
   Missing pieces are created per this spec; existing human material is kept per the
   preservation rule below. Confirm before overwriting any machine file that differs from what
   the spec describes.
2. **`_design/` was dropped directly into a workspace root** (its parent contains other projects
   or identifies itself as a workspace root): create the lab folder beside it (default name
   `social-media/`; the human may name it otherwise), **move `_design/` inside it**, then build
   as in case 1.

### What to build

Everything in the Proposed Folder Structure section: the front-door chain, `HOW-TO-USE.md` (per
requirement 11 — plain language, four sections in order), the four blog stages, the two v1
channels with their stages, the six `reference/` files, the two `_config/` files, `tracker/`
with `index.md` and the current period's file, `input/_template/` (per the Template Scaffolds —
copy the skeletons verbatim), the shipped sample input (requirement 12), and an empty `output/`.

Where this spec gives verbatim scaffolds, copy them; where it gives requirements (stage
behavior, reference file contents, the sample), write files that satisfy them.

### Preservation and migration rule (rebuilds and the legacy structure)

A build or rebuild restores machine files but never clobbers what the human made:

- **Legacy structure**: if the build target contains the old `Writing/` and/or `LinkedIn/`
  trees (or other pre-rebuild folders), **offer to move them into `_archive/`** — never
  silent-delete, never leave them where they would shadow the new router. Carry forward the
  contents of any existing `reference/`, `_config/`, or `shared/` files into the matching new
  reference files (e.g. old `brand-voice.md` → new `reference/brand-voice.md`; a publishing
  checklist folds into `platform-rules.md`), noting in the file what was carried forward.
- **Human material**: real `input/<post>/` folders and **everything under `output/`** are the
  permanent record and are never touched by a rebuild.
- Any machine file that exists but was customized gets a confirmation before overwrite.

### Plugging into the parent workspace

After building, walk up from the lab folder and integrate:

1. **Parent workspace has a `CONTEXT.md` router**: add or update the routing row for this lab
   (e.g. *"Blog posts, social media content, platform rewrites, content tracker →
   social-media/CLAUDE.md"*), following that router's own row format. Replace any row that
   describes the legacy structure.
2. **Parent has `CLAUDE.md`/`AGENTS.md` but no router**: add a short pointer to the lab in the
   parent `AGENTS.md`, matching its existing style.
3. **No parent chain at all**: the lab stands alone — its own `CLAUDE.md` is the entry point.
   Offer to create a minimal workspace-root chain, but do not create one unasked.

Always report exactly which parent files were changed (or that none needed changing).

### Verify

Structural, not end-to-end — a post cannot run unattended because the pipeline ends at a human
checkpoint:

- The front-door chain resolves: `CLAUDE.md` → `AGENTS.md` → `CONTEXT.md`, and every router row
  points at a file that exists.
- All four blog stages and both v1 channels have their `AGENTS.md` files; channel stage counts
  match this spec.
- `input/_template/` contains exactly the six template files; the shipped sample contains the
  five (no `HOW-TO-START.md`) with content.
- `_config/tracker-settings.md` parses (three keys); `tracker/index.md` and the current period
  file exist and match the settings.
- `reference/` has all six files; `brand-notes.md` carries the entry format and a
  `Last merged: never` stamp.
- `HOW-TO-USE.md` exists with the four required sections in order, and its instructions match
  the built lab (folder names, checkpoint verdicts *finalize*/*loop*, the template file list).
- If legacy folders existed: they are in `_archive/` (with the human's confirmation) and
  nothing outside `_archive/` still routes to them.
- The parent router row (if any) resolves.

Then tell the human the lab is ready and offer a first run on the shipped sample — do not
auto-run it.

## Out of Scope (for v1)

- **Research and fact-checking as lab machinery.** The lab flags unsourced claims but never
  verifies them itself unless explicitly asked per requirement 8. A dedicated
  research/fact-checking workspace is a separate future project, external to this lab so it can
  serve other uses too.
- **Instagram, YouTube, and faceless-YouTube channels** — recipe only (requirement 5); they are
  added later by copying the channel pattern.
- **Brandkit content** — only the pointer and fallback chain ship (requirement 7); the brandkit
  itself is another project.
- **Auto-publishing to any platform** — the lab produces ready-to-post text and specs; posting
  is the human's act, and the tracker records it after the fact.
- **Cross-project ingestion** — other workspaces' outputs (a debate-lab report, a learning
  note) may be dropped into an input folder by the human like any material; the lab never pulls
  from another project on its own.
