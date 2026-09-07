# Theme behavior and picker

Read this for a new page or changes to theme behavior. Standalone reports use the picker without animation; application cross-fades are optional and follow [motion.md](motion.md). The picker below keeps its current state in memory so blocked storage cannot desynchronize the theme and its controls.

## Contents

- [Theme Behavior](#theme-behavior)
- [Theme picker (segmented)](#theme-picker-segmented)

## Theme Behavior

For a view inside an existing application, consume the host's theme state and
reuse its controls. Keep charts and exports in sync through the host's theme
mechanism; do not add a second picker or overwrite the host's root attributes
and storage. The defaults and recipe below apply when a standalone page owns
its theme state.

Default theme selection follows `prefers-color-scheme`. Explicit light and dark
choices override the browser and persist only when the user has chosen them.

Ship a small theme picker that owns theme state: an always-visible segmented
control with three icon-only options — **System**, **Light**, **Dark** — using
the monitor, sun, and moon icons. Keep option names visually hidden and retain
the hover tooltips. System is selected by default
and the page follows the system theme (`prefers-color-scheme`); choosing Light
or Dark pins that theme and persists the choice; choosing System removes the
pin. Expose the control in its normal state — pickers hidden behind a hover
or a click are discovered only after the user has already fought the theme.
A theme change updates:

- The root `data-theme` attribute (which flips `color-scheme` and all tokens);
  System clears it
- The picker's selection state
- Charts, editors, and other canvas-based libraries
- Exported media backgrounds and labels

Do not mutate the root theme attribute anywhere else.

Interactive applications may cross-fade theme switches; reports and reduced-motion users get an instant flip. The mechanism is scoped, not global: a temporary class on the
root enables color transitions (`background-color`, `border-color`, `color`,
`fill`, `stroke`, `box-shadow`) under the `motion-on` gate, the theme flips,
and the class is removed once the fade can no longer be in flight — a
permanent global color transition makes every hover sluggish. The duration is
owned by CSS (`--ds-theme-transition-duration`); JavaScript reads it via
`getComputedStyle` to schedule the class removal and never writes it — a
runtime-patched style value is a second source of truth that drifts. Two traps
found the hard way: the class lives on the root together with `motion-on`, so
the rule needs compound selectors (`.motion-on.theme-transition`) or the
root's own background is excluded from the fade; and the class must be in the
before-change style — read the computed duration (which flushes styles) before
flipping, or the transition may not start at all.

**Resolve the effective theme explicitly when using the standalone recipe.**
Do not infer it from `getComputedStyle(root).colorScheme` — in the unpinned System
state its computed value is the literal string `light dark`, not the
resolved scheme, so the comparison silently fails and chart code renders
the light palette while the page correctly renders dark. Resolve
explicitly: the `data-theme` attribute when present, otherwise
`matchMedia("(prefers-color-scheme: dark)").matches`:

```js
const dark = root.dataset.theme
  ? root.dataset.theme === "dark"
  : matchMedia("(prefers-color-scheme: dark)").matches;
```

**The control's visible state must never depend on persistence succeeding.**
Storage can throw — blocked cookies, private browsing, sandboxed embeds — and
an unguarded write inside the change handler aborts the handler *after* the
theme has already been applied but *before* the selection re-syncs, leaving
a picker that permanently shows a stale selection. Apply the state to the
DOM and the control first, attempt persistence second inside a try/catch,
and re-sync the selection on `pageshow`, since back/forward cache restores
outlive the page's last known state. Use [the theme picker recipe](theme.md#theme-picker-segmented)
instead of hand-rolling this again.

**Single-theme exemption:** a tool that is unambiguously dark-first (e.g. a
log console) may ship dark-only. If so, set `data-theme="dark"` on `<html>` (which selects `color-scheme: dark` and the dark overlay shadow),
keep using the semantic tokens (do not hardcode dark hex values inline), and
omit the toggle. Do not ship light-only.

## Theme picker (segmented)

Prefer firm, rounded outlines for the monitor, sun, and moon, with consistent
visual weight across all three. Target a stroke of 1.5–2 CSS pixels at the
rendered size. The recipe uses a 16×16 viewBox rendered at 16px with a 1.5 stroke.
When substituting another icon family, account for viewBox scaling: a 24×24
icon rendered at 18px needs a stroke width of 2 to retain a 1.5px visible stroke.
Keep the same stroke weight in selected and unselected states; color and the
segment background communicate selection.

The complete theme picker for a standalone report or small tool: three exposed
icon-only options with native radio semantics, defaulting to the system theme.
Storage access is guarded, the selection is synced on init and on
`pageshow`, and a `themechange` event lets canvas-based charts re-theme.

Anti-flash script in `<head>`, before the stylesheet renders a frame:

```html
<script>
  (() => {
    try {
      const saved = localStorage.getItem("report-theme");
      if (saved === "light" || saved === "dark")
        document.documentElement.dataset.theme = saved;
    } catch { /* storage unavailable — theme follows the host */ }
  })();
</script>
```

```html
<fieldset class="theme-picker">
  <legend class="visually-hidden">Color theme</legend>
  <label title="Follow system theme">
    <input type="radio" name="theme" value="system" checked>
    <svg viewBox="0 0 16 16" aria-hidden="true"><rect x="2" y="2.5" width="12" height="8.5" rx="1.5"/><path d="M5.5 14h5M8 11v3"/></svg>
    <span>System</span>
  </label>
  <label title="Light theme">
    <input type="radio" name="theme" value="light">
    <svg viewBox="0 0 16 16" aria-hidden="true"><circle cx="8" cy="8" r="3"/><path d="M8 1v1.5M8 13.5V15M1 8h1.5M13.5 8H15M3.05 3.05l1.06 1.06M11.89 11.89l1.06 1.06M11.89 4.11l1.06-1.06M3.05 12.95l1.06-1.06"/></svg>
    <span>Light</span>
  </label>
  <label title="Dark theme">
    <input type="radio" name="theme" value="dark">
    <svg viewBox="0 0 16 16" aria-hidden="true"><path d="M13.5 9.5A6 6 0 0 1 6.5 2.5a6 6 0 1 0 7 7Z"/></svg>
    <span>Dark</span>
  </label>
</fieldset>
```

```css
.theme-picker {
  display: inline-flex;
  gap: var(--ds-space-1);
  min-inline-size: 0;
  margin: 0;
  padding: var(--ds-space-1);
  border: 0;
  border-radius: var(--ds-radius);
  background: var(--ds-color-surface-subtle);
}
.theme-picker legend {
  position: absolute;
  inline-size: 1px;
  block-size: 1px;
  overflow: hidden;
  clip-path: inset(50%);
  white-space: nowrap;
}
.theme-picker label {
  position: relative;
  display: inline-flex;
  min-block-size: calc(var(--ds-control-height) - var(--ds-space-3));
  align-items: center;
  padding-inline: var(--ds-space-2);
  border: 1px solid transparent;
  border-radius: var(--ds-radius-sm);
  color: var(--ds-color-text-muted);
  cursor: pointer;
  font-size: var(--ds-font-size-label);
  font-weight: var(--ds-font-weight-semibold);
  line-height: 1;
  white-space: nowrap;
}
.theme-picker label:hover { color: var(--ds-color-text-primary); }
.theme-picker label:has(input:checked) {
  color: var(--ds-color-text-primary);
  background: var(--ds-color-accent-soft);
  box-shadow: 0 0 0 1px var(--ds-color-accent);
}
.theme-picker label:has(input:focus-visible) {
  outline: var(--ds-focus-width) solid var(--ds-focus-color);
  outline-offset: var(--ds-focus-offset);
}
.theme-picker input {
  position: absolute;
  inset-block-start: 0;
  inline-size: 1px;
  block-size: 1px;
  opacity: 0;
}
.theme-picker svg {
  inline-size: 16px;
  block-size: 16px;
  fill: none;
  stroke: currentColor;
  /* 1.5px visible stroke: the 16-unit viewBox is rendered at 16px. */
  stroke-width: 1.5;
  stroke-linecap: round;
  stroke-linejoin: round;
}
.theme-picker label span {
  position: absolute;
  inline-size: 1px;
  block-size: 1px;
  overflow: hidden;
  clip-path: inset(50%);
  white-space: nowrap;
}
@media (forced-colors: active) {
  .theme-picker label:has(input:checked) {
    /* Keep system-color text/fill together without a text backplate. */
    forced-color-adjust: none;
    border-color: Highlight;
    color: HighlightText;
    background: Highlight;
    box-shadow: none;
  }
  .theme-picker label:has(input:focus-visible) {
    outline-color: Highlight;
  }
}
```

The transparent border reserves space for the selected-state boundary in
forced-colors mode, where the usual selection shadow and tint disappear.
System highlight colors preserve the selected fill even when unfocused;
keyboard focus keeps a separate outer outline. Only the selected segment
opts out of automatic paint adjustment, using the user's system colors and
removing its shadow; this prevents text backplates from obscuring its label.

The picker hides the text labels **visually only** at every viewport size — visually
hidden spans stay in the accessibility tree so every radio keeps its
accessible name. `display: none` here strips the name and leaves a bare
"radio button" announcement. The `title` tooltips and the visually hidden
legend complete the contract, per the icon rules.

```js
(() => {
  const root = document.documentElement;
  const picker = document.querySelector(".theme-picker");
  const media = matchMedia("(prefers-color-scheme: dark)");
  const KEY = "report-theme";
  const storage = {
    get: (k) => { try { return localStorage.getItem(k); } catch { return null; } },
    set: (k, v) => { try { localStorage.setItem(k, v); } catch { /* private mode */ } },
    del: (k) => { try { localStorage.removeItem(k); } catch { /* ignore */ } },
  };
  const valid = (value) => ["system", "light", "dark"].includes(value);
  const saved = root.dataset.theme || storage.get(KEY);
  let choice = valid(saved) ? saved : "system";
  const effective = () => root.dataset.theme || (media.matches ? "dark" : "light");
  const announce = () =>
    document.dispatchEvent(new CustomEvent("themechange", { detail: effective() }));
  const syncChecked = () => {
    for (const input of picker.querySelectorAll('input[name="theme"]')) {
      input.checked = input.value === choice;
    }
  };
  const apply = () => {
    if (choice === "system") delete root.dataset.theme;
    else root.dataset.theme = choice;
    syncChecked();
    announce();
  };

  picker.addEventListener("change", (event) => {
    const value = event.target.value;
    if (!valid(value)) return;
    choice = value;
    apply(); // Update the theme and controls before attempting storage.
    if (choice === "system") storage.del(KEY);
    else storage.set(KEY, choice);
  });
  media.addEventListener("change", () => { if (!root.dataset.theme) announce(); });
  addEventListener("pageshow", apply);

  apply();
})();
```

Rules: System never writes a `data-theme` attribute or a storage value —
with no pin, the page follows the host through `color-scheme` and
`light-dark()`, and host-preference changes fire `themechange` while
unpinned. The selection write happens on every state change and never
depends on a storage call succeeding; storage errors are swallowed, never
surfaced; charts and other canvas content re-render by listening for
`themechange` (see [Data Visualization](data-display.md#data-visualization)). Hand-rolled variants of this picker
are how controls end up out of sync with the applied theme — copy this one.
