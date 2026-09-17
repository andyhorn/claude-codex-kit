---
name: design-to-flutter
description: Implement Flutter widgets from approved Pencil frames using the project's theme tokens. Use when turning a design into code, or when feature-workflow Phase 4 has a UI chunk.
---

# Pencil frames -> Flutter

## Inputs
Spec path and frame names (`<Feature>/<Screen>/<State>`).

## Steps
1. Read frame structure and variables from Pencil. Take one screenshot per
   screen for reference; don't screenshot every state.
2. Map every visual value with `references/token-mapping.md`. Any value that
   doesn't map to a token is a bug in the design or the theme. Ask; don't
   hardcode it.
3. Build the first screen yourself to set the pattern: widget breakdown, file
   layout, how the screen reads providers, state handling.
4. Later screens that follow the same pattern go to `codex-delegate`, with the
   first screen's path given as the pattern to copy.
5. Widget tests cover each designed state. Test writing goes to Codex.

## Widget structure rules
- One public screen widget per route, composed from private or feature-local widgets.
- Screens watch providers; child widgets take plain values and callbacks.
- No `MediaQuery` magic numbers. Use the spacing tokens and LayoutBuilder when needed.
- Extract a widget when it's reused or over ~80 lines, not before.
- `const` constructors everywhere possible.

## Fidelity check
After verify passes, take one screenshot of the running widget (golden test
or simulator) and compare it to the frame. List differences. Don't loop on
pixel-perfection: spacing and color mismatches are bugs; 1pt differences are not.
