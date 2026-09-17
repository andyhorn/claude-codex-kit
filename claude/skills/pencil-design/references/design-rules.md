# Design rules

## Tokens
- Colors come from the color scheme / variables. No raw hex in frames.
- Spacing is on a 4pt scale: 4, 8, 12, 16, 24, 32, 48.
- Radius, elevation, and text styles come from named tokens only.
- Text styles map to Material TextTheme roles (displayLarge … labelSmall).
  Don't invent sizes.

## Layout
- Touch targets at least 44x44pt.
- Primary action within thumb reach (bottom half) on phone layouts.
- Respect safe areas; don't design content under the status bar or home indicator.
- Lists need empty and loading states. Forms need error states per field.

## Accessibility
- Text contrast at least 4.5:1 (3:1 for large text).
- Don't use color as the only signal (add an icon or text).
- Layout must survive 1.3x text scale without clipping.

## Flutter-feasibility
- Prefer layouts expressible with Column/Row/Stack/Sliver lists.
- Flag custom painting, blur-heavy effects, or complex animations in the spec
  as "costly".
- Use Material 3 components where they fit. Custom components need a reason.
