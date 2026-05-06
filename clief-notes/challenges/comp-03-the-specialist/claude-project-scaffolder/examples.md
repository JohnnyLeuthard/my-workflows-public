# Examples: Claude Project Scaffolder

## Example 1: SaaS Sales Email Specialist

**User asks:**
> I want to build a specialist who writes cold sales emails for B2B SaaS. The specialist should know the difference between email to founders vs. CTOs, and always include specific benefit-focused hooks. I'll train it on email templates from our best performers.

**I respond:**

```
saas-sales-emailer/
├── identity.md
├── rules.md
├── examples.md
├── reference/
│   ├── high-performing-templates.md
│   ├── buyer-personas.md
│   └── copywriting-frameworks.md
└── README.md
```

**File breakdown:**
- `identity.md` — Who the emailer is. Background in B2B SaaS. Explicit point of view on what makes a cold email work. What it *doesn't* do (e.g., doesn't write follow-up sequences).
- `rules.md` — Output format: Email subject + body in this specific structure. Always: personalization hooks. Never: generic openers. Tone: professional but warm.
- `examples.md` — Three real (anonymized) cold emails showing the voice: one to a founder, one to a CTO, one to a head of ops.
- `reference/` — Your templates, buyer personas, your copywriting playbook
- `README.md` — Drop folder in → describe the prospect → expect a cold email draft

**Reference material to gather:**
- 2–3 of your best-performing cold emails (anonymized)
- One doc on founder vs. CTO messaging differences
- Your internal copywriting framework (if you have one)

---

## Example 2: Data Viz Design Critique Specialist

**User asks:**
> I want a specialist who critiques data visualizations. It should catch common mistakes (misleading axes, wrong chart type, color accessibility issues) and suggest better approaches. I'll feed it visual design principles.

**I respond:**

```
dataviz-critiquer/
├── identity.md
├── rules.md
├── examples.md
├── reference/
│   ├── visual-design-principles.md
│   └── common-mistakes.md
└── README.md
```

**File breakdown:**
- `identity.md` — Who the critiquer is. Background in data viz + design. Strong opinions on clarity, accessibility, honesty. Explicit non-scope: doesn't generate new viz, doesn't do interactive design.
- `rules.md` — Output format: Problem → Why it matters → Suggested fix. Tone: constructive, specific. Always cite design principle. Never shame the designer.
- `examples.md` — Three critique scenarios showing different types of mistakes: one with axis issues, one with chart type misuse, one with color/accessibility fail.
- `reference/` — Edward Tufte principles, accessibility guidelines, common chart-type mistakes
- `README.md` — Drop folder in → describe your viz → expect a critique with fixes

**Reference material to gather:**
- Visual design principles doc (your own or a curated collection)
- One checklist of common data viz mistakes

---

## Example 3: Job Interview Prep Coach (Tech)

**User asks:**
> I want to build a coach that helps people prep for behavioral tech interviews. It should ask probing questions about past projects, help them build STAR stories, and give feedback on how they're framing their experience.

**I respond:**

```
tech-interview-coach/
├── identity.md
├── rules.md
├── examples.md
├── reference/
│   ├── interview-frameworks.md
│   ├── star-method.md
│   └── common-traps.md
└── README.md
```

**File breakdown:**
- `identity.md` — Who the coach is. Background: hiring manager experience, interview prep coaching. Explicit: doesn't prep for coding rounds, doesn't write cover letters.
- `rules.md` — Output format: Coaching-style questions → feedback on responses. Tone: encouraging, direct. Always ground feedback in what interviewers are listening for.
- `examples.md` — Two mock interview sessions showing: one weak answer → coaching → strong answer. One project story that's unclear → questions that clarify it.
- `reference/` — STAR method, common behavioral questions, red flags interviewers listen for
- `README.md` — Drop folder in → ask for practice question → get coached responses

**Reference material to gather:**
- STAR framework doc
- 5–6 classic behavioral interview questions
- Doc on what interviewers are actually evaluating
