#!/usr/bin/env python3
"""
archive_job.py — Archive a completed, cancelled, or on-hold position.

Usage:
  python scripts/archive_job.py --job 2026-06-SeniorDevOpsEngineer-FTE --reason filled
  python scripts/archive_job.py --job 2026-06-SeniorDevOpsEngineer-FTE --reason cancelled --whatif

What it does:
  1. Verifies all candidates for this job are in a final status
  2. Creates 07-archive/<JobKey>/applicants/
  3. Moves 03-jobs/<JobKey>/ contents to 07-archive/<JobKey>/
  4. Moves each linked candidate folder to 07-archive/<JobKey>/applicants/<CandidateID>/
  5. Moves 06-interviews/<JobKey>-interviews.md to 07-archive/<JobKey>/
  6. Creates 07-archive/<JobKey>/status.md stub
  7. Marks master-applicants.md rows as archived (moves to archived section)

After running, ask your AI to fill in the status.md summary.
"""

import argparse
import json
import re
import shutil
import sys
from datetime import date
from pathlib import Path


FINAL_STATUSES = {"accepted", "rejected", "withdrawn"}


def check_candidate_statuses(root: Path, job_key: str) -> list:
    job_scoring = root / "03-jobs" / job_key / "scoring.md"
    if not job_scoring.exists():
        return []

    text = job_scoring.read_text(encoding="utf-8")
    candidate_ids = re.findall(r"\b([A-Za-z]+-[A-Za-z]+-\d{4}-\d{2}-\d{2})\b", text)
    unfinished = []
    for cid in dict.fromkeys(candidate_ids):
        meta_path = root / "04-applicants" / cid / "metadata.json"
        if meta_path.exists():
            meta = json.loads(meta_path.read_text(encoding="utf-8"))
            status = meta.get("screeningStatus", "unknown")
            if status not in FINAL_STATUSES:
                unfinished.append((cid, status))
    return unfinished


def create_status_stub(archive_job_dir: Path, job_key: str, reason: str,
                       job_meta: dict, whatif: bool) -> None:
    today = date.today().isoformat()
    status_content = (
        f"# Archive Status — {job_key}\n\n"
        f"**Job Title**: {job_meta.get('jobTitle', '<!-- fill in -->')}  \n"
        f"**Job Type**: {job_meta.get('type', '<!-- FTE or Contractor -->')}  \n"
        f"**Date Opened**: {job_meta.get('dateOpened', '<!-- fill in -->')}  \n"
        f"**Date Closed**: {today}  \n"
        f"**Close Reason**: {reason.capitalize()}  \n\n"
        "## Outcome\n\n"
        "- **Total Applicants**: <!-- fill in -->\n"
        "- **Interviewed**: <!-- fill in -->\n"
        "- **Offer Extended To**: <!-- CandidateID or None -->\n"
        "- **Offer Accepted By**: <!-- CandidateID or None -->\n"
        "- **Start Date**: <!-- YYYY-MM-DD or N/A -->\n\n"
        "## Notes\n\n"
        "<!-- AI: summarize outcomes, lessons learned, notes for future similar openings -->\n"
    )
    status_path = archive_job_dir / "status.md"
    if whatif:
        print(f"  [whatif] Would create: {status_path}")
    else:
        status_path.write_text(status_content, encoding="utf-8")
        print(f"  Created: {status_path}")


def main() -> None:
    parser = argparse.ArgumentParser(description="Archive a completed job position.")
    parser.add_argument("--job", required=True)
    parser.add_argument("--reason", required=True,
                        choices=["filled", "cancelled", "on-hold", "withdrawn"])
    parser.add_argument("--force", action="store_true", help="Archive even if candidates have non-final status")
    parser.add_argument("--whatif", action="store_true")
    args = parser.parse_args()

    root = Path(__file__).parent.parent
    job_src = root / "03-jobs" / args.job
    archive_dir = root / "07-archive"
    archive_job_dir = archive_dir / args.job
    interviews_src = root / "06-interviews" / f"{args.job}-interviews.md"

    if not job_src.exists():
        print(f"ERROR: Job folder not found: {job_src}", file=sys.stderr)
        sys.exit(1)

    if archive_job_dir.exists():
        print(f"ERROR: Archive folder already exists: {archive_job_dir}", file=sys.stderr)
        sys.exit(1)

    print(f"\nArchiving: {args.job}")
    print(f"Reason: {args.reason}\n")

    # Check candidate statuses
    unfinished = check_candidate_statuses(root, args.job)
    if unfinished and not args.force:
        print("WARNING: Some candidates have non-final status:")
        for cid, status in unfinished:
            print(f"  {cid}: {status}")
        print("\nUpdate their status to accepted/rejected/withdrawn, or use --force to archive anyway.")
        sys.exit(1)

    # Load job metadata
    job_meta = {}
    meta_path = job_src / "metadata.json"
    if meta_path.exists():
        job_meta = json.loads(meta_path.read_text(encoding="utf-8"))

    # Find candidate IDs linked to this job
    scoring_text = (job_src / "scoring.md").read_text(encoding="utf-8") if (job_src / "scoring.md").exists() else ""
    candidate_ids = list(dict.fromkeys(re.findall(r"\b([A-Za-z]+-[A-Za-z]+-\d{4}-\d{2}-\d{2})\b", scoring_text)))

    # Create archive structure
    archive_applicants = archive_job_dir / "applicants"
    if not args.whatif:
        archive_job_dir.mkdir(parents=True, exist_ok=True)
        archive_applicants.mkdir()
    else:
        print(f"  [whatif] Would create: {archive_job_dir}/")
        print(f"  [whatif] Would create: {archive_applicants}/")

    # Move job folder contents
    if args.whatif:
        print(f"  [whatif] Would move contents of {job_src}/ to {archive_job_dir}/")
    else:
        for item in job_src.iterdir():
            shutil.move(str(item), str(archive_job_dir / item.name))
        job_src.rmdir()
        print(f"  Moved job folder contents to {archive_job_dir}/")

    # Move candidate folders
    for cid in candidate_ids:
        cand_src = root / "04-applicants" / cid
        cand_dst = archive_applicants / cid
        if cand_src.exists():
            if args.whatif:
                print(f"  [whatif] Would move {cand_src} → {cand_dst}")
            else:
                shutil.move(str(cand_src), str(cand_dst))
                print(f"  Moved candidate: {cid}")

    # Move interview log
    if interviews_src.exists():
        if args.whatif:
            print(f"  [whatif] Would move {interviews_src} → {archive_job_dir}/")
        else:
            shutil.move(str(interviews_src), str(archive_job_dir / interviews_src.name))
            print(f"  Moved interview log")

    create_status_stub(archive_job_dir, args.job, args.reason, job_meta, args.whatif)

    print(f"""
Archive complete.

Next step — ask your AI:
  "The job {args.job} has been archived (reason: {args.reason}).
   Please fill in 07-archive/{args.job}/status.md with a summary of the hiring outcomes."
""")


if __name__ == "__main__":
    main()
