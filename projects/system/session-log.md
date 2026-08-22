---
type: project
project: system
---

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

---

## [Claude] — Turn 9 | 2026-07-16

Human asked, in a broader conversation comparing this architecture to Obsidian's "second brain" conventions, which Obsidian-style structural ideas were worth adopting — with an explicit bar of "sure-fire, not flimsy, easily maintained by an LLM." Recommended three: minimal YAML frontmatter, mechanical cross-reference reciprocity checking, and a generated Mermaid relationship diagram (deferred — see below). Confirmed to proceed with the first two, scoped to this repo only for now (`familien-boe` explicitly deferred).

**Frontmatter** — deliberately minimal, to avoid recreating the exact duplication problem the own-vs-reference rule (`authoring-guidelines.md` §4) exists to prevent: `type` + a folder-name slug (`domain:` or `project:`) only, no `status`/`version` field, since that already lives in the existing header line. Documented in `MarkdownConventions.md` §1 (new subsection) rather than `authoring-guidelines.md`, since it applies to project files too, not just domain knowledge documents. `authoring-guidelines.md` §2, §9.1, and §11 cross-reference it.

**Reciprocity checking** — built on the actual links inside each domain's own files, not on `index.md`'s References column prose. That column is a human-authored summary and could itself drift from the real links; scanning real content keeps a single ground truth. Reuses the link-scanning approach already built for the sources/deep-wells checks (§9.4) rather than inventing new parsing logic. Severity: warning, since a one-directional reference can be legitimate.

**Retrofit turned out larger than scoped.** The plan said "example-domain/ + example-project/ — trivial," but `validate.ps1`'s own new checks caught two real gaps in that scoping once run against the actual repo rather than a fixture: `projects/system/` (a real, pre-created project, not a placeholder) and `projects/example-project/` (a second real folder distinct from `_template/`) both needed frontmatter too and had been missed. Both fixed as follow-up commits, each caught by the tool doing exactly what it was built to do. `projects/system/TODO.md`'s version was also bumped for the frontmatter addition, per `MarkdownConventions.md` §2's own edit rule — a small thing, but worth doing given the "sure-fire" bar for this whole exercise.

**Files changed:**

- `MarkdownConventions.md` (1.1 → 1.2) — new Frontmatter subsection in §1.
- `knowledge/domains/authoring-guidelines.md` (1.3 → 1.4) — cross-references to the new convention in §2, §9.1 (source-manifest template), §11 (Quick Checklist); §5 and §8 note that reciprocity is now checked mechanically.
- `knowledge/domains/example-domain/description.md`, `knowledge.md` (1.0 → 1.1 each) — frontmatter added, template source for all future domains.
- `projects/_template/TODO.md`, `session-log.md` — frontmatter added with the bracket-placeholder convention (`project: [project-name]`), matching the template's existing style.
- `projects/system/TODO.md`, `session-log.md` — frontmatter added (scope-gap fix).
- `projects/example-project/TODO.md`, `session-log.md` — frontmatter added (scope-gap fix).
- `scripts/validate.ps1` — new frontmatter checks (domain files, project files, source manifests) and the reciprocity check.

**Testing**: fixture covering every new case (missing frontmatter, wrong `type`, slug/folder mismatch, one-directional cross-reference) confirmed each is caught, and the corresponding clean fixture passes 0/0. Two successive real-repo clones caught the two scope gaps above; a third clone after both fixes passed clean (0 errors, 0 warnings, both real projects correctly detected as active).

### Session close

Knowledge candidates: None — structural/authoring-standard change, not a domain fact.
Open flags: None.
Push status: Pushed — directly to `main`.

STATUS: CHECKPOINT
Completed: Added the frontmatter convention (`type` + folder-name slug) and mechanical cross-reference reciprocity checking; retrofitted every existing domain and project file in this repo, including two real folders missed in the original scope; verified clean against a fresh clone.
Next: Suggestion 3 (a generated Mermaid relationship diagram in `knowledge/domains/index.md`, derived from the same reciprocity data) was explicitly deferred until this work landed — the human asked to be reminded now that it has.
Waiting for: Direction on suggestion 3, or the next task.

---

## [Claude] — Turn 10 | 2026-07-24

Human raised suggestion 3 (the Mermaid diagram) again, per the reminder set in Turn 9 — but on scrutiny (would it help LLM readers of `index.md`, would it help a human looking at a specific domain), it didn't hold up: a Mermaid edge is a lossy restatement of what the References column already says more precisely, LLMs don't gain anything from a rendered shape the way humans do, and the own-vs-reference discipline that makes this architecture good also keeps real cross-references sparse by design — sparse graphs aren't where graph visualization earns its value. Shelved, not built.

Human then raised a real, recurring need: bringing fork instances (`familien-boe`, and a future one, "longstraw") up to date with this template over time, and proposed two mechanisms — a version-number check, and a changelog written to be followed "chronologically and to the word." Talked through both before building:

- **Version-number check, reconsidered as a commit-SHA check instead.** This repo has no unified template version — every file versions independently (`MarkdownConventions.md` §2). Inventing one would mean maintaining a second versioning scheme in parallel. A recorded last-synced upstream commit SHA is more precise (tells you exactly what changed, not just that something did) and needs no new bookkeeping discipline.
- **Rigid word-for-word migration instructions, pushed back on.** Both prior ports into `familien-boe` (Turns 6–9 here) succeeded specifically because I diffed the fork's *actual* current state before applying anything and used judgement where it had diverged — `Architecture.md` needed hand-fitting, not a copy-paste, once `familien-boe` grew its own §4; two scope misses were caught only by re-verifying against the live repo, not by following a plan. A changelog meant to be followed mechanically risks exactly that failure mode. What already does the job "changelog" was meant to do is the session-log itself — I used Turn 6's and Turn 9's own entries as the brief for both ports, no separate instructions needed.
- **Scheduled Routine, proposed then dropped.** First plan used a monthly `create_trigger` Routine to run the check. Human pointed out this repo already has a Maintenance Pass discipline (`authoring-guidelines.md` §8) — opportunistic, "on request, or when things have visibly diverged," not scheduled — and asked why not use that instead. Right call: a scheduled Routine would have been the one piece of background-automation infrastructure in a system where everything else is a written procedure a session follows by judgement when it's in the relevant context, and it costs a session every month whether or not anything changed. Dropped entirely in favour of the same opportunistic pattern, surfaced through a marker sitting in a file a System-project session already loads — no new infrastructure needed at all.

**Built:**

- New `knowledge/flow/upstream-sync.md` — the sync marker format (last-synced commit SHA + date, recorded in the *fork's own* `projects/system/TODO.md`, not in any session's local state, since nothing local survives between sessions here), an explicit tracked-paths list (system-layer files only — never a domain's own knowledge, the domain index, a project's own work, or `library/*`), a read-only check procedure, and an apply procedure that requires diffing the fork's real current state first, same discipline as above. Explicitly notes `README.md` and `Architecture.md` as the two most likely to need hand-fitting rather than a clean apply, since both routinely carry fork-specific narrative.
- `Architecture.md` (1.1 → 1.2) — §6 gained a fork-setup step: add the sync marker to your own `projects/system/TODO.md`, recording your fork's starting commit as the initial sync point.
- `ROUTING.md` (1.5 → 1.6) — Quick Task Guide gained an entry pointing to the new mechanism.
- `knowledge/domains/authoring-guidelines.md` (1.4 → 1.5) — §8 cross-references `upstream-sync.md` as the repo-level analog of this domain-scoped pass.
- `scripts/validate.ps1` — `upstream-sync.md` added to the required `knowledge/flow/` files check.

This repo itself doesn't get a live sync marker in its own `projects/system/TODO.md` — it has no upstream to sync from. The marker is something each fork adds for itself, per the new `Architecture.md` §6 step; `familien-boe` (and eventually `longstraw`) picking this up is a separate, later task, not done this turn.

### Session close

Knowledge candidates: None — structural/authoring-standard change, not a domain fact.
Open flags: None.
Push status: Pushed — directly to `main`.

STATUS: CHECKPOINT
Completed: Reconsidered and shelved the Mermaid-diagram suggestion; designed and built the Upstream Template Sync mechanism (sync marker, tracked-paths list, check/apply procedures) as an opportunistic Maintenance Pass extension rather than scheduled automation; verified clean against a fresh clone.
Next: Roll the sync marker out to `familien-boe` (set its initial last-synced commit to this repo's current HEAD, since it was just brought fully up to date) — a separate task, not yet started. `longstraw` isn't in scope for this session.
Waiting for: Direction on rolling this out to familien-boe, or the next task.

---

## [Claude] — Turn 11 | 2026-07-25

Human asked how clear this architecture's procedure is for deleting a project or knowledge domain once it becomes genuinely irrelevant over the years — a question raised in general discussion, not from a specific repo needing it right now. On inspection there was no such procedure anywhere: `knowledge/domains/index.md` has a 6-step "Adding a Domain" flow with no removal counterpart; `project-types.md`'s "Archive" phase only means logging findings into an operational log, not removing anything; the only "delete" precedent in the whole system was the one-off instruction to delete the example placeholders. An LLM asked to retire something today would have had to improvise. Human agreed with the recommendation to build an archive-in-place mechanism rather than deletion, and asked to implement it.

**Design, reusing existing structure rather than inventing new machinery:**

- Every file already has a header `Status` field (`MarkdownConventions.md` §1: `Draft`, `Review Pending`, `Production`). Added `Retired` as a fourth value — no new field needed.
- A one-line blockquote (`> **Retired:** YYYY-MM-DD — [reason]`) makes retirement visible to anyone opening the file directly, matching the existing idiom already used throughout for structural meta-notes (Routing check, Edit guard, Setup note).
- `knowledge/domains/index.md`'s Registered Domains table gained a `Status` column (`Active`/`Retired`) — a simpler routing-relevance flag than the header's four-value vocabulary, since a domain's document maturity (Draft vs. Production) and its ongoing relevance are genuinely different axes; only the Retired/not-Retired distinction between the two is meant to agree.
- Retiring is explicitly archive-in-place, never deletion — deletion is a separate, explicitly-confirmed action the new Hard Constraint calls out by name, mirroring the existing cornerstone-promotion gate pattern (`authoring-guidelines.md` §9.3).

**Backed by a mechanical check, not just a written rule** — consistent with how the frontmatter/reciprocity and upstream-sync mechanisms were built, and with the earlier explicit ask that additions here be "sure-fire, not flimsy." Extended `scripts/validate.ps1`:
- A domain's `description.md`/`knowledge.md`/`index.md` Status values must agree on Retired-or-not; any disagreement is flagged.
- A project marked `Retired` in `TODO.md` that still has a live routing row in `ROUTING.md` Step 2 is flagged — the row should be removed so new work isn't routed there.
- Summary now reports retired project counts alongside active ones.

Tested both checks directly before trusting them: built a throwaway copy, retired `example-project`/`example-domain` incompletely (index.md updated but not the domain files; TODO.md status flipped but the routing row left in place) and confirmed both new warnings fired correctly; then completed the retirement properly and confirmed both warnings cleared. Discarded the test copy — `example-project`/`example-domain` in the real repo are untouched, still `Active`.

**Files changed:**

- `MarkdownConventions.md` (1.2 → 1.3) — `Retired` added to the Status vocabulary; new "Retirement" subsection under §1 defining the convention for both domain and project files.
- `knowledge/domains/index.md` (1.1 → 1.2) — `Status` column added to the registry table; new "Retiring a Domain" section mirroring "Adding a Domain".
- `ROUTING.md` (1.6 → 1.7) — Step 2 gained a note to remove a retired project's routing row; Step 4 gained a rule to skip `Retired` domains by default; Hard Constraints gained a retirement/deletion confirmation rule; Quick Task Guide gained a "retire a domain or project" entry.
- `knowledge/domains/authoring-guidelines.md` (1.5 → 1.6) — Maintenance Pass (§8) gained a check for whether a domain should be retired rather than left silently stale.
- `Architecture.md` (1.2 → 1.3) — §4 Routing inputs gained a bullet noting retirement status affects routing.
- `scripts/validate.ps1` — the two new checks and the retired-project summary count, described above.

No project or domain in this repo was actually retired this turn — this was purely building the mechanism itself, tested on throwaway content.

### Session close

Knowledge candidates: None — structural/authoring-standard change, not a domain fact.
Open flags: None.
Push status: Pushed — directly to `main`.

STATUS: CHECKPOINT
Completed: Designed and built domain/project retirement as an archive-in-place convention (`Retired` status value, retirement blockquote, `index.md` Status column) with two new mechanical `validate.ps1` checks (domain Status agreement across files, retired-project routing-row cleanup) — both checks tested against deliberately broken and then correctly-fixed throwaway content before trusting them; verified clean against a fresh clone.
Next: This is a template-level addition, not yet rolled out to `familien-boe` or `longstraw` — those forks will need it ported the same way the frontmatter/reciprocity and upstream-sync mechanisms were, whenever their own upstream-sync check next runs.
Waiting for: Direction on the next task.

---

## [Claude] — Turn 12 | 2026-07-25

Human is planning to self-host both this repo and an as-yet-undecided LLM sized for a homelab setup, and asked how confident I was that `ROUTING.md` and the rest of the prose-based instructions would hold up on a weaker or self-hosted model versus a frontier one — a fair question, since I've made real mistakes following this system's own discipline this session (two scope misses porting into `familien-boe`, two forgotten Version History rows). Answered honestly: low-to-moderate confidence for the *restraint* rules specifically (Plan-first, Hard Constraints, no-chaining, what counts as system-layer) — the class of instruction hardest for any LLM to hold reliably, weaker ones especially, because failure there is silent, not a crash. What already holds up regardless of model is anything backed by `scripts/validate.ps1`, since that doesn't depend on the model remembering a rule, only on it running the script and acting on the output.

Human asked for a detailed review of the most obvious hardening vectors. Reviewed `operating-principles.md`, `turn-protocol.md`, `routing-rules.md`, `MarkdownConventions.md`, and `ROUTING.md`'s Hard Constraints for rules that currently depend purely on the model remembering, and ranked five candidates by severity and mechanical checkability: (1) append-only `session-log.md`, (2) turn structure / STATUS signal vocabulary, (3) no-chaining between turns, (4) Version History append-only + header/row agreement, (5) system-layer edits coupled to a session-log entry in the same commit (flagged as needing a git hook, not `validate.ps1`, since it's commit-diff-level). Human approved building 1–4 now, with 5 as a separate later addition.

**Before building anything, verified the underlying assumptions against the real logs rather than trusting the spec docs** — the same discipline that caught the two scope misses earlier this session. This paid off immediately: `turn-protocol.md`'s `[HUMAN]` turn template implies a human turn is logged between confirmations, but `grep`-ing both this repo's and `familien-boe`'s real `session-log.md` files showed every turn after Turn 1 is `[Claude]`/`[Copilot]` consecutively — human confirmation happens in conversation, never as a separate logged entry. A literal "no two consecutive non-HUMAN turns" check would therefore flag the *entire* existing history in both repos as violations. Dropped item 3 rather than ship a check that's pure noise against actual usage — no-chaining is enforced by the conversational medium itself (a new turn requires a new incoming human message), not by anything visible in the repository, so it isn't mechanically checkable here. Documented this reasoning directly in the new `validate.ps1` comment block so a future session doesn't rebuild it under a mistaken assumption.

**Built, all in `scripts/validate.ps1`:**

- **Append-only `session-log.md`** — for each project, fetches the file's content at `git HEAD` and asserts the working copy is that content with only lines appended, never edited or removed. Scope is deliberately working-tree-vs-last-commit, matching how this script is actually run (immediately before each commit) — it does not walk full history.
- **Turn structure and STATUS-signal vocabulary** — validates every `## [Role] — Turn N | YYYY-MM-DD` header is well-formed and `N` is strictly sequential with no gaps or repeats; every non-`[HUMAN]` turn has a `STATUS:` line (errors if missing); the STATUS text is checked against the known signal vocabulary from `turn-protocol.md`/`routing-rules.md`/`project-types.md` (warns, not errors, if unrecognized — a fork may legitimately add its own phase signals); `STATUS: BLOCKED` is checked for all three required sub-fields (errors if incomplete, per `turn-protocol.md` §3).
- **Version History discipline, generalized to every file that has one** — header `Version` must match the latest table row (warning — a legitimate mid-edit state); old rows must never be edited or removed compared to `git HEAD`, only appended to (error). This is the exact mistake I made twice earlier this session, caught only by manually `tail`-checking — now it can't happen silently.

**Two real bugs found and fixed while testing, not just written and trusted:**
1. A classic PowerShell gotcha — a function returning an array via `return $rows` gets unwrapped to a scalar when the array has exactly one element, so `$rows[-1]` silently indexed into a *string's last character* instead of the array's last row for any file with exactly one Version History entry. Wrapped both call sites in `@(...)` to force array context. Caught immediately because the very first real run against this repo threw exceptions instead of passing clean.
2. Code-fenced examples needed the same `Remove-CodeFences` treatment already used elsewhere — `MarkdownConventions.md` itself contains a fenced *example* of a Version History section, literally including the heading text `## Version History`, which would otherwise be mistaken for a real one.

**Verification, same rigor as the retirement checks:** built a disposable copy, committed a clean baseline, then deliberately injected one violation at a time — an edited word inside an already-committed turn, a skipped turn number, a missing `STATUS:` line, an invented `STATUS: ALL DONE` signal, an incomplete `BLOCKED` signal, and a hand-edited prior Version History row — and confirmed each produced exactly the intended error or warning, with no false positives on the surrounding unmodified content. Discarded the disposable copy afterward. Re-ran against the real repo clean both before and after the fixes.

Item 5 (system-layer edits must be logged in the same commit) is explicitly deferred — it needs a pre-commit git hook, not a `validate.ps1` addition, since it depends on commit-level diff granularity that a working-tree scan can't see.

### Session close

Knowledge candidates: None — structural/tooling change, not a domain fact.
Open flags: None.
Push status: Pushed — directly to `main`.

STATUS: CHECKPOINT
Completed: Added three new `validate.ps1` checks hardening this system against weaker-model failure modes — append-only `session-log.md`, turn-structure/STATUS-signal validation, and generalized Version History append-only/agreement — after verifying the assumptions behind a fourth candidate (no-chaining) against real session-log content and finding it would be pure noise, so it was dropped rather than built. Fixed two real bugs (a PowerShell array-unwrapping gotcha, a code-fence collision) found while testing against deliberately broken content. Verified clean against a fresh clone.
Next: Item 5 (system-layer edits coupled to a session-log commit) is a separate git-hook addition, not yet built. Not yet ported to `familien-boe` or `longstraw`.
Waiting for: Direction on the next task.

---

## [Claude] — Turn 13 | 2026-07-25

Human asked to build item 5 from the previous turn's hardening review: system-layer edits must be logged in `projects/system/session-log.md` in the same commit. Unlike items 1–4, this can't live in `validate.ps1` — it depends on commit-level diff (what's staged right now vs. what's at `HEAD`), not working-tree state, so it needs an actual git pre-commit hook.

**The real problem wasn't the check logic — it was activation.** A tracked hook file does nothing by itself; git only runs hooks from `.git/hooks/` (untracked, clone-local) unless `core.hooksPath` is pointed at a tracked directory, and `core.hooksPath` is local git config that a fresh clone never inherits. Given how this whole session actually works — Claude Code web sessions clone fresh every time — a hook that silently needs a manual one-time command per clone would, in practice, almost never be active exactly where it matters most. Solved by treating this the same way Turn 6 solved the missing-PowerShell problem: `.claude/hooks/session-start.sh` (already run automatically at the start of every Claude Code session) now also runs `git config core.hooksPath .githooks`, idempotently, regardless of remote vs. local. For non-Claude-Code setups (the human's planned self-hosted homelab included), the one-time manual command is documented in `Architecture.md` §6 — and since a self-hosted setup is more likely to be a persistent clone rather than a fresh one each session, running it once by hand there is genuinely sufficient, not just a fallback.

**Built:**

- `.githooks/pre-commit` — a thin `sh` shim (git invokes hooks directly; PowerShell isn't a valid hook interpreter on its own) that calls `scripts/pre-commit-check.ps1`, keeping the actual logic in the same language as `validate.ps1` rather than introducing a second scripting language.
- `scripts/pre-commit-check.ps1` — reads staged files (`git diff --cached --name-only`), checks them against the same tracked-paths list `knowledge/flow/upstream-sync.md` §3 already defines as "system-layer" (reused, not reinvented, to avoid a second list drifting out of sync with the first), and blocks the commit if any matches without `projects/system/session-log.md` also being staged. The block message names the files and points at `git commit --no-verify` as the deliberate, visible bypass — better than a silent skip, but still an explicit named action rather than nothing.
- `scripts/validate.ps1` gained two additions: existence checks for both new hook files, and a warning (not error, since it's clone-local state rather than repo content) if `core.hooksPath` isn't actually set to `.githooks` in the current clone.
- `Architecture.md` (1.3 → 1.4) — §6 gained step 10 for activation. `ROUTING.md` (1.7 → 1.8) — the "structural changes must be logged" Hard Constraint now cross-references the hook. `knowledge/flow/upstream-sync.md` (1.0 → 1.1) — `.githooks/*` added to the Tracked Paths list, since it's a new system-layer directory forks need to sync too.

**One real bug caught by testing, not just written:** the git-helper block (`$isGitRepo`, `Get-GitHeadContent`) that items 1/2/4 already depended on was defined *after* first use once I added the `core.hooksPath` check earlier in the script — `$isGitRepo` would have silently evaluated as `$null`/falsy at that point, making the new warning never fire regardless of actual state. Moved the git-helper block up to right after `$repoRoot`/`$copilotInstructionsPath` are defined, before anything needs it. Caught by testing the warning both ways (unset, then set) rather than trusting the code once it ran without error.

**Verification:** tested the actual git mechanism end to end, not just the PowerShell logic in isolation — staged a `ROUTING.md`-only change and ran a real `git commit` (blocked, exit 1, nothing committed); staged `session-log.md` alongside it (passed); staged only an unrelated project file (passed, correctly untouched by the check); confirmed `git commit --no-verify` still bypasses deliberately. All test commits were undone (`git reset --soft`, `git checkout --`) before the real work was committed.

### Session close

Knowledge candidates: None — structural/tooling change, not a domain fact.
Open flags: None.
Push status: Pushed — directly to `main`.

STATUS: CHECKPOINT
Completed: Built and activated a pre-commit git hook (`.githooks/pre-commit` + `scripts/pre-commit-check.ps1`) enforcing that system-layer edits are logged in `projects/system/session-log.md` in the same commit — completing all five hardening vectors from the prior review. Solved the activation gap (local git config doesn't survive a fresh clone) by wiring it into the existing `.claude/hooks/session-start.sh`, and documented the manual one-time command for non-Claude-Code setups. Fixed an evaluation-order bug in `validate.ps1` found while testing both states of the new warning. Verified end to end against a real `git commit`, not just the check logic in isolation.
Next: This is a template-level addition, not yet ported to `familien-boe` or `longstraw` — same as items 1–4 and the retirement mechanism before it.
Waiting for: Direction on the next task.

---

## [Claude] — Turn 14 | 2026-07-25

Human proposed a new capability: an LLM taking the adversarial side of a real negotiation (employer HR minimizing termination cost, testing whether an expense claim would hold up) to stress-test arguments before acting on them for real. What shipped this turn is a small fraction of what was originally scoped — the design converged down through two rounds of external consultation and two rounds of the human's own direct pushback, each one cutting real complexity rather than adding it.

**Design arc, briefly:**

1. Initial proposal: a full top-level `simulation/` (later `counterparty/`) folder — its own frontmatter type, its own entity registry, a four-phase "Stress-Test" project type, dedicated `STATUS: IN CHARACTER`/`OUT OF CHARACTER` signals with a mandatory per-turn marker, a pairing check in `validate.ps1`.
2. Consulted `familien-boe` and the human's homelab session directly (via a written feedback-request prompt, not assumed) before building anything. Real findings, not rubber-stamps: two independent naming collisions (`simulation/` read too close to this repo's existing "Scenario A/B" financial-projection pattern in one fork, and to unrelated "simulate a lockout" prose usage in the other); an entry-ambiguity gap (nothing distinguished "predict how he'd react" from "roleplay him telling me no"); a sharper exit-ambiguity gap (a phase-level boundary doesn't mark *individual turns* within a long, multi-topic session); and — from the pentesting follow-up — that a promoted lesson from adversarial security-reasoning could double as an actual offensive playbook, a different risk category than personal-reputational `[SENSITIVE]` exposure.
3. Human then challenged the core premise directly: why does a real, useful fact ("boss responds better to written follow-ups") need to live in a separate store that's *never loaded outside a stress-test*, when it's just an ordinary domain fact useful in normal ally-mode work too? Correct — the thing that actually needed fencing was never *where facts about a person live*, it was the fictional transcript and the adversarial stance. Dropped the entire `counterparty/entities/` structure; behavioral knowledge about anyone — household member or external party — now lives as ordinary content in whatever domain already owns them.
4. Human then challenged the remaining mechanism too: most of what the original request needed is just grounded reasoning in the LLM's own voice, which doesn't need a formal sandbox at all — and the `IN CHARACTER`/`OUT OF CHARACTER` apparatus never actually *prevented* anything, it only left an after-the-fact paper trail for a risk that's about behavior in the moment, not documentation of it. Correct again. Dropped the project type, the STATUS signals, the per-turn marker, and every planned `validate.ps1` change.
5. A closing question from the human ("would this routing apply the same way to how my own or my wife's communication style gets captured?") surfaced that the surviving guidance was still framed adversarially ("Counterparty and behavioral notes," leverage-focused `[SENSITIVE]` example) even though the underlying rules apply equally to non-adversarial, non-external content. Broadened the heading and the first bullet before committing rather than shipping a subsection whose title undersold its own scope.

**What actually shipped — three small additions, no new structure:**

- `knowledge/domains/authoring-guidelines.md` (1.6 → 1.7) — new §4 subsection "Behavioral and communication-style notes": a domain may capture how a household member or external party tends to communicate or argue, using the signals that already exist (`[SENSITIVE]`, `[VERIFIED]`/`[UNVERIFIED]`) rather than new ones; hedge pattern-based behavioral claims and periodically test them against disconfirming evidence, not just repeated confirming instances; attacker/security-domain content stays framed as defensive hardening, never a portable offensive technique; never write roleplayed dialogue into a domain as if it were a real exchange — already covered by existing writing-style and validity-signal rules, no new rule needed.
- `ROUTING.md` (1.8 → 1.9) — new Hard Constraint: never adopt an adversarial persona without an explicit, unambiguous human request, and drop back to normal voice immediately and unprompted at any sign the human has stepped outside the exercise.
- `knowledge/flow/operating-principles.md` (1.0 → 1.1, its first edit since initial creation) — §5 gained a note to actively watch for behavioral/argumentative-style signal when processing correspondence from a party a domain already covers, not just the logistical content — same flag-and-confirm gate as any other knowledge candidate, nothing captured automatically.

Everything that would have needed mechanical enforcement got designed away before it needed any — there is nothing new for `validate.ps1` to check this turn.

### Session close

Knowledge candidates: None — structural/authoring-standard change, not a domain fact.
Open flags: None.
Push status: Pushed — directly to `main`.

STATUS: CHECKPOINT
Completed: Shipped the counterparty/behavioral-notes capability as three small additions (`authoring-guidelines.md`, `ROUTING.md`, `operating-principles.md`) after a full design arc that started as a new top-level folder with dedicated signals and tooling, and was cut down through two rounds of grounded fork feedback plus two rounds of the human's own scrutiny to exactly what the original request needed and no more.
Next: Not yet ported to `familien-boe` or `longstraw`.
Waiting for: Direction on the next task.

---

## [Claude] — Turn 15 | 2026-07-25

Human relayed feedback from `longstraw`'s session porting the upstream-sync-tracked changes from this repo, gathered while doing the real port rather than a hand-simulated one (that session had `CLAUDE_CODE_REMOTE=true`, so its own session-start hook ran for real, installing real PowerShell — the first time `validate.ps1` and the pre-commit hook were exercised end to end by a session other than this one). Four findings, two requiring action here.

**1. Real bug in `MarkdownConventions.md`, found and fixed.** Its header read "Version 1.2" while its own Version History table's last row already said "1.3" — the exact class of mistake the Version History discipline check (built in the hardening round two turns ago) exists to catch. It didn't catch it. Investigated rather than just patching the content: the check's heading-match regex only recognised a bare `## Version History` heading, but `MarkdownConventions.md` is the one file in this repo that numbers its own final section (`## 10. Version History`, per its own Index) — so the check's initial gate silently skipped the entire file, every time, since the check was written. Confirmed via direct debugging (isolated the two helper functions, ran them against the real file content) rather than guessing from the error's absence. Fixed the regex in both `Get-VersionHistoryRows` and the gate check to accept an optional numeric prefix, verified it now flags the real bug on the unfixed content, then fixed the content (header bumped to 1.4, a new row documenting the fix itself — not silently reused the stale 1.3 slot). Closed my own test-coverage gap at the same time: two turns ago I verified the tamper-detection logic against `ROUTING.md`, which has an unnumbered heading and would never have exercised this exact bug — re-ran the same row-edit and header/row-mismatch tests specifically against `MarkdownConventions.md` this turn and confirmed both now fire correctly, and confirmed the file passes clean when untampered.

**2. Pre-commit hook confirmed working under real conditions** — no action needed, noting for the record since it's the first real (not hand-simulated) confirmation.

**3. A genuine pre-existing gap in `longstraw`'s own history** (a Turn 2 missing its required `STATUS:` line, predating this whole thread) — correctly left undocumented-but-unfixed by that session rather than edited, since fixing it would itself violate the newly-synced append-only check. Right call; nothing to do here, this is `longstraw`'s repo, not this one.

**4. A near-miss during hook testing, self-caught and self-recovered.** An unconditional `git reset --soft HEAD~1`, run right after a blocked (no-op) commit attempt, assumed the attempt had succeeded — it hadn't, so `HEAD~1` was one commit further back than intended, and a real, already-pushed commit briefly got undone locally. Caught by diffing against `origin/main` rather than trusting local state before pushing anything, recovered with `git reset --soft origin/main`, nothing bad reached the remote. Added a comment directly in `scripts/pre-commit-check.ps1` — the file anyone testing or porting this hook will actually be looking at — warning against this exact assumption: a blocked commit creates no commit, so verify before resetting, never assume.

**Files changed:** `MarkdownConventions.md` (1.2 → 1.4, skipping past the never-actually-synced "1.2 state" — the 1.3 row was already real and correct, only the header was stale); `scripts/validate.ps1` (heading-match regex fix, comment updated to record why); `scripts/pre-commit-check.ps1` (hook-testing safety comment, no logic change).

### Session close

Knowledge candidates: None — structural/tooling fix, not a domain fact.
Open flags: None.
Push status: Pushed — directly to `main`.

STATUS: CHECKPOINT
Completed: Fixed a real header/changelog version mismatch in `MarkdownConventions.md`, found by `longstraw`'s sync port; traced it to a genuine bug in the Version History discipline check itself (a numbered-heading file was being silently skipped since the check was written) rather than just patching the symptom; fixed the check, verified it now catches the bug, then fixed the content; closed a real test-coverage gap by re-running the tamper tests against the specific file type that exposed it. Added a hook-testing safety note to `scripts/pre-commit-check.ps1` from a near-miss `longstraw` self-caught and self-recovered from.
Next: Nothing scheduled. `familien-boe` and `longstraw` remain ahead of this repo on the counterparty/behavioral-notes addition until their own sync checks run.
Waiting for: Direction on the next task.

---

## [Claude] — Turn 16 | 2026-07-25

Human asked how well this template handles two people (human's wife and himself) working concurrently in the same fork — specifically fetch/pull discipline before pushing, and safe conflict handling — with the explicit goal that git stay invisible to the humans and be handled by routing/instructions instead. Investigated before answering: grepped `ROUTING.md`, `Architecture.md`, every `knowledge/flow/*.md`, and `scripts/*.ps1` for fetch/pull/merge/conflict/diverge/force. Nothing addressed it — the only hits were about the unrelated upstream-template-sync concept. `scripts/commit-push.ps1` itself does `add` → `commit` → `push` with no fetch step at all; on a rejected push it just reports failure and stops, with no guidance for what happens next. Real, evidenced gap, not a hypothetical one — confirmed before proposing anything, same discipline as the retirement-procedure gap earlier.

Presented a three-phase plan, checkpointed after each phase per the no-chaining discipline:

**Phase 1 — `knowledge/flow/git-collaboration.md` (new file).** Fetch-before-every-push, rebase-then-revalidate integration, file-type-specific resolution (append-only files get renumbered fresh against current remote content, never hand-resolved via conflict markers; ordinary content collisions route through the existing `[CONTRADICTS: source]` correction discipline rather than new machinery), and a Hard Constraint against ever force-pushing automatically.

**Phase 2 — `ROUTING.md` (1.9 → 1.10).** Standing Rules cross-reference, a Hard Constraint against force-pushing through a rejection, a Quick Task Guide entry.

**Phase 3 — `scripts/commit-push.ps1`.** Added fetch, divergence detection, rebase, and a re-validation step before push; on a rebase conflict it aborts back to a clean state, reports exactly which files conflicted (distinguishing a real content conflict from some other rebase failure with no unmerged files, e.g. a hook rejecting a replayed commit, rather than reporting a misleading empty conflict list), and stops without pushing either way. No force-push capability exists anywhere in the script.

**Tested against real divergent clones, not trusted on read** — a bare local "fake remote" cloned from the real repo, two independent clones simulating two concurrent sessions, run through the actual git commands (not just the PowerShell wrapper, which locates `git.exe` via Windows-specific paths that don't exist in this environment — noted as an honest limitation: the underlying git sequence is proven correct end-to-end, the Windows-specific wrapper syntax around it is a comparatively low-risk, mechanical transplant of that same sequence).

- **Clean divergence** (two unrelated files): fetched, rebased silently, `validate.ps1` passed, pushed. Confirmed the ordinary case resolves with nothing for a human to see.
- **Turn-number collision** (both sessions append "Turn 16" to `session-log.md`): this produced a genuine git conflict during rebase, not a silent clean merge — a real finding, not the assumption the plan and the first draft of `git-collaboration.md` had been written on. Confirmed `--diff-filter=U` correctly names the conflicted file and `rebase --abort` restores a fully clean state. Then executed the actual recommended resolution — reset to the current remote state, re-read the real latest turn number, re-appended fresh as "Turn 17" — and confirmed it validates and pushes cleanly with correct, sequential, non-duplicated history.

**Caught and corrected a real documentation error before shipping it.** The original design assumed concurrent appends to the same file tail would merge cleanly at the git level and only be caught by `validate.ps1`'s turn-numbering check — that assumption was wrong, disproven by the test above, and had already been written into `git-collaboration.md`, `ROUTING.md`'s Quick Task Guide entry, and two places in `commit-push.ps1`'s comments/messages before the test ran. Fixed all four in place: the dominant, evidenced behaviour is that same-point appends surface as real rebase conflicts (handled by §4's abort-and-reappend path), and `validate.ps1`'s re-validation-after-clean-rebase is accurately reframed as a backstop for genuinely non-overlapping edits that could still leave something structurally inconsistent, not as the primary mechanism for the turn-collision case specifically.

**Files changed:** `knowledge/flow/git-collaboration.md` (new, v1.0), `ROUTING.md` (1.9 → 1.10), `scripts/commit-push.ps1` (fetch/rebase/re-validate logic added, corrected comments).

### Session close

Knowledge candidates: None — structural/tooling change, not a domain fact.
Open flags: None.
Push status: Pushed — directly to `main`.

STATUS: CHECKPOINT
Completed: Built and tested multi-writer git safety for this template — fetch-before-push, rebase-and-revalidate integration, append-only turn renumbering, and routing genuine content collisions through the existing `[CONTRADICTS]` discipline rather than new machinery. Verified against real divergent clones rather than trusted on read, which surfaced and corrected a real wrong assumption in the original design (append collisions conflict at the git level far more often than the plan assumed) before it shipped.
Next: Not yet ported to `familien-boe` or `longstraw`.
Waiting for: Direction on the next task.

---

## [Claude] — Turn 17 | 2026-07-25

Human flagged that "deep well" isn't intuitive terminology, and asked whether the `library/deep-wells/` subfolder nesting even earns its place, or whether it could be simplified without losing robustness. Brainstormed several options first (keep `library/` and rename the concept to "reference work"; drop the special word entirely and just use the existing `Stored: yes/no` field; or rename `library/` itself to `shared-sources/` to pair explicitly with the per-domain `sources/` convention) before touching anything. Human picked the first: keep `library/` as the folder name, rename the concept to "reference work," and confirmed dropping the `deep-wells/` subfolder.

**Rationale for dropping the subfolder:** it existed only to keep the registry file visually separate from the physical files, but the cornerstone rule (§9.3 — only store a work if multiple domains use it, it's hard to reacquire, or it's mined over months) already keeps that folder small by design. A folder meant to stay small doesn't need its own subfolder to stay organised.

**Renamed throughout, not just at the surface:** "deep well" → "reference work" wherever it appeared, and — since leaving "mined"/"extraction" language in place while dropping the well metaphor would have left a half-finished mixed metaphor — also replaced "mined incrementally" with "drawn from incrementally" and the registry template's "Extraction log" field's "what was mined" with "Notes log" / "what was found". Historical `session-log.md` entries and existing Version History rows were deliberately left untouched — they're an accurate record of what was true when written, not something to retroactively correct; each affected file got a new version row describing the rename instead, per the append-only discipline this template already enforces on itself.

**Files changed:** `knowledge/domains/authoring-guidelines.md` (1.7 → 1.8, §9.2–9.4 and Index), `Architecture.md` (1.4 → 1.5, §2 diagram and §3), `README.md` (folder diagram, new 1.3 row), `ROUTING.md` (1.10 → 1.11, Step 4 / Hard Constraints / Quick Task Guide), `knowledge/flow/upstream-sync.md` (1.1 → 1.2, §3 tracked-paths wording), `library/reference-index.md` (1.0 → 1.1, Document Purpose / Edit guard / section heading / entry template).

**`scripts/validate.ps1` — a real logic change, not just prose.** Rewrote the library-integrity check to scan `library/` directly instead of `library/deep-wells/`, excluding `reference-index.md` itself and `*-manifest.md` files from orphan-file detection (same exclusions as before, same severity levels, just pointed at the flattened location). Tested against a disposable copy before trusting it: a properly registered and stored file validates clean; an unregistered file in `library/` is correctly flagged as an orphan warning; a registered `Stored: yes` entry whose file is missing is correctly flagged as an error; a manifest file sitting alongside a stored work is correctly excluded from orphan detection. All four behaved as intended, no false positives or negatives.

### Session close

Knowledge candidates: None — structural/authoring-standard change, not a domain fact.
Open flags: None.
Push status: Pushed — directly to `main`.

STATUS: CHECKPOINT
Completed: Renamed "deep well" to "reference work" throughout the template and dropped the `library/deep-wells/` subfolder — stored reference works now live directly in `library/`. Updated the mining/extraction language that came with the old metaphor for consistency, not just the folder name. Rewrote and tested the corresponding `scripts/validate.ps1` logic against a disposable fixture before trusting it. No mechanics changed — same checks, same severities, simpler surface.
Next: Not yet ported to `familien-boe` or `longstraw`.
Waiting for: Direction on the next task.

---

## [Claude] — Turn 18 | 2026-08-11

Human (working outside any specific project, asking a general question this repo had no answer for) asked whether this template is equipped to handle sensitive/confidential information — specifically whether it would even *flag* the human before storing something sensitive, given that a fork is sometimes used to back a public GitHub repo. Investigated before answering: the only existing mechanism is `[SENSITIVE]` (`MarkdownConventions.md` §8), which is a post-hoc documentation tag an author has to remember to apply — it doesn't gate whether content gets written in the first place, has no relationship to whether it gets committed or pushed, and there is no secret-scanning anywhere in `scripts/pre-commit-check.ps1` (which only checks staged *filenames* against the system-layer list, never content) or `.gitignore` (which ignores only `temp/`). Nothing in the repo mentions repo visibility at all, and the "commit and push, almost always" Standing Rule actively pushes in the wrong direction for this case. Confirmed gap, not a hypothetical one.

Human then shared a detailed implementation report from a sibling fork (`kej-context-architecture`, a genealogy-research project) that had hit this for real: an audit found ~150 individuals' unredacted records, sensitive images, and — worst of all — raw source manuscripts sitting unredacted in the live public working tree, requiring a `git-filter-repo` history rewrite to recover from. That fork's fix was a two-repo pattern: a private companion repo mounted as a git submodule, gated by a strict "never opened unless named this turn, by the human" Hard Constraint, with intake triage, a Cornerstone Rule extension, structured-data redaction, and review-queue counterparts.

**Assessed rather than adopted wholesale.** The full two-repo submodule pattern is right-sized for systematic, high-volume sensitive material (kej's actual shape) but is real setup and maintenance friction — a second repo, submodule init/update discipline, a pointer commit that must stay in sync — for a template meant to be fork-and-go. Most forks will have occasional sensitive content, not a systematic stream of it. Recommended and built a tiered design instead: a cheap universal baseline in the template itself, plus the full pattern documented as an opt-in extension for forks that actually need it. Also flagged, per the human's question about a Google Drive alternative, that swapping the companion repo for a non-git store trades away mechanical cross-reference validation (diffable history, pre-commit gating) and doesn't remove the need for the Hard Constraint — a connector-backed store has no "uninitialized submodule = nothing on disk" safety net.

**Built:**

- `ROUTING.md` (1.11 → 1.12) — new Hard Constraint: pause and ask before writing a secret, credential, or third-party confidential detail into any tracked file, including content the human pastes or dictates directly. Points to environment variables/secrets managers for credentials (never git), to `[SENSITIVE]` for confidential-but-storable content, to the new pre-commit secret check as a mechanical backstop (not a substitute for the judgment call), and to `knowledge/flow/restricted-tier.md` for systematic cases. Standing Rules — added a one-line cross-reference from "Commit and push, almost always" noting it doesn't override the new constraint. Quick Task Guide — two new entries ("I think what I'm about to write down is a secret..." and "My commit was blocked by the secret-pattern check").
- `MarkdownConventions.md` (1.4 → 1.5) — §8 gained a clarifying note: `[SENSITIVE]` documents a decision already made about content already written; it is not the gate that decides whether the content should have been written at all — that's the new `ROUTING.md` Hard Constraint.
- `scripts/pre-commit-check.ps1` — new secret-pattern scan, added before the existing system-layer check. Scans staged *added* lines (`git diff --cached -U0`) against six narrow, high-confidence regexes (AWS access key IDs, GitHub/Slack/Stripe token prefixes, private-key block headers, generic bearer tokens) — deliberately shape-based rather than free-form heuristics like bare `password=` or entropy scoring, which keeps false positives low enough to block rather than warn. An inline `pragma: allowlist secret` comment on the same line, or `git commit --no-verify`, are the two visible bypasses.
- New `knowledge/flow/restricted-tier.md` (v1.0) — the opt-in extension, generalized from `kej`'s report: when to adopt it (§2, a volume test), the companion-repo design and Hard Constraint (§3–4), structure and intake/triage discipline (§5–6), the Cornerstone Rule extension (§7), structured-data redaction with the record-interleaving gotcha called out generally rather than tied to any one format (§8), review-queue and correspondence patterns (§9–10), a recommendation against the companion repo having its own `ROUTING.md` (§11), access-model and validation-tooling notes (§12–13), the non-git-store alternative and its trade-offs (§14), and a setup checklist (§15). Deliberately excludes the genealogy-specific remediation walkthrough beyond a one-paragraph pointer — the document's purpose is proactive setup, not incident response.
- `Architecture.md` (1.5 → 1.6) and `README.md` (1.3 → 1.4) — each gained one optional setup-step line pointing to `restricted-tier.md`, explicitly marked as skippable for the common case.

**Tested before trusting.** Staged a throwaway file containing a fake AWS key (`AKIAABCDEFGHIJKLMNOP`) and ran `pre-commit-check.ps1` directly via `pwsh` — blocked, exit 1, correct file and pattern name reported. Staged a benign file — passed, exit 0. Staged the same fake key with a trailing `pragma: allowlist secret` comment — passed, exit 0, confirming the escape hatch works. Re-ran the pre-existing system-layer check (staged `ROUTING.md` alone, without `session-log.md`) to confirm the new block didn't regress it — still correctly blocked. All test files/staged changes were reset and removed before any real work was staged.

Did not touch `knowledge/domains/authoring-guidelines.md`'s own Cornerstone Rule (§9.3) — the restricted-tier extension to it is documented as fork-adopted guidance inside the new file itself (§7), not merged into the base template's shared rule, since it only applies to forks that opt in.

### Session close

Knowledge candidates: None — structural/authoring-standard change, not a domain fact.
Open flags: None.
Push status: Pending — will push immediately after this turn is logged.

STATUS: CHECKPOINT
Completed: Closed the sensitive-data handling gap identified this turn with a tiered design — a universal baseline (ROUTING.md Hard Constraint, MarkdownConventions.md clarification, a tested secret-pattern pre-commit check) that every fork gets by default, plus a new opt-in `knowledge/flow/restricted-tier.md` extension (generalized from a sibling fork's real implementation and incident) for forks that will systematically handle sensitive material at volume. Cross-referenced from Architecture.md and README.md as an optional, clearly-skippable setup step.
Next: Not yet ported to `familien-boe` or `longstraw`.
Waiting for: Direction on the next task.

Also, per the human's standing instruction after this turn: this repo does not use feature branches — work directly on `main` and push there. The prior turn's changes had been pushed to a branch by the session's own launch configuration (outside this repo's control) and were fast-forwarded onto `main` and pushed after the fact; the stray remote branch could not be deleted from this session (GitHub rejected the delete with a 403 — push-only credentials) and was left for manual cleanup.

---

## [Claude] — Turn 19 | 2026-08-11

Human relayed a bug report from `longstraw-context-architecture` (a fork), found while creating that fork's first real `knowledge/domains/*/sources/manifest.md` in Turn 9 of its own `session-log.md`.

**The bug:** `Get-ManifestTableFirstColumn` (§9.1 referential-integrity check, added in Turn 6) scanned every line in a manifest starting with `|`, not just rows belonging to the intended `| File | ... |` table. Since `MarkdownConventions.md` requires a `## Version History` table at the bottom of every file, including manifests, that table's own header row and version row got misread as more source-file entries — the literal strings `"Version"` and `"1.0"` (first cell of each row) were flagged as phantom files missing from `sources/`. Same class of bug as the earlier `## 10. Version History` heading-match miss in `MarkdownConventions.md` (Turn 15): a check never exercised against a real file of the shape it's meant to validate, until a fork actually created one.

**Fix, exactly as `longstraw` proposed and verified independently before applying:** scope the scan to the block immediately following a `| File | ...` header row, stopping at the first line that isn't `|`-prefixed — the same section-scoping approach already used elsewhere in this script (e.g. Version History extraction), rather than treating every pipe-prefixed line in the document as a table row.

**Tested against a disposable fixture, not trusted on read.** Built a throwaway copy of the repo (`/tmp` scratch, discarded after) with a real `test-domain/sources/manifest.md` shaped exactly like the authoring-guidelines.md §9.1 template — a `| File | ... |` table followed by the mandatory `## Version History` table — and two matching files in `sources/`.

1. **Reproduced the bug first**, to confirm the fixture actually exercised it: ran the *pre-fix* function against the fixture and got exactly the reported failure — `ERROR: lists 'Version' but that file does not exist` and `ERROR: lists '1.0' but that file does not exist`, nothing else (only the first cell of each Version History row is captured, which is why `Date`/`Summary` didn't also appear as phantom errors).
2. **Applied the fix, re-ran on the same fixture:** clean, `Validation passed - no issues found` — no phantom errors, both real files correctly matched.
3. **Broke it for real** (deleted one of the two files the manifest lists): correctly caught as a single genuine error, no phantom errors alongside it.
4. **Added an orphan file** (a file in `sources/` not listed in the manifest): correctly caught as a warning, confirming the untouched second half of the check (files-on-disk-not-in-manifest) still works.

**File changed:** `scripts/validate.ps1` — `Get-ManifestTableFirstColumn` rewritten to scope to the `File` table block only. No other logic touched.

### Session close

Knowledge candidates: None — tooling fix, not a domain fact.
Open flags: None.
Push status: Pending — will push immediately after this turn is logged, directly to `main`.

STATUS: CHECKPOINT
Completed: Fixed the `Get-ManifestTableFirstColumn` phantom-file bug reported by `longstraw` (Version History table rows misread as source-file entries) by scoping the scan to the `File` table block only, matching the section-scoping pattern already used elsewhere in the script. Verified against a disposable fixture: reproduced the original bug first, confirmed the fix clears it, then confirmed both a real missing file and a real orphan file are still caught correctly.
Next: `familien-boe` and `longstraw` remain ahead of this repo on their own local fixes/additions until their next sync check; this fix should flow back to `familien-boe` too, since it shares the same manifest check.
Waiting for: Direction on the next task.

---

## [Claude] — Turn 20 | 2026-08-11

Human noted that the last two turns (18 and 19) both landed here only because they personally relayed findings from `kej-context-architecture` and `longstraw-context-architecture` by hand — nothing in this template prompts a fork session to surface a template-level finding in the first place, or gives it anywhere durable to go if the human isn't in the room to relay it that same conversation. Confirmed the gap by checking: `knowledge/flow/upstream-sync.md` is entirely one-directional (fork checks/pulls from upstream); `[FLAG FOR SYSTEM]` and Subproject Transcendence (`Architecture.md` §5) only route within a single repo, never across the fork-to-upstream boundary.

Talked through the design before building. Two open questions, both resolved by the human directly rather than assumed:

1. **Should a fork with upstream repo access ever write to it directly, to skip the relay?** No — explicit, considered "no": direct writes would "circumvent [the human] as the gatekeeper." Access to a repo isn't authorization to decide what's worth surfacing in it — the same principle every other cross-boundary flag in this architecture already enforces (`[FLAG FOR KNOWLEDGE UPDATE]`, `[FLAG FOR SYSTEM]`, cornerstone promotion: surface, wait for confirmation, only then act). A fork-local log is also the only path that behaves the same regardless of whether upstream access happens to be attached in a given session — a mechanism that sometimes writes directly and sometimes doesn't is exactly the kind of inconsistency this system is built to avoid.
2. **Should the log read as raw notes or a ready-to-paste prompt?** Ready-to-paste prompt, modeled directly on the two real examples that worked this session (the `kej` restricted-tier report and the `longstraw` bug report) — both were self-contained, addressed to a session with no shared memory, and ended in explicit instructions. Writing new entries to that same shape removes the translation work from the human, who is now the required relay point for every entry, not just an optional one.

**Built, mirroring the existing flag family exactly:**

- `knowledge/flow/operating-principles.md` (1.1 → 1.2) — §5 gained "Upstream feedback flags": a third flag type, `[FLAG FOR UPSTREAM]`, alongside the existing `[FLAG FOR KNOWLEDGE UPDATE]` and `[FLAG FOR SYSTEM]`. Same confirm-before-writing gate as the other two. Explicit: never written directly to the upstream repo regardless of in-session access.
- `knowledge/flow/upstream-sync.md` (1.2 → 1.3) — new §7 "Downstream Feedback: Reporting Template-Level Findings", the reverse-direction counterpart to the existing check/apply mechanism: how to recognize a finding as template-level rather than fork-local, the confirm-before-writing gate, the **Upstream Feedback Log** template (a sibling subsection to the existing sync marker inside `projects/system/TODO.md`'s System Maintenance Pass section), and a minimal `Open`/`Relayed` lifecycle with manual deletion once a later Check Procedure run shows the finding landed — no automated resolution tracking, deliberately, to keep the mechanism as small as the actual need. §2 cross-references the new section; Document Purpose updated to cover both directions; old §7 Version History renumbered to §8.
- `Architecture.md` (1.6 → 1.7) — §5 Subproject Transcendence gained a fourth table row for template-level findings, alongside the existing three (knowledge correction, system improvement, project-specific discovery), routing to the new Upstream Feedback Log.
- `ROUTING.md` (1.12 → 1.13) — new Hard Constraint against writing a template-level finding directly into the upstream repo even with access, and a Quick Task Guide entry walking through the confirm → log → human-relays sequence.

No new STATUS signal added — deliberately reused `STATUS: CHECKPOINT` and the existing confirm-before-writing gate rather than inventing new turn-protocol machinery for a mechanism that's really just "one more flag type, logged to one more file."

Did not touch `projects/system/TODO.md` in this repo — `upstream-sync.md`'s own scope note already excludes `proto-context-architecture` itself, which has no upstream to report findings to. The System Maintenance Pass section (sync marker + Upstream Feedback Log) is something each fork adds to its own `TODO.md`, same as the sync marker already was.

### Session close

Knowledge candidates: None — structural/authoring-standard change, not a domain fact.
Open flags: None.
Push status: Pending — will push immediately after this turn is logged, directly to `main`.

STATUS: CHECKPOINT
Completed: Built the downstream-feedback counterpart to `upstream-sync.md` — a `[FLAG FOR UPSTREAM]` flag type (`operating-principles.md` §5), a new §7 in `upstream-sync.md` defining the Upstream Feedback Log format and lifecycle, a fourth Subproject Transcendence row in `Architecture.md`, and a Hard Constraint plus Quick Task Guide entry in `ROUTING.md`. Two design decisions made explicitly by the human rather than assumed: forks never write to the upstream repo directly regardless of access, and log entries are written as ready-to-paste prompts, not raw notes.
Next: Not yet ported to `familien-boe` or `longstraw` — both would benefit from this given they're the two forks that have already generated real upstream findings.
Waiting for: Direction on the next task.

---

## [Claude] — Turn 21 | 2026-08-11

Human caught a real side effect of Turn 18's `restricted-tier.md`: it invented the `incoming/` landing-zone concept entirely inside that document, framed around the sensitivity problem ("give both repos an `incoming/` landing zone... put it in the companion repo, not the main one"). This template never had a generic version of the pattern — only the gitignored, ephemeral `temp/` — so a fork *without* the restricted tier (the human's own home-IT-infrastructure fork, reported directly) had no sanctioned durable folder for sharing files with a session at all, and its own session was advising against creating one because nothing in the inherited template supported it. Confirmed the gap directly: `temp/` is gitignored (verified — nothing survives a clone) and its own Hard Constraint says not to do substantive work there, so it structurally cannot serve as a durable file-sharing folder; `restricted-tier.md` was, before this turn, the template's only place `incoming/` was mentioned at all.

**Fix: give the base template the generic pattern it should have had from the start, then have `restricted-tier.md` reference it instead of re-deriving it.**

- New top-level `incoming/` folder, git-tracked (not gitignored) — created with a `.gitkeep` placeholder so it exists in a fresh clone rather than being a folder only referenced in prose (`temp/` itself has no placeholder and doesn't physically exist in this repo, but `temp/` is gitignored so that's fine for it — `incoming/` needs to actually be there since it's meant to be committed).
- `Architecture.md` (1.7 → 1.8) — §2 File Structure diagram gained `incoming/`, plus a new "`incoming/` vs `temp/`" subsection distinguishing durable/git-tracked (share a real file, triage it out to its real home, don't let files accumulate) from ephemeral/gitignored (momentary tool handoff, nothing survives a session).
- `README.md` (1.4 → 1.5) — folder diagram updated to match.
- `ROUTING.md` (1.13 → 1.14) — the `temp/` Hard Constraint now explicitly states it doesn't apply to `incoming/`; new Quick Task Guide entry for setting one up or using it.
- `knowledge/flow/restricted-tier.md` (1.0 → 1.1) — §6 reframed: its `incoming/` is now presented as the restricted-tier's own copy of the base template's generic pattern, gated by that document's Hard Constraint, not something invented fresh in that document. No mechanics changed — same failure mode, same triage procedure, same companion-repo-only placement for genuinely untriaged material.

The relationship is now stated explicitly in both directions: a fork's public `incoming/` is for anything already known to be fine to have in that repo; a restricted-tier fork's companion-repo `incoming/` is specifically for material that hasn't been triaged for third-party sensitivity yet. The two coexist rather than compete — adopting the restricted tier doesn't remove the public `incoming/`, it adds a second, more gated one.

### Session close

Knowledge candidates: None — structural/authoring-standard change, not a domain fact.
Open flags: None.
Push status: Pending — will push immediately after this turn is logged, directly to `main`.

STATUS: CHECKPOINT
Completed: Added a generic, git-tracked top-level `incoming/` folder to the base template (with a `.gitkeep` placeholder), documented in `Architecture.md` §2 alongside a clarified distinction from `temp/`, cross-referenced from `ROUTING.md`'s Hard Constraints and Quick Task Guide, and reframed `restricted-tier.md` §6 to present its own `incoming/` as the restricted-tier variant of this pattern rather than the pattern's origin. Closes a real gap the human hit directly in a fork that had no restricted tier and therefore no sanctioned file-sharing folder at all.
Next: Not yet ported to `familien-boe` or `longstraw`; the human's home-IT-infrastructure fork can pick this up via its own upstream-sync check once this is pushed.
Waiting for: Direction on the next task.

---

## [Claude] — Turn 22 | 2026-08-11

Human asked, in a broader discussion of whether a medical-curriculum fork was viable, for two `scripts/validate.ps1` additions discussed but not yet built: (1) a mechanical check for Index structural integrity (stale links, orphan sections) — since the loading-hierarchy discipline in `ROUTING.md` Step 4 depends entirely on the Index staying trustworthy, and a script can catch the structural half of "trustworthy" even though the semantic half still needs a human read; (2) a "heaviness" tripwire for domain files, since a domain that's silently grown too large defeats the loading hierarchy's whole purpose (a session defaulting to a full-file load burns far more context than the hierarchy is meant to cost) — explicitly framed around not wasting the AI credit budget on context loading alone.

**Built both, plus the Executive-Summary-specific variant of the second, as agreed:**

- **Index structural integrity** (new `Get-GithubAnchorSlug` helper + a check applied to every `.md` file with an `## Index` heading, not just domains — scoped generically since the Index convention itself is repo-wide, per `MarkdownConventions.md` §3): every Index link must resolve to a real `##` heading in the same file (error if not — a stale entry), and every real `##` section (excluding `Document Purpose` and `Index` themselves) must have a corresponding Index entry (warning if not — an orphan section). Explicitly scoped to structural drift only; whether an Index description still semantically matches its section is left to the Maintenance Pass, since no script can judge that.
- **Domain heaviness**: three independent tripwires per `knowledge.md` — total line count (>600), Index entry count (>15), and Executive Summary length specifically (>20 non-blank lines, much lower than the others since Step 4 Level 3 loads the Executive Summary on nearly every query to that domain — that's the single most expensive place for bloat to hurt an ordinary session). All three are warnings, not errors, and the thresholds are named constants at the top of the block for a fork to retune.

**First real run against this repo caught two genuine pre-existing bugs, not just fixture cases:**

1. My own `Get-GithubAnchorSlug` had a real bug on first run — it collapsed runs of whitespace to a single hyphen, which produced a false "stale Index entry" against `authoring-guidelines.md`'s own correct anchor for "9. Evidentiary Sources & Reference Works" (`#9-evidentiary-sources--reference-works`, a genuine double hyphen — GitHub's real algorithm strips the `&` but doesn't collapse the two spaces it leaves behind into one hyphen). Fixed by replacing each space individually instead of collapsing `\s+`.
2. With that fixed, two *real*, previously-invisible gaps surfaced: `authoring-guidelines.md`'s own Index never included its own Version History section, and — more consequential — `example-domain/knowledge.md`'s Index template has *never* included a Version History entry, meaning every real domain anyone has ever created by copying this template inherited the same gap silently. Fixed both by adding the missing Index entries (`authoring-guidelines.md` 1.8 → 1.9, `example-domain/knowledge.md` 1.1 → 1.2).

**Tested against deliberately broken fixtures before trusting either check**, same discipline as every prior script change this session, in a disposable `/tmp` copy of the repo (discarded after):

- Index check: broke one Index link to point at a nonexistent anchor (caught as an error) and added a real section with no Index entry (caught as a warning, correctly also flagging the now-effectively-unindexed neighboring section) — then reverted and confirmed clean again.
- Heaviness check: built a throwaway domain padded past all three thresholds at once (676 lines, 18 Index entries, a 30-line Executive Summary) — all three warnings fired correctly and independently, with the Index-integrity check itself catching an unrelated bug in my own test fixture along the way (I'd forgotten to index the fixture's own Version History section) — confirming the two new checks compose correctly rather than interfering with each other.

**File changed:** `scripts/validate.ps1` (two new check blocks + one helper function). Also `knowledge/domains/authoring-guidelines.md` and `knowledge/domains/example-domain/knowledge.md` (the two real Index gaps the new check found).

### Session close

Knowledge candidates: None — tooling addition plus two real pre-existing documentation bugs, not a domain fact.
Open flags: None.
Push status: Pending — will push immediately after this turn is logged, directly to `main`.

STATUS: CHECKPOINT
Completed: Added Index structural-integrity checking and domain-heaviness tripwires (file size, Index entry count, Executive Summary length) to `scripts/validate.ps1`, tested against deliberately broken fixtures before trusting either. The first real run surfaced and fixed a genuine bug in the new check's own anchor-slug algorithm, plus two real pre-existing gaps in this repo's own content — most notably that `example-domain/knowledge.md`'s Index template never indexed its own Version History section, a gap every real domain copied from it would have silently inherited.
Next: Not yet ported to `familien-boe` or `longstraw` — both would benefit, especially `longstraw` given its own manifest-check history.
Waiting for: Direction on the next task.

---

## [Claude] — Turn 23 | 2026-08-18

Human reported that every fork of this template, and this repo itself, keeps creating branches and pushing to them instead of `main` — including this very session, which had been placed on `claude/proto-template-sensitive-data-368nn7` by its own launch configuration two turns ago and had to be fast-forwarded onto `main` by hand once the human caught it. Asked for something with more teeth than the existing Standing Rule, while explicitly preserving room for branching when the human asks for one or the LLM has a real reason.

**Root-caused why the existing rule wasn't working, not just reworded it.** The "work directly on `main` by default" rule (`ROUTING.md` Standing Rules) is a written instruction with no mechanical backing at all — unlike the system-layer-logging and secret-content rules, which both have a `pre-commit` hook enforcing them. Two separate failure paths converge on the same symptom: (1) a session's own generic training-instinct toward "always branch" competing with, and sometimes winning against, a Standing-Rule-level instruction; (2) a session-launch environment assigning a branch before the session's first git command runs at all, which no amount of in-repo wording can prevent — exactly what happened here two turns ago.

**Response, matched to which failure path it addresses:**

1. **Promoted the rule to a Hard Constraint** (`ROUTING.md`) — reworded to name the instinct directly ("a model's own training-instinct toward 'always work on a feature branch' — that instinct is wrong for this repo") rather than stating the rule neutrally, and to name exactly two exceptions: the human explicitly asked for a branch, or there's a specific, stated reason for isolation — either one requires saying so plainly, not branching silently. This addresses failure path 1; it cannot address path 2, and says so.
2. **Built a mechanical backstop for path 1**: a new `pre-push` git hook (`.githooks/pre-push` + `scripts/pre-push-check.ps1`), activated the same way as the existing pre-commit hook (`core.hooksPath`, already wired into `.claude/hooks/session-start.sh`) — no new activation step needed. Blocks any push that creates or updates a branch other than `main` (branch deletions and tag pushes are never blocked), requiring a deliberate `git push --no-verify` to override, same visible-bypass pattern as the two existing pre-commit checks. Honestly scoped in its own comments and in `ROUTING.md`: this only fires when a session drives `git push` itself, so it cannot address failure path 2 either.
3. **Named path 2 explicitly and gave it a procedure**, since no hook or instruction can prevent it: if a session finds itself already on a non-default branch it didn't choose, developing there is fine, but landing the finished work on `main` is part of finishing the task, not optional — fast-forward or merge onto `main` and push there before considering the work done, unless the human says otherwise. This formalizes exactly the recovery this session performed by hand two turns ago, so it doesn't have to be re-litigated every time it recurs.

**Tested the hook properly before trusting it**, same discipline as the pre-commit hooks: unit-tested `pre-push-check.ps1` directly against four hand-built stdin payloads matching git's real pre-push input format (push to `main` — allowed; push to a new branch — blocked; branch deletion — allowed; tag push — allowed), all four correct. Then ran a full end-to-end test — a real bare local remote, a real clone with `core.hooksPath` set, a real `git push` to a feature branch. First attempt at the end-to-end test was invalid (cloned before the new hook files were committed anywhere, so the clone genuinely had no `.githooks/pre-push` to run — caught immediately since the hook binary was missing rather than silently passing) — rebuilt the fixture from a full working-tree copy including the new, not-yet-committed hook files, committed with `--no-verify` as the baseline, and reran. Confirmed: push to a feature branch is blocked and nothing lands on the remote; push to `main` succeeds normally; `git push --no-verify` to the feature branch is a real, working bypass.

**Files changed:** `.githooks/pre-push` (new, executable), `scripts/pre-push-check.ps1` (new), `ROUTING.md` (1.14 → 1.15 — Hard Constraint promoted and reworded, Standing Rules entry shrunk to a pointer, new Quick Task Guide entry), `Architecture.md` (1.8 → 1.9 — §6 step 10 reworded from singular "the pre-commit hook" to "the git hooks," since one activation command now covers both), `scripts/validate.ps1` (existence checks for the two new hook files, alongside the existing pre-commit ones).

### Session close

Knowledge candidates: None — structural/tooling change, not a domain fact.
Open flags: None.
Push status: Pending — will push immediately after this turn is logged, directly to `main`.

STATUS: CHECKPOINT
Completed: Promoted "work directly on `main` by default" from a Standing Rule to a Hard Constraint naming the model's own branch-by-habit instinct directly, backed it with a new, tested `pre-push` hook that mechanically blocks pushes to non-default branches (deliberate `--no-verify` bypass, same pattern as the existing hooks), and gave explicit procedural guidance for the one failure path no in-repo mechanism can prevent — a session-launch environment pre-assigning a branch, exactly as happened in this session two turns ago.
Next: Not yet ported to `familien-boe` or `longstraw` — both were named directly as repeat offenders and would benefit immediately.
Waiting for: Direction on the next task.

---

## [Claude] — Turn 24 | 2026-08-18

Human reported real, recurring conflicts from jumping between Claude Code web and VS Code + Copilot on the same forks: the newly-started interface doesn't always have what the other one already pushed, since a fresh session has no natural "pull before I start" moment. Asked for a mechanical check, run whenever a session is about to work in the repo — and noted this is also exactly what's needed for real multi-person team collaboration on a shared `main`, not just a single person's two interfaces.

**Distinguished this from what already existed, rather than assuming it was missing entirely.** `commit-push.ps1` (built Turn 16) already fetches, detects divergence, and rebases — but only right before a push, *after* a session has already read files and done work against whatever was locally current. `git-collaboration.md` §1 had literally already named the gap this turn closes: "there's no natural 'pull before I start' moment unless something instructs it" — that sentence had sat there unaddressed since Turn 16. The two checkpoints are genuinely complementary, not redundant: catching staleness before work begins is what actually avoids wasted effort and late-discovered collisions; catching it right before push (already built) is the necessary last line of defense regardless.

**Built `scripts/sync-check.ps1`** — deliberately conservative, matching the same safety posture as everything else in this template that touches git automatically: fetches `origin/<branch>`, and only fast-forwards when it's unambiguously safe (no local uncommitted changes, no local-only commits). Anything less clean-cut — behind with local edits in progress, or a genuine divergence — is reported plainly and left untouched, with a pointer to `git-collaboration.md` §4-5 for the real resolution procedure. Always exits 0: this is informational infrastructure that keeps a session from starting work on stale content, not a gate that should ever block anything.

**Wired into `.claude/hooks/session-start.sh` — and found a real bug in that file while doing it.** The script had two early `exit 0`s guarding its PowerShell-install logic: one for any non-remote (local) session, one for a remote session where `pwsh` was already cached. Appending the new sync-check call at the end of the file, as originally planned, would have meant it only ran in the single narrow case of "remote session, `pwsh` not yet installed" — i.e. almost never. Restructured both early exits into an `if` gate around the install block instead, so execution always reaches the new sync-check call regardless of path. Verified this mattered, not just in theory: ran the restructured script directly with `CLAUDE_CODE_REMOTE` unset (the "local" path) and with it set to `true` with `pwsh` already present (the "cached remote" path) — both previously would have exited before the install block; both now correctly reach and run `sync-check.ps1`. `bash -n` syntax-checked the result; the install commands themselves were only moved, not altered.

**Tested `sync-check.ps1` against all five real states, not just the happy path**, using two real clones of a bare local remote to simulate the actual two-interface scenario:

1. Up to date — reported cleanly, no action.
2. Behind by 1, clean working tree (the exact reported scenario — "session A" pushed, "session B" starts fresh) — fast-forwarded automatically, listed the incoming commit, and the file content was confirmed actually updated afterward.
3. Behind by 1, with an uncommitted local edit present — correctly refused to auto-sync, left the edit untouched (verified via `git status` before and after), and named the fix.
4. Diverged (both ahead and behind) — correctly detected and refused to touch anything, pointed at the rebase procedure.
5. Ahead only (a genuine unpushed local commit, nothing new upstream) — correctly reported as informational, no action taken.

**Updated `git-collaboration.md`** to document the new checkpoint as new §2 "Sync at Session Start," ahead of the existing §2 "Fetch Before Every Push" (renumbered to §3, with §4-6 shifting accordingly and all internal cross-references fixed to match) — and corrected §1's own text, which had been describing the gap this turn closes as still open. Updated `ROUTING.md` Step 1 (renamed "Sync, then load") to instruct running this before loading or trusting anything else, with the honest caveat that Claude Code gets this automatically and other setups (Copilot) depend on the model actually doing it — same reliance class as any other unhooked instruction here. Added a Quick Task Guide entry. Added an existence check for the new script to `scripts/validate.ps1`.

**Files changed:** `scripts/sync-check.ps1` (new), `.claude/hooks/session-start.sh` (restructured, bug fixed), `ROUTING.md` (1.15 → 1.16), `knowledge/flow/git-collaboration.md` (1.0 → 1.1), `scripts/validate.ps1` (existence check).

### Session close

Knowledge candidates: None — structural/tooling change, not a domain fact.
Open flags: None.
Push status: Pending — will push immediately after this turn is logged, directly to `main`.

STATUS: CHECKPOINT
Completed: Built and wired in `scripts/sync-check.ps1` — a session-start sync check that safely auto-fast-forwards when possible and clearly reports when not, closing a gap `git-collaboration.md` had named but left unaddressed since Turn 16. Found and fixed a real bug in `.claude/hooks/session-start.sh` while wiring it in (two early exits that would have made the new check run almost never), verified the fix actually reaches both previously-skipped paths, and tested all five real sync states (up to date, safe-behind, behind-with-local-changes, diverged, ahead-only) against real local clones before trusting any of it.
Next: Not yet ported to `familien-boe` or `longstraw` — the human's stated cross-interface workflow is exactly what this was built for.
Waiting for: Direction on the next task.

---

## [Claude] — Turn 25 | 2026-08-18

Human compared this repo against how the AI industry currently frames "context engineering" (Gartner's July 2025 definition, RAG/vector-DB tooling, MCP, agent-memory services) for a possible career pivot, then asked which of the resulting ideas could practically be added to proto without compromising what makes it distinctive. Talked through four candidates and a rough priority order: an MCP server exposing the routing table and domain loading (best fit — a deterministic interface on top of existing logic, no change to how decisions get made), a retrieval eval harness (cheap, closes a real gap, prerequisite for honestly evaluating anything semantic), an opt-in semantic-search layer for Step 4 (real embeddings/vector-store experience, scoped as an optional aid with the hand-curated Index staying ground truth), and a LangGraph/memory-as-a-service exploration recommended as a separate standalone project rather than a proto change, since both fight the audit-first design harder than the rest and real forks — including a production one — depend on proto's current stability.

Human then asked whether to self-host the MCP server for AI sessions beyond this one to use. Recommended scoping any first version to personal/team hosting rather than a broadly-reachable public service — a real hosted server is real infrastructure (uptime, auth, rate limiting) and, more importantly, a leak-surface risk for any fork that also holds a restricted-tier companion repo with genuinely sensitive content; a routing server has no business being the thing that exposes that. Also noted plainly that "other AIs using it" isn't automatic — it requires the server to be configured as an MCP connector wherever a given session actually runs.

Asked to log all of this as a backlog for later, not build any of it now.

**Built:** `projects/system/TODO.md` (1.2 → 1.3) — new "Backlog — Context-Engineering / Industry-Tooling Exploration" section, the four candidates each with enough context to be picked up cold by a future session, plus the self-hosting scoping note. This is a project-layer file (not on the system-layer tracked-paths list), so no pre-commit-hook-forced session-log entry was actually required for this edit — logging it anyway for continuity, matching how every other change this session has been narrated.

### Session close

Knowledge candidates: None — backlog note, not a domain fact.
Open flags: None.
Push status: Pending — will push immediately after this turn is logged, directly to `main`.

STATUS: CHECKPOINT
Completed: Logged four context-engineering/industry-tooling ambitions (MCP server, eval harness, opt-in semantic-search layer, and a separate LangGraph/memory-service practice project) plus a self-hosting scoping note, in a new Backlog section of `projects/system/TODO.md`. Nothing built — explicitly deferred for later, per direct instruction.
Next: None scheduled — human said they'll come back to these individually.
Waiting for: Direction on the next task.

---

## [Claude] — Turn 26 | 2026-08-22

Human relayed two `[FLAG FOR UPSTREAM]` findings from `kej-context-architecture`, both already confirmed worth relaying by the human running that fork — the mechanism built in Turn 20 working exactly as designed, this time carrying real content instead of being tested in the abstract. Per that mechanism's own rule, and an explicit instruction embedded in the relay, did not commit anything before presenting an assessment of each and getting confirmation.

**Finding 1 — no flag type or mechanism exists for a finding that needs confirmation from a specific named external party who isn't the session's own user.** `kej`'s fork represents a family's primary source and final genealogical authority, who isn't its day-to-day user — a case this template's three existing flags (all assuming the session's own user is the confirming party) had no answer for. Real, non-fork-specific gap, and one already assumed to exist by `restricted-tier.md` §9 without ever being defined at the base — same shape of gap as the `incoming/` finding in Turn 21. Assessed the proposed design (a queue file, a companion log it moves to once resolved, and an escalation discipline so low-confidence anomalies don't reach the named party until a real pattern emerges) as proportionate — smaller and tighter than the Turn 14 counterparty-flags proposal that needed real cutting down. Made two deliberate refinements before building, both surfaced to the human first: generalized the queue/log location from `kej`'s bespoke `grandfather-review/` folder to `projects/[name]/context/` (the folder this template already designates for project-specific working notes, rather than a new top-level convention); and documented the escalation discipline as a principle ("track anomalies in a lighter side file first, promote only once a real pattern emerges") rather than hardcoding `kej`'s specific "3+ instances" threshold as a universal rule.

**Finding 2 — the structured-data redaction check (`restricted-tier.md` §8) can't distinguish "legitimately public-by-name but restricted-detail" from a genuine accidental un-redaction.** A person can be public by identity while a narrower fact about them stays restricted; a check that only compares placeholder-presence flags that real, intentional case as a warning every run. `kej`'s fix — check whether the public record's own note text cross-references the restricted file by the same ID, and treat that as confirmation rather than a mismatch — generalizes cleanly with no code, only documentation, since §8 already describes the pattern rather than shipping an implementation.

**Built, after confirmation:**

- `knowledge/flow/operating-principles.md` (1.2 → 1.3) — §5 gained a fourth flag type, "External review flags" / `[FLAG FOR EXTERNAL REVIEW]`, same confirm-before-writing gate and structural shape as the other three, pointing at the new mechanism file for the queue/log/escalation details rather than inlining them into a flag definition already shared by three other flag types.
- New `knowledge/flow/external-review.md` (v1.0) — the queue/log file pattern (§2), the escalation discipline as a principle rather than a fixed number (§3), the flag-raising procedure (§4), and the restricted-tier counterpart (§5). Generalized from `kej`'s working `grandfather-review/queue.md`, with the two refinements above already folded in rather than left as follow-up edits.
- `knowledge/flow/restricted-tier.md` (1.1 → 1.2) — §8 gained the second gotcha as a new paragraph, phrased generically (no code, no fork-specific field names); §9 rewritten to point at `external-review.md` §5 instead of assuming a base mechanism that, until this turn, didn't exist.

### Session close

Knowledge candidates: None — structural/authoring-standard change, not a domain fact.
Open flags: None.
Push status: Pending — will push immediately after this turn is logged, directly to `main`.

STATUS: CHECKPOINT
Completed: Added a fourth flag type, `[FLAG FOR EXTERNAL REVIEW]`, and a new `knowledge/flow/external-review.md` defining the queue/log/escalation mechanism it points to — closing a gap `restricted-tier.md` §9 had assumed away since Turn 18 — and added a second, generalized gotcha to `restricted-tier.md` §8's redaction-validation guidance. Both relayed via `[FLAG FOR UPSTREAM]` from `kej-context-architecture`, both assessed and refined (not adopted verbatim) before building, per direct confirmation.
Next: Not yet ported to `familien-boe` or `longstraw`. `kej` itself would benefit from generalizing its own `grandfather-review/` implementation to match the new base pattern, once it next runs its upstream-sync check.
Waiting for: Direction on the next task.

---

## [Claude] — Turn 27 | 2026-08-22

Human relayed four upstream findings from an unnamed fork's own repo-wide Maintenance Pass (~5 weeks, 15 domains, 8 projects deep). Verified each against this repo's actual current code and history before building anything, rather than accepting the write-up as-is — one finding's framing didn't hold up, worth correcting rather than quietly adopting.

**Finding 1 — real bug, framing partly wrong.** Confirmed `validate.ps1`'s project Active/Retired regexes require a bare date immediately before the status word, and reproduced the described symptom directly: a project using a `2026-08-22 (later)`-style suffix silently drops out of both the active and retired counts, no warning. But searched this entire repo's history for the claimed "template convention" of same-day date suffixes and found zero occurrences — it isn't documented anywhere, and no prior turn ever fixed "the turn-numbering checker" for the same issue as claimed. This template already has an adequate mechanism for same-day multiple edits (bump the version number), so a date suffix isn't solving an unmet need here. Fixed the regex fragility anyway — a header field shouldn't silently misparse just because something unexpected follows the date — without adopting the suffix as a blessed convention. While verifying, found the turn-header regex (`session-log.md` parsing) has the identical bare-date assumption, undiscovered until now; fixed it in the same pass with a single shared date-field regex fragment, per the finding's own suggestion, closing what would otherwise have been a third occurrence of this exact bug shape.

**Findings 2 & 3 — both real, addressed together since they're the same category of gap** (a domain's own stale placeholder prose; other domains' stale plain-text references to superseded content) **at two points: prevention and backstop.** Added step 7 to `knowledge/domains/index.md` § Adding a Domain — grep the repo for stale mentions of the new domain at onboarding time, when it's cheap and the session already knows what changed. Added the retroactive backstop to `authoring-guidelines.md` §8's Maintenance Pass checklist, for anything onboarded before step 7 existed or that missed it anyway.

**Finding 4 — real, fixed at the source rather than just documented.** Confirmed `authoring-guidelines.md` §5 and the `validate.ps1` reciprocity check both treated every one-directional cross-reference identically. Documented the two-category split in §5 (genuine scope-exclusion pointers, permanently one-way, versus real content dependencies worth fixing) and cross-referenced it from §8. Upgraded the validator itself to detect "does NOT cover" phrasing within a window before a one-directional link and word its warning differently when found — kept as a visible warning either way, never suppressed, since the pattern match is a heuristic and not proof of intent.

**Tested all four against fixtures before trusting any of them,** same discipline as every prior script change this session:

- Finding 1: built a disposable project with a `(later)`-suffixed date, confirmed it now counts correctly (3 active projects including it); reverted the fix temporarily against the same fixture and confirmed the original bug reproduces exactly as described (2 active projects, the suffixed one silently missing) before re-applying the fix.
- Finding 4: built three disposable domains — one linking to another near "does NOT cover" phrasing (correctly got the differentiated wording), one with a plain unreciprocated link (correctly got the generic wording), then added the reciprocal link back and confirmed only that second warning cleared while the exclusion-pointer warning correctly persisted.

**Files changed:** `scripts/validate.ps1` (shared date-field pattern used in three places; reciprocity-check upgrade), `knowledge/domains/index.md` (1.2 → 1.3), `knowledge/domains/authoring-guidelines.md` (1.9 → 1.10).

### Session close

Knowledge candidates: None — structural/tooling change, not a domain fact.
Open flags: None.
Push status: Pending — will push immediately after this turn is logged, directly to `main`.

STATUS: CHECKPOINT
Completed: Fixed a real project-status-detection bug and a latent twin of it in turn-header parsing (shared regex fragment now used by both, plus the domain-onboarding step and Maintenance Pass items), and gave the cross-reference reciprocity checker a way to distinguish genuine scope-exclusion pointers from real drift instead of treating every one-directional link identically. All four relayed via upstream feedback from a fork's Maintenance Pass; one finding's "template convention" framing was checked and didn't hold up, corrected rather than adopted as stated; all four tested against disposable fixtures before trusting them.
Next: Not yet ported to `familien-boe` or `longstraw`.
Waiting for: Direction on the next task.

---

## [Claude] — Turn 28 | 2026-08-22

Human relayed a `[FLAG FOR UPSTREAM]` from `longstraw-context-architecture`: `ROUTING.md`'s Hard Constraints are only actually re-checked at session start (Step 1's sequence), with nothing telling a session to re-read the relevant constraint when it's asked directly, mid-session, about a past or in-progress action. Real incident behind it: a session on that fork, asked "why are you on a branch instead of main," answered from the outer harness's generic branch-per-task framing instead of re-reading `ROUTING.md` — which already had the correct, specific answer written — and only self-corrected after the human pushed back.

Verified before proposing anything. One framing correction: the finding said Hard Constraints are "framed and enforced only at session start," but the actual text never scopes them that way — "do not break these regardless of what the human asks" already reads as an ongoing rule. The real gap is narrower: no instruction tells a session to *re-check* the file on a relevant direct question, especially many turns past when it was last actually loaded. Also confirmed this isn't a hook-closeable gap — it's precisely the residual case the branch-default constraint's own text already admits the pre-push hook can't reach (a session-launch-assigned branch, pushed by the harness's own plumbing, not a local `git push` the hook could intercept). What failed was purely conversational: the session had the right answer on file and didn't go read it.

Proposed exact wording for confirmation before committing, per the flag's own explicit instruction to confirm wording first. Human approved as proposed, no changes.

**Built:** `ROUTING.md` (1.16 → 1.17) — a blockquote directly under the `## Hard Constraints` heading (not a separate Standing Rule, and not extended to Standing Rules generally — the flag scoped this to Hard Constraints specifically, so left Standing Rules alone rather than expanding scope unprompted): Hard Constraints apply for the whole session, not just at Step 1; a direct question touching one should trigger re-reading it before answering, not an answer from assumption or outer-session-launch framing.

### Session close

Knowledge candidates: None — structural change, not a domain fact.
Open flags: None.
Push status: Pending — will push immediately after this turn is logged, directly to `main`.

STATUS: CHECKPOINT
Completed: Added a blockquote to `ROUTING.md`'s Hard Constraints section stating they apply for the whole session and should be re-checked on a direct question about a past or in-progress action, not answered from assumption or outer-context framing. Relayed via `[FLAG FOR UPSTREAM]` from `longstraw-context-architecture`, prompted by a real incident; framing corrected (not literally "entry-only" in the text) before the fix was written, and exact wording confirmed with the human before committing, per the flag's own request.
Next: Not yet ported to `familien-boe` or `kej`.
Waiting for: Direction on the next task.
