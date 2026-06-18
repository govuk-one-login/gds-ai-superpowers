# Project QA driver register

> Copy this file to your project at `.claude/qa-drivers.md` and fill it in.
> It declares **which concrete tools** `verify-story` uses to drive and test each
> surface, and **how to stand up** each target. Project-owned, same spirit as
> `.claude/source-map.md` and `.claude/standards/`. The cadence library
> stays product-agnostic — it names only *capabilities*; this file names the *tools*.

## How to use it

- One row per surface (`kind`) your repos cover. The skill picks the row from the
  story's `kind`.
- **Capability → tool:** name the concrete tool that fills each capability. The
  durable-test framework is what `verify-story` codifies into.
- **Stand-up contract:** the command to start the target, the externals it needs, and
  what to do when they can't be met (the skill prefers a *provided* target and only
  best-effort stands up).

## Driver register

| `kind` | Interactive driver (drive the running system) | Durable e2e framework (codify into) | Notes |
|--------|-----------------------------------------------|-------------------------------------|-------|
| `backend` | HTTP client (curl / REST client / supertest-style) | [your API e2e/integration framework] | check status, contract, error cases |
| `web-frontend` | the Chrome MCP (environment) | [your browser e2e framework] | role/text selectors; no hard waits |
| `ios` | [your iOS simulator UI driver] | [your iOS UI test / flow tool] | **validate on one real flow before trusting**; iOS sims need macOS |
| `android` | [your Android emulator UI driver] | [your Android UI test / flow tool] | **validate on one real flow before trusting** |

## Stand-up contracts (how to bring up a target)

> The skill prefers a **provided** running target. These are for best-effort local
> stand-up; if the externals can't be satisfied, the skill requests a provided target.

| `kind` | Start command | Required externals | Degrade trigger |
|--------|---------------|--------------------|-----------------|
| `backend` | [e.g. `make run` / `npm start` / `sam local start-api`] | [DB, secrets, seed fixtures] | [externals unavailable → request a provided URL] |
| `web-frontend` | [e.g. `npm run dev`] | [backend/API target, env config] | [backend unavailable → request a provided URL] |
| `ios` | [e.g. build scheme + `xcrun simctl boot` + install] | [booted sim, signing/scheme, bundle id] | [can't build/boot → request a provided booted sim] |
| `android` | [e.g. assemble + `emulator @AVD` + `adb install`] | [AVD, build, fixtures] | [can't build/boot → request a provided emulator] |
