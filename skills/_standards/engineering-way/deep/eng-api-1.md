# ENG-API-1 Shared-contract change control — deep

Pull when a shared/public-contract change is contested or its "is this breaking?" call is unclear.

**Check**
- Identify whether the change touches a **public** contract: an HTTP API other services
  consume, or a shared-module (polyrepo) public interface. If unsure, treat as public.
- Decide breaking vs non-breaking. **Breaking** = removing/renaming a field/endpoint/method,
  tightening a type, changing semantics, making an optional input required. **Non-breaking** =
  adding optional fields/endpoints, widening output, additive enums handled tolerantly.
- A breaking change to a shared contract requires **TD approval** — route it to the technical
  design process; it is never a plan-time or implement-time decision.

**Pitfalls**
- "It's just a rename" — a rename is a break for every downstream consumer.
- Judging breaking-ness from the producer repo alone, blind to who consumes it (polyrepo).
- Tightening validation (e.g. max length) silently — a break for existing valid callers.

**Example / anti-example**
- *Bad:* dev renames a shared model field to "tidy up"; three other repos break on next pull.
- *Good:* the rename is flagged, routed to the TD, shipped additively (new field + deprecate old).

**Source**: `../api-compatibility.md` (lens). Polyrepo rule; see `generate-implementation-plan` routing.
