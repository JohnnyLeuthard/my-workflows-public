# Kirk Snider — Prospect Intelligence Specialist

Comp #8: The Wildcard. Your repo was read in full: [github.com/kirksnider/prospect-intelligence-specialist](https://github.com/kirksnider/prospect-intelligence-specialist) (commit c614dd2c).

---

The lessons baked into your method are the tell that a real pipeline ran somewhere: research agents never write shared files, merges join by company from scratch JSONs, row counts are enforced, budget gets a pre-flight. Those aren't things you invent at a whiteboard; they're scars. The $0 git-CRM — prospects.csv as system of record, pipeline.md as the curated weekly view, merge-don't-overwrite — is a pattern worth publishing on its own for founders who won't pay for a CRM they don't need yet.

The push is the gap between your philosophy and your folder. Your own pipeline-method.md says most of this work is mechanical and should be scripted — don't spend model calls on work a filter or a join can do deterministically — and then the repo ships zero scripts; the merge, dedup, and CSV writing are all instructions to the model. And the hard dependency, the discovery source, is a config placeholder, which means the machine that ran for you isn't in the folder. Ship the one deterministic merge-and-tier script plus a single anonymized real-segment run, and this goes from method to tool. Greg Faysash's engine with its committed expected output is the pattern.

---

An idea worth naming, and it is yours: the zero-dollar git-CRM — a version-controlled CSV as the system of record and a markdown file as the curated weekly view, with merge-don't-overwrite semantics so runs accrete instead of clobbering.

Worth a look:
- [Greg Faysash — BriefLock](https://github.com/julianargus01/brief-lock) — a real engine with its expected output committed beside it; the mechanization your method file already argues for
