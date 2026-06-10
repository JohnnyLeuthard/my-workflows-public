# FTE vs. Contractor — Rules and Differences

This file describes the workflow differences between Full-Time Employee (FTE) and Contractor requisitions. Load this when setting up a new job or when there is ambiguity about how to handle a Contractor candidate.

---

## Key Differences

| Aspect | FTE | Contractor |
|--------|-----|-----------|
| Employment type | Direct hire, permanent | Fixed-term contract via agency or direct |
| `metadata.json` type field | `"FTE"` | `"Contractor"` |
| Agency/staffing firm | Not applicable | Required: agency name, rep, contact info |
| Duration | Indefinite (at-will) | Fixed: e.g., 12 months, 6 months + option |
| Rate | Salary (usually not in metadata) | Hourly rate or monthly billing rate |
| Benefits | Yes (health, PTO, 401k, etc.) | No (contractor's own, or agency's) |
| Citizenship / Compliance | Depends on role | May have additional contract-specific requirements |
| Job Key suffix | `-FTE` | `-Contractor` |

---

## `metadata.json` Differences

### FTE — fields only in FTE jobs
```json
{
  "type": "FTE",
  "complianceRequired": true,
  "predefinedQuestions": true,
  "questionsFile": "screening-questions.md"
}
```

### Contractor — fields only in Contractor jobs
```json
{
  "type": "Contractor",
  "contractFirms": [
    {
      "name": "Agency Name",
      "rep": "Recruiter Name",
      "email": "rep@example.com",
      "phone": "(000) 000-0000"
    }
  ],
  "contractDuration": "12 months",
  "rate": "$85/hr"
}
```

---

## Scoring Differences

FTE and Contractor positions use the same scoring formula and rubric. However, apply these adjustments when scoring Contractor candidates:

| Adjustment | Rule |
|-----------|------|
| Education weight | Education/Certs weight may be reduced for purely technical contract roles where skills trump credentials. Update `05-scoring/scoring-criteria.md` per-job override if needed. |
| Track Record | Contractor track records often include more short-tenure engagements — do not penalize for < 2-year stints if the pattern is consistent with contracting. |
| Citizenship | Some contracts (government, defense) require citizenship regardless of FTE/Contractor status. Check `metadata.json`.complianceRequired. |

---

## Interview Question Differences

| FTE | Contractor |
|-----|-----------|
| Behavioral + culture fit questions | Technical skills + delivery capability focus |
| Long-term career goals | Availability and transition readiness |
| Benefits / compensation expectations | Rate negotiation and agency terms |
| Growth path discussions | Extension / convert-to-hire possibility |

---

## Offer Stage Differences

| Aspect | FTE | Contractor |
|--------|-----|-----------|
| Offer document | Employment offer letter | SOW / contract via agency |
| Background check | Typically yes | Varies by agency agreement |
| Start date | Calendar date, direct | Based on contract start and agency onboarding |
| `offerExtended` in metadata | Set to `true` when letter sent | Set to `true` when SOW executed |
| `offerAccepted` in metadata | Set to `true` when signed | Set to `true` when contract counter-signed |

---

## Archive Differences

Both FTE and Contractor positions use the same archive process. For Contractors, include in `07-archive/<JobKey>/status.md`:
- Contract duration and actual end date
- Whether the contract was extended or converted to FTE
- Agency contact information for future reference
