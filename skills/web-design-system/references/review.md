# Accessibility, content, and review

Use the applicable checks before delivery. These are implementation checks, not a separate conformance process. Skip checks for components outside the selected profile. Review composition defaults against the task and host application; matching a recipe's page structure or adding otherwise unnecessary controls is not a delivery requirement.

## Contents

- [Accessibility](#accessibility)
- [Content Style](#content-style)
- [Rendered visual review](#rendered-visual-review)
- [Design Review Checklist](#design-review-checklist)
- [Anti-Patterns](#anti-patterns)

## Accessibility

These are requirements, not aspirations — they are cheap when done from the
start and are the most common failure mode in generated UIs.

- Text contrast at least 4.5:1 (3:1 for text ≥ 24 CSS px, or ≥ 18.67 CSS px bold). Essential
  control boundaries at least 3:1 against adjacent surfaces. Use the intended token pairings and verify the rendered result. Large-text thresholds are 18pt/14pt bold, not 18px/14px ([WCAG guidance](https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html)).
- Check composited contrast, including ancestor opacity. Text uses its color
  role at full opacity; graphical dimming must not dim labels or controls.
- Provide a visible two-pixel focus indicator with sufficient contrast. A
  spatial widget may replace the outline with a cursor indicator kept in
  lockstep with focus (see [Dense Grid Widget](spatial-widgets.md#dense-grid-widget)), provided every interactive
  state keeps a visible marker.
- Keep keyboard order aligned with visual order.
- Interactive targets at least 24×24 CSS pixels, via invisible hit area if the
  visual control is smaller.
- Give icon-only controls accessible names.
- Use visible feedback text by default. Icon-only feedback requires a distinct
  non-color symbol and an accessible name.
- Do not hide essential information in hover or tooltips.
- Tooltips support hover, keyboard focus, and explicit-trigger click/tap;
  users can hover their content and dismiss them with Escape without moving
  focus. Dismissal persists until a new interaction.
- Provide one main landmark, appropriate navigation landmarks, a descriptive
  document title, and a bypass link when repeated navigation precedes content.
  Live tools reflect the actionable state in the title ("Your move — App")
  so multi-tab users can find the right tab.
- Preserve content and function at 400 percent zoom and a 320 CSS-pixel viewport
  without two-dimensional scrolling, except for content that inherently requires
  it, such as large data tables or diagrams.
- Respect reduced-motion, forced-colors, and platform contrast preferences.
- Focus and selected states survive forced-colors mode, where box shadows
  disappear. Check outlines and essential boundaries in that mode.
- Use native HTML semantics before recreating them with ARIA.
- Announce asynchronous updates only when they are relevant to the user's task.
- Test with keyboard and zoom at minimum.

## Content Style

- Use sentence case for actions, labels, headings, and messages.
- Prefer concrete product language over generic marketing language.
- Name actions explicitly: `Download report`, `Filter results`, `Create item`.
- Explain consequences before destructive or expensive actions.
- Include units and time zone when ambiguity is possible.
- Keep descriptions concise, but do not remove information needed for a decision.
- Use the vocabulary of the user's domain, not implementation terminology.
- One teacher per fact: an instruction appears once per view. Do not repeat
  the same hint in several panels, and do not caption the absence of state
  ("no cell selected") when its presence is already visible — show state,
  don't narrate its absence.
- Onboarding instructions render on first occurrence only — first turn, first
  empty list — then get out of the way.
- The same hidden/empty explanation never renders in multiple regions of one
  screen; pick the place it belongs and keep the others silent.

Two zero-cost internationalization rules (even for English-only tools):

- Use CSS logical properties (`margin-inline`, `padding-block`,
  `inset-inline-start`) instead of physical left/right properties.
- Do not apply uppercase `text-transform` to user-generated or
  potentially-translated strings; eyebrow/label styling on your own fixed
  strings is fine.

## Rendered visual review

For a new page or a substantial layout change, render the actual artifact with
its charts and data loaded. Inspect screenshots or a browser view at a desktop
and a narrow width, including the supported themes. For a narrow component
edit, inspect the affected region. Functional checks alone do not establish
visual quality.

Assess the rendered layout against the
[composition guidance](layout.md#composition):

- Are the page frame and alignment edges consistent?
- Are headings, labels, summary numbers, and supporting text visibly distinct?
- Do controls belong visually to the regions they affect?
- Do padding and margins leave useful room for the plotted data, without
  unexplained gaps or crowded labels?
- Do surfaces clarify grouping, and does navigation preserve orientation?
- After resizing and chart reflow settle, are wrapping and overflow intentional
  and confined to the regions that need them?

Correct visible problems and re-inspect the affected view before delivery.
Preserve the task's content and capabilities while refining its presentation;
adapt the layout to the task. If rendering or image-viewing
tools are unavailable, perform the checks available and state that visual
review could not be completed.

## Design Review Checklist

Before accepting a screen, verify:

- The hierarchy makes the current task clear.
- A task-oriented page has one primary action; read-only pages may have none.
- Cards represent meaningful boundaries rather than every DOM section.
- Pills are limited to feedback, metadata, and compact preset tokens.
- Segmented-control labels are typographically distinct from their options,
  and the selected-segment treatment matches every other segmented control in
  the view.
- Feedback uses visible text; icon-only exceptions use a distinct non-color
  symbol and an accessible name.
- Status chips and colored labels use feedback **text** tokens, not signal
  colors, at small sizes.
- Input boundaries use `--ds-color-border-strong`, not the divider color.
- No text is lighter than `--ds-color-text-subtle`, and no text is smaller
  than 12px unless it is a single glyph.
- Sustained reading uses the prose type and width roles; compact controls
  and data regions keep their own typography and density.
- Feedback hues are not reused as decorative category colors.
- Accent is not used as positive, warning, or danger feedback. Informational
  feedback intentionally shares the accent hue; that is the one sanctioned
  overlap.
- Chart baseline and context series use `--ds-color-neutral`, not boundary
  or text tokens; charts that support a conclusion have a Reading caption.
- Series identity colors agree across chart, legend, and related tables;
  endpoint marks and caption numbers come from the same data as the series.
- Interactive-chart legends are real controls (`aria-pressed`). Graphical
  de-emphasis uses `--ds-dim-muted` on marks or swatches, with text at full
  opacity; `--ds-opacity-disabled` is reserved for unavailable controls.
- Each instruction appears once per view; the absence of state is not
  captioned, and onboarding copy does not persist past first use.
- Disabled controls with non-obvious causes have an adjacent explanation;
  their labels still name the action.
- Any focus-outline replacement keeps a visible indicator in every
  interactive state.
- Continuous controls state their timing semantics; live retargeting is
  debounced and skips no-op sends.
- Async actions mark pending state and guard double-submission until the
  authoritative response.
- Every applicable interaction and async state is specified.
- Keyboard, focus, ARIA, zoom, and overflow behavior are defined.
- The view works in the host's supported themes, or in light and dark for a
  standalone page unless the single-theme exemption applies.
- Responsive behavior reorganizes content without hiding essential capability.
- Spacing and radii come from the token scales, not raw pixel values.
- Chrome-row controls share one height formula derived from the density
  tokens; no box in a shared row is hand-pixelled.
- Animation only exists under the `motion-on` gate; the page is complete and
  static without it; at most one element pulses.
- JS-rendered artifacts ship a favicon and a `<noscript>` fallback.
- Report artifacts preserve source data and omit motion; useful view controls
  are allowed. Provenance and interpretation boundaries remain visible,
  and captions/print retain the selected view's context.
- Decorative effects are not carrying the design hierarchy.

## Anti-Patterns

Avoid:

- A card for every datum or paragraph
- Multiple nested surfaces without distinct behavior
- Pill-shaped primary actions or navigation
- Oversized task-page headings
- Decorative gradients, glass-effect panels, floating blobs, and shadow stacks
- Icons without labels when text is clearer
- Brand/accent color used as success, warning, or danger
- Raw colors or spacing values in feature styles
- A parallel local token namespace instead of `--ds-*`
- Feedback signal colors as small text
- The same hint repeated in several panels of one screen
- A disabled button whose label narrates state instead of naming its action
- A native tooltip as the only recovery guidance for a disabled control
- Chart endpoints or captions computed from cached earlier data
- Opacity on legend text or context rows; ad-hoc graphical dimming values
- Text below 12px for anything a user reads repeatedly
- Desktop layouts merely scaled down on mobile
- Dark mode produced by simple inversion
- Separate component APIs for each density or theme
- Theming infrastructure, token pipelines, or conformance paperwork beyond
  what this document shows
