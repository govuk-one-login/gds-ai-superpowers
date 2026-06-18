# Project standards register

> Copy this file to your project at `.claude/standards/INDEX.md` and fill it in.
> It declares the standards **this project** must adhere to. The
> cadence skills discover it from the project root and honour it
> alongside the library's own (cross-engagement) standards — they never embed a
> product-specific standard in the library.
>
> This register is **project-owned**. It is the source of truth for "what must
> this work conform to", covering both external/regulatory standards (ISO, GDPR,
> WCAG, …) and internal conventions (house coding style, architecture rules).

## How to use it

- One row per standard. Keep `Scope` specific enough that a skill can tell whether
  a given design surface is governed by it.
- **Pointer vs encoded reference:**
  - **Pointer** (default) — leave `Reference` as `—`. Skills reason about the
    standard from its name, scope, and link. Good for awareness and for recording
    adherence in a design.
  - **Encoded reference** — set `Reference` to a path like `service-standard.md` (a file
    next to this one) in which you write the *specific* controls/clauses that
    matter to this project. A check skill can then verify a design against those
    named controls, the same way the library checks against OWASP/MASVS. Add this
    only when you want clause-level conformance, not just awareness.

## Register

| Name | Type | Scope | Authority / link | Reference |
|------|------|-------|------------------|-----------|
| [sector standard, e.g. ISO 27001] | external | [scope — what surfaces it governs] | [link to standard] | — |
| Platform / CI-CD baseline & constraints | internal | **security baseline:** repo setup & branch protection, PR/review rules, CI/CD pipeline & supply-chain integrity, deploy/IaC, cloud IAM. **fit constraints:** approved region(s)/residency, approved-services list, tenancy/isolation model, resource & quota limits, network egress rules | [owning platform team / link] | [`platform-baseline.md` or —] |
| [standard name] | external \| internal | [surfaces/topics it governs] | [link or owning team] | [`file.md` or —] |

> **Why declare the platform baseline & constraints.** The architect skills treat the
> delivery and hosting platform as **inherited** — assured once here, not re-modelled per
> design. Two skills read this row: `threat-model` and `check-security-standards` **cite
> and defer** to the **security baseline** for pipeline / repo / supply-chain surfaces
> (instead of drilling into reviewer counts and deploy configs in every TD); and
> `check-platform-constraints` checks each design **fits** the **fit constraints**
> (residency, approved services, quotas, egress, tenancy) and security-checks any *new*
> platform component a design introduces. Leave `Reference` as `—` for a pointer, or
> encode the specific values in `platform-baseline.md` for clause-level checks.

## Encoded reference files (optional)

If a row sets a `Reference`, create that file next to this one and encode only the
controls this project must meet — cite clause/section identifiers, do not paste
copyrighted standard text. Example skeleton for `service-standard.md`:

```
# [Standard name] — points this project must meet

- [Clause/section identifier] — [what our design must do]
- [Clause/section identifier] — [requirement]
- ...
```
