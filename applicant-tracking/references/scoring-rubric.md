# Scoring Rubric — Detailed Guide

> Use this file when there is ambiguity about how to score a category. For day-to-day scoring, `05-scoring/CONTEXT.md` is sufficient.

---

## Formula

```
Weighted Score = (Core Skills × 0.40) + (Experience × 0.30) + (Education/Certs × 0.15) + (Track Record × 0.15)
```

All four raw scores use the 1–5 integer scale below. The weighted total is rounded to the nearest whole number.

---

## Core Skills (40%)

Measures how well the candidate's demonstrated skills match the job's **required skills** list in `skills-matrix.md`.

| Score | Label | Criteria |
|-------|-------|----------|
| 5 | Excellent | Meets all required skills AND covers ≥ 50% of nice-to-haves |
| 4 | Strong | Meets all required skills; few or no nice-to-haves |
| 3 | Partial | Meets ≥ 75% of required skills; notable gap in 1–2 areas |
| 2 | Weak | Meets 50–74% of required skills; multiple gaps |
| 1 | Unqualified | Meets fewer than 50% of required skills |

**Tie-breaking:** Depth beats breadth. A candidate who deeply knows 90% of required skills scores higher than one who superficially lists all of them.

---

## Experience (30%)

Measures years of relevant professional experience and seniority relative to the job's requirements.

| Score | Label | Criteria |
|-------|-------|----------|
| 5 | Excellent | ≥ 150% of required years; held senior or lead titles |
| 4 | Strong | 100–149% of required years; held relevant titles |
| 3 | Partial | 75–99% of required years; or years met but in adjacent domain |
| 2 | Weak | 50–74% of required years |
| 1 | Unqualified | < 50% of required years |

**Domain relevance:** Adjust down by 1 point if the experience is in a completely different domain with minimal transferability.

---

## Education / Certifications (15%)

Measures whether the candidate meets the educational and certification requirements.

| Score | Label | Criteria |
|-------|-------|----------|
| 5 | Excellent | Exceeds education requirement (e.g., MS when BS required) AND holds all listed preferred certifications |
| 4 | Strong | Meets education requirement AND holds at least one preferred certification |
| 3 | Partial | Meets education requirement with no certifications, OR has relevant certifications but slightly below education requirement |
| 2 | Weak | Does not meet education requirement; no relevant certifications |
| 1 | Unqualified | No relevant education or certifications; significant gap |

**Equivalent experience note:** If the job states "or equivalent experience," a strong work history with no degree should not automatically score below 3 in this category.

---

## Track Record (15%)

Measures evidence of professional impact beyond simply holding a job title.

| Score | Label | Criteria |
|-------|-------|----------|
| 5 | Excellent | Multiple quantified achievements (metrics, %, $), promotions, publications, awards, open-source leadership |
| 4 | Strong | At least one quantified achievement; evidence of scope increase or leadership |
| 3 | Partial | Responsibilities listed but limited evidence of outcomes or impact |
| 2 | Weak | Generic job description language; no evidence of growth or impact |
| 1 | Unqualified | No verifiable professional track record in the relevant domain |

---

## Final Score Interpretation

| Weighted Score | Recommendation | Suggested Action |
|---------------|---------------|-----------------|
| 5 | Excellent Fit | Fast-track — schedule interview immediately |
| 4 | Strong Fit | Advance to interview |
| 3 | Partial Fit | Flag for hiring manager review before advancing |
| 2 | Weak Fit | Decline — send standard rejection |
| 1 | Unqualified | Decline — send standard rejection |
| 0 | Disqualified | Decline — hard-stop rule triggered (see `scoring-criteria.md`) |

---

## Scoring Examples

### Example 1 — Senior DevOps Engineer (5 years required)

Candidate: Jane Smith — 8 years DevOps, CKA certified, Kubernetes expert, promoted to Tech Lead

| Category | Score | Rationale |
|----------|-------|-----------|
| Core Skills | 4 | Meets all required, covers 3 of 5 nice-to-haves |
| Experience | 5 | 8 yrs vs 5 required (160%); held Tech Lead title |
| Education | 4 | BS CS (meets req) + CKA cert (preferred) |
| Track Record | 4 | Promoted, led team, reduced deploy time by 40% (quantified) |

```
Weighted = (4×0.40) + (5×0.30) + (4×0.15) + (4×0.15) = 1.60 + 1.50 + 0.60 + 0.60 = 4.30 → 4
```

### Example 2 — Generalist Sysadmin applying for DevOps

Candidate: Michael Brown — 4 years sysadmin, Docker basics, no Kubernetes

| Category | Score | Rationale |
|----------|-------|-----------|
| Core Skills | 3 | Meets ~70% of required — Docker yes, Kubernetes/Terraform no |
| Experience | 3 | 4 yrs vs 5 required (80%); adjacent domain |
| Education | 2 | No degree; CompTIA Linux+ (partial) |
| Track Record | 3 | Stable tenure, no quantified achievements |

```
Weighted = (3×0.40) + (3×0.30) + (2×0.15) + (3×0.15) = 1.20 + 0.90 + 0.30 + 0.45 = 2.85 → 3
```
