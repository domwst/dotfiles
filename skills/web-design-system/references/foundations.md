# Foundations

Copy [tokens.css](../assets/tokens.css) into the output stylesheet (inline it for a single-file report). Keep its values and the `--ds-` namespace. Read the rules below for the roles you use.

The asset targets browsers with `light-dark()`, `:has()`, `color-mix()`, and `text-wrap` support. If older browsers are required, compile the same token values into explicit light/dark rules and test them. Do not silently degrade.

The overlay shadow uses theme selectors for its light/dark values: `light-dark()` cannot select whole box shadows ([CSS syntax](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Values/color_value/light-dark)).

## Contents

- [Token Model](#token-model)
- [Color Roles](#color-roles)
- [Feedback Roles](#feedback-roles)
- [Typography](#typography)
- [Spacing](#spacing)
- [Density](#density)
- [Shape](#shape)
- [Borders and Elevation](#borders-and-elevation)
- [Icons](#icons)
- [Focus ring (global default)](#focus-ring-global-default)
- [Metadata text](#metadata-text)

## Token Model

The token block defines three levels:

| Level | Purpose | Example |
| --- | --- | --- |
| Semantic | Meaning shared by all components | `--ds-color-accent`, `--ds-color-text-muted` |
| Feedback | State colors in three forms each | `--ds-color-danger`, `-danger-text`, `-danger-soft` |
| Component | Local alias inside one component's CSS | `--ds-button-background` |

Feature CSS should consume semantic and feedback tokens. Component-level
aliases (see the button example in [component aliases](#component-aliases))
keep component CSS readable but are optional for small projects.

All custom properties use the `--ds-` namespace. Do not invent a parallel local
namespace (`--bg`, `--ink`, `--line`...) — renaming tokens is how values drift
and contrast breaks. If existing local names must stay, alias them directly:
`--bg: var(--ds-color-canvas);`

Do not write `var()` fallbacks for tokens defined in the root block
(`var(--ds-space-3, 8px)`). The token is unconditional, so the fallback is dead
code that hides drift — and it would not even fire for an *invalid* token value,
only for a missing one. Reserve fallbacks for tokens a host document may
legitimately omit.

## Color Roles

| Token | Light | Dark | Role |
| --- | --- | --- | --- |
| `--ds-color-canvas` | `#fafafc` | `#0f0f12` | Application background |
| `--ds-color-surface` | `#ffffff` | `#17171b` | Primary bounded surface |
| `--ds-color-surface-subtle` | `#f0f1f4` | `#1f1f25` | Hover and recessed surface |
| `--ds-color-text-primary` | `#17171c` | `#ececf1` | Headings and primary values |
| `--ds-color-text` | `#3f3f47` | `#c4c4cd` | Default body and control text |
| `--ds-color-text-muted` | `#5f5f68` | `#90909b` | Secondary labels and descriptions |
| `--ds-color-text-subtle` | `#696972` | `#8b8b96` | Nonessential metadata and placeholders |
| `--ds-color-border` | `#e4e5e9` | `#26262d` | Dividers and passive boundaries |
| `--ds-color-border-strong` | `#858892` | `#696974` | Editable and essential boundaries |
| `--ds-color-accent` | `#2563eb` | `#5b9cf5` | Primary action, focus, link, selection |
| `--ds-color-accent-hover` | `#1d4ed8` | `#7cb0f7` | Accent hover and active state |
| `--ds-color-accent-soft` | `rgba(37, 99, 235, 0.08)` | `rgba(91, 156, 245, 0.14)` | Accent-tinted surface |
| `--ds-color-on-accent` | `#ffffff` | `#0b0b0e` | Content placed on accent fill |
| `--ds-color-inverse` | `#17171c` | `#0a0a0d` | High-contrast surface (consoles, logs) |
| `--ds-color-on-inverse` | `#ececf1` | `#e6e6ec` | Primary content on inverse surface |

Rules that prevent the most common mistakes:

- **Do not darken or lighten these values per project.** Use the intended token pairings and check their rendered contrast, including any opacity or compositing.
- Use primary text selectively. If everything uses maximum contrast, nothing
  has hierarchy.
- `--ds-color-text-subtle` is the lightest color allowed for any text. It is
  for nonessential metadata and placeholders only, and still meets AA at small
  sizes. Never invent a lighter gray for text.
- `--ds-color-border-strong` is the weakest color allowed for an editable
  control's boundary (3:1 against adjacent surfaces). `--ds-color-border` is
  for dividers only — never for input outlines.
- Selection always uses `--ds-color-accent-soft` on any surface. Do not
  introduce a dedicated "selected surface" token: a selection tint that is
  indistinguishable from its background in one theme is a bug, and
  per-theme selected surfaces have historically been exactly that.

## Feedback Roles

Feedback names describe generic meaning rather than domain vocabulary.

| Role | Typical meanings |
| --- | --- |
| Positive | Successful, approved, complete, available |
| Warning | Needs attention, at risk, expiring, partially complete |
| Danger | Failed, rejected, destructive, overdue, unavailable |
| Information | In progress, pending, scheduled, contextual |
| Neutral | Draft, inactive, skipped, unknown |

Each role has three token forms:

- **Signal** (`--ds-color-positive` etc.): large fills, progress bars, chart
  series, leading marks. **Not for small text** — signal colors fail the 4.5:1
  text contrast requirement on light surfaces.
- **Text** (`--ds-color-positive-text` etc.): contrast-tested for small labels.
  Also used for marks or borders placed on soft feedback surfaces. In light
  mode this is a darker shade than the signal; in dark mode the 300/400-step
  signals already meet AA, so the text form is the same value as the signal —
  one feedback register per theme, not two.
- **Soft** (`--ds-color-positive-soft` etc.): low-emphasis tinted backgrounds.
  Pair with the text token, never with the signal token, for content on top.

| Role | Signal light/dark | Text light/dark |
| --- | --- | --- |
| Positive | `#16a34a` / `#4ade80` | `#166534` / `#4ade80` |
| Warning | `#d97706` / `#fbbf24` | `#92400e` / `#fbbf24` |
| Danger | `#dc2626` / `#f87171` | `#b91c1c` / `#f87171` |
| Information | `#2563eb` / `#60a5fa` | `#1d4ed8` / `#60a5fa` |
| Neutral | `#6e6e78` / `#8b8b96` | `#5f5f68` / `#8b8b96` |

Warning is a muted amber, deliberately calmer than danger: it means "needs
attention", not "error". A saturated orange reads as an alarm on every
surface and becomes the loudest element on the page. Dark-mode feedback
values are 300–400-step pastels, not the light theme's values lightened —
dark surfaces amplify chroma, and fully saturated hues read as neon on
near-black. On a filled warning surface, use dark ink
(`--ds-color-on-warning`), never white — white on amber fails text
contrast.

Every visible feedback state should include readable text. If an exceptionally
constrained context requires icon-only state, use a distinct symbol or shape and
an accessible name. Color alone never distinguishes state.

When a role is used as a solid fill with content on top, use the matching
`--ds-color-on-*` token (`on-positive`, `on-warning`, `on-danger`, `on-info`).
White on a positive fill is large-text contrast only (3.3:1): at least
24 CSS px, or 18.67 CSS px bold. Bold weight alone does not qualify small
text; use the `positive-text` token on a `positive-soft` surface for it.

Domain terms map onto these roles rather than adding new colors. For example,
`paid`, `healthy`, and `passed` may all map to Positive while retaining their
domain-specific labels. Do not reuse feedback hues as decorative category
colors (e.g. green for one service type, amber for another) — it dilutes the
meaning of real feedback and reintroduces color-only coding.

## Typography

Use a system-oriented sans-serif stack for interface text and a monospace stack
for machine-readable content.

```css
--ds-font-ui: Inter, "Aptos", ui-sans-serif, system-ui, -apple-system,
  BlinkMacSystemFont, "Segoe UI", sans-serif;
--ds-font-data: "SFMono-Regular", "Cascadia Code", Consolas, monospace;
```

The first names in each stack (`Inter`, `Aptos`, `Cascadia Code`) are used
only when already installed on the viewing machine. Everything from
`ui-sans-serif`/`system-ui`/`Consolas` onward is the supported baseline
rendering. Never load these as web fonts, and never trim the generic
fallbacks — self-contained artifacts must render correctly with the system
fonts alone.

| Role | Token | Size | Line-height | Weight |
| --- | --- | --- | --- | --- |
| Body | `--ds-font-size-body` | `14px` | `1.55` | 400 |
| Prose | `--ds-font-size-prose` | `1rem` (normally `16px`) | `1.65` | 400 |
| Page title | `--ds-font-size-page-title` | `clamp(27px, 3.4vw, 34px)` | `1.15` | 700 |
| Section title | `--ds-font-size-section-title` | `19px` | `1.25` | 650 |
| Subsection title | `--ds-font-size-subsection-title` | `16px` | `1.3` | 650 |
| Control | `--ds-font-size-control` | `13px` | `1.3` | 600 |
| Label | `--ds-font-size-label` | `12px` | `1.4` | 600 |
| Prominent value | `--ds-font-size-value` | `19px` | `1.2` | 650 |
| Eyebrow | `--ds-font-size-eyebrow` | `12px` | `1.3` | 600 |

Use the prose role for sustained reading: explanations, methodology, articles,
and narrative sections in reports or applications. Keep compact interface copy,
tables, labels, and controls on their own roles. Apply this class to prose
blocks, not the page shell or a container mixing prose and UI components:

```css
.ds-prose {
  max-inline-size: var(--ds-content-width-prose);
  font-size: var(--ds-font-size-prose);
  font-weight: var(--ds-font-weight-regular);
  line-height: var(--ds-line-height-prose);
  overflow-wrap: break-word;
}
```

The prose defaults are `1rem`, `1.65`, and `70ch`. Keep the root font size at
the browser/user default so the relative size respects reading preferences.
Reading-heavy pages may use a larger prose size; this does not change the
control or table density. Wide tables, charts, and code blocks can sit outside
the prose measure.

`12px` is the size floor for any text a user reads repeatedly — labels,
chips, eyebrows, helper text. Smaller sizes survive only for single glyphs
(a `kbd` hint, a badge mark), never for sentences; 11px body text was tried
and reads as broken rendering at arm's length.

Eyebrow style: `--ds-color-accent`, `--ds-font-data`, uppercase,
`letter-spacing: 0.08em`. It is an optional orientation label above a page or
section title — use at most one per view.

For numbered section flows (multi-section forms, sequential workflows), a
section index may replace the eyebrow: `--ds-font-data`, `--ds-color-accent`,
`12px`, weight 600, formatted `01`, `02`, ... alongside the section title. It
marks sequence, not importance — do not use it on unordered groups of panels.

Headings use `--ds-color-text-primary`. Tracking tightens as size grows:
`-0.035em` at the top of the page-title range, `-0.02em` at section size,
none at body size. Apply `text-wrap: balance` to multi-line headings and
`text-wrap: pretty` to body copy — both are free and prevent ugly rags.

Use the data font for identifiers, code, technical timestamps, hashes, or values
whose character alignment aids scanning. Use the UI font with
`font-variant-numeric: tabular-nums` for prices, scores, quantities, clocks,
and other human-facing numbers when monospace would feel too technical.
Any number that can change while visible (timers, counters, live stats) must
use tabular numerals so the layout does not jitter.

## Spacing

| Token | Value | Typical use |
| --- | --- | --- |
| `--ds-space-1` | `4px` | Tight internal gap |
| `--ds-space-2` | `6px` | Tags and compact groups |
| `--ds-space-3` | `8px` | Control contents |
| `--ds-space-4` | `10px` | Labels and row details |
| `--ds-space-5` | `12px` | Compact component padding |
| `--ds-space-6` | `16px` | Standard panel padding |
| `--ds-space-7` | `20px` | Form and section spacing |
| `--ds-space-8` | `24px` | Major content padding |
| `--ds-space-9` | `32px` | Workflow section gap |
| `--ds-space-10` | `40px` | Page-level separation |

Use `4-16px` inside components and `24-40px` between major workflow regions.
Large whitespace should indicate a real hierarchy change. Do not write raw
pixel paddings and margins in feature CSS — use the tokens.

## Density

Density is a deliberate product setting, not an arbitrary per-page choice.
Pick one per application and set it on `:root` with `data-density`.

| Mode | Control | Row | Panel padding | Field gap |
| --- | --- | --- | --- | --- |
| Comfortable | `44px` | `52px` | `24px` | `20px` |
| Standard | `40px` | `48px` | `20px` | `16px` |
| Compact | `36px` | `40px` | `16px` | `12px` |

Density changes spacing and control height, not text contrast, hit-area
semantics, or information priority. Interactive targets must stay at least
24×24 CSS pixels; use an invisible hit area (padding or `::before`) when the
visual control is smaller.

## Shape

| Token | Value | Use |
| --- | --- | --- |
| `--ds-radius-sm` | `6px` | Tags, code, compact navigation |
| `--ds-radius` | `8px` | Controls, tables, standard panels |
| `--ds-radius-lg` | `12px` | Major bounded groups |
| `--ds-radius-pill` | `999px` | Status, tags, preset tokens, progress only |

Do not increase radius automatically with component size. Avoid mixing many
corner styles in one region. Do not "adjust" radii per project (7px buttons,
7px small radius) — pick from the scale.

## Borders and Elevation

- For passive card and panel boundaries, prefer a ring over `border`:
  `box-shadow: 0 0 0 1px var(--ds-color-border)`. A ring consumes no layout space and lets state changes (hover, selected) alter the
  boundary without shifting content. Reserve the `border` property for
  editable controls, where it participates in the box model deliberately.
- Use the strong border (or ring) for editable controls and essential
  boundaries.
- Prefer dividers and surface contrast to drop shadows.
- A selected segment may use a restrained outline and small shadow.
- Reserve modal elevation for overlays that genuinely sit above the page.
- Avoid stacked shadows and decorative floating cards.
- Restrained `backdrop-filter: blur()` is allowed on sticky chrome (headers,
  docked bars) and modal backdrops where it aids legibility over scrolling
  content. It is not a decorative "glass" effect — do not apply it to cards
  or panels.

Shared state tokens:

| Token | Default | Role |
| --- | --- | --- |
| `--ds-focus-color` | accent | Visible keyboard focus color |
| `--ds-focus-width` | `2px` | Visible keyboard focus width |
| `--ds-focus-offset` | `2px` | Separation from component boundary |
| `--ds-opacity-disabled` | `0.45` | Disabled visual treatment |
| `--ds-dim-muted` | `0.78` | De-emphasis of graphical marks, such as unfocused series or legend swatches |
| `--ds-shadow-selected` | `0 1px 2px rgba(16, 16, 20, 0.08)` | Selected segment only |
| `--ds-shadow-overlay` | theme-aware | Dialog or popover elevation |
| `--ds-color-overlay` | `rgba(0, 0, 0, 0.48)` | Modal backdrop |

De-emphasize text with the existing text roles at full opacity. Legend labels,
context rows, and explanations must remain readable; do not apply
`--ds-dim-muted` to them or to a parent containing text or controls. For example,
`--ds-color-text-subtle` on a light surface falls from about 5.43:1 to 3.43:1
when dimmed to `0.78`, below the normal-text minimum.

Apply `--ds-dim-muted` only to graphical marks and check the composited result
against its actual background. Essential marks still need sufficient contrast
and another way to convey their meaning. `--ds-opacity-disabled` is reserved
for genuinely unavailable controls; keep the adjacent explanation at full
opacity. Do not invent per-feature dimming levels to create hierarchy.

## Icons

- Use icons to reinforce meaning, not decorate empty space.
- Pair unfamiliar icons with text.
- Use one consistent icon family, stroke width 1.5–2px, sized 14–20px.
- Keep status symbols visually distinct without relying on color.
- Give icon-only controls an accessible name and visible tooltip when useful.
- Do not use an icon where a short text label is clearer.

## Focus ring (global default)

Use an outline for focus; a shadow may supplement it but must not be the only
indicator. Forced-colors mode removes box shadows. Preserve the user's system
colors in that mode; do not disable color adjustment across the page.

```css
:focus-visible {
  outline: var(--ds-focus-width) solid var(--ds-focus-color);
  outline-offset: var(--ds-focus-offset);
}
@media (forced-colors: active) {
  :focus-visible {
    outline-color: Highlight;
  }
}
```

## Metadata text

```css
.meta {
  color: var(--ds-color-text-subtle); /* the lightest legal text color */
  font-size: var(--ds-font-size-label);
}
```

## Component aliases

When a component's CSS grows, alias foundation roles locally instead of
repeating long token names:

```css
.ds-button {
  --ds-button-height: var(--ds-control-height);
  --ds-button-background: var(--ds-color-surface);
  --ds-button-border: var(--ds-color-border-strong);
  --ds-button-text: var(--ds-color-text);
}

.ds-button--primary {
  --ds-button-background: var(--ds-color-accent);
  --ds-button-border: var(--ds-color-accent);
  --ds-button-text: var(--ds-color-on-accent);
}
```

When a modifier must override its base rule regardless of file order, use a
compound selector (`.button.button--small`), never source-order dependence.
Equal-specificity rules resolve by file order, and a base defined after its
modifier silently wins — heights, paddings, everything.
