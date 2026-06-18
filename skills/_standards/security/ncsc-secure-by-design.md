# NCSC Secure by Design — posture wrapper

Secure by Design is not a per-finding checklist. It is the framing that says
security must be considered from the very start of a project and throughout its
life, owned by the people accountable for delivery, and backed by evidence. In
this threat model it governs the final section and the overall stance, not
individual threat records.

The threat-modelling activity itself is one of the assurance activities Secure
by Design expects — so producing this document is partly *how* the project
demonstrates Secure by Design, not just a thing the framework comments on.

## What the Secure by Design section of the output should establish

- **Security considered from the start.** Was security built into this design
  from the outset, or bolted on? Note where the design shows evidence of
  security-by-design thinking, and where it looks retrofitted.
- **Risk ownership.** Every significant residual risk has a named accountable
  owner. The threat model does not accept risk; it routes each significant
  residual risk to the human who must decide whether to accept, mitigate, or
  avoid it. List these explicitly.
- **Proportionate, threat-informed decisions.** Security decisions should be
  driven by an understanding of the actual threats and be proportionate to them
  — not generic box-ticking. The threat register *is* the evidence base for
  this; reference it.
- **Assurance and continuous validation.** Security is not a one-off gate.
  Note what ongoing assurance backs the model: testing, monitoring (ties to
  NCSC Cloud Principle 5 and OWASP A09:2025), and the cadence at which this
  threat model should be revisited as the design changes.
- **Decisions and trade-offs are recorded.** Where a security trade-off was
  made, it should be documented and traceable — not lost in a conversation.

## The mandatory closing artefact: open risk decisions

End the threat model with an explicit, consolidated list of every threat marked
`Needs human risk decision: YES`. For each:

```
OPEN RISK DECISION — THREAT-NNN
  Residual risk:      <restate concisely>
  Decision required:  Accept / Mitigate further / Avoid
  Accountable owner:  <role that must decide — name left for the human>
  Recommendation:     <the skill's recommendation, clearly marked as advisory>
```

This list is the handoff to the human assurance process. The skill's
recommendations here are explicitly advisory. The accountable decision is made
by a person, recorded by a person, and owned by a person. Make that boundary
unmissable in the output.
