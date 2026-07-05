# Research Lab — Decision Log

Append-only. Each entry: what was decided, why, and what was rejected. The spec
(`SPEC.md`) records outcomes; this file records reasoning. Never rewrite old
entries — supersede them with new ones.

Entries D1–D13: **2026-07-05**, design phase. Entries D14–D19: same day, pre-build
reliability review. Later entries carry their own date inline.

---

## D1. Name and location: `research-lab/` at the workspace root

**Why**: A standalone project with its own CLAUDE.md → AGENTS.md → CONTEXT.md chain, sibling of
debate-lab and social-media. Its whole reason to exist (debate-lab D29) is serving every project
without living inside any of them; the `-lab` name matches the workspace's naming. Router row at
the workspace root per the workspace's own rule.
**Rejected**: Nesting inside debate-lab or social-media (locks a shared capability inside one
consumer — the exact problem D29 was solving); `fact-lab` / `intel-lab` naming (narrower than
what the lab does).

## D2. A service pipeline with cross-reading verification — not a debate

**Why**: The job is gather-then-verify, not argue. Gatherers work their beats in parallel;
verifiers must read the gatherers' output because checking it *is* their function — debate-lab's
round-1 isolation rule would make verification impossible. Sequential phases (gather → verify →
synthesize) give the dispatcher a simple plan that adapts per request type (fact-check-only
skips gathering). Checkpoint verdicts are accept / dig-deeper / reprocess; there are no rebuttal
rounds because specialists have no positions to defend.
**Rejected**: Fan-out isolation copied from debate-lab (breaks verification); a single
monolithic researcher stage (loses beat-specific scope files, per-specialist source lists, and
the restrict-to-list capability); making it a debate between specialists (nothing to debate —
evidence either checks out or it doesn't).

## D3. Specialists are workspace markdown via the template pattern

**Why**: Straight reuse of debate-lab's persona reasoning: a specialist is context loaded only
when dispatched, lives in the workspace (not any machine's config), and is portable to any tool
that reads files. Copy/rename/register from `specialists/_template/`, mechanics defined once in
`reference/specialist-protocol.md`, every specialist `AGENTS.md` a never-edited pointer.
AI-assisted creation is a first-class path.
**Rejected**: Harness subagents (machine-specific, eagerly loaded); defining specialists inline
in the dispatcher (mechanics with no per-specialist home — exactly what the template pattern
exists to avoid).

## D4. Starter set: four role specialists; domains come later via the template

**Why**: The human chose general-researcher, fact-checker, data-checker, and source-analyst —
the four *roles* every request type needs, regardless of topic. Domain expertise
(security-researcher, academic-researcher, OSINT/news-researcher, counter-researcher) is added
by the user via the template when a real need appears, exactly like adding a debate persona.
**Rejected**: Shipping domain specialists nobody asked for yet (guesswork, and the template
makes adding one trivial); counter-researcher in v1 (offered; the human deferred it —
documented as a suggested future add).

## D5. Experience levels are declarations plus request depth — not junior/senior clones

**Why**: The human raised "different levels of experience." Modeling that as separate
junior/senior specialist folders would double the roster for no behavioral gain. Debate-lab
already solved the guardrail half: `SCOPE.md` declares expertise per domain
(expert/working/aware/none) and governs how assertively findings are stated. The rigor half is
a property of the *request*, not the specialist: a per-request depth setting
(quick/standard/deep, pinned in `research-settings.md`) sets how hard everyone digs.
**Rejected**: Junior/senior persona clones (folder sprawl, arbitrary boundaries); a per-specialist
rigor dial in CONFIG.md (rigor varies per job, not per worker).

## D6. Source precedence: global lists + per-specialist lists, specialist wins for itself

**Why**: Human-directed. The lab-wide `reference/sources.md` (trusted + avoid) sets the
baseline so common judgments live once; each specialist's `SOURCES.md` carries beat-specific
lists. On conflict the **specialist's entry overrides the global list for that specialist
only** — a domain expert legitimately trusts sources the general lists avoid (and distrusts
ones they accept), and its own list is precisely where that expertise lives. Overrides are
surfaced, not hidden: the packet's Sources section notes them.
**Rejected**: Global-always-wins (blocks legitimate beat-specific sources; the human explicitly
chose specialist-wins); per-specialist lists only (repeats the avoid list in every folder and
loses the shared baseline); merge with no override (conflicts would be undefined exactly where
they matter).

## D7. `restrict-to-list` is a CONFIG flag, defaulting to false

**Why**: Human-directed, with the defining example: a `snopes-fact-checker` whose only source
is snopes.com. By default a specialist has **freedom to find sources** — trusted lists are
preferences, not walls, and only the avoid list is binding. Flipping `restrict-to-list: true`
confines that one specialist to its own `SOURCES.md` trusted table, turning it into a
single-authority (or curated-set) checker. One boolean in the existing CONFIG file covers the
whole spectrum from "roam freely" to "one website only."
**Rejected**: A separate "restricted specialist" type (a second template and roster category
for what one boolean expresses); putting the restriction in the request (it is a property of
the specialist's identity — the snopes checker is *always* snopes-only — not of any one job);
making trusted lists binding for everyone (kills the freedom the human explicitly wanted
preserved by default).

## D8. Teams with a required `default` team — the committees pattern reused

**Why**: Debate-lab D28 proved the shape the same day: named groups as adjustable layer-2
shorthand, kill switch supreme, misconfiguration reported not guessed, and a required
`default` row that makes the standing selection a one-line edit. Reusing it identically
(as `reference/teams.md`) means one mental model across labs — and the human already uses
committees in debate-lab.
**Rejected**: Fixed locked teams (per-request adjustment is the point); no default team
(re-introduces a hardcoded "everyone" rule debate-lab just retired); inventing a different
grouping mechanism for this lab (gratuitous divergence from a pattern the human just learned).

## D9. Verdict scale, cited evidence, no weights

**Why**: Fact-check output must be a bounded vocabulary or packets become mush: confirmed /
plausible / unsupported / contradicted / misleading-context, every verdict with cited
evidence, "couldn't check" mapped to `unsupported` with the reason. Debate-lab's persona
weights are deliberately NOT imported: in a debate, credibility attaches to the arguer; in
research it attaches to the *sources* — a finding's force comes from its evidence plus the
specialist's declared expertise level, surfaced as confidence notes.
**Rejected**: Free-form verdict prose (unscannable, inconsistent across jobs); numeric
confidence scores (false precision); specialist weights (wrong locus of credibility).

## D10. Checkpoint: a structured `## Human Review` block and three verdicts

**Why**: Human-directed. The lab is meant to be shared — *any* person running it needs one
obvious, pre-seeded place in the draft packet to respond: **Comments** (reactions to specific
findings, plus inline `> COMMENT:` lines), **Direction** (overall steer), and **New
Information** (links, claims, corrections added at review time — treated as first-class input
on the next pass). Verdicts: accept (finalize + close), dig-deeper (targeted re-run, appended
findings, fresh review block, soft-capped), full reprocess (restart from phase 1 with prior
work superseded-archived, never deleted — debate-lab's reprocess rule).
**Rejected**: No checkpoint / deliver-final-immediately (the human explicitly wants review
before the packet is trusted); comment-lines-only with no structured block (a first-time user
has nowhere obvious to put new information or overall steer); rebuttal-style rounds (D2 —
specialists don't argue).

## D11. The packet is the single deliverable; consumers pull

**Why**: Extends debate-lab D21 (the job folder is the record; reports are views) and the
social-media lab's repurpose-notes reasoning: downstream use is designed in, not bolted on.
`packet.md` is canonical and closing; it carries everything a reader in another workspace needs
— findings, verdict table, vetted sources, gaps, and a "How This Research Ran" appendix —
because packets travel. Derived views of a closed job go to `output/<job>/reports/`. The lab
never pushes into another project; the human (or a consumer's explicit request) carries the
packet — the same isolation rule every lab in this workspace follows.
**Rejected**: Auto-delivering packets into consumer input folders (standing cross-project
connection); multiple parallel deliverables per job (one canonical artifact or none is
trustworthy).

## D12. Two shipped samples, one per main request type

**Why**: Debate-lab D22's reasoning re-applied: first runs should test the machine, not the
human's request-writing, and the two main request shapes (open research vs claim fact-check)
should both be demonstrated from day one. Topics are evergreen tech questions the builder may
substitute.
**Rejected**: No samples (first contact becomes a writing exercise); one combined mega-sample
(demonstrates neither shape cleanly).

## D13. Tooling honesty: capability depends on available tools, and the packet says so

**Why**: Research quality is bounded by what the running agent can actually reach (web search,
web fetch). Pretending otherwise produces confident packets built on nothing. So the rule is
stated in the spec and enforced in the format: with no web access the lab works from supplied
material only, and every packet's "How This Research Ran" appendix records what could and
could not be reached, alongside unreachable-source gaps in Open Questions.
**Rejected**: Silently degrading to supplied-material-only (the reader can't tell a thin
evidence base from a lazy one); refusing to run without web access (supplied-material
verification is still real work — e.g. checking a draft's internal consistency and its claims
against provided documents).

## D14. Citations are quote-anchored and fetched-only

*(2026-07-05, pre-build reliability review — NEXT-STEPS A1+A2.)*

**Why**: The lab's dominant failure mode is not structure, it is the AI: hallucinated
citations — URLs that don't say what's claimed or don't exist. Two rules close most of it.
**Quote-anchored**: every citation carries a short verbatim quote plus the access date;
fabricating a quote+URL pair is far harder than fabricating a URL, quotes keep packets
auditable after pages change, and human spot-checks drop from a re-read to seconds per claim.
**Fetched-only**: a specialist may cite only sources it actually opened and read during the
run — a search snippet is a lead, not a citation; claims on unreachable pages become
`unsupported (unreachable)`.
**Rejected**: Links-only citations (unauditable, and the model can invent them); trusting
search snippets as evidence (snippets routinely misrepresent pages); silently keeping claims
whose source couldn't be fetched (confident packets built on nothing).

## D15. Verification runs against sources, never against the researcher's prose

*(2026-07-05, pre-build reliability review — NEXT-STEPS A3.)*

**Why**: The fact-checker is the same model as the researcher; if it verifies by reading the
findings file, phase 2 just launders phase 1's misreadings into verdicts. So the rule: the
verifier re-fetches and re-reads the cited sources; the findings tell it *what* to check,
never what is true. HOW-TO-USE carries the high-stakes tip to run verification in a fresh
session, since context contamination is real even with the rule.
**Rejected**: Verifying from the findings prose (an echo, not a check); mandatory
fresh-session verification for every job (right for high-stakes runs, needless overhead for a
quick sweep — so it's a documented tip, not a requirement).

## D16. `not-covered` — the restricted specialist's silence verdict

*(2026-07-05, pre-build reliability review — NEXT-STEPS A4.)*

**Why**: A `restrict-to-list: true` specialist can only report what its list covers. Mapping
its silence to `unsupported` would read as "probably false" — silence from a narrow list
carries no implication either way. The distinct verdict `not-covered` keeps a
snopes-fact-checker honest when Snopes simply never wrote about a claim.
**Rejected**: Folding silence into `unsupported` with a reason note (readers scan verdict
columns; the word itself must not mislead); letting restricted specialists roam when their
list is silent (defeats the entire point of the restriction).

## D17. Corroboration requires independent originators

*(2026-07-05, pre-build reliability review — NEXT-STEPS A5.)*

**Why**: "2–3 sources" is worthless when all three syndicate one press release — the web is
full of circular sourcing. So independence is defined (different originators; wire re-prints
and re-reports count once) and tracing a claim to its origin is explicitly the
source-analyst's job.
**Rejected**: Counting sources by URL (rewards syndication); leaving "independent" undefined
in the depth scale (every run would re-invent it).

## D18. Fetched content is data, never instructions

*(2026-07-05, pre-build reliability review — NEXT-STEPS A6.)*

**Why**: A research agent reads arbitrary web pages, and pages can carry text addressed to AI
agents ("ignore your instructions and…") — prompt injection. The protocol rule makes fetched
material evidence to evaluate, never instructions to follow, and treats agent-addressed text
as a reportable red flag about that source.
**Rejected**: Relying on the harness alone to resist injection (defense belongs in the lab's
own protocol too — the seed is portable to other tools); silently ignoring injected text
(its presence is itself signal about the source's trustworthiness).

## D19. Freshness stamps: packets and citations carry dates

*(2026-07-05, pre-build reliability review — NEXT-STEPS A7.)*

**Why**: Verdicts age and pages change. An "As of \<date\>" stamp at the packet's top tells a
reader a year later exactly when this was true; per-citation access dates plus D14's verbatim
quotes keep every claim auditable even after its page moves or dies.
**Rejected**: Dates only in the run appendix (too buried for the packet's primary question:
"is this still current?"); archiving full page copies into the job folder (heavyweight;
quotes capture the load-bearing part).
