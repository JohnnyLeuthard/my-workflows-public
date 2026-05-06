# Reference: ICM — Interpretable Context Methodology

## What Is ICM?

Interpretable Context Methodology (ICM) is the principle that **folder structure is architecture**. Instead of throwing everything into a text file or hoping Claude remembers what you said last time, you organize your context *in folders*. Each file has one job. The structure is self-documenting.

When someone opens your folder, they immediately understand what's there and where things live.

## The 5-File Pattern

Every specialist folder contains exactly these five things:

```
specialist-name/
├── identity.md       ← Who is this?
├── rules.md          ← How do they work?
├── examples.md       ← What do they sound like?
├── reference/        ← What do they need to know?
└── README.md         ← How do I use this?
```

### identity.md
**The "about me" file.** Who is this specialist? Background, expertise, point of view. What are they *great* at? What do they explicitly *not* do? Read this first if you want to know if this specialist is right for your problem.

**Tone:** First person. Opinionated. Clear on boundaries.

### rules.md
**The "how I work" file.** What does this specialist always do? Never do? What's the tone? Format? Length defaults? Constraints? This is where you set guardrails.

**Tone:** Prescriptive. Rules, not suggestions.

### examples.md
**The "see it in action" file.** Show 2–3 realistic interactions. A question someone might ask. How does the specialist respond? This trains the voice better than any rule.

**Tone:** Show, don't tell. Real examples beat instruction.

### reference/
**The "research materials" folder.** What does this specialist need to know to do good work? Industry guides, frameworks, checklists, best practices, your internal playbooks, anonymized case studies. The specialist pulls from these.

**Content:** Whatever your specialist domain needs. Can be sparse (2 files) or deep (10 files). Think hard — don't include padding.

### README.md
**The "how to use this" file.** One paragraph someone can follow with zero other context. "Drop this folder into a Claude project. Ask it this way. Expect output that looks like this." That's it.

**Tone:** Ultra-clear, directional, actionable.

---

## Why This Pattern Works

**Reusable:** Drop the folder into any Claude project. No copy-paste. No re-explanation.

**Updatable:** Found a better example? Learned something about your domain? Just edit the file. No hunting through conversation history.

**Self-documenting:** Someone who's never seen this folder before can open it and immediately know what's inside.

**Portable:** Hand it off to a contractor, teammate, or archive it. The structure survives.

**Pedagogical:** Building a folder teaches you *what* a specialist needs. The structure itself is the lesson.

---

## The Bar for "Good"

Someone with zero context should be able to drop your folder into Claude and get real value in under 5 minutes.

If they have to ask you questions or read external docs, the folder isn't done.

---

## Common Mistakes

**Mistake 1: Vague identity.md**
Don't say "I'm a marketing expert." Say "I write B2B SaaS email sequences targeting CTOs in fintech, focusing on technical credibility and compliance concerns."

**Mistake 2: Weak rules.md**
Don't just list platitudes. Give real constraints: "Always include a technical credibility hook. Never use more than 2 CTA buttons. Default length: 150–200 words."

**Mistake 3: Generic examples.md**
Examples must show your specialist *voice*, not just show that it works. Three identical good outputs teach nothing. Show variance: a simple ask, a complex ask, maybe a bad-input recovery.

**Mistake 4: Reference/ bloat or reference/ emptiness**
Don't paste 50 pages of irrelevant material. Don't leave reference/ empty if your specialist actually needs source material. Goldilocks zone: 2–4 files, each meaningful and actually referenced.

**Mistake 5: README that requires explanation**
If someone has to open identity.md to figure out what to do, your README failed. Write it so dense it's obvious.

---

## When NOT to Use ICM

You're building a general utility, not a specialist. ICM assumes you're creating a *narrow, reusable expert*. If your use case is "general assistant" or "flexible tool," folder-based context is overkill.

Otherwise? Use it.
