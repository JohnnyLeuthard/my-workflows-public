# Screening Questions — 2026-06-SeniorDevOpsEngineer-FTE

## Phone Screen Questions

| Question ID | Category | Question | Required | Notes |
|------------|----------|----------|----------|-------|
| Q-001 | Technical | Walk me through a Kubernetes deployment you owned end-to-end. What was the scale and what challenges did you face? | Yes | Listen for: cluster size, RBAC setup, upgrade strategy, incident handling |
| Q-002 | Technical | How do you manage Terraform state in a team environment? What pitfalls have you encountered? | Yes | Listen for: remote state, state locking, workspace patterns, import experience |
| Q-003 | Technical | Describe your experience with CI/CD pipeline design. What is the most complex pipeline you built and what did it do? | Yes | Listen for: multi-stage builds, secrets management, rollback strategy |
| Q-004 | Behavioral | Tell me about a production incident you were directly involved in. What was your role and what did the team learn? | Yes | STAR format expected; evaluate composure, communication, follow-through |
| Q-005 | Behavioral | Describe a time you introduced a significant DevOps improvement in an organization. How did you drive adoption? | Yes | Evaluate leadership and change management beyond just technical skill |

## Round 1 — Technical Deep Dive

| Question ID | Category | Question | Required | Notes |
|------------|----------|----------|----------|-------|
| Q-006 | Technical | How would you design a zero-downtime deployment strategy for a stateful application on Kubernetes? | Yes | Expect: rolling updates, PodDisruptionBudgets, readiness probes, persistent volume handling |
| Q-007 | Technical | You have a Terraform module that needs to be updated in a way that will destroy and recreate a production database. How do you handle this? | Yes | Expect: `prevent_destroy`, `terraform plan` review, blue-green, explicit approval gates |
| Q-008 | Situational | It is 11pm and your monitoring alerts that 40% of pods in the primary namespace are in CrashLoopBackOff. Walk me through your diagnostic and recovery process. | Yes | Evaluate systematic debugging; listen for: `kubectl describe`, events, logs, rollback trigger |

## Culture / Fit

| Question ID | Category | Question | Required | Notes |
|------------|----------|----------|----------|-------|
| Q-009 | Culture | How do you approach mentoring junior engineers on DevOps practices? Give a specific example. | No | Role requires mentorship; flag if candidate has never mentored or refuses to |
| Q-010 | Culture | What does "DevOps culture" mean to you beyond the tooling? | No | Listen for: collaboration, shared responsibility, blameless post-mortems |
