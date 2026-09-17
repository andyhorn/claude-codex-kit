# Adding the kit to the Flutter template repo

1. Replace the repo's CLAUDE.md with template/CLAUDE.md, keeping any
   project-specific rules the old one had that aren't covered globally.
2. `ln -s CLAUDE.md AGENTS.md` so Codex reads the same project facts.
3. `mkdir -p tasks/done` and commit `tasks/.gitkeep`.
4. Add to .gitignore:
       tasks/.logs/
       .dart_tool/verify/
5. The old skills (add-feature.md, add-screen.md, ...) should become
   project-specific references that the global `feature-workflow` skill
   points to, not a competing workflow. Keep add-firestore-collection,
   add-cloud-function, and add-paywall. They're stack recipes and still useful.
   Fold add-feature and add-screen into the global flow.
6. Drop `.cursor/rules` if you're no longer using Cursor. Otherwise you
   maintain three copies of the same rules.
