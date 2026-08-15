# AI Workflow Failure Diagnostician ICM - Project Brief

## Purpose

Build an Interpretable Context Module (ICM) for Weekly Comp #10: The Diagnostician.

The ICM diagnoses why folder-based Claude/AI workflows produce inconsistent, wrong, or unusable outputs. It works backward from a failed output, the project folder structure, and the workflow instructions to identify one primary cause.

It does not rewrite prompts, fix workflows, or provide an implementation plan. It explains why the workflow failed and how the evidence supports that diagnosis.

## Challenge Summary

The challenge asks for a folder-based AI diagnostician that reads something broken and explains why it broke.

Required deliverable:

- `identity.md` - who the diagnostician is and what it diagnoses
- `rules.md` - how it diagnoses and separates cause from symptom
- `examples.md` - 2-3 example diagnoses with reasoning
- `reference/` - common failure modes, frameworks, and benchmarks
- `README.md` - how to use it and what to feed it

The key judging standard is diagnosis, not critique or repair.

The output must:

- Name one primary cause
- Show reasoning
- Separate symptoms from root cause
- Stop before rewriting, editing, or prescribing fixes

## Current Direction

Working title:

**AI Workflow Failure Diagnostician ICM**

Possible folder/repo name:

`ai-workflow-failure-diagnostician-icm`

Specific domain:

> Diagnoses why folder-based Claude and AI workflows produce inconsistent, wrong, or unusable outputs.

Submission pitch draft:

> This ICM diagnoses why folder-based Claude and AI workflows produce inconsistent, wrong, or unusable outputs. It works backward from the failed output, project folder structure, and instructions to identify one primary cause such as context routing failure, role confusion, instruction conflict, or missing output contract. It does not rewrite prompts or fix the workflow; it explains why the workflow failed and how the evidence points to that cause.

## Why This Direction Was Chosen

Rejected directions:

- CyberArk EVD query diagnostician: strong fit for existing technical work, but too niche for the challenge audience.
- Resume callback diagnostician: more broadly useful, but too subjective and affected by hidden variables outside the artifact.

Chosen direction:

- AI workflow failure is a real problem many Claude/project builders have.
- The failure is often visible in the project artifacts: folder structure, context files, instructions, user input, and output.
- The domain fits folder-based context methodology.
- The ICM can diagnose concrete causes instead of guessing from external market conditions.
- The creator has existing strengths in workflow structure, reusable project design, AI-assisted process design, and context architecture.

## Target User

The target user is someone building reusable AI workflows, Claude projects, prompt folders, agent instructions, or small automation systems.

They have a workflow that appears organized but fails in practice:

- It gives inconsistent answers.
- It ignores instructions.
- It produces technically valid but useless outputs.
- It edits when it should diagnose.
- It skips required steps.
- It works for the creator but not for other users.
- It reads too much context or the wrong context.

## What The User Provides

Minimum useful input:

- The failed output
- The user request that produced the failed output
- The relevant instructions, prompt files, or folder structure
- A short description of what should have happened

Optional input:

- The full folder tree
- Relevant `README.md`, `CLAUDE.md`, `AGENTS.md`, or context files
- Multiple failed runs
- The model/tool used
- Any constraints the workflow was supposed to follow

## Diagnostic Output Shape

The ICM should produce a concise diagnosis with this shape:

1. Primary cause
2. Why this is the cause
3. Evidence from the artifacts
4. Symptoms that are not the root cause
5. Confidence level
6. What information would change the diagnosis

The ICM must not include:

- A rewritten prompt
- A fixed folder structure
- A checklist of every issue
- A step-by-step repair plan
- Generic best practices

## Candidate Primary Cause Categories

### Context Routing Failure

The workflow does not clearly tell the model which files to read, in what order, or when to stop loading context.

Common symptoms:

- The model misses important instructions.
- The model uses irrelevant files.
- The output blends unrelated parts of the project.
- Results vary depending on which files were loaded.

Primary cause test:

If the workflow would improve mainly by defining context selection and routing hierarchy, the root cause is context routing failure.

### Role Confusion

The workflow assigns multiple incompatible jobs to the same agent or file without clear boundaries.

Common symptoms:

- The model critiques, edits, and executes in the same answer.
- The output mixes strategy, implementation, and review.
- The model cannot tell whether to ask questions or proceed.

Primary cause test:

If the workflow fails because the model does not know which hat it is wearing, the root cause is role confusion.

### Output Contract Failure

The workflow never defines what a successful output must contain, omit, or optimize for.

Common symptoms:

- The model gives plausible but unusable output.
- The output format changes across runs.
- The answer sounds good but cannot be acted on.
- The model over-explains or under-specifies.

Primary cause test:

If the workflow has enough input context but no clear definition of the expected artifact, the root cause is output contract failure.

### Input Ambiguity

The user request or workflow entry point does not include enough information to make the intended decision.

Common symptoms:

- The model makes assumptions.
- The output is generic.
- The model solves a neighboring problem.
- Different reasonable interpretations produce different outputs.

Primary cause test:

If no well-designed instruction set could reliably answer without additional input, the root cause is input ambiguity.

### Instruction Conflict

Two or more instructions point in different directions with no clear authority order.

Common symptoms:

- The model follows one rule while violating another.
- It alternates behavior across runs.
- The output contains signs of competing priorities.
- The model partially satisfies multiple goals but completes none cleanly.

Primary cause test:

If the workflow contains incompatible instructions and no precedence rule, the root cause is instruction conflict.

### Stage Boundary Failure

The workflow blends phases that should be separated, such as diagnosis, planning, execution, and verification.

Common symptoms:

- The model jumps to fixes before diagnosing.
- Review gates are skipped.
- Later-stage assumptions appear before earlier-stage evidence.
- The output is hard to validate because multiple stages happened at once.

Primary cause test:

If the failure comes from collapsing a multi-stage process into one undifferentiated step, the root cause is stage boundary failure.

### Reference Bloat

The workflow provides too much undifferentiated context, causing important instructions to lose salience.

Common symptoms:

- The model references low-priority material.
- Important constraints are present but ignored.
- The answer becomes broad and unfocused.
- The workflow gets worse as more reference files are added.

Primary cause test:

If the right information exists but is buried among too much unrelated context, the root cause is reference bloat.

## Example Scenarios To Develop

### Example 1: Claude Ignores The Folder Rules

Scenario:

A project has many instruction files. Claude gives an answer using irrelevant reference material and misses the current task rules.

Likely primary cause:

Context routing failure.

Why:

The workflow lacks a clear entry file that tells Claude which files to load for the current task and when to stop.

### Example 2: The Workflow Keeps Giving Advice Instead Of Diagnosis

Scenario:

The user asks why an AI workflow failed. The output gives a list of prompt improvements and a rewritten instruction file.

Likely primary cause:

Stage boundary failure or role confusion.

Need to decide which is primary based on artifact evidence.

### Example 3: The Output Sounds Good But Cannot Be Used

Scenario:

An automation workflow produces long, polished responses, but every run has a different structure and none are easy to hand off.

Likely primary cause:

Output contract failure.

Why:

The instructions describe the topic and tone but never define the expected artifact shape, acceptance criteria, or stopping condition.

## Open Questions

- Should the ICM focus specifically on Claude Projects, or stay broader as "folder-based Claude/AI workflows"?
- Should `AGENTS.md`, `CLAUDE.md`, and `CONTEXT.md` be named explicitly, or should examples stay tool-agnostic?
- What is the cleanest diagnostic output template?
- How strict should the ICM be about refusing to fix the workflow?
- Should reference failure modes each live in separate files, or one consolidated `reference/failure_modes.md`?

## Next Steps

1. Decide the final title and folder name.
2. Draft `identity.md`.
3. Draft `rules.md` with the diagnostic method and anti-patterns.
4. Build `reference/failure_modes.md`.
5. Write 2-3 strong examples in `examples.md`.
6. Write the final `README.md`.
7. Test the ICM against one broken workflow artifact and revise.

## Current Status

Initial concept selected and project brief created.

No final ICM files have been created yet.
