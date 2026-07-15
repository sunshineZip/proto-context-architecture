# Routing

Version 1.0 | 2026-06-29 | Production

---

## Document Purpose

LLM routing instructions for this context architecture. Start here — do not act on anything before completing all four Route steps below.

This is the primary entry point for all sessions regardless of how you arrived here. In VS Code with GitHub Copilot, this file loads automatically via `.github/copilot-instructions.md`. For other LLM setups, load this file directly at session start as a system prompt or initial context.

---

## Route

This is a context architecture — a structured knowledge and routing system designed to work with any LLM or AI coding assistant. Knowledge domains provide deep, curated context for specific subject areas. A routing table ensures the right knowledge loads for every request. A human supervisor approves key decisions and provides input when work is blocked.

Do not emit STATUS signals or append to `session-log.md` unless explicitly asked.

**Context budget rule:** Load only what each step below specifies. Do not load additional files unless a specific gap forces it. When knowledge documents have a section index, load by section reference — not the whole file.

---

### Step 1 — Always load first

`knowledge/flow/operating-principles.md`

---

### Step 2 — Match the request and load project context

Read the first message. Match one row. Load the listed files before responding.

| If the request concerns... | Project | Also load |
|---|---|---|
| Changes to or questions about the context architecture itself — adding domains, modifying routing or protocols, structural improvements, or any work that changes how this system operates | System | `projects/system/TODO.md` |
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

Identify which knowledge domains the task touches. Apply this loading hierarchy — each level is a gate, not a default progression. Stop at the earliest level that satisfies the task.

1. **`description.md` only** — does this domain actually apply? Can the task be answered from the scope description alone? If yes, stop here.
2. **Index only** — scan section titles and descriptions. Identify which sections are relevant. For broad questions, the Index and Executive Summary together are often sufficient.
3. **Executive Summary** — load when domain context is needed but full section detail is not required.
4. **Named sections** — load only the sections whose Index descriptions match the task. Name them explicitly before loading; do not load adjacent sections speculatively.
5. **Full file** — last resort only, when multiple sections are deeply interdependent and cannot be understood in isolation.

When multiple domains are relevant, apply the hierarchy independently for each. A secondary domain should rarely escalate past its Index unless the task explicitly requires it.

For a recurring multi-domain task, check `knowledge/domains/index.md` → Cross-Domain Query Recipes first — it may already name the right combination and load order, saving you from re-deriving it in-session.

Which domains exist and what they cover: `knowledge/domains/index.md`

---

## Hard Constraints

Do not break these regardless of what the human asks.

- **Do not edit `knowledge/` files directly.** Changes to the knowledge layer require human approval. Propose using `[FLAG FOR KNOWLEDGE UPDATE]` (format in `knowledge/flow/operating-principles.md` §5).
- **Do not act on files listed as "(planned)" in the Folder Map.** They do not exist. Do not create them without explicit instruction.
- **Do not invent content from files you have not read.** If a file is relevant and unreadable, say so.
- **Do not edit prior turns in `session-log.md`.** Append only.
- **Do not start substantive work in `temp/`.** The `temp/` folder is for transient handoff artifacts only — short-lived files passed between tools or sessions. Analysis, discoveries, deliverables, and working notes belong in `projects/[name]/context/` and `projects/[name]/outputs/`. Work started in `temp/` bypasses routing and leaves no project record.
- **Do not update `ROUTING.md` silently.** After any structural change, propose the update and wait for approval.
- **Do not chain multiple work items without a checkpoint.** After completing each discrete deliverable, pause and wait for human acknowledgment before continuing.
- **Do not make structural system changes without logging them.** Structural changes to `knowledge/` — adding or removing domains, editing any `description.md`, editing any file under `knowledge/flow/` — and any edit to `ROUTING.md` or `Architecture.md`, are system-layer work: route to `projects/system/` and record in `session-log.md` before committing. Appending new facts to an existing domain `knowledge.md` uses the FLAG process in the first constraint above, not this one.

---

## Standing Rules

Apply these in every session regardless of project type or how you entered the session.

- **Load before acting.** Do not act on assumptions or unread context. If a required file is missing or unreadable, say so before proceeding.
- **Human-facing simplicity.** The human does not need to know file paths or system internals. Work transparently — surface decisions and blockers, not scaffolding.
- **Commit and push, almost always.** This is a personal working repo, not shared infrastructure with a review gate — nearly every file change should be pushed. Run `.\scripts\commit-push.ps1 "brief description of what changed"` after each discrete increment of work, or at minimum after finishing a segment of work — use judgement on which cadence fits the session. Do not interrupt a tightly-coupled sequence of edits just to push mid-sequence, and do not stockpile many unrelated changes unpushed either.
- **Never leave a push silently pending.** If you defer pushing until a segment finishes rather than after every increment, say so explicitly to the human before the turn ends — e.g. "changes are saved locally but not yet pushed." The human may end the session at any point; an unflagged pending push risks losing untracked work.

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
→ Ask the human: what should it be called, and what does done look like?
→ Copy `projects/_template/` to `projects/[project-name]/`
→ Write Turn 1 in `projects/[project-name]/session-log.md` from the human's description — the human does not need to format or write this
→ Update `projects/[project-name]/TODO.md` with the goal and any open items
→ Add a routing row in `ROUTING.md` Step 2
→ Confirm to the human in plain language that the project is open and ready

**This is a fresh fork with no domains or projects yet — where do I start?**

Follow this sequence. Do not create projects before domains exist — a project without domain knowledge loads nothing useful.

> **The system project (`projects/system/`) is pre-created.** Use it from day one to track all setup and structural work. Every step below should be recorded there.

1. **Identify your knowledge domains.** Ask the human: what are the distinct subject areas this initiative needs deep knowledge about? For a securities trading platform these might be: regulatory compliance, market data and feeds, order execution, risk management, platform infrastructure. Each becomes a domain.
2. **Create each domain.** Copy `knowledge/domains/example-domain/` to `knowledge/domains/[domain-name]/`. Fill in `description.md` (scope, what belongs here, constraints) and stub out `knowledge.md` (Index and Executive Summary — content can be built over time).
3. **Register each domain** in `knowledge/domains/index.md`.
4. **Update the routing table** in `ROUTING.md` Step 2 — add one row per domain and one row per initial project.
5. **Delete the example placeholders** — remove `knowledge/domains/example-domain/` and `projects/example-project/` once your real content exists.
6. **Create your first project** — copy `projects/_template/`, rename, write Turn 1 in `session-log.md` stating the project goal.
7. **Now start working** — routing will load the right domain knowledge for each session.

> Domain knowledge documents start thin and grow. A stub with an Executive Summary and a few key facts is enough to begin. The LLM will surface what is missing as it works.

---

## Version History

| Version | Date | Summary |
|---|---|---|
| 1.0 | 2026-06-29 | Initial creation. Extracted from README.md — routing instructions now live here, README.md reserved for human readers. |
| 1.1 | 2026-06-29 | Added first-time setup workflow to Quick Task Guide — covers domain-first initialization sequence for fresh forks. |
| 1.2 | 2026-07-15 | Expanded the Commit and push standing rule with cadence guidance (per-increment vs per-segment) and an explicit requirement to flag the human when a push is deferred. |
| 1.3 | 2026-07-15 | Step 4 now points to the new Cross-Domain Query Recipes section in `knowledge/domains/index.md` for recurring multi-domain tasks. |
