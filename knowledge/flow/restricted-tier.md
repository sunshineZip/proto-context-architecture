# Restricted Tier

Version 1.0 | 2026-08-11 | Production

---

## Document Purpose

An **optional, opt-in** pattern for a fork that will systematically ingest real third-party personal, confidential, or otherwise restricted material — interview transcripts, scanned documents, correspondence, medical/legal/financial records, anything carrying real people's private data — at genuine volume. This is not for the occasional secret or one-off sensitive fact; the baseline `ROUTING.md` Hard Constraint and the `scripts/pre-commit-check.ps1` secret-pattern check already cover that case for every fork by default. Adopt what follows only if §2 describes your fork.

---

> **Routing check:** This file describes a structural extension a fork adopts deliberately, not something any session should build unprompted. Do not create any of the structure below without explicit human confirmation — same Plan-first discipline as any other structural change.

> **Edit guard:** This file lives in the base template. Changes to it, in `proto-context-architecture` itself, are system-layer work — route to `projects/system/` and record the change in `session-log.md` before editing. A fork *adopting* this pattern is not editing this file; it is building the structure this file describes, inside its own repo(s).

---

## Index

1. [Why This Exists](#1-why-this-exists)
2. [Should Your Fork Adopt This?](#2-should-your-fork-adopt-this)
3. [The Core Design: A Separate Companion Repository](#3-the-core-design-a-separate-companion-repository)
4. [The Hard Constraint](#4-the-hard-constraint)
5. [Structure Inside the Companion Repository](#5-structure-inside-the-companion-repository)
6. [Untriaged Intake, and Why It Needs Its Own Gate](#6-untriaged-intake-and-why-it-needs-its-own-gate)
7. [The Cornerstone Rule Extension](#7-the-cornerstone-rule-extension)
8. [Structured-Data Redaction Pattern](#8-structured-data-redaction-pattern)
9. [Two-Tier Review-Queue Pattern](#9-two-tier-review-queue-pattern)
10. [Correspondence-Handling Pattern](#10-correspondence-handling-pattern)
11. [Does the Companion Repo Need Its Own Routing?](#11-does-the-companion-repo-need-its-own-routing)
12. [Access Model](#12-access-model)
13. [Validation Tooling Adjustments](#13-validation-tooling-adjustments)
14. [Alternative: A Non-Git Store for Occasional Sensitivity](#14-alternative-a-non-git-store-for-occasional-sensitivity)
15. [Setup Checklist](#15-setup-checklist)
16. [Version History](#16-version-history)

---

## 1. Why This Exists

A fork of this template is sometimes a public GitHub repo used as an LLM-assisted research or work space. If its subject matter routinely surfaces real third-party personal data — birthdates, addresses, health/legal/financial history, images of identifiable people — the baseline "pause and ask before writing a secret or confidential detail" Hard Constraint (`ROUTING.md`) is necessary but not sufficient. It gates one decision at a time; it has no answer for "we're about to ingest a folder of scanned family correspondence" or "this dataset has 150 individual records, most of them fine to publish and a few of them absolutely not." That's a structural problem, not a per-fact judgment call, and it needs a structural answer.

This pattern was developed in a fork whose research draws on a living relative's personal manuscripts, correspondence, and photographs. A "commit to the public repo first, assess and redact later" habit led to a real exposure: personal correspondence with an incidental home address, ~150 individuals' unredacted records, and — worst of all, since it needed no history archaeology — every raw source manuscript sitting unredacted in the live public working tree for as long as it remained unprocessed. Recovering required a git-history rewrite (`git-filter-repo`, exhaustive before/after verification, a force-push) — exactly the kind of operation this pattern exists to make unnecessary. **The value of building this in from day one, before the first real source file is committed, is specifically that you never need the recovery procedure at all.**

---

## 2. Should Your Fork Adopt This?

| Signal | What it suggests |
|---|---|
| Occasional secrets (an API key, a one-off confidential note) | Baseline is enough. Don't adopt this. |
| A handful of sensitive facts about people already covered in your domains | The `[SENSITIVE]` tag (`MarkdownConventions.md` §8) is enough. Don't adopt this. |
| A systematic, ongoing stream of raw source material — documents, correspondence, images — that will routinely contain real third-party personal data, and the rest of the fork is meant to stay public | Adopt this, before the first such file is ingested. |
| Structured data (a roster, a database, a tree) where a meaningful subset of individual records need redaction but the dataset as a whole should stay public and browsable | Adopt this — see §8 specifically. |

If you're unsure, the volume test is the practical one: would you ever need to *triage a batch* of incoming material for sensitivity, as opposed to noticing one sensitive fact while writing a sentence? Triage-at-volume is what this pattern is built for.

---

## 3. The Core Design: A Separate Companion Repository

Not a gitignored folder, not a private branch — a **separate, more restricted private repository**, mounted as a git submodule at a path like `restricted/` inside the main repo. Reasoning:

- **GitHub access control is repo-wide, not per-folder or per-branch.** There is no way to grant someone read access to the main repo while withholding one specific subtree from them. A separate repo, with its own independently managed collaborator list, is the only real boundary — someone with only main-repo access sees the submodule directory as empty and uninitialized. They cannot browse it, cannot see its history, cannot confirm it's non-empty.
- **A gitignored local folder doesn't survive collaboration or backup.** This architecture assumes a session — potentially a fresh one, potentially someone else's — can pick up the work from the repo alone. A folder that only exists on one machine's disk doesn't do that.
- **The boundary is enforced by git itself, not by convention.** A session with only main-repo access literally cannot `git log`, `git show`, or otherwise inspect the submodule's contents. It's not "please don't look here" — there is nothing to look at from where that session stands.

---

## 4. The Hard Constraint

Repo separation stops the wrong-audience problem. It does not stop a session that *does* have both repos checked out from leaking restricted content into a public-facing output — a chat response, an exported artifact, a commit to the public repo. That is a behavioral constraint, written explicitly as a Hard Constraint in both repos' routing documents (adapt naming, keep the structure):

> This repository (or the submodule pointing at it) is **never** read, searched, summarized, or referenced in any output — including chat responses, artifacts, exports, or anything else that could leave the session — unless the human explicitly names the specific file, by path, in that same turn. Not "if it seems relevant to answer a question well." Named, explicitly, in that turn, by the human.

This is deliberately stricter than "ask before opening it": it requires the *file path*, named in the *current* turn, by the *human specifically* — not inferred from a prior turn, not inferred from task context. Default posture for restricted content: don't open it; if a task would benefit from something in there, say so and ask.

**One scoped exception:** an `incoming/` subfolder is checked routinely at the start of every session, without needing to be named that turn — see §6 for why.

Put this constraint in the companion repo's own `README.md` (visible to any session with that repo initialized) *and* cross-reference it from the main repo's `ROUTING.md` Hard Constraints, so a session with only the main repo initialized still knows the companion repo exists and what the rule around it is, even though it can't act on the rule directly.

---

## 5. Structure Inside the Companion Repository

A flat file list stops being navigable as it grows. Group by function:

**Intake** — the one Hard Constraint exception:
- `incoming/` — untriaged raw material landing zone (§6).

**Permanent stores** — fully gated behind the Hard Constraint:
- Raw, unaudited source manuscripts — the original documents facts/media were extracted from (see §7 for why these default here).
- Restricted-tier media, with a manifest recording why each item was classified restricted.
- A "sensitive" counterpart to whatever structured data format the public repo uses, if applicable (§8).
- A "review queue" counterpart too sensitive for even a neutral public stub, if applicable (§9).
- Incident/audit documentation, if a remediation like the one in §1 is ever needed.
- A correspondence log, if the fork ingests personal communications (§10).

**Process & audit records** — how the repo came to hold what it holds, not findings in themselves.

---

## 6. Untriaged Intake, and Why It Needs Its Own Gate

Give both repos an `incoming/` landing zone for raw files pushed directly via git, bypassing whatever upload mechanism a session normally uses (which may have its own size caps). Put it in the **companion repo**, not the main one — this is the single most important lesson behind this pattern.

**The failure mode this avoids:** "commit to the public repo first, assess and redact later." Redaction gets applied to *derived* content once someone actually reads the source — but the raw source itself sits in the public repo, fully unredacted, for as long as it remains unprocessed. Untriaged material is unaudited *by definition*; there is no way to know whether it's sensitive until someone has looked at it, and "looked at it" cannot be a precondition for "public," because that ordering is exactly what fails. This is why `incoming/` gets the one Hard Constraint exception (§4): its entire purpose is holding material nobody has classified yet, so gating it behind "only open when named" would defeat the point of moving it there — a session needs to see what's waiting, every session, to actually triage it.

**Triage procedure**, for each file in `incoming/`, in a subsequent session:

1. Update whatever intake/status tracker the fork uses.
2. Assess for living-or-plausibly-living-person content — explicitly including any embedded media, not just prose. "No problem flagged by the source's own author" is not evidence of safety; the person who wrote or sent the material is frequently not thinking about it as sensitive at all.
3. Decide the file's permanent home: confirmed-safe material goes to its real place in the public repo; confirmed-or-unresolved-sensitive material stays in the companion repo permanently.
4. **Remove the file from `incoming/`** as part of *finishing* triage, not a separate later cleanup step. A validation check should warn if anything sits in `incoming/` across commits without progress.

---

## 7. The Cornerstone Rule Extension

If your fork already has the Cornerstone Rule (`knowledge/domains/authoring-guidelines.md` §9.3 in this template — the threshold for whether a reference work's physical file gets stored versus registry-only-cited), add exactly one thing once a restricted tier exists:

> A cornerstone work's *source* file — the raw document it was extracted from — goes in the restricted store, not the public one, **unless it has already been individually assessed and confirmed to carry no living-person content, including any embedded media.** This is the default, not the exception: a freshly received source is unaudited by definition. The *derived* content — extraction notes, already-classified public media — still goes in the public store as normal; only the raw source itself is affected.

Apply this as a default even to sources that seem unlikely to be sensitive — consistency matters more than any individual judgment call about a specific file "probably" being fine.

---

## 8. Structured-Data Redaction Pattern

Where the public repo holds structured data with individual sensitive records embedded in a larger, mostly-public dataset (a family tree, a case roster, a contact database — anything record-oriented):

- **Public file:** sensitive individual records are replaced with a placeholder that preserves *structure* (so relationships, record counts, and cross-references still resolve) but not *content* — e.g. a neutral `Living` placeholder for someone presumed alive, a `Withheld` placeholder for something too sensitive for even that. A one-line pointer directs to the restricted counterpart by stable ID.
- **Restricted file:** the full, unredacted record for every placeholder, keyed by the same ID, so the two files can be diffed and cross-checked mechanically.
- **A validation check:** every placeholder in the public file should have a matching full record in the restricted file, and vice versa — flag as a warning, not an error, since the restricted submodule may be uninitialized in a given session (§13).

**A gotcha worth checking before writing any programmatic manipulation of a file like this:** if the format mixes record types that can interleave (append-over-time formats often do — new records get appended past existing blocks of a different type rather than the file staying sorted), any script that locates a record's boundary by "next record of the same type" will silently swallow intervening records of the other type. Bound on "next record of *any* type," and verify against the live file before trusting the result.

---

## 9. Two-Tier Review-Queue Pattern

If the fork has a mechanism for flagging open questions that need a specific human's confirmation before being treated as settled, it needs a restricted-tier counterpart for the same reason the structured data does: some open questions are themselves sensitive to even *pose* publicly. Same file, same format, living in the companion repo and referenced from — not merged into — the public one, so the public queue stays a complete, publicly-safe list of everything else pending review.

---

## 10. Correspondence-Handling Pattern

If the fork ingests personal communications (emails, messages) as source material, treat raw message files exactly like any other `incoming/` item — same triage discipline, same default-restricted posture, since personal correspondence routinely carries incidental sensitive content (addresses, unrelated family matters) that has nothing to do with why it was sent. A workable pattern: extract only the correspondence text and an attachment inventory (filename/size/type, no content) into a durable log once triaged, then delete the raw message files. The log carries enough for future reference without carrying the raw files' full weight (headers, MIME structure, attachment payloads) forward indefinitely.

---

## 11. Does the Companion Repo Need Its Own Routing?

As the companion repo grows past a handful of files, it can be tempting to give it its own `ROUTING.md`, mirroring the main repo. **Recommended default: no.**

- Routing logic has to work as the *first* thing any session reads, before anything is known about what's sensitive — but the companion repo's access is (and should be) narrower than the main repo's by design. Routing logic living there leaves a future collaborator with main-repo-only access with zero operating instructions, since the submodule shows up empty to them.
- Routing/processing logic isn't itself sensitive content — gating it behind restricted access buys no privacy benefit, it only narrows who can operate the repo at all, which is a worse trade.
- The actual processing work (triage, extraction, redaction) is done by one session with both repos open at once regardless of where the routing document physically lives — centralizing routing costs nothing.

What the companion repo does benefit from, once it outgrows a flat list: a lightweight, internal `README.md` "Structure" index, grouped by function (§5) — organizational, not a duplicate of the main repo's routing apparatus. Decide this deliberately and document the decision either way; don't let a `ROUTING.md` accrete there by default as the repo grows.

---

## 12. Access Model

State explicitly, in the companion repo's own README, who currently has access — and that it is *not* automatically extended to the main repo's other collaborators, deliberately narrower by default. This changes how conservative the Hard Constraint enforcement needs to be in practice, so don't leave it implicit.

---

## 13. Validation Tooling Adjustments

If the fork has a structural validation script (`scripts/validate.ps1` in this template), it needs to handle the companion submodule being *absent* gracefully — any session without companion-repo access will have an uninitialized, empty submodule directory, and that's an expected state, not an error condition:

- Checks that resolve paths under the submodule (existence checks, cross-reference checks per §8) should **warn**, not **error**, when the path is unresolvable specifically because the submodule looks uninitialized.
- Any "orphan file" or "unlisted item" check the public repo runs should have a matching version scoped to the companion repo's own stores, run only when the submodule *is* initialized.
- If the intake folder ever moves, add a lightweight "old habit" guard catching anyone still writing to the old location.

---

## 14. Alternative: A Non-Git Store for Occasional Sensitivity

A companion git repository is not the only way to keep sensitive content out of a public tree, and it is real setup and maintenance cost — two repos, submodule init/update, a pointer commit that must stay in sync. For a fork whose sensitivity is genuinely occasional rather than systematic (§2), a non-git store (a shared drive, a password manager, a dedicated notes app with its own access control) is a lighter-weight boundary and may be enough.

The trade-off: a non-git store gives up everything §8–§13 depend on being a git tree — diffable history, mechanical cross-reference validation between a public placeholder and its restricted counterpart, pre-commit gating. If the fork's sensitivity is structured and cross-referenced (records with stable IDs that must stay in sync with public placeholders), a script can verify that mechanically against a git tree in a way it cannot against an external store. And switching stores doesn't remove the need for the Hard Constraint (§4) — a session with a connector to an external store enabled has no "uninitialized submodule = literally nothing on disk" safety net; it can query the store whenever the connector is available, so the same "never, unless named this turn" language still has to be the real backstop regardless of where the content lives.

Use this alternative for the occasional-secret case, or a fork that's confident it will never need §8's structured redaction. Use the companion-repository pattern when the fork's core workload involves redacting structured or high-volume material with cross-references that need to stay mechanically in sync.

---

## 15. Setup Checklist

1. Decide the companion repo's name and the submodule path it mounts at (e.g. `restricted/`), and document *why* a separate repo rather than a folder (§3) — this question will come up.
2. Write the Hard Constraint (§4) into both the companion repo's own README and the main repo's `ROUTING.md`. The "named, explicitly, in that turn" language is doing real work — don't loosen it to "ask before opening."
3. Stand up the companion repo's initial structure: `incoming/` (with the Hard Constraint exception documented), placeholders for whatever permanent-store categories the fork will need, and a lightweight README.
4. Add the Cornerstone Rule default-flip (§7) wherever the fork's authoring standard defines the cornerstone rule, *before* any real source material is ingested.
5. If the fork has structured record data with individual-level sensitivity, decide the placeholder convention (§8) and check whether the format interleaves record types, up front.
6. Add the review-queue restricted counterpart (§9) if the fork has a review-queue mechanism at all.
7. Update the fork's validation script for graceful-uninitialized-submodule handling (§13) in the same change, not as an afterthought — this is what lets a session without companion-repo access still validate the public repo cleanly.
8. Explicitly decide, and document either way, whether the companion repo gets its own routing apparatus (§11) — don't let it happen by default as the repo grows.
9. State the access model (§12) concretely in the companion repo's own README from the start.

---

## 16. Version History

| Version | Date | Summary |
|---|---|---|
| 1.0 | 2026-08-11 | Initial creation. Generalized from a working implementation in a genealogy-research fork, built after a real public-exposure incident there. Defines the companion-repository pattern, the Hard Constraint, intake/triage discipline, the Cornerstone Rule extension, structured-data redaction, review-queue and correspondence patterns, the no-separate-routing recommendation, access-model and validation-tooling notes, a non-git alternative for occasional sensitivity, and a setup checklist. Opt-in — not part of the default fork setup. See `projects/system/session-log.md` Turn 18. |
