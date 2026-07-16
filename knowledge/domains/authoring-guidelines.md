# Domain Knowledge Authoring Guidelines

Version 1.3 | 2026-07-16 | Production

---

## Document Purpose

Defines the structure, naming conventions, content rules, and versioning standards for domain knowledge documents in this context architecture. Apply these guidelines when creating or editing any `knowledge.md` file.

This document covers knowledge-document-specific rules only. General markdown formatting, versioning conventions, and validity signal formats follow `MarkdownConventions.md`, which is the baseline standard for all files. Where this document and MarkdownConventions.md overlap, this document takes precedence for knowledge documents specifically.

**Edit ceremony for `knowledge.md` files:** Appending new facts or sections to an existing `knowledge.md` requires a `[FLAG FOR KNOWLEDGE UPDATE]` and human confirmation — no system project entry needed. Structural changes (adding a new domain, changing a domain's scope, removing a domain, reorganising a knowledge document) route through `projects/system/` first.

> **Routing check:** Load this file when a knowledge change has been approved and you are ready to write. Do not begin authoring without completing ROUTING.md routing and receiving explicit human confirmation.

> **Edit guard:** Changes to this file are system-layer work. Route to `projects/system/` and record the change in `session-log.md` before editing.

> **These are guidelines, not rules.** The guidance here defines sensible defaults. Adapt freely where a different format better serves a specific document's purpose. The following are mandatory for all knowledge documents regardless of type:
>
> - **Title and header block** in the format defined in §2
> - **Document index with descriptive entries and live anchor links**, placed immediately after Document Purpose. Each entry must name the key concepts covered in that section — the Index is the routing LLM's decision aid for section-aware loading.
> - **Executive Summary**, placed immediately after the index
> - **Version History** as the final section, with a one-line entry per edit
> - **Consistent table formatting**: no blank lines between rows; "N/A" or "TBC" for empty cells

---

## Index

1. [File Naming](#1-file-naming)
2. [Document Header Block](#2-document-header-block)
3. [Section Architecture](#3-section-architecture)
4. [Content Rules per Section Type](#4-content-rules-per-section-type)
5. [Cross-References Between Domains](#5-cross-references-between-domains)
6. [Validity and Confidence Signals](#6-validity-and-confidence-signals)
7. [Versioning](#7-versioning)
8. [Maintenance Pass](#8-maintenance-pass)
9. [Evidentiary Sources & Deep Wells](#9-evidentiary-sources--deep-wells)
10. [What Does Not Belong in a Knowledge Document](#10-what-does-not-belong-in-a-knowledge-document)
11. [Quick Checklist](#11-quick-checklist)

---

## 1. File Naming

Domain knowledge files are always named:

```
knowledge.md
```

The domain is identified by the parent folder (`knowledge/domains/[domain-name]/`), not the filename. This mirrors the `description.md` convention — the folder provides context, the filename signals the document type.

---

## 2. Document Header Block

Every knowledge document opens with:

```
# [Domain Name] — Knowledge

Version [X.Y] | [YYYY-MM-DD] | [Status]

---

## Document Purpose

[One to two sentences: what domain this covers and what the LLM can do with this knowledge.]
```

---

## 3. Section Architecture

### Required sections, in order

1. **Document Purpose** — immediately after the title block
2. **Index** — numbered list with descriptive entries and anchor links; placed immediately after Document Purpose
3. **Executive Summary** — 3–8 bullet points covering the most operationally critical facts; placed immediately after the Index
4. **Domain sections** — one section per major subject area; ordered by operational frequency (most-used first)
5. **Version History** — always the last section

### Optional sections

Add these only if the domain genuinely needs them:

- **Known Gaps / Open Questions** — things that are genuinely unresolved or contradictory about the domain itself, not yet actionable.
- **Open Items / Next Actions** — concrete tasks. Keep this separate from Known Gaps: conflating the two causes a settled-but-unresolved question to be re-litigated as if it were a fresh task.

### Index entries

Each index entry must name the key concepts covered in that section — not just the section title. The Index is the primary mechanism by which a routing LLM decides which sections to load.

Good: `3. [Database Schema](#3-database-schema) — table names, column types, primary keys, known null fields`
Poor: `3. [Database Schema](#3-database-schema)`

### Executive Summary

The Executive Summary gives an LLM the critical facts it needs before reading any domain section. Write it as if the LLM may load only this section in a time-constrained session. Cover:
- What this domain is responsible for
- The single most important fact or constraint
- Any critical gotchas or non-obvious behaviours

---

## 4. Content Rules per Section Type

### Token efficiency

Every word in a knowledge document is a recurring cost — it loads on every future session that reads this file. Write for density.

- **Tables over prose.** A fact in a table row costs a fraction of the tokens of the same fact in a paragraph. If it fits in a table, it belongs in a table.
- **Sections must be independently loadable.** A routing LLM may load only one or two sections. Every section must make sense on its own — never rely on context established in a prior section that may not have been loaded.
- **The Executive Summary is the primary token optimisation.** It must contain the facts needed in 80% of sessions. A well-written Executive Summary means most sessions never need to load the full document.
- **Lead each section with the most operationally relevant fact.** Background and rationale belong at the end of a section, not the beginning.

### Domain sections

- One topic per section. Do not merge distinct subjects just because they seem related.
- Lead with the most operationally relevant fact, not with background.
- Prefer tables over prose for structured facts (mappings, inventories, configurations).
- End domain sections with a `> **Note:**` callout if there is a critical caveat that applies to the whole section.
- Every fact has exactly one owning section. If it's also relevant elsewhere in the same document, cross-reference it (§X.Y) instead of restating it — a restated fact drifts out of sync the moment one copy is updated and the other isn't.

### Procedures

- Number every step. Steps must be executable in sequence.
- State preconditions before the first step.
- State the expected outcome after the last step.
- Do not include rationale in procedural steps — move it to a preceding paragraph.

### Tables

See `MarkdownConventions.md` §5. Key rules: no blank lines between rows, no empty cells.

### Provenance and source notes

When a fact was discovered during a specific project session, note the source:

```
> **Source:** Project [name], Turn [N], [YYYY-MM-DD]
```

This allows future sessions to locate the original context if the fact needs to be re-verified.

### Correction discipline

- Do not overwrite established facts based on a single contradicting observation.
- When you observe something that contradicts existing content: append a `[CONTRADICTS]` callout, note the source, and raise a `[FLAG FOR KNOWLEDGE UPDATE]`.
- Rewriting established content requires full context of the surrounding section and explicit human approval.
- The asymmetry is intentional: it is cheaper to investigate a flag than to recover from a premature rewrite.
- When a flagged correction is approved, check `knowledge/domains/index.md`'s References column and any project `context/` notes for the same fact restated elsewhere. The own-vs-reference rule (§4) prevents *new* duplication, but doesn't retroactively catch a value that was copied before a document adopted the convention — a correction with no backlink check can leave a stale copy uncorrected indefinitely.

---

## 5. Cross-References Between Domains

When a knowledge document refers to content in another domain:

- Use a relative file link: `[description.md](../other-domain/description.md)`
- Add a `> **See also:**` callout at the point of reference naming the other domain and what it covers.
- Do not duplicate content from another domain — reference it instead.
- Register the cross-reference in `knowledge/domains/index.md` (Registered Domains → References column), and check whether the referenced domain should reference this one back. A reference that only points one way is a common source of silent drift as the domain family grows — nothing else catches it.

---

## 6. Validity and Confidence Signals

Use the signals defined in `MarkdownConventions.md` §8 to qualify claims:

| Signal | Meaning |
|---|---|
| `[VERIFIED: source]` | Confirmed against a named primary source |
| `[UNVERIFIED]` | Not yet confirmed — treat as hypothesis |
| `[CONTRADICTS: source]` | Conflicts with another documented fact |
| `[OUTDATED: date]` | Known to be stale as of the given date |
| `[TIME-SENSITIVE: source type]` | Sourced from third-party/public material that can change without notice — re-verify before relying on it for a decision |
| `[SENSITIVE]` | Handle with care if this document is ever shared, quoted, or copied elsewhere |

Apply signals at the claim level, not the section level. A section can contain both verified and unverified claims. `[TIME-SENSITIVE]` and `[SENSITIVE]` describe a different axis than the other four and can stack with them — a claim can be both `[VERIFIED: source]` and `[TIME-SENSITIVE: source type]` at once.

---

## 7. Versioning

Follow `MarkdownConventions.md` §2. Additionally for knowledge documents:

- Increment version on every edit, including single-fact additions.
- The Version History row should name the section changed, not just "updated."
- When a section is significantly restructured, increment major version and note the old structure briefly in the Version History row.
- If this document replaces older files or notes, name them explicitly in the Document Purpose and state that they should not be loaded independently once this document exists. Keep the superseded files in the repo for history and audit — not for reading.

---

## 8. Maintenance Pass

A structural health check, distinct from the per-edit updates above. Per-edit updates keep a single change correct; a Maintenance Pass catches drift that accumulates silently across many small edits over time. Run it periodically — on request, or when a domain's Index and content have visibly diverged — not on every edit.

- [ ] Confirm every Index entry (§3) still points to a section that exists, under the correct number
- [ ] Check for the same fact stated in two places with different confidence signals (§6); consolidate under one owning section per the rule in §4
- [ ] Confirm the Executive Summary still reflects the most operationally critical facts — move anything it has outgrown into the relevant domain section
- [ ] If the domain has separate Known Gaps and Open Items sections (§3), confirm they haven't been conflated
- [ ] Compact fully-resolved entries: once something is no longer actionable, collapse it to a one-line outcome and date rather than keeping the full history
- [ ] Confirm `knowledge/domains/index.md`'s References column still matches the actual `> See also:` callouts in this domain's `knowledge.md` — a one-directional reference that should be reciprocal is exactly the kind of drift this pass exists to catch
- [ ] Consider whether this domain should split in two: warning signs are routinely needing the Full file (ROUTING.md §4, level 5) because sections are too interdependent to load separately, or two sections that are never needed by the same task. There's no fixed size threshold — judge by whether a task ever needs the whole document versus consistently needing only one part of it
- [ ] If this domain has a `sources/` folder, run `scripts/validate.ps1` and confirm it reports no referential-integrity issues for this domain (§9.4)

---

## 9. Evidentiary Sources & Deep Wells

Raw material a domain's knowledge is actually built from — an insurance policy PDF, a medical journal, a contract — has no home in `description.md` or `knowledge.md`. Two categories, handled differently based on size and reusability.

### 9.1 Evidentiary Sources

An evidentiary source is finite, definitive, and proves one specific claim (a policy clause, a contract term). It is small enough that storage is never a real cost — always store it.

Location: `knowledge/domains/[name]/sources/`. Only create this folder for a domain that actually has evidentiary sources — not a default empty folder in every domain.

```
knowledge/domains/[name]/
  description.md
  knowledge.md
  sources/
    manifest.md
    <raw-file-1>.pdf
    <raw-file-2>.pdf
```

`sources/manifest.md` follows the standard file header (`MarkdownConventions.md` §1), since it's a file in this repo like any other:

```
# [Domain Name] — Source Manifest

Version 1.0 | YYYY-MM-DD | Production

---

## Document Purpose

Registry of evidentiary source documents for the [Domain Name] domain —
raw files that specific claims in knowledge.md cite back to.

---

| File | Type | Effective date | Acquired | Supersedes | Status |
|---|---|---|---|---|---|
| home-policy-2026.pdf | Insurance policy | 2026-01-01 | 2026-01-15 | home-policy-2025.pdf | Current |

---

## Version History

| Version | Date | Summary |
|---|---|---|
| 1.0 | YYYY-MM-DD | Initial creation. |
```

Cite a source from `knowledge.md` with a standard relative link, consistent with `MarkdownConventions.md` §7 — no new link syntax:

```
The policy excludes water damage above the 2nd floor
([home-policy-2026.pdf](sources/home-policy-2026.pdf), §4.2). [VERIFIED: home-policy-2026.pdf]
```

The existing `[VERIFIED: source]` signal (§6) already carries the provenance confidence state — the link supplies the "where," the signal supplies the "how sure." No new signal is needed.

**Edit ceremony:** adding a source and a manifest row is a knowledge-layer content addition — treat it exactly like appending a fact to `knowledge.md` (`[FLAG FOR KNOWLEDGE UPDATE]`, human confirms, then commit). It does not need system-project routing on its own — only introducing or restructuring the `sources/` convention itself (this section) is system-layer work.

### 9.2 Deep Wells

A deep well is large, mined incrementally, and possibly relevant to more than one domain — a textbook, a manual. It is always registered; it is only physically stored if it clears the cornerstone bar (§9.3).

Location: `library/`, a top-level folder sibling to `knowledge/` and `projects/`.

```
library/
  reference-index.md
  deep-wells/
    <cornerstone-work>.pdf
    <cornerstone-work>-manifest.md
```

`library/reference-index.md` is a cross-domain registry of every deep well ever touched, stored or not. One heading per entry; the heading text is the citation slug:

```
## <slug-in-kebab-case>

- **Title:**
- **Format:**
- **Stored:** yes / no — if no, note how to reacquire it (ISBN, URL)
- **Location:** library/deep-wells/<filename> (only if Stored: yes)
- **Referenced by domains:** <domain-name>
- **Cornerstone status:** Yes/No — one line why
- **Extraction log:**
  - YYYY-MM-DD: <what was mined> → appended to <domain>/knowledge.md, per [VERIFIED: <slug>]
```

For a stored cornerstone work, `library/deep-wells/<work>-manifest.md` holds the detailed extraction log (table of contents, what's mined, what isn't), so `reference-index.md` can stay a short summary that links to it.

Citing a registry-only (not physically stored) deep well from a domain, from `knowledge/domains/[name]/knowledge.md`:

```
See [Gray's Anatomy, 43rd ed., ch. 12](../../../library/reference-index.md#grays-anatomy-2023) [VERIFIED: grays-anatomy-2023]
```

### 9.3 The Cornerstone Rule

A deep well's physical file goes into `library/deep-wells/` only if any one of these holds:

- More than one domain draws on it, or is likely to.
- It's not trivially reacquirable (out of print, a personal scan, paid for and not worth repurchasing).
- A subproject will mine it incrementally over months and reacquisition friction would slow that down.

Otherwise: registry entry only, no physical file.

This decision is never made unilaterally by the LLM — same pattern as the existing knowledge-promotion flag (`operating-principles.md` §5): surface it as a one-line question in the next CHECKPOINT turn, wait for human confirmation, only then store the file and write the manifest. This is a Hard Constraint — see `ROUTING.md`.

### 9.4 Referential Integrity

`scripts/validate.ps1` checks that source and deep-well references stay consistent: every `sources/manifest.md` row resolves to a real file and vice versa (orphan detection both directions), every `reference-index.md` entry marked `Stored: yes` resolves to a real file in `library/deep-wells/` and vice versa, and relative links from a domain's `description.md`/`knowledge.md` into `sources/` or `library/reference-index.md` resolve to a real file or a real heading. Run it after adding, removing, or renaming a source or deep well.

> **Note:** Raw evidentiary sources and deep-well files are never loaded as part of routine domain-knowledge routing (`ROUTING.md` §4) — they are opened only when a task explicitly names the specific file to mine or verify against.

---

## 10. What Does Not Belong in a Knowledge Document

| Does not belong | Belongs instead |
|---|---|
| Routing or workflow instructions | `knowledge/flow/` |
| Project-specific state or working notes | `projects/[name]/context/` |
| Decisions that apply only to one project | `projects/[name]/session-log.md` |
| Transient artifacts or handoff materials | `temp/` |
| Instructions for the LLM about how to behave generally | `knowledge/flow/operating-principles.md` |

---

## 11. Quick Checklist

Before submitting any knowledge document for human approval:

- [ ] Header block present with version, date, and status
- [ ] Document Purpose is one to two sentences
- [ ] Index is present with descriptive entries and working anchor links
- [ ] Executive Summary covers the critical facts
- [ ] No blank lines between table rows
- [ ] No empty table cells (use N/A or TBC)
- [ ] All cross-domain references use relative links
- [ ] Validity signals applied to unverified or contradicted claims, and time-sensitive or sensitive facts carry the appropriate signal (§6)
- [ ] Sections are independently loadable — no critical fact depends on a prior section that may not be loaded
- [ ] Evidentiary sources have a manifest.md; every source cited from knowledge.md resolves to a real file or a real reference-index.md heading (§9)
- [ ] Version History row added for this edit

---

## Version History

| Version | Date | Summary |
|---|---|---|
| 1.0 | 2026-06-29 | Initial creation. Adapted from NightCrew Knowledge Base Authoring Guidelines, terminology updated for domain model. |
| 1.1 | 2026-07-15 | Added Maintenance Pass (§8, subsequent sections renumbered), own-vs-reference rule for within-document facts (§4), optional Known Gaps/Open Items section pattern (§3), supersede rule (§7), and matching `[TIME-SENSITIVE]`/`[SENSITIVE]` signal rows (§6). |
| 1.2 | 2026-07-15 | Added cross-reference reciprocity registration (§5), a correction backlink check for facts copied before the own-vs-reference convention existed (§4), and a when-to-split heuristic (§8) — prompted by a review of known pitfalls in a larger, organically-grown document family. |
| 1.3 | 2026-07-16 | Added new §9 "Evidentiary Sources & Deep Wells" (evidentiary sources in per-domain `sources/`, deep wells in top-level `library/`, the human-gated cornerstone rule, and referential-integrity tooling) — subsequent sections renumbered (old §9→10, §10→11). Added a `sources/` validation step to the Maintenance Pass (§8) and a source/deep-well resolution check to the Quick Checklist (§11). |
