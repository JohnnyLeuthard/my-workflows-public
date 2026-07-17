# Gabriel Azoulay — Visit Ready (prepare-dr-visit)

Comp #8: The Wildcard. Your repo was read in full: [github.com/NFTYoginis/prepare-dr-visit](https://github.com/NFTYoginis/prepare-dr-visit) (commit a8063d12) · [live demo](https://nftyoginis.github.io/prepare-dr-visit/).

---

The oldest rule in engineering is that a guarantee is only as strong as its enforcement, and yours is the entry that took it seriously. Everyone writes "no diagnosis" in their rules; you decided prose isn't enforcement and moved the invariant into check.py — eighteen compiled rules, a self-test corpus that visibly grew through three re-gates, and a line in rules.md that the model's own "this looks fine" is not sufficient. The detail I keep returning to is smaller: the gate can't know who's speaking, so you turned that limit into a writing discipline — a patient's worry becomes a question for the doctor. The constraint made the output better than the unconstrained version would have been. That's design.

Two pushes. When the runtime has no code tool, the gate degrades to the model simulating it — your own INVARIANT.md argues that isn't enough, and your in-browser gate already exists on the landing page; promote it to the official no-code path. And your bare rule-out regex blocks a legitimate patient question ("should we rule out anemia?") — your own Example 2 quietly dodges it with a gerund. You and Bas already found each other in the comments; his evidence tiers are the natural next layer under your refusals.

---

An idea worth naming, and it is yours: worries become questions — the gate's speaker-blindness converted into a clinical-communication convention that is better for the doctor anyway. The constraint improved the medicine.

Worth a look:
- [Nicolás Patrón — structure-call-ar](https://github.com/Nicopatron/structure-call-ar) — your sibling build: the same enforced boundary between what the system commits to and what escalates to a named human
