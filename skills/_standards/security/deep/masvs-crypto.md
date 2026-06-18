# MASVS-CRYPTO — mobile cryptography & key management — deep

Pull when mobile crypto/key applicability is contested or unclear.

**Check**
- Keys generated and held in hardware-backed storage (Secure Enclave / StrongBox / TEE);
  non-exportable; access gated by user presence/biometric where appropriate.
- Standard algorithms via platform crypto APIs; no custom crypto; no hardcoded keys.
- Key rotation and invalidation on credential change; keys tied to the device, not shipped.

**Pitfalls**
- A symmetric key hardcoded in the binary or derived from a static value.
- Using a software key when StrongBox/Secure Enclave is available.
- Biometric "unlock" that gates UI only, not the actual key release.

**Example / anti-example**
- *Bad:* AES key embedded as a string constant in the app.
- *Good:* key generated in StrongBox, non-exportable, released only after biometric auth.

**Source (gated web)**: https://mas.owasp.org/MASVS/ (CRYPTO). STRIDE: Tampering, Information disclosure. x-ref A04.
