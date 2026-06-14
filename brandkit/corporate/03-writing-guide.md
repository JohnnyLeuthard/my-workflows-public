# Writing Guide

Use this file as a lightweight style guide for reusable workflow documentation.

## Quick Edit Notes

- Keep rules specific enough that another contributor can follow them.
- Add project-specific terms only after they are approved.
- Remove examples that do not match your workflow.

## Document Structure

Use this order for most workflow docs:

1. What this is
2. When to use it
3. What to edit
4. How to run or apply it
5. What output to expect
6. Review or approval steps
7. Troubleshooting or notes

## Headings

- Use title case for top-level headings.
- Keep headings short.
- Make headings describe the section, not the mood.
- Avoid clever headings in technical docs.

Good:

- `Setup`
- `Inputs`
- `Review Steps`
- `Output Files`

Avoid:

- `Let's Make Magic`
- `The Fun Part`
- `Important Stuff`

## Formatting

| Item | Preferred Style |
|---|---|
| File paths | Use inline code, like `folder/file.md`. |
| Commands | Reference existing scripts instead of writing inline execution code. |
| Placeholders | Use brackets, like `[Project name]`. |
| Dates | Use exact dates, like `May 28, 2026`. |
| Lists | Use bullets for options and numbered lists for ordered steps. |
| Warnings | State the risk and the action to take. |

## Terminology

| Use | Avoid |
|---|---|
| workflow | process magic, automation thing |
| reference | source of truth, unless it truly is authoritative |
| starter kit | final brand system |
| placeholder | fake data |
| customize | personalize, tweak endlessly |
| public-safe | sanitized, scrubbed |

## Placeholder Rules

- Use placeholders only where the user must supply real information.
- Do not create fake names, fake companies, fake metrics, fake reports, or fake outputs.
- Label starter examples clearly as defaults or examples.
- Remove placeholder language once real project guidance exists.

## Accessibility and Inclusion

- Write for readers who are new to the workflow.
- Avoid idioms that may not translate well.
- Avoid ableist language.
- Do not rely on color alone to explain status or meaning.
- Make links descriptive enough to understand out of context.

## Review Checklist

- [ ] The document says what it is for.
- [ ] The next action is clear.
- [ ] Placeholders are obvious.
- [ ] No private company information is included.
- [ ] Claims are supported by actual project facts.
- [ ] The file is short enough to use as AI context.
