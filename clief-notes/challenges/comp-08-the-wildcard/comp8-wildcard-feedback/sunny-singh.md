# Sunny Singh — Context Re-Entry Specialist

Comp #8: The Wildcard. Your repo was read in full: [github.com/ms-codehorizon/context-reentry](https://github.com/ms-codehorizon/context-reentry) (commit 608f3844) · [live](https://ms-codehorizon.github.io/context-reentry/).

---

The idea underneath your build is an epistemology, and you committed to it harder than anyone: every fact wears a source tag, a guess may never wear an evidence label, and when memory and the repo disagree, the repo wins. The case study is the proof — your own brain said "finish wiring the Flask backend," commit 5aab3a7 said the backend was deliberately deleted, and the map even caught the subtler trap of a deleted file showing up as recently touched. gather.py doing collection in code and the rules doing the reading is the right split, and requiring every first action to name the rule it won on and what it beat is provenance most production systems don't have.

Two pushes, both about the same seam. Your cold test is graded by the person who built the thing — the one adjudication your own epistemology wouldn't accept. And rules 2a and 3a key on test status and open PRs that no shipped collector gathers, so your top-ranked rule can only ever fire from memory, the source you've demoted. Teach gather.py to fetch PRs and record tests-unrun, and the rules stand on evidence all the way down.

---

An idea worth naming, and it is yours: memory demoted to a hypothesis — the human's own recall treated as a claim to check against ground truth, with source tags on every fact and the runner-up rule named on every decision.

Worth a look:
- [Craig Howard — Voice Engine](https://github.com/craig-atr/voice-engine) — your cousin build: the outbox over the self-image, the record over the guess
