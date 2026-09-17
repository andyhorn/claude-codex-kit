# Routing: who does the work

## Gate: gathering comes before routing
Before you can answer any question below, you may need to look at the codebase.
Don't do that in the main session. If deciding the route needs a file you
haven't already read, dispatch `explorer` first, then come back and route.
Two files is the main session's reading budget; a third means dispatch.

Reading is the largest cost in the main session and the one that never presents
itself as a decision, which is why it gets its own gate rather than a rule.

## Then ask in this order. The first "yes" wins.

1. Does it need a decision the spec doesn't make (API shape, state ownership,
   data model)? -> Main session. Make the decision, update the spec, then re-route.
2. Is it read-only (search, explain, audit)? -> `explorer` agent.
3. Does it need a spec that doesn't exist yet? -> Codex drafts it
   (`codex-delegate` Mode 1), you critique it. Don't explore by hand to write one.
4. Is it at most ~3 edits, confined to files already in context, needing no new
   file opened and no new pattern looked up? -> Main session. A round trip costs
   more than the edit.
   This is the rule that leaks. "I'll just look at one more file" means the
   answer was no. Re-route instead of finishing.
5. Is it UI implementation from an approved Pencil design? -> Main session with
   `design-to-flutter` for the first screen that sets up the pattern. Codex for
   later screens that copy it.
6. Everything else with a spec: implementation, tests, codegen fixes,
   migrations, repetitive refactors, l10n -> Codex.

## Always Claude
These are *decisions*. Claude makes the call and writes it into the spec; Codex
may then implement it from that spec. Only the last one stays Claude's to write.
- Theme and token setup
- Riverpod provider graph design
- go_router structure and redirects
- RevenueCat entitlement logic
- Firestore security rules (Codex may draft them; Claude must review and own them)

## Codex is especially good at
- Drafting a spec against an existing codebase
- Writing widget and unit test suites against a finished implementation
- `build_runner` fallout after model changes
- Mechanical migrations across many files
- Second-opinion review of Claude's code

## When Codex is out of quota
Fall back to the `builder` agent (sonnet) with the same spec, limited to the
files the spec names. This is a fallback, not an alternative: it spends the
budget the kit exists to protect. Prefer waiting for quota on anything that
isn't blocking.
