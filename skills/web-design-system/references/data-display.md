# Content, data display, and recipes

Read the sections for the content being built. The [report profile](reports.md) rules out source-data editing, motion, and application notification workflows in read-only reports; controls that change the view are allowed. Recipes use [the shared tokens](../assets/tokens.css).

## Contents

- [Links](#links)
- [Badges, Status, and Tags](#badges-status-and-tags)
- [Panels and Cards](#panels-and-cards)
- [Metadata and Diagnostics](#metadata-and-diagnostics)
- [Disclosure](#disclosure)
- [Alerts and Notifications](#alerts-and-notifications)
- [Data Table Component](#data-table-component)
- [Empty and Error States](#empty-and-error-states)
- [Summary Values](#summary-values)
- [Data Table](#data-table)
- [Data Visualization](#data-visualization)
- [Activity Stream](#activity-stream)
- [Technical Console](#technical-console)
- [Status chip (label + mark on soft surface)](#status-chip-label--mark-on-soft-surface)
- [Selected item in a list](#selected-item-in-a-list)
- [Chart caption (the Reading pattern)](#chart-caption-the-reading-pattern)

## Links

- Use links for navigation and buttons for actions.
- Ensure links are distinguishable from surrounding text without relying only
  on hover.
- Provide clear visited state when revisiting links matters to the task.
- External links should communicate that behavior when it may surprise users.
- When a whole row or card acts as a link, make it a real `<a>`, give it a
  visible hover affordance (accent-soft background and/or a trailing `↗`
  that reacts on hover), and keep the accessible name meaningful.

## Badges, Status, and Tags

Badge:

- Compact count or short metadata value
- Neutral unless it represents feedback

Status:

- Visible label plus optional mark
- Feedback **text** color on a feedback **soft** surface (see [the status-chip recipe](data-display.md#status-chip-label--mark-on-soft-surface) — this combination is the one most often built wrong)
- Chroma discipline: feedback color belongs in text, marks, and thin borders —
  the smallest possible area. Reserve tinted soft surfaces for states the user
  can act on (failed, at risk, blocked). Purely informational chips
  (scheduled, reconciled, contextual metadata) use a neutral surface with the
  feedback color only in the leading mark. A page where every chip is tinted
  spends its entire color budget on nothing in particular.
- Programmatic state name
- A single *live* state per view (active incident, running job) may add a
  pulsing halo to its leading mark to draw the eye — see [the live-status recipe](motion.md#live-status-pulse-one-per-view-motion-gated). Only one element per view may pulse, it must still carry the text
  label, and the pulse must be scoped under `motion-on`.

Tag:

- Category or user-assigned metadata
- Neutral surface by default
- Optional removable action with accessible label

Pills are reserved for compact metadata, feedback, and preset tokens. Do not
turn ordinary field labels, navigation, or primary actions into pills.

## Panels and Cards

Use a panel when content forms a meaningful boundary users can understand,
compare, or act on independently.

Appropriate uses include a filter group, bounded summary, settings group,
preview, collection, or supporting explanation.

Avoid:

- Wrapping every paragraph or section
- Nested surfaces without separate interaction
- Decorative cards containing no meaningful unit
- Using elevation where a divider would communicate the relationship

## Metadata and Diagnostics

A short inline metadata string works for a few related facts. When counts,
time ranges, policies, provenance, and warnings appear together, give them
structure instead of joining everything with separators.

- Use labeled rows or a definition list for heterogeneous values; reserve
  prominent metrics for values users need to compare at a glance.
- Keep the interpretation boundary close to the values, such as whether a
  range describes observed file metadata or actual event coverage.
- Separate incomplete or failed state from ordinary metadata. Put diagnostic
  messages on distinct lines and retain the useful original details; use
  monospace for technical output and UI typography for explanations.
- Qualify zero counts when collection failed or was partial. A displayed zero
  must not imply verified absence. Keep this qualification visible when
  optional diagnostic detail is collapsed.

## Disclosure

Use disclosure for optional detail that can be understood from its summary.

- Prefer native `details` and `summary` for simple content.
- Keep the summary useful while collapsed.
- Preserve open state when rerendering does not represent a new context.
- Do not hide required decisions, errors, or primary actions.

## Alerts and Notifications

Inline alert:

- Relates to nearby content or a current workflow
- Includes feedback role, concise title, and recovery guidance

Toast:

- Confirms a completed background event or nonblocking update
- Does not contain the only copy of critical information
- Pauses or remains available long enough for assistive technology
- Sits at `--ds-z-toast`

Use live regions intentionally. Routine rerenders should not repeatedly announce
unchanged content.

## Data Table Component

Build one table style per application and reuse it; do not restyle tables per
feature.

- Associate every data cell with its column and applicable row header.
- Put sort behavior on a labeled button and expose `aria-sort` on the active
  header.
- Row selection uses native checkboxes with row-specific labels.
- Select-all communicates checked, unchecked, and mixed state.
- Keyboard focus remains stable after sorting, pagination, and data refresh.
- Pagination exposes current page, total pages when known, and disabled limits.
- Bulk actions identify the selected count and remain reachable by keyboard.
- Virtualization preserves table meaning, row position, set size, and focused
  content; use a simpler nonvirtual table when assistive technology support is
  uncertain.

## Empty and Error States

Empty states explain what is absent and, when appropriate, offer one next action.
They should distinguish first use, filtered-out results, missing permission, and
true absence.

Error states include a concise problem statement and a recovery path. Technical
details may appear behind disclosure when relevant to the audience.

## Summary Values

Use a compact summary grid when users need to compare a small set of important
values.

- Use a quiet label above a prominent value. Headline summary metrics use
  `--ds-font-size-summary-value` with semibold weight; smaller component values
  use `--ds-font-size-value`. Avoid giving every number headline emphasis.
- Use tabular numerals for numeric comparison.
- Apply feedback color only when the value represents feedback state, and use
  the feedback **text** token for it.
- Do not add an icon or chart to a scalar value without adding meaning.
- A one-shot count-up on first reveal is acceptable emphasis for a small set of
  hero values; see [the count-up recipe](motion.md#count-up-for-prominent-values-one-shot-motion-gated). Never loop it, never apply it to values
  that update live, and keep it behind the `motion-on` gate.

The value styling works in a summary row, grid, or individual metric. Choose
the grouping for the page; a separate card around every number is unnecessary.

```css
.summary-metric__value {
  margin-block: var(--ds-space-2);
  color: var(--ds-color-text-primary);
  font-size: var(--ds-font-size-summary-value);
  font-weight: var(--ds-font-weight-semibold);
  line-height: 1.2;
  font-variant-numeric: tabular-nums;
}
```

## Data Table

Compose tables from the application's single table style rather than rebuilding
sorting, selection, pagination, or accessibility behavior in a feature.

- Classify columns as text, numeric, status, action, or custom.
- Right-align numeric columns and use tabular numerals.
- Keep units explicit.
- Preserve header association for assistive technology.
- Support horizontal overflow before truncating essential values.
- Put row actions in a consistent location.
- Use pagination, virtualization, or progressive loading according to scale.
- Optional large tables may remain behind disclosure until requested.

## Data Visualization

Charts use theme tokens for background, text, grid, axes, and hover content.

Reference series tokens:

| Token | Light | Dark |
| --- | --- | --- |
| `--ds-chart-series-1` | `#2563eb` | `#7cb0f7` |
| `--ds-chart-series-2` | `#059669` | `#6ee7b7` |
| `--ds-chart-series-3` | `#7c3aed` | `#c4b5fd` |
| `--ds-chart-series-4` | `#db2777` | `#f0abfc` |
| `--ds-chart-series-5` | `#b45309` | `#fcd34d` |

Series are ordered blue, green, violet, pink, amber. Assign slots by
importance: the primary series takes series-1. The set is deliberately
two-register: saturated 600-step values in light mode for punch on white,
pastel 300-step values in dark mode to prevent glare on near-black
surfaces. Dark series slots never reuse a feedback signal value — a series
line must stay visually distinct from positive/warning/danger marks in the
same theme. Series amber (`#b45309`) sits in a darker register than the
warning amber (`#d97706`), but the prohibition below still applies: series
hues never imply judgment.

**Fill strength is area-dependent.** The dark pastels are sized for thin
marks: at full strength they hit 8–12:1 against a dark surface, which is
correct for strokes, points, and text but reads as glare when applied to
large fills. Bar, histogram, and area fills use the series color at 70%
strength in dark mode — `rgba()` of the series color, or the opaque blend
over `--ds-color-surface` when bars stack or overlap (translucent fills
compound where they layer):

| Series | Fill (rgba) | Opaque blend |
| --- | --- | --- |
| series-1 `#7cb0f7` | `rgba(124, 176, 247, 0.7)` | `#5e82b5` |
| series-2 `#6ee7b7` | `rgba(110, 231, 183, 0.7)` | `#54a988` |
| series-3 `#c4b5fd` | `rgba(196, 181, 253, 0.7)` | `#9086b9` |
| series-4 `#f0abfc` | `rgba(240, 171, 252, 0.7)` | `#af7fb8` |
| series-5 `#fcd34d` | `rgba(252, 211, 77, 0.7)` | `#b79b3e` |

This brings dark fills into the same 4.5–6.5:1 register the light theme's
600-step bars already occupy on white. Lines, markers, and text never use
the fill variants. Feedback-colored bars (positive/negative attribution)
follow the same rule with the feedback signal colors.

For theme-switching code, the mapping is light bar value → dark fill blend:
`#2563eb → #5e82b5`, `#059669 → #54a988`, `#7c3aed → #9086b9`,
`#db2777 → #af7fb8`, `#b45309 → #b79b3e`, `#16a34a → #3ba262`,
`#d97706 → #b78d21`, `#dc2626 → #b45657`, `#60a5fa → #4a7ab7`.

Requirements:

- Use chart types that match the comparison task.
- Show units in labels or ticks.
- Provide a concise textual conclusion.
- Provide a table or downloadable representation when exact values matter.
- Do not rely only on series color; use labels, symbols, or line styles.
- Use `--ds-color-neutral` (gray) for context series — benchmarks, previous
  period, or a baseline model — instead of spending a series slot on data that
  is reference rather than content. This is the only legal gray for chart
  strokes: do not substitute `--ds-color-border-strong`, `--ds-color-text`,
  or any other boundary/text token for a series or baseline color.
- A series color must not double as feedback: do not pick a series hue to imply
  good/bad. When a chart needs judgment colors (e.g. positive/negative
  attribution bars), use the feedback signal tokens, not series tokens.
- One identity, one color, everywhere: the chart, its legend, and any related
  table dots read from a single per-view color registry. A table dot that
  disagrees with its line in the chart is a bug.
- Evolution charts keep every series that ever led, even after it falls
  behind — the lead changes are the story. Order series by current standing;
  colors stay attached to identity when the order changes.
- A constant per-series reference value (a prior, a baseline) renders as a
  dashed line in that series' color, is named in the legend, and participates
  in the axis scale computation so it cannot fall outside the plot.
- Derived marks — endpoint dots, callouts, caption numbers — are computed from
  the same fresh data as the series they annotate, never from cached copies of
  earlier data. An endpoint that sags below its curve is the signature of a
  stale aggregate.
- When a chart is a navigation surface, its legend is a control surface:
  entries are keyboard-operable toggle controls (`aria-pressed`) that focus
  or isolate a series and mirror selection in related views (table rows, canvas
  markers). Use native buttons or [equivalent library controls](controls.md#existing-library-controls).
  De-focused series marks dim via `--ds-dim-muted`; they are never removed, so
  history stays readable. Keep legend text, buttons, table text, and captions
  at full opacity; dim an individual swatch, not the whole legend entry.
- A hovered or selected mark promotes above its siblings so its tooltip is
  never occluded. Enlarge the hit area of small marks with an invisible
  `::before` (`inset: min(-6px, 50% - 16px)`) instead of enlarging the mark
  itself.
- Charts with dense tick labels adapt to their own width, not the viewport:
  make the plot a size container (`container: plot / inline-size`) and drop
  minor tick labels below a container-width threshold. Grid lines stay; only
  label density changes.
- Every chart panel that supports a conclusion carries a Reading caption
  (see [the chart caption recipe](data-display.md#chart-caption-the-reading-pattern)): a `figcaption` inside the same `figure`
  that states the conclusion with exact values, readable without
  interacting with the chart.
- Update the chart library's actual layout when theme changes so exports match
  (canvas-based libraries do not follow CSS variables on their own).

## Activity Stream

Use for chronological events, history, comments, audits, or system activity.

- Keep time, actor/source, event, and severity structurally distinct.
- Use human-readable descriptions as the primary content.
- Collapse verbose detail behind disclosure.
- Preserve visible severity labels when columns collapse on mobile.

## Technical Console

An optional pattern for logs, source output, traces, or code.

The inverse treatment belongs to a bounded region whose primary content is
that output — a log pane, file viewer, or trace view. Log excerpts rendered
inside result cards or list rows stay on the ordinary surface with primary
text; wrapping every match in an inverse block turns the console treatment
into decoration and makes long lists heavy, especially in light mode.

- Use an inverse surface in both themes.
- Use monospace for technical fields and sans-serif for explanatory messages.
- Keep severity visible as text, not tint alone.
- Bound height and allow internal scrolling.
- Offer copy, download, or search when the content volume justifies it.

## Status chip (label + mark on soft surface)

```css
.status {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 4px 9px;
  border-radius: var(--ds-radius-pill);
  font-size: 12px;
  font-weight: 650;
  line-height: 1;
  white-space: nowrap;
}
.status::before {
  width: 5px;
  height: 5px;
  border-radius: 2px;
  background: currentColor;
  content: "";
}
.status--positive {
  color: var(--ds-color-positive-text);
  background: var(--ds-color-positive-soft);
}
.status--warning {
  color: var(--ds-color-warning-text);
  background: var(--ds-color-warning-soft);
}
.status--danger {
  color: var(--ds-color-danger-text);
  background: var(--ds-color-danger-soft);
}
.status--info {
  color: var(--ds-color-info-text);
  background: var(--ds-color-info-soft);
}
.status--neutral {
  color: var(--ds-color-neutral-text);
  background: var(--ds-color-neutral-soft);
}
```

Quiet variant for informational chips (neutral surface, color only in the
mark) — the default for header metadata that is not actionable:

```css
.status--quiet {
  color: var(--ds-color-text);
  background: var(--ds-color-neutral-soft);
}
.status--quiet.status--positive::before { background: var(--ds-color-positive); }
.status--quiet.status--warning::before { background: var(--ds-color-warning); }
.status--quiet.status--danger::before { background: var(--ds-color-danger); }
.status--quiet.status--info::before { background: var(--ds-color-info); }
```

Wrong: `color: var(--ds-color-positive)` (the signal color) at 12px — it fails
text contrast on light surfaces. Right: text token on soft surface, as above.

## Selected item in a list

```css
.row {
  border-radius: var(--ds-radius);
}
.row:hover {
  background: var(--ds-color-surface-subtle);
}
.row[aria-current="true"],
.row.is-selected {
  background: var(--ds-color-accent-soft);
}
```

## Chart caption (the Reading pattern)

Every chart that supports a conclusion gets a `figcaption` inside the same
`figure`. The caption is the accessible, printable version of the chart —
the pattern reports are most often missing, and the first thing lost when
the chart is skipped by a screen reader or printed in grayscale.

```html
<figure class="ds-panel">
  <div class="panel-heading">
    <h3>Cumulative return</h3>
    <p>Full artifact history; the flat interval is model warmup.</p>
  </div>
  <div class="chart"><!-- chart library target --></div>
  <figcaption>
    <strong>Reading:</strong> Net return reaches 985.13%. The 2026 extension
    contributes 64.79% net after 2 bps.
  </figcaption>
</figure>
```

```css
figcaption {
  padding: var(--ds-space-5) var(--ds-panel-padding);
  border-block-start: 1px solid var(--ds-color-border);
  color: var(--ds-color-text-muted);
  font-size: var(--ds-font-size-control);
  text-wrap: pretty;
}
figcaption strong {
  color: var(--ds-color-text);
}
```

Rules: start with `Reading:`; state the conclusion, not a description of
axes; use only values that actually appear in the chart; and keep it to one
or two sentences. A chart whose takeaway cannot be written down in a
caption is the wrong chart for the question.
