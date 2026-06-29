# Routing Rules

Version 1.0 | 2026-06-29 | Production

---

## Document Purpose

Defines the routing logic used after each session turn. An operational reference: how status signals, blockers, approvals, and project templates determine what happens next.

---

> **Routing check:** This file describes how turns are routed once work is underway. If you have not completed ROUTING.md routing and received explicit human confirmation to begin work, stop and do that first.

---

## Routing Inputs

For every routing decision, evaluate:

1. Current project type and phase template
2. Last turn author and STATUS signal
3. Open blockers, unresolved flags, and outstanding human asks
4. Explicit human override instructions
5. Any required approval gates

---

## Priority Order

Apply rules top-down. First match wins.

1. Human override rule
2. Hard blocker rule
3. Approval-gate rule
4. Explicit rework rule
5. Signal-driven default phase progression
6. Safe fallback

---

## Core Rules

### 1. Human override rule

If a human turn explicitly says what should happen next, follow that instruction unless it violates a hard constraint defined in ROUTING.md.

### 2. Hard blocker rule

If a turn ends with `STATUS: BLOCKED`, route to the `Suggested contact` when present; otherwise route to `HUMAN`.

If the BLOCKED signal is missing required fields (`Reason`, `Need`, `Suggested contact`), request a corrected turn before proceeding.

### 3. Approval-gate rule

If the workflow requires human approval (knowledge promotion, design gates, release acceptance), emit `STATUS: WAITING FOR HUMAN: [reason]` and do not advance until approval is recorded.

### 4. Explicit rework rule

If a valid `STATUS: RETURN TO PHASE [N]` appears, route to the owner of that phase in the project template and annotate required rework scope.

### 5. Signal-driven progression rule

If no higher-priority rule applies, route based on the project type template and its signal chain. See `knowledge/flow/project-types.md` for template details.

### 6. Safe fallback rule

If no route can be inferred safely, pause with `STATUS: WAITING FOR HUMAN: routing ambiguity` and list the missing information.

---

## Universal Signal Map

These signals apply across all project types and always resolve the same way.

| Signal | Route to |
|---|---|
| `STATUS: BLOCKED` | Suggested contact, or HUMAN if absent |
| `STATUS: WAITING FOR HUMAN: [reason]` | HUMAN |
| `STATUS: FLAG RAISED` | HUMAN (knowledge promotion review) |
| `STATUS: CHECKPOINT` | HUMAN (acknowledge and confirm next phase) |
| `STATUS: PROJECT COMPLETE` | HUMAN (final review and close) |
| `STATUS: COMPLETE, SYSTEM FLAGS PENDING` | Append handoff turn to system project session-log, then HUMAN |

---

## Project-Specific Signal Maps

Add phase signal chains here as your instance adds structured project types. See `knowledge/flow/project-types.md` for the phase templates those chains correspond to.

---

## Version History

| Version | Date | Summary |
|---|---|---|
| 1.0 | 2026-06-29 | Initial creation. Generic routing rules adapted from NightCrew routing-rules.md, migration signal map removed. |
