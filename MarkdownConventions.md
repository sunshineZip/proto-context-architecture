# Markdown Conventions

Version 1.1 | 2026-07-15 | Production

---

## Document Purpose

Baseline markdown authoring standard for all files in this context architecture. Applies to every file regardless of type — conceptual documents, knowledge bases, project session logs, outputs. Both humans and the LLM are expected to follow these conventions when creating or editing any file.

Document-type-specific rules (e.g. for domain knowledge documents) build on top of this baseline and do not override it.

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

### Header fields

| Field | Rule |
|---|---|
| Title | Matches the filename (without extension and folder path). Use title case. |
| Version | See §2. |
| Date | ISO 8601 (`YYYY-MM-DD`) — date of the last edit, not creation. |
| Status | `Draft`, `Review Pending`, or `Production`. |

### Document Purpose rule

State what the document is and what it covers. Do not restate information the reader can infer from the title. One to two sentences is correct length — if it needs more, the document scope may be too broad.

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

Required in every file. Always the last section. Format:

```
## Version History

| Version | Date | Summary |
|---|---|---|
| 1.0 | YYYY-MM-DD | Initial creation. [Brief description of what the file contained at creation.] |
| 1.1 | YYYY-MM-DD | [What changed and why.] |
```

---

## 3. Structure and Hierarchy

- Use `#` for the document title only — one per file.
- Use `##` for top-level sections.
- Use `###` for sub-sections.
- Do not skip levels (e.g. do not jump from `##` to `####`).
- Name sections after the **knowledge domain or content type** they contain, not after the workflow step or phase where they are used.
- Use an `## Index` section with anchor links in any document longer than four sections. Place it immediately after Document Purpose.

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

Do not write `\#`, `\*`, `\|`, `\_`, `\-`, `\&`, `\[`, `\]`, `` \` ``. Write the literal character directly. Backslash-escaped characters render as literal backslashes in most markdown renderers and corrupt the document.

**Exception:** `\\` in UNC paths such as `\\server\share\path` is intentional — preserve double backslashes in those contexts.

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
