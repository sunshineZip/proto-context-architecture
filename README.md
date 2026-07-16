# Context Architecture

> **If you are an LLM:** stop reading this file and open `ROUTING.md` instead. That file contains your routing instructions.

---

A **context architecture** is a structured knowledge and routing system designed to work with any LLM or AI coding assistant. It organises subject-matter knowledge into curated domains, routes the right context to each AI session, and enforces discipline around how knowledge is updated and how work progresses — all through a structured set of files in a Git repo.

This repo is a generic template. Fork it, rename it, replace the example content with your own domains and projects, and you have a working context architecture for any major initiative.

---

## How it works

- **Knowledge domains** (`knowledge/domains/`) hold deep, curated knowledge about specific subject areas. Each domain has a scope description and a reference knowledge document.
- **Flow files** (`knowledge/flow/`) define the operating principles, turn protocol, routing rules, and project templates that govern how sessions behave.
- **Projects** (`projects/`) each have a session log (append-only turn record) and a TODO list. The AI works through projects by appending turns to the session log.
- **Routing** (`ROUTING.md`) is a four-step instruction set loaded by the AI at the start of every session. It tells the AI what to load and how to behave based on the request.

For the full structural design: see [Architecture.md](Architecture.md).

---

## Setting up a new instance

1. Fork or copy this repo. Rename it to `[your-initiative]-context-architecture`.
2. Update `.github/copilot-instructions.md` — replace `[Project Name]` with your initiative name.
3. Update `ROUTING.md` — replace the routing table rows with your projects and domains.
4. Define your domains — copy `knowledge/domains/example-domain/`, rename, fill in the content.
5. Register domains in `knowledge/domains/index.md`.
6. Create your first project — copy `projects/_template/`, rename, write Turn 1 in `session-log.md`.
7. Delete `example-domain/` and `example-project/` once replaced.

For domain authoring standards: see [knowledge/domains/authoring-guidelines.md](knowledge/domains/authoring-guidelines.md).

---

## Folder structure

```
[repo-name]/
  README.md                           ← This file — human overview
  ROUTING.md                          ← LLM routing instructions (Steps 1-4)
  Architecture.md                     ← System design reference
  MarkdownConventions.md              ← Markdown standards for all files
  .github/
    copilot-instructions.md           <- VS Code + Copilot adapter — loads ROUTING.md
                                         (for other LLM setups, load ROUTING.md directly)

  knowledge/
    flow/
      operating-principles.md         ← Core principles, signals, layer boundaries
      turn-protocol.md                ← Turn format, STATUS signals, BLOCKED format
      routing-rules.md                ← Routing logic for structured work
      project-types.md                ← Project type definitions and phase templates
    domains/
      index.md                        ← Domain registry
      authoring-guidelines.md         ← Standards for writing domain knowledge
      [domain-name]/
        description.md                ← Domain scope, constraints, when to load
        knowledge.md                  ← Domain reference material
        sources/                      ← Evidentiary source files (only if this domain has any)
          manifest.md                 ← Registry of the raw files in this folder

  library/                            ← Cross-domain deep-well registry
    reference-index.md                ← Registry of every deep well, stored or not
    deep-wells/                       ← Physical files for cornerstone-status deep wells only

  projects/
    system/                           ← Pre-created — audit log for structural changes to this system
      session-log.md
      TODO.md
    _template/                        ← Copy this when starting a new project
      session-log.md
      TODO.md
    [project-name]/
      session-log.md                  ← Turn-by-turn record — append only
      TODO.md                         ← Open items and done list
      context/                        ← Project-specific working notes (optional)
      outputs/                        ← Phase deliverables (optional)

  scripts/
    commit-push.ps1                   ← Stage, commit, and push all changes
    validate.ps1                      ← Structural integrity check

  temp/                               ← Transient handoff artifacts (.gitignored)
```

---

## Version History

| Version | Date | Summary |
|---|---|---|
| 1.0 | 2026-06-29 | Initial creation. Generic context architecture template. |
| 1.1 | 2026-06-29 | Rewritten as human-readable document. LLM routing instructions moved to ROUTING.md. |
| 1.2 | 2026-07-16 | Added `library/` (cross-domain deep-well registry) and the per-domain `sources/` folder to the folder structure diagram — see `knowledge/domains/authoring-guidelines.md` §9. Also fixed a pre-existing formatting break in the `projects/` block of this same diagram (missing line breaks had collapsed three tree rows onto one line). |
