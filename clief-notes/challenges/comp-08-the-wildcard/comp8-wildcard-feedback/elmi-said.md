# Elmi Said — automatic-broccoli (Amazon Monthly Report Specialist)

Comp #8: The Wildcard. Your repo was read in full: [github.com/Promali-bit/automatic-broccoli](https://github.com/Promali-bit/automatic-broccoli) (commit 22e38373).

---

The best idea in your build is the intake. You worked out that Amazon's filenames lie — BusinessReport-6-22-26.csv is the download date, not the reporting month — and instead of teaching the model to guess better, you made the human supply the one fact the system can't safely infer. That's the right division of labor, and it's older than AI: every clean data pipeline has a declared load date, because inferring it from file metadata burns you exactly once a quarter.

Now the honest part of the read. The deliverable is invisible — there's no example report, no mapping file (not even ten synthetic rows), no sample inputs, and two reference files end mid-code-fence with sample-inputs/README a byte-identical copy of the root README. A stranger can see that the workflow completed, never what it produced. And the model both does the financial arithmetic and audits its own arithmetic, which is the one loop that can't catch itself. Ship one full synthetic month end to end — fake CSV, small mapping table, the actual final report built from them — and look at Roc Lee's sheet-update contract for how to make the write-back checkable. The bones are right; the proof is missing.

---

An idea worth naming, and it is yours: the human supplies the one fact the system cannot safely infer — and the traceable folder, not the report, is what makes the workflow trustworthy. Both are stated cleanly in your rules; the next version just has to show them.

Worth a look:
- [Roc Lee — Daily Sonar](https://github.com/rocleemusic/daily-sonar) — the byte-echo contract and column-ownership rules for safe write-backs
