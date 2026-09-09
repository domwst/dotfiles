# Interactive controls and recipes

Read the contract and recipe for controls the artifact actually needs. Account for relevant states, keyboard behavior, focus, ARIA, overflow, and responsive behavior; no component specification document is needed. Read-only reports may use controls that [change the view](reports.md#view-controls); their theme picker is in [theme.md](theme.md).

## Contents

- [Existing library controls](#existing-library-controls)
- [Buttons](#buttons)
- [Form Fields](#form-fields)
- [Combobox and Autocomplete](#combobox-and-autocomplete)
- [Date and Time Input](#date-and-time-input)
- [Selection Controls](#selection-controls)
- [Segmented Controls](#segmented-controls)
- [Menus, Popovers, and Tooltips](#menus-popovers-and-tooltips)
- [Dialogs and Drawers](#dialogs-and-drawers)
- [Progress and Loading](#progress-and-loading)
- [Keyboard Shortcut Hints](#keyboard-shortcut-hints)
- [Text input](#text-input)
- [Primary / secondary buttons](#primary--secondary-buttons)
- [Info tip (icon-triggered popover)](#info-tip-icon-triggered-popover)
- [Keyboard shortcut hint](#keyboard-shortcut-hint)
- [Dialog](#dialog)

## Existing library controls

Prefer native HTML controls for new UI. Existing library controls, including
SVG chart legends and toolbars, may be retained or adapted when they provide
equivalent accessible names and roles, keyboard operation, visible focus, and
selection or toggle state. Keep pointer and keyboard behavior in sync, including
after rerenders. ARIA attributes alone do not establish equivalence; verify the
rendered control's behavior. Replacing its markup is unnecessary when this
contract is met.

## Buttons

Variants:

- Primary: the strongest action in a local region
- Secondary: ordinary action with neutral surface and border
- Quiet: low-emphasis action with no persistent boundary
- Danger: destructive action using danger semantics

Rules:

- Use one primary action per local decision area.
- Start labels with a clear verb when the action changes state.
- Keep the visible label after an icon whenever space permits.
- Require confirmation or a clear undo path for unrecoverable actions.
- Use `aria-pressed` only for toggle buttons, not ordinary actions.
- Disabled buttons must remain legible and should not replace validation help.
- A disabled control whose cause is not obvious gets an adjacent info tip
  (see [the info-tip recipe](controls.md#info-tip-icon-triggered-popover)) stating the cause and the recovery path — the
  tip's trigger stays keyboard-reachable even though the control is not.
- A disabled button's label still names its action ("Continue search"); it
  never narrates completion ("Search complete"). A status message posing as a
  control reads as a bug, and the adjacent progress affordance already says
  it. Prefer keeping the action label and adding that adjacent affordance; an
  in-flight label ("Connecting…") is acceptable only where no room for one
  exists, such as a compact modal.

## Form Fields

A field includes label, control, optional help, and optional validation message.

- Labels remain visible after entry; placeholders are examples, not labels.
- Help text explains format, effect, or constraints — and states **when** a
  value applies: immediately, live to in-flight work, or on the next start
  ("Live while a search runs · hard limit 10,000"). A continuous input that
  retargets in-flight work debounces its commands (~250ms) and skips no-op
  sends; one that applies on the next start says that instead.
- Errors explain how to recover, not merely that input is invalid.
- Required state is available visually and programmatically.
- Inputs expose autocomplete, input mode, and native type where appropriate.
- Focus uses an accent boundary and visible focus ring.
- For composite fields (an icon or a merged input-and-button sharing one
  border), carry the focus boundary on the container: `:focus-within` sets
  the accent border and the standard focus outline on the wrapper, and the
  inner input suppresses its own outline. Keep it an outline rather than only
  a box-shadow, so forced-colors mode preserves the indicator.
- Invalid state uses danger text plus a message, not a red border alone.
- When a form submission fails with multiple errors, show an error summary at
  the top of the form listing each problem, and move focus to it.

This contract applies to text inputs, text areas, selects, date controls, search,
and domain-specific field wrappers.

## Combobox and Autocomplete

Use a native `select` for a short, static option set. Use a combobox when users
must search, filter, create, or load options asynchronously.

- Follow the ARIA combobox and listbox pattern.
- Expose expanded state, controlled popup, active option, and selected value.
- `ArrowDown` and `ArrowUp` move through options; `Enter` selects; `Escape`
  closes without an unexpected value change.
- Keep typed text, active option, and committed value as distinct states.
- Announce loading, no-results, validation, and selection changes appropriately.
- Multi-select exposes every selected item and gives each removal action an
  accessible name.
- Virtualized options must retain correct set size, position, and focus behavior.

## Date and Time Input

Use native date and time controls when their behavior meets the product need. A
custom picker must also support direct text entry.

- Display values unambiguously (include time zone when it can change meaning).
- Calendar dialogs use grid semantics and documented arrow, page, home, and end
  key behavior.
- Date ranges expose start, end, invalid ordering, unavailable dates, and partial
  selection states.
- Do not make pointer interaction the only way to enter a date.

## Selection Controls

Use checkboxes for independent choices, radios for one choice from a set, and a
switch only for an immediately applied binary setting.

- Use native controls or preserve equivalent keyboard semantics.
- Give each group a visible label or accessible name.
- Preserve arrow-key movement for radio groups.
- Keep labels clickable and do not hide focus.
- Explain consequences for settings with a non-obvious effect.

## Segmented Controls

Use a segmented control for two to four mutually exclusive, short options.

- Build selection on native radio semantics (visually hidden inputs + labels).
- The selected segment is `--ds-color-accent-soft` with a 1px accent boundary.
  Use that treatment identically on every segmented control in the view — one
  picker whose selection is a tinted chip next to another whose selection is a
  raised chip reads as two different systems.
- When the control carries a text label in front of its options, the label
  must be unmistakably a label: a small semibold slightly-tracked group label
  (sentence case is enough; uppercase is optional) or a position outside the
  control. An unchecked segment is muted text exactly like a bare label would
  be — without one of those treatments the label reads as a dead option and
  the option reads as naked text, whichever the user fixates on.
- When the labeled control sits inside a larger region, give the options their
  own track surface (`--ds-color-surface` inside a `--ds-color-surface-subtle`
  region) and let the selected segment fill the track edge-to-edge — matched
  heights and radii, zero inner padding — so selection reads as the track's
  state, not a box inside a box.
- When a small region feels over-nested, thin the decoration before dropping a
  hierarchy level: fills may stack, but not every layer also needs a stroke.
  One stroke inside the region (the selection) plus the action button's own
  boundary is the budget.
- Keep every segment equally reachable by keyboard and pointer.
- Do not use segments as general site navigation or for long labels.

## Menus, Popovers, and Tooltips

- Menus contain actions or choices, not arbitrary layout.
- Popovers contain lightweight contextual interaction.
- Tooltips explain controls; they do not contain required information.
- Use [the info-tip recipe](controls.md#info-tip-icon-triggered-popover) for icon-triggered explainers,
  including explanations beside disabled controls.
- Tooltip content is available on keyboard focus as well as hover. An explicit
  info trigger also supports click/tap. Keep the tip open while the pointer is
  over its content, and let Escape dismiss it without moving focus or the
  pointer. It stays dismissed until a new interaction opens it.
- Duplicated chart hints need not add a focus stop for every mark if an
  equivalent keyboard-accessible view already exposes the same information.
- Escape closes the topmost dismissible layer.
- If a popup moved focus into itself, return focus to its trigger on dismissal.
  A tooltip contains no interactive elements and leaves focus on its trigger.
- Positioning must adapt at viewport edges and at zoom.

## Dialogs and Drawers

- Use dialogs for focused decisions that interrupt the current flow.
- Use drawers for related detail that benefits from retaining page context.
- Prefer the native `<dialog>` element; trap focus only while modal behavior is
  active.
- Label the surface with `aria-labelledby` or an accessible name.
- Put destructive actions after explanatory copy.
- Avoid stacking multiple modal layers.
- Use `--ds-z-modal` for the dialog and `--ds-color-overlay` for the backdrop.

## Progress and Loading

- Prefer local progress near the affected region.
- Use skeletons only when the final structure is predictable.
- Use a spinner for indeterminate work without a predictable layout.
- Avoid replacing the entire page when only one region is loading.
- Use native `progress` or `role="progressbar"` with the applicable ARIA values.
- Label indeterminate progress with the current operation.
- For actions the server confirms within a second, keep the pre-action state
  visible with a pending marker until the authoritative response replaces it.
  Do not flash optimistic state and revert it on the response — a move that
  briefly disappears and reappears reads as a rejection.
- Guard repeat activation with an in-flight token cleared on response, error,
  or disconnect; a second press while the first is pending is a no-op.
- When a bar's target can move below its current value while visible (a
  budget lowered mid-run), clamp `aria-valuenow` to `aria-valuemax`; adjacent
  text shows the true numbers.
- A determinate bar may switch to the positive signal color when it
  completes, with the completion state still readable as text nearby.

## Keyboard Shortcut Hints

When a view has keyboard shortcuts, show the hint near the relevant control
using a [`kbd` style](controls.md#keyboard-shortcut-hint). Keep hints secondary (subtle text), hide
them on touch-sized layouts, and never let a hint replace a visible label.

## Text input

```css
.input {
  min-height: var(--ds-control-height);
  padding: 0 var(--ds-space-5);
  border: 1px solid var(--ds-color-border-strong); /* never --ds-color-border */
  border-radius: var(--ds-radius);
  color: var(--ds-color-text-primary);
  background: var(--ds-color-surface);
  font: inherit;
  transition: border-color var(--ds-duration-fast) var(--ds-ease-standard),
    box-shadow var(--ds-duration-fast) var(--ds-ease-standard);
}
.input::placeholder {
  color: var(--ds-color-text-subtle);
}
.input:hover {
  border-color: var(--ds-color-text-subtle);
}
.input:focus {
  border-color: var(--ds-color-accent);
  box-shadow: 0 0 0 3px var(--ds-color-accent-soft);
  outline: var(--ds-focus-width) solid var(--ds-focus-color);
  outline-offset: var(--ds-focus-offset);
}
.input:disabled {
  opacity: var(--ds-opacity-disabled);
}
@media (forced-colors: active) {
  .input:focus {
    border-color: Highlight;
    outline-color: Highlight;
  }
}
```

## Primary / secondary buttons

```css
.button {
  display: inline-flex;
  min-height: var(--ds-control-height);
  align-items: center;
  justify-content: center;
  gap: var(--ds-space-3);
  padding: 0 var(--ds-space-6);
  border: 1px solid var(--ds-color-border-strong);
  border-radius: var(--ds-radius);
  color: var(--ds-color-text);
  background: var(--ds-color-surface);
  cursor: pointer;
  font-size: var(--ds-font-size-control);
  font-weight: 600;
  transition: background var(--ds-duration-fast) var(--ds-ease-standard),
    color var(--ds-duration-fast) var(--ds-ease-standard),
    border-color var(--ds-duration-fast) var(--ds-ease-standard);
}
.button:hover {
  border-color: var(--ds-color-text-subtle);
  color: var(--ds-color-text-primary);
}
.button--primary {
  border-color: var(--ds-color-accent);
  color: var(--ds-color-on-accent);
  background: var(--ds-color-accent);
}
.button--primary:hover {
  border-color: var(--ds-color-accent-hover);
  color: var(--ds-color-on-accent);
  background: var(--ds-color-accent-hover);
}
.button--danger {
  color: var(--ds-color-danger-text);
}
.button:disabled {
  cursor: not-allowed;
  opacity: var(--ds-opacity-disabled);
}
```

## Info tip (icon-triggered popover)

For explainers that must not permanently occupy the layout — value
definitions, why a control is disabled, what an overlay encodes. The trigger
opens the tip on hover or focus. Click/tap pins it; another activation,
Escape, or an outside press dismisses it. Hovering the content keeps it open.
Do not add a timeout or move focus into a tooltip.

```html
<span class="info-tip">
  <button type="button" class="info-tip-trigger"
    aria-describedby="tip-unique" aria-controls="tip-unique"
    aria-expanded="false" aria-label="What network value means">i</button>
  <span class="info-tip-popover" id="tip-unique" role="tooltip" hidden>
    <strong>Network value V</strong>
    The value head's raw read of the position. Positive favors the side to
    move; the favored color flips with every move.
  </span>
</span>
```

```css
.info-tip {
  position: relative;
  display: inline-flex;
  /* Continuous hover area between the trigger and the popover. */
  padding-block: var(--ds-space-1);
  vertical-align: middle;
}
.info-tip-trigger {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  inline-size: var(--ds-space-8);
  block-size: var(--ds-space-8);
  padding: 0;
  border: 1px solid var(--ds-color-border-strong);
  border-radius: 50%;
  color: var(--ds-color-text-muted);
  background: transparent;
  cursor: help;
  font-size: var(--ds-font-size-label);
  font-weight: var(--ds-font-weight-bold);
  line-height: 1;
}
.info-tip-trigger:hover {
  border-color: var(--ds-color-text-subtle);
  color: var(--ds-color-text-primary);
}
.info-tip .info-tip-popover {
  box-sizing: border-box;
  position: absolute;
  inset-block-start: 100%;
  inset-inline-end: 0;
  inline-size: min(18rem, calc(100vw - 2 * var(--ds-space-5)));
  z-index: var(--ds-z-popover);
  overflow: auto;
  overflow-wrap: anywhere;
  padding: var(--ds-space-3);
  border: 1px solid var(--ds-color-border-strong);
  border-radius: var(--ds-radius);
  color: var(--ds-color-text);
  background: var(--ds-color-surface);
  box-shadow: var(--ds-shadow-overlay);
  font-size: var(--ds-font-size-label);
  line-height: var(--ds-line-height-body);
  text-align: start;
}
.info-tip-popover[data-side="above"] {
  inset-block-start: auto;
  inset-block-end: 100%;
}
.info-tip .info-tip-popover strong {
  display: block;
  margin-block-end: var(--ds-space-1);
  color: var(--ds-color-text-primary);
  font-size: var(--ds-font-size-label);
  font-weight: var(--ds-font-weight-semibold);
}
```

Run this once after the markup. Give every tip a unique ID. It clamps the
popover to the viewport and flips it above the trigger when needed. Keep
these tips outside clipping containers; within a scroll region or complex
overlay, use the application's positioning/layer mechanism with the same
interaction behavior.

```js
(() => {
  let dismissActiveTip = null;
  document.querySelectorAll(".info-tip").forEach(root => {
    const trigger = root.querySelector(".info-tip-trigger");
    const popover = root.querySelector(".info-tip-popover");
    let hovered = false;
    let pinned = false;
    let dismissed = false;

    function position() {
      popover.style.translate = "none";
      popover.style.maxBlockSize = "none";
      popover.dataset.side = "below";
      const anchor = root.getBoundingClientRect();
      const gutter = parseFloat(getComputedStyle(root).getPropertyValue("--ds-space-5"));
      const below = innerHeight - anchor.bottom - gutter;
      const above = anchor.top - gutter;
      const flip = popover.getBoundingClientRect().height > below && above > below;
      popover.dataset.side = flip ? "above" : "below";
      popover.style.maxBlockSize = `${Math.max(0, flip ? above : below)}px`;
      const rect = popover.getBoundingClientRect();
      const shift = Math.max(gutter - rect.left, Math.min(0, innerWidth - gutter - rect.right));
      popover.style.translate = `${shift}px 0`;
    }

    function render() {
      const open = !dismissed && (hovered || pinned || document.activeElement === trigger);
      if (open && dismissActiveTip && dismissActiveTip !== dismiss) dismissActiveTip();
      popover.hidden = !open;
      trigger.setAttribute("aria-expanded", String(open));
      if (open) {
        dismissActiveTip = dismiss;
        position();
      } else if (dismissActiveTip === dismiss) {
        dismissActiveTip = null;
      }
    }
    function dismiss() {
      dismissed = true;
      pinned = false;
      render();
    }

    root.addEventListener("pointerenter", event => {
      if (event.pointerType === "touch") return;
      hovered = true;
      dismissed = false;
      render();
    });
    root.addEventListener("pointerleave", () => { hovered = false; render(); });
    trigger.addEventListener("focus", () => { dismissed = false; render(); });
    trigger.addEventListener("blur", () => { pinned = false; render(); });
    trigger.addEventListener("click", () => {
      pinned = !pinned;
      dismissed = !pinned;
      render();
    });
    document.addEventListener("pointerdown", event => {
      if (!popover.hidden && !root.contains(event.target)) dismiss();
    });
    const reposition = () => { if (!popover.hidden) position(); };
    window.addEventListener("resize", reposition);
    window.addEventListener("scroll", reposition, true);
  });
  document.addEventListener("keydown", event => {
    if (event.key !== "Escape" || !dismissActiveTip) return;
    dismissActiveTip();
    event.preventDefault();
    event.stopPropagation(); // Close the tip before an enclosing dialog.
  }, true);
})();
```

Beside a disabled control, the trigger explains the cause and the recovery
path; it stays keyboard-reachable even though the control is not. Never put
the only copy of essential information in a tip. If the content needs links,
buttons, or substantial reading, use an explicitly opened popover or disclosure
with the appropriate focus behavior instead of `role="tooltip"`.

## Keyboard shortcut hint

```css
kbd {
  display: inline-block;
  min-width: 18px;
  padding: 1px 5px;
  border: 1px solid var(--ds-color-border-strong);
  border-bottom-width: 2px;
  border-radius: var(--ds-radius-sm);
  color: var(--ds-color-text-muted);
  background: var(--ds-color-surface-subtle);
  font-family: var(--ds-font-data);
  font-size: 11px;
  line-height: 1.5;
  text-align: center;
}
```

## Dialog

```css
.dialog {
  border: 1px solid var(--ds-color-border-strong);
  border-radius: var(--ds-radius-lg);
  color: var(--ds-color-text);
  background: var(--ds-color-surface);
  box-shadow: var(--ds-shadow-overlay);
}
.dialog::backdrop {
  background: var(--ds-color-overlay);
}
```
