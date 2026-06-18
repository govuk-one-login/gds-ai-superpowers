# MASVS-PLATFORM — safe platform/IPC interaction — deep

Pull when platform-interaction applicability is contested or unclear. A common sensitive-data
leak surface.

**Check**
- Exported components (Android activities/services/receivers/providers) are minimised and
  permission-protected; iOS URL schemes / universal links validate their input.
- Deep links and inter-app data exchange validate and authorise — treat as untrusted entry points.
- WebViews: JS bridges restricted, no `file://`/universal access, no loading untrusted content
  with native bridges exposed.
- Pasteboard/clipboard, share sheets, and notifications don't leak sensitive data.

**Pitfalls**
- An exported Android `ContentProvider` with no permission, readable by any app.
- A WebView `addJavascriptInterface` exposed to remote content.
- A deep link that performs a state change without authenticating the caller.

**Example / anti-example**
- *Bad:* `exported=true` provider returning user records to any installed app.
- *Good:* provider not exported, or guarded by a signature-level permission.

**Source (gated web)**: https://mas.owasp.org/MASVS/ (PLATFORM). STRIDE: Information disclosure, Elevation. x-ref A01.
