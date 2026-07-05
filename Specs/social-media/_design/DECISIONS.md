# Content Lab — Decision Log

Append-only. Each entry: what was decided, why, and what was rejected. The spec
(`SPEC.md`) records outcomes; this file records reasoning. Never rewrite old
entries — supersede them with new ones.

Entries D1–D14: **2026-07-05**, design phase. Later entries carry their own date inline.

---

## D1. Blog-first hub-and-spoke, replacing the parallel-channel structure

**Why**: The previous social-media workspace put `Writing/` and `LinkedIn/` side by side as
peers, each with generic proposals→drafting→publishing→archive stages. The human's actual
process is: collaborate with AI on one comprehensive, researched blog post first; only later,
per platform and only when wanted, rewrite it. Making the blog the hub and every platform a
spoke matches that, and gives every downstream artifact a single sourced record to draw from.
**Rejected**: Keeping parallel channel folders with a shared "Writing" peer — nothing enforced
the blog-first order or the hard stop, and platform work had no structured record to pull from.

## D2. Research and fact-checking are external to the lab

**Why**: The human will build a separate research/fact-checking workspace, deliberately outside
social-media so it can serve other uses (and debate-lab may fold into it). This lab therefore
*consumes* research through its input folder and never owns research machinery. The lab still
flags unsourced claims — flagging is editorial hygiene, not verification.
**Rejected**: An in-lab research crew (researcher/fact-checker role folders, debate-lab-style) —
seriously considered during design, dropped because the capability belongs at a higher level
where any workspace can use it. The idea survives as planned debate-lab personas (recorded in
`debate-lab/_design/NEXT-STEPS.md`), not here.

## D3. Research hook is generic and two-doored, with no named dependency

**Why**: Even with research external, the human must be able to say "go research X" and have it
happen. Two doors: the agent researches directly when asked (results filed into the input folder
as ordinary material), or the human hands `research-request.md` to any external workflow. Naming
a specific research system in the spec would couple this lab to a project that does not exist
yet and break the drop-in promise.
**Rejected**: Hard dependency on the future research workspace (doesn't exist; couples the
seed); forbidding the agent from researching at all (the human explicitly wants "do research"
to work on request).

## D4. Input starts from a template folder, not free-form

**Why**: A copy/rename `input/_template/` (the persona-template pattern) gives every post the
same named slots — instructions, the human's own text, links, post rules, a research handoff —
so the intake stage knows exactly what was and wasn't supplied, and a new user can start a post
without reading the spec. Empty files are legal; only `instructions.md` must have content.
**Rejected**: Free-form input folders with just a required instructions file — works for the
designer, but loses the fill-in-the-blanks framework the human explicitly asked for and makes
intake guess at what each file is.

## D5. An instruction file drives each post, not a fixed stage recipe

**Why**: Every post is different — sometimes the draft exists and needs expansion, sometimes
there are only links, sometimes research must happen first. `instructions.md` states the angle,
audience, required points, steps to take, and what each supplied file is for; the pipeline
stages read it rather than assuming one shape of work.
**Rejected**: A fixed per-stage checklist identical for every post — simpler to spec, but forces
the human to contort real posts into it.

## D6. Loop-with-checkpoint instead of a linear pipeline

**Why**: The human reviews the draft *and its sources* for accuracy, then either finalizes or
loops — adding material and steer, getting a new draft. Accuracy review is the human's
non-negotiable role; the loop is how "get more data and try again" works. `> COMMENT:` lines
reuse the debate-lab convention so the human learns one markup.
**Rejected**: Straight-through 01→04 with revision-by-conversation only (no durable record of
what the human corrected); auto-looping until some quality bar is met (the human, not a metric,
judges accuracy).

## D7. Hard stop at the finished blog post

**Why**: Channels must never auto-run. Publishing cadence, platform choice, and whether a post
gets repurposed at all are per-post human decisions made later ("when I want to"). The blog
close is therefore a terminal state for the run.
**Rejected**: An "also make the LinkedIn version" fast path at finalize — convenient, but it
erodes exactly the boundary the human asked for; a channel pass is always a separate request.

## D8. Channel outputs live inside the post's record

**Why**: `output/<post>/channels/<channel>/` keeps one folder as the complete story of a post —
the blog, its sources, and every platform derivative, matching the debate-lab principle that
the job folder is the record. STATUS.md's platform table then has one obvious home.
**Rejected**: Channel-local output folders (`channels/linkedin/output/…`) — the old structure's
shape; scatters one post's artifacts across the tree and needs cross-links to reassemble.

## D9. Per-post STATUS.md is the source of truth; the tracker is a view

**Why**: Debate-lab proved the pattern: a snapshot plus append-only event log per job survives
interruptions, resumes cold sessions, and answers "how did we get here". The cross-post tracker
duplicates only the publish events, because "what went out where, when" is the one question that
spans posts.
**Rejected**: Tracker as the only record (no per-post resume state); status embedded in the
tracker rows (one file becomes both view and truth, and grows unboundedly).

## D10. Tracker rotation is configuration, defaulting to monthly

**Why**: The human wanted date-split tracker files so no file grows forever, and wanted the
cadence changeable without touching workflow logic. `_config/tracker-settings.md` holds
rotation, file pattern, and folder; stages read it before writing rows. Monthly is the default
because it keeps files small at any realistic posting rate.
**Rejected**: One `TRACKER.md` forever (the growth problem the human raised); hardcoded monthly
rotation (works today, but changing cadence would mean editing stage logic — exactly what ICM
avoids); yearly default (large files for an active poster).

## D11. Brandkit deferred behind a pointer, with a generic fallback chain

**Why**: The brandkit (several brand styles, chosen per blog) is a future external project. The
lab ships the seam now — `_config/brandkit.md` — so wiring it later is a config edit, not a
redesign. The fallback chain (brandkit → `reference/brand-voice.md` → clean generic style) means
no stage ever fails or stalls for lack of a brand; an unbranded run is noted in STATUS.md, not
blocked.
**Rejected**: Waiting for the brandkit before designing the seam (guarantees a redesign);
failing/stopping when no brand is set (the human explicitly chose "be generic" as the floor);
a standing link to a brandkit workspace (violates project isolation).

## D12. Brand learning via an append-and-merge notes file

**Why**: The human wants the brand to improve from every artifact without the token cost of
rereading the whole structure. `reference/brand-notes.md` is an append-only inbox: one short
dated entry per finished artifact (what was approved, corrected, what worked). "Update my brand"
reads only that file, merges into `brand-voice.md` (or the brandkit later), stamps the date, and
clears it. Cheap on every write, cheap on every merge, and the inbox never grows past one
merge cycle.
**Rejected**: Periodically re-reading all posts/records to re-derive the brand — the human's own
comparison; correct but token-expensive and slow, and it rewards never running it. Also
rejected: merging automatically at every close (the human should control when the standing
brand file changes).

## D13. Repurpose-notes.md is the bridge to downstream specs

**Why**: The stated end-goal is generating platform specs (LinkedIn now; Remotion now; YouTube
and faceless-YouTube later) from blog material *without re-research*. That requires the blog
close to leave behind a structured extract — core message, cited claims, stats, hooks, visual
suggestions, a scene-by-scene video treatment — rather than prose only. Channels read it first
and drop to `blog-post.md`/`sources.md` for detail.
**Rejected**: Channels re-mining the raw input each time (expensive, and the raw input may
predate checkpoint corrections); putting the extract inside `blog-post.md` itself (pollutes the
publishable artifact with machine-facing scaffolding).

## D14. The seed is portable and self-locating; legacy folders are archived, never deleted

**Why**: The deliverable is the `_design/` folder itself — the human will rebuild from it and
share it so others can hand it to an AI and get the lab. So the Build Protocol carries the
debate-lab self-locating rule (parent-is-the-lab vs dropped-in-a-root), and adds this lab's
specific migration case: a build into the existing `social-media/` offers to move the legacy
`Writing/`/`LinkedIn/` trees to `_archive/` and carries forward matching `reference/` content.
Nothing human-made is ever silently deleted.
**Rejected**: Pinning the build location to `social-media/` (breaks the share-it promise);
deleting the legacy structure on rebuild (irreversible, and the human never asked for that);
leaving legacy folders in place un-archived (they would shadow the new router and confuse
routing).
