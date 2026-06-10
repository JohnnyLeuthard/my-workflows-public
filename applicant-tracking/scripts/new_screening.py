#!/usr/bin/env python3
"""
new_screening.py — Scan resume inbox and scaffold candidate folders in 04-applicants/.

Usage:
  python scripts/new_screening.py --job 2026-06-SeniorDevOpsEngineer-FTE
  python scripts/new_screening.py --job 2026-06-SeniorDevOpsEngineer-FTE --whatif
  python scripts/new_screening.py --job 2026-06-SeniorDevOpsEngineer-FTE --force

What it does (mechanical only — no AI):
  1. Scans 02-resume-intake/_inbox/ for *.pdf files
  2. Validates each filename against LastName-Firstname-YYYY-MM-DD.pdf
  3. Creates 04-applicants/<CandidateID>/ with stub files for valid filenames
  4. Prints a prompt for the user to give their AI to fill in analysis content

After running, ask your AI for each candidate:
  "Resume inbox has new candidate <CandidateID> applying for <JobKey>.
   I'll paste their resume content below. Please fill in analysis.md and metadata.json.
   <paste resume text>"
"""

import argparse
import json
import re
import sys
from datetime import date
from pathlib import Path


RESUME_PATTERN = re.compile(r"^([A-Za-z]+)-([A-Za-z]+)-(\d{4}-\d{2}-\d{2})\.pdf$")


def validate_filename(filename: str):
    m = RESUME_PATTERN.match(filename)
    if not m:
        return None, f"Does not match LastName-Firstname-YYYY-MM-DD.pdf"
    last, first, dt = m.groups()
    candidate_id = f"{last}-{first}-{dt}"
    return candidate_id, None


def create_candidate_stubs(applicants_dir: Path, candidate_id: str, job_key: str, whatif: bool) -> None:
    candidate_dir = applicants_dir / candidate_id
    today = date.today().isoformat()

    metadata = {
        "candidateId": candidate_id,
        "candidateName": "<!-- AI: fill in -->",
        "phone": None,
        "email": None,
        "location": None,
        "citizenship": None,
        "dateAdded": today,
        "appliedJobKey": job_key,
        "screeningStatus": "resume_received",
        "analysisCompleted": False,
        "interviewScheduled": None,
        "interviewDate": None,
        "overallScore": None,
        "recommendation": None,
        "offerExtended": False,
        "offerAccepted": None,
        "startDate": None
    }

    scoring_header = (
        f"# Scoring — {candidate_id}\n\n"
        f"**Job Applied For**: {job_key}  \n"
        f"**Date Applied**: {today}  \n"
        f"**Scored On**: Pending  \n\n"
        "| Category | Raw Score (1–5) | Weight | Weighted Score |\n"
        "|----------|----------------|--------|---------------|\n"
        "| Core Skills | — | 40% | — |\n"
        "| Experience | — | 30% | — |\n"
        "| Education / Certs | — | 15% | — |\n"
        "| Track Record | — | 15% | — |\n"
        "| **TOTAL** | | | **—** |\n\n"
        "**Recommendation**: Pending  \n"
        "**Notes**: \n"
    )

    files = {
        "metadata.json": json.dumps(metadata, indent=2) + "\n",
        "analysis.md": f"# Analysis — {candidate_id}\n\n<!-- AI: fill in from resume content -->\n",
        "scoring.md": scoring_header,
    }

    if whatif:
        print(f"  [whatif] Would create: {candidate_dir}/")
        for f in files:
            print(f"  [whatif]   {f}")
        return

    candidate_dir.mkdir(parents=True, exist_ok=False)
    for filename, content in files.items():
        (candidate_dir / filename).write_text(content, encoding="utf-8")
    print(f"  Created: {candidate_dir}/")


def main() -> None:
    parser = argparse.ArgumentParser(description="Scaffold candidate folders from resume inbox.")
    parser.add_argument("--job", required=True, help="Job Key (e.g. 2026-06-SeniorDevOpsEngineer-FTE)")
    parser.add_argument("--whatif", action="store_true", help="Dry run")
    parser.add_argument("--force", action="store_true", help="Overwrite existing candidate folders")
    args = parser.parse_args()

    script_dir = Path(__file__).parent
    root = script_dir.parent
    inbox = root / "02-resume-intake" / "_inbox"
    applicants_dir = root / "04-applicants"
    jobs_dir = root / "03-jobs"

    if not (jobs_dir / args.job).exists():
        print(f"ERROR: Job folder not found: {jobs_dir / args.job}", file=sys.stderr)
        sys.exit(1)

    pdfs = sorted(inbox.glob("*.pdf"))
    if not pdfs:
        print(f"No PDF files found in {inbox}")
        print("Drop resumes named LastName-Firstname-YYYY-MM-DD.pdf into 02-resume-intake/_inbox/ and re-run.")
        return

    print(f"\nScanning {inbox}")
    print(f"Job: {args.job}\n")

    created = []
    skipped = []
    invalid = []

    for pdf in pdfs:
        candidate_id, error = validate_filename(pdf.name)
        if error:
            print(f"  SKIP (invalid name): {pdf.name} — {error}")
            invalid.append(pdf.name)
            continue

        target = applicants_dir / candidate_id
        if target.exists() and not args.force:
            print(f"  SKIP (exists): {candidate_id} — use --force to overwrite")
            skipped.append(candidate_id)
            continue

        create_candidate_stubs(applicants_dir, candidate_id, args.job, args.whatif)
        created.append(candidate_id)

    print(f"\nSummary: {len(created)} created, {len(skipped)} skipped, {len(invalid)} invalid filenames")

    if created and not args.whatif:
        print("\nNext step — ask your AI for each candidate:")
        for cid in created:
            print(f"  Candidate: {cid}")
        print("""
  Template prompt:
  "New candidate <CandidateID> has applied for <JobKey>.
   Here is their resume content: <paste resume text>
   Please fill in 04-applicants/<CandidateID>/analysis.md and update metadata.json."
""")


if __name__ == "__main__":
    main()
