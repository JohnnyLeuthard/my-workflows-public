# Phase 2 — Resume Intake

This phase accepts resumes in any format and produces structured candidate analysis files in `04-applicants/`.

---

## Accepted Input Formats

| Format | How to provide |
|--------|---------------|
| **PDF in `_inbox/`** | Name the file `LastName-Firstname-YYYY-MM-DD.pdf` and drop it in `02-resume-intake/_inbox/`. Tell AI the filename. |
| **Paste in chat** | Copy-paste the resume text directly into chat. AI derives Candidate ID from name + today's date. |
| **LinkedIn export** | Export profile as PDF, rename per naming standard, drop in `_inbox/`. |
| **HTML/web** | Paste the HTML source of a LinkedIn profile or resume page into chat. |

---

## Candidate ID Derivation

The Candidate ID is **immutable once set** and follows the pattern:

```
LastName-FirstName-YYYY-MM-DD
```

- Use the date the resume was **received** (not today's date if processing a backlog)
- If the date is unknown, use today's date
- The filename of the PDF in `_inbox/` determines the Candidate ID when using file drop
- Example: `Smith-Jane-2026-06-01` derived from `Smith-Jane-2026-06-01.pdf`

---

## What the AI Does

Given a resume, the AI must:

1. **Extract** the following fields:
   - Full name (Last, First)
   - Phone number
   - Email address
   - Location (city, state/country)
   - Citizenship / work authorization (if stated)
   - Total years of relevant professional experience
   - Job titles held (most recent first)
   - Key skills and technologies
   - Education (degree, institution, year)
   - Certifications (name, issuer, year if stated)
   - Notable achievements or metrics

2. **Derive Candidate ID** from name + date (see above)

3. **Create candidate folder** at `04-applicants/<CandidateID>/` containing:

   | File | Contents |
   |------|----------|
   | `metadata.json` | Machine-readable candidate data (see schema below) |
   | `analysis.md` | Narrative candidate analysis (see template in `references/analysis-template.md`) |
   | `scoring.md` | Scoring file stub — header only, no scores yet |

4. **Confirm** to user: "Candidate `<CandidateID>` created. Which job should I score them against? Provide the Job Key or say 'all open jobs'."

---

## `metadata.json` Schema

```json
{
  "candidateId": "LastName-FirstName-YYYY-MM-DD",
  "candidateName": "First Last",
  "phone": "string",
  "email": "string",
  "location": "City, State",
  "citizenship": "string or null",
  "dateAdded": "YYYY-MM-DD",
  "appliedJobKey": "YYYY-MM-JobTitlePascalCase-Type",
  "screeningStatus": "resume_received",
  "analysisCompleted": true,
  "interviewScheduled": null,
  "interviewDate": null,
  "overallScore": null,
  "recommendation": null,
  "offerExtended": false,
  "offerAccepted": null,
  "startDate": null
}
```

Valid `screeningStatus` values (in order):
`resume_received` → `screening` → `interview` → `offer` → `accepted` → `rejected` → `withdrawn`

---

## `scoring.md` Initial Header

The AI creates this as a stub — scores are filled in during Phase 5:

```markdown
# Scoring — <CandidateID>

**Job Applied For**: <JobKey>
**Date Applied**: YYYY-MM-DD
**Analyst**: AI-assisted

| Category | Raw Score (1–5) | Weight | Weighted Score |
|----------|----------------|--------|---------------|
| Core Skills | — | 40% | — |
| Experience | — | 30% | — |
| Education / Certs | — | 15% | — |
| Track Record | — | 15% | — |
| **TOTAL** | | | **—** |

**Recommendation**: Pending
**Notes**:
```

---

## Filename Validation

If a PDF filename in `_inbox/` does not match `LastName-Firstname-YYYY-MM-DD.pdf`:
- AI must warn the user
- Suggest the correct rename
- Do not create a candidate folder until the name is confirmed or corrected

---

## Using the Script Instead (Token-Efficient)

```bash
python scripts/new_screening.py --job 2026-06-SeniorDevOpsEngineer-FTE
# Scans _inbox/, validates filenames, creates 04-applicants/<CandidateID>/ stubs
# Then ask AI to read each analysis.md stub and fill in from the resume content
```

---

## Batch Processing

If multiple resumes arrive at once, process them sequentially: create all candidate folders first, then ask AI to fill in each `analysis.md` one at a time to avoid token overload.
