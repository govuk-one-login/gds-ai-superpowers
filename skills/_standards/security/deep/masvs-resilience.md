# MASVS-RESILIENCE — resistance to tampering / reverse engineering — deep

Pull when resilience/anti-tamper applicability is contested or unclear. Relevant whenever the
app runs in a hostile environment (a possibly rooted/jailbroken end-user device).

**Check**
- Root/jailbreak and hooking/instrumentation (Frida/Xposed) detection, with a **safe degrade**
  (block the sensitive action, don't just log) proportionate to the threat model.
- Anti-debugging and integrity/tamper checks on the binary; obfuscation of sensitive logic.
- Server-side enforcement of anything that matters — client controls are defence in depth, not
  the security boundary (a determined attacker owns the client).

**Pitfalls**
- Treating client-side root detection as the control (it's bypassable; the server must enforce).
- Detecting tampering but failing open (continuing the sensitive flow anyway).
- Over-investing in RASP for a low-value app where the threat model doesn't warrant it.

**Example / anti-example**
- *Bad:* root check that only writes a log line, then proceeds to release keys.
- *Good:* on detected compromise, refuse the high-value operation and require re-auth server-side.

**Source (gated web)**: https://mas.owasp.org/MASVS/ (RESILIENCE). STRIDE: Tampering.
