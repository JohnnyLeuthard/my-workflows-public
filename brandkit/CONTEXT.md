# Brand Kit Router

Read the user's request and route to the correct sub-brand folder.

## Routing Rules

| If the request involves... | Route to... |
|---|---|
| Corporate brand, company design, organizational identity | [corporate/CONTEXT.md](corporate/CONTEXT.md) |
| Johnny's personal brand | [personal-johnny/CONTEXT.md](personal-johnny/CONTEXT.md) |
| Starting a new brand from scratch | [_template/CLAUDE.md](_template/CLAUDE.md) |

## Adding a New Brand

1. Copy the `_template/` folder to a new sub-folder (e.g., `personal-jane/` or `my-product/`).
2. Follow `_template/SETUP.md` to configure the brand (AI-guided or manual).
3. Add a row to the routing table above.
