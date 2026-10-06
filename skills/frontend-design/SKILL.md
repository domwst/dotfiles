---
name: frontend-design
description: Design or refine frontend interfaces, including websites, product UI, and internal tools. Use for visual direction, layout, typography, interaction, and design critique, within the brief and any established project design system.
license: Complete terms in LICENSE.txt
---

# Frontend Design

<!-- Adapted from https://github.com/anthropics/skills/tree/main/skills/frontend-design.
Local modifications: broader frontend scope, design-system precedence, redesign
preservation, and contextual asset, implementation, and review guidance.
See LICENSE.txt for the upstream license. -->

Make deliberate choices about palette, typography, layout, and interaction that are specific to the brief. Take aesthetic risks when they serve the product and audience; for task-focused interfaces, clarity and familiar behavior may be the strongest design direction.

## Scope and existing constraints

Use this guidance across public websites, customer-facing products, and internal tools. The user's brief and an established brand or design system set the constraints. An applicable design-system skill supplies the visual tokens and component rules; use this skill's design judgment within them. Do not adopt a separate house style merely because the task involves frontend UI, a dashboard, or a report.

Preserve the project's framework, component library, theme behavior, and conventions unless changing them is part of the task. A request for visual improvement does not by itself call for a new stack, new dependencies, or a new design system. Scale the process to the change: a focused component edit needs a focused review, not a page-wide design exercise.

## Ground your designs in the subject matter

Before designing, identify the surface, audience, primary task, references, existing assets, and accessibility or delivery constraints. Distinguish a new build, a targeted refinement, and an approved visual overhaul. Use the brief and project context to infer the direction. For substantial design work, briefly state that reading; ask a focused question only when unresolved ambiguity would materially change the result.

The subject's industry, materials, and vernacular are where distinctive visual choices come from. Build with the brief's real content and subject matter throughout. For redesigns, read [redesign.md](references/redesign.md) to preserve the relevant brand, workflows, routes, and integrations while changing the presentation.

## Design principles

For pages that need a hero, open with what best communicates the subject and gives the audience a reason to continue: a headline, an image, a live demo, or another suitable treatment. Choose its scale and format around that purpose. Task-focused applications should lead with the work people came to do and the context needed to do it.

Typography carries the personality of the page. One well-chosen family can serve both headings and body content; additional faces should have distinct roles.

Where the project leaves type choices open, choose typefaces deliberately rather than automatically reusing a favorite family. Set a clear type scale with intentional weights, widths, and spacing. When type is used as a headline or visual element, let the treatment contribute to the design.

Default to line lengths of less than 80 characters. Serif typefaces can have slightly longer line lengths; give serif body text slightly more line-height than a sans-serif.

Use typographic emphasis to reveal meaning and hierarchy. Labels should orient the reader, and changes in case, weight, style, or color should help them identify what matters.

Visual structure is information. Use spacing, alignment, surfaces, dividers, and labels to express relationships in the content. Numbering should communicate an order or provide a useful reference. Repeat structures where they help comparison; vary them when the content has a different role.

Use motion to direct attention or explain a change. Coordinate any introductory motion around the page's focal point, and keep routine tasks ready to use. Motion that answers a person's action should make the resulting state easier to understand.

Consider written content carefully. Often a design brief may not contain real content, and it's up to you to come up with copy and placeholder content. Copy can make a design feel as templated as the design itself. See the below section on writing for more guidance.

## Process: plan, review against the brief, build, critique

Judge a direction by how well it serves the subject, audience, and task. Familiar palettes, type treatments, and component patterns are valid choices when they fit. Preserve recognizable brand character and useful conventions; a different color scheme or an unusual layout is not evidence of a better design.

Where the brief leaves room for interpretation, make the composition specific through the content it emphasizes, the relationships it exposes, and the actions it supports. Reuse familiar layouts, spacing, surfaces, and controls when they support those priorities; change them when they obscure content, weaken the intended character, or make the task harder.

For a new page or substantial visual change, first sketch a short design plan based on the brief. Reuse established tokens; define a compact token system only where the project needs one.

- Color: identify the palette and its semantic roles, using existing tokens where available.
- Type: the typefaces and their roles.
- Layout: describe the composition and alignment; use a short wireframe when it helps compare alternatives.
- Purpose: how these choices support the audience's main task and the intended character of the page.

Review the plan against the brief before building. Check that its hierarchy makes the most useful content or next action prominent, and that its visual character fits the audience. Respect the requested direction without sacrificing usability or established project conventions.

## Assets and implementation choices

- Use existing brand assets and real product screenshots when they communicate the subject accurately. Generate or source imagery when it adds meaning; a typographic composition or a working component preview may be a better fit. Make missing assets and placeholder content explicit.
- Match content density to the reader's task. Summarize or progressively disclose long content when that improves scanning, while keeping needed details reachable. Vary composition where the content changes and repeat patterns where consistency helps people compare or act.
- Reuse installed components and icon families. Check dependencies before importing new packages. Use official components when implementing a named design system; visual inspiration alone does not require installing that system.
- Every animation should explain hierarchy, feedback, state, or a narrative transition. Respect reduced motion, keep essential content available in the static fallback, and clean up observers, listeners, and animation instances. Avoid driving continuous pointer or scroll animation through React state; use the project's animation tools or browser primitives.
- Preserve supported theme behavior. Add themes when the brief or product needs them, and check contrast and assets in each supported mode. Reserve image and embed dimensions, and avoid loading heavy visual effects before they are needed.

## Restraint and self-critique

Give emphasis a clear hierarchy. An expressive page may benefit from a memorable focal point; a working interface may need a quiet, consistent presentation of several peer items. Keep treatments that support the subject or task and remove those that compete with it. Build to a quality floor: responsive layouts, visible keyboard focus, reduced motion respected, readable contrast, and harmonious color palettes.

Inspect the rendered result at desktop and narrow widths and in supported themes when the environment permits. Assess whether the subject comes through, the content is easy to scan, and the primary task and its essential context remain easy to reach. Reconsider section order and emphasis at narrow widths instead of simply stacking the desktop composition, keeping reading and keyboard focus order consistent with the visual flow. Exercise the affected interactions and their applicable loading, empty, error, and success states. Review actual copy and assets for clipping, awkward wrapping, broken links, and placeholders. Match checks to the change, and report verification that could not be performed.

For substantial frontend changes, consult the `frontend-review` skill to suggest an independent UI/UX review once a representative render is ready.
Also consult it for substantive changes to this skill's scope or guidance, using the revised instructions and diff as review evidence.

## More on writing in design

Words appear in a design for one reason: to make it easier to understand and use. They are design content, not decoration. Bring the same intentionality and minimalism to copywriting that you would bring to spacing and color. Before writing anything, ask what the design needs to say, and how it can best be said to help the person navigate the experience.

Write from the end user's perspective. Name things by what users will understand in simple language, not by how the system is built. A user manages notifications, not webhook config. Describe what something is or does in plain terms rather than selling it. Being specific and legible to new users is always better than being clever.

Use active voice as default. A CTA says exactly what happens when it is used: "Save changes," not "Submit." An action keeps the same name through the whole flow, so the button that says "Publish" produces a toast that says "Published." The vocabulary of an interface is the signposting for someone navigating the product. Cohesion and consistency are how people learn their way around.

Use real evidence for metrics, specifications, testimonials, and customer logos. When mock content is needed, label it visibly as illustrative; a code comment alone does not tell the reader that a claim is invented. Preserve the meaning of supplied quotes and technical details when shortening copy.

Treat failure and emptiness as moments for direction, not mood. Explain what went wrong and how to fix it, in the interface's voice rather than a person's. Errors don't apologize, and they are never vague about what happened. An empty screen is an invitation to act.

Keep the tone conversational: plain verbs, sentence case, no filler, with tone matched to the brand and the audience. Let each written element do exactly one job.
