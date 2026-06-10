#!/usr/bin/env python3
"""
new_interview.py — Add an interview row to the job interview log and update candidate status.

Usage:
  python scripts/new_interview.py --job 2026-06-SeniorDevOpsEngineer-FTE \
      --candidate Smith-Jane-2026-06-01 --round "Phone Screen" --interviewer "Jordan Ellis" \
      --date 2026-06-05
  python scripts/new_interview.py --job 2026-06-SeniorDevOpsEngineer-FTE \
      --candidate Smith-Jane-2026-06-01 --round "Technical Deep Dive" \
      --interviewer "Jordan Ellis, Sam Park" --date 2026-06-12 --whatif

What it does (mechanical only):
  1. Creates or updates 06-interviews/<JobKey>-interviews.md with a new row
  2. Creates interview.md stub in 04-applicants/<CandidateID>/ if it does not exist
  3. Updates candidate metadata.json: screeningStatus → interview, interviewDate

After running, ask your AI to fill in interview notes:
  "Interview Round 1 for <CandidateID> is scheduled. Please add the interview questions
   from 03-jobs/<JobKey>/screening-questions.md to
   04-applicants/<CandidateID>/interview.md for Round 1."
"""

import argparse
import json
import sys
from datetime import date
from pathlib import Path


def ensure_interview_log(log_path: Path, job_key: str) -> None:
    if not log_path.exists():
        header = (
            f"# Interview Log — {job_key}\n\n"
            "| Candidate ID | Candidate Name | Round | Date | Interviewer(s) | Status | Recommendation | Notes |\n"
            "|---|---|---|---|---|---|---|---|\n"
        )
        log_path.write_text(header, encoding="utf-8")
        print(f"  Created interview log: {log_path}")


def append_interview_row(log_path: Path, candidate_id: str, candidate_name: str,
                         round_name: str, interview_date: str, interviewer: str,
                         whatif: bool) -> None:
    row = (f"| {candidate_id} | {candidate_name} | {round_name} | {interview_date} | "
           f"{interviewer} | Scheduled | — | |\n")
    if whatif:
        print(f"  [whatif] Would append row to {log_path}: {candidate_id} / {round_name}")
        return
    with log_path.open("a", encoding="utf-8") as f:
        f.write(row)
    print(f"  Appended interview row: {candidate_id} / {round_name}")


def ensure_interview_md(candidate_dir: Path, candidate_id: str, job_key: str,
                        round_name: str, interview_date: str, interviewer: str,
                        whatif: bool) -> None:
    interview_md = candidate_dir / "interview.md"
    section = (
        f"\n## {round_name}\n\n"
        f"**Date**: {interview_date}  \n"
        f"**Interviewer(s)**: {interviewer}  \n"
        f"**Duration**: <!-- fill in -->  \n"
        f"**Format**: <!-- Phone / Video / On-site -->  \n"
        f"**Status**: Scheduled  \n\n"
        "### Questions\n\n"
        "| Question ID | Category | Question | Asked | Response Summary | Rating (1–5) | Follow-up Needed | Notes |\n"
        "|------------|----------|----------|-------|-----------------|--------------|-----------------|-------|\n"
        "| <!-- Q-001 --> | <!-- Category --> | <!-- Question --> | — | — | — | — | |\n\n"
        "### Overall Round Assessment\n\n"
        "**Strengths Observed**: <!-- fill in -->  \n"
        "**Concerns Raised**: <!-- fill in -->  \n"
        "**Round Recommendation**: <!-- Advance / Hold / Decline -->  \n"
        "**Interviewer Notes**: <!-- fill in -->  \n"
    )

    if whatif:
        if interview_md.exists():
            print(f"  [whatif] Would append Round section to {interview_md}")
        else:
            print(f"  [whatif] Would create {interview_md} with header + Round section")
        return

    if not interview_md.exists():
        header = f"# Interview Record — {candidate_id}\n\n**Job**: {job_key}  \n"
        interview_md.write_text(header + section, encoding="utf-8")
        print(f"  Created {interview_md}")
    else:
        with interview_md.open("a", encoding="utf-8") as f:
            f.write(section)
        print(f"  Appended Round section to {interview_md}")


def main() -> None:
    parser = argparse.ArgumentParser(description="Add interview entry and update candidate status.")
    parser.add_argument("--job", required=True)
    parser.add_argument("--candidate", required=True)
    parser.add_argument("--round", required=True, dest="round_name",
                        help="e.g. 'Phone Screen', 'Round 1', 'Technical Deep Dive', 'Final'")
    parser.add_argument("--interviewer", required=True)
    parser.add_argument("--date", default=date.today().isoformat(), help="YYYY-MM-DD")
    parser.add_argument("--whatif", action="store_true")
    args = parser.parse_args()

    root = Path(__file__).parent.parent
    candidate_dir = root / "04-applicants" / args.candidate
    interviews_dir = root / "06-interviews"
    log_path = interviews_dir / f"{args.job}-interviews.md"
    metadata_json = candidate_dir / "metadata.json"

    if not candidate_dir.exists():
        print(f"ERROR: Candidate folder not found: {candidate_dir}", file=sys.stderr)
        sys.exit(1)

    # Load candidate name from metadata
    candidate_name = args.candidate
    metadata = {}
    if metadata_json.exists():
        metadata = json.loads(metadata_json.read_text(encoding="utf-8"))
        candidate_name = metadata.get("candidateName", args.candidate)

    print(f"\nJob: {args.job}")
    print(f"Candidate: {args.candidate} ({candidate_name})")
    print(f"Round: {args.round_name} | Date: {args.date} | Interviewer: {args.interviewer}\n")

    interviews_dir.mkdir(parents=True, exist_ok=True)
    ensure_interview_log(log_path, args.job)
    append_interview_row(log_path, args.candidate, candidate_name,
                         args.round_name, args.date, args.interviewer, args.whatif)
    ensure_interview_md(candidate_dir, args.candidate, args.job,
                        args.round_name, args.date, args.interviewer, args.whatif)

    # Update metadata
    if not args.whatif:
        metadata["screeningStatus"] = "interview"
        metadata["interviewScheduled"] = True
        if not metadata.get("interviewDate"):
            metadata["interviewDate"] = args.date
        metadata_json.write_text(json.dumps(metadata, indent=2) + "\n", encoding="utf-8")
        print(f"  Updated metadata.json: status=interview, interviewDate={args.date}")
    else:
        print(f"  [whatif] Would update metadata.json: status=interview")

    print(f"""
Next step — ask your AI:
  "Interview {args.round_name} for {args.candidate} is scheduled on {args.date}.
   Please copy the relevant questions from 03-jobs/{args.job}/screening-questions.md
   into the new round section of 04-applicants/{args.candidate}/interview.md."
""")


if __name__ == "__main__":
    main()
