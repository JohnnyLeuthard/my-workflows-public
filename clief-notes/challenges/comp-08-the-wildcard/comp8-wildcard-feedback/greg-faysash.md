# Greg Faysash — BriefLock

Comp #8: The Wildcard. Your repo was read in full: [github.com/julianargus01/brief-lock](https://github.com/julianargus01/brief-lock) (commit 21280dd4) · [live](https://julianargus01.github.io/brief-lock/).

---

BriefLock has the cleanest label-and-compute split in the field: the model classifies, price_calc.py prices, and the committed sample output matches the code path to the dollar — I checked the arithmetic by hand. "You never pick a number, a band, or a model" is the discipline everyone else wrote as philosophy and you wrote as code, and QUOTE-BLOCKED — refusing to price what can't be priced honestly — is a feature dressed as a refusal. The scope-lock is the original move: freezing each quote as a file so that months later, change requests get re-priced by the same engine that priced the job.

Two pushes. First, the whole system is synthetic — Meridian, Brightline, Harbor Goods; no quote you've actually sent lives anywhere in it. Run one real engagement and commit the sanitized receipt; until then the flywheel exists in spec only. Second, the silent one-pass intake means the model's labels — which can swing a price threefold by your own warning — meet the human only after the number. Nicolás's ratify microgate this week is the missing piece: one confirm-question before committing when the stakes step up. Your engine deserves that gate.

---

An idea worth naming, and it is yours: the scope-lock — the quote frozen as a file at the moment of agreement, so scope creep months later is measured against the locked scope by the same deterministic engine, never renegotiated from memory.

Worth a look:
- [Nicolás Patrón — structure-call-ar](https://github.com/Nicopatron/structure-call-ar) — the ratify microgate, and the same labels-in-model / numbers-in-code discipline with the arithmetic pinned by self-tests
