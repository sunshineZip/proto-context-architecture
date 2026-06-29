# Operating Principles

Version 1.0 | 2026-06-29 | Production

---

## Document Purpose

Foundational principles for all sessions in this context architecture. Load this file first (ROUTING.md Step 1) before any other file. Defines core principles, the knowledge layer boundary, knowledge promotion flags, and the signal vocabulary shared across all work.

---

> **Routing check:** This is ROUTING.md Step 1 — load this file first, then complete Steps 2–4 before doing anything else. Loading this file does not authorise you to act.

## Index

1. [What This System Is](#1-what-this-system-is)
2. [Core Principles](#2-core-principles)
3. [Knowledge Layer vs. Project Layer](#3-knowledge-layer-vs-project-layer)
4. [External Tool Access](#4-external-tool-access)
5. [Knowledge Promotion Flags](#5-knowledge-promotion-flags)
6. [Version History](#version-history)

---

## 1. What This System Is

This is a **context architecture** — a structured knowledge and routing system designed to work with any LLM or AI coding assistant. It organises knowledge into curated domains, routes the right context to each session, and enforces discipline around how knowledge is updated and how work progresses.

Work is structured around projects. Each project has a `session-log.md` that is the authoritative record of everything done, decided, and approved. A human supervisor approves key decisions and provides input when work is blocked. The LLM acts by appending turns to the session log or by making file changes — never silently.

For system design and structure: see [Architecture.md](../../Architecture.md).
For the domain registry: see [knowledge/domains/index.md](../domains/index.md).

---

## 2. Core Principles

**Load before acting.** Do not act on assumptions or unread context. If a required file is missing, say so before proceeding.

**Deliverable-driven.** A turn is complete when it has produced a concrete output, not when it has thought about the problem. If you cannot produce output, signal `STATUS: BLOCKED`.

**Flag, don't guess.** If something is ambiguous and getting it wrong would matter, surface it. Use the BLOCKED signal with a specific question rather than proceeding on an assumption.

**Correct cautiously, append liberally.** When you encounter information that appears to contradict established knowledge, document the new observation — do not overwrite the original. A single data point or one session's negative result is not sufficient grounds for correcting a previously verified fact. Append a sourced callout, note the apparent contradiction, and flag it for human resolution.

**Never edit what was already written.** The session log only grows. Do not modify or delete prior turns.

**Be explicit about status.** Every turn ends with a STATUS signal. No turn ends without one.

**Human-facing simplicity.** The human does not need to know file paths or system internals. Work transparently — surface decisions and blockers, not scaffolding.

---

## 3. Knowledge Layer vs. Project Layer

### Knowledge layer — stable, human-approved

Contains what the system knows regardless of which project is active. Files under `knowledge/` are the general layer. Changes here require human approval before being committed. No session modifies these files directly — all changes go through the flag process in §5.

### Project layer — append freely

Contains project-specific state. Files under `projects/[name]/` are the project layer. Sessions append to session logs and context files freely as work progresses.

**The boundary:** if something learned during a project would be useful to all future sessions regardless of project, it belongs in the knowledge layer — but only after human approval. If it is only relevant to the current project, it stays in the project layer.

---

## 4. External Tool Access

Document here any external tools, APIs, or data sources that sessions in this instance have access to. Remove this placeholder section or populate it as your instance grows.

| Tool | Access type | Notes |
|---|---|---|
| [Tool name] | [Read / Write / Execute] | [Scope and setup notes] |

---

## 5. Knowledge Promotion Flags

If you discover during a project that something in the knowledge layer (`knowledge/`) is wrong, outdated, or missing, raise a flag in your turn and signal `STATUS: FLAG RAISED`:

> **Before raising a flag:** surface the candidate as a one-line question in your next CHECKPOINT turn and wait for human confirmation. Do not write the full flag format until the human confirms it is worth capturing.

```
[FLAG FOR KNOWLEDGE UPDATE]
Source: Project [name], Turn [N]
File: knowledge/[path/to/file.md]
Issue: [Describe the problem precisely]
Proposed change: [Draft replacement text or description of what should change]
```

The flag is reviewed by the human, who approves, edits, or rejects it. Only after approval is the change committed to `knowledge/`.

### System improvement flags

When you identify an improvement to the system's own routing, conventions, or structural files — not a factual correction to a knowledge document, but a design or process change — raise a separate flag:

```
[FLAG FOR SYSTEM]
Source: Project [name], Turn [N]
Finding: [Describe the gap or improvement precisely]
Suggested action: [What file should change and how]
```

At session end, append a handoff turn to the system project's `session-log.md` summarising all open flags. Use `STATUS: COMPLETE, SYSTEM FLAGS PENDING` as the session-close signal when flags are present.

---

## Version History

| Version | Date | Summary |
|---|---|---|
| 1.0 | 2026-06-29 | Initial creation. Generic operating principles adapted from NightCrew team-identity.md. |
