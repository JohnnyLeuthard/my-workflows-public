# Roc Lee — Daily Sonar

Comp #8: The Wildcard. Your repo was read in full: [github.com/rocleemusic/daily-sonar](https://github.com/rocleemusic/daily-sonar) (commit ec90c557).

---

The sheet-write policy is the best model/shared-data boundary anyone drew this month. Column-level ownership — notes and last-contact never written, action items write-if-empty, contacts and assignment propose-only because who owns a lead is a human call even when the cell is empty — plus a byte-echo contract and one approval gate at the only irreversible point. That's a real edit surface, specified tightly enough to hand to a team. The recursion is elegant too: an operator built from operators, every stage its own identity and contract. And the Double Fine example — holding the score on a rumor while drafting a personal check-in, because a closure scatters good people — is the judgment layer of this work done right.

The push: the two things a skeptic wants are pointed at and absent. The runbook is referenced eleven times across eight files and doesn't exist; the June 28 live run your examples quote isn't committed. And a recalibration left drift behind — publisher backing is 18 points in the news-sources tier and 16 in the rubric, and one file calls audio headcount lightly weighted while the rubric makes it the heaviest criterion. Will's pinned-schema-with-a-test pattern is how you keep copies honest. Commit the run, write the runbook, reconcile the numbers — the design is already there.

---

An idea worth naming, and it is yours: column-level ownership — a per-column contract for which cells the machine may write, propose, or never touch, so a shared spreadsheet becomes a governed boundary instead of a free-for-all. Anyone wiring an agent to shared business data needs this and almost nobody writes it down.

Worth a look:
- [Will Vessels — content-engine](https://github.com/wcvessels/content-engine) — pinned schema copies with a test that proves they agree; the fix for rubric drift
