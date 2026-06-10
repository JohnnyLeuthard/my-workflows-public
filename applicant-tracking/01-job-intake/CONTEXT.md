# Phase 1 — Job Intake

This phase accepts a job description in any format and produces a fully structured job folder in `03-jobs/`.

---

## Accepted Input Formats

| Format | How to provide |
|--------|---------------|
| **URL** | Paste the URL in chat. AI fetches and parses the page. |
| **Paste** | Copy-paste the full job description text into chat. |
| **HTML source** | Paste raw HTML. AI strips tags and extracts content. |
| **PDF** | Open the PDF, select-all, copy, paste into chat. (Or use `pdftotext` to extract first.) |
| **Manual** | Use `_template.md` in this folder as a guided fill-in form. |

---

## What the AI Does

Given any of the above inputs, the AI must:

1. **Extract** the following fields:
   - Job title (exact)
   - Employment type: `FTE` (full-time employee) or `Contractor`
   - Department / team (if stated)
   - Hiring manager (if stated)
   - Required skills (list)
   - Nice-to-have skills (list)
   - Minimum years of experience
   - Key responsibilities (bullet list)
   - Educational requirements
   - Certifications required or preferred
   - Compliance/clearance requirements (if any)
   - Contractor-specific fields: agency name, duration, rate (if applicable)

2. **Generate the Job Key** using the pattern: `YYYY-MM-JobTitlePascalCase-Type`
   - Use today's date for YYYY-MM
   - PascalCase the job title (remove spaces, capitalize each word)
   - Append `-FTE` or `-Contractor`
   - Example: `2026-06-SeniorDevOpsEngineer-FTE`

3. **Create the job folder** at `03-jobs/<JobKey>/` containing these files:

   | File | Contents |
   |------|----------|
   | `job-description.md` | Formatted full job posting (title, overview, responsibilities, requirements, nice-to-haves) |
   | `metadata.json` | Machine-readable job data (see schema below) |
   | `skills-matrix.md` | Two-column table: Required Skills \| Nice-to-Have Skills |
   | `screening-questions.md` | 5 behavioral + 3 technical questions derived from the job description |
   | `scoring.md` | Scoring table header only (no candidate rows yet) |

4. **Confirm** to the user: "Job Key `<JobKey>` created. Drop resumes in `02-resume-intake/_inbox/` or paste resume content to begin Phase 2."

---

## `metadata.json` Schema

### FTE
```json
{
  "jobKey": "YYYY-MM-JobTitlePascalCase-FTE",
  "jobTitle": "Exact Job Title",
  "type": "FTE",
  "dateOpened": "YYYY-MM-DD",
  "department": "Department Name",
  "hiringManager": "Name or null",
  "requiredSkills": ["Skill A", "Skill B"],
  "niceToHaveSkills": ["Skill C"],
  "yearsRequired": 5,
  "educationRequired": "BS Computer Science or equivalent",
  "certificationsRequired": [],
  "complianceRequired": false,
  "status": "open"
}
```

### Contractor
```json
{
  "jobKey": "YYYY-MM-JobTitlePascalCase-Contractor",
  "jobTitle": "Exact Job Title",
  "type": "Contractor",
  "dateOpened": "YYYY-MM-DD",
  "department": "Department Name",
  "hiringManager": "Name or null",
  "contractFirms": [
    {
      "name": "Agency Name",
      "rep": "Recruiter Name",
      "email": "rep@example.com",
      "phone": "(000) 000-0000"
    }
  ],
  "requiredSkills": ["Skill A", "Skill B"],
  "niceToHaveSkills": ["Skill C"],
  "yearsRequired": 3,
  "contractDuration": "12 months",
  "rate": "TBD",
  "status": "open"
}
```

---

## `scoring.md` Initial Header

The AI must create this file with headers only — no candidate rows:

```markdown
# Scoring — <JobKey>

| Candidate ID | Candidate Name | Date Applied | Core Skills (1–5) | Experience (1–5) | Education (1–5) | Track Record (1–5) | Weighted Score | Recommendation | Status |
|---|---|---|---|---|---|---|---|---|---|
```

---

## Using the Script Instead (Token-Efficient)

Run the Python script to create the folder scaffold first, then ask AI to fill in content:

```bash
python scripts/new_job.py --title "Senior DevOps Engineer" --type FTE
# Creates 03-jobs/2026-06-SeniorDevOpsEngineer-FTE/ with empty stub files
# Then paste the job description text and ask AI to populate the files
```

---

## Naming Rules

- No spaces in Job Key — use PascalCase
- No special characters except hyphens as separators
- If two jobs share the same title and month, append a suffix: `2026-06-SeniorDevOpsEngineer-FTE-2`
- See `references/naming-standards.md` for full rules
