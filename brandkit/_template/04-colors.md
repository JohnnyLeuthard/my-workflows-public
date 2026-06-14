# Colors — {{BRAND_NAME | Your Brand}}

> **Setup note:** Replace every `{{TOKEN | default}}` with your answer from `SETUP.md Section 4`. If you chose "use defaults," the starter palette below is ready to use as-is.

## Color Mood

Target feel: **{{COLOR_MOOD | Calm and professional}}**

## Primary Palette

| Token | HEX | RGB | Usage |
|---|---|---|---|
| {{COLOR_TEXT_NAME | Primary Text}} | {{COLOR_TEXT_HEX | #1F2933}} | {{COLOR_TEXT_RGB | 31, 41, 51}} | Headings, body copy, icons on light backgrounds |
| {{COLOR_MUTED_NAME | Muted Text}} | {{COLOR_MUTED_HEX | #52606D}} | {{COLOR_MUTED_RGB | 82, 96, 109}} | Captions, labels, secondary copy |
| {{COLOR_BG_NAME | Background}} | {{COLOR_BG_HEX | #F8FAF7}} | {{COLOR_BG_RGB | 248, 250, 247}} | Main page or document background |
| Surface | #FFFFFF | 255, 255, 255 | Panels, cards, modals, tables |
| {{COLOR_PRIMARY_NAME | Primary Accent}} | {{COLOR_PRIMARY_HEX | #2F6F62}} | {{COLOR_PRIMARY_RGB | 47, 111, 98}} | Links, primary buttons, active states |
| {{COLOR_SECONDARY_NAME | Warm Accent}} | {{COLOR_SECONDARY_HEX | #D9A58A}} | {{COLOR_SECONDARY_RGB | 217, 165, 138}} | Supporting accent, highlights, illustrative use |

## Functional Colors

Use these for status and system feedback only. Do not use decoratively.

| Token | HEX | Usage |
|---|---|---|
| Success | #2F6F62 | Completed states, success messages |
| Warning | #8A5A00 | Review-needed states, caution messages |
| Error | #9F3A3A | Errors, destructive actions |
| Info | #4F6F8F | Informational callouts |
| Focus | #6F5A8D | Keyboard focus rings, active outlines |

## Recommended Pairings

Verify contrast with a tool before publishing. Target WCAG AA (4.5:1 for normal text).

| Foreground | Background | Notes |
|---|---|---|
| Primary Text | Background | High contrast — safe for all body text |
| Primary Text | Surface (white) | High contrast — safe for all body text |
| Muted Text | Background | Verify meets 4.5:1 before using for small text |
| White | Primary Accent | Verify meets 4.5:1 before using |

## Usage Rules

- Use Background color for broad layouts.
- Use Surface (white) for cards, tables, and framed areas.
- Use Primary Text for most copy; Muted Text only at lower emphasis.
- Use accents as supporting color — not as dominant fills.
- Pair every color-coded status with text or an icon, never color alone.

## Dark Mode

Dark mode needed: **{{DARK_MODE | Maybe later}}**

If yes, define a dark-mode token set and verify contrast for each pairing before publishing.

## Avoid

- Full-page accent color fills.
- Low-contrast pastel text.
- Using Error, Warning, or Success colors decoratively.
- Copying another organization's palette without permission.
- Using color as the only indicator of meaning or status.

## Customization Checklist

- [ ] Replace all `{{PLACEHOLDER}}` tokens with real color decisions.
- [ ] Verify contrast ratios for all key foreground/background pairs.
- [ ] Confirm the palette matches the brand mood.
- [ ] Add dark mode tokens if needed.
- [ ] Remove any colors that serve no purpose in this brand.
