# Layout and application composition

Use the sections relevant to the page. These composition patterns are defaults to adapt to the task, not required page structures. Reuse an existing application's shell and navigation. For standalone reports, start with the lighter [report profile](reports.md).

## Contents

- [Composition](#composition)
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

## Composition

Use these relationships to give reports and application views a deliberate
layout. Adapt navigation position, chart type, and column count to the task.

- **Establish a page frame.** Align headings, control groups, and content regions
  to shared edges. Use the standard width as a starting point for standalone
  pages; choose the wider data width or a full-viewport workspace when the task
  benefits. Keep prose at its own reading measure and preserve outer breathing
  room. Extra available width does not require expanding every region.
- **Make type roles visibly distinct.** Headings organize regions, labels identify
  controls, and supporting text recedes while staying readable. Use the
  [headline metric role](foundations.md#typography) for a few summary numbers;
  keep ordinary component values and controls compact. Set weight and line
  height along with size instead of inheriting body styling for every role.
- **Group controls by their effect.** Put a chart's controls with that chart and
  a table's filters with that table. Separate groups when their scopes differ.
  Align related controls to one baseline and height; keep labels distinct from
  values and actions, with labels close to their fields. Keep result counts
  and pagination beside the affected view. A reader should see where a
  control's result will appear.
- **Give each gap one owner.** Let the parent layout space sibling panels; avoid
  adding child margins to an existing grid or flex gap. Use smaller gaps within
  a group and larger gaps between groups. Coordinate card padding, heading
  margins, and chart-library margins so they do not accumulate accidentally.
- **Compose the whole chart panel.** Treat its heading, legend, plot, inspection
  state, and caption as one group, including only the parts needed. Reserve
  separate space for library toolbars, actual labels, and wrapping legends,
  then give the plotted data useful room. A shared margin override must not
  erase the space required by a particular chart.
  Keep the legend close to the plot and any inspection region or caption
  visually attached, with quiet separators when needed.
  Choose panel proportions and columns to suit the visualization; do not assign
  every chart the same height merely because they share a renderer.
- **Budget the primary interaction loop.** For desktop inspection workspaces,
  arrange the primary object, its frequent controls, and essential diagnostics
  so the main loop requires little scrolling; use available horizontal space
  before stacking everything vertically. Live status belongs in view, not
  behind an extra interaction. This is a desktop goal, not a reason to shrink
  text or prevent reflow at zoom.
- **Use boundaries selectively.** Spacing, alignment, and a shared divider can
  group summary values or rows. Add a surface or border when it clarifies a
  region; keep the plot and its related controls/caption visually connected.
- **Preserve orientation in long views.** Keep section navigation and relevant
  selection context easy to recover while exploring. A sticky strip, side
  navigation, or another suitable pattern can provide continuity; reuse host
  navigation when embedded. When navigation and theme controls share a region,
  align and group them into a coherent strip.

## Application Shell

Reference dimensions (token values, not magic numbers — consume them via
`var()`):

- Standard content width: `var(--ds-content-width)` (`1320px`)
- Data-dense content width: `var(--ds-content-width-data)` (`1540px`)
- Header height: `var(--ds-header-height)` (`60px`)
- Desktop horizontal padding: `20-24px`
- Mobile horizontal padding: `14-16px`
- Desktop page top padding: `40-48px`

These are defaults, not universal limits. For analytical workspaces, prefer
using the available width for charts and tables; apply a page cap only when it
improves the actual task. Constrain prose and forms locally instead of applying
their reading measure to the entire workspace. The shell and header should
share a quiet surface hierarchy.

Prefer page scrolling and natural panel heights. Add internal scrolling when
it preserves a useful relationship, such as a results list beside an inspector,
or contains a dedicated console. A final sidebar panel with nothing below it
usually has no reason to impose a separate scroll container.

When a page mixes data-dense regions with explanatory prose, use the
[prose role](foundations.md#typography) and `--ds-content-width-prose` (`70ch`)
for reading blocks. Tables and charts can use the wider content tokens;
each region keeps a measure suited to its content.

## Sticky Chrome

Keep persistent chrome compact: navigation, theme selection, and controls
needed during inspection belong there. Leave duplicate page titles, lengthy
help, and routine freshness text with the scrolling content unless they are
needed to interpret or operate the current view.

Sticky bars docked flush to the viewport top follow these rules:

- **One boundary.** Use `border-block-end` only, and dock with
  `inset-block-start: -1px` so the element's top edge hides behind the
  viewport edge while stuck. A stuck bar with both top and bottom borders
  renders as a double rule pinned to the screen edge.
- **Breathe on both axes.** `padding-block` of at least 10px and
  `padding-inline` of at least 12px inside the bar, so labels never touch a
  boundary — neither at the screen edge nor where scrolling content passes
  beneath.
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
Components should respond when their own content stops fitting. Judge the
remaining content width after navigation, padding, and supporting panels; a
layout can avoid page overflow while leaving its primary content too narrow
to read. On narrow screens, keep source selection and primary work close:
collapse lengthy navigation after selection, and keep peer views reachable
without scrolling through the full contents of another view.

## Application Header

The header may contain a brand or workspace identity, navigation, contextual
controls, account controls, and a primary action. Render only the slots the
product needs.

- Keep the header visually quiet.
- Use one boundary between header and page.
- Preserve access to essential navigation on small screens.
- Make the application brand a home link when the application has a main page.
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
- Keep navigation edges clean by default. Do not fade labels, hover surfaces,
  active underlines, or focus indicators with a mask. If overflow needs a cue,
  show it only where more content exists and keep the cue separate from the
  interactive items; never fade an edge already scrolled to its limit.
- Tabs switch peer views within one context and support arrow-key navigation.
- Breadcrumbs describe hierarchy and should not replace a page title.
- Side navigation becomes an appropriate compact pattern at narrow widths rather
  than disappearing without replacement.

## Filter Toolbar

Use when users repeatedly narrow a collection.

- Keep the most common filters visible.
- Move advanced filters into disclosure or a popover.
- Show active filters and result count.
- Prefer debounced filtering while typing for inexpensive list searches; do
  not require Enter without a task or cost reason. This is view filtering,
  not implicit submission of commands or other state-changing actions.
- Provide a clear reset when multiple filters can combine.
- Preserve filters across refresh when that matches user intent.
- In submitted searches, distinguish draft controls from the scope of the
  displayed results; keep pagination tied to the submitted search.
- When users revisit or share investigations, consider URL state and
  Back/Forward restoration for source, query, and filters. Keep credentials
  out of links; make clear whether a shared time range is fixed or relative.

## Record Collection

Use a list, grid, or table based on the comparison task.

List:

- Best for varied descriptions and a clear primary identifier

Grid:

- Best for visually comparable items or previews

Table:

- Best for repeated attributes and column-wise comparison

Choose pagination or virtualization based on collection size, rendering cost,
and the comparison task. A modest working set may be easier to inspect as one
list; do not add pagination merely because a table component supports it.
Distinguish parent groups and child sources through headings and indentation.
Align repeated row actions in a consistent column so label length does not
move each action to a different horizontal position.

Rows in a bounded list use shared dividers instead of individual card outlines.
Hover may use a subtle accent surface when the whole row is interactive; a
noninteractive comparison table may use a subtler scan-aid hover that does not
imply clickability.
For repeated evidence such as logs, align the fields users compare and judge
density with a populated collection. Repeated paths, pills, and padding should
not dominate the messages. Keep verbose fields and context behind useful
summaries. When users need to select or copy text, give navigation an explicit
action instead of making every click on the record navigate.

Operational histories and selectors — queues, attempt logs, archives — follow
scanning defaults:

- Default to recent-first order unless chronological progression serves the
  task, and say which order a selector presents.
- Make meaningful names the primary identity; hashes and raw ids are secondary
  metadata, available for inspection but not the scanning label.
- Show distinguishing facts inline — state, outcome, one differentiating
  count — without repeating context the selected group already establishes.
- Group previous/next navigation together; distinguish boundary jumps from
  stepping and support scoped keyboard shortcuts.
- Keep navigation links visually consistent after visiting them; reserve
  visited differentiation for contexts where reading history matters.
- Render timestamps in one house format — a 24-hour clock by default — with
  the complete value available for inspection and the date shown where it adds
  context.

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
  boards), keep natural column heights. Place a compact, frequently consulted
  inspector beside the tall region when the two can share viewport height and
  the interaction loop crosses between them; place longer supporting panels in
  the primary column, directly under the region they visualize.
- When horizontal space becomes constrained, choose between stacking,
  disclosure, or peer views according to the workflow. Stacking a frequently
  used inspector after hundreds of results makes it difficult to reach.
- Let detailed inspection use more space when a preview becomes too narrow;
  preserve a clear return to the originating result and its context.
- Do not repeat help already attached to individual controls.

## Long-Content Navigation

Use a sticky side rail, table of contents, or section index when a page contains
many meaningful sections.

- Indicate the current section visually and programmatically.
- Keep labels short.
- Convert to a horizontal strip, compact menu, or in-flow table of contents when
  a side rail no longer fits.
- Apply the [navigation overflow guidance](#navigation) to scrolling strips;
  section labels and active indicators must remain fully legible at both edges.
