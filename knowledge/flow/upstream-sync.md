# Upstream Template Sync

Version 1.1 | 2026-07-25 | Production

---

## Document Purpose

How a fork of this template checks whether the upstream template (`proto-context-architecture` itself) has changed, and how to bring the fork's system-layer files up to date when it has. Only relevant to forks — this file has no effect in `proto-context-architecture` itself, which has no upstream of its own.

---

> **Routing check:** This file governs opportunistic system-layer housekeeping, not routine work. Do not act on it outside a System project session with explicit human confirmation, same as any other structural change.

> **Edit guard:** Changes to this file are system-layer work. Route to `projects/system/` and record the change in `session-log.md` before editing.

---

## Index

1. [Why This Exists](#1-why-this-exists)
2. [The Sync Marker](#2-the-sync-marker)
3. [Tracked Paths](#3-tracked-paths)
4. [Check Procedure](#4-check-procedure)
5. [Apply Procedure](#5-apply-procedure)
6. [When to Run This](#6-when-to-run-this)
7. [Version History](#version-history)

---

## 1. Why This Exists

A fork customises this template's domains, projects, and — over time — some of its system-layer files too (a fork's `ROUTING.md` grows real routing rows; `Architecture.md` sometimes gains fork-specific sections). Meanwhile the upstream template keeps evolving its own conventions. Nothing currently tells a fork *that* the upstream has moved, or *what* changed — the only way to find out has been an ad-hoc conversation re-deriving it from scratch each time.

This file defines a lightweight, repeatable way to check, and a careful way to apply what's found — without assuming the fork's copy of any given file still matches the upstream baseline it started from.

---

## 2. The Sync Marker

Each fork records its sync state in a **System Maintenance Pass** section of its own `projects/system/TODO.md`:

```
## System Maintenance Pass

**Upstream Template Sync**
- Upstream: https://github.com/sunshinezip/proto-context-architecture
- Last synced commit: <SHA>
- Last synced date: YYYY-MM-DD
```

This is the only state the mechanism depends on. It lives in the fork's own repo (not in any session's local environment) specifically because sessions here are ephemeral — nothing set up locally survives between them, so anything this depends on has to be committed.

---

## 3. Tracked Paths

Only these paths count as template content. A sync — check or apply — never touches anything else.

**Tracked:**
- `ROUTING.md`
- `Architecture.md`
- `MarkdownConventions.md`
- `README.md`
- `.github/copilot-instructions.md`
- `knowledge/domains/authoring-guidelines.md`
- `knowledge/flow/*`
- `scripts/*`
- `.claude/*`
- `.githooks/*`

**Never touched by a sync** (fork-owned content):
- `knowledge/domains/[name]/*` (every domain's own knowledge)
- `knowledge/domains/index.md` (the fork's own domain registry)
- `projects/[name]/*` except `_template` (every project's own work)
- `library/*` (the fork's own deep-well registry and files)

`README.md` and `Architecture.md` are the two most likely to need real adaptation rather than a clean apply — both routinely carry fork-specific narrative (a fork's `README.md` describes its own purpose; `familien-boe`'s `Architecture.md` has its own §4 the upstream copy doesn't). Expect to hand-fit those two; expect `ROUTING.md`, `authoring-guidelines.md`, `MarkdownConventions.md`, and `scripts/validate.ps1` to apply more often cleanly, but confirm rather than assume for all of them — see §5.

---

## 4. Check Procedure

Read-only. Produces a report; changes nothing.

1. Read the fork's own sync marker (§2) for the last-synced commit SHA.
2. Query the upstream repo (`sunshinezip/proto-context-architecture`) for commits since that SHA — via the GitHub tools available in-session (e.g. list commits, then inspect each one's changed files), not a local `git remote`, since nothing local persists between sessions here.
3. Filter to commits that touched at least one tracked path (§3). Discard the rest — a commit that only touched `knowledge/domains/example-domain/` or a project file is not template drift.
4. For each remaining commit, note which tracked files it touched and read the corresponding entry in upstream's own `projects/system/session-log.md` for the rationale — that log is the source of intent; this file does not duplicate it.
5. Report to the human: which tracked files have upstream changes since the last sync, and a one-line summary of each, sourced from the session-log entries found in step 4. Stop here. Do not proceed to §5 without explicit confirmation.

---

## 5. Apply Procedure

Only after a human has reviewed the check's findings and said to proceed. This is system-layer work — Plan-first rule applies, same as any other structural change.

1. For each affected tracked file, fetch **the fork's actual current content** and diff it against the pre-change upstream version (not against assumptions about what the fork "should" contain — a fork's copy may have already diverged, as `familien-boe`'s `Architecture.md` had by the time `sources`/`library` support was ported to it).
2. Where the fork's copy is unchanged from the upstream baseline, the upstream diff applies directly.
3. Where the fork's copy has diverged, hand-fit the same conceptual change into the fork's actual current text — do not overwrite fork-specific content to force a clean apply.
4. Enumerate the fork's real folders (`knowledge/domains/*`, `projects/*`) programmatically when a change needs retrofitting across many files, rather than relying on memory of what exists — the fork has very likely grown since it was last checked.
5. Run `scripts/validate.ps1` locally against the modified state before pushing.
6. Push, then re-verify against a fresh clone.
7. Log the sync as its own turn in the fork's `projects/system/session-log.md`, and update the sync marker (§2) to the new last-synced commit SHA and today's date.

---

## 6. When to Run This

Opportunistically, not on a schedule — the same discipline as the domain-level Maintenance Pass (`knowledge/domains/authoring-guidelines.md` §8): "on request, or when things have visibly diverged," not a recurring automated job. A session working in the System project with spare capacity, or asked to "tidy up," should glance at the sync marker in `projects/system/TODO.md` and run the check (§4) if it looks stale. See that file's own maintenance note for exactly where this is surfaced.

---

## Version History

| Version | Date | Summary |
|---|---|---|
| 1.0 | 2026-07-24 | Initial creation. Defines the sync marker, tracked paths, check procedure, and apply procedure for bringing a fork's system-layer files up to date with `proto-context-architecture`. Deliberately opportunistic rather than scheduled — no recurring trigger, surfaced instead via `projects/system/TODO.md`'s System Maintenance Pass section. |
| 1.1 | 2026-07-25 | Added `.githooks/*` to the Tracked Paths list — the new `.githooks/pre-commit` hook (`scripts/pre-commit-check.ps1`) is a system-layer file like the others. |
