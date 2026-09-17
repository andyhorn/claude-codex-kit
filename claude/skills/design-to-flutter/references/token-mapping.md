# Pencil variables -> Flutter theme

Fill this in per project, or keep the project's version in ARCHITECTURE.md and
point here. Suggested naming contract:

| Pencil variable | Flutter |
|---|---|
| color/primary | `Theme.of(context).colorScheme.primary` |
| color/on-primary | `colorScheme.onPrimary` |
| color/surface | `colorScheme.surface` |
| color/surface-container | `colorScheme.surfaceContainer` |
| color/error | `colorScheme.error` |
| color/<custom> | `context.appColors.<custom>` (ThemeExtension) |
| space/1 … space/12 | `AppSpacing.s4 … s48` |
| radius/sm, md, lg | `AppRadius.sm, md, lg` |
| text/<role> | `textTheme.<role>` |
| elevation/<n> | Material 3 surface tint levels |

Rules:
- Custom colors live in a `ThemeExtension`, with light and dark values.
- Pencil variable names and Dart names should be mechanically convertible. If
  a designer name doesn't convert cleanly, rename the variable.
- Dark mode: every color variable needs a dark value or the design isn't done.
