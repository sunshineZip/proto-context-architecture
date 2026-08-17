---
type: domain
domain: example-domain
---

# Example Domain — Knowledge

Version 1.2 | 2026-08-11 | Production

---

## Document Purpose

Reference knowledge for the Example Domain. Load the Index first — then load only the sections relevant to the current task. Do not load the entire file unless you have confirmed that multiple sections are needed.

> **Routing check:** Load this file only when directed by ROUTING.md Step 4. If you have not completed all four Route steps, do that first.

> **Edit guide:** To append new knowledge to this file, raise a `[FLAG FOR KNOWLEDGE UPDATE]` in your current session turn and wait for human confirmation — no system project entry needed. To change this domain's scope, rename it, or remove it entirely, route to `projects/system/` instead.

> **Setup note:** This is a template. Replace all bracketed placeholders with real knowledge, including the `domain:` value in the frontmatter above. Follow `knowledge/domains/authoring-guidelines.md` for content standards.

---

## Index

1. [Executive Summary](#1-executive-summary) — critical facts, key constraints, non-obvious behaviours
2. [Section Title](#2-section-title) — [describe the key concepts in this section so a routing LLM can decide whether to load it]
3. [Section Title](#3-section-title) — [describe the key concepts in this section]
4. [Section Title](#4-section-title) — [describe the key concepts in this section]
5. [Version History](#version-history)

---

## 1. Executive Summary

> Replace with 3–8 bullet points covering the most operationally critical facts about this domain. Write as if this may be the only section loaded in a time-constrained session.

- [Critical fact 1 — e.g. "All API calls require an OAuth 2.0 token with scope X"]
- [Critical fact 2 — e.g. "The staging and production environments use separate credential stores"]
- [Critical fact 3 — the most important gotcha or non-obvious constraint]
- [Critical fact 4]

---

## 2. [Section Title]

> Replace this section with your first major knowledge area. Name it after the knowledge domain or content type it contains, not after the workflow phase where it is used.

| Column Header | Column Header | Notes |
|---|---|---|
| [Value] | [Value] | [Note] |

---

## 3. [Section Title]

> Replace with your second major knowledge area.

---

## 4. [Section Title]

> Replace with your third major knowledge area.

---

## Version History

| Version | Date | Summary |
|---|---|---|
| 1.0 | 2026-06-29 | Initial creation. Placeholder knowledge document template. |
| 1.1 | 2026-07-16 | Added frontmatter (`type: domain`, `domain: example-domain`) per `MarkdownConventions.md` §1. |
| 1.2 | 2026-08-11 | Added a missing "5. Version History" Index entry — the template's own Index never indexed its Version History section, a real gap that would have propagated to every real domain copied from it. Found by the new Index structural-integrity check in `scripts/validate.ps1`. See `projects/system/session-log.md` Turn 22. |
