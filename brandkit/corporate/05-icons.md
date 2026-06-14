# Icons

Use this file to choose and apply icons consistently across workflow docs, generated UI, diagrams, and public examples.

## Quick Edit Notes

- If your project has an approved icon library, name it here.
- If no library exists, use a common open-source library and document the choice.
- Do not include proprietary icon package names, internal asset links, or private file inventories in this public starter kit.

## Starter Recommendation

For generic public projects, use a simple outline icon style with consistent stroke weight. Lucide, Heroicons, Material Symbols, and similar libraries can all work. Choose one library per project.

Document your choice:

| Field | Decision |
|---|---|
| Icon library | [Library name] |
| License | [License] |
| Default style | Outline |
| Default stroke | 1.5px or 2px |
| Default corner style | Rounded |
| Default format | SVG |

## Icon Categories

| Category | Use For | Examples |
|---|---|---|
| Navigation | Moving through pages or views | Home, menu, back, close, search |
| Actions | Commands a user can take | Add, edit, save, download, upload |
| Status | System state or result | Check, warning, error, info |
| Security | Access, privacy, protection | Lock, shield, key, eye |
| Documents | Files, notes, reports | File, folder, clipboard, book |
| Workflow | Process and automation | Branch, repeat, play, pause, list-check |
| People | Users, teams, roles | User, users, badge, contact |
| Data | Tables, charts, records | Database, chart, filter, columns |

## Size Guide

| Size | Use |
|---|---|
| 16px | Inline labels, dense tables, compact controls |
| 20px | Toolbar buttons, compact navigation |
| 24px | Default interface icons |
| 32px | Empty states, section headers, feature summaries |
| 48px | Large visual moments, sparingly |

## Color Guide

| Context | Color |
|---|---|
| Default | Ink `#1F2933` |
| Secondary | Slate `#52606D` |
| Link or active | Link `#2F6F62` |
| Success | Success `#2F6F62` |
| Warning | Warning `#8A5A00` |
| Error | Error `#9F3A3A` |
| Dark background | Dark Text `#F8FAF7` |

## Usage Rules

- Use one icon style per project.
- Keep stroke weight consistent.
- Use icons to clarify actions, not decorate every section.
- Pair unfamiliar icons with text labels.
- Use the same icon for the same concept everywhere.
- Do not rotate, stretch, skew, or add decorative effects.
- Do not mix filled, outlined, and duotone styles unless the design system explicitly allows it.

## Accessibility

- Every interactive icon-only button needs an accessible label.
- Decorative icons should be hidden from assistive technology.
- Do not rely on icon color alone to communicate state.
- Touch targets should be at least 44px by 44px.
- Use visible focus states for keyboard navigation.

## Naming Convention

Use predictable lowercase names when storing custom icons.

```text
icon-{category}-{name}.svg
```

Examples:

```text
icon-action-download.svg
icon-status-warning.svg
icon-workflow-branch.svg
```

## Customization Checklist

- [ ] Choose one icon library.
- [ ] Confirm the license allows your intended use.
- [ ] Document default size, stroke, and format.
- [ ] Map common actions to specific icons.
- [ ] Remove any proprietary icon references.
