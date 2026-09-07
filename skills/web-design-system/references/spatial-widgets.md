# Spatial widgets and detail inspection

Read only for a spatial grid or a multi-level inspection interaction. Ordinary reports and tables do not need a roving-focus grid or arm–commit behavior.

## Contents

- [Dense Grid Widget](#dense-grid-widget)
- [Detail Ladder](#detail-ladder)

## Dense Grid Widget

Use for spatial boards — game fields, seating maps, pixel editors — where
targets are numerous, small, and mostly identical, and where a misclick is
destructive or expensive. A 19×19 board has 361 cells; the pattern keeps the
keyboard and pointer contracts coherent at that density.

Structure and semantics:

- Real `<button>` cells under `role="grid"` → `role="row"` →
  `role="gridcell"`. Non-interactive cells keep `aria-disabled="true"` and
  stay focusable.
- Every cell's accessible label carries its coordinates and its data (the
  values a tooltip would show), generated from the same source as the visual
  notation. Coordinate captions around the grid are decorative
  (`aria-hidden`) duplicates of that source — one generator, never two.

Roving focus:

- Exactly one tab stop. Arrow keys move focus cell by cell and skip
  non-interactive cells (a cursor parked on an occupied square is dead air);
  navigation stops at edges.
- The cell that owns focus is always visibly marked.

Arm–commit selection:

- Destructive or expensive activation is armed first: the first activation
  (click, or Enter/Space on the focused cell) arms a cell and shows a
  selection ring; activating the armed cell again commits. This is the
  pointer and keyboard equivalent of two-step confirmation at tiny target
  sizes.
- Arrow keys move the armed selection together with focus once something is
  armed — and create it on the first press when nothing is armed, so the
  cursor is never invisible. Focus and selection move in lockstep; the
  moment they diverge, two competing highlights appear and the user stops
  trusting either.
- Commit keys (`Enter`, `Space`) `preventDefault()` and fire once — native
  button activation differs between the two keys and repeats while held.
- `Escape` clears the selection. `pointer-events: none` on any cell-child
  tooltip or badge; a selected cell suppresses its own tooltip (its data
  lives in a mirroring panel).

Focus indicator exception:

- The global focus outline may be suppressed on cells because the selection
  ring plus a hover-style tint carry the cursor — but only when focus,
  selection, and the visible marker provably coincide in every state. Any
  state that would render no indicator keeps the outline. This is the one
  sanctioned replacement for the global focus ring.

Pending and stale data:

- A committed cell keeps its armed marker until the authoritative state
  replaces it with the result (see [Progress and Loading](controls.md#progress-and-loading)); the round trip
  must not flash the cell back to empty.
- Overlay data (probabilities, heatmaps) may be inspected while live work
  continues; a pinned historical view must survive list compaction — pin by
  identity, not array index, and preserve the pinned entry when samples are
  downsampled.

## Detail Ladder

Inspection is a ladder, not a wall: each rung shows more on demand, and the
user chooses how far to climb.

- Typical rungs: the mark itself (visual encoding) → hover or focus tooltip
  (exact values) → summary panel (the focused entity's context, mirrored for
  keyboard and print) → dedicated detail view (full history, sources).
- Tooltips are never the only rung that carries essential data; the summary
  rung mirrors them, which is also what makes the ladder work without
  focus-time popups when marks are keyboard-navigated.
- Every rung is keyboard-reachable: tooltips show on focus, panel selection
  follows keyboard navigation of marks or interactive legend entries.
- Coach the first rung exactly once — first-use copy near the ladder, then
  silence (see [Content Style](review.md#content-style)).
- Actions live at the rung where the decision is made: commit from the
  summary panel or detail view, never from a tooltip.
