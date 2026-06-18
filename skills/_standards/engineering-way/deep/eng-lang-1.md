# ENG-LANG-1 Supported language choice — deep

Pull when a language/stack choice is contested or "is this a new-language decision?" is unclear.

**Check**
- The tier's language is in the programme's supported set already in use — programmes keep a
  deliberately small set (e.g. Node.js/TypeScript and Python 3 for backend/web; native Swift
  (iOS) and Kotlin (Android) for mobile) and allow reasoned exceptions.
- Introducing a **new** language is a **TD-level** decision with a recorded justification, not
  an implementation-time choice. Valid exceptions exist (an alpha experiment expected to be
  replaced; a genuinely unusual problem domain) — but they're named and time-boxed, not default.

**Pitfalls**
- A team adding a new language for one service because it's familiar, with no TD decision —
  creating a long-tail support/skills burden.
- Treating "right tool for the job" as a blank cheque rather than a justified, recorded exception.

**Example / anti-example**
- *Bad:* a new Rust microservice appears in implementation with no design-time decision.
- *Good:* the TD records the language per tier; a proposed new language carries a written rationale.

**Source**: `../languages.md` (lens).
