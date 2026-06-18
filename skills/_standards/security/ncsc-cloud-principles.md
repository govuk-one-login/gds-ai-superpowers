# NCSC Cloud Security Principles — cloud / backend posture lens

Use this lens for the backend's cloud posture: how services are separated, how
data is protected in transit and at rest in the cloud, supply chain, operational
security, and governance. This is the set your cloud services are assured
against. Cite the principle by number and name.

There are **14 principles**. Walk the ones relevant to whatever cloud surface
STRIDE has surfaced.

1. **Data in transit protection.** Data moving between your services, and
   to/from users, is protected against tampering and eavesdropping (TLS,
   appropriate cipher suites). Maps to STRIDE Information disclosure, Tampering.
2. **Asset protection and resilience.** Data and the assets storing/processing
   it are protected against physical tampering, loss, damage, or seizure —
   covers physical location, data-at-rest encryption, sanitisation, and
   availability. Maps to Information disclosure, Denial of service.
3. **Separation between customers.** One tenant (or one consumer of a shared
   service) cannot affect the service or access the data of another. Critical
   for multi-tenant backends. Maps to Elevation, Information disclosure.
4. **Governance framework.** A security governance framework coordinates and
   directs management of the service and the information within it. Maps to the
   Secure by Design posture.
5. **Operational security.** The service is operated and managed securely —
   covers configuration/change management, vulnerability management, protective
   monitoring, and incident management. Maps to Tampering, and to OWASP
   A09:2025 logging/alerting.
6. **Personnel security.** Staff with access are subject to appropriate
   screening and have minimum necessary access.
7. **Secure development.** Services are designed and developed to identify and
   mitigate threats to their security — design-time security, this exercise
   included. Maps to OWASP A06:2025 Insecure Design.
8. **Supply chain security.** The service's supply chain (including
   subcontractors and third-party components) satisfies the security
   principles. Maps to OWASP A03:2025 Software Supply Chain Failures.
9. **Secure user management.** Tools and mechanisms let you securely manage your
   use of the service — authentication and access control for management
   interfaces. Maps to Spoofing, Elevation.
10. **Identity and authentication.** Access to service interfaces is constrained
    to authenticated and authorised individuals/identities. Maps to Spoofing.
11. **External interface protection.** All external or less-trusted interfaces
    are identified and appropriately defended. Maps to Tampering, Elevation —
    pairs with the trust-boundary analysis.
12. **Secure service administration.** Administration is designed to make
    compromise of admin systems hard, since these are high-value targets. Maps
    to Elevation.
13. **Audit information for users.** You are given the audit records needed to
    monitor access and detect misuse. Maps to Repudiation, OWASP A09:2025.
14. **Secure use of the service.** The division of responsibility between you
    and the provider is clear, so you can use the service securely (the shared
    responsibility model). Maps to the Secure by Design posture.

## Using this lens
- Cite as e.g. "Governing control: NCSC Cloud Principle 3 — Separation between
  customers".
- Principles 1, 2, 3, 5, 8, 11 carry most of the per-finding weight in a
  typical backend threat model; 4, 6, 7, 14 are more posture/governance and feed
  the Secure by Design section.

## Deep tier
Authored deep files for the two principles whose operational depth isn't already carried by an
OWASP/MASVS deep file (P1 data-in-transit → A04/MASVS-NETWORK; P5 → A09; P8 → A03). **Pull only
when about to record the principle Contested / Deferred / applicability Unclear.**
- Principle 3 (Separation between customers) — deep: deep/ncsc-cp-03.md
- Principle 11 (External interface protection) — deep: deep/ncsc-cp-11.md
