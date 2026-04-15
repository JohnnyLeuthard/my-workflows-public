# Acme Company - Workspace map

<!--
===========================================
bla bla bla.....

xxxxx
https://www.youtube.com/watch?v=MkN-ss2Nl10&t=458s

=========================================

-->

## What Ths is
a workspace system for Acme Company...

**CONTEXT.md** (top-level) routes you to the right workpace. This file is the map/

---
## Folder Structure

```
.
├── _examples
├── CLAUDE.md    # You are here 
├── CONTEXT.md
├── example.md
├── claude-office-skills-ref
├── community
├── production                
│   ├── docs
│   ├── src
│   ├── workflows
│   │   ├── 01-briefs
│   │   ├── 02-specs
│   │   ├── 03-builds
│   │   ├── 04-output
│   │   └── CONTEXT.md
│   └── CONTEXT.md
├── writing-room
|       ├── 00-temp
|       └── CONTEXT.md
└── START-HERE.md

```
---

## Quick Navigation

| what to... | Go here|
|------------|--------|
| **write a blog post or tutoril** | `writing-room/CONTEXT.md` |
| **EVD Query**      | `EVD/CONTEXT.md`  |


---

## Cross-Workspae Flow

```

writing-room (voice + style + polished drats)
    ↓
production (draft → spec → build → deliverable )
 
 community (repurposes content from writing room and production)
    ↑ uses writing-room voice bla bla bla
    ↑ uses production deliverables as assets 
```

<!--
TEACHING NOTE: bla bla bla

nla2 bla3 bla4

Just notes. Probably nit in a real file just what i saw in the turorial. 
-->

---

## ID & Nameing Conventions


| Content Type | Pattern | Example |
|--------------|---------|---------|
| Blog drafts | `[slug]-[status].md` | `api-auth-guide-draft.md` |
| Tutorials | `[slug]-[status].md` | `getting-started-final.md` |
| Build specs | `[slug]-spec.md` | `auth-demo-spec.md` |
| Deliverables | `[slug]-v[n].[ext]` | `auth-demo-v2.mp4` |
| Newsletters | `[YYYY-MM-DD]-[slug].md` | `2026-03-10-launch-week.md` |
| Social posts | `[platform]-[slug].md` | `twitter-launch-announce.md` |

**Statuses:** `draft` → `review` → `final`

---

## File Placement Rules

### Writng
- **Drafts:** `Writing-room/drafts/[slug]-[status].md`
- **Final:** `writing-room/final/[slug]-final.md`
- **Ready for Producation:** Copy to `prduction/workfows/01-briefs/`
- 

