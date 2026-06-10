# Interview Question Template

Use this template for both `03-jobs/<JobKey>/screening-questions.md` (job-level questions) and `04-applicants/<CandidateID>/interview.md` (candidate-level interview records).

---

## Job-Level Question Bank (`screening-questions.md`)

Define questions once at the job level. Copy to candidate-level interview files before each interview.

### Standard Columns

| Round | Question ID | Category | Question | Required | Notes |
|-------|------------|----------|----------|----------|-------|

### Column Definitions

| Column | Description |
|--------|-------------|
| Round | `Phone Screen`, `Round 1`, `Round 2`, `Technical`, `Final` |
| Question ID | Stable identifier: `Q-001`, `Q-002`, etc. — **never change after creation** |
| Category | `Behavioral`, `Technical`, `Situational`, `Culture`, `Role-Specific` |
| Question | Full question text |
| Required | `Yes` / `No` — required questions must be asked in every interview of that round |
| Notes | Scoring rubric, expected answer elements, or follow-up guidance |

---

## Candidate Interview Record (`interview.md`)

One file per candidate, appended with a new section for each round.

### Template: Interview Round Section

```markdown
## Round [N] — [Round Name]

**Date**: YYYY-MM-DD  
**Interviewer(s)**: [Name(s)]  
**Duration**: [X minutes]  
**Format**: [Phone / Video / On-site]  
**Status**: [Scheduled / Completed / Cancelled / No-Show]  

### Questions

| Question ID | Category | Question | Asked | Response Summary | Rating (1–5) | Follow-up Needed | Notes |
|------------|----------|----------|-------|-----------------|--------------|-----------------|-------|
| Q-001 | Technical | [question] | Yes | [summary] | 4 | No | |
| Q-002 | Behavioral | [question] | Yes | [summary] | 3 | Yes | Ask about specific incident |

### Overall Round Assessment

**Strengths Observed**: [2–3 bullets]
**Concerns Raised**: [1–2 bullets or "None"]
**Round Recommendation**: [Advance / Hold / Decline]
**Interviewer Notes**: [Freeform observations]
```

---

## Standard Question Bank (Reusable Across Jobs)

Copy relevant questions into your job-level `screening-questions.md`. Assign Question IDs sequentially starting from `Q-001`.

### Behavioral (STAR format expected)

| ID | Category | Question |
|----|----------|----------|
| B-001 | Behavioral | Tell me about a time you had to deliver a project under significant time pressure. What did you do? |
| B-002 | Behavioral | Describe a situation where you disagreed with a technical decision made by your team. How did you handle it? |
| B-003 | Behavioral | Tell me about a time a project failed or went significantly off-track. What was your role and what did you learn? |
| B-004 | Behavioral | Describe the most complex system you have designed or contributed to. What made it complex? |
| B-005 | Behavioral | Tell me about a time you had to quickly learn a new technology or tool. How did you approach it? |

### Culture / Situational

| ID | Category | Question |
|----|----------|----------|
| C-001 | Culture | How do you prefer to receive feedback on your work? Give an example of feedback that changed your approach. |
| C-002 | Situational | You discover a critical bug in production at 4pm on a Friday. Walk me through your response. |
| C-003 | Culture | Describe your ideal working environment and how you collaborate with teammates. |

### Technical (Generic — Replace with Job-Specific)

| ID | Category | Question |
|----|----------|----------|
| T-001 | Technical | Walk me through how you would design [relevant system]. What are your key considerations? |
| T-002 | Technical | How do you approach [relevant problem domain]? Give a recent example. |
| T-003 | Technical | What tools or frameworks do you use for [relevant area] and why? |

---

## Rating Scale (Per Question)

| Rating | Meaning |
|--------|---------|
| 5 | Exceptional — concrete, specific, demonstrated depth |
| 4 | Strong — good answer with examples |
| 3 | Adequate — answered but surface-level |
| 2 | Weak — vague, no examples, or partially answered |
| 1 | Poor — did not answer or significantly off-mark |
