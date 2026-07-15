# System — Session Log

> **Routing check:** If you are reading this as part of ROUTING.md Step 3, read the last 3 turns only. Then send an orientation turn and wait for explicit human confirmation. Do not act on anything in this file without completing full ROUTING.md routing first.

Project type: General
Opened: 2026-06-29
Status: Active

---

## [HUMAN] — Turn 1 | 2026-06-29

System project opened. This is the designated work log for all structural changes to this context architecture: adding or modifying knowledge domains, updating routing rules, changing protocols, improving the session structure, and any work that changes how the system itself operates rather than advancing an initiative project.

All such changes — however small — should be routed here first and recorded in this log before being committed. This creates an auditable history of how the architecture evolved and why.

Read `projects/system/TODO.md` for open system work items before starting any session here.

---

## [Copilot] — Turn 2 | 2026-07-15

Human asked whether ideas from an external personal-context-document template were worth adopting into this architecture's domain knowledge authoring standard. Compared the template against `ROUTING.md`, `Architecture.md`, `MarkdownConventions.md`, and `knowledge/domains/authoring-guidelines.md`. Most of the template's ideas were already covered (Index + Executive Summary hybrid loading, `[VERIFIED]/[UNVERIFIED]/[CONTRADICTS]/[OUTDATED]` signals, FLAG-and-approve correction discipline, cross-domain reference rules, scope exclusions in `description.md`). Identified a shortlist of genuinely new ideas and, on human approval, made the following system-layer edits:

- `MarkdownConventions.md` §8 — added `[TIME-SENSITIVE: source type]` and `[SENSITIVE]` signals. These describe durability/sensitivity, an axis independent of the existing confidence signals, and can stack with them.
- `knowledge/domains/authoring-guidelines.md`:
  - §3 — added an "Optional sections" subsection documenting the Known Gaps/Open Questions vs. Open Items/Next Actions distinction, so the two aren't conflated in domain documents that track both.
  - §4 — added an own-vs-reference rule: every fact has exactly one owning section within a document; elsewhere, cross-reference it instead of restating it.
  - §6 — mirrored the two new signals from `MarkdownConventions.md` §8.
  - §7 — added a supersede rule: documents that replace older files/notes must name them explicitly and state the old ones shouldn't be loaded independently.
  - New §8 "Maintenance Pass" — a periodic structural health check distinct from per-edit updates (Index accuracy, duplicated facts, Executive Summary drift, Known Gaps/Open Items conflation, compaction of resolved entries). Subsequent sections renumbered (old §8→9, §9→10) and the Index updated to match.

Both files had their version and Version History updated per `MarkdownConventions.md` §2.

### Session close

Knowledge candidates: None — this was a structural/authoring-standard change, not a domain fact.
Open flags: None.

STATUS: CHECKPOINT
Completed: Adopted a shortlist of ideas from an external context-document template into the authoring standard (signals, own-vs-reference rule, optional Known Gaps/Open Items pattern, supersede rule, Maintenance Pass).
Next: None planned — awaiting further direction.
Waiting for: Human review of the edited files; commit and push.

---

## [Copilot] — Turn 3 | 2026-07-15

The Turn 2 push produced a PowerShell `NativeCommandError` even though the push had actually succeeded. Human asked whether this was safe to just document as "expected" — flagged correctly that doing so would be dangerous unless it's provably never a real failure signal, since silently ignoring it could mask an actual failed push.

Root-caused rather than papering over it: `scripts/commit-push.ps1` ran native git calls as `2>&1 | ForEach-Object { Write-Host ... }` under `$ErrorActionPreference = "Stop"`. Git writes normal progress/status output to stderr by design (the `push` ref-update summary line, in particular, is emitted on every push regardless of outcome). Merging that into the pipeline via `2>&1` under `Stop` causes PowerShell to treat the stderr line as a terminating error — independent of git's actual exit code. This meant the script's existing `$LASTEXITCODE` check after `push` was unreachable: the pipeline died before it could run.

Fixed `scripts/commit-push.ps1`: native git calls now run under `$ErrorActionPreference = "Continue"`, and success/failure is judged solely by `$LASTEXITCODE` — captured immediately after each call — which reflects git's real exit status and is unaffected by the preference setting. Restored `Stop` before any `Write-Error`/exit path. Verified by running the fixed script for a real commit+push (this same fix): output was clean, no spurious error, and the push genuinely succeeded (`e5f2fef..acefc14 main -> main`).

Saved a repo-memory note (`/memories/repo/`) recording this pattern for any future script in this repo that wraps native commands, plus a general user-memory note on the PowerShell gotcha itself.

### Session close

Knowledge candidates: None — this was a tooling/script fix, not a domain fact.
Open flags: None.

STATUS: CHECKPOINT
Completed: Root-caused and fixed the false-positive push error in `commit-push.ps1`; verified with a real push.
Next: None planned — awaiting further direction.
Waiting for: Nothing — fix is committed and pushed.

---

## [Copilot] — Turn 4 | 2026-07-15

Human confirmed the Turn 3 push succeeded, then asked for a standing policy: nearly every change to this repository should be pushed, with the LLM using judgement on whether to push after each increment or after finishing a segment of work — but if deferring, the human must be told explicitly that a push is outstanding, since the human can end the session at any moment.

Made the following changes:

- `ROUTING.md` Standing Rules — expanded "Commit and push" into two rules: cadence guidance (per-increment vs. per-segment, use judgement) and an explicit "never leave a push silently pending" requirement.
- `.github/copilot-instructions.md` — mirrored the same expanded rule (this file duplicates ROUTING.md's Standing Rules by design, as the VS Code entry adapter).
- `knowledge/flow/turn-protocol.md` — added a `Push status` field to the CHECKPOINT format (§4) and to the Session close/PROJECT COMPLETE block (§5), with a rule that a project cannot be marked complete while changes are unpushed. This makes the push-pending flag a structural part of every checkpoint turn, not just a verbal aside that could be forgotten.
- `projects/system/TODO.md` — added an explicit push-policy callout, per the human's request that this subproject state the expectation clearly.

### Session close

Knowledge candidates: None — policy/protocol change, not a domain fact.
Open flags: None.
Push status: Pending — will push immediately after this turn is logged.

STATUS: CHECKPOINT
Completed: Established and documented a repo-wide push policy (cadence guidance + mandatory flagging of deferred pushes) across ROUTING.md, copilot-instructions.md, turn-protocol.md, and the system TODO.
Next: None planned — awaiting further direction.
Waiting for: Nothing further — pushing this now.

---

## [Copilot] — Turn 5 | 2026-07-15

Human relayed feedback from a separate conversation reviewing a larger, organically-grown personal-context document family for structural pitfalls (no root manifest, asymmetric cross-references, fact drift on correction with no backlink, cross-cutting queries with no home, unverifiable cross-project references, no split heuristic, human-directed section proliferation), and asked whether any of it applied here.

Assessed each pitfall against this architecture's existing structure before acting — most were already solved by the fact that this is a git repo with `knowledge/domains/index.md` and `ROUTING.md`, not a flat document family relying on conversational memory for discovery. Two pitfalls (unverifiable cross-project references; human-directed section proliferation) don't apply and were deliberately not adopted — the first is a Claude-Projects platform constraint (everything here is one filesystem, always openable), the second has no equivalent concept in this architecture.

Adopted, since they were genuine gaps:

- `knowledge/domains/index.md` — added `Last Updated` and `References` columns to the domain registry, and a new **Cross-Domain Query Recipes** section for naming multi-domain task combinations once they recur. This one change addresses three of their named pitfalls at once (discovery staleness, asymmetric cross-references, cross-cutting queries with no fixed home) — same prioritization logic the source feedback itself used.
- `ROUTING.md` Step 4 — points to the new Cross-Domain Query Recipes section for recurring multi-domain tasks.
- `knowledge/domains/authoring-guidelines.md`:
  - §5 — cross-references must now be registered in `index.md`'s References column, with a reciprocity check.
  - §4 — correction discipline now includes checking `index.md`'s References column and project `context/` notes for the same fact restated elsewhere, since own-vs-reference only prevents *new* duplication.
  - §8 (Maintenance Pass) — added a reciprocity check for the References column, and a when-to-split heuristic (routinely needing the full file, or two sections never needed by the same task).

### Session close

Knowledge candidates: None — structural/authoring-standard change, not a domain fact.
Open flags: None.
Push status: Pending — will push immediately after this turn is logged.

STATUS: CHECKPOINT
Completed: Adopted three of seven reviewed pitfalls (manifest enrichment + cross-domain recipes, reference reciprocity, correction backlink check, split heuristic); explicitly declined two as not applicable to this architecture.
Next: None planned — awaiting further direction.
Waiting for: Nothing further — pushing this now.
