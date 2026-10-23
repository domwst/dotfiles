---
name: frontend-review
description: Suggest an independent review for substantial frontend changes and substantive changes to frontend-related skills, including their scope, design guidance, templates, and review workflows. Review UI/UX, visual design, or skill instructions through OpenCode with GLM when requested or already authorized. Skip mechanical edits and backend-only changes.
---

# Frontend review

Use a second opinion to improve a working interface. The user's brief, existing
brand, and applicable design system remain the constraints; this skill supplies
a review workflow, not another visual style.

## When to suggest a review

Suggest a review after a representative render is ready for a new page,
substantial redesign, or a meaningful change to a user flow, responsive layout,
theme, or interactive visualization. Also use this workflow when the user asks
for an independent frontend critique. A focused component change may warrant a
focused review when its interaction or visual consequences are significant.

Also suggest a review when frontend-related skills change their activation scope,
design guidance, templates, or review workflow. Revised instructions and a diff
are enough to start this review; a rendered page is not a prerequisite.

Make one suggestion per coherent change. Finish the authorized work without
waiting on an optional review. If a review is already requested or covered by
standing instructions, run it without asking again. Skip trivial copy changes,
mechanical refactors, and another review of an unchanged artifact. When both
frontend-design and web-design-system apply, they share one review pass.

## Prepare useful evidence

Prepare the implementation or revised skill and complete relevant checks before
review.
Keep the review packet outside the repository and include:

- The original brief, audience, primary tasks, requested changes, and meaningful
  constraints, including the established design system and intentional demo
  limitations. Give the reviewer these facts without your preferred verdict.
- Relevant source and, for a modification, its diff or before/after context.
  Select the affected components and styles rather than sending an entire repo.
- For page reviews, actual desktop and narrow-screen renders at normal use sizes.
  Add intermediate widths, supported themes, alternate selections, or
  error/success states where the change makes them informative. Inspect important
  variants rather than assuming the initial state represents them all.
- Accurate screenshot captions: viewport, theme, selected state, and any action
  that produced the view. Distinguish initial viewports, scrolled/full-page
  captures, and close-ups. Include the surrounding page as well as detail views.

Use representative data that is appropriate to send to OpenRouter. Do not include
credentials or unrelated account/repository content. If rendering is unavailable,
state that limitation; source-only feedback cannot establish visual quality.

For a skill review, identify that target in the brief and include the revised
`SKILL.md`, diff, affected references or templates, and related skill instructions
where their scopes overlap. Ask about clarity, contradictions, activation
boundaries, unnecessary constraints, and likely effects on generated interfaces.
When useful for judging a design-rule change, include representative outputs
generated from the same brief before and after the change. Instruction review
can proceed without generating sample pages; label predicted effects as untested.

## Request one independent pass

Hosts are expected to have `opencode` installed with OpenRouter configured.
Default to `openrouter/z-ai/glm-5.3-flash`; honor an explicitly requested reviewer.
Use [scripts/review.py](scripts/review.py), which sends the selected evidence with
the [review prompt](references/review-prompt.txt), disables external plugins and
reviewer tools, and saves the response in a fresh directory.

Write `brief.txt` with the task context and captions for any screenshots, then run:

```sh
python3 "$HOME/.agents/skills/frontend-review/scripts/review.py" \
  --brief /tmp/ui-review-input/brief.txt \
  --source /tmp/ui-review-input/change.diff \
  --source /path/to/affected/component.tsx \
  --image /tmp/ui-review-input/desktop.png \
  --image /tmp/ui-review-input/mobile.png
```

`--source` and `--image` can repeat. `--model` overrides the default reviewer;
`--output` selects a new output directory. Without screenshots the runner marks
the request as source-only. It does not capture the browser or scan the repo.
The default timeout is ten minutes; `--timeout` accepts seconds.
For skill reviews, pass the skill files and diff with `--source`; attach rendered
examples with `--image` when available and relevant.

Read `review.txt` in the printed output directory. If the command fails or the
response is incomplete, inspect the saved events and stderr before deciding
whether to retry. Do not silently switch models or treat missing feedback as
approval. One completed pass is the default; repeat only for a material revision
or an unresolved issue that benefits from another opinion.

## Evaluate the findings

The primary agent owns the final judgment and implementation.

- For skill findings, check the cited instructions and their interaction with
  related skills against representative tasks. Distinguish demonstrated scope
  or instruction conflicts from predictions about resulting UI quality.
- For page findings, reproduce the issue in the stated viewport and state. Inspect
  geometry, computed styles, interaction behavior, and the affected variants.
  Check contrast against the surface actually behind the content, including
  opacity and overlap; source token pairs alone may not describe the rendering.
- Evaluate the complete design intent. Text can be readable yet misplaced on
  its illustration or component. A zoomed crop does not establish legibility at
  normal size, and one good color or theme does not clear another state.
- If the explanation is imprecise but points to a real defect, retain the
  finding and correct its diagnosis. Conversely, test a suspected problem
  before describing it as confirmed. A selected-state capture does not prove
  that state is shown by default.
- Calibrate priority to the user consequence. Separate task failures,
  readability/affordance problems, speculative compatibility concerns, and
  aesthetic preferences. Familiar layouts and existing brand choices do not
  need replacing merely because the reviewer prefers another treatment.
- Apply justified fixes within the authorized task and verify the affected
  behavior. For a review-only request, report recommendations. Do not adopt a
  proposed fix that loses context, keyboard behavior, useful content, or text
  selection, or adds unnecessary motion and scope.

Briefly report the useful findings, what was addressed or remains recommended,
material disagreements, and verification limits. Keep the raw review available;
an independent opinion complements the primary agent's rendered and functional
checks.
