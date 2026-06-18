# MASVS-STORAGE — secure on-device storage — deep

Pull when on-device storage applicability is contested or unclear.

**Check**
- Sensitive data (tokens, keys, PII) stored in the OS keystore (iOS Keychain / Android
  Keystore), not plain files, `UserDefaults`/`SharedPreferences`, or an unencrypted DB.
- Nothing sensitive leaks to logs, crash reports, analytics, clipboard, screenshots, or
  cloud/auto backups (exclude from backup; `FLAG_SECURE` where relevant on Android).
- Data minimisation: not stored at all if not needed; wiped on logout/uninstall.

**Pitfalls**
- Caching an auth token in `UserDefaults`/`SharedPreferences` (world-readable on a rooted device).
- Sensitive fields included in iCloud/Android auto-backup by default.
- PII in screenshots when the app is backgrounded (no privacy overlay).

**Example / anti-example**
- *Bad:* JWT written to `SharedPreferences` for "convenience".
- *Good:* token in Android Keystore-backed `EncryptedSharedPreferences`, excluded from backup.

**Source (gated web)**: https://mas.owasp.org/MASVS/ (STORAGE). STRIDE: Information disclosure. x-ref A04.
