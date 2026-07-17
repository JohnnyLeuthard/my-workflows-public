# Alyshia Perri — Spritesheet Animation Tool + Missing Middle Steward

Comp #8: The Wildcard. Both repos were read in full: [github.com/alydperri/spritesheet-animation-tool](https://github.com/alydperri/spritesheet-animation-tool) (commit 887c198c) · [github.com/alydperri/missing-middle-steward](https://github.com/alydperri/missing-middle-steward) (commit a9284dd1).

---

Two builds, and between them they cover both halves of this methodology. The sprite pipeline is the cleanest generative/deterministic split in the field: taste gates exactly where taste lives — sheet approval, motion approval — Python doing everything between them, a byte-compare so what ships is provably what you approved, and refusals that forbid using cleanup to launder a failed generation past the gate. Forcing the model's aesthetic ranking into a schema-validated file the code checks before acting is judgment made addressable; I'd name that pattern and reuse it. The steward is quieter and maybe deeper: logging declines as first-class memory, so a settled call never gets relitigated — an architecture decision record for a framework instead of a codebase, and the one real session in your changelog shows it working.

Pushes. The sprite CLI doesn't implement stage 005's centerpiece contract — the animation-wide scale factor and landmark anchoring live only in the doc — and both batch configs point at prompt files that don't exist, so the batch path fails at load. Make the code honor its own contract. For the steward: one session is one data point, and a stranger adopting it has to delete your content rather than fill a blank — ship templates and a second session's entries, and the loop is proven to compound.

---

Two ideas worth naming, and they are yours: schema-validated taste — the model's aesthetic judgment forced into a typed, machine-checked artifact before code will act on it — and declines as first-class memory, so the same signal never gets relitigated three reviews later. One disciplines the model's taste, the other protects yours.

Worth a look:
- [Will Vessels — content-engine](https://github.com/wcvessels/content-engine) — the factory-of-lanes shape your sprite pipeline is one lane of
