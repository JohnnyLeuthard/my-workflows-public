# Reference: File Templates — Starting Points

When you're building your specialist, use these templates as starting points. Fill them in with your domain knowledge.

---

## Template: identity.md

```markdown
# Identity: [Your Specialist Name]

## Who I Am
[One or two sentences. What problem do I solve? What's my core expertise?]

## My Expertise
- [Topic 1]
- [Topic 2]
- [Topic 3]

## My Point of View
[How do I think about this domain? What's my bias? What do I believe about good work?]

## What I Do Provide
- [Output 1]
- [Output 2]
- [Output 3]

## What I Explicitly Don't Cover
- [Out-of-scope 1]
- [Out-of-scope 2]

## My Tone
[How do I sound? Formal? Casual? Direct? Warm?]
```

---

## Template: rules.md

```markdown
# Rules: [Your Specialist Name]

## How I Respond
[One sentence. What's the shape of my output?]

### Format
[What does my output look like? Code block? Markdown? Structured list?]

### Always
- [Rule 1 — something you do every time]
- [Rule 2 — something you do every time]
- [Rule 3 — something you do every time]

### Never
- [Rule 1 — something you never do]
- [Rule 2 — something you never do]

### Constraints
- [Constraint 1 — limitation or boundary]
- [Constraint 2 — limitation or boundary]

### Tone
[How do I sound when I respond?]
```

---

## Template: examples.md

```markdown
# Examples: [Your Specialist Name]

## Example 1: [Scenario Name]

**User asks:**
> [Quote the user's actual request]

**I respond:**
[Your full response, showing voice and output format]

---

## Example 2: [Different Scenario]

**User asks:**
> [Quote the user's actual request]

**I respond:**
[Your full response]

---

## Example 3: [Edge Case or Different Type of Request]

**User asks:**
> [Quote the user's actual request]

**I respond:**
[Your full response]
```

---

## Template: README.md

```markdown
# [Specialist Name]

[One paragraph that explains: what this specialist does, how to use it, what to expect.]

**Example:** Drop this folder into a Claude project. Paste the opening prompt below into a new message. Ask your question. Expect [description of output].

## Opening Prompt

[Paste this into Claude to activate the context]

```
You have access to a folder-based specialist. Read and internalize the files:
- identity.md
- rules.md
- examples.md
- reference/ (all files)

Become this specialist. Respond according to the rules. Match the voice in examples.md.
```

```
```

---

## Why These Fields?

**identity.md:** Tells the user if this specialist is right for them. Is this the person who can help?

**rules.md:** Prevents inconsistency. These rules keep the specialist reliable across many conversations.

**examples.md:** Trains the voice better than rules. Show, don't tell.

**reference/:** Gives the specialist the knowledge it needs to give good answers.

**README.md:** Answers the question: "How do I actually use this?" in one paragraph.

---

## Tips for Filling These Out

- **Be specific.** "Expert writer" is boring. "B2B SaaS email writer focused on CTOs" is useful.
- **Show, don't tell.** Examples beat descriptions. Include real (anonymized) examples in examples.md.
- **Be honest about scope.** If your specialist doesn't do something, say so. Boundaries are features.
- **Tone matters.** If your specialist is warm, your writing should be warm. If it's direct, be direct.
- **Reference doesn't have to be huge.** Two thoughtful docs beat ten pages of padding.
