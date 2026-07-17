# Al W — Keel (Drift Harness)

Comp #8: The Wildcard. Your repo was read in full: [github.com/al-afk82/Keel-1](https://github.com/al-afk82/Keel-1) (commit 1db43b6b) · [dashboard](https://dashboard.malecsystems.com) · [walkthrough](https://www.loom.com/share/425db78dc18f4d4daa5c0027b1411586).

You arrived after the deadline, so this read is outside the standing. It got the same depth as everyone else's.

---

Two things in your repo are genuinely strong. The verdict contract: five fields, three states, and the rule that an agent may not flag anything it cannot quote — "if you cannot quote it, there is no constraint and you must return clean." Evidence instead of a confidence number is a reusable contract for any multi-agent checker, and it's real in the code. And KNOWN_ISSUES.md is the most honest engineering document in this entire competition — dated issues with severity, root cause, and status, including the instruction "do not claim the verifier validates the panel" about your own demo. That kind of record is worth more than the feature it documents.

The push is one word: truth pass. The documentation layer contradicts the code layer almost everywhere I looked. The coordinator docs describe a four-agent design that no longer exists; the constraints agent's ABOUT says its prompt is the reference file, and the code never loads it — so the C01–C10 library a stranger would edit is decorative; the feedback loop is called "Built" and is prose; the demo README lists three files that aren't there; the thinking-capture headline is a comment admitting both variables point at the same value; and .gitignore ships with merge-conflict markers committed. None of these are hard fixes — delete the stale folders, wire or remove the constraints file, make the README's build table match what harness.py actually runs, get the secrets out. The deeper move is the one your own design already names: the human-confirmed correction loop ("The human decides") is the augmentation half of this system, and it's the unbuilt half. Right now the human sits at a dashboard after the fact. Build the loop where an overridden finding flags the rule, and Keel becomes what the pitch says it is. Also: no brief.md, no worked examples — the comp's form exists because it forces exactly the honesty gaps above to surface; adopt it even for a system this code-heavy.

---

An idea worth naming, and it is yours: the excerpt-or-clean verdict — a checker may not flag what it cannot quote, and certainty is three states tied to evidence, never a percentage dressed as a probability.

Worth a look:
- [Jodi Paige-Lee — Debrief Specialist](https://github.com/jmarielee/debrief-specialist) — the honest naming of where code ends and prose begins; the discipline your docs layer needs
- [Craig Howard — Voice Engine](https://github.com/craig-atr/voice-engine) — the human-as-training-loop mechanism your feedback-loop module describes but doesn't build
