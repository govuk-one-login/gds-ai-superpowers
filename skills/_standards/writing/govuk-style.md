# GOV.UK Technical Writing Style — house controls (WRITE-*)

Encodes the writing standards used by this library's `tech-writer` skill. Controls
use house IDs (`WRITE-*`) in the same pattern as `GDSW-*` and `PLAT-*`. Do not
copy this file into a skill or into output — cite control IDs and read this file
when needed.

Primary source: [GOV.UK Content Design guidance](https://www.gov.uk/guidance/content-design)
and the [GOV.UK style guide](https://www.gov.uk/guidance/style-guide). This file
encodes the subset applicable to technical documents (Technical Designs, user stories).

---

## WRITE-PLAIN — Plain English

**WRITE-PLAIN-1: Active voice and sentence length**

Write in the active voice. In the active voice the subject does the action
("the service sends an email"); in the passive voice the action is done to the
subject ("an email is sent by the service"). The passive is not banned but it
must be intentional — use it only when the actor is genuinely unknown or
unimportant.

Aim for sentences under 25 words. When a sentence exceeds this, look first for
a conjunction (`and`, `but`, `which`, `that`) where it can be split cleanly.

Pitfalls: "it is expected that", "it should be noted that", "there is/are" are
passive-voice padding — cut them and rewrite around the real subject.

**WRITE-PLAIN-2: Plain-English substitutions**

Replace latinate or bureaucratic vocabulary with plain equivalents. The GOV.UK
content design list; apply these across the document:

| Avoid | Use instead |
|-------|-------------|
| utilise | use |
| facilitate | help, enable, allow |
| implement | do, carry out, set up |
| leverage | use |
| prior to | before |
| subsequent to | after |
| in order to | to |
| with regard to | about |
| at this point in time | now |
| on a regular basis | regularly |
| in the event that | if |
| provide assistance to | help |
| is responsible for | does, manages, owns |
| a number of | several, many (or give the actual number) |
| due to the fact that | because |
| has the ability to | can |
| in the majority of cases | usually, mostly |
| it is possible that | may, might |
| make a decision | decide |
| reach a conclusion | conclude |

---

## WRITE-ABBR — Abbreviations

**WRITE-ABBR-1: Spell out on first use**

When an abbreviation or acronym appears for the first time in a document, write
it out in full followed by the abbreviation in parentheses:

> "The Government Digital Service (GDS) publishes this guidance."

Use the abbreviation alone on all subsequent occurrences. "First use" means the
first occurrence in the body of the document; a title or heading is not a
definition.

Applies to: acronyms, initialisms, contractions used as abbreviations, and
product/service names shortened to an acronym (e.g. "One Login" abbreviated to
"OL" must be introduced before use).

Pitfalls: tables, diagrams, and code blocks that use an abbreviation without
a definition elsewhere in the body text — each one is a finding.

**WRITE-ABBR-2: Known exceptions (no expansion needed)**

The following abbreviations are sufficiently universal in a UK government
technical context that they do not need expansion on first use. They are the
only exceptions:

`API`, `APIs`, `URL`, `URLs`, `HTTP`, `HTTPS`, `HTML`, `CSS`, `JSON`, `XML`,
`YAML`, `SQL`, `SSH`, `TLS`, `SSL`, `DNS`, `IP`, `UI`, `UX`, `ID`, `IDs`,
`CI`, `CD`, `CI/CD`, `PR`, `PRs`, `VM`, `VMs`, `OS`, `AWS`, `GCP`, `SaaS`,
`PaaS`, `IaaS`, `UK`, `GOV.UK`, `GDS`, `NCSC`, `OWASP`, `WCAG`, `AA`, `AAA`.

Any abbreviation not on this list must follow WRITE-ABBR-1.

---

## WRITE-REP — Repetition and redundancy

**WRITE-REP-1: Cross-section duplication**

The same substantive information should appear in only one place in a document.
When the same fact, decision, constraint, or explanation appears in more than one
section, that is duplication. The fix is to keep the primary instance and replace
or remove the duplicate — a cross-reference ("see section X") is acceptable if the
reader genuinely needs the pointer.

Check for duplication across: the executive summary / overview and the body; the
decision log and a section's rationale; NFRs and the security section;
assumptions and the risks section.

Pitfalls: re-stating a constraint in an architecture section that was already
defined in an NFR row; opening paragraphs of sections that repeat the section
heading in prose form.

**WRITE-REP-2: Verbose phrases**

Single phrases that add length without meaning. Cut or replace:

| Avoid | Use instead |
|-------|-------------|
| in order to | to |
| at this point in time | now |
| on a regular basis | regularly |
| it should be noted that | (cut; just state the thing) |
| it is worth noting that | (cut; just state the thing) |
| it is important to note that | (cut; just state the thing) |
| the fact that | (rewrite around the real subject) |
| in terms of | of, for, about (choose the right one) |
| as a matter of fact | (cut) |
| for the purpose of | for, to |
| with the exception of | except |
| in the majority of cases | usually |
| take into consideration | consider |
| make use of | use |
| be in a position to | can |
| at the end of the day | (cut) |
| going forward | (cut; or specify a date/phase) |
| moving forward | (cut; or specify a date/phase) |

---

## WRITE-TECH — Technical terms and code formatting

**WRITE-TECH-1: Introduce new terms on first use**

When a technical term, domain concept, or proper noun is introduced for the
first time in a document and is not self-evident to the target reader, provide
a brief definition at that point — either inline ("the trust anchor, the
cryptographic root that other components verify against,") or in a Glossary
section if the document uses one. Do not assume a term is self-evident unless
it would be familiar to a senior software engineer reading the document cold.

Pitfalls: domain-specific acronyms treated as known (these also trigger
WRITE-ABBR-1); product-specific component names used without explanation;
architectural patterns cited by name without a one-line description of what
they mean in this context.

**WRITE-TECH-2: Code formatting for technical literals**

The following categories of text must always use inline code formatting (wrapped
in backticks in Markdown):

- Command names and CLI invocations: `npm install`, `git push`
- File and directory paths: `/etc/config.yaml`, `src/handlers/`
- Environment variable names: `DATABASE_URL`, `APP_ENV`
- Configuration keys and values: `max_connections: 100`
- Function, method, and class names when referred to in prose: `authenticate()`
- HTTP methods and status codes when used as literals: `POST`, `200 OK`
- Programming language keywords when used as literals: `null`, `true`, `undefined`
- Package and module names: `express`, `boto3`

Do not use code formatting for product names, service names, or general
concepts even if they are technical: the API Gateway is prose; `aws apigateway`
is a command and gets code formatting.
