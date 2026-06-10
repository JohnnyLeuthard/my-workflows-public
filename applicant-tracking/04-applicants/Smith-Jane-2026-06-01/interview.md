# Interview Record — Smith-Jane-2026-06-01

**Job**: 2026-06-SeniorDevOpsEngineer-FTE  

---

## Round 1 — Phone Screen

**Date**: 2026-06-05  
**Interviewer(s)**: Jordan Ellis (Hiring Manager)  
**Duration**: 45 minutes  
**Format**: Video call  
**Status**: Completed  

### Questions

| Question ID | Category | Question | Asked | Response Summary | Rating (1–5) | Follow-up Needed | Notes |
|------------|----------|----------|-------|-----------------|--------------|-----------------|-------|
| Q-001 | Technical | Walk me through a Kubernetes deployment you owned end-to-end. | Yes | Described 150-node EKS cluster at CloudScale; covered RBAC, pod security policies, cluster autoscaler config, and upgrade runbook with canary approach. | 5 | No | Extremely detailed; clearly owns this |
| Q-002 | Technical | How do you manage Terraform state in a team environment? | Yes | Uses S3 backend with DynamoDB locking; described workspace-per-environment pattern and import strategy for legacy resources. | 5 | No | Mentioned specific pitfalls with state drift |
| Q-003 | Technical | CI/CD pipeline experience. | Yes | Designed GitHub Actions pipeline with reusable composite actions; multi-stage: lint → test → security scan → build → deploy. | 5 | No | Mentioned secrets via OIDC, not static keys |
| Q-004 | Behavioral | Production incident story. | Yes | P1 Kubernetes node group exhaustion at 2am; walked through detection (PagerDuty), triage (kubectl events, Prometheus), mitigation (ASG scaling), and post-mortem write-up. | 5 | No | Blameless PM, shared learnings with full org |
| Q-005 | Behavioral | Introduced a significant DevOps improvement. | Yes | Drove adoption of IaC across 12 product teams; created internal scaffolding CLI, ran lunch-and-learns, got exec buy-in on a 3-month rollout plan. | 4 | No | Strong change management narrative |

### Overall Round Assessment

**Strengths Observed**:
- Deep Kubernetes expertise beyond surface-level knowledge
- Security-conscious (OIDC for CI, PodSecurityPolicies, RBAC)
- Excellent communication; explained technical concepts clearly and concisely

**Concerns Raised**: None  
**Round Recommendation**: Advance — schedule technical deep dive  
**Interviewer Notes**: This is a top-tier candidate. Schedule Round 2 with the Platform Engineering team ASAP.

---

## Round 2 — Technical Deep Dive

**Date**: 2026-06-12  
**Interviewer(s)**: Jordan Ellis + Sam Park (Staff Engineer)  
**Duration**: 90 minutes  
**Format**: Video call with shared screen  
**Status**: Completed  

### Questions

| Question ID | Category | Question | Asked | Response Summary | Rating (1–5) | Follow-up Needed | Notes |
|------------|----------|----------|-------|-----------------|--------------|-----------------|-------|
| Q-006 | Technical | Zero-downtime deployment for stateful app on Kubernetes. | Yes | Described PodDisruptionBudgets, StatefulSet rolling update strategy, readiness probes, PVC claim handling, and pre-upgrade data backup hooks. | 5 | No | Added discussion of operator pattern for complex state |
| Q-007 | Technical | Terraform change that destroys/recreates prod database. | Yes | Immediately cited `prevent_destroy` lifecycle rule; described blue-green approach + Terraform plan review gate in CI; used `terraform state mv` to avoid recreation where possible. | 5 | No | Identified edge case with RDS multi-AZ behavior |
| Q-008 | Situational | 40% pods CrashLoopBackOff at 11pm. | Yes | Systematic: kubectl describe → events → container logs → previous logs → node conditions → resource quotas. Identified likely OOM due to recent memory limit reduction. Described rollback trigger and PagerDuty escalation path. | 4 | No | Strong but could have mentioned tracing/APM sooner |
| Q-009 | Culture | Mentoring junior engineers. | Yes | Runs weekly 1:1s with junior team members; described pair-programming sessions on IaC reviews and a "DevOps 101" internal training series she created. | 5 | No | Exactly what the role needs |
| Q-010 | Culture | What does DevOps culture mean beyond tooling? | Yes | "Shared responsibility, psychological safety, and blameless learning. The tools are just the medium — the goal is that dev and ops succeed or fail together." | 5 | No | Perfect framing |

### Overall Round Assessment

**Strengths Observed**:
- Handles edge cases and failure scenarios naturally
- Strong mentorship experience — runs structured programs, not just ad hoc help
- Cultural philosophy is well-articulated and aligned

**Concerns Raised**: None  
**Round Recommendation**: Extend offer  
**Interviewer Notes**: Sam Park said "hire immediately." Unanimous recommendation. Prepare offer letter.

---

## Offer Details

**Offer Extended**: 2026-06-16  
**Offer Accepted**: 2026-06-18  
**Start Date**: 2026-07-14  
**Notes**: Candidate requested 2-week gap between current job end and start. Approved.
