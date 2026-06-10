# Scoring Criteria — Universal

> This file is loaded for every candidate scoring run. It defines the base rubric, weight overrides, custom criteria, and disqualification rules. Edit this file to customize scoring for your organization without touching the per-job or per-candidate files.

---

## Base Rubric (Always Applied)

```
Weighted Score = (Core Skills × 0.40) + (Experience × 0.30) + (Education/Certs × 0.15) + (Track Record × 0.15)
```

Scale: 1–5 integers. Round final weighted score to nearest whole number.

| Category | Default Weight | Can Override? |
|----------|---------------|--------------|
| Core Skills | 40% | Yes — see per-job override section |
| Experience | 30% | Yes |
| Education / Certs | 15% | Yes |
| Track Record | 15% | Yes |

**Note:** All four weights must sum to 100%. If you override one, adjust the others accordingly.

---

## Per-Job Weight Overrides

Document any active per-job weight overrides here. Remove rows when a job closes.

| Job Key | Core Skills % | Experience % | Education % | Track Record % | Reason |
|---------|--------------|-------------|-------------|---------------|--------|
| *(none active)* | | | | | |

---

## Automatic Disqualification Rules

If ANY of the following are true, the candidate's overall score must be recorded as **0 (Disqualified)** regardless of other category scores. Document the reason in the scoring notes.

| Rule | Trigger |
|------|---------|
| Citizenship required | `metadata.json`.complianceRequired is `true` AND candidate's citizenship field is null or non-qualifying |
| Minimum years not met | Candidate has fewer than 50% of the required years of experience |
| Mandatory certification missing | Job lists a required certification AND the candidate does not hold it |

Add custom disqualification rules below:

| Rule | Trigger |
|------|---------|
| *(add custom rules here)* | |

---

## Custom Scoring Factors (Optional)

These factors do not change the formula weights but can be noted as qualitative modifiers in the scoring narrative. Check any that apply when writing the scoring notes.

- [ ] **Communication quality** — Resume is well-written, clear, and professional
- [ ] **Culture indicators** — Candidate's background suggests alignment with team values
- [ ] **Remote readiness** — Evidence of successful remote work (if role is remote)
- [ ] **Growth trajectory** — Consistent upward career progression
- [ ] **Diversity of experience** — Cross-industry or cross-functional exposure relevant to the role
- [ ] **Referral** — Candidate was referred by a current employee (note name)
- [ ] **Salary alignment** — Candidate's stated expectations are within budget (if known)

---

## Score Interpretation Guide

| Weighted Score | Label | Hiring Action |
|---------------|-------|--------------|
| 5 | Excellent Fit | Fast-track to interview |
| 4 | Strong Fit | Advance to interview |
| 3 | Partial Fit | Flag for hiring manager review before advancing |
| 2 | Weak Fit | Decline — send rejection |
| 1 | Unqualified | Decline — send rejection |
| 0 | Disqualified | Decline — compliance or hard-stop rule triggered |

---

## Scoring Ethics

Scores must be based **only** on skills, experience, education, and documented professional track record. The following must **never** influence a score:

- Age, race, religion, national origin, sex, disability, or protected characteristics
- Personal appearance, social media presence unrelated to professional work
- Subjective cultural assessments beyond documented professional behaviors
- Referral bonus status

When in doubt, ask: "Would I score this the same way if I could not see this candidate's name or photo?"

---

## Version History

| Date | Change | By |
|------|--------|----|
| 2026-06-09 | Initial version | System |
