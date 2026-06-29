# Turn Protocol

Version 1.0 | 2026-06-29 | Production

---

## Document Purpose

Defines the structured turn format, STATUS signal vocabulary, and BLOCKED signal format used when appending turns to a project's `session-log.md`.

**Load this file when:** you are resuming in-progress work and will be appending a turn, or when working through a structured project phase.

---

> **Routing check:** This file defines turn format for work that has already been approved. If you have not completed ROUTING.md routing and received explicit human confirmation to proceed, stop and do that first.

> **Edit guard:** Changes to this file are system-layer work. Route to `projects/system/` and record the change in `session-log.md` before editing.

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
```

Do not chain into the next phase without human acknowledgment after a CHECKPOINT.

---

## 5. PROJECT COMPLETE Convention

Before emitting `STATUS: PROJECT COMPLETE`, include a closing section in the final turn:

```
### Session close

Knowledge candidates: [facts, patterns, or corrections surfaced this session that may warrant a FLAG — or "None identified"]
Open flags: [any unresolved [FLAG FOR KNOWLEDGE UPDATE] or [FLAG FOR SYSTEM] items — or "None"]
```

If knowledge candidates exist, raise `[FLAG FOR KNOWLEDGE UPDATE]` items and emit `STATUS: FLAG RAISED` before closing. Do not emit `STATUS: PROJECT COMPLETE` while flags are unresolved.

If only system-level findings exist, emit `STATUS: COMPLETE, SYSTEM FLAGS PENDING` and append a handoff turn to `projects/system/session-log.md`.

---

## Version History

| Version | Date | Summary |
|---|---|---|
| 1.0 | 2026-06-29 | Initial creation. Generic turn protocol adapted from NightCrew agent-turn-protocol.md, migration signals removed. |
