# Phase 5 — Scoring

This phase scores a candidate against a specific job opening using the weighted rubric and produces three synchronized outputs: a candidate-level score, a per-job scoring table row, and a master applicants table row.

---

## Inputs Required

Before scoring, the AI must load all three of these:

1. `04-applicants/<CandidateID>/analysis.md` — candidate profile
2. `03-jobs/<JobKey>/skills-matrix.md` — required and nice-to-have skills for this job
3. `05-scoring/scoring-criteria.md` — universal scoring criteria and any custom factors

Do not load other files unless a specific custom criterion requires it.

---

## Scoring Formula

```
Weighted Score = (Core Skills × 0.40) + (Experience × 0.30) + (Education/Certs × 0.15) + (Track Record × 0.15)
```

- All categories scored 1–5 (integers only)
- Final weighted score: round to nearest whole number
- Apply override rules in `scoring-criteria.md` before computing (e.g., automatic disqualification)

---

## Category Definitions

| Category | Weight | What to Evaluate |
|----------|--------|-----------------|
| **Core Skills** | 40% | Match between candidate's skills and the job's **required** skills list. Rate 5 if all required skills are met and some nice-to-haves are covered. Rate 1 if fewer than half of required skills are present. |
| **Experience** | 30% | Years of relevant experience vs. years required. Seniority of roles held. Relevance of industries/domains. |
| **Education / Certs** | 15% | Meets minimum education requirement? Holds any listed certifications? Rate higher for exceeding requirements. |
| **Track Record** | 15% | Evidence of impact: promotions, metrics, awards, publications, open-source contributions, leadership roles. |

---

## Scoring Scale

| Score | Label | Meaning |
|-------|-------|---------|
| 5 | Excellent fit | Exceeds requirements in this category |
| 4 | Strong fit | Fully meets requirements in this category |
| 3 | Partial fit | Meets most but not all requirements |
| 2 | Weak fit | Meets some requirements but significant gaps |
| 1 | Unqualified | Does not meet minimum requirements for this category |

---

## Three Outputs (Always Update All Three)

### 1. `04-applicants/<CandidateID>/scoring.md`

Fill in the stub created during Phase 2:

```markdown
# Scoring — <CandidateID>

**Job Applied For**: <JobKey>
**Date Applied**: YYYY-MM-DD
**Scored On**: YYYY-MM-DD
**Scored By**: AI-assisted

| Category | Raw Score (1–5) | Weight | Weighted Score |
|----------|----------------|--------|---------------|
| Core Skills | X | 40% | X×0.40 |
| Experience | X | 30% | X×0.30 |
| Education / Certs | X | 15% | X×0.15 |
| Track Record | X | 15% | X×0.15 |
| **TOTAL** | | | **X.XX → X** |

**Recommendation**: [Excellent Fit / Strong Fit / Partial Fit / Weak Fit / Unqualified]

**Scoring Notes**:
[2–4 sentences explaining key strengths, gaps, and the recommendation.]
```

### 2. `03-jobs/<JobKey>/scoring.md`

Append or update the candidate's row in the per-job scoring table:

```
| <CandidateID> | First Last | YYYY-MM-DD | X | X | X | X | X | Strong Fit | screening |
```

### 3. `05-scoring/master-applicants.md`

Append or update the candidate's row in the master table:

```
| <CandidateID> | <JobKey> | <JobTitle> | YYYY-MM-DD | X | Strong Fit | No | — | — | — |
```

---

## Also Update: Candidate `metadata.json`

After scoring, update these fields in `04-applicants/<CandidateID>/metadata.json`:

```json
{
  "screeningStatus": "screening",
  "overallScore": X,
  "recommendation": "Strong Fit"
}
```

---

## When to Re-Score

Re-score a candidate (use `--force` with the script or overwrite the scoring files) when:
- A correction to the original resume analysis is discovered
- The job's required skills list is updated after initial scoring
- A manager requests a re-evaluation with different criteria weights

---

## Using the Script (Token-Efficient)

```bash
python scripts/score_candidates.py --job 2026-06-SeniorDevOpsEngineer-FTE --candidate Smith-Jane-2026-06-01
# Reads analysis.md + skills-matrix.md, computes numeric scores, updates all three output files
# AI writes the scoring narrative only
```
