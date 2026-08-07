# Git Collaboration

Version 1.0 | 2026-07-25 | Production

---

## Document Purpose

How a session avoids and safely resolves collisions with another session or human working concurrently on the same fork. Applies whenever more than one person may be pushing to the same repository — a household with more than one member, a team, or any instance where sessions run independently rather than one at a time.

> **Routing check:** This file governs push behaviour, not routine work. Follow it on every push, not only after a rejection — most collisions resolve invisibly if caught early, which is the point.

> **Edit guard:** Changes to this file are system-layer work. Route to `projects/system/` and record the change in `session-log.md` before editing.

---

## Index

1. [Why This Exists](#1-why-this-exists)
2. [Fetch Before Every Push](#2-fetch-before-every-push)
3. [Integrating Remote Changes](#3-integrating-remote-changes)
4. [Resolution by File Type](#4-resolution-by-file-type)
5. [Never Force-Push Automatically](#5-never-force-push-automatically)
6. [Version History](#version-history)

---

## 1. Why This Exists

This template's default workflow — direct to `main`, commit and push almost every increment (`ROUTING.md` Standing Rules) — assumes a single writer unless told otherwise. The moment a second person works against the same fork, two things make collisions more likely than in an ordinary shared repo, not less:

- Sessions here often start from a fresh clone rather than a long-lived local checkout, so there's no natural "pull before I start" moment unless something instructs it.
- `session-log.md` turns are append-only *and* sequentially numbered. Two sessions starting from the same base and each appending the next turn number is a realistic, not hypothetical, collision. Appending at the same point in a file is exactly the case git's merge does flag as a conflict (verified directly — see §3), so this usually surfaces as a rebase conflict rather than slipping through silently. Still never resolve it by hand-editing conflict markers — §4 gives the actual procedure.

The goal is that the humans involved almost never see any of this. Catching drift early (§2) means most real collisions — different people, different projects, most of the time — resolve silently.

---

## 2. Fetch Before Every Push

Before pushing, fetch `origin` and check whether the local branch is behind. Do this on every push attempt, proactively — not only after a rejection.

- **Not behind:** push normally.
- **Behind:** do not push directly. Integrate first — see §3.

This applies regardless of whether the push happens via `scripts/commit-push.ps1` or directly through `git`.

---

## 3. Integrating Remote Changes

1. Rebase the local commit(s) onto `origin/<branch>`.
2. **If the rebase completes with no conflicts:** do not assume the result is correct just because git didn't flag anything. Re-run `scripts/validate.ps1` before pushing anyway. Two edits to different files, or non-adjacent sections of the same file, can merge with no git conflict at all and still leave something structurally inconsistent — this is `validate.ps1`'s job to catch, not git's. (Two sessions colliding on the exact same append point, like a session-log turn — see §4 — is more likely to surface as an actual rebase conflict than to merge silently; re-validating here is a backstop for the cases that don't.) If it reports a turn-numbering or Version History mismatch, follow §4's append-only resolution, then re-validate before pushing.
3. **If the rebase conflicts:** abort it (`git rebase --abort`) and return the working tree to a clean state. Never resolve by hand-editing conflict markers. Identify which files conflicted and apply §4.

---

## 4. Resolution by File Type

### Append-only files (`session-log.md`, any `## Version History` table)

Never resolve these via git conflict markers, even if git offers to let you. After aborting (§3) and re-fetching:

1. Re-read the file as it now actually exists on the remote.
2. Re-append your own new turn(s) or row(s) fresh, renumbered to follow whatever is now actually latest.
3. Re-validate, then push.

This is a rewrite of your own pending addition against the current state, not a merge of two versions of the same line — there's nothing to reconcile, just a number to correct.

### Ordinary content (a real edit collision on the same fact or section)

This is the hard case: two people genuinely changed the same thing. Do not silently prefer either side.

- If the two edits are compatible (additive, not contradictory), merge them by hand, re-validate, and proceed.
- If they genuinely disagree, this is the same kind of event as a knowledge contradiction discovered any other way — route it through the existing correction discipline (`knowledge/domains/authoring-guidelines.md` §4, `[CONTRADICTS: source]`) rather than inventing a separate process. Surface the disagreement to the human plainly; do not resolve it unilaterally.

---

## 5. Never Force-Push Automatically

`git push --force`, including `--force-with-lease`, requires the same explicit, separately-confirmed human authorisation as retiring or deleting content (`ROUTING.md` Hard Constraints). It overwrites another session's real work. Never use it to make a rejected push succeed without that confirmation — a rejected push is a signal to integrate (§3), not an obstacle to push through.

---

## Version History

| Version | Date | Summary |
|---|---|---|
| 1.0 | 2026-07-25 | Initial creation. Defines fetch-before-push discipline, rebase-and-revalidate integration, append-only vs. ordinary-content conflict resolution (reusing the existing turn-numbering check and `[CONTRADICTS]` correction discipline rather than new machinery), and the force-push Hard Constraint. |
