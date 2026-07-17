# Toby Iverson — Worth the Ride

Comp #8: The Wildcard. Your repo was read in full: [github.com/BytesFromToby/worth-the-ride](https://github.com/BytesFromToby/worth-the-ride) (commit d47f8145).

---

Worth the Ride works because you built the map before the planner. trail-network.md is a real connectivity graph — hubs, spokes, junction landmarks, and honest warnings where you aren't sure ("there isn't one clean signed trail the whole way. Confirm a comfy connector") — and that's why the outputs are rides instead of plausible inventions. Pilots have planned this way for a century: known waypoints, live weather on top, wind deciding the direction of the loop. Your "ride out into the headwind, come home with the tailwind" rule is that tradition written down, with an 8 mph threshold.

The reframe I'd keep: a close destination doesn't shorten the ride, it anchors a longer loop. That's judgment encoded, not preference.

One push. The whole thesis is breaking your own autopilot, and rule 4.4 favors directions you don't usually take — but nothing remembers which directions you took. A one-line-per-ride log (date, destination, keeper or not) that rule 4.4 reads before scoring would close the loop; it's the same mechanism Craig's corrections-log uses for voice. Right now the planner is stateless in the one place your problem is stateful.

---

An idea worth naming, and it is yours: destination as waypoint — with its consequence, the 80% loop-budget rule, which is what turns "I've got three hours" into a route that actually fills them.

Worth a look:
- [Craig Howard — Voice Engine](https://github.com/craig-atr/voice-engine) — the corrections-log shape your ride log wants
