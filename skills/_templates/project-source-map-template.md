# Project source map

> Copy this file to your project at `.claude/source-map.md` and fill it in.
> It tells the architect pipeline which codebases a design for **this** project
> should be grounded in — so a generated Technical Design reuses real modules and
> real API contracts instead of inventing them. Project-owned, same spirit as
> `.claude/standards/`.

## How to use it

- One row per code source a design should consider. The repo you run the generator
  in is always included automatically — list the *other* relevant repos here.
- **Location** is either a **local path** (preferred — already checked out, nothing
  to clone) or a **remote git URL**. For a remote URL the generator offers a
  shallow, **read-only** clone (gated) only when no local checkout is given; it
  never executes anything from a cloned repo. Private URLs need your git auth — if
  a clone fails, check the repo out and switch the row to its local path.
- Keep `Scope` specific enough that the generator knows which part of a large repo
  is relevant.

## Source map

| Name | Kind | Location | Scope / notes |
|------|------|----------|---------------|
| Mobile app | ios-app | /Users/you/repos/my-app-ios | core user journeys, on-device storage, API client |
| [name] | ios-app \| android-app \| backend \| infra \| lib | [local path or https://git…] | [which part is relevant] |
