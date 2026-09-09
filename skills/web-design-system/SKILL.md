---
name: web-design-system
description: Apply the user's design system when creating or styling HTML reports, dashboards, and internal application interfaces. Use for layout, typography, colors, components, charts, and light/dark themes in these artifacts, or when explicitly requested. Not a default for marketing sites or immersive experiences.
---

# Web design system

Build restrained, compact, readable interfaces whose hierarchy comes from their
content and tasks. Keep the shell quiet, group related work, use familiar
controls, and make state explicit in text and semantics as well as color.

This skill and its bundled references and tokens define the design system.
Build the requested UI without adding token pipelines, component
specification documents, or a conformance process. For an existing product, keep
changes within the requested scope and honor its established design system
unless the user asks to replace it.

## Adapt to the task

Accessible interaction, readable contrast, semantic color roles, and accurate
data and captions are requirements in every composition. Page structure,
navigation placement, section order, and density are defaults to adapt to the
content, audience, and requested format. Choose the composition that serves
the task; the examples do not prescribe a universal page template.

Reuse an existing application's shell, navigation, and theme controls when
building inside it. Standalone-page defaults do not require adding duplicate
chrome to an embedded report or view. Code recipes illustrate appearance and
behavior; adapt their markup and framework integration while preserving the
relevant keyboard, focus, state, and data behavior.

## Choose a profile

- **Read-only HTML report:** read [reports.md](references/reports.md). Use its
  self-contained export defaults for a standalone file. Keep source data
  unchanged and omit motion; search, filters, sorting, and other view controls
  are allowed when useful. Adapt navigation to the report's format and reuse
  host controls when embedded. Keep provenance and interpretation boundaries
  visible and support print.
- **Interactive application:** read the relevant parts of
  [layout.md](references/layout.md) and [controls.md](references/controls.md).
  For record lists, metadata summaries, or diagnostics, also read the relevant
  [data-display guidance](references/data-display.md), even when there are no charts.
  Implement only the controls and composition patterns the task needs.

## Load details as needed

For a new page, read [foundations.md](references/foundations.md), the relevant
layout guidance, and [theme.md](references/theme.md). For a narrow edit, read only
the sections needed for the change. References have contents lists; do not load
the entire reference directory by default.

When composing a new page or substantially changing its layout, apply the
[composition guidance](references/layout.md#composition) for spacing, grouping,
and hierarchy.

| Task | Resource |
| --- | --- |
| Colors, typography, spacing, density, focus, and metadata | [Foundations](references/foundations.md) |
| Page headings, responsive layout, sticky chrome, and application composition | [Layout](references/layout.md) |
| Single-file reports, sticky section nav, and print/PDF | [Reports](references/reports.md) |
| Fields, buttons, selection, popovers, dialogs, and async states | [Controls](references/controls.md) |
| Status chips, panels, summaries, tables, charts, Reading captions, and logs | [Data display](references/data-display.md) |
| System / Light / Dark selection, persistence, and chart theme updates | [Theme](references/theme.md) |
| Brand marks, favicons, and their theme scoping | [Theme](references/theme.md#brand-marks-and-favicons) |
| Optional application animation and reduced motion | [Motion](references/motion.md) |
| Spatial boards, roving focus, and progressive detail inspection | [Spatial widgets](references/spatial-widgets.md) |
| Accessibility, wording, and checks before delivery | [Review](references/review.md) |

## Apply the shared values

Copy [assets/tokens.css](assets/tokens.css) into the generated stylesheet; inline
its contents in a single-file report. It is a token foundation, not a complete
page stylesheet. Add only the component recipes needed by the artifact.

- Keep the `--ds-` namespace and supplied colors, spacing, radii, and density
  values. Consume the tokens in feature styles; avoid parallel token systems.
- Use feedback **text** tokens for small colored labels, **signal** tokens for
  marks and chart feedback, and **soft** tokens for their intended backgrounds.
  Use chart series tokens for identity, not good/bad judgments.
- Keep recurring text at least 12px, numeric comparisons tabular, focus visible,
  and layout responsive. Prefer native semantics and use CSS logical properties.
- Read [theme.md](references/theme.md) when adding theme behavior. Use the host's
  theme state when embedded; the standalone recipe resolves `data-theme` or
  the system media query. Update canvas charts as well as CSS when it changes.
- Read [data-display.md](references/data-display.md) when adding charts. Every
  chart supporting a conclusion needs a visible `Reading:` caption derived from
  the same data, with exact values that appear in the chart.

Before delivery, apply the relevant [review checks](references/review.md),
including keyboard, narrow-screen/zoom, supported themes, and print for reports.
For a new page or substantial layout change, inspect the rendered UI and refine
visible layout issues using the [visual review](references/review.md#rendered-visual-review).
Describe any verification that could not be performed.
