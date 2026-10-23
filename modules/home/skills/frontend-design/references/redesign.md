# Redesigning an existing interface

Read this for a redesign or substantial visual refresh. Inspect the affected
surface and dependencies; a local component change does not require auditing
the entire product.

## Establish what is changing

Distinguish a targeted refinement from a replacement visual language. Use the
request and existing project to determine the scope. If that distinction is
unresolved and would change the implementation, ask one focused question.
An approved visual overhaul still preserves behavior and content unless the
request also changes them.

Before proposing changes, inspect the relevant parts of:

- Brand and presentation: logo, palette, typography, spacing, components,
  theme support, copy voice, and recognizable interactions.
- User journeys: routes, navigation, primary actions, forms, workflows,
  disclosures, and state that users rely on.
- Integrations: form field names, submissions, analytics events, anchor IDs,
  and selectors used by tests or external consumers.
- Public-site discovery: URLs, page titles, canonical metadata, structured
  data, and social preview metadata when present and relevant to the change.

Identify which problems the refresh should solve and which existing choices
already work. Use those findings to choose the smallest sufficient change.
Do not add motion, replace typography, or alter density merely to make a
redesign look more extensive.

## Preserve continuity

Keep route slugs, navigation destinations, form contracts, analytics, and
working accessibility behavior intact unless changing them is in scope.
Preserve brand assets, copy voice, and consent or legal text through a visual
refresh. If a requested change affects these, account for the consequences
within the existing authorization; do not silently expand the task.

When URLs change, include the relevant redirects and update internal links
and metadata. When replacing components, carry over the behavior and state
transitions as well as the visible content. A screenshot of the new style
does not establish that the original workflow still works.

## Review the result

Compare the result with both the requested visual direction and the original
user journeys. Check the affected routes, links, forms, integrations, and
supported responsive and theme states. Distinguish a visual prototype from a
working implementation, and identify any behavior or verification that remains
unfinished.
