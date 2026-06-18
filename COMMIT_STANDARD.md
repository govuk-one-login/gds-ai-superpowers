# Commit message standard

We use a simple **Conventional Commits**–style format so history is scannable and
tooling (changelogs, semver) can use it later. It also keeps the assurance trail
legible: a reviewer should be able to read the log and see what changed in the
encoded standards and why.

---

## Format

```
<type>(<scope>): <short description>

[optional body]

[optional footer]
```

- **First line:** < 72 characters, imperative mood ("add" not "added"), no period at the end.
- **Body:** Wrap at 72 characters. Explain *why* when it's not obvious from the diff.
- **Footer:** Use for breaking changes and issue refs (see below).

---

## Types

| Type       | Use for |
|-----------|--------|
| `feat`    | A new skill, or new capability in an existing skill |
| `fix`     | Correcting a skill's behaviour, trigger, or output |
| `docs`    | Documentation only (README, CLAUDE.md, authoring, this file) |
| `refactor`| Restructuring a skill/template without changing what it does |
| `style`   | Formatting/wording with no behavioural change |
| `chore`   | Tooling, install, repo config (install.sh, .gitignore, CI) |
| `ci`      | CI/CD only (workflows, actions) |
| `security`| A change to encoded **security** standards or a hardening of the tooling |

Use the most specific type that fits. Prefer `fix` over `refactor` when something
was actually wrong.

---

## Scope (optional but encouraged)

Narrow where the change lives. Examples for this repo:

- **`threat-model`**, **`setup`**, … — a specific skill (use its folder name)
- **`standards`** — anything under `_standards/` (the encoded compliance posture)
- **`templates`** — anything under `_templates/`
- **`install`** — `install.sh` and the install mechanism
- **`docs`** — cross-cutting documentation

Omit scope for broad or multi-area changes.

### `_standards/` changes carry extra weight

A change under `_standards/` alters the security/compliance output of every skill
that cites it. Such commits should:

1. use the `standards` scope (and usually the `security` type),
2. say **why** in the body (framework version bump, NCSC guidance change, etc.), and
3. be matched by an entry in `CHANGELOG.md` — that is the assurance trail.

---

## Examples

**Good**

```
feat(threat-model): add MASVS v2 routing for on-device key storage
fix(setup): detect a per-skill name collision instead of clobbering it
chore(install): link each skill flat so slash commands are discoverable
docs: explain per-skill symlink mechanism in CLAUDE.md
security(standards): bump OWASP lens to Top 10:2025 and map legacy refs
```

**Avoid**

```
Updated stuff                    # vague, past tense
fix: fix the bug                 # redundant
feat(scope): Add feature.        # period, capitalised "Add"
```

---

## Footer

- **Breaking changes:**
  `BREAKING CHANGE: <description>` (and/or note in body). For this repo a breaking
  change includes renaming a skill folder (the slash command changes) or moving a
  `_standards/` file other skills cite.
- **Issue reference:**
  `Refs #123` or `Fixes #123` (on its own line in the footer).

---

## Summary

1. First line: `type(scope): imperative short description` (< 72 chars).
2. Body when "why" isn't obvious; footer for breaking changes and issue refs.
3. One logical change per commit; split large changes where it helps a reviewer.
