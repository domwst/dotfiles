# Layout and application composition

Use the sections relevant to the page. These composition patterns are defaults to adapt to the task, not required page structures. Reuse an existing application's shell and navigation. For standalone reports, start with the lighter [report profile](reports.md).

## Contents

- [Application Shell](#application-shell)
- [Sticky Chrome](#sticky-chrome)
- [Page Heading](#page-heading)
- [Responsive Strategy](#responsive-strategy)
- [Application Header](#application-header)
- [Navigation](#navigation)
- [Filter Toolbar](#filter-toolbar)
- [Record Collection](#record-collection)
- [Multi-Section Form](#multi-section-form)
- [Split Workspace](#split-workspace)
- [Long-Content Navigation](#long-content-navigation)

## Application Shell

Reference dimensions (token values, not magic numbers — consume them via
`var()`):

- Standard content width: `var(--ds-content-width)` (`1320px`)
- Data-dense content width: `var(--ds-content-width-data)` (`1540px`)
- Header height: `var(--ds-header-height)` (`60px`)
- Desktop horizontal padding: `20-24px`
- Mobile horizontal padding: `14-16px`
- Desktop page top padding: `40-48px`

These are defaults, not universal limits. Reading-focused products may use a
narrower measure; creative canvases may use the full viewport. The shell and
header should share a quiet surface hierarchy.

When a page mixes data-dense regions with explanatory prose, use the
[prose role](foundations.md#typography) and `--ds-content-width-prose` (`70ch`)
for reading blocks. Tables and charts can use the wider content tokens;
each region keeps a measure suited to its content.

## Sticky Chrome

Sticky bars docked flush to the viewport top follow four rules:

- **One boundary.** Use `border-block-end` only, and dock with
  `inset-block-start: -1px` so the element's top edge hides behind the
  viewport edge while stuck. A stuck bar with both top and bottom borders
  renders as a double rule pinned to the screen edge.
- **Breathe on both axes.** `padding-block` of at least 10px and
  `padding-inline` of at least 12px inside the bar, so labels never touch a
  boundary — neither at the screen edge nor where scrolling content passes
  beneath.
- **Scrollable strips fade their edges.** Put the edge-fade mask (see
  Long-Content Navigation) on the scrolling track, never on an element that
  also carries borders — a mask fades the border with it.
- **Anchor offsets are mandatory.** Every target of in-page navigation sets
  `scroll-margin-block-start` at least as tall as the total stuck chrome
  plus one spacing step. This is a correctness rule, not polish: without
  it, headings land underneath the bar.

Bars may dock to the bottom edge as well. The mirror rules: a single **top**
boundary (`border-block-start`), `inset-block-end: 0`, rounded top corners
only, translucent background with restrained blur matching the header, and a
z-index below the top header so popovers layer above it. Use a bottom dock
for cross-cutting view state that must stay reachable at every scroll
position — a history scrubber, a live/stale indicator — when the regions it
controls cannot share the viewport. A bottom dock is not a second toolbar:
one per application, carrying state rather than actions.

## Page Heading

The standard composition supports:

1. Optional orientation label or breadcrumb
2. Concise page title
3. Optional one-sentence description
4. Primary action when the page has one

Do not turn task headings into marketing heroes. Large empty areas should serve
content comprehension, not visual spectacle.

## Responsive Strategy

Use component-driven breakpoints. The following values are reference points,
not mandatory global media queries.

| Width | Typical adaptation |
| --- | --- |
| `1180px` | Wide side regions may become horizontal or move below content |
| `960px` | Split workspaces and supporting asides often stack |
| `760px` | Multi-column forms, filters, and records often become one column |
| `520px` | Summary grids and action groups often become one column |

Responsive behavior should reorganize information rather than simply shrink it.
Components should respond when their own content stops fitting.

## Application Header

The header may contain a brand or workspace identity, navigation, contextual
controls, account controls, and a primary action. Render only the slots the
product needs.

- Keep the header visually quiet.
- Use one boundary between header and page.
- Preserve access to essential navigation on small screens.
- Do not place every global action in the header.
- Derive every control's height in a shared row from the same token
  expression. Hand-rolled variants (`control-height − 4px`, a hardcoded
  `28px`, `control-height − 6px`) drift by a couple of pixels each, and a row
  of adjacent boxes with mismatched heights reads as broken even when nobody
  can name which one is wrong. Composite controls (chip + padding) must land
  on the same outer height as their simple neighbors.

## Navigation

The system supports links, tabs, breadcrumbs, side navigation, and compact
overflow menus.

- Navigation reflects information architecture, not action categories.
- The current destination is visually and programmatically identified.
- Tabs switch peer views within one context and support arrow-key navigation.
- Breadcrumbs describe hierarchy and should not replace a page title.
- Side navigation becomes an appropriate compact pattern at narrow widths rather
  than disappearing without replacement.

## Filter Toolbar

Use when users repeatedly narrow a collection.

- Keep the most common filters visible.
- Move advanced filters into disclosure or a popover.
- Show active filters and result count.
- Provide a clear reset when multiple filters can combine.
- Preserve filters across refresh when that matches user intent.

## Record Collection

Use a list, grid, or table based on the comparison task.

List:

- Best for varied descriptions and a clear primary identifier

Grid:

- Best for visually comparable items or previews

Table:

- Best for repeated attributes and column-wise comparison

Rows in a bounded list use shared dividers instead of individual card outlines.
Hover may use a subtle accent surface when the whole row is interactive.

## Multi-Section Form

Divide long forms by user goal, not by backend object.

Each section may contain a short index, title, explanation, and one- or
two-column field grid. Put common decisions first and advanced configuration
later. Keep actions at the end of the flow.

## Split Workspace

Use a primary region with a supporting aside for preview, guidance, summary, or
contextual controls.

- The primary task remains wider.
- The aside may be sticky on wide screens — but only when it is shorter than
  the viewport. A sticky element taller than the viewport pins uselessly and
  strands its lower content off-screen. For tall primary regions (canvases,
  boards), keep natural column heights and place supporting panels in the
  primary column, directly under the region they visualize.
- Stack the aside when horizontal space becomes constrained.
- Do not repeat help already attached to individual controls.

## Long-Content Navigation

Use a sticky side rail, table of contents, or section index when a page contains
many meaningful sections.

- Indicate the current section visually and programmatically.
- Keep labels short.
- Convert to a horizontal strip, compact menu, or in-flow table of contents when
  a side rail no longer fits.
- Any horizontally-scrollable strip should fade its edges with a mask so
  overflow is discoverable:
  `mask-image: linear-gradient(to right, transparent, black 8%, black 92%, transparent)`.
