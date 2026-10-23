# Read-only reports

Read this when generating a report. The export defaults below target a self-contained HTML file; an embedded report uses its host's shell, navigation, and theme behavior. Use [theme.md](theme.md) for theme integration and [data-display.md](data-display.md) for the components and chart-caption recipe.

## Contents

- [Read-Only Report Profile](#read-only-report-profile)
- [View controls](#view-controls)
- [Sticky section nav (report profile)](#sticky-section-nav-report-profile)
- [Print and PDF](#print-and-pdf)

## Read-Only Report Profile

Use this profile for a self-contained report with embedded data and charts.
Read-only means that readers cannot modify the underlying records. They may
change how those records are presented to explore and understand the report.

Choose the components the content needs; this is not a required section list
or page template. Defaults for a standalone report:

- Use the shared tokens and appropriate components: a page heading, alerts,
  panels, summary values, status chips, tables, charts with Reading captions,
  the technical console for raw output, and empty/error states as needed.
- The icon-only theme picker (System / Light / Dark, exposed — see [the theme picker recipe](theme.md#theme-picker-segmented)). Reports are read in both
  themes, and canvas-based chart libraries must be re-rendered on theme
  change so exports match.
- Start with compact or standard density, set on `:root`. Adapt density or
  offer a reader control when the reading task benefits from it.

Skip:

- Source-data editing, submission workflows, destructive actions, and their
  confirmation dialogs or application notifications. Controls that only
  change the view are allowed; see [View controls](#view-controls).
- Application-shell machinery unrelated to reading the report. A scrolling
  heading with an optional section nav is the usual starting point. For long
  reports, the [sticky strip below](#sticky-section-nav-report-profile), a side
  table of contents, or an in-flow index may suit the content; choose the
  arrangement and theme-picker placement that fit. Embedded reports keep
  their host's navigation.
- Motion entirely. A report renders complete and static; do not add the
  `motion-on` gate, entrance reveals, count-ups, or pulses.

Report-specific rules:

- For a self-contained export: inline CSS and JS, embed the data, never load
  web fonts or remote assets.
- Every chart panel that supports a conclusion carries a **Reading
  caption** — see [the chart caption recipe](data-display.md#chart-caption-the-reading-pattern). This is part of the contract,
  not decoration: it is the version of the chart that survives screen
  readers and print.
- Sections targeted by the nav set `scroll-margin-block-start` covering the
  stuck nav height (see [Sticky Chrome](layout.md#sticky-chrome)).
- Use disclosure, an internal scroll region, or pagination for large tables
  when it helps readers navigate them; keep the row count visible.
- Reports that claim results include provenance: timestamps, parameters,
  and source fingerprints where they exist. A results report without
  provenance is marketing.
- Keep interpretation boundaries prominent (simulation vs. realized, excluded
  effects). An alert near the top is the usual treatment; a different format
  must make those limits just as apparent alongside the conclusions.

## View controls

Add controls when they help readers answer a question: search, sorting,
filters, date ranges, unit switches, chart-series selection, or pagination
for a large result set. They are optional; a short report may need none.
Use the relevant [control recipes](controls.md) with visible labels and
keyboard support.

- Derive the displayed view from the embedded source data; do not overwrite
  records when filtering, sorting, or changing units.
- Make active filters, time ranges, units, and sorting apparent. Show matching
  and total counts where useful, and provide a clear way to reset a view.
- Recompute charts, summaries, and Reading captions from the same view, or
  clearly label a summary that intentionally covers the full dataset.
- State whether a download represents the current view or the full dataset.
  Printed views retain the active filter/range context as text even when
  their controls are hidden.

## Sticky section nav (report profile)

One navigation option for a long standalone report. The label strip scrolls
horizontally inside a track (so the mask fades labels, not borders); the
theme toggle and any other persistent controls sit in a pinned action slot
that never scrolls away. Follows the Sticky Chrome rules: single bottom
boundary, docked at `-1px`, breathing room on both axes.

```html
<nav class="section-nav" aria-label="Sections">
  <div class="section-nav-track">
    <a href="#overview">Overview</a>
    <a href="#returns" aria-current="location">Returns</a>
    <!-- ... -->
  </div>
  <div class="section-nav-actions">
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
  </div>
</nav>
```

```css
.section-nav {
  position: sticky;
  inset-block-start: -1px;
  z-index: var(--ds-z-header);
  display: flex;
  align-items: center;
  gap: var(--ds-space-5);
  margin-block: var(--ds-space-8) var(--ds-space-9);
  padding-block: var(--ds-space-4);
  border-block-end: 1px solid var(--ds-color-border);
  background: var(--ds-color-canvas);
}
.section-nav-track {
  display: flex;
  gap: var(--ds-space-3) var(--ds-space-7);
  min-inline-size: 0;
  overflow: auto;
  padding: var(--ds-space-2) var(--ds-space-6);
  scrollbar-width: none;
  mask-image: linear-gradient(to right, transparent, black
    var(--ds-space-6), black calc(100% - var(--ds-space-6)), transparent);
}
.section-nav-track::-webkit-scrollbar { display: none; }
.section-nav a {
  display: inline-flex;
  min-block-size: 24px;
  align-items: center;
  padding-inline: var(--ds-space-2);
  border-radius: var(--ds-radius-sm);
  color: var(--ds-color-text);
  font-size: var(--ds-font-size-control);
  font-weight: var(--ds-font-weight-semibold);
  text-decoration: none;
  white-space: nowrap;
}
.section-nav a:hover { color: var(--ds-color-accent); text-decoration: underline; }
.section-nav a[aria-current="location"] { color: var(--ds-color-accent); background: var(--ds-color-accent-soft); }
.section-nav-actions {
  display: flex;
  flex: none;
  align-items: center;
  margin-inline-start: auto;
  padding-inline-end: var(--ds-space-5);
}
.section-nav-actions .theme-picker { min-block-size: 28px; }
.section-nav-actions .theme-picker label { min-block-size: 24px; }
```

## Print and PDF

Reports and dashboards get exported. A handful of cheap rules cover it:

- Under `@media print`, force the light palette (`color-scheme: light` plus
  explicit light token values, or `data-theme="light"` in the print copy).
- Hide interactive-only chrome: theme toggle, view controls, chart mode bars,
  skip link, and sticky headers. Preserve the view's filters, range, units,
  and result count as readable text.
- Expand paginated or scroll-clipped results for print so the selected result
  set is not silently reduced to the visible screenful.
- Keep units intact: `break-inside: avoid` on panels, summary values, and
  figures so a caption never separates from its chart.
- Do not put essential content behind closed `details` in print-oriented
  artifacts — collapsed disclosures do not survive printing.
- Chart canvases need an explicit opaque background matching paper
  (`#ffffff`); transparent chart backgrounds render unpredictably in PDF
  pipelines.
