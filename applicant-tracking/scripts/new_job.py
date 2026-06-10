#!/usr/bin/env python3
"""
new_job.py — Scaffold a new job folder in 03-jobs/.

Usage:
  python scripts/new_job.py --title "Senior DevOps Engineer" --type FTE
  python scripts/new_job.py --title "QA Engineer" --type Contractor --year 2026 --month 06
  python scripts/new_job.py --whatif --title "Backend Engineer" --type FTE

What it does (mechanical only — no AI):
  1. Derives the Job Key from title + type + date
  2. Creates 03-jobs/<JobKey>/ with stub files
  3. Prints a prompt for the user to give their AI to fill in the content

After running, ask your AI:
  "I created the job folder for <JobKey>. Here is the job description: <paste text>
   Please populate job-description.md, metadata.json, skills-matrix.md,
   screening-questions.md, and add the header to scoring.md."
"""

import argparse
import json
import os
import re
import sys
from datetime import date
from pathlib import Path


def pascal_case(title: str) -> str:
    return re.sub(r"[^a-zA-Z0-9]", "", title.title().replace(" ", ""))


def build_job_key(title: str, job_type: str, year: int, month: int) -> str:
    slug = pascal_case(title)
    return f"{year:04d}-{month:02d}-{slug}-{job_type}"


def unique_job_key(base_key: str, jobs_dir: Path) -> str:
    if not (jobs_dir / base_key).exists():
        return base_key
    suffix = 2
    while (jobs_dir / f"{base_key}-{suffix}").exists():
        suffix += 1
    return f"{base_key}-{suffix}"


def create_stub_files(job_dir: Path, job_key: str, whatif: bool) -> None:
    today = date.today().isoformat()

    files = {
        "job-description.md": f"# {job_key}\n\n<!-- AI: fill in from job description -->\n",
        "metadata.json": json.dumps({
            "jobKey": job_key,
            "jobTitle": "<!-- AI: fill in -->",
            "type": "<!-- FTE or Contractor -->",
            "dateOpened": today,
            "department": None,
            "hiringManager": None,
            "requiredSkills": [],
            "niceToHaveSkills": [],
            "yearsRequired": 0,
            "educationRequired": None,
            "certificationsRequired": [],
            "complianceRequired": False,
            "status": "open"
        }, indent=2) + "\n",
        "skills-matrix.md": f"# Skills Matrix — {job_key}\n\n<!-- AI: fill in required and nice-to-have skills tables -->\n",
        "screening-questions.md": f"# Screening Questions — {job_key}\n\n<!-- AI: generate 5 behavioral + 3 technical questions from job description -->\n",
        "scoring.md": (
            f"# Scoring — {job_key}\n\n"
            "| Candidate ID | Candidate Name | Date Applied | Core Skills (1–5) | Experience (1–5) | "
            "Education (1–5) | Track Record (1–5) | Weighted Score | Recommendation | Status |\n"
            "|---|---|---|---|---|---|---|---|---|---|\n"
        ),
    }

    for filename, content in files.items():
        target = job_dir / filename
        if whatif:
            print(f"  [whatif] Would create: {target}")
        else:
            target.write_text(content, encoding="utf-8")
            print(f"  Created: {target}")


def main() -> None:
    parser = argparse.ArgumentParser(description="Scaffold a new job folder.")
    parser.add_argument("--title", required=True, help="Job title (e.g. 'Senior DevOps Engineer')")
    parser.add_argument("--type", required=True, choices=["FTE", "Contractor"], dest="job_type")
    parser.add_argument("--year", type=int, default=date.today().year)
    parser.add_argument("--month", type=int, default=date.today().month)
    parser.add_argument("--whatif", action="store_true", help="Dry run — show what would be created")
    args = parser.parse_args()

    script_dir = Path(__file__).parent
    workspace_root = script_dir.parent
    jobs_dir = workspace_root / "03-jobs"

    base_key = build_job_key(args.title, args.job_type, args.year, args.month)
    job_key = unique_job_key(base_key, jobs_dir)
    job_dir = jobs_dir / job_key

    print(f"\nJob Key: {job_key}")
    if args.whatif:
        print(f"[whatif] Would create folder: {job_dir}")
    else:
        job_dir.mkdir(parents=True, exist_ok=False)
        print(f"Created folder: {job_dir}")

    create_stub_files(job_dir, job_key, args.whatif)

    print(f"""
Next step — ask your AI:
  "Job folder {job_key} is ready. Here is the job description:
   <paste job description text here>
   Please populate job-description.md, metadata.json, skills-matrix.md,
   and screening-questions.md in 03-jobs/{job_key}/"
""")


if __name__ == "__main__":
    main()
