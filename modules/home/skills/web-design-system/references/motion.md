# Optional application motion

Read only when an interactive application needs motion. The [report profile](reports.md) omits all motion, including count-ups, pulses, and theme cross-fades.

## Contents

- [Motion](#motion)
- [Live status pulse (one per view, motion-gated)](#live-status-pulse-one-per-view-motion-gated)
- [Count-up for prominent values (one-shot, motion-gated)](#count-up-for-prominent-values-one-shot-motion-gated)
- [Reduced motion](#reduced-motion)

## Motion

| Token | Value | Use |
| --- | --- | --- |
| `--ds-duration-fast` | `120ms` | Hover, focus, border, color |
| `--ds-duration-normal` | `180ms` | Disclosure and small layout changes |
| `--ds-duration-slow` | `300ms` | Progress and deliberate transitions |
| `--ds-ease-standard` | `ease` | General interaction easing |

Do not animate routine page entry or repeatedly animate refreshed content.
Respect `prefers-reduced-motion`.

**Motion is opt-in, not opt-out.** Ship the page fully visible and static by
default. JavaScript adds a single `motion-on` class to `<html>` only when
reduced motion is off, and every animation rule is scoped under it:

```css
.motion-on [data-reveal] {
  opacity: 0;
  transform: translateY(24px);
  transition: opacity 0.7s cubic-bezier(0.16, 1, 0.3, 1),
    transform 0.7s cubic-bezier(0.16, 1, 0.3, 1);
}
.motion-on [data-reveal].is-revealed {
  opacity: 1;
  transform: none;
}
```

```js
const reduce = matchMedia("(prefers-reduced-motion: reduce)").matches;
if (!reduce && "IntersectionObserver" in window) {
  document.documentElement.classList.add("motion-on");
  const io = new IntersectionObserver((entries) => {
    for (const e of entries) {
      if (e.isIntersecting) {
        e.target.classList.add("is-revealed");
        io.unobserve(e.target);
      }
    }
  }, { threshold: 0.12 });
  document.querySelectorAll("[data-reveal]").forEach((el) => io.observe(el));
}
```

No JavaScript or reduced motion → the page renders complete and static. This is
safer than a global `!important` kill-switch, which fights specificity per
component.

Use entrance reveals sparingly — a page's primary content region at most, never
every card. When an entrance transition finishes, remove the reveal hooks so
later hover transforms behave normally.

## Live status pulse (one per view, motion-gated)

For the single live element on a screen — an active incident, a running job —
add an expanding halo to the status chip's leading mark:

```css
.status__mark {
  position: relative;
  width: 7px;
  height: 7px;
  border-radius: 2px;
  background: currentColor;
}
.motion-on .status--live .status__mark::after {
  position: absolute;
  inset: 0;
  border-radius: inherit;
  background: currentColor;
  content: "";
  animation: ds-ping 1.6s cubic-bezier(0, 0, 0.2, 1) infinite;
}
@keyframes ds-ping {
  0% { opacity: 0.6; transform: scale(1); }
  75%, 100% { opacity: 0; transform: scale(2.4); }
}
```

Rules: at most one pulsing element per view, the text label stays, and the
animation only exists under `motion-on`.

## Count-up for prominent values (one-shot, motion-gated)

```js
// Requires the motion-on gate from the Motion section.
if (document.documentElement.classList.contains("motion-on")) {
  const io = new IntersectionObserver((entries) => {
    for (const e of entries) {
      if (!e.isIntersecting) continue;
      io.unobserve(e.target);
      const el = e.target;
      const raw = el.textContent.trim();
      const m = raw.match(/^([0-9][0-9,]*)(.*)$/);
      if (!m || m[1].includes(".")) continue;
      const target = parseInt(m[1].replace(/,/g, ""), 10);
      if (!Number.isFinite(target)) continue;
      const commas = m[1].includes(",");
      const suffix = m[2];
      let t0 = null;
      const step = (ts) => {
        t0 ??= ts;
        const p = Math.min(1, (ts - t0) / 1200);
        const v = Math.round(target * (1 - Math.pow(1 - p, 3)));
        el.textContent = (commas ? v.toLocaleString("en-US") : String(v)) + suffix;
        if (p < 1) requestAnimationFrame(step);
        else el.textContent = raw; // restore the exact server-rendered string
      };
      requestAnimationFrame(step);
    }
  }, { threshold: 0.4 });
  document.querySelectorAll("[data-countup]").forEach((el) => io.observe(el));
}
```

Mark up values with `data-countup`. The final frame restores the exact original
text, so formatting is never lost. Without motion, the value is simply there.

## Reduced motion

The `motion-on` gate in [Motion](#motion) replaces the traditional global
kill-switch: animation rules simply do not exist unless the gate adds the
class. If a project still needs a catch-all (e.g. third-party CSS that
animates), this is the fallback:

```css
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    scroll-behavior: auto !important;
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
```
