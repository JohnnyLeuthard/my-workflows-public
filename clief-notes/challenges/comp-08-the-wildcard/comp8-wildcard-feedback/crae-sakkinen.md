# Crae Säkkinen — Agent Script Checker

Comp #8: The Wildcard. Your repo was read in full: [github.com/usedcolouringbook/agent-script-checker](https://github.com/usedcolouringbook/agent-script-checker) (commit 37b8409c) · [site](https://agent-script-checker.vercel.app/).

---

The checker practices what it preaches, which is rarer than it should be: scoring, counting, and classification are pure TypeScript with no model in the loop, and the model is reserved for the one genuinely judgmental act — the rewrite — under a rule that forbids improving anything beyond the layering. "A VLOOKUP does not hallucinate" is the whole doctrine in five words, and your stateful-determinism argument — the store owns the state, so reads belong in the 60 — is an actual contribution to how people should think about the split.

The push lands on the one place the build betrays itself. The specialist's worked examples carry hand-written checker outputs that contradict your real scorer — one block says judgment at 8% in its summary and 23% in its own layers line, and the printed score matches neither under your formula; your reference script's header says ~25 where the example says 10. In a tool about trusting computed numbers, the few-shots teach drift. Generate every example block by actually running src/core on the reference scripts, and delete the ghost tests/ and docs/ entries from CLAUDE.md — npm test fails for anyone who believes the map. Greg Faysash committed his expected output next to his engine; that's the pattern.

---

An idea worth naming, and it is yours: stateful determinism — a database or store read belongs in the deterministic layer because the store owns the state, formalized as a scored category rather than left as instinct.

Worth a look:
- [Greg Faysash — BriefLock](https://github.com/julianargus01/brief-lock) — the committed expected-output pattern: sample input and engine result pinned side by side
- [Joshua Hubbard — Reckon](https://github.com/hubbardjoshua9-a11y/reckon) — your sibling: the invisible-failure taxonomy your engine could rank by
