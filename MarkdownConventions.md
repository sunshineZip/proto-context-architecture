# Markdown Conventions

Version 1.11 | 2026-09-10 | Production

---

## Document Purpose

Baseline markdown authoring standard for all files in this context architecture. Applies to every file regardless of type — conceptual documents, knowledge bases, project session logs, outputs. Both humans and the LLM are expected to follow these conventions when creating or editing any file.

Document-type-specific rules (e.g. for domain knowledge documents) build on top of this baseline and do not override it.

Which of these rules are mechanically enforced and which are honour-system: `knowledge/flow/convention-enforcement.md`. Check there before assuming a rule stated here is being checked — several were not, for months. When adding a rule to this file, add its row there in the same change.

> **Routing check:** This file defines formatting standards. If you have not read `ROUTING.md` and completed all four Route steps, do that first before making any file changes.

---

## Index

1. [File Header](#1-file-header)
2. [Versioning](#2-versioning)
3. [Structure and Hierarchy](#3-structure-and-hierarchy)
4. [Formatting Rules](#4-formatting-rules)
5. [Tables](#5-tables)
6. [Code Blocks](#6-code-blocks)
7. [Links and References](#7-links-and-references)
8. [Validity and Confidence Signals](#8-validity-and-confidence-signals)
9. [Writing Style](#9-writing-style)
10. [Version History](#10-version-history)

---

## 1. File Header

Every markdown file opens with this block:

```
# [Document Title]

Version [X.Y] | [YYYY-MM-DD] | [Status]

---

## Document Purpose

[One or two sentences: what this document is, who it belongs to or serves, and what it covers.]
```

*(For domain and project files, see also §1 "Retirement" below for the additional blockquote a `Retired` status requires.)*

### Header fields

| Field | Rule |
|---|---|
| Title | Matches the filename (without extension and folder path). Use title case. |
| Version | See §2. |
| Date | ISO 8601 (`YYYY-MM-DD`) — date of the last edit, not creation. |
| Status | `Draft`, `Review Pending`, `Production`, or `Retired`. **Project `TODO.md` files use `Active` or `Retired` instead** — a separate, intentional vocabulary that `scripts/validate.ps1` depends on to distinguish active from retired projects. Both vocabularies are checked. |

### Document Purpose rule

State what the document is and what it covers. Do not restate information the reader can infer from the title. One to two sentences is correct length — if it needs more, the document scope may be too broad.

### Frontmatter

Domain and project instance files additionally open with a YAML frontmatter block, before everything else in the file — including the `#` title and any blockquote that precedes it. This is the one exception to "the file opens with the header block above": frontmatter comes first, the standard header block follows immediately after it.

| File | Frontmatter |
|---|---|
| `knowledge/domains/[name]/description.md`, `knowledge.md` | `type: domain` · `domain: [name]` |
| `knowledge/domains/[name]/sources/manifest.md` | `type: source-manifest` · `domain: [name]` |
| `projects/[name]/TODO.md`, `session-log.md` | `type: project` · `project: [name]` |

```
---
type: domain
domain: example-domain
---
```

The slug field (`domain:` or `project:`) is a checksum, not narrative content — it must match the parent folder name exactly, and `scripts/validate.ps1` checks this. **Never add a `status` or `version` field here**: that information already lives in the header block's "Version | Date | Status" line above. Restating it in frontmatter creates two sources of truth for the same fact — the same own-vs-reference problem `knowledge/domains/authoring-guidelines.md` §4 exists to prevent within a single document, just spanning two locations in the same file instead of two sections.

Root, flow, and registry files (`ROUTING.md`, `Architecture.md`, `knowledge/flow/*.md`, `knowledge/domains/index.md`, `library/reference-index.md`) do not use frontmatter — each is a singleton, not part of a queryable collection of same-shaped files, so frontmatter adds no value there.

### Retirement

A domain or project that has become permanently irrelevant is retired, not deleted — the record stays in the repo for history, just excluded from default routing. This is the default outcome; hard-deleting files is a separate, explicitly-confirmed action, not part of retirement itself.

| File | On retirement |
|---|---|
| Domain `description.md`, `knowledge.md` | Header Status field (above) → `Retired`. Add a one-line blockquote immediately after Document Purpose, before the Index: `> **Retired:** YYYY-MM-DD — [one-line reason]. Historical reference only; excluded from default routing.` |
| Project `TODO.md`, `session-log.md` | Header Status field → `Retired`. Add the same blockquote alongside the file's existing top-of-file blockquotes (Routing check, Push policy, or similar). |

Retiring is a structural change, not a content edit — it requires explicit human confirmation and routes through `projects/system/` like adding a domain or project does (`ROUTING.md` Hard Constraints). See `knowledge/domains/index.md` § Retiring a Domain and `ROUTING.md` Quick Task Guide for the full procedure.

---

## 2. Versioning

### Version number semantics

| Increment | When to use |
|---|---|
| Minor (`X.Y → X.Y+1`) | Added content, corrected a fact, updated a reference, added a table row |
| Major (`X.Y → X+1.0`) | Restructured the document, replaced a major section, scope changed significantly |

Start all documents at `1.0`.

### On every edit

1. Update the version number and date in the header line.
2. Append a new row to the Version History table at the bottom of the file — one sentence describing what changed and why.
3. Never delete or overwrite old Version History rows. The full history is preserved regardless of how significantly the document has changed.

### Version History section

Required in every root document (`README.md`, `ROUTING.md`, `Architecture.md`, this file) and every file under `knowledge/` and `library/`. Always the last section.

Project-layer files are the deliberate exception and carry none: `session-log.md` is append-only and already versioned by turn number, and `TODO.md` is a live task list rather than a document with revisions. `.github/copilot-instructions.md` (an editor entry point) and anything in `incoming/` (a transient landing zone) are likewise out of scope. `scripts/validate.ps1` enforces exactly this scope — a file that requires the section and omits it is now warned about rather than silently skipped, which is how a domain document in a fork lost its Version History entirely without anything noticing.

Format:

```
## Version History

| Version | Date | Summary |
|---|---|---|
| 1.0 | YYYY-MM-DD | Initial creation. [Brief description of what the file contained at creation.] |
| 1.1 | YYYY-MM-DD | [What changed and why.] |
```

### Version History archival

"Never delete" and "never grow without limit" are both right, and for a handful of files they conflict. A few singleton documents are loaded on nearly every session — `ROUTING.md` at Step 1, `knowledge/domains/index.md` at Step 4 — and their changelog is paid for on every one of those loads while telling a live session nothing about how to behave. A fork measured its own: 14% of `ROUTING.md` and 46% of its domain index were history.

So rows may be **moved, never removed**. Once a live table exceeds **20 rows**, rows older than the most recent 20 may be relocated verbatim into a paired `<basename>-history.md` in the same directory — `ROUTING-history.md` beside `ROUTING.md`. Leave a pointer line where they were:

> Earlier history archived in `ROUTING-history.md`.

The archive file carries a `## Version History` section holding the moved rows, and deliberately **no** `Version X.Y | Date | Status` header line: a pure archive has no meaningful version of its own, and a header there would trip the header-versus-latest-row check for no reason.

The append-only rule is not weakened by this, because what must stay append-only is the archive and the live table **read together**. `scripts/validate.ps1` enforces exactly that: when a live table shrinks it looks for the paired file and accepts the change only if archive-plus-live still reconstructs everything that was there at the last commit. A genuine deletion, or an edit to an archived row, fails that test and errors as before.

Two things that follow, and are easy to get wrong:
- **20 rows is a threshold for permission, not an instruction.** Nothing warns at 20, and nothing should — a file sitting at 30 rows is not in violation of anything.
- **The live table then starts mid-sequence**, at 1.15 rather than 1.0. That is correct, and the start-at-1.0 check already tolerates it: it warns only on a first row *below* 1.0.

---

## 3. Structure and Hierarchy

- Use `#` for the document title only — one per file.
- Use `##` for top-level sections.
- Use `###` for sub-sections.
- Do not skip levels (e.g. do not jump from `##` to `####`).
- Name sections after the **knowledge domain or content type** they contain, not after the workflow step or phase where they are used.
- Use an `## Index` section with anchor links in any document longer than four sections. Place it immediately after Document Purpose.
- **Exception:** `knowledge/domains/[name]/description.md` carries no Index regardless of section count. It is capped at roughly one page and loaded whole on every request matched to its domain (see its own Brevity constraint), so an Index would add load cost on every session while helping none of them. Every other document over four sections needs one.

### When to use each content type

| Content type | Use when |
|---|---|
| Table | Structured facts with clear column relationships: mappings, requirements, inventories, status tracking |
| Bulleted list | Unordered items or short procedural steps where sequence doesn't matter |
| Numbered list | Ordered steps where sequence matters |
| Prose | Framing, rationale, and caveats only — not for restating facts that fit in a table or list |

Lead sections with the most operationally relevant information. Reserve prose for the edges — context that doesn't fit a structured format.

---

## 4. Formatting Rules

### No backslash escapes

Default: do not write `\#`, `\*`, `\_`, `\-`, `\&`, `\[`, `\]`, `` \` ``. Write the literal character directly. A backslash before a character that did not need escaping renders as a literal backslash in most markdown renderers and corrupts the document.

Two exceptions are real, and both appear in this repo's own shipped files. This rule previously forbade both with only a UNC-path carve-out, which made it wrong rather than merely strict:

1. **A literal pipe inside a table cell must be escaped.** Required, not optional: an unescaped pipe ends the cell, so the row silently loses columns and the table misrenders. GitHub-flavoured markdown specifies escaping as the only way to put a pipe in a cell — including inside a code span, where the table parser consumes the backslash rather than rendering it. This applies to *this* table-heavy convention document as much as to any domain document.
2. **A backslash inside an inline code span or fenced block is literal content, not an escape.** The rationale above does not apply to it. This covers Windows paths (`.\scripts\commit-push.ps1` appears in `ROUTING.md`, `.github/copilot-instructions.md`, `knowledge/flow/turn-protocol.md` and `projects/system/TODO.md`), UNC paths such as `\\server\share\path`, and regular expressions.

Outside those two cases the default holds: write the character directly.

### No blank lines between list items (unless intentional paragraph breaks)

A blank line between list items promotes them to block-level paragraphs in most renderers, which is rarely the intended behaviour. Keep list items directly adjacent unless each item genuinely requires paragraph-level separation.

### No HTML entities

Do not use `&#x20;`, `&nbsp;`, `&amp;`, or similar HTML entities. Use the literal character or a standard unicode character.

### Bold and italics

- Use `**bold**` for terms being defined, critical warnings, or field labels.
- Use `*italics*` sparingly — for emphasis within a sentence, or for titles of external documents.
- Do not use bold to make prose easier to skim. If a section needs bolding to be readable, restructure it into a table or list.

---

## 5. Tables

- No blank lines between table rows. A blank line inside a markdown table breaks rendering — every row must immediately follow the previous one.
- Never leave a table cell blank — use `N/A` or `TBC`.
- One topic per table. Do not merge unrelated rows into the same table just because they share a column structure.
- Table headers should be short (one to three words). Explanatory text belongs in a preceding sentence, not in the header row.

### Standard column patterns for common table types

| Table type | Columns |
|---|---|
| Artifact → purpose | Item / Description / Notes |
| Requirement mapping | Element / Standard / Notes |
| Context → applicability | Context / Applicability |
| Issue inventory | Item / Issue / Required Action |
| Status tracking | # / Item / Status / Action + Owner |
| Signal reference | Signal / Meaning / When used |

---

## 6. Code Blocks

- Use fenced code blocks (triple backtick) for all code, file paths, command-line instructions, and structured text that must be reproduced exactly.
- Specify a language hint where helpful: ` ```sql `, ` ```powershell `, ` ```xml `.
- Do not use inline code (single backtick) for prose emphasis — reserve it for literal values, file names, and short code references.

---

## 7. Links and References

- Use relative links for internal file references: `[Architecture.md](Architecture.md)`, `[description.md](knowledge/domains/example-domain/description.md)`.
- Encode spaces as `%20` in link targets: `[My File](My%20File.md)`.
- Do not use absolute paths for internal files — relative paths survive repo moves and forks.

---

## 8. Validity and Confidence Signals

Use these inline signals to flag the reliability of specific claims:

| Signal | Meaning |
|---|---|
| `[VERIFIED: source]` | Confirmed against a named primary source |
| `[UNVERIFIED]` | Not yet confirmed — treat as hypothesis |
| `[CONTRADICTS: source]` | Conflicts with another documented fact — do not resolve without human review |
| `[OUTDATED: date]` | Known to be stale as of the given date |
| `[TIME-SENSITIVE: source type]` | Sourced from third-party/public material (pricing page, vendor docs, FAQ) that can change without notice — re-verify before relying on it for a decision |
| `[SENSITIVE]` | Handle with care if this document is ever shared, quoted, or copied elsewhere |

Place signals immediately after the claim they qualify, in square brackets. The first four signals describe a claim's current confidence state and are mutually exclusive. `[TIME-SENSITIVE]` and `[SENSITIVE]` describe a different axis and can stack with any of the four — a claim can be both `[VERIFIED: source]` and `[TIME-SENSITIVE: source type]` at once.

`[SENSITIVE]` documents a decision already made about content that has already been written — it is not the mechanism that decides whether the content should have been written down at all. That decision point is a Hard Constraint in `ROUTING.md`: pause and ask before writing a secret, credential, or third-party confidential detail into any tracked file, regardless of whether it ends up tagged.

### Where a `[SENSITIVE]` claim may sit

**A `[SENSITIVE]` claim belongs in a named section, never in a section the loading hierarchy reads by default.** `ROUTING.md` Step 4 Level 3 loads a domain's Executive Summary on nearly every query that touches that domain, without opening a single numbered section. A tagged claim placed there is therefore loaded by default, in sessions that had no reason to ask for it — and the care the tag exists to prompt never gets a chance to happen. The same applies to any Quick Reference, At a Glance, or similar always-loaded section a fork adds.

Those sections may name the mechanism and point at the section holding the detail. "Recovery procedure is covered in §9" is routing information and belongs in an Executive Summary; the recovery codes do not.

This matters most at the moment content leaves the repo. An extract, a shared summary, or a cross-fork pull built from "just the Executive Summary" is a natural request, and if severe material is sitting there it travels without anyone deciding that it should — see `knowledge/flow/repo-mixing.md` §7 for the cross-fork case.

**Carve-out — a domain that is sensitive throughout.** Some domains have no ordinary part to summarise. Applying the rule literally would force an Executive Summary that says nothing useful, which defeats the routing purpose Level 3 exists for. Such a domain records `Sensitive throughout: yes` in its `description.md` `## Declarations` section — a registered set of standing per-domain decisions, defined in `knowledge/domains/authoring-guidelines.md` §3 — and is then exempt from the per-section rule: its whole file is treated as tagged. The declaration goes there rather than per claim because `description.md` loads at Level 1, ahead of the Executive Summary — so a session sees the declaration before it sees anything it governs. An absent declaration means the domain is not exempt, not that nobody checked.

**This rule cannot be checked mechanically, and that is a finding rather than an omission.** The real instance that prompted it carried no tag at all: that domain classified sensitivity per *section*, in its own local legend, so the copy that reached its Executive Summary was untagged by construction and no scan for the tag could have seen it. Section-level classification is the deeper error — `knowledge/domains/authoring-guidelines.md` §6 requires signals at the claim level precisely so that a claim carries its own handling rules wherever it is later copied to.

---

## 9. Writing Style

- Write for the LLM reader first, human reader second. Precision matters more than readability.
- Use active voice. Avoid hedging language ("might", "could potentially") unless genuinely uncertain.
- State what is true, not what is expected or assumed to be true.
- One idea per sentence. One topic per paragraph.
- Avoid filler phrases: "it is worth noting that", "as mentioned above", "in order to".

---

## 10. Version History

| Version | Date | Summary |
|---|---|---|
| 1.0 | 2026-06-29 | Initial creation. Generic markdown conventions adapted from NightCrew baseline. |
| 1.1 | 2026-07-15 | Added `[TIME-SENSITIVE: source type]` and `[SENSITIVE]` signals to §8 — durability and sensitivity are separate axes from confidence and can stack with the existing four signals. |
| 1.2 | 2026-07-16 | Added a Frontmatter subsection to §1: domain/project instance files open with a minimal YAML block (`type` + a folder-name checksum field) before the standard header, checked by `scripts/validate.ps1`. Explicitly excludes `status`/`version` to avoid duplicating the header line. |
| 1.3 | 2026-07-25 | Added `Retired` to the Status vocabulary and a Retirement subsection to §1, defining the archive-in-place convention (status field + one-line blockquote) for domains and projects that have become permanently irrelevant. Deletion is explicitly a separate, human-confirmed action, not part of retirement. |
| 1.4 | 2026-07-25 | Fixed a header/changelog version mismatch: the header still read "1.2" after the 1.3 edit shipped its own row. Found during `longstraw`'s upstream-sync port, not by the Version History discipline check meant to catch exactly this — that check had its own bug (§10's numbered heading, `## 10. Version History`, didn't match the check's unnumbered-only pattern, so this file was silently skipped entirely). Both fixed together; see `scripts/validate.ps1` and `projects/system/session-log.md` Turn 15. |
| 1.5 | 2026-08-11 | §8 — clarified that `[SENSITIVE]` is a post-hoc documentation tag, not a gate; cross-referenced the new pause-and-ask Hard Constraint in `ROUTING.md` that governs whether sensitive content gets written down in the first place. See `projects/system/session-log.md` Turn 18. |
| 1.6 | 2026-09-09 | §2 now names which files actually require a Version History section, instead of saying "Required in every file" — no file under `projects/` has ever carried one, so the rule as written was broader than any fork has followed and could not be enforced as stated. `scripts/validate.ps1` gained a matching check in the same change; previously a file omitting the section entirely was skipped silently while a file that had one was checked closely. See `projects/system/session-log.md` Turn 35. |
| 1.7 | 2026-09-09 | §3 gained an explicit exception for domain `description.md`, which has six sections and so nominally required an Index it should never have — the file is capped at one page and loaded whole by design. Surfaced while building `knowledge/domains/_template/`, which forced the question; the shipped `example-domain/description.md` had been quietly violating the rule as written since creation. See `projects/system/session-log.md` Turn 36. |
| 1.8 | 2026-09-10 | §4's no-backslash-escapes rule corrected: it forbade escaping a pipe absolutely with only a UNC-path exception, but a literal pipe inside a table cell must be escaped or the row silently loses columns, and a backslash inside a code span is literal content the rule's own rationale never covered. Both usages already existed and were correct in shipped files; nothing had ever exercised the rule against real content. §1's Status row now documents the Active/Retired vocabulary project TODO files actually use, which `scripts/validate.ps1` depends on and which §1 had never mentioned. Document Purpose now points at the new `knowledge/flow/convention-enforcement.md`. See `projects/system/session-log.md` Turn 38. |
| 1.9 | 2026-09-10 | §8 gained "Where a `[SENSITIVE]` claim may sit" — tagged content belongs in a named section, never in an Executive Summary or other section `ROUTING.md` Step 4 loads by default, with a carve-out for a domain that is sensitive throughout. Closes a gap in the interaction between §8, `authoring-guidelines.md` §6 and Step 4 Level 3 that none of the three stated on its own: nothing said a tagged claim may not sit in the one section loaded on nearly every query. Relayed from a fork whose security domain does exactly that. See `projects/system/session-log.md` Turn 42. |
| 1.10 | 2026-09-10 | §2 gained "Version History archival" — rows past the most recent 20 may be relocated verbatim to a paired `<basename>-history.md`, never deleted, with `scripts/validate.ps1` verifying that archive and live table together still reconstruct the committed history. Ported from a fork that built and tested it after measuring 14% of its `ROUTING.md` and 46% of its domain index as changelog loaded on nearly every session. This is also the mechanism several earlier relayed entries assumed already existed here; it now does. See `projects/system/session-log.md` Turn 47. |
| 1.11 | 2026-09-10 | §8's sensitive-throughout carve-out now names the registered `Sensitive throughout` declaration (`knowledge/domains/authoring-guidelines.md` §3) instead of describing a free-form note in Working Constraints. It was one of three markers that had accreted separately into `description.md`. See `projects/system/session-log.md` Turn 49. |
