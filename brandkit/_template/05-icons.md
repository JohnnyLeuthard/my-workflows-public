# Icons — {{BRAND_NAME | Your Brand}}

> **Setup note:** Replace every `{{TOKEN | default}}` with your answer from `SETUP.md Section 5`. If you chose "use defaults," Lucide in outline style at 1.5px stroke is ready to use.

## Icon Library Choice

| Field | Decision |
|---|---|
| Icon library | {{ICON_LIBRARY | Lucide}} |
| License | {{ICON_LICENSE | MIT}} |
| Default style | {{ICON_STYLE | Outline}} |
| Default stroke | {{ICON_STROKE | 1.5px}} |
| Default corner style | Rounded |
| Default format | SVG |

## Icon Categories

| Category | Use For | Examples |
|---|---|---|
| Navigation | Moving through views or pages | Home, menu, back, close, search |
| Actions | Things a user can do | Add, edit, save, download, upload, share |
| Status | System state or outcome | Check, warning, error, info, clock |
| People | Users, teams, roles | User, users, badge, contact |
| Documents | Files, notes, records | File, folder, clipboard, book |
| Workflow | Process and steps | Branch, repeat, play, pause, list-check |
| Data | Tables, charts, records | Database, chart, filter, columns |
| Security | Access, privacy, protection | Lock, shield, key, eye, eye-off |

## Size Guide

| Size | Use |
|---|---|
| 16px | Inline labels, dense tables, compact controls |
| 20px | Toolbar buttons, compact navigation |
| 24px | Default interface icons |
| 32px | Empty states, section headers |
| 48px | Large visual moments — use sparingly |

## Color Guide

| Context | Use |
|---|---|
| Default | Primary Text color |
| Secondary or inactive | Muted Text color |
| Link or active | Primary Accent color |
| Success state | Success functional color |
| Warning state | Warning functional color |
| Error state | Error functional color |

## Usage Rules

- Use one icon library and one style per brand. Do not mix.
- Keep stroke weight consistent throughout.
- Use icons to clarify actions — not to decorate every section.
- Pair unfamiliar icons with visible text labels.
- Use the same icon for the same concept everywhere.
- Do not rotate, stretch, skew, or add effects to icons.

## Accessibility

- Every icon-only interactive element needs an accessible text label.
- Decorative icons should be hidden from screen readers (`aria-hidden="true"`).
- Do not rely on icon color alone to communicate state.
- Touch targets should be at least 44px × 44px.
- Provide visible focus states for keyboard navigation.

## File Naming Convention

If storing custom icons, use predictable lowercase names:

```
icon-{category}-{name}.svg
```

Examples:
```
icon-action-download.svg
icon-status-warning.svg
icon-workflow-branch.svg
```

## Customization Checklist

- [ ] Choose one icon library and confirm the license.
- [ ] Replace all `{{PLACEHOLDER}}` tokens with real decisions.
- [ ] Document default size, stroke, and format.
- [ ] Remove categories that don't apply to this brand.
- [ ] Confirm touch target and accessibility rules are met before publishing.
