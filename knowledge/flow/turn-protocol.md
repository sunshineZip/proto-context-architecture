# Turn Protocol

Version 1.3 | 2026-09-10 | Production

---

## Document Purpose

Defines the structured turn format, STATUS signal vocabulary, and BLOCKED signal format used when appending turns to a project's `session-log.md`.

**Load this file when:** you are resuming in-progress work and will be appending a turn, or when working through a structured project phase.

---

> **Routing check:** This file defines turn format for work that has already been approved. If you have not completed ROUTING.md routing and received explicit human confirmation to proceed, stop and do that first.

> **Edit guard:** Changes to this file are system-layer work. Route to `projects/system/` and record the change in `session-log.md` before editing.

---

## Index

1. [Turn Format](#1-turn-format)
2. [Status Signals](#2-status-signals)
3. [BLOCKED Signal Format](#3-blocked-signal-format)
4. [CHECKPOINT Format](#4-checkpoint-format)
5. [PROJECT COMPLETE Convention](#5-project-complete-convention)
6. [Version History](#version-history)

---

## 1. Turn Format

Every turn in `session-log.md` uses this exact format:

```
## [Role or Name] — Turn N | YYYY-MM-DD

[Content — analysis, decisions, output, questions]

STATUS: [signal]
```

Human turns use the same structure:

```
## [HUMAN] — Turn N | YYYY-MM-DD

[Approval, clarification, input, or routing override]
```

Rules:
- Turn numbers are sequential and never reused.
- Append only — never edit a prior turn.
- Always end with a STATUS signal on its own line.

### If you miscount

It will happen. A session appending turns by hand eventually numbers one wrong, and the two rules above then close every route back: renumbering the turn would edit a prior turn, and append-only holds even against a direct human request to fix it. So there is no compliant repair. Knowing that in advance is the point of this subsection — a session discovering it mid-incident otherwise has to derive it from two separate rules while under pressure to "just fix it", and then invent a response.

What to do depends on which mistake it was, and they are not equally serious.

**A skipped number** — Turn 79 written where 78 was next. Nothing is actually lost: no turn is missing, and every reference still resolves to exactly one turn. If it is not yet committed, correct it. If it is, the gap is permanent and that is acceptable. Say so in your next turn, in one line — "Turn 78 was skipped by a miscount; numbering continues from 79" — keep counting forward, and never reuse the skipped number. `scripts/validate.ps1` reports this as a warning, deliberately: an uncorrectable finding that stayed an error would sit red forever and teach a reader to ignore errors generally.

**A reused or out-of-order number** — two turns numbered 79, or 78 appended after 79. This one does real damage: every later reference to "Turn 79" becomes ambiguous, and the never-reused guarantee is what stops two concurrent sessions colliding. Fix it before committing. `scripts/validate.ps1` reports it as an error for that reason. If it has already been committed, stop and raise it with the human rather than resolving it alone — the options all involve trade-offs against the append-only rule, and that is not a session's call to make.

The same reasoning applies to any defect sealed into a committed turn, such as a missing STATUS line: it cannot be repaired in place, so note it in the next turn and carry on. Do not silently rewrite history to make a check pass.

---

## 2. Status Signals

Every turn ends with exactly one STATUS signal. Use the exact phrasing below.

### Universal signals (all project types)

| Signal | Meaning | When used |
|---|---|---|
| `STATUS: BLOCKED` | Cannot proceed — see §3 | Any turn where work cannot continue |
| `STATUS: WAITING FOR HUMAN: [reason]` | Project paused pending human input | When human decision or input is required |
| `STATUS: FLAG RAISED` | Knowledge-layer update proposed — see `operating-principles.md` §5 | When a knowledge update is ready for human review |
| `STATUS: CHECKPOINT` | Discrete work item complete — see §4 | After each phase deliverable |
| `STATUS: PROJECT COMPLETE` | All phases done, deliverables confirmed | Project closeout |
| `STATUS: COMPLETE, SYSTEM FLAGS PENDING` | Project work done but system improvement flags raised — append handoff turn to system project session-log before closing | When `[FLAG FOR SYSTEM]` was raised during the session |

### Project-specific signals

Add project-type-specific phase signals here as your instance grows. See `knowledge/flow/project-types.md` for phase templates and their default signal chains.

---

## 3. BLOCKED Signal Format

When you cannot proceed, use this exact format at the end of your turn:

```
STATUS: BLOCKED
Reason: [What is blocking you — be specific]
Need: [What information or action would unblock you]
Suggested contact: [Who or what can resolve this — human, domain, external source]
```

All three fields are required. A BLOCKED signal without `Need` and `Suggested contact` is incomplete and will be returned for correction.

---

## 4. CHECKPOINT Format

Use `STATUS: CHECKPOINT` after completing a discrete deliverable within a larger task. Include a brief summary of what was completed and what comes next:

```
STATUS: CHECKPOINT
Completed: [What was done in this turn]
Next: [What the next phase or action is]
Waiting for: [Human confirmation / specific input / nothing — proceed when ready]
Push status: [Pushed / Pending — will push after [reason for deferring]]
```

Do not chain into the next phase without human acknowledgment after a CHECKPOINT.

Nearly every file change in this repository should be pushed (see `ROUTING.md` Standing Rules) — push after each increment, or at minimum after finishing a segment of work, using judgement on which cadence fits the session. If `Push status` is `Pending`, say so plainly to the human in the turn itself as well — do not rely on the human reading this field. The human may end the session before the next turn, so an unflagged pending push is a silent risk of lost work.

---

## 5. PROJECT COMPLETE Convention

Before emitting `STATUS: PROJECT COMPLETE`, include a closing section in the final turn:

```
### Session close

Knowledge candidates: [facts, patterns, or corrections surfaced this session that may warrant a FLAG — or "None identified"]
Open flags: [any unresolved [FLAG FOR KNOWLEDGE UPDATE] or [FLAG FOR SYSTEM] items — or "None"]
Push status: [Pushed — all changes committed and pushed / N/A, no file changes this session]
```

If knowledge candidates exist, raise `[FLAG FOR KNOWLEDGE UPDATE]` items and emit `STATUS: FLAG RAISED` before closing. Do not emit `STATUS: PROJECT COMPLETE` while flags are unresolved.

All file changes must be committed and pushed (`.\scripts\commit-push.ps1`) before emitting `STATUS: PROJECT COMPLETE` — a project is not complete while local changes are unpushed.

If only system-level findings exist, emit `STATUS: COMPLETE, SYSTEM FLAGS PENDING` and append a handoff turn to `projects/system/session-log.md`.

---

## Version History

| Version | Date | Summary |
|---|---|---|
| 1.0 | 2026-06-29 | Initial creation. Generic turn protocol adapted from NightCrew agent-turn-protocol.md, migration signals removed. |
| 1.1 | 2026-07-15 | Added a `Push status` field to the CHECKPOINT (§4) and Session close/PROJECT COMPLETE (§5) formats, and made explicit that a project cannot be marked complete with unpushed changes. |
| 1.2 | 2026-09-09 | Added the `## Index` section `MarkdownConventions.md` §3 requires of any document longer than four sections — this file has seven and had never had one. Found by auditing the template against its own conventions rather than by `scripts/validate.ps1`, whose Index check skips any file with no Index at all and so could not have caught this. See `projects/system/session-log.md` Turn 34. |
| 1.3 | 2026-09-10 | §1 gained "If you miscount" — a recovery convention for a turn-numbering slip, which the sequential-numbering rule and the append-only rule together made unrepairable with nothing anywhere saying what to do instead. A fork hit this for real and had to improvise. A skipped number is now accepted and warned about; a reused one stays an error, because only the second breaks the guarantee that does the work. See `scripts/validate.ps1` and `projects/system/session-log.md` Turn 46. |
