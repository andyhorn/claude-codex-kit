# Routing: who does the work

Ask in this order. The first "yes" wins.

1. Does it need a decision the spec doesn't make (API shape, state ownership,
   data model)? -> Main session. Make the decision, update the spec, then re-route.
2. Is it read-only (search, explain, audit)? -> `explorer` agent.
3. Is it fewer than ~3 small edits in files you already have open? -> Main
   session. A spec round-trip costs more than the edit.
4. Is it UI implementation from an approved Pencil design? -> Main session with
   `design-to-flutter` for the first screen that sets up the pattern. Codex for
   later screens that copy it.
5. Everything else with a spec: implementation, tests, codegen fixes,
   migrations, repetitive refactors, l10n -> Codex.

## Always Claude
- Theme and token setup
- Riverpod provider graph design
- go_router structure and redirects
- RevenueCat entitlement logic
- Firestore security rules (Codex may draft them; Claude must review)

## Codex is especially good at
- Writing widget and unit test suites against a finished implementation
- `build_runner` fallout after model changes
- Mechanical migrations across many files
- Second-opinion review of Claude's code

## When Codex is out of quota
Route to a Sonnet subagent with the same spec, and limit it to the listed files.
