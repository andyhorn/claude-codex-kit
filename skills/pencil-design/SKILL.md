---
name: pencil-design
description: Design screens and components in Pencil through its MCP server, using the project's design tokens. Use when the user wants to design, mock up, or iterate on UI before implementation, or when feature-workflow Phase 1 runs.
---

# Designing in Pencil

If you have a more specific Pencil skill with exact tool names, follow its
tool usage. This skill defines the workflow and the rules.

## Before designing
1. Read the project's tokens: Pencil variables first, then
   `lib/app/theme/` (or wherever ARCHITECTURE.md says the theme lives).
   If they disagree, stop and ask which is correct.
2. Check `references/design-rules.md`.

## Design loop
1. Build a low-fidelity layout first: structure, hierarchy, and spacing only.
   Screenshot it and get a quick yes/no from the user before styling. Restyling
   a wrong layout wastes the most tokens in design work.
2. Apply tokens. Only use existing variables. If a new value is needed, add it
   as a variable and list it under "New tokens".
3. Design every state the spec needs: loading, empty, error, populated. A
   screen without an empty state isn't finished.
4. Check at a 375pt-wide phone frame. Add a tablet frame only if the spec asks.
5. Screenshot each final frame and review it against design-rules.md
   before showing the user.

## Budget
- Screenshots are expensive. Take them at checkpoints, not after every change.
- Batch design operations instead of one element per call.
- Name frames `<Feature>/<Screen>/<State>` so design-to-flutter can find them
  without searching.

## Output
- Frame names
- New tokens (name, value, purpose)
- Open questions for the spec
