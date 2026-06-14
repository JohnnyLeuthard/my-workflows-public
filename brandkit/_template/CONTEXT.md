# Brand Kit Template Router

Route to the correct file based on what the user needs.

## Routing Rules

| If the request involves... | Load... |
|---|---|
| Starting setup, the full walkthrough, or brand basics | [CLAUDE.md](CLAUDE.md) + [SETUP.md](SETUP.md) |
| Brand purpose, personality, audience, positioning | [01-primary-brand.md](01-primary-brand.md) |
| Voice, tone, communication style | [02-voice-and-tone.md](02-voice-and-tone.md) |
| Writing rules, formatting, terminology | [03-writing-guide.md](03-writing-guide.md) |
| Colors, palettes, visual mood | [04-colors.md](04-colors.md) |
| Icons, pictograms, symbols | [05-icons.md](05-icons.md) |
| Logo, wordmark, lockups | [06-logo.md](06-logo.md) |

## Loading Rules

- For full brand setup, load `CLAUDE.md` and `SETUP.md` first, then each numbered file in order.
- For a single brand element, load only the file that covers it.
- Remove all `{{PLACEHOLDER}}` tokens before using files in downstream workflows.
