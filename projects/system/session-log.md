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

---

## [Claude] — Turn 6 | 2026-07-16

Human relayed a design worked out in a separate conversation for storing raw evidentiary sources (insurance policies, contracts) and deep wells (textbooks, manuals) alongside domain knowledge — neither previously had a home in this architecture. Assessed it against `ROUTING.md`, `Architecture.md`, `MarkdownConventions.md`, and `knowledge/domains/authoring-guidelines.md` before building, per the proposal's own request, and presented a phased plan first (system-layer work touching 4 files, per the Plan-first rule).

**Structure adopted, close to the proposal as written:**

- Per-domain `knowledge/domains/[name]/sources/` (evidentiary sources — small, definitive, always stored) with a `manifest.md` registry, created only for domains that actually have sources.
- Top-level `library/` (deep wells — large, incrementally mined, possibly cross-domain) with `reference-index.md` as an always-populated registry and `deep-wells/` for the physical files of cornerstone-status works only.
- The cornerstone-promotion decision (store the physical file, or registry-only) is human-gated, reusing the existing knowledge-promotion flag pattern (`operating-principles.md` §5) rather than inventing new machinery.
- Citing either kind of source uses a plain relative link plus the existing `[VERIFIED: source]` signal — no new link syntax or signal, per `MarkdownConventions.md` §7–8 as already written.

**Two corrections made against the proposal's own draft**, surfaced to the human rather than silently fixed:
1. Its `library/reference-index.md` citation example (`../../library/reference-index.md`) was one directory level short — from `knowledge/domains/[name]/knowledge.md`, the correct relative path is `../../../library/reference-index.md` (name → domains → knowledge → repo root). Verified against the existing `../other-domain/description.md` cross-domain link example in `authoring-guidelines.md` §5 to confirm the level-counting.
2. `README.md`'s existing folder-structure code block had a pre-existing formatting break in the `projects/` tree (three rows collapsed onto one line, missing newlines) — fixed in the same edit since it sat directly in the block being extended.

**Files changed:**

- `knowledge/domains/authoring-guidelines.md` (1.2 → 1.3) — new §9 "Evidentiary Sources & Deep Wells" (§9.1 sources, §9.2 deep wells, §9.3 cornerstone rule, §9.4 referential-integrity tooling), inserted before "What Does Not Belong" per the existing Maintenance Pass precedent — old §9 → §10, old §10 → §11. Index updated to match. Added a `sources/` check to the Maintenance Pass (§8) and a source/deep-well resolution line to the Quick Checklist (§11).
- `ROUTING.md` (1.3 → 1.4) — Step 4 now excludes `sources/` and `library/deep-wells/` from routine routing (opened only when a task names the specific file); Hard Constraints gained the cornerstone-confirmation rule next to the existing "do not edit `knowledge/` directly" line; Quick Task Guide gained an entry for adding a source or deep well.
- `Architecture.md` (1.0 → 1.1) — §2 File Structure diagram and §3 Two-Tier Knowledge Model updated for `sources/` and `library/`; knowledge-promotion procedure notes the additional cornerstone gate.
- `README.md` (1.1 → 1.2) — folder-structure diagram updated to match, plus the formatting fix above.
- `library/reference-index.md` — new file, empty registry (no deep wells registered yet), same pattern as `knowledge/domains/index.md` existing before any real domains do.

**Referential-integrity tooling (proposal's open question, resolved this turn):** asked the human to choose between extending `validate.ps1` (PowerShell, consistent with existing tooling) or a separate Python script. Human wanted a solution that works both from Claude Code on the web and from Copilot locally in VS Code. Rather than maintaining two parallel implementations, extended `validate.ps1` — the existing tooling language — and closed the environment gap instead: added `.claude/hooks/session-start.sh` (registered via `.claude/settings.json`) that installs PowerShell (via Microsoft's official apt repo) on Claude Code web/remote sessions only (`$CLAUDE_CODE_REMOTE` gate), idempotently, and no-ops locally where Windows PowerShell is already native. Both the hook and the extended script were tested end-to-end in this session: the hook was run from a clean state (PowerShell fully removed) and completed a real install in ~17s, and from an already-installed state it no-ops in ~2ms; `validate.ps1`'s new checks were run against a fixture directory covering every case (missing manifest, orphan file on disk, orphan manifest row, broken source link, broken deep-well `Location`, orphan deep-well file, broken reference-index anchor) and correctly flagged each one with zero false positives on the matching clean fixture.

`validate.ps1` additions: for each domain with a `sources/` folder, cross-checks `manifest.md` rows against the files actually on disk in both directions; for `library/reference-index.md`, checks every `Stored: yes` entry's `Location` resolves to a real file and every file in `library/deep-wells/` is claimed by some entry; for every domain's `knowledge.md`/`description.md`, checks that relative links into `sources/` or `library/reference-index.md` resolve to a real file or a real heading.

### Session close

Knowledge candidates: None — structural/authoring-standard change, not a domain fact.
Open flags: None.
Push status: Pushed — directly to `main`.

STATUS: CHECKPOINT
Completed: Added the evidentiary-sources/deep-wells convention (`sources/`, `library/`, cornerstone rule) across `authoring-guidelines.md`, `ROUTING.md`, `Architecture.md`, and `README.md`; created the empty `library/reference-index.md` registry; extended `scripts/validate.ps1` with referential-integrity checks and added a `.claude` session-start hook so the same PowerShell tooling runs identically from Claude Code on the web and from local VS Code + Copilot.
Next: None planned — awaiting further direction.
Waiting for: Nothing further — pushed this turn.

---

## [Claude] — Turn 7 | 2026-07-16

Follow-up fix, no new content from the human this turn. After Turn 6 was pushed, ran `validate.ps1` against a fresh clone of the actual pushed repo as a final end-to-end sanity check (beyond the fixture-based testing already done in Turn 6) — it failed with a false positive: `library/reference-index.md entry '<slug-in-kebab-case>' points Location at 'library/deep-wells/<filename>', which does not exist`.

Root cause: `library/reference-index.md`'s own "Registered Deep Wells" section documents the entry template as an illustrative example inside a fenced ` ``` ` code block (per `authoring-guidelines.md` §9.2's own spec for this file). The script's heading/field regexes had no way to distinguish that documentation example from a real registered entry — it parsed `## <slug-in-kebab-case>` and `**Stored:** yes / no` (matching on the literal leading "yes") as if they were live registry content.

Fixed `scripts/validate.ps1`: added a `Remove-CodeFences` helper (strips ` ``` `-fenced blocks via a non-greedy regex) and applied it before all four places that scan markdown prose for headings, `**Stored:**`/`**Location:**` fields, table rows, or links — `sources/manifest.md` tables, `reference-index.md` entry-block parsing, `reference-index.md` heading collection (for anchor-checking), and domain `knowledge.md`/`description.md` link scanning. This is the general fix — the same class of false positive would otherwise recur for any domain's `knowledge.md` that includes a fenced-code documentation example referencing `sources/` or `reference-index.md` syntax, not just this one file. Re-verified clean (0 errors, 0 warnings) against both the existing fixture (no regression) and a fresh clone of this repo.

### Session close

Knowledge candidates: None — tooling/script fix, not a domain fact.
Open flags: None.
Push status: Pushed — directly to `main`.

STATUS: CHECKPOINT
Completed: Fixed a code-fence false positive in the Turn 6 `validate.ps1` extension, caught via real-repo end-to-end testing rather than fixture testing alone; verified with a clean re-run.
Next: None planned — awaiting further direction.
Waiting for: Nothing further — pushed this turn.

---

## [Claude] — Turn 8 | 2026-07-16

Two items, both prompted from a parallel session working in `familien-boe` (a fork of this template) rather than from a request made directly here.

**Retroactive note — an unlogged fix from earlier today:** while porting this repo's `.claude/hooks/session-start.sh` into `familien-boe`, discovered that both repos had the same defect — the file was pushed as mode `100644` (non-executable) rather than `100755`, because the GitHub Contents API used for all of Turn 6/7's pushes has no way to set the executable bit, and a SessionStart hook needs `+x` to run as a direct command. Fixed here via a direct git commit (`chmod +x` + push, since the Contents API can't express a mode-only change either) at the time, but that fix — unlike its `familien-boe` counterpart — was never actually logged in this file. Recorded now for the audit trail: commit changed `.claude/hooks/session-start.sh` from `100644` to `100755`, no content change. Verified via a fresh clone that the mode is now correct and `validate.ps1` still passes clean.

**New this turn:** `familien-boe` has had a "work directly on `main`" Standing Rule since its own Turn 3 (2026-07-15, when Nikolaj asked to drop a feature-branch-per-session pattern there) — but that rule was never added back to this upstream template, since it wasn't part of the original generic scaffold. Asked whether to port it here too; confirmed yes. Added to `ROUTING.md` Standing Rules, but phrased as an **overridable template default** rather than an absolute rule (unlike `familien-boe`'s phrasing) — this repo is meant to be forked for arbitrary initiatives, some of which may be team repos needing a real review gate, so the rule explicitly tells a fork how to replace it rather than assuming personal/solo use unconditionally.

### Session close

Knowledge candidates: None — both items are tooling/policy, not domain facts (this repo has no real domains, only the `example-domain` placeholder).
Open flags: None.
Push status: Pushed — directly to `main`.

STATUS: CHECKPOINT
Completed: Retroactively logged the Turn 6/7-era executable-bit fix; added an overridable "work directly on `main` by default" Standing Rule to `ROUTING.md`, ported from `familien-boe`.
Next: None planned — awaiting further direction.
Waiting for: Nothing further — pushed this turn.
