# External Review

Version 1.0 | 2026-08-22 | Production

---

## Document Purpose

How a fork tracks findings that need confirmation from a specific named external party — a source, a subject-matter expert, a client, a co-researcher — before being treated as settled, when that party is not the session's own user. Relevant only to a fork whose work is conducted on behalf of, or draws its authority from, someone other than whoever runs the day-to-day sessions.

---

> **Routing check:** This file governs a specific flag's mechanics, not routine work. Load it when a `[FLAG FOR EXTERNAL REVIEW]` is raised or being resolved — see `knowledge/flow/operating-principles.md` §5.

> **Edit guard:** Changes to this file are system-layer work. Route to `projects/system/` and record the change in `session-log.md` before editing.

---

## Index

1. [Why This Exists](#1-why-this-exists)
2. [The Queue and Log Files](#2-the-queue-and-log-files)
3. [Escalation: Not Every Anomaly Reaches the Queue](#3-escalation-not-every-anomaly-reaches-the-queue)
4. [Raising the Flag](#4-raising-the-flag)
5. [Restricted-Tier Counterpart](#5-restricted-tier-counterpart)
6. [Version History](#version-history)

---

## 1. Why This Exists

This template's other flags (`operating-principles.md` §5) all assume the confirming authority is the session's own user — approve a knowledge correction, approve a system change, decide whether to relay an upstream finding. Some forks are built differently: they digest one specific party's material — interviews, source documents, correspondence — on behalf of a different day-to-day user. A genealogy project representing a family's primary source and final authority on its own history is one example; a project conducted on behalf of a client, or research assembled at the direction of a subject-matter expert who isn't at the keyboard, are others. For those forks, a class of finding exists that neither the session's user nor the LLM can settle — only that named party can.

This section previously had no base version at all, even though `knowledge/flow/restricted-tier.md` §9 already assumed one existed ("if the fork has a mechanism for flagging open questions..."). Found and reported by a fork that needed it for real.

---

## 2. The Queue and Log Files

Two files per project that needs this, living in that project's own `context/` folder (`projects/[name]/context/`) — not a new top-level structure:

- **`external-review-queue.md`** — open items only: proposed connections, discoveries, or inconsistencies not yet confirmed by the named party.
- **`external-review-log.md`** — where an entry moves once the party answers, preserving the confirmed (or rejected) outcome. The queue never accumulates resolved items; closing the loop means moving the entry, not marking it done in place.

Entry shape, adapt fields to the fork's own subject matter:

```
### [Short title]

Category: [what kind of finding this is]
Source: [where this came from — project, turn, document]
Finding: [what's being proposed or questioned]
Grounds: [what supports this, and how confident]
Status: Open
```

When the party answers, cut the entry from the queue and paste it into the log with the outcome appended (`Status: Confirmed` / `Status: Rejected`, plus what they actually said) — the same append-don't-edit spirit as `session-log.md`, applied to a smaller file.

---

## 3. Escalation: Not Every Anomaly Reaches the Queue

A named external authority is a scarce, high-value resource. Flooding them with every low-confidence anomaly trains them to stop reading the queue at all. Before an item reaches `external-review-queue.md`, track it in a lighter side file first — name it for what it tracks (a `possible-duplicates.md` for a genealogy fork, a `flagged-anomalies.md` generically) — and only promote it to the real queue once a real pattern emerges, not on first occurrence.

What counts as "a real pattern" is a judgment call for the fork to set for itself — one fork's bar might be three independent instances of the same shape; another's might be different, or might depend on what's actually at stake in a given finding. The discipline that matters is having an explicit bar at all, stated somewhere a session can find it (this project's own `context/` notes, or this file if the fork wants one bar system-wide), not the specific number.

---

## 4. Raising the Flag

Same mechanism as any other flag in this template (`operating-principles.md` §5): surface the candidate as a one-line question in a CHECKPOINT turn, wait for human confirmation, only then write the full `[FLAG FOR EXTERNAL REVIEW]` block and append the entry to `external-review-queue.md`.

The human running the session is not the one who resolves this flag — confirming it is worth adding to the queue at all is a different decision from confirming the finding itself. The named external party is the one who eventually resolves it, on whatever cadence the fork actually gets their input.

---

## 5. Restricted-Tier Counterpart

A fork that has also adopted the restricted-tier pattern (`knowledge/flow/restricted-tier.md`) needs a second copy of `external-review-queue.md` / `external-review-log.md` inside the companion repo, for questions too sensitive to even pose publicly. Same file, same format, referenced from the public queue rather than merged into it, so the public queue stays a complete, publicly-safe list of everything else pending review. See `restricted-tier.md` §9.

---

## Version History

| Version | Date | Summary |
|---|---|---|
| 1.0 | 2026-08-22 | Initial creation. Generalized from a working implementation (`grandfather-review/queue.md`) in a genealogy-research fork, relayed via `[FLAG FOR UPSTREAM]`. Defines the queue/log file pattern, the escalation discipline for what's even worth raising, the flag-raising procedure, and the restricted-tier counterpart. See `projects/system/session-log.md` Turn 26. |
