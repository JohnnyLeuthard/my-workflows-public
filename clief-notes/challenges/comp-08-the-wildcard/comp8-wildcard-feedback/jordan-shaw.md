# Jordan Shaw — Quartermaster + Purser

Comp #8: The Wildcard. Both repos were read in full: [github.com/jordansshaw-pixel/quartermaster](https://github.com/jordansshaw-pixel/quartermaster) (commit 7067ed92) · [github.com/jordansshaw-pixel/purser](https://github.com/jordansshaw-pixel/purser) (commit 5bc96c99).

---

The pair is a working diagram of the whole philosophy. The Quartermaster's data model makes the human's authority structural: confidence is derived at read time and never stored, so stale can't be laundered into live; ownership and control are two links that never merge, so "the business owns it but a personal Gmail controls it" is a finding, not a blur; and last_confirmed is the one field only a human act can write. The Purser is the cleanest constrained middle in the field — a scout that reads years of receipts and structurally cannot decide, because the schema reserves every judgment field for the parent. Refusing to infer a cadence from three monthly-spaced charges is exactly where extraction agents silently fabricate, and you wrote the refusal into the data format itself. The pattern underneath is old and good — this is a configuration-management database with a human signature column — which is why it will outlive the demo.

Two pushes. The Quartermaster's one guarantee — anti-rot — is date arithmetic performed by the model at read time; a fifty-line checker that walks the registry, computes the due-slices, and emits the Standup skeleton would make the guarantee a property instead of a request. And the Purser is unrunnable from the repo: gmail-registry is named, characterized, and required, but neither shipped nor linked, and no real sweep output exists. A redacted transcript of one real full sweep closes the loop.

---

Two ideas worth naming, and they are yours: confidence derived at read time and never stored — staleness cannot hide behind a cached badge — and the human's confirmation as a property of the data format, not a request in the prose. The second one is the deepest single design move in this competition's whole field.

Worth a look:
- [Sunny Singh — Context Re-Entry](https://github.com/ms-codehorizon/context-reentry) — the same family: the record over the guess, with the deterministic collector your Standup wants
