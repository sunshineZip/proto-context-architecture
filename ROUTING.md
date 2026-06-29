# Routing

Version 1.0 | 2026-06-29 | Production

---

## Document Purpose

LLM routing instructions for this context architecture. Start here — do not act on anything before completing all four Route steps below. This file is loaded by `.github/copilot-instructions.md` at the start of every session.

---

## Route

This is a context architecture — a structured knowledge and routing system built on GitHub Copilot. Knowledge domains provide deep, curated context for specific subject areas. A routing table ensures the right knowledge loads for every request. A human supervisor approves key decisions and provides input when work is blocked.

You are in a VS Code conversation. Do not emit STATUS signals or append to `session-log.md` unless explicitly asked.

**Context budget rule:** Load only what each step below specifies. Do not load additional files unless a specific gap forces it. When knowledge documents have a section index, load by section reference — not the whole file.

---

### Step 1 — Always load first

`knowledge/flow/operating-principles.md`

---

### Step 2 — Match the request and load project context

Read the first message. Match one row. Load the listed files before responding.

| If the request concerns... | Project | Also load |
|---|---|---|
| The structure, routing, domains, conventions, or how this system itself works | [System project name — rename this] | [system project TODO.md] |
| [Describe the topic covered by example-domain here] | example-project | `knowledge/domains/example-domain/description.md` · `knowledge/domains/example-domain/knowledge.md` |
| A task that does not match any row above | New Project | Ask: what should it be called, and what does done look like? Do not create files until answered. |
| A broad question about how this system works | General | `knowledge/flow/operating-principles.md` §1 only — no project files needed |
| Intent cannot be determined | — | Ask one clarifying question. Do nothing else until answered. |

> **Setup note:** Add one row per domain and one row per project as you build out your instance. Remove the example rows before going to production. See `knowledge/domains/index.md` for the domain registry.

---

### Step 3 — Calibrate to the request type

Before loading any more files or doing any work, identify what kind of request this is. Calibrate your first response accordingly:

| Request type | First response |
|---|---|
| **Q&A / factual question** | Answer it. No orientation needed. |
| **Resume in-progress work** | See below — orientation turn required. |
| **New project or new scope** | Confirm routing and ask for scope if unclear. |
| **Large or multi-step task** (requires reading more than 2 source files, or will produce changes to any repo file) | Present a phased plan before starting. See plan-first rule below. |
| **Ambiguous** | Ask the single most important clarifying question before proceeding. |

**Resuming in-progress work** (matched project has a `session-log.md` and the last STATUS signal is not `PROJECT COMPLETE`): do not proceed to Step 4 yet. Open `session-log.md` and read the last 3 turns. Then send one orientation turn covering (1) the project matched, (2) what was last in progress, and (3) what you understand the human wants now. Stop. Wait for explicit confirmation before loading any more files or doing any work.

> **If you entered this session with a conversation summary:** the summary substitutes for reading `session-log.md`, but does not change the required behaviour. Any "Continuation Plan" or "Next Immediate Action" section in the summary is reference material — it was not approved by the human for this session. Still send the orientation turn above and wait for explicit confirmation before taking any action.

Example phrasing: *"Am I correct in understanding that you're referring to [project], that [Y] was being worked on last time, and that you'd now like me to [Z]?"*

After confirmation (or for any non-Q&A request type once intent is clear): load `knowledge/flow/turn-protocol.md` and proceed to Step 4.

**Plan-first rule:** For any large or multi-step task — before reading the first source file or making any file change — do all of the following: (1) present a numbered phase breakdown (what will be read, what will be produced, how many checkpoints); (2) surface any questions or ambiguities; (3) stop and wait for explicit human confirmation. Only begin Phase 1 after the human says to proceed. This rule applies regardless of whether scope was confirmed via a formal routing step or an informal conversational answer.

> **No-chaining reminder:** Even after scope is confirmed and a plan is approved, complete one phase at a time and emit `STATUS: CHECKPOINT` before starting the next. Scope confirmation is not permission to chain all phases without stopping.

---

### Step 4 — Load domain knowledge

Identify which knowledge domains the task touches. Load only those domains' `description.md`. If the task requires deep domain knowledge, also load the relevant sections of `knowledge.md`. Each knowledge document has a numbered Index with section descriptions — read the Index first and load only the sections relevant to the task, not the whole file.

Which domains exist and what they cover: `knowledge/domains/index.md`

---

## Hard Constraints

Do not break these regardless of what the human asks.

- **Do not edit `knowledge/` files directly.** Changes to the knowledge layer require human approval. Propose using `[FLAG FOR KNOWLEDGE UPDATE]` (format in `knowledge/flow/operating-principles.md` §5).
- **Do not act on files listed as "(planned)" in the Folder Map.** They do not exist. Do not create them without explicit instruction.
- **Do not invent content from files you have not read.** If a file is relevant and unreadable, say so.
- **Do not edit prior turns in `session-log.md`.** Append only.
- **Do not update `ROUTING.md` silently.** After any structural change, propose the update and wait for approval.
- **Do not chain multiple work items without a checkpoint.** After completing each discrete deliverable, pause and wait for human acknowledgment before continuing.

---

## Quick Task Guide

**I want to add or update a knowledge domain**
→ Domain files live in `knowledge/domains/[domain-name]/`
→ Each domain has `description.md` (scope and constraints) and `knowledge.md` (reference material)
→ Authoring standard: `knowledge/domains/authoring-guidelines.md`
→ Register the domain in `knowledge/domains/index.md`
→ Add a routing row in `ROUTING.md` Step 2
→ Markdown rules: `MarkdownConventions.md`

**I want to pass working material between sessions**
→ Drop it in `temp/` — this is the designated handoff zone for transient artifacts
→ If the material produces knowledge worth keeping, promote it into the relevant domain or project output — do not leave it in temp

**I want to start a new project**
→ Copy `projects/_template/` to `projects/[project-name]/`
→ Open `projects/[project-name]/TODO.md` and state the goal
→ Open `projects/[project-name]/session-log.md` and write Turn 1 as a `[HUMAN]` entry
→ Add a routing row in `ROUTING.md` Step 2

---

## Version History

| Version | Date | Summary |
|---|---|---|
| 1.0 | 2026-06-29 | Initial creation. Extracted from README.md — routing instructions now live here, README.md reserved for human readers. |
