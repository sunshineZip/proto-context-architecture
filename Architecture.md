# Context Architecture — System Design

Version 1.0 | 2026-06-29 | Production

---

## Document Purpose

Describes how a context architecture works: the session interface, the file and folder structure, the two-tier knowledge model, knowledge promotion, and dynamic routing. Read this when designing or changing how the system operates, or when setting up a new instance.

---

## Index

1. [The Session Interface](#1-the-session-interface)
2. [File Structure](#2-file-structure)
3. [Two-Tier Knowledge Model](#3-two-tier-knowledge-model)
4. [Dynamic Routing](#4-dynamic-routing)
5. [Subproject Transcendence](#5-subproject-transcendence)
6. [Setting Up a New Instance](#6-setting-up-a-new-instance)
7. [Version History](#version-history)

---

## 1. The Session Interface

Each project has a single `session-log.md` file that accumulates entries chronologically. This file is the project's authoritative record — what was done, decided, questioned, and approved.

There is no dedicated application. The interface is the file. Any text editor or VS Code serves equally.

### Entry format

```
## [Role or Name] — Turn N | YYYY-MM-DD

[Content — analysis, decisions, output, questions]

STATUS: [signal]
```

Human turns follow the same structure:

```
## [HUMAN] — Turn N | YYYY-MM-DD

[Approval, clarification, input, or routing override]
```

The session log only ever grows — no entries are deleted or edited after the fact.

---

## 2. File Structure

```
[repo-name]/
  README.md                           <- Human overview — what this is and how to set it up
  ROUTING.md                          <- LLM routing instructions — Steps 1-4
  Architecture.md                     ← This file
  MarkdownConventions.md              ← Baseline markdown rules for all files
  .github/
    copilot-instructions.md           ← VS Code entry point

  knowledge/                          ← Knowledge layer — human-approved changes only
    flow/
      operating-principles.md         ← Core principles, signals, knowledge promotion
      turn-protocol.md                ← Turn format and STATUS signals
      routing-rules.md                ← Routing logic reference
      project-types.md                ← Project type definitions and phase templates
    domains/
      index.md                        ← Domain registry
      authoring-guidelines.md         ← Standards for writing domain knowledge
      [domain-name]/
        description.md                ← Scope, constraints, when to load
        knowledge.md                  ← Domain reference material

  projects/                           ← One folder per project
    _template/
      session-log.md
      TODO.md
    [project-name]/
      session-log.md                  ← Turn-by-turn project record
      TODO.md                         ← Open items and done list
      context/                        ← Project-specific working notes
      outputs/                        ← Phase deliverables

  scripts/
    commit-push.ps1
    validate.ps1

  temp/                               ← .gitignored transient artifacts
```

---

## 3. Two-Tier Knowledge Model

### Knowledge layer — stable

Contains what the system knows regardless of which project is active. Changes to this layer require human approval before being committed.

- **`knowledge/flow/operating-principles.md`** — shared across all sessions: core principles, signal vocabulary, knowledge promotion procedure, and layer boundary rules.
- **`knowledge/flow/turn-protocol.md`** — turn format, STATUS signal vocabulary, BLOCKED format.
- **`knowledge/domains/[name]/description.md`** — domain scope, constraints, and load conditions.
- **`knowledge/domains/[name]/knowledge.md`** — domain reference material. Each has a numbered Index — entries name key concepts so a routing LLM can decide which sections to load without reading the whole file.

### Project layer — append freely

Contains project-specific state that accumulates during work. The LLM appends to these files as it works, without approval gates.

- **`session-log.md`** — the living project record: everything done, decided, and approved.
- **`context/[name].md`** — current working knowledge for this project: relevant background, phase outputs, open questions, and any corrections to knowledge-layer content discovered during the project.

### Knowledge promotion

When something discovered during a project should update the knowledge layer — a factual correction, a newly identified pattern, an outdated reference — the process is:

1. Document the discovery in the project's `context/` notes.
2. Raise a `[FLAG FOR KNOWLEDGE UPDATE]` (format in `knowledge/flow/operating-principles.md` §5).
3. The flag is reviewed by the human, who approves, edits, or rejects it.
4. Only after approval is the change committed to `knowledge/`.

This gate exists because the knowledge layer is loaded by every future session. An incorrect or premature update propagates everywhere.

---

## 4. Dynamic Routing

Routing is the mechanism by which the system decides what to load and what to do next. It is defined in `ROUTING.md` (Steps 1–4) and elaborated in `knowledge/flow/routing-rules.md`.

### Routing inputs

- The request content (Step 2 table match)
- The current project's last STATUS signal
- Open flags and outstanding human asks
- Explicit human override instructions

### Priority order

1. Human override
2. Hard blocker (`STATUS: BLOCKED`)
3. Approval gate
4. Explicit rework signal
5. Signal-driven default phase progression
6. Safe fallback (`STATUS: WAITING FOR HUMAN`)

---

## 5. Subproject Transcendence

A session focused on Project A may produce findings that belong in Project B (or in the knowledge layer itself). This creates a recurring tension: act immediately (convenient but untracked) or defer entirely (clean but easy to forget).

**Correct handling:**

| Finding type | Where it belongs | How to handle |
|---|---|---|
| Knowledge correction or new domain fact | Knowledge layer (`knowledge/domains/`) | Raise `[FLAG FOR KNOWLEDGE UPDATE]` — do not edit directly |
| Structural or routing improvement to the system itself | System project `session-log.md` | Raise `[FLAG FOR SYSTEM]` and append a handoff turn at session end |
| Project-specific discovery | Source project's `context/` | Document in-session in the appropriate context file |

Do not act on knowledge-layer or system-layer changes from within another project's session. Surface them as flags, hand off via session-log, and resolve in the correct project.

---

## 6. Setting Up a New Instance

To fork this template for a new initiative:

1. **Rename** the repo to `[initiative-name]-context-architecture`.
2. **Update `.github/copilot-instructions.md`** — replace `[Project Name]` with your initiative name.
3. **Update `ROUTING.md`** — replace the document purpose, update routing table rows.
4. **Define your knowledge domains** — copy `knowledge/domains/example-domain/`, rename, fill in `description.md` and `knowledge.md`.
5. **Register domains** in `knowledge/domains/index.md`.
6. **Create your first project** — copy `projects/_template/`, rename, write Turn 1 in `session-log.md`.
7. **Remove example content** — delete `example-domain/` and `example-project/` once replaced.
8. **Initialize git** — run `git init`, add remote, push.

---

## Version History

| Version | Date | Summary |
|---|---|---|
| 1.0 | 2026-06-29 | Initial creation. Generic context architecture system design document. |
