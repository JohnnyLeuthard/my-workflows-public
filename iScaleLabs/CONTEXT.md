# iScaleLabs — Router

Read the user's request and route to the correct project.

## Routing Rules

| If the request involves...                                              | Route to...                                      |
|-------------------------------------------------------------------------|--------------------------------------------------|
| Agent control, "control your agent", hello-world tutorial, AGENTS.md stages | [hello-world/AGENTS.md](hello-world/AGENTS.md) |

*Add a row here whenever a new project is added under `iScaleLabs/`.*

## Global Constraints

- **Route first, then load**: Do not open project files until you have identified which project the request belongs to.
- **Follow project AGENTS.md**: Each project drives execution through its own `AGENTS.md` chain. Start at the project root `AGENTS.md` and follow the stage sequence it describes.
