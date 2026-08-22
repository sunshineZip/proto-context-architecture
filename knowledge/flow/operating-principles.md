# Operating Principles

Version 1.3 | 2026-08-22 | Production

---

## Document Purpose

Foundational principles for all sessions in this context architecture. Load this file first (ROUTING.md Step 1) before any other file. Defines core principles, the knowledge layer boundary, knowledge promotion flags, and the signal vocabulary shared across all work.

---

> **Routing check:** This is ROUTING.md Step 1 — load this file first, then complete Steps 2–4 before doing anything else. Loading this file does not authorise you to act.

> **Edit guard:** Changes to this file are system-layer work. Route to `projects/system/` and record the change in `session-log.md` before editing.

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

**Correct cautiously, append liberally.** When you encounter information that appears to contradict established knowledge, document the new observation — do not overwrite the original. A single data point, one failed test, or one session's negative result is not sufficient grounds for correcting a previously verified fact. Append a sourced callout, note the apparent contradiction, and raise a `[FLAG FOR KNOWLEDGE UPDATE]` for human resolution.

Before proposing any correction: read the full surrounding section — not just the sentence that appears wrong. A correction made without that context often introduces new errors. The asymmetry is intentional: filing a flag and waiting costs little; recovering from a premature rewrite that propagates through future sessions costs a lot.

**Never edit what was already written.** The session log only grows. Do not modify or delete prior turns.

**Be explicit about status.** Every turn ends with a STATUS signal. No turn ends without one.

**Human-facing simplicity.** The human does not need to know file paths, routing steps, or system internals. STATUS signals, FLAG formats, turn structure, routing decisions, and session log mechanics are internal machinery — never surface these as requirements or explanations to the human. Translate everything into plain language: say "I found something worth saving for future sessions — shall I flag it for review?" not "I am raising a `[FLAG FOR KNOWLEDGE UPDATE]`". The human's job is to answer questions and provide direction, not to operate the system.

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

**When processing correspondence** (emails, messages, documents) from a person or organization already covered by a domain — or clearly belonging in one — also watch for behavioral and argumentative-style signals worth flagging (see `authoring-guidelines.md` §4, Behavioral and communication-style notes), not just the logistical content. The same flag-and-confirm process applies; nothing about this content type is captured automatically.

### System improvement flags

When you identify an improvement to the system's own routing, conventions, or structural files — not a factual correction to a knowledge document, but a design or process change — raise a separate flag:

```
[FLAG FOR SYSTEM]
Source: Project [name], Turn [N]
Finding: [Describe the gap or improvement precisely]
Suggested action: [What file should change and how]
```

At session end, append a handoff turn to the system project's `session-log.md` summarising all open flags. Use `STATUS: COMPLETE, SYSTEM FLAGS PENDING` as the session-close signal when flags are present.

### Upstream feedback flags

When a finding is a property of the template itself — something any fork built the same way would hit, not a mistake specific to this fork's own customization — it doesn't get fixed here and it doesn't get written into the upstream template repo either, even if this session happens to have repo access to it. Raise a separate flag instead:

```
[FLAG FOR UPSTREAM]
Source: Project [name], Turn [N]
Finding: [Describe the template-level gap or bug precisely, and why it isn't fork-specific]
Proposed prompt: [Self-contained text, ready to hand to a session working in the
upstream repo with no memory of this conversation — what fork this came from and
why, the finding, a concrete proposed fix if one exists, and explicit instructions
for what that session should do]
```

Same confirm-before-writing gate as above: surface it as a one-line question first, write the full flag only once the human confirms it's worth capturing. Once confirmed, append the entry to `projects/system/TODO.md`'s Upstream Feedback Log — see `knowledge/flow/upstream-sync.md` §7 for the log format and lifecycle.

**This fork never writes the finding directly into the upstream repo, regardless of whether repo access is available in-session.** The human decides if and when to relay it — the same review a human-submitted finding would get applies equally to one this session identified itself.

### External review flags

When a finding needs confirmation from someone who isn't the session's own user — a source, a subject-matter expert, a client, a co-researcher the fork's work draws its authority from or is conducted on behalf of — it isn't a knowledge-layer correction, a system improvement, or a template-level finding. The party who has to confirm it is a specific named person, not whoever happens to be running the session. Raise a separate flag:

```
[FLAG FOR EXTERNAL REVIEW]
Source: Project [name], Turn [N]
Party: [Who must confirm this, and why they are the authority — not the session's own user]
Finding: [What needs their confirmation, precisely]
Grounds: [What supports this, and how confident]
```

Same confirm-before-writing gate as above. Once confirmed, log it per `knowledge/flow/external-review.md` — a queue/log pattern distinct from the flags above, since the party being asked to confirm it is someone else entirely, not the human running this session. That file also covers the escalation discipline for deciding when a low-confidence anomaly is even worth raising as a flag in the first place, rather than every one reaching the named party.

---

## Version History

| Version | Date | Summary |
|---|---|---|
| 1.0 | 2026-06-29 | Initial creation. Generic operating principles adapted from NightCrew team-identity.md. |
| 1.1 | 2026-07-25 | §5 gained a note to actively watch for behavioral/argumentative-style signal when processing correspondence from a party already covered by a domain, not just the logistical content — same flag-and-confirm gate, no automatic capture. See `knowledge/domains/authoring-guidelines.md` §4 (Behavioral and communication-style notes). |
| 1.2 | 2026-08-11 | §5 gained "Upstream feedback flags" — a third flag type, `[FLAG FOR UPSTREAM]`, for template-level findings a fork identifies in itself. Explicitly never written directly to the upstream repo even when access is available; logged locally in `projects/system/TODO.md` for the human to relay. See `knowledge/flow/upstream-sync.md` §7 and `projects/system/session-log.md` Turn 20. |
| 1.3 | 2026-08-22 | §5 gained "External review flags" — a fourth flag type, `[FLAG FOR EXTERNAL REVIEW]`, for findings that need confirmation from a specific named party who isn't the session's own user. Relayed via `[FLAG FOR UPSTREAM]` from a fork (`kej-context-architecture`) whose work is conducted on behalf of exactly such a party. See new `knowledge/flow/external-review.md` and `projects/system/session-log.md` Turn 26. |
