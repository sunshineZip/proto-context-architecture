# Convention Enforcement

Version 1.2 | 2026-09-10 | Production

---

## Document Purpose

Maps every convention this template states to whether anything actually enforces it. Answers "is this rule checked, or is it honour-system?" without reading a thousand lines of PowerShell, and gives a new rule somewhere to declare its enforcement status at the moment it is written.

> **Routing check:** This is a reference map, not a procedure. Reading it does not authorise you to act — complete `ROUTING.md`'s Route steps first.

> **Edit guard:** Changes to this file are system-layer work. Route to `projects/system/` and record the change in `session-log.md` before editing. Add a row here whenever a convention is added to `MarkdownConventions.md` or `knowledge/domains/authoring-guidelines.md`, or whenever a check is added to `scripts/validate.ps1`.

---

## Index

1. [How to Read This Map](#1-how-to-read-this-map)
2. [Markdown Conventions](#2-markdown-conventions)
3. [Domain Authoring Guidelines](#3-domain-authoring-guidelines)
4. [Flow Protocol Rules](#4-flow-protocol-rules)
5. [Checks Without a Stated Convention](#5-checks-without-a-stated-convention)
6. [Open Gaps, Ranked](#6-open-gaps-ranked)
7. [Version History](#version-history)

---

## 1. How to Read This Map

Three statuses, and the distinction between the last two is the whole point of this file:

| Status | Meaning |
|---|---|
| **Checked** | `scripts/validate.ps1` enforces it. The Check column names how, and whether a violation is an error or a warning. |
| **Judgement** | Cannot be mechanised, and saying so is a decision rather than an omission. These rely on the model and the human, and a Maintenance Pass (`knowledge/domains/authoring-guidelines.md` §8) is where they get reviewed. |
| **Gap** | Should be checked and is not. A real backlog item, not a design choice. §6 ranks them. |

**Why this file exists.** `scripts/validate.ps1` grew by accretion — several of its own comments say so, describing bug shapes that recurred independently in three places and checks that silently skipped a whole file. Nothing had ever audited the result for coverage, so conventions accumulated in `MarkdownConventions.md` and `authoring-guidelines.md` as though stating them were sufficient. In a two-month-old fork with 18 domains, eight documented conventions turned out to have no enforcement at all and had silently decayed — including three files the template itself ships.

An unenforced rule does not decay gracefully into a weaker rule. It decays to zero, and takes the credibility of neighbouring rules with it: a session that finds three conventions quietly violated stops treating the fourth as binding. The reverse error is just as real — a rule stated as absolute that reality has legitimate exceptions to, never discovered because nothing ever exercises it against real content. `MarkdownConventions.md` §4 was in exactly that state until 2026-09-10.

**Not a substitute for running the validator.** A green run means the Checked rows passed. It says nothing about the Judgement or Gap rows, and this template's own history shows a clean run coexisting with real violations of its own conventions.

---

## 2. Markdown Conventions

Source: `MarkdownConventions.md`.

| Rule | Section | Status | Check or reason |
|---|---|---|---|
| Frontmatter present and correct on domain/project instance files | §1 | Checked | Type and folder-name checksum, both errors |
| Header Status field vocabulary | §1 | Checked | Warning. Two vocabularies: project TODO files use Active/Retired, everything else uses Draft/Review Pending/Production/Retired |
| Root, flow and registry files carry no frontmatter | §1 | Gap | Violated by a shipped flow file until 2026-09-09 and caught by hand, not by a check |
| Frontmatter never carries a status or version field | §1 | Gap | Cheap to add alongside the existing frontmatter check |
| Title matches filename | §1 | Gap | Mechanical and unchecked |
| Date is ISO 8601 | §1 | Checked | Indirectly — the shared date pattern is required wherever a header line is parsed |
| Document Purpose is one to two sentences | §1 | Judgement | Sentence count is measurable; whether the scope is right is not |
| Retirement sets Status and adds the blockquote | §1 | Checked | Status consistency across description, knowledge and the index is checked; blockquote presence is not |
| Start all documents at 1.0 | §2 | Checked | Warning on a first Version History row below 1.0 |
| Version and date updated on every edit | §2 | Checked | Indirectly — header version must match the latest Version History row |
| Version History rows are append-only | §2 | Checked | Error, compared against the last commit |
| Version History required | §2 | Checked | Warning, scoped to root, knowledge and library documents |
| Version History is always the last section | §2 | Gap | Position is not checked, only presence |
| Index required over four sections | §3 | Checked | Warning. Domain description files are §3's own exception |
| Heading levels never skip | §3 | Gap | Mechanical and unchecked |
| Sections named for content, not workflow phase | §3 | Judgement | Requires knowing what the section is about |
| Right content type for the content | §3 | Judgement | Table versus list versus prose is an editorial call |
| Backslash escapes only in the two named cases | §4 | Gap | The rule itself was wrong until 2026-09-10; worth a check now that it is correct |
| No blank lines between list items | §4 | Gap | Mechanical and unchecked |
| No HTML entities | §4 | Gap | Mechanical and unchecked |
| Bold and italics used sparingly and for their stated purposes | §4 | Judgement | Editorial |
| No blank lines between table rows | §5 | Gap | Mechanical, and a real corruption risk, unlike most of this column |
| No empty table cells | §5 | Gap | Mechanical and unchecked |
| One topic per table, short headers | §5 | Judgement | Editorial |
| Fenced code blocks with language hints | §6 | Judgement | Whether a hint helps depends on the content |
| Internal links are relative, spaces encoded | §7 | Checked | Partially — links from domain files into sources and the reference index are resolved; other internal links are not |
| Validity and confidence signals used correctly | §8 | Judgement | Whether a claim is verified cannot be determined from the text |
| Writing style rules | §9 | Judgement | Editorial |

---

## 3. Domain Authoring Guidelines

Source: `knowledge/domains/authoring-guidelines.md`.

| Rule | Section | Status | Check or reason |
|---|---|---|---|
| Domain knowledge file is named knowledge.md | §1 | Checked | Existence is checked per domain |
| Header block and frontmatter | §2 | Checked | Same checks as §2 above |
| Index present, entries resolve, sections not orphaned | §3 | Checked | Both directions. The four structural sections are exempt from the orphan direction only |
| Executive Summary present | §3 | Gap | Mandated in a fixed position and never checked for existence |
| Required sections appear in the stated order | §3 | Gap | Presence is checked for some; order is not checked at all |
| Index entries name key concepts, not just titles | §3 | Judgement | Whether a description is useful for routing is a judgement |
| Every fact has one owning section | §4 | Judgement | Detecting a restated fact requires understanding it |
| Behavioural claims are hedged | §4 | Judgement | Distinguishing a hedged pattern claim from a bare trait claim is not mechanical |
| Cross-domain references are reciprocal | §5 | Checked | Warning, with scope-exclusion pointers worded differently from real drift |
| Signals applied per claim, not per section | §6 | Judgement | Same reason as §8 above |
| Version History row names the section changed | §7 | Judgement | Editorial |
| Maintenance Pass items | §8 | Judgement | A procedure, not a rule a file can violate |
| Domain size and Executive Summary heaviness | §8 | Checked | Three warning thresholds, deliberately lagging indicators rather than limits |
| Source manifest exists and rows resolve both ways | §9.1 | Checked | Errors for missing files, warnings for orphans |
| Every stored source is cited from the owning document | §9.1 | Gap | A stored source cited nowhere is invisible; a fork had five |
| Document classification runs on every qualifying upload | §9.1 | Judgement | Documented explicitly as having no mechanical backstop — a skipped classification leaves no artifact for a hook to inspect |
| Reference works registered, stored ones resolve | §9.2 | Checked | Errors and orphan warnings, both directions |
| Cornerstone promotion is human-gated | §9.3 | Judgement | A Hard Constraint on behaviour, not a file property |
| Referential integrity across sources and library | §9.4 | Checked | This is the check §9.4 describes |

---

## 4. Flow Protocol Rules

Source: `knowledge/flow/turn-protocol.md` and `knowledge/flow/operating-principles.md`.

| Rule | Source | Status | Check or reason |
|---|---|---|---|
| Turn numbers are sequential, never reused | turn-protocol §1 | Checked | Error |
| Every non-HUMAN turn ends with a STATUS line | turn-protocol §1 | Checked | Error. HUMAN turns are exempt by design |
| STATUS signal is in the known vocabulary | turn-protocol §2 | Checked | Warning, since forks legitimately add project-type signals |
| BLOCKED carries Reason, Need and Suggested contact | turn-protocol §3 | Checked | Error |
| Session log is append-only | operating-principles §2 | Checked | Error, compared against the last commit |
| CHECKPOINT and PROJECT COMPLETE field formats | turn-protocol §4, §5 | Gap | The STATUS line is checked; its required sub-fields are not |
| Knowledge-layer edits go through a flag | operating-principles §5 | Checked | Indirectly, by the pre-commit hook requiring the session log in the same commit |
| Findings route to the right flag type | operating-principles §5 | Judgement | Classifying a finding is the judgement the flag exists for |

---

## 5. Checks Without a Stated Convention

These run but map to no rule in the convention documents. They are structural preconditions rather than authoring conventions, and are listed so the map is complete in both directions.

- Required root files, entry point, flow files and git hook scripts all exist.
- `core.hooksPath` is actually set to `.githooks` in this clone — warning, because a fresh clone does not inherit it and the hooks are inert until it is.
- Nothing under `scripts/` or `.githooks/` contains a non-ASCII character — error. Stated in `Architecture.md` §6 (Script portability) rather than in a convention document, because it is a property of executable files rather than of authored prose. A single em dash stops a `.ps1` parsing under Windows PowerShell 5.1, which takes the validator down with it: this is the one check whose failure disables every other check in this file, so it is an error rather than a warning. The rationale sits in full above the check itself in `scripts/validate.ps1`, on the assumption that whoever trips it will be reading the script, not this map.
- No header line or Version History row carries a date in the future — warning. The first check in this repo that compares a date against *today* rather than against another date in the repo. Both are permanent append-only records, so a wrong date written into one cannot be corrected cleanly afterwards.
- No unchecked item in a project `TODO.md`, or in a domain's optional Open Items / Next Actions section, states a deadline that has already passed — warning. Deliberately narrow, and the narrowing was measured rather than assumed: against a 14-project fork the unscoped form produced 52 warnings of which roughly six were real, because the dominant shape is a date recording when an item was *raised*, not a deadline. Requiring a deadline cue word and excluding dates that follow a recording verb took it to 8. Its cue list is English and a fork working in another language will need to extend it.
- Every domain has a description and a knowledge file.
- The domain index's Last Updated column is not older than the domain's own files.
- A retired project no longer has a live routing row.

---

## 6. Open Gaps, Ranked

Highest value first. Ranked by whether the rule is mechanically decidable, how badly a violation renders, and whether a fork has actually been observed hitting it.

1. **No blank lines between table rows, and no empty cells** (§5). Both mechanically decidable, and the first silently corrupts rendering rather than merely looking untidy.
2. **Executive Summary present** (authoring-guidelines §3). Mandated, always in the same place, trivially checkable, and currently invisible if missing.
3. **Every stored source is cited from its owning document** (§9.1). The reverse direction is already checked; a fork had five stored sources cited nowhere at all.
4. **Root, flow and registry files carry no frontmatter, and frontmatter never carries status or version** (§1). Both extend the frontmatter check that already exists.
5. **Version History is the last section** (§2). Presence is checked; position is not.
6. **Backslash escapes outside the two named exceptions** (§4). Worth adding now that the rule is correct — a check written against the old wording would have flagged correct content.
7. **Heading levels never skip, no HTML entities, title matches filename** (§1, §3, §4). Mechanical, low individual value, cheap in aggregate.
8. **Aged `[TIME-SENSITIVE]` claims** (`MarkdownConventions.md` §8). The signal already means "re-verify before relying on this" and nothing records when it last was, so a warning on a file that has not been touched in N months is the obvious complement to the passed-date check in §5. Ranked last deliberately: this template contains no real `[TIME-SENSITIVE]` claim at all — only the instruction text describing the signal — so there is nothing here to calibrate N against, and a threshold picked without calibration is how a check becomes noise. Note for whoever builds it: the fork that raised this writes the signal as an emoji as well as text, and that emoji does not exist in this template. Key on the text tag.

---

## Version History

| Version | Date | Summary |
|---|---|---|
| 1.0 | 2026-09-10 | Initial creation. Maps every convention in `MarkdownConventions.md`, `knowledge/domains/authoring-guidelines.md`, `turn-protocol.md` and `operating-principles.md` to Checked, Judgement or Gap, lists checks with no corresponding stated rule, and ranks the open gaps. Built by enumerating the convention documents first and reading `scripts/validate.ps1` against that list, which is the ordering that surfaces gaps rather than confirming coverage. Relayed via `[FLAG FOR UPSTREAM]` from `familien-boe`, where eight documented conventions had no enforcement and had silently decayed. See `projects/system/session-log.md` Turn 38. |
| 1.1 | 2026-09-10 | §5 gained the non-ASCII check on `scripts/` and `.githooks/` — the first check registered here whose own failure mode is disabling every other check in this file. See `Architecture.md` §6 (Script portability) and `projects/system/session-log.md` Turn 39. |
| 1.2 | 2026-09-10 | §5 gained the two date checks that compare repo content against today rather than against other repo dates — future-dated header and Version History rows, and passed deadlines in open items. §6 gained the deliberately deferred aged-`[TIME-SENSITIVE]` check as gap 8, with the reason it cannot be calibrated here. See `projects/system/session-log.md` Turn 41. |
