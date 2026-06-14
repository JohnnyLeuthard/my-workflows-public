# Colors

Use this file as a starter color system for documentation, small websites, workflow dashboards, and generated visual assets. The palette is intentionally soft, contemporary, and easy on the eyes.

## Quick Edit Notes

- Replace these colors with approved brand colors when they exist.
- Keep color names descriptive and tool-friendly.
- Verify contrast before using any foreground and background pair in production.
- Do not include proprietary palettes from another organization.

## Starter Palette

| Token | HEX | RGB | Usage |
|---|---|---|---|
| Ink | #1F2933 | 31, 41, 51 | Primary text, headings, icons on light backgrounds |
| Slate | #52606D | 82, 96, 109 | Secondary text, captions, low-emphasis labels |
| Canvas | #F8FAF7 | 248, 250, 247 | Main page background |
| Surface | #FFFFFF | 255, 255, 255 | Panels, cards, modals, tables |
| Mist | #E8F1EF | 232, 241, 239 | Soft section background, subtle fills |
| Sage | #8FAF9B | 143, 175, 155 | Primary calm accent, tags, selected states |
| Clay | #D9A58A | 217, 165, 138 | Warm accent, highlights, illustrations |
| Sky | #9CC7D8 | 156, 199, 216 | Informational accent, diagrams, links when darkened |
| Lavender | #A695C7 | 166, 149, 199 | Secondary accent, workflow grouping |
| Marigold | #DDB967 | 221, 185, 103 | Attention accent, not for body text |

## Functional Colors

Use functional colors consistently. These are intentionally distinct from the softer brand accents.

| Token | HEX | Usage |
|---|---|---|
| Link | #2F6F62 | Links and primary text buttons |
| Success | #2F6F62 | Success messages and completed states |
| Warning | #8A5A00 | Warnings and review-needed states |
| Error | #9F3A3A | Errors, destructive states, failed checks |
| Info | #4F6F8F | Informational callouts |
| Focus | #6F5A8D | Keyboard focus rings and active outlines |

## Recommended Pairings

These starter pairings pass WCAG AA for normal text based on contrast calculations.

| Foreground | Background | Contrast |
|---|---|---|
| Ink `#1F2933` | Canvas `#F8FAF7` | 14.06:1 |
| Slate `#52606D` | Canvas `#F8FAF7` | 6.15:1 |
| Ink `#1F2933` | Mist `#E8F1EF` | 12.83:1 |
| Ink `#1F2933` | Clay `#D9A58A` | 6.82:1 |
| Ink `#1F2933` | Sky `#9CC7D8` | 8.13:1 |
| Ink `#1F2933` | Lavender `#A695C7` | 5.44:1 |
| White `#FFFFFF` | Link `#2F6F62` | 5.88:1 |
| White `#FFFFFF` | Info `#4F6F8F` | 5.25:1 |
| White `#FFFFFF` | Focus `#6F5A8D` | 5.96:1 |

## Usage Rules

- Use `Canvas` for broad backgrounds.
- Use `Surface` for small framed areas such as cards, tables, and dialogs.
- Use `Ink` for most text.
- Use `Slate` only where lower emphasis is acceptable.
- Use soft accents as supporting color, not as the only sign of meaning.
- Use functional colors for status, validation, and system feedback.
- Pair every color-coded status with text, an icon, or shape.

## Avoid

- Full pages dominated by one accent color.
- Bright saturated backgrounds behind body text.
- Low-contrast pastel text.
- Using warning, error, or success colors decoratively.
- Copying another organization's brand palette into this public starter kit.

## Dark Mode Starter

Only use this section if your workflow or UI supports dark mode.

| Token | HEX | Usage |
|---|---|---|
| Dark Canvas | #111827 | Main dark background |
| Dark Surface | #1F2933 | Panels and navigation |
| Dark Text | #F8FAF7 | Primary text |
| Dark Muted Text | #CBD5D1 | Secondary text |
| Dark Border | #3D4A45 | Dividers and outlines |

Verify every dark-mode pairing before release.
