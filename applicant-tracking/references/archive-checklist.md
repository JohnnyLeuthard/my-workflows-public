# Archive Checklist

Use this checklist when a position closes (filled, cancelled, on-hold, or withdrawn). Complete all steps before clearing the active folders.

---

## Trigger Conditions

Archive when the position reaches one of these final states:

- [ ] **Filled** — Offer accepted, start date confirmed
- [ ] **Cancelled** — Requisition cancelled; no hire made
- [ ] **On-Hold** — Position paused indefinitely (> 90 days)
- [ ] **Withdrawn** — All candidates withdrew; position closing without fill

---

## Pre-Archive Verification

Before moving any files:

- [ ] `05-scoring/master-applicants.md` — All rows for this Job Key have a final status (`accepted`, `rejected`, or `withdrawn`)
- [ ] `03-jobs/<JobKey>/scoring.md` — All candidate rows have a final score and recommendation
- [ ] `04-applicants/*/metadata.json` — `screeningStatus` is set to final value for all candidates linked to this job
- [ ] `06-interviews/<JobKey>-interviews.md` — All interview rows have notes or a completion marker
- [ ] Offer accepted candidate: `startDate` is set in `metadata.json` and `master-applicants.md`

---

## Archive Steps

Run the script (recommended):
```bash
python scripts/archive_job.py --job 2026-06-SeniorDevOpsEngineer-FTE --reason filled
# PowerShell: pwsh scripts/ps/Archive-Job.ps1 -JobKey "2026-06-SeniorDevOpsEngineer-FTE" -Reason "filled"
```

Or manually:

1. [ ] Create destination folder: `07-archive/<JobKey>/`
2. [ ] Create `07-archive/<JobKey>/applicants/` subfolder
3. [ ] Move `03-jobs/<JobKey>/` contents to `07-archive/<JobKey>/`
4. [ ] For each candidate in this job: move `04-applicants/<CandidateID>/` to `07-archive/<JobKey>/applicants/<CandidateID>/`
5. [ ] Move `06-interviews/<JobKey>-interviews.md` to `07-archive/<JobKey>/`
6. [ ] Create `07-archive/<JobKey>/status.md` (see template below)
7. [ ] Update `05-scoring/master-applicants.md`: move rows to "Archived Positions" section
8. [ ] Remove now-empty folders from `03-jobs/` (leave `.gitkeep` if folder becomes empty)
9. [ ] Verify all links are intact (spot-check `status.md` links)

---

## `status.md` Template

Create this file at `07-archive/<JobKey>/status.md`:

```markdown
# Archive Status — <JobKey>

**Job Title**: [Title]
**Job Type**: [FTE / Contractor]
**Date Opened**: YYYY-MM-DD
**Date Closed**: YYYY-MM-DD
**Close Reason**: [Filled / Cancelled / On-Hold / Withdrawn]

## Outcome

- **Total Applicants**: X
- **Interviewed**: X
- **Offer Extended To**: [CandidateID or None]
- **Offer Accepted By**: [CandidateID or None]
- **Start Date**: [YYYY-MM-DD or N/A]

## Notes

[Any context about why the position closed, lessons learned, or notes for future similar openings.]
```

---

## Post-Archive Verification

- [ ] `07-archive/<JobKey>/` exists and contains all expected files
- [ ] `03-jobs/<JobKey>/` is empty or removed
- [ ] All candidate folders for this job are in `07-archive/<JobKey>/applicants/`
- [ ] `master-applicants.md` no longer shows these rows in the Active Pipeline section
- [ ] No broken relative links in `status.md`
