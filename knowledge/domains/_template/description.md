---
type: domain
domain: [domain-name]
---

# [Domain Name] — Description

Version 1.0 | YYYY-MM-DD | Draft

---

## Document Purpose

Scope and load conditions for the [Domain Name] domain. Load this file when working on any project that touches [describe what this domain covers in a few words].

> **Template note:** Copy this folder to `knowledge/domains/[domain-name]/`, then replace every bracketed placeholder — including the `domain:` value in the frontmatter above, which must match the new folder name exactly (`scripts/validate.ps1` checks this). Register the domain in `knowledge/domains/index.md` and add a routing row in `ROUTING.md` Step 2. Delete this note. Build the domain from this template rather than by copying a sibling domain: a copied sibling propagates whatever that one got wrong, and the copies then drift apart independently.

> **Routing check:** Load this file only when directed by ROUTING.md Step 2 or Step 4. Reading it does not authorise you to begin work — complete all four routing steps first.

> **Brevity constraint:** This file loads on every request matched to this domain. Keep it under one page. Its job is to answer two questions: does this domain apply, and which `knowledge.md` sections are likely relevant? Knowledge belongs in `knowledge.md`, not here. This file deliberately carries no Index — it is loaded whole by design (`MarkdownConventions.md` §3).

---

## Domain Scope

**This domain covers:**
- [Primary subject area 1]
- [Primary subject area 2]

**This domain does NOT cover:**
- [Explicitly excluded area — name the domain that does cover it, if one exists]

**Overlap risk:** [How to decide between this domain and an adjacent one, or `N/A` if there is no overlap risk.]

---

## When to Load This Domain

Load this description file and `knowledge.md` when:
- [Trigger condition 1]
- [Trigger condition 2]

Do not load this domain when:
- [Exclusion condition 1]

---

## Working Constraints

Constraints that apply to any work in this domain. Delete this section if the domain has none — an empty placeholder is worse than its absence.

- **[Constraint name]** — [What it requires, and what happens if it is not followed.]

---

## Declarations

Standing decisions about this domain as a whole. Registered set — see `knowledge/domains/authoring-guidelines.md` §3 for the permitted keys, their values, and what each means when absent. Delete any line you have not actually decided: a missing declaration correctly reads as "not reviewed", while a guessed one reads as a decision nobody made.

Mixable into other forks: [no | yes, ordinary content only]
Sensitive throughout: [yes | no]
Split assessed: [YYYY-MM-DD, keep whole]

---

## Key Contacts and Ownership

| Role | Responsible for | Notes |
|---|---|---|
| [Role or person] | [What they own in this domain] | [Notes, or `N/A`] |

---

## Version History

| Version | Date | Summary |
|---|---|---|
| 1.0 | YYYY-MM-DD | Initial creation. |
