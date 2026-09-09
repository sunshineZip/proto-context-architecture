---
type: domain
domain: [domain-name]
---

# [Domain Name] — Knowledge

Version 1.0 | YYYY-MM-DD | Draft

---

## Document Purpose

Reference knowledge for the [Domain Name] domain. Load the Index first, then load only the sections relevant to the current task.

> **Template note:** Copy this folder to `knowledge/domains/[domain-name]/` and replace every bracketed placeholder, including the `domain:` value in the frontmatter above (it must match the folder name exactly). A new domain starts as a stub — an Index and an Executive Summary with a handful of real facts is enough to begin; content grows over time. Delete this note. Content standards: `knowledge/domains/authoring-guidelines.md`. Formatting baseline: `MarkdownConventions.md`.

> **Routing check:** Load this file only when directed by ROUTING.md Step 4. If you have not completed all four Route steps, do that first.

> **Edit guide:** To append new knowledge to this file, raise a `[FLAG FOR KNOWLEDGE UPDATE]` in your current session turn and wait for human confirmation — no system project entry needed. To change this domain's scope, rename it, or remove it entirely, route to `projects/system/` instead.

---

## Index

1. [Executive Summary](#1-executive-summary) — critical facts, key constraints, non-obvious behaviours
2. [Section Title](#2-section-title) — [name the key concepts this section covers, not just its title: this line is how a routing LLM decides whether to load it]
3. [Version History](#version-history)

---

## 1. Executive Summary

3–8 bullets covering the facts needed in most sessions. Write it as if this may be the only section loaded (`authoring-guidelines.md` §3). Keep it short — `scripts/validate.ps1` warns past 20 non-blank lines, because ROUTING.md Step 4 Level 3 loads this on nearly every query.

- [The single most important fact or constraint in this domain]
- [A critical gotcha or non-obvious behaviour]
- [Fact 3]

---

## 2. [Section Title]

Name sections after the content they hold, not the workflow step that uses them. Lead with the most operationally relevant fact; background goes at the end. Prefer tables over prose. Every section must be independently loadable — never rely on context established in a section that may not have been loaded.

| Column Header | Column Header | Notes |
|---|---|---|
| [Value] | [Value] | [Note, or `N/A`] |

Qualify claims with the signals in `MarkdownConventions.md` §8 — `[VERIFIED: source]`, `[UNVERIFIED]`, `[TIME-SENSITIVE: source type]`, `[SENSITIVE]` — at the claim level, not the section level.

> **Note:** Use a callout like this for a caveat that applies to the whole section.

---

## Version History

| Version | Date | Summary |
|---|---|---|
| 1.0 | YYYY-MM-DD | Initial creation. |
