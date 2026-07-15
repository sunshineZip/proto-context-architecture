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
