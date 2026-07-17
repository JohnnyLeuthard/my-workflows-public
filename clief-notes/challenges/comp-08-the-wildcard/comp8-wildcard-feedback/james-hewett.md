# James Hewett — finance-app

Comp #8: The Wildcard. Your repo was read in full: [github.com/datageodude/finance-app](https://github.com/datageodude/finance-app) (commit 5298466f).

---

This is the entry where the checkpoint discipline visibly paid for itself: seventeen decision records with rejected options, a dated changelog, fixtures designed with expected outcomes written down, and tests that assert the dangerous behaviors — the dedupe constraint rejecting a true duplicate and accepting the near-duplicate that differs only in balance. The flag-threshold finding is the methodology working in the open: 83 fixture transactions analysed, $100 measured as too noisy, the recommendation recorded before any code changed. "Own the spine, supervise the surface" is a division of labor worth naming: you own the schema, the import, the flagging; presentation is delegated.

Two things. The honest fit note first: your canonical files govern the builder, not a runtime specialist — ICM here is the build harness for a real app, which is a legitimate reading of the assignment but a different one. A small weekly-review operator folder the family actually runs would close that gap and give the household its own specialist; Roc's stage shape is a good template. Second, the brief's own hardest line isn't met yet — nothing leaves home and a tested backup exists is Phase 7, still open. A backup that has never restored is a hope, not a backup. Close that loop and all six criteria stand.

---

An idea worth naming, and it is yours: own the spine, supervise the surface — an explicit division of labor where the human owns and understands the schema, the import, and the flagging, and delegates the presentation, enforced by mandatory gates at every phase boundary.

Worth a look:
- [Roc Lee — Daily Sonar](https://github.com/rocleemusic/daily-sonar) — the operator-stage shape for the family's weekly-review folder
