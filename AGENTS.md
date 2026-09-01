# NixOS Project Instructions

You are working on a real, existing NixOS system. Treat the current `/etc/nixos` configuration as the source of truth for the machine's intended behavior.

## Core objective

Solve the user's request correctly while making the **smallest justified change**.

Preserve existing functionality, installed software, hardware support, services, applications, and user workflows unless the user explicitly asks for a change or the requested fix strictly requires it.

Do not redesign the system merely because you prefer a different architecture.

A small problem should receive a small solution.

## Before editing

Inspect the relevant files and directly related configuration before making changes.

Understand:

- what the current configuration does,
- which modules and options are related,
- existing conventions,
- hardware- or machine-specific settings,
- the likely root cause of the requested issue,
- and which changes are actually necessary.

Do not explore unrelated parts of `/etc/nixos`.

Do not repeatedly reread the same files without gaining new information.

Do not edit code merely to "improve" it before understanding the problem.

## Research policy

**Do not browse the internet by default.**

Use local configuration, local documentation, installed tooling, package metadata, and Git history first.

Only perform external research when there is a **specific unresolved technical question** that cannot be confidently answered from local evidence.

Examples:

- uncertain NixOS/Nix syntax,
- uncertain module or option behavior,
- possible deprecation,
- version-specific behavior,
- unclear upstream behavior,
- or a concrete issue that local evidence cannot resolve.

Before searching, ask internally:

> What exact fact am I missing, and will this search resolve it?

If there is no concrete missing fact, do not search.

When research is necessary:

1. Perform at most one targeted search at a time.
2. Prefer official NixOS, nixpkgs, KDE, SDDM, or upstream documentation.
3. Use the result to resolve the specific uncertainty.
4. Stop researching immediately once the uncertainty is resolved.
5. Do not perform another search unless a new, concrete uncertainty remains.
6. Do not compare many alternative implementations after a valid solution is established.

**Research is for resolving uncertainty, not for making the investigation longer.**

## Git history

Use Git history when it can help understand why the current configuration exists or how similar changes were previously implemented.

Useful commands include:

    git status
    git log --oneline --decorate -20
    git log -- <relevant-file>
    git blame <relevant-file>
    git show <commit>

Do not dig through unrelated history.

When history provides enough context, stop.

When creating a commit, follow the repository's existing conventions when possible.

Preferred style:

    fix(<theme>): <message>

Examples:

    fix(display): correct SDDM monitor layout
    fix(display): simplify Plasma configuration
    fix(ai): correct local model configuration

Use a concise theme describing the affected area.

The commit message should describe the actual change, not the investigation.

## Avoid overthinking

Be decisive.

Do not spend large amounts of reasoning on hypothetical problems that do not affect the task.

Do not repeatedly reconsider a solution that is already supported by the available evidence.

Only reconsider when:

- validation fails,
- new evidence contradicts an assumption,
- the user changes the requirements,
- or a concrete technical issue is discovered.

Prefer the **simplest correct, evidence-based solution** over theoretical perfection.

**Think enough to solve the problem, then execute.**

## Avoid agent loops

Do not enter loops such as:

    search → search again → search again → rethink → search again

or:

    inspect → reread → reread → reconsider → reread

or:

    valid solution → invent alternatives → reconsider → redesign → repeat

Instead use:

    inspect → understand → research only if necessary → implement → validate → finish

Once a path is supported by sufficient evidence, commit to it.

Do not restart the investigation from scratch unless new evidence requires it.

## Keep context efficient

**Keep internal reasoning concise, task-directed, and proportional to the difficulty of the task. Do not continue reasoning once the implementation path is sufficiently clear.**

Context is limited and valuable.

Do not spend reasoning on information that cannot affect the implementation.

Do not repeatedly restate large amounts of configuration.

Do not repeatedly summarize the same findings.

Do not spend large amounts of reasoning on speculative edge cases.

Prefer concrete reasoning about:

- root cause,
- constraints,
- implementation,
- validation.

Keep reasoning focused and proportional to the task.

**Do not use the context window as a scratchpad for endless exploration.**

## Tool discipline

Every tool call should have a concrete purpose.

Before using a tool, know what information or action you expect from it.

Avoid:

- redundant file reads,
- redundant searches,
- redundant shell commands,
- unrelated repository exploration,
- repeated validation with no new information.

Use tools to reduce uncertainty or perform necessary work.

## Implementation

Prefer:

- idiomatic Nix,
- declarative configuration,
- simple solutions,
- existing NixOS/Home Manager mechanisms,
- minimal duplication,
- maintainable structure,
- consistency with the surrounding configuration.

Avoid:

- unnecessary abstractions,
- clever Nix tricks,
- unrelated cleanup,
- unnecessary dependencies,
- broad refactors,
- changing software choices without a requirement,
- rewriting working code without a concrete benefit.

If the existing configuration is already good, make only the changes that are actually needed.

## Preservation rules

Treat the current configuration as intentional.

Do not remove, disable, replace, uninstall, or omit existing software or functionality merely because you prefer another approach.

Do not remove existing applications, desktop components, packages, drivers, services, or configuration just to "clean things up."

Do not redesign the system from scratch.

Do not discard or overwrite unrelated uncommitted changes.

If a proposed improvement changes behavior, preserve the current behavior by default unless the user explicitly asks for the change or it is required to solve the task.

## Comments

Prefer self-explanatory code.

Only add or keep comments when they explain:

- non-obvious intent,
- important constraints,
- workarounds,
- compatibility requirements,
- or surprising behavior.

Avoid comments that merely describe obvious code.

Remove redundant or noisy comments when doing so is clearly safe.

Keep remaining comments concise and consistent.

## Validation

Validate the result proportionally to the change.

For NixOS changes, use the appropriate validation for the existing setup, such as:

    nixos-rebuild dry-build ...

or the corresponding flake-based command if the system uses flakes.

Also use relevant:

- syntax checks,
- formatting,
- tests,
- builds,
- runtime checks,
- or configuration evaluation.

Do not run expensive unrelated checks without a reason.

If validation fails:

1. inspect the concrete failure,
2. fix the specific problem,
3. validate again.

Do not repeatedly rerun successful checks without a reason.

## Diff discipline

Before finishing, inspect the relevant Git diff when appropriate.

Confirm:

- only necessary files changed,
- no unrelated cleanup was introduced,
- no existing functionality was accidentally removed,
- no debug code remains,
- no temporary files were introduced,
- and unrelated user changes were preserved.

## Commits

Do not create a commit unless the user asks for one or the task explicitly requires it.

When creating a commit, inspect recent history when useful and follow the repository's established style.

Prefer:

    fix(<theme>): <message>

Examples:

    fix(display): correct SDDM monitor layout
    fix(nix): correct Plasma display configuration
    fix(ai): correct local model configuration

Use the smallest accurate theme and a concise description.

## Communication

Be direct and concise.

Do not narrate every tool call.

Do not dump unnecessary internal exploration.

When the task is complete, report:

- what was found,
- what was changed,
- important behavior changes,
- validation performed,
- and anything genuinely unresolved.

Do not continue explaining after the task is complete.

## Finish rule

Once:

1. the requested problem is solved,
2. existing functionality is preserved,
3. the change is appropriately validated,

**stop.**

Do not continue researching, optimizing, refactoring, or reconsidering simply because more work is possible.

The goal is:

**understand → fix → validate → finish.**
