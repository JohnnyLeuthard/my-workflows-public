#!/usr/bin/env python3
"""
score_candidates.py — Update scoring tables after AI has filled in candidate scoring.md.

Usage:
  python scripts/score_candidates.py --job 2026-06-SeniorDevOpsEngineer-FTE --candidate Smith-Jane-2026-06-01
  python scripts/score_candidates.py --job 2026-06-SeniorDevOpsEngineer-FTE --all
  python scripts/score_candidates.py --job 2026-06-SeniorDevOpsEngineer-FTE --candidate Smith-Jane-2026-06-01 --whatif

What it does (mechanical only):
  1. Reads 04-applicants/<CandidateID>/scoring.md to extract the four raw scores
  2. Computes weighted total: Core×0.40 + Experience×0.30 + Education×0.15 + TrackRecord×0.15
  3. Appends or updates the row in 03-jobs/<JobKey>/scoring.md
  4. Appends or updates the row in 05-scoring/master-applicants.md
  5. Updates 04-applicants/<CandidateID>/metadata.json with score and recommendation

The AI writes scoring narratives; this script only handles the table math and row management.
"""

import argparse
import json
import re
import sys
from pathlib import Path


WEIGHTS = {"Core Skills": 0.40, "Experience": 0.30, "Education / Certs": 0.15, "Track Record": 0.15}

SCORE_LABELS = {5: "Excellent Fit", 4: "Strong Fit", 3: "Partial Fit", 2: "Weak Fit", 1: "Unqualified", 0: "Disqualified"}

SCORE_ROW_PATTERN = re.compile(
    r"\|\s*(Core Skills|Experience|Education \/ Certs|Track Record)\s*\|\s*(\d)\s*\|"
)


def parse_scores_from_md(scoring_md: Path) -> dict:
    text = scoring_md.read_text(encoding="utf-8")
    scores = {}
    for m in SCORE_ROW_PATTERN.finditer(text):
        category, score = m.group(1), int(m.group(2))
        scores[category] = score
    return scores


def compute_weighted(scores: dict) -> float:
    return sum(scores.get(cat, 0) * weight for cat, weight in WEIGHTS.items())


def update_job_scoring(job_scoring: Path, candidate_id: str, candidate_name: str,
                       date_applied: str, scores: dict, total: int, label: str,
                       status: str, whatif: bool) -> None:
    row = (f"| {candidate_id} | {candidate_name} | {date_applied} | "
           f"{scores.get('Core Skills', '—')} | {scores.get('Experience', '—')} | "
           f"{scores.get('Education / Certs', '—')} | {scores.get('Track Record', '—')} | "
           f"{total} | {label} | {status} |")

    text = job_scoring.read_text(encoding="utf-8") if job_scoring.exists() else ""
    if candidate_id in text:
        lines = text.splitlines()
        new_lines = [row if candidate_id in line else line for line in lines]
        new_text = "\n".join(new_lines) + "\n"
        action = "Updated"
    else:
        new_text = text.rstrip() + "\n" + row + "\n"
        action = "Appended"

    if whatif:
        print(f"  [whatif] Would {action.lower()} row in {job_scoring}")
    else:
        job_scoring.write_text(new_text, encoding="utf-8")
        print(f"  {action} row in {job_scoring}")


def update_master(master_md: Path, candidate_id: str, job_key: str, job_title: str,
                  job_type: str, date_applied: str, total: int, label: str,
                  metadata: dict, whatif: bool) -> None:
    offer = "Yes" if metadata.get("offerExtended") else "No"
    accepted = "Yes" if metadata.get("offerAccepted") else ("—" if metadata.get("offerAccepted") is None else "No")
    start = metadata.get("startDate") or "—"
    status = metadata.get("screeningStatus", "screening")
    notes = ""

    row = (f"| {candidate_id} | {job_key} | {job_title} | {job_type} | {date_applied} | "
           f"{total} | {label} | {offer} | {accepted} | {start} | {status} | {notes} |")

    text = master_md.read_text(encoding="utf-8") if master_md.exists() else ""
    if candidate_id in text:
        lines = text.splitlines()
        new_lines = [row if candidate_id in line else line for line in lines]
        new_text = "\n".join(new_lines) + "\n"
        action = "Updated"
    else:
        new_text = text.rstrip() + "\n" + row + "\n"
        action = "Appended"

    if whatif:
        print(f"  [whatif] Would {action.lower()} row in {master_md}")
    else:
        master_md.write_text(new_text, encoding="utf-8")
        print(f"  {action} row in {master_md}")


def process_candidate(root: Path, job_key: str, candidate_id: str, whatif: bool) -> None:
    scoring_md = root / "04-applicants" / candidate_id / "scoring.md"
    metadata_json = root / "04-applicants" / candidate_id / "metadata.json"
    job_scoring = root / "03-jobs" / job_key / "scoring.md"
    job_metadata = root / "03-jobs" / job_key / "metadata.json"
    master_md = root / "05-scoring" / "master-applicants.md"

    if not scoring_md.exists():
        print(f"  ERROR: {scoring_md} not found. Run resume intake and have AI fill in scoring.md first.")
        return

    scores = parse_scores_from_md(scoring_md)
    if len(scores) < 4:
        print(f"  ERROR: Could not parse all 4 scores from {scoring_md}. Ensure AI has filled in the scoring table.")
        return

    weighted = compute_weighted(scores)
    total = round(weighted)
    label = SCORE_LABELS.get(total, "Unknown")

    print(f"\n  {candidate_id}")
    print(f"  Scores: Core={scores.get('Core Skills')} Exp={scores.get('Experience')} "
          f"Edu={scores.get('Education / Certs')} Track={scores.get('Track Record')}")
    print(f"  Weighted: {weighted:.2f} → {total} ({label})")

    # Load candidate metadata
    metadata = {}
    if metadata_json.exists():
        metadata = json.loads(metadata_json.read_text(encoding="utf-8"))
    date_applied = metadata.get("dateAdded", "unknown")

    # Load job metadata for title and type
    job_meta = {}
    if job_metadata.exists():
        job_meta = json.loads(job_metadata.read_text(encoding="utf-8"))
    job_title = job_meta.get("jobTitle", job_key)
    job_type = job_meta.get("type", "FTE")

    update_job_scoring(job_scoring, candidate_id,
                       metadata.get("candidateName", candidate_id), date_applied,
                       scores, total, label, metadata.get("screeningStatus", "screening"), whatif)

    update_master(master_md, candidate_id, job_key, job_title, job_type,
                  date_applied, total, label, metadata, whatif)

    # Update metadata.json
    metadata["overallScore"] = total
    metadata["recommendation"] = label
    if metadata.get("screeningStatus") == "resume_received":
        metadata["screeningStatus"] = "screening"
    if not whatif:
        metadata_json.write_text(json.dumps(metadata, indent=2) + "\n", encoding="utf-8")
        print(f"  Updated metadata.json: score={total}, recommendation={label}")
    else:
        print(f"  [whatif] Would update metadata.json: score={total}, recommendation={label}")


def main() -> None:
    parser = argparse.ArgumentParser(description="Update scoring tables from candidate scoring.md files.")
    parser.add_argument("--job", required=True, help="Job Key")
    parser.add_argument("--candidate", help="Candidate ID (omit to use --all)")
    parser.add_argument("--all", action="store_true", help="Process all candidates for this job")
    parser.add_argument("--whatif", action="store_true", help="Dry run")
    args = parser.parse_args()

    root = Path(__file__).parent.parent

    if not (root / "03-jobs" / args.job).exists():
        print(f"ERROR: Job not found: {args.job}", file=sys.stderr)
        sys.exit(1)

    print(f"\nJob: {args.job}")

    if args.all:
        scoring_md = root / "03-jobs" / args.job / "scoring.md"
        if not scoring_md.exists():
            print("ERROR: No scoring.md found for this job. Run new_screening.py first.")
            sys.exit(1)
        text = scoring_md.read_text(encoding="utf-8")
        candidate_ids = re.findall(r"\b([A-Za-z]+-[A-Za-z]+-\d{4}-\d{2}-\d{2})\b", text)
        for cid in dict.fromkeys(candidate_ids):  # deduplicate, preserve order
            process_candidate(root, args.job, cid, args.whatif)
    elif args.candidate:
        process_candidate(root, args.job, args.candidate, args.whatif)
    else:
        print("ERROR: Provide --candidate <ID> or --all", file=sys.stderr)
        sys.exit(1)

    print("\nDone.")


if __name__ == "__main__":
    main()
