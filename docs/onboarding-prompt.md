# Onboarding prompt

After you've cloned the repo (`git clone <repo-url> && cd cadence`),
start Claude Code in the repo and paste the prompt below. It drives the install
for you and verifies it worked, so you don't run commands by hand.

---

> Set up the cadence skill library on my machine. Read `install.sh`
> and `README.md` first so you follow the intended setup. Install globally
> unless I tell you otherwise. It links one symlink per skill into
> `~/.claude/skills` alongside anything already there — if a skill's name
> collides with something I already have (the installer will say so and leave
> the existing one alone), stop and tell me rather than guessing. After
> installing, verify `/threat-model` and `/setup` are discoverable as slash
> commands (each linked one level deep) and that their shared `_standards/`
> references resolve through the links, and tell me plainly whether it's healthy.

---

If the library is already installed and you just want the latest version, paste
this instead:

> Update the cadence skill library: pull the latest, re-verify the
> install, and tell me what changed — especially anything under `_standards/`,
> since that affects security and compliance output.

Both prompts trigger the `setup` skill, which carries the safety checks and the
post-install verification. Once the library is installed, every lifecycle
operation (update, re-link, health check) is a sentence like the above — no
command list to follow.

## Why the one clone step is manual

A model can't fetch a repo it can't see, so the initial `git clone` is
unavoidable. We keep it a visible, readable step rather than a "paste this and
run it blind" one-liner on purpose: a blind pipe-to-shell install is exactly the
software-supply-chain pattern this library's own `threat-model` skill flags
(OWASP A03:2025). A plain clone of a reviewed repo, then a script you can read,
is the posture we want to model.
