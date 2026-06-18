# OWASP MASVS v2 — mobile app governing lens

Use this lens for the mobile application itself: on-device storage, key
material, the app's interaction with the OS, network communication from the app,
and resistance to tampering/reverse engineering. For an app holding sensitive
data and keys *on the device*, this is frequently the highest-value
lens — a backend-centric threat model tends to under-serve it.

This is **MASVS v2.0** (the current structure; it removed the old L1/L2/R levels
and moved testing profiles into the MASTG). It is organised into eight control
groups. Cite the group (and a specific control number where you can,
e.g. MASVS-STORAGE-1).

## The eight control groups

- **MASVS-STORAGE — secure storage of sensitive data at rest.** Is sensitive
  data (secrets, keys, PII) stored encrypted and access-controlled? Is
  anything sensitive in logs, caches, backups, clipboards, or screenshots?
  Maps to STRIDE Information disclosure.
- **MASVS-CRYPTO — correct cryptography and key management.** Are
  industry-standard algorithms used? Are keys generated, stored, and rotated
  properly, ideally in hardware-backed keystores / secure enclave? Maps to
  STRIDE Tampering and Information disclosure.
- **MASVS-AUTH — authentication and authorisation.** Are auth mechanisms sound,
  including biometric and device-binding flows? Is local authentication
  enforced server-side where it matters? Maps to STRIDE Spoofing and Elevation.
- **MASVS-NETWORK — secure network communication (data in transit).** Is TLS
  enforced and validated? Is certificate or public-key pinning used where
  appropriate? Maps to STRIDE Information disclosure and Tampering.
- **MASVS-PLATFORM — safe interaction with the platform and other apps.** IPC,
  deep links, WebViews, exported components, permissions, inter-app data
  exposure. A common sensitive-data-leak surface. Maps to STRIDE Information
  disclosure and Elevation.
- **MASVS-CODE — data-processing best practice and staying current.** Input
  validation in the app, safe handling of data from external sources, keeping
  dependencies and the platform up to date. Maps to STRIDE Tampering.
- **MASVS-RESILIENCE — resistance to reverse engineering and tampering.**
  Anti-tampering, anti-debugging, integrity checks, obfuscation, RASP. Relevant
  whenever the app runs in a hostile environment (an end user's possibly
  rooted/jailbroken device). Maps to STRIDE Tampering.
- **MASVS-PRIVACY — protecting user privacy.** Data minimisation, transparency,
  preventing tracking. Directly relevant to **tracking-resistance** and
  data-minimisation concerns. Maps to STRIDE Information disclosure.

## Using this lens — highest-value questions for an app holding sensitive data
The questions that matter most for an app that holds sensitive data on the device:
- **STORAGE + CRYPTO:** are sensitive data and signing/binding keys held in
  hardware-backed secure storage, not extractable even on a compromised device?
- **RESILIENCE:** does the app detect a rooted/jailbroken or hooked environment,
  and does it degrade safely? (This is where prior RASP evaluation work lands.)
- **PRIVACY:** does the app minimise the data it collects and shares, and resist
  correlation/tracking across interactions?
- **PLATFORM:** can another app on the device, a malicious deep link, or a
  screenshot leak sensitive data?

## Deep tier
Authored deep files for the highest-value groups (check / pitfalls / example / link). **Pull
one only when about to record that control Contested / Deferred / applicability Unclear.** The
other groups (AUTH, CODE, PRIVACY) are covered by the lens here (+ A07 for AUTH).
- STORAGE — deep: deep/masvs-storage.md   · CRYPTO — deep: deep/masvs-crypto.md
- NETWORK — deep: deep/masvs-network.md   · PLATFORM — deep: deep/masvs-platform.md
- RESILIENCE — deep: deep/masvs-resilience.md

Source: mas.owasp.org/MASVS/.
