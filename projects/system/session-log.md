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

---

## [Claude] — Turn 29 | 2026-08-22

Human relayed two findings from `homelab-context-architecture`, both verified before building.

**Finding 1 — sessions can misattribute a harness-imposed workflow constraint to the human or the repo.** Real incident: a session on that fork, run under branch-mandating harness tooling, complied all session, then described the branch requirement back to the human as "your standing instructions" — confronted directly, had to walk it back. Distinct from Turn 28's fix (that one was about re-checking a rule; this one is about correctly attributing where a rule came from). Confirmed `git-collaboration.md`'s actual scope is multi-writer collision handling, no overlap with constraint-provenance. Placed the fix in `ROUTING.md` Hard Constraints instead of `git-collaboration.md` as the finding suggested — this is a "never do X" rule of the same shape as the existing Hard Constraints there, needs to cover harness-level constraints generally (permission modes, outcome-branch targets), not just branches, and is narrower in scope than what `git-collaboration.md` actually covers.

**Finding 2 — `validate.ps1` never checked `index.md`'s `Last Updated` column against a domain's own file dates**, despite `index.md`'s own instruction saying to update it whenever `description.md`/`knowledge.md` changes materially. Confirmed the gap and the existing Status-consistency check's pattern to extend. Built the extension, then immediately caught a real, previously-invisible case in this repo's own content: `example-domain`'s Last Updated cell still said `2026-06-29`, six weeks stale against `knowledge.md`'s actual `2026-08-11` header date from Turn 22. Fixed the stale row in the same turn.

**Bonus, found while building Finding 2:** `Get-HeaderStatus` — the function the Status-consistency check itself depends on — had the identical bare-date assumption already fixed twice in Turn 27 (project Active/Retired detection, turn-header parsing) and missed there. Widened it to use the same shared `$dateFieldPattern` rather than leaving a fourth latent instance of the same bug. Added a matching `Get-HeaderDate` helper (bare date only, ignoring any trailing annotation) for the new Last-Updated comparison.

**Tested all three before trusting them**, in a disposable `/tmp` copy: the Last-Updated check against index-ahead (no warning), index-equal (no warning), and index-behind (warns with correct dates) cases; the `Get-HeaderStatus` widening against a `(later)`-suffixed domain header, confirming Status still parses correctly and the retirement-consistency check isn't disrupted by the suffix.

**Files changed:** `ROUTING.md` (1.17 → 1.18 — new Hard Constraint, Quick Task Guide entry), `knowledge/flow/git-collaboration.md` (1.1 → 1.2 — §1 pointer distinguishing its scope from harness-constraint attribution), `scripts/validate.ps1` (`Get-HeaderStatus` widened, new `Get-HeaderDate` helper, new Last-Updated staleness check), `knowledge/domains/index.md` (real stale `Last Updated` cell for `example-domain` fixed, found by the new check).

### Session close

Knowledge candidates: None — structural/tooling change, not a domain fact.
Open flags: None.
Push status: Pending — will push immediately after this turn is logged, directly to `main`.

STATUS: CHECKPOINT
Completed: Added a Hard Constraint requiring sessions to distinguish and disclose whether a workflow constraint came from this repo, the human, or the calling harness — never misattributing the third to the first two — and extended `validate.ps1` with a Last-Updated staleness check that immediately found and let us fix a real six-week-stale index row in this repo's own `example-domain`. Also closed a fourth latent instance of the bare-date regex bug found while building the second fix. Both findings relayed via `[FLAG FOR UPSTREAM]` from `homelab-context-architecture`.
Next: Not yet ported to `familien-boe`, `longstraw`, or `kej`.
Waiting for: Direction on the next task.

---

## [Claude] — Turn 30 | 2026-08-25

Human relayed five documents of hard, cross-fork evidence that the branch-default enforcement built two turns ago (Hard Constraint + pre-push hook) was not sufficient: a `familien-boe` post-mortem, a `longstraw` post-mortem (the most rigorous — four documented episodes with git-log evidence), and two shorter incident write-ups. Central, load-bearing fact: `longstraw`'s most recent stray branch was created and pushed to *four days after* the pre-push hook shipped, in a session that had the hook active.

**Synthesized five distinct root causes from the evidence, not assumed:**

1. Branch assignment happens before any repo convention can be read (already known, already documented as an irreducible limit).
2. **Two authority sources actively conflict, and nothing forces this repo's own convention to win** — `longstraw`'s harness injected "NEVER push to a different branch without explicit permission," worded exactly as absolutely as this file's own Hard Constraints, for a branch the harness itself had assigned. A session took it at face value.
3. **The pre-push hook has two real gaps**: it only fires after a whole session's work has already happened on the wrong branch, and it's silently bypassed by GitHub-API-based writes (`longstraw`'s `jaqueq` branch was pushed to twice via `create_or_update_file`, never touching a local git hook at all).
4. **"Land it before calling it done" has no forcing function** — `tut8v2` sat unlanded for four days; the session that created it even flagged the exact problem in its own log and moved on without resolving it.
5. A stale reference to "the two-branch/multi-session setup this fork is currently running under" raised the possibility that concurrent sessions genuinely needed separate branches at some point — asked the human directly rather than assume either way, since the fix differs completely depending on the answer. Confirmed: no current need for parallel branches in any fork. Root cause 5 is closed; "always `main`" can stay unconditional.

Two more findings, each from a different document, folded into the same fix: pushing a branch's commits to the remote `main` ref (`git push origin branch:main`) does not move local HEAD, so subsequent commits keep landing on the stale branch until `git checkout main` actually happens (the `.txt` postmortem); and a successful push to `main` does not change which branch the *hosting side* treats as default — only a genuinely empty repo's first-ever push does that automatically (the other `.txt` postmortem).

**Built, closing root causes 2, 3, and 4 plus both secondary findings:**

- `scripts/sync-check.ps1` — two new checks, confirmed by the evidence as the two highest-leverage additions. (1) A loud, write-path-blind "NOT ON 'main'" banner the moment a session starts on any other branch — deliberately independent of git fetch/push succeeding at all, since the evidence showed the actual failure mode is often a write path (GitHub API) no git hook could ever see. (2) A check against the remote's actual default branch (`git remote show origin`, parsed for `HEAD branch:`), closing the hosting-side-default-branch finding.
- `scripts/commit-push.ps1` — new `-AllowBranch` switch; the script now refuses to run at all on a non-`main` branch unless it's passed deliberately. Independently redundant with the pre-push hook on purpose: the hook depends on `core.hooksPath` being configured in a given clone, this doesn't depend on that at all.
- `ROUTING.md` (1.18 → 1.19): rewrote the branch-default Hard Constraint to describe all three mechanical layers as independent and non-substitutable, and tightened "land on `main`" to explicitly mean `git checkout main`, not just advancing the remote ref. Added a new Hard Constraint: when a harness's own instructions conflict with this repo's conventions, this repo wins, even when the harness is worded just as firmly — closing root cause 2. Added a new Standing Rule mirroring "never leave a push silently pending": never leave a branch silently unmerged — closing root cause 4. Added a matching Quick Task Guide entry.

**Tested before trusting, same discipline as every prior script change this session.** `sync-check.ps1`: built a bare local remote and a real clone, confirmed the branch banner fires correctly (and independently of fetch succeeding — it printed even when the feature branch had never been pushed anywhere), confirmed the remote-default-branch check correctly detects a mismatch by pointing a bare repo's `HEAD` symref at a non-`main` branch, and confirmed both checks stay silent on a correctly-configured `main` checkout. `commit-push.ps1`: this script resolves `git.exe` via Windows-specific paths that don't exist in this Linux sandbox (a known, previously-documented limitation, Turn 16) — extracted just the new branch-check logic into a standalone test against a real repo instead, confirmed it blocks on a non-`main` branch, proceeds normally on `main`, and proceeds with a visible notice when `-AllowBranch` is passed; separately confirmed the actual edited file still parses with no syntax errors.

**Files changed:** `scripts/sync-check.ps1`, `scripts/commit-push.ps1`, `ROUTING.md` (1.18 → 1.19).

### Session close

Knowledge candidates: None — structural/tooling change, not a domain fact.
Open flags: None.
Push status: Pending — will push immediately after this turn is logged, directly to `main`.

STATUS: CHECKPOINT
Completed: Closed three of five root causes identified from real cross-fork evidence that the existing branch-default enforcement was insufficient — authority conflict between harness and repo (new Hard Constraint), the pre-push hook's write-path and timing gaps (two new `sync-check.ps1` checks plus `commit-push.ps1`'s new `-AllowBranch` gate), and the missing forcing function for landing unmerged branches (new Standing Rule). Confirmed with the human that root cause 5 (possible legitimate concurrent-session need) doesn't apply to any current fork, so "always `main`" stays unconditional. Two secondary findings (pushing to remote `main` doesn't move local HEAD; a successful push doesn't change the hosting side's default branch) folded into the same fix. All new logic tested against real repos before trusting it.
Next: None of this is yet ported to `familien-boe`, `longstraw`, `homelab-context-architecture`, or `kej` — all four would benefit, `longstraw` most directly since its own postmortem is what drove this turn.
Waiting for: Direction on the next task.

---

## [Claude] — Turn 31 | 2026-08-31

Human asked how the proto would handle two forks loaded into one session — motivated by a real scenario: a "children's learning" fork (`hh-learning`) and a general family fork (`familien-boe`) both being open at once, and wanting to deliberately mix a third fork's career-domain content into a kids'-education project. Confirmed the base template has no answer for this: `ROUTING.md`, `Architecture.md`, and `routing-rules.md` all assume exactly one repo's routing table governs a session, and the closest existing precedent (`restricted-tier.md`'s companion-repository pattern) is built for a different, asymmetric problem — access control between a public repo and a gated one holding real third-party sensitive material, not convenience mixing between peer forks the same person already owns.

Human then asked what a deliberate "repo-mixing" feature would require, and offered to attach two real forks to ground the design rather than working from the template in the abstract. Attached `sunshinezip/hh-learning` and `sunshinezip/familien-boe` (read-only) and reviewed their actual structure before designing anything:

- `hh-learning` diverges structurally from the standard `knowledge/domains/[name]/` layout — it uses fixed top-level areas (`children/`, `curriculum/`, `homeschool-compliance/`, `friskole-initiative/`, `folkeskole-system/`, `materials/`, `prep/`) instead, because a generic domain folder was a worse fit for its subject matter. Confirms a mixing design can't assume the standard domain path.
- `hh-learning` already carries an explicit, ad hoc Hard Constraint against linking into `familien-boe`: restate facts directly (re-confirmed, not copied as a live cross-reference) rather than cross-referencing a fully independent repo. This is real, working precedent for §8 of the new document below.
- `familien-boe` already has a two-tier sensitivity system (`[SENSITIVE]`/🔒, `[SENSITIVE: severe]`/⛔, `MarkdownConventions.md` §8) and a full `extraction-procedure.md` mechanism for building purpose-scoped, human-reviewed shareable extracts for external recipients — explicitly not automatic, not a redacted mirror, not committed back into the repo. This is the direct precedent for gating what content is even safe to pull across fork boundaries, reused rather than reinvented.

Designed and wrote `knowledge/flow/repo-mixing.md` — a new opt-in flow document, mirroring `restricted-tier.md`'s structure (Routing check, Edit guard, Hard Constraints, Setup Checklist). Core design: exactly one fork is **home** per mixing session (owns routing authority, Hard Constraints, and all writes, generalizing `restricted-tier.md` §11's single-authority reasoning from the access-gated case to the peer-fork case); every other fork present is a **guest**, read-only, declared explicitly at session start rather than inferred. Guest content is gated by an export registry (§6, marking which domains are mixable — default-closed for anything never written with an outside-fork audience in mind) and by the sensitivity tags where a guest fork carries them (§7, reusing `familien-boe`'s tiers and `extraction-procedure.md`'s handling rules rather than inventing new ones). Anything durable that crosses gets restated into home's own tracked files, never left as a live cross-repo link (§8, generalizing `hh-learning`'s existing convention), and logged in a new `projects/system/mixing-log.md` pattern mirroring the extraction log (§9). Mounting mechanics (§10) are deliberately left environment-agnostic — no submodule requirement, unlike the companion-repo pattern, since there's no access-control reason to couple two repos the same person already fully owns. §11 covers domain-name qualification across repos with divergent structure. §12 works the human's own example (learning fork as home, career fork as guest, drop-off/pickup logistics as the stated purpose) end to end.

Cross-referenced the new document from `README.md`'s setup checklist (new optional step 9, alongside the existing restricted-tier step 8) and bumped its Version History.

**Files changed:** `knowledge/flow/repo-mixing.md` (new), `README.md` (1.5 → 1.6).

### Session close

Knowledge candidates: None — structural/tooling document, not a domain fact.
Open flags: None. Not yet ported to any fork via `[FLAG FOR UPSTREAM]` in the other direction — this originated here, in the template, directly from a live design conversation grounded against two real forks, rather than being relayed from a fork's own incident.
Push status: Pending — will push immediately after this turn is logged.
Note on branch: this session was assigned `claude/multi-fork-session-routing-koesjw` by the launching harness, not by the human and not by this repo's own convention — disclosed per the Hard Constraint on harness-vs-repo conflicts. The harness's own instructions for this session direct all commits and the final push to that branch specifically (a designated review branch, not a stray one picked by habit), so this turn is being pushed there rather than landed on `main` immediately; flagging this explicitly rather than silently deferring it, per the "never leave a branch silently unmerged" Standing Rule.

STATUS: CHECKPOINT
Completed: Attached and reviewed two real forks (`hh-learning`, `familien-boe`) to ground a new opt-in pattern, then designed and wrote `knowledge/flow/repo-mixing.md` — home/guest routing authority, an export registry for what's mixable, a sensitivity gate reusing existing tiering, a restate-never-link rule, and a mixing log, generalizing real precedent found in both attached forks rather than inventing the mechanism from scratch. Cross-referenced from `README.md`.
Next: Not yet adopted by any actual fork — this is template-layer only until a human decides to adopt it in `hh-learning`/`familien-boe`/a third career fork.
Waiting for: Direction on the next task, and a decision on whether/when to land this turn's work on `main` given the harness-assigned branch.

---

## [Claude] — Turn 32 | 2026-08-31 (later)

Human asked to land Turn 31's work on `main` — checked out `main`, fast-forwarded to `origin/main` (already current), fast-forwarded in `claude/multi-fork-session-routing-koesjw`'s single commit (clean fast-forward, no divergence), pushed, and verified the remote's actual `HEAD branch` still reports `main` (`git remote show origin`), per the Standing Rule to verify a branch-governing action's real outcome rather than inferring it from a successful push. The harness-assigned branch itself is left in place, fully merged, not deleted.

Human then asked two direct design questions about `repo-mixing.md` §5: how is the correct fork confirmed as "guest," and what changes with three or more forks in one session. Both were real gaps in how explicit the document was, not just requests to restate what it already said — clarified and edited in place rather than answered only in conversation:

- Home/guest is always a human statement, never inferred from which repos merely happen to be reachable in the session — being mounted is not the same signal as being declared.
- With three-plus forks present, each guest must be named individually, not as a block, because §6/§7 gating is evaluated per guest against that guest's own domain scope and tagging conventions — a blanket declaration would invite treating every guest as equally reviewed when they aren't.
- §9's mixing log follows the same per-guest logic: one row per (session, guest, destination), not one merged row per session, so "what has ever crossed from fork X specifically" stays answerable later without parsing a combined row.

**Files changed:** `knowledge/flow/repo-mixing.md` (1.0 → 1.1 — §5 and §9 clarified for explicit-declaration and multi-guest mechanics).

### Session close

Knowledge candidates: None — structural/tooling document, not a domain fact.
Open flags: None.
Push status: Pending — will push immediately after this turn is logged, directly to `main` (now the checked-out branch).
Note on branch: `main` is now checked out and is confirmed the actual GitHub default branch (`HEAD branch: main`). No unmerged work remains on `claude/multi-fork-session-routing-koesjw`.

STATUS: CHECKPOINT
Completed: Landed Turn 31's `repo-mixing.md` work on `main`, verified against the real remote state rather than assuming success. Tightened `repo-mixing.md` §5/§9 for explicit per-guest declaration and multi-guest mixing-log mechanics, prompted directly by the human's own questions.
Next: Still not adopted by any actual fork.
Waiting for: Direction on the next task.

---

## [Claude] — Turn 33 | 2026-09-02

Relayed finding from `familien-boe`, handed to this session as a ready-to-paste prompt (per the `[FLAG FOR UPSTREAM]` shape in `operating-principles.md` §5): that fork's `ROUTING.md` carries a "Proactive document capture" Standing Rule (classify every uploaded/quoted/forwarded document as evidentiary-source material or not, store the former under `sources/` unasked, always disclose which way — even on the "no" branch), backed only by the model's own instinct re-firing every time, with no equivalent to the mechanical pre-commit hook backing "structural changes must be logged." Concrete failure observed there: a document uploaded early in a conversation was correctly classified and stored; a second qualifying document (an official pension-provider letter) arrived many turns later, attached to a question about what it meant rather than about storage, and the session answered well but never re-ran classification or disclosed the gap — surfaced only because the human noticed and asked directly.

That Standing Rule itself doesn't exist in this template — it's `familien-boe`-specific content, never ported up. The generic mechanism it depends on (`sources/`, evidentiary-source classification) does live here, in `authoring-guidelines.md` §9.1, so the fix is porting a generalized version of the rule here, the same pattern as Turn 8's "work directly on `main`" port.

**Evaluated the three options the relay proposed rather than applying one blindly:**
1. Strengthen `ROUTING.md` wording to make re-running classification on every qualifying upload explicit, regardless of depth into the conversation or the surface question attached — adopted.
2. A mechanical backstop the way the structural-changes hook backs its own constraint — assessed and rejected as infeasible for this specific rule, not just skipped. `pre-commit-check.ps1` works because it inspects a *diff*: a real, git-visible artifact of what changed. A skipped classification produces no artifact at all — there's no file a hook could inspect to notice "a document arrived and nothing happened." The branch-default constraint's own honesty precedent (`ROUTING.md` Hard Constraints: "a session-launch environment assigning a branch before any local command runs... remains a real, structural limit this repo cannot close from the inside") applies just as directly here. Documented as an explicit limitation rather than silently dropped.
3. A worked negative example — adopted, in `authoring-guidelines.md` §9.1, reusing the fork's own concrete incident (mid-conversation upload, attached to an unrelated question, silently skipped) rather than inventing a generic one.

**Files changed:**
- `ROUTING.md` (1.19 → 1.20) — new Standing Rule requiring document classification to re-run on every qualifying upload for the life of a session, disclosed on both branches, cross-referencing `authoring-guidelines.md` §9.1 and naming why no mechanical backstop applies.
- `knowledge/domains/authoring-guidelines.md` (1.10 → 1.11) — §9.1 gained a "Proactive classification, every time" subsection with the same instruction, the worked negative example, and the same explicit no-backstop note.

**Not run this turn:** `scripts/validate.ps1` — this sandbox has no `pwsh` available (consistent with the Windows-path limitation already noted in Turn 30's testing). Checked manually instead: both files' header `Version` lines match their new latest Version History row, both Version History tables were only appended to (no prior row edited), frontmatter untouched, and the Index in `authoring-guidelines.md` needs no update since §9.1 is an existing indexed section gaining a subsection, not a new top-level one.

### Session close

Knowledge candidates: None — structural/authoring-standard change, not a domain fact.
Open flags: None — this turn is itself the resolution of an already-confirmed `[FLAG FOR UPSTREAM]` relay, not a new one.
Push status: Pending — will push immediately after this turn is logged, to `claude/document-capture-backstop-05absg`.
Note on branch: this session was launched by an external harness against a GitHub issue, which assigned `claude/document-capture-backstop-05absg` and instructed pushing there specifically (a designated review branch feeding a pull request), not `main`, and not by this repo's own habit or a silent default. Disclosed per the Hard Constraint on harness-vs-repo conflicts and its own recorded precedent (Turn 31): treated this as the constraint's named exception — "a specific, stated reason for needing isolation" — since an issue-triggered, PR-reviewed workflow is a deliberate isolation request from the calling system, not the generic branch-by-habit instinct the constraint exists to override. Landing this on `main` is therefore left to the human's PR review, not done unilaterally by this session.

STATUS: CHECKPOINT
Completed: Ported a generalized "classify every qualifying document upload, every time" Standing Rule and matching `authoring-guidelines.md` §9.1 mechanics (plus a worked negative example) into the template, relayed from a real `familien-boe` incident. Evaluated a mechanical backstop and concluded, with reasoning documented in both files, that none is feasible here the way the structural-changes hook is — classification leaves no diff-visible artifact for a hook to check.
Next: Not yet ported back down into `familien-boe` itself, which is where the original gap was actually observed — that fork still needs this Standing Rule added to its own `ROUTING.md` (informed by, but not identical to, the version here, since its own rule is more domain-specific — family legal/financial documents specifically, not the generic "any domain with `sources/`" framing used here). This turn's branch also still needs landing on `main` once the PR is reviewed and merged — flagged per the "never leave a branch silently unmerged" Standing Rule.
Waiting for: PR review and merge to `main`.

---

## [Claude] — Turn 34 | 2026-09-09

Opening turn of a multi-entry session working through 13 template-level findings relayed from `familien-boe`, which ran the first repo-wide structural health check ever done on that fork (59 findings, nine root causes, all nine template-level). This turn is scoped to the template's own conformance with its own conventions — the precondition for trusting anything the rest of the session measures.

**Read in full first**, per the human's instruction: `ROUTING.md`, `Architecture.md`, `MarkdownConventions.md`, `knowledge/domains/authoring-guidelines.md`, and all nine files under `knowledge/flow/`.

**Then actually ran `scripts/validate.ps1` against this repo rather than reading it and inferring.** This required installing PowerShell first — see the environment finding below. Result: **0 errors, 0 warnings.**

That clean result is the finding. This repo violates its own documented conventions in at least three places, and the validator is structurally incapable of seeing any of them:

| Violation | Convention | Why `validate.ps1` misses it |
|---|---|---|
| `turn-protocol.md` (7 sections), `routing-rules.md` (7), `project-types.md` (8) have no `## Index` | `MarkdownConventions.md` §3 — required over four sections | The Index check opens with `if ($scanText -notmatch '^## Index') { continue }`. A file with no Index is skipped entirely. The check can only police an Index that already exists. |
| `repo-mixing.md` carried a `type: flow` frontmatter block — the only flow file with one | `MarkdownConventions.md` §1 — root, flow, and registry files do not use frontmatter | Frontmatter is validated for domain and project files only. |
| `repo-mixing.md` §7 cites `extraction-procedure.md` six times and `[SENSITIVE: severe]` | Neither exists in this template — both are `familien-boe` files/extensions referenced but never ported up | Nothing checks cross-file references outside `sources/` and `library/`. |

This is the sharpest form of the relayed finding that nothing runs `validate.ps1` against the template itself: running it would not have caught these anyway. A fork inherits all three as its starting state.

**Fixed this turn** (the first two; the third is substantive and belongs with the severe-tier entry later in this session, not here):
- `knowledge/flow/turn-protocol.md` (1.1 → 1.2), `routing-rules.md` (1.0 → 1.1), `project-types.md` (1.0 → 1.1) — added the missing `## Index`, placed after the guard blockquotes to match the six flow files that already had one, with bare anchor links matching that same local style rather than the descriptive-entry form `authoring-guidelines.md` §3 requires of domain knowledge documents specifically.
- `knowledge/flow/repo-mixing.md` (1.1 → 1.2) — removed the frontmatter block.

**Verification, positive control run rather than assumed:** `validate.ps1` passes clean on the modified state. Because a clean pass is exactly what a silently-skipped check also produces, deliberately broke one anchor and deleted one Index entry in a scratch copy and re-ran: the check correctly produced 1 stale-entry error and 2 orphan-section warnings against `routing-rules.md`. The green result on the real tree is a real pass, not a skip.

**Environment finding, and a correction to Turn 33's diagnosis.** `.claude/hooks/session-start.sh` sets `core.hooksPath=.githooks` and *then* installs PowerShell. In this session the first succeeded and the second did not: `CLAUDE_CODE_REMOTE=true`, hooks active, no `pwsh` on PATH. `.githooks/pre-commit` is `pwsh …; exit $?`, and a missing command exits 127 — so **the session began in a state where every `git commit` and `git push` would fail**, reporting a PowerShell error rather than anything a session did. The script's `set -euo pipefail` also means `sync-check.ps1` never ran, so `ROUTING.md` Step 1 was skipped silently. Running the same install commands by hand succeeded in about two minutes (PowerShell 7.6.6), so this is a partial-execution failure, not an unsupported platform.

Turn 33 recorded "this sandbox has no `pwsh` available" and validated by hand instead, reading it as an environment limitation. It is the same root cause, and it is a template bug: the hook orders activation before the dependency the activated hooks need, with no verification that the install succeeded. Logged for the entry sequence rather than fixed here — the fix is a hook-ordering change, not a conformance fix.

**Branch provenance, disclosed per the Hard Constraint.** The harness that launched this session assigned `claude/template-audit-findings-bhgir9` and instructed pushing there and never elsewhere. That is not the human's instruction and not this repo's convention. Raised it with the human, who directed landing each entry on `main` as it completes. Working directly on `main` accordingly. `sync-check.ps1`'s "NOT ON 'main'" banner fired correctly once run by hand — the mechanism works; it simply never got the chance to run.

### Session close

Knowledge candidates: None — conformance and tooling, not a domain fact.
Open flags: None. The 13 relayed entries are the human's own confirmed queue, worked one at a time from here.
Push status: Pending — pushing to `main` immediately after this turn.

STATUS: CHECKPOINT
Completed: Read the five required documents in full, installed PowerShell and actually ran `validate.ps1` against this repo, and established that its clean pass coexists with three real self-conformance violations it cannot detect. Fixed two of them across four flow files, verified with a positive-control run.
Next: Entry 1 — the orphan-section check's three bugs, independently reproduced against `familien-boe` (38 of 70 warnings: 19 Version History, 18 Executive Summary, 1 non-ASCII heading).
Waiting for: Nothing — the human directed proceeding through the mechanical entries and stopping at the judgement calls.

---

## [Claude] — Turn 35 | 2026-09-09

Entry 1 of the relayed queue: `scripts/validate.ps1`'s orphan-section check. Three separate bugs in one code block, all three fixed here.

**Reproduced the finding independently before touching anything.** Attached `familien-boe` read-only and ran its validator: 4 errors, 70 warnings (69 at the commit that fork audited). Of the 70, **38 were orphan-section warnings and none were real**, breaking down exactly as the relayed entry claimed:

| Heading flagged | Count | Real? |
|---|---|---|
| `Version History` | 19 | No — mandatory section, deliberately unindexed |
| `Executive Summary` | 18 | No — mandatory section, deliberately unindexed |
| `7. Børneopsparing tax treatment` | 1 | No — separate Unicode bug |

19 domains × 2 mandatory-but-unindexed sections = 38. Confirmed at source in `insurance/knowledge.md`: `## Executive Summary` at line 42, `## Version History` at line 1248, and an Index listing only the numbered content sections.

**Bug 1 — structural sections counted as orphans.** The check excluded exactly two headings, `Document Purpose` and `Index`, but `authoring-guidelines.md` §3 mandates four structural sections in fixed positions. Executive Summary and Version History are required to exist, carry no routing information an Index entry could add, and were flagged in every domain that has them.

Fixed by exempting all four from the orphan direction **only**. They deliberately stay in `$realSlugs` rather than being skipped outright: this template's own `example-domain/knowledge.md` *does* index both, and removing them from the resolvable set would have converted 38 spurious warnings into spurious *errors* — a worse regression than the bug being fixed. Indexing them is now optional rather than either required or wrong, which resolves a real conflict the relayed entry did not mention: the fork's convention omits them, while `authoring-guidelines.md` 1.9 and `example-domain/knowledge.md` 1.2 both treated an unindexed Version History as "a real pre-existing gap" and added one. Both readings are now valid. Matching ignores a numeric prefix, since `MarkdownConventions.md` numbers its own final section `## 10. Version History`.

**Bug 2 — non-ASCII headings.** `Get-GithubAnchorSlug` stripped `[^a-z0-9\- ]` and the anchor-extraction regex was `[a-z0-9\-]+`, but GitHub's real algorithm preserves non-ASCII letters. A heading like `## 7. Børneopsparing tax treatment`, whose Index link works correctly on GitHub, had its anchor skipped by the extraction regex and its heading reported as an orphan. Both patterns now use `\p{L}\p{Nd}`. Any fork not working in English hits this on its first domain.

**Bug 3 — the rule nothing enforced.** The Version History loop opened with `if ($scanText -notmatch '^## …Version History') { continue }`, so a file that omitted the section entirely was skipped silently, while a file that had one was checked closely. `MarkdownConventions.md` §2 states this requirement more plainly than almost any other rule in the template, and it was the one rule with no enforcement at all behind it.

Fixed with a scoped check. Scope mattered: §2 said "Required in every file," but **no file under `projects/` has ever carried a Version History table**, in this template or any fork — `session-log.md` is append-only and versioned by turn number, `TODO.md` is a live task list. Enforcing the rule as literally written would have produced 20+ warnings per fork on files that are correct. So §2 was corrected in the same change to name the real scope (root, `knowledge/`, `library/`; project files, `.github/copilot-instructions.md` and `incoming/` excluded) rather than shipping a checker quietly narrower than the rule it enforces — that gap is the same failure mode this whole entry queue is about.

**Measured outcome, both repos:**

| Repo | Before | After |
|---|---|---|
| `familien-boe` | 4 errors, 70 warnings | 4 errors, **32 warnings** |
| This template | 0 errors, 0 warnings | 0 errors, 0 warnings |

All 38 orphan warnings gone, zero remaining. The new missing-Version-History check fires exactly once across the fork — on `knowledge/domains/boerneopsparing/knowledge.md`, precisely the file the relayed entry predicted was invisible.

**Verification, run rather than reasoned about:**
- Positive control for the exemption: `example-domain/knowledge.md` indexes both structural sections and still validates clean, confirming no stale-entry regression.
- Positive and negative control for the Unicode fix, in a scratch copy: a correctly-anchored `## 6. Børneopsparing Håndtering` section now passes clean, and deliberately corrupting its anchor to `#6-børneopsparing-haandtering` produces the expected stale-entry error plus orphan warning. Before the fix these two outcomes were inverted — the correct form warned, the broken form was ignored.

**Files changed:**
- `scripts/validate.ps1` — the three fixes above.
- `MarkdownConventions.md` (1.5 → 1.6) — §2 now names which files actually require a Version History section.

**Not adopted, deliberately:** the relayed entry's alternative of requiring Executive Summary and Version History in every Index. It would add two entries per domain to the section the loading hierarchy reads at Level 2, and worsen the Index entry-count heaviness warning that is itself a separate open entry in this queue.

### Session close

Knowledge candidates: None — tooling fix.
Open flags: None.
Push status: Pending — pushing to `main` immediately after this turn.

STATUS: CHECKPOINT
Completed: Fixed all three orphan-section-check bugs, verified with positive and negative controls, and measured the result: the fork's warning count drops 70 → 32 with zero orphan warnings left, while the newly-enforced Version History rule surfaces exactly the one real violation it was predicted to find.
Next: Entry 2 — `knowledge/domains/_template/`.
Waiting for: Nothing.

---

## [Claude] — Turn 36 | 2026-09-09

Entry 2 of the relayed queue: there is no `knowledge/domains/_template/`, so every new domain gets created by copying a sibling.

**The asymmetry is real and visible in this repo's own files.** `projects/_template/` exists and `ROUTING.md`'s Quick Task Guide says to copy it. Domains had no equivalent: `Architecture.md` §2's diagram listed `projects/_template/` but showed only `index.md`, `authoring-guidelines.md` and `[domain-name]/` under `domains/`, and the Adding a Domain procedure said "Create `description.md`" and "Create `knowledge.md`" with no starting artifact. In practice that means copying the nearest existing domain, which propagates whatever that one got wrong and then lets the copies drift apart.

The relayed evidence is a natural experiment, not an inference: across 18 domains in `familien-boe`, the header Status field carries a value outside `MarkdownConventions.md` §1's vocabulary in 17 of them — and the single exception is the one domain authored directly from `authoring-guidelines.md` rather than copied. Same author, same standards, different starting point, different outcome.

**Built `knowledge/domains/_template/` from `authoring-guidelines.md` §3 and `MarkdownConventions.md` §1 rather than by copying `example-domain/`**, which would have reproduced the exact failure being fixed. `description.md` and `knowledge.md` carry correct frontmatter with a `[domain-name]` placeholder, a correct header block, the mandatory section structure, and inline pointers naming the rule behind each element. Status defaults to `Draft` — the correct opening value from §1's vocabulary, and the field the fork got wrong 17 times.

`example-domain/` is left in place and unchanged. The two now do different jobs, mirroring how `projects/_template/` and `projects/example-project/` already coexist: the template is the skeleton you copy, the example is the illustrative filled-in version a fork deletes at setup.

**Scoping correction against the relayed entry.** It calls for the template to carry "the canonical Notation Legend copied verbatim from `MarkdownConventions.md` §8.1." **This template has no §8.1 and no Notation Legend concept** — both are `familien-boe` extensions that were never ported up, along with the two-tier `[SENSITIVE: severe]` signal its §8 defines. Nothing was copied that does not exist here. The legend drift the entry describes is real in that fork but is not currently a template-level problem, and inventing the mechanism upstream purely to satisfy the relay would be a blind port of exactly the kind this queue is meant to avoid.

**A second finding, forced by the work.** `description.md` has six `##` sections, and `MarkdownConventions.md` §3 requires an Index in "any document longer than four sections" — so writing the template raised the question of whether it needed one. It should not: `description.md` is capped at roughly one page and loaded whole on every request matched to its domain, so an Index would cost load on every session and help none. The shipped `example-domain/description.md` has been quietly violating the rule as written since creation, and `validate.ps1` could never have flagged it (no Index means the check skips the file). Added an explicit exception to §3 rather than adding a pointless Index to every domain.

**Files changed:**
- `knowledge/domains/_template/description.md`, `knowledge.md` — new.
- `scripts/validate.ps1` — `$domainDirs` now excludes `_template`, mirroring the existing `$projectDirs` exclusion. Verified this is load-bearing rather than assumed: with the exclusion removed, `_template` produces two frontmatter folder-name-mismatch errors.
- `ROUTING.md` (1.20 → 1.21) — Quick Task Guide and fresh-fork setup step 2.
- `Architecture.md` (1.9 → 1.10) — §2 diagram and §6 step 4.
- `knowledge/domains/index.md` (1.3 → 1.4) — Adding a Domain steps 1–2.
- `knowledge/domains/authoring-guidelines.md` (1.11 → 1.12) — §3 now names the template as the starting point.
- `MarkdownConventions.md` (1.6 → 1.7) — §3 `description.md` Index exception.

`validate.ps1` passes clean on the result.

**Deferred, not dropped:** the entry's closing suggestion of a template for `projects/[name]/context/` files, on the evidence that ten such files in that fork diverge from the markdown baseline three different ways. This template ships no `context/` files at all and `projects/_template/` has no `context/` folder, so adding one means deciding whether every project should carry an empty folder and a placeholder file — a larger design question than this entry, and one worth putting to the human rather than settling in passing.

### Session close

Knowledge candidates: None — structural.
Open flags: None.
Push status: Pending — pushing to `main` immediately after this turn.

STATUS: CHECKPOINT
Completed: Added `knowledge/domains/_template/`, built from the authoring standard rather than copied from an existing domain, and repointed all five places that previously sent an author to `example-domain/` or an unnamed starting point. Corrected the relayed entry's scope where it assumed template features that only exist in the fork.
Next: Entry 3 — moving the Upstream Feedback Log out of `projects/system/TODO.md` into its own file.
Waiting for: Nothing.

---

## [Claude] — Turn 37 | 2026-09-09

Entry 3 of the relayed queue, and the one that fixes the mechanism these entries themselves travel through: the Upstream Feedback Log outgrows its host and is hard to find where §7 put it.

**The two problems, as the fork measured them.** §7 specified the log as a subsection inside `projects/system/TODO.md`'s System Maintenance Pass, introduced by a bold paragraph rather than a heading.

1. **Invisible to the repo's own navigation.** A `**bold paragraph**` was the only parent of a growing list of `###` entries, so the log appeared in no heading scan, no section listing, no table of contents — while its entries showed up as top-level-looking headings inside a task file with nothing marking them as not-tasks. That fork's human asked three separate times where findings were being written, having been told the path each time. `ROUTING.md` pointed at the procedure (§7) but never at the destination, which is part of why.
2. **It outgrew its host.** Each accepted finding appends 15–30 lines of self-contained prose — necessarily, since §7 correctly requires every entry to be a ready-to-paste prompt. Eleven entries reached 237 lines of a 333-line `TODO.md`: **71%**, leaving that file's actual Open and Done lists at 21%.

Both get worse the better the mechanism works, which is what makes this worth fixing structurally rather than tidying.

**Evaluated the three options the entry offered, and did not take its recommendation.** The entry recommends option 2 (keep it in `TODO.md`, promote to a `##` heading, add a size-triggered split) on the stated grounds that it "matches a pattern the template already uses and already validates" — namely `MarkdownConventions.md` §2's Version History archival mechanism.

**That premise is false in this template.** There is no Version History archival mechanism here, and no split threshold, and nothing in `validate.ps1` that validates one. It is a `familien-boe` extension — its §2 has a "Version History archival" subsection with a 20-row threshold and a `<basename>-history.md` sibling convention; this repo's §2 has none of it. Porting the log fix upstream by mirroring an upstream pattern that does not exist upstream would have meant inventing a threshold and a split mechanism from scratch, for a mechanism this repo never instantiates at all.

Its own objection to option 1 also does not hold here: "it adds a file to every fork's `projects/system/`, including forks that never file a single finding." **This template never ships the log** — `upstream-sync.md`'s scope note excludes `proto-context-architecture` itself, and Turn 20 deliberately left `projects/system/TODO.md` untouched for that reason. §7 only *specifies where a fork creates it*. With an explicit create-on-first-use rule, a fork that never files a finding never grows the file.

**Chose option 1, with create-on-first-use** — a dedicated `projects/system/upstream-feedback.md`. It fixes both halves permanently rather than deferring growth to an invented threshold, and the create-on-first-use half reuses a precedent this repo genuinely does have: `repo-mixing.md` §9's mixing log, which is created the first time that procedure produces a durable write and "not pre-created speculatively." That is the pattern the entry was reaching for; it exists here, just not where the entry looked.

**Files changed:**
- `knowledge/flow/upstream-sync.md` (1.3 → 1.4) — §7's "Where it lands" rewritten for the dedicated file, create-on-first-use, a self-explanatory header, and a pointer stub back from §2's Maintenance Pass section so both halves of the mechanism stay findable from one place. Both measured problems are stated in §7 itself rather than only corrected, since they recur in any fork that lets the log grow in place. §2's cross-reference updated.
- `ROUTING.md` (1.21 → 1.22) — Quick Task Guide now names the destination, not just the procedure.
- `knowledge/flow/operating-principles.md` (1.3 → 1.4) — §5's upstream-feedback flag points at the new file.
- `Architecture.md` (1.10 → 1.11) — §5's Subproject Transcendence row updated.

Nothing to change in `scripts/validate.ps1`: its project-file frontmatter check is scoped to `TODO.md` and `session-log.md` by name, so an additional file in a project folder is unconstrained. Confirmed by reading the check, and by the validator passing clean on the result.

**Note for the fork that raised this:** it has already made the move locally and deliberately left `upstream-sync.md` §7 unchanged, pending this decision. §7 now blesses that location, so its prototype and the template agree — but its own `upstream-feedback.md` should gain the self-explanatory header and the `TODO.md` pointer stub §7 now requires, if it does not already have them.

### Session close

Knowledge candidates: None — structural.
Open flags: None.
Push status: Pending — pushing to `main` immediately after this turn.

STATUS: CHECKPOINT
Completed: Moved the Upstream Feedback Log to its own file across all four places that referenced it, choosing against the relayed entry's recommendation after finding that the upstream pattern it was built on exists only in the fork — and substituting a create-on-first-use precedent that does exist here.
Next: Entry 4 — the enforcement map and the `MarkdownConventions.md` §4 backslash-escape rule. This is the first entry the human asked to review before I proceed.
Waiting for: Human direction on Entry 4.

---

## [Claude] — Turn 38 | 2026-09-10

Entry 4 of the relayed queue: no map of which stated conventions are mechanically enforced. The human directed a dedicated `knowledge/flow/` file for the map, and closing the three cheap gaps with real checks in the same change.

**Built the map in the order the entry specified** — enumerate the convention documents first, then read `scripts/validate.ps1` against that list. That ordering is what surfaces gaps; doing it the other way round only confirms the coverage that already exists. Result: `knowledge/flow/convention-enforcement.md`, with every rule in `MarkdownConventions.md`, `authoring-guidelines.md`, `turn-protocol.md` and `operating-principles.md` marked **Checked** (naming the check), **Judgement** (unmechanisable, which is a decision rather than an omission), or **Gap**. It also lists the checks that map to no stated rule, so the map is complete in both directions, and ranks the remaining gaps.

**Three checks added, and all three found real violations immediately.** Measured against `familien-boe`, which is what the entry's own numbers were drawn from:

| New check | Convention | Violations found in the fork | Entry predicted |
|---|---|---|---|
| Status field vocabulary | `MarkdownConventions.md` §1 | 17 | "17 of 18 domains" |
| Index required over four sections | §3 | 10 | "5 files, 3 template-shipped" |
| Start all documents at 1.0 | §2 | 6 | "6 documents below 1.0" |

The Index count came in higher than the entry's five because the check also reaches `library/` manifests — one of them has 24 sections and no Index — and `README.md`. Those are real, not over-reach. The three template-shipped files it names are the ones fixed in Turn 34; that fork has not synced yet, which is why they still appear there.

**Two design decisions inside the checks, both to avoid false positives on correct content:**
- **Status vocabulary is two vocabularies, not one.** Project `TODO.md` files legitimately use `Active`/`Retired` — this script's own active-versus-retired project detection depends on it — while everything else uses §1's four values. A single-vocabulary check would have flagged every correct project file in every fork. §1 never documented the project vocabulary at all, which is plausibly *why* forks reach for `Active` on domain files; it now does.
- **Start-at-1.0 warns only on a first row below 1.0**, not on any first row that is not literally `1.0`. A fork that archives old Version History rows to a sibling file has a live table starting mid-sequence — that is correct content, and a literal check would flag it. Verified directly: the naive form flags that fork's `ROUTING.md` at 1.24 and its domain index at 1.42, both false; the implemented form flags exactly the six genuine 0.x starts and nothing else.

**Ran the new Index check against this template and it found two more of our own violations** — `ROUTING.md` (six sections) and `knowledge/domains/index.md` (six sections). Fixed rather than exempted. This matters most in `ROUTING.md`: its own Hard Constraints blockquote instructs a session to re-read a specific constraint mid-session, which until now meant scrolling 250 lines with no map. That is the third and fourth self-conformance violation this session's tooling work has surfaced in the template itself.

**`MarkdownConventions.md` §4 corrected — the rule was wrong, not merely unenforced.** It forbade escaping a pipe absolutely, with one UNC-path exception. Two exceptions are real:
1. A literal pipe inside a table cell **must** be escaped. Unescaped, it ends the cell and the row silently loses columns. GitHub-flavoured markdown specifies escaping as the only way, including inside a code span.
2. A backslash inside a code span is literal content, not an escape — `.\scripts\commit-push.ps1` appears in four shipped files, and §4's stated rationale never applied to it.

**Wrote the corrected rule as a table and immediately violated it in the same sentence** — the cell explaining that an unescaped pipe ends a cell contained an unescaped pipe in a code span, which ended that cell. Rewrote the exceptions as prose so no pipe sits inside a table row, then scanned every markdown file in the repo for the same shape: no other instance. A rule that is this easy to break while writing it down is a strong argument for the check ranked sixth in the map's gap list.

**Files changed:**
- `knowledge/flow/convention-enforcement.md` (new, 1.0) — the map.
- `scripts/validate.ps1` — three checks, placed after the Index block so the helpers they reuse are already defined.
- `MarkdownConventions.md` (1.7 → 1.8) — §4 corrected, §1 Status row documents both vocabularies, Document Purpose points at the map.
- `knowledge/domains/authoring-guidelines.md` (1.12 → 1.13) — Document Purpose points at the map.
- `ROUTING.md` (1.22 → 1.23), `knowledge/domains/index.md` (1.4 → 1.5) — added the Index each now needs.

**Deliberately not added to `validate.ps1`'s required-flow-files list.** Doing so would raise a hard error in every fork that has not yet synced, for a file they cannot have — a missing reference map is not a structural failure the way a missing `operating-principles.md` is. It is reachable from both convention documents instead.

**Noted, not fixed:** `Architecture.md` §2's File Structure diagram lists four `knowledge/flow/` files and the folder now holds ten. That drift predates this entry and is its own small fix.

### Session close

Knowledge candidates: None — conventions and tooling.
Open flags: None.
Push status: Pending — pushing to `main` immediately after this turn.

STATUS: CHECKPOINT
Completed: Built the enforcement map, closed the three cheap gaps with checks that found 33 real violations in a fork and two more in this template, and corrected §4's backslash rule from wrong to right.
Next: Entry 5 — nothing in the template is aware of the current date.
Waiting for: Human review of Entry 4 before Entry 5, per the agreed cadence.

---

## [Copilot] — Turn 39 | 2026-09-10

Not an entry from the relayed queue. This session opened in VS Code + GitHub Copilot on a Windows work laptop, and ROUTING.md Step 1 could not be completed: `scripts/sync-check.ps1` would not run. Investigating that turned into the finding below, which had to be fixed before Entry 5 could be worked at all — every verification standard Turns 34–38 set ("run it, don't reason about it") was unavailable here.

**Every script in this repo was inert on this machine, and the session looked normal from the inside.** All five `.ps1` files failed to parse; both git hooks were unusable; `core.hooksPath` was unset so neither hook was even wired up. That is all four mechanical layers this repo relies on — validator, session-start sync notice, commit guard, branch guard — silently absent at once.

**Root cause, proven rather than inferred.** Every `.ps1` here is UTF-8 with no BOM and contains `—` and `§`. Windows PowerShell 5.1 — the version built into Windows, and the only one on this machine — decodes a BOM-less `.ps1` using the ANSI codepage. An em dash arrives as `â€"`, whose final byte is U+201D, and PowerShell's tokenizer accepts U+201D as a string delimiter: strings terminate mid-line and the file will not parse. The evidence is in the parse errors themselves, which print `â€"` and `Â§` literally. Re-reading the same bytes as UTF-8 and re-parsing gave **0 errors in all five files**, isolating encoding as the sole cause — no PowerShell 7-only syntax was involved.

**A BOM would also have fixed it, and was rejected on the human's cross-environment constraint.** This repo is worked from at least three environments (Claude Code Linux containers with pwsh 7, and two Windows machines). PowerShell 7 writes `-Encoding utf8` **without** a BOM by default, so one session on Linux editing any of these files strips the BOM invisibly and the breakage returns on Windows only. ASCII content has no invisible state to lose. Scripts are now pure ASCII (151 replacements: `—` → `--`, `§` → `section`), markdown deliberately untouched, and the single load-bearing em dash — the turn-header regex that matches this very heading — is written as the escape `\u2014` rather than a literal.

**Fixing the parse was necessary and not sufficient. Running the validator for the first time exposed three more Windows PowerShell 5.1 defects, and all three made it lie rather than fail.**

| Defect | Effect before the fix |
|---|---|
| `[System.IO.Path]::GetRelativePath` does not exist on .NET Framework | 73 failures in one run; every path-dependent check silently degraded |
| `Get-Content` defaults to the ANSI codepage for BOM-less files | Headings containing `—` produced a false stale-Index **error** against `session-log.md` |
| PS 5.1 decodes native command stdout with the console codepage | Git output mangled, so **17 files** with an em dash in their Version History were reported as edited when nothing had been touched |

Fixed with a `Get-RepoRelativePath` helper, explicit `-Encoding UTF8` on all 20 reads, and a `ProcessStartInfo` with `StandardOutputEncoding` set for `git show` (`ArgumentList` does not exist on .NET Framework either, so the argument string is quoted by hand). **The pre-fix run reported 19 errors, every one of them false.** A validator that lies is worse than one that will not start: it would have sent a session "correcting" a fully compliant repo.

**Git was not on PATH here either** — only GitHub Desktop's bundled copy. `commit-push.ps1` already handled that, but with a Windows-only lookup that would fail on Linux, and it never checked PATH first. All five scripts now resolve git PATH-first, then GitHub Desktop, then Program Files, and say so loudly when none is found instead of proceeding with stale `$LASTEXITCODE` — which is exactly how the 19 false errors were produced.

**Hooks assumed `pwsh` unconditionally.** `.githooks/pre-commit` and `pre-push` invoked it with no fallback and `exit $?`, so a machine without PowerShell 7 gets 127 on every commit — the same root cause Turn 34 recorded for `.claude/hooks/session-start.sh`, reached from a different direction and not specific to Claude Code. Both hooks now resolve `pwsh`, then `powershell.exe`, and fail with an explanation and the deliberate `--no-verify` bypass rather than an unexplained 127.

**New check: no non-ASCII in `scripts/` or `.githooks/`.** An error, not a warning — a regression here disables everything else. Verified with a positive control (clean tree passes) and a negative control (a file containing one em dash is caught, with file, line and code point named). Its full rationale is written into `validate.ps1` above the check itself, since the next session to hit this will be reading the script, not this log.

**Added `.gitattributes`.** Line endings were previously governed by each machine's untracked `core.autocrlf`; a machine with it set to `false` could commit CRLF into `.githooks/*`, and a CRLF shebang makes a hook unrunnable on Linux. Now pinned: `*.sh` and `.githooks/*` are `eol=lf`. The index was already LF throughout, so this pins existing behaviour rather than changing it.

**Files changed:** `scripts/validate.ps1`, `scripts/sync-check.ps1`, `scripts/commit-push.ps1`, `scripts/pre-commit-check.ps1`, `scripts/pre-push-check.ps1`, `.githooks/pre-commit`, `.githooks/pre-push`, `.gitattributes` (new).

**Verification, run rather than reasoned about.** All five scripts parse; `sync-check.ps1` ran here for the first time and reported `up to date with origin/main`; `validate.ps1` reports **0 errors, 0 warnings** after activating hooks in this clone (`git config core.hooksPath .githooks`, which the validator had correctly warned was unset).

**Deliberately not done, and proposed instead:** a row in `knowledge/flow/convention-enforcement.md` registering the new check, and a note in `Architecture.md` §6 about interpreter and git resolution. Both are gated files; raising them as a proposal rather than editing them unilaterally.

**Also observed, not fixed:** the relayed queue itself exists nowhere in this repo. Entries 5–13 survive only as the one-line `Next:` in Turn 38, so no new session can resume the queue from the repo alone. The hook-ordering bug and the `Architecture.md` §2 diagram drift are likewise recorded only as prose inside session-log turns, absent from `TODO.md`.

### Session close

Knowledge candidates: None — tooling and environment.
Open flags: None. Two documentation updates proposed above, awaiting human approval.
Push status: Pending — pushing to `main` immediately after this turn.

STATUS: CHECKPOINT
Completed: Made all five scripts and both hooks run correctly on Windows PowerShell 5.1 without breaking the Linux and PowerShell 7 environments — four separate compatibility defects, three of which made the validator report false errors rather than fail. Added a check that stops the encoding half from regressing.
Next: Entry 5 — nothing in the template is aware of the current date. The human is retrieving the queue text from `familien-boe`'s `projects/system/upstream-feedback.md`.
Waiting for: The Entry 5 handover, and a decision on the two proposed documentation updates.

---

## [Copilot] — Turn 40 | 2026-09-10

Human approved both documentation updates proposed at the end of Turn 39.

**`Architecture.md` §6 gained a Script portability subsection.** Turn 39's fixes lived only in script comments and this log; nothing in the system-design document said scripts had portability requirements at all, so the next session to add a script would have had no reason to know. The subsection states the three rules — pure ASCII, resolve `git` rather than assuming `PATH`, resolve the interpreter between `pwsh` and `powershell.exe` — each with the failure it prevents rather than the rule alone. The rejected BOM alternative is recorded too: a fix that works and was still wrong is the kind of thing a later session re-proposes unless the reasoning survives. Step 10 also now says hooks need PowerShell present *before* activation, which is the ordering `.claude/hooks/session-start.sh` gets backwards.

**`knowledge/flow/convention-enforcement.md` §5 gained the non-ASCII check.** §5 is the right home rather than §2–§4: those map rules stated in the convention documents, and this is a property of executable files, not authored prose. Noted there as the one entry in the map whose own failure disables every other check in it — which is why it is an error rather than a warning, and why the full rationale lives above the check in `scripts/validate.ps1` rather than here. Someone who trips it will be reading the script.

Both files' edit guards require this log entry; that is what this turn is. `validate.ps1` passes clean on the result, including the Index and Version History checks against the new subsection and both new rows.

### Session close

Knowledge candidates: None — documentation of tooling already landed.
Open flags: None.
Push status: Pending — pushing to `main` immediately after this turn.

STATUS: CHECKPOINT
Completed: Recorded Turn 39's portability requirements where a future session will actually encounter them — the system-design document and the enforcement map — rather than leaving them in script comments alone.
Next: Entry 5.
Waiting for: The Entry 5 handover text from `familien-boe`.

---

## [Copilot] — Turn 41 | 2026-09-10

Entry 5 of the relayed queue: nothing in the template is aware of the current date, so time-bound content expires silently.

**Guest handling, disclosed per `repo-mixing.md` §5.** `familien-boe` was declared a read-only guest by the human; this repo is home. Nothing was written to it — including for measurement, see the `-RepoRoot` note below. Six other forks are checked out as siblings on this machine; none was declared, so none was read or touched. The guest is on `main`, clean, in sync, at `880c0a4` — newer than the commit the handover named, and the entry has moved from line 343 to 496.

**Grepped every citation before implementing, and one is fork-only.** `[TIME-SENSITIVE: source type]` is real here (`MarkdownConventions.md` §8, `authoring-guidelines.md` §6), as are `TODO.md` Open lists and the date-parsing helpers. But the entry writes the signal as "`[TIME-SENSITIVE]` / 🕐", and **the emoji form has zero occurrences in this template** — the same shape as the `⛔` two-tier signal and the §8.1 Notation Legend that tripped earlier entries. Also worth recording: Open Items / Next Actions is an *optional* section pattern here (`authoring-guidelines.md` §3), and no shipped domain uses one.

**The entry's title claims more than its proposed fix delivers.** Both proposed checks address content aging. Neither addresses the half this repo demonstrated live and recorded in Turn 38: **a session has no idea what today is.** Every date check that existed compared repo dates against *each other* — the domain index's Last Updated against a domain's header date — so a repo whose dates were all consistently wrong passed clean indefinitely. Nothing anywhere established "now".

**Three things shipped, one deliberately deferred.**

1. **Passed-date check** — the entry's check (1). Unchecked items only, in `TODO.md` and domain Open Items sections only, never general prose. Warning.
2. **Future-date check** — not in the entry; proposed and approved this session. Warns on a header date or Version History row later than today. Both are permanent append-only records: a wrong date in one cannot be corrected afterwards without breaking the append-only rule, which makes catching it before the commit the only chance.
3. **`sync-check.ps1` now prints today's date** before anything else and regardless of whether git is reachable. One line, no false-positive surface, and it is the only thing in this repo that ever tells a session what day it is.
4. **Deferred: check (2), aged `[TIME-SENSITIVE]` claims.** The entry itself says start with (1). The stronger reason to defer: this template contains no real `[TIME-SENSITIVE]` claim at all, only the instruction text describing the signal, so there is nothing here to calibrate a threshold against — and a threshold picked without calibration is how a check becomes noise. Logged as ranked gap 8 in `convention-enforcement.md` §6, with the emoji finding attached for whoever builds it.

**The narrowing of check (1) was measured, not asserted — and the first version was not usable.** The entry warned that false positives would make it useless, so I ran it against the guest at each stage:

| Form | Warnings | Roughly real |
|---|---|---|
| Location-scoped only (as the entry describes it) | **52** | ~6 |
| Plus: item must state a deadline cue | **11** | ~6 |
| Plus: skip a date that follows a recording verb | **8** | ~5 |

The dominant false-positive shape is a date recording *when an item was raised*, or citing a past event as context — `opened 2026-07-16`, `(reviewed 2026-08-26, no changes needed)`, `his 2026-03-03 reply gave no commission rate` — not a deadline. The entry's own framing, "an unchecked item containing a date earlier than today", produces that 52. What survives at 8 includes four of the entry's five named examples: the consumer-guarantee deadline, the salary conversation described as upcoming in August, and the health follow-up whose outcome was never recorded (twice, from both the project and the domain side).

I stopped tuning at 8 rather than pushing further. Precision is roughly 60%, which for a warning across a 14-project fork is triageable, and every additional rule risks over-fitting the check to one fork's prose habits.

**The cue list is English, and that is stated in the script rather than hidden.** A fork working in another language will need to extend it — the same kind of documented template default as `$defaultBranch` in the branch checks. Hardcoding an English assumption invisibly is exactly the bug Entry 1 fixed in the anchor-slug regex.

**`validate.ps1` gained a `-RepoRoot` parameter.** The handover sanctioned copying the validator into the guest and reverting afterwards. A parameter is better: the guest was measured four times this turn with nothing written to it at all, and no cleanup step to forget. This also makes the next cross-fork measurement non-invasive by default.

**Files changed:**
- `scripts/validate.ps1` — `-RepoRoot`; a single `$today`; the future-date and passed-date checks.
- `scripts/sync-check.ps1` — the date line.
- `knowledge/flow/convention-enforcement.md` (1.1 → 1.2) — §5 registers both new checks with their measured tuning; §6 gains the deferred check as ranked gap 8.

**Verification, run rather than reasoned about.** Positive control: the template passes clean, 0 errors 0 warnings, with both checks live. Negative control: an injected open item with a passed deadline and an injected future header date each produced exactly one correct warning naming the file, line and date; both reverted, and the clean result returned. The measurement above is itself the calibration the entry asked for.

**Not fixed, still open** — unchanged from Turn 39: the queue exists nowhere in this repo; the `session-start.sh` hook-ordering bug; `Architecture.md` §2's stale diagram.

### Session close

Knowledge candidates: None — tooling.
Open flags: None.
Push status: Pending — pushing to `main` immediately after this turn.

STATUS: CHECKPOINT
Completed: Entry 5. Shipped the passed-date check, calibrated 52 → 8 against a real fork rather than shipping the entry's unusable first form; added a future-date check the entry did not propose; and gave the session itself a source of truth for today's date, which is what the entry's title actually claimed and its proposed fix did not cover.
Next: Entry 6 — severe-tier content in always-loaded sections, folding in `repo-mixing.md` §7's dangling references. Security-adjacent, and an evaluate-and-choose entry.
Waiting for: Nothing — the human directed continuing through the queue, stopping at judgement calls.

---

## [Copilot] — Turn 42 | 2026-09-10

Entry 6: nothing stops severe-tier content appearing in the sections the loading hierarchy always loads. An evaluate-and-choose entry, and the shipped bug folded into it turned out to matter more than the entry itself.

**The entry's central premise does not exist here.** It rests throughout on a two-tier sensitivity signal. `MarkdownConventions.md` §8 in this template defines **one** tier, `[SENSITIVE]` — no severe tier, no emoji forms, no Notation Legend, no `extraction-procedure.md`. Its proposed fix, "a short rule in §8: severe-tier content belongs in a named section," is unwritable as stated. Fifth instance of this pattern in this queue and the largest.

**The bug underneath is larger than the entry describes, and it ships.** `knowledge/flow/repo-mixing.md` was generalized from that fork's mechanisms in Turn 31 but kept citing them by name: **eleven dangling references across six sections** — six to `extraction-procedure.md`, five to the severe tier and its emoji — in §1, §6, §7, §9, §12 and §13. Turn 34 found the §7 subset and deferred it here. §7 is titled *The Sensitivity Gate*, and for any fork other than the one it was drawn from it gated on a tier that does not exist and delegated its handling rules to a file that does not exist. What actually survived was its final fallback paragraph, the weakest of its three rules, reading like a footnote.

**A check would not have caught the entry's own instance, and this is the finding that decided the design.** Inspecting the guest's security domain — structure only, no content pulled across, per §7's own discipline — its Executive Summary contains **no sensitivity tag at all**; the tags sit elsewhere in the file. The classification lives in a per-domain notation legend that scopes the tier to *named sections*, so the copy that reached the Executive Summary was untagged by construction. Scanning all 19 guest domains for a tag inside an Executive Summary returns zero hits. Any check keying on the tag would report that fork clean.

That also identifies the deeper cause: scoping sensitivity to sections contradicts `authoring-guidelines.md` §6's existing "apply signals at the claim level, not the section level" — a rule which, until this turn, never said *why*. It now does: a claim tagged in place carries its handling rules with it when copied; a section-level classification does not travel, and the copy arrives looking clean.

**Chose to write the rule against the one tier that exists rather than port the tier.**

Porting `[SENSITIVE: severe]` upstream would have made the entry's fix writable verbatim and retroactively validated several other entries' citations. Rejected, for three reasons. It is the blind-port failure this queue exists to avoid, in its most tempting form — real machinery every fork inherits, added on one fork's evidence, because an entry assumed it. It would not have been sufficient: five of the eleven dangling references are the tier, the other six are a whole procedure document. And it would have been *less* protective for most forks — a one-tier rule covers everything anyone has tagged, where a severe-tier rule covers a tier most forks will never adopt. Nothing about the interaction gap requires two tiers; the gap is "a tagged claim can sit in an always-loaded section," which is equally true with one.

Also rejected: writing `extraction-procedure.md` upstream, which would mean inventing an entire procedure document from a single fork's usage.

**On the carve-out the entry asks about — yes, and it lands in `description.md`.** A domain with no ordinary part to summarise would otherwise be forced into an Executive Summary that says nothing useful, defeating the routing purpose Level 3 exists for. Such a domain declares its scope once and is exempt, its whole file treated as tagged. The declaration goes in `description.md` rather than per claim for a specific reason: `description.md` loads at Step 4 Level 1, ahead of the Executive Summary, so a session sees the declaration before anything it governs.

**Registered as Judgement, not Gap.** That distinction is load-bearing here. A Gap means "should be checked and is not." This is "a check would have missed the founding instance," which is a different statement and worth recording as such.

**Files changed:**
- `MarkdownConventions.md` (1.8 → 1.9) — §8 gains "Where a `[SENSITIVE]` claim may sit": the placement rule, the extract/cross-fork rationale, the carve-out, and why it cannot be mechanised.
- `knowledge/flow/repo-mixing.md` (1.2 → 1.3) — all eleven dangling references removed. §7 rewritten to state its rules inline against `[SENSITIVE]`, to warn explicitly against treating an Executive Summary as pre-cleared, and to defer to a guest fork's own stronger tier where one exists rather than assuming this template defines it.
- `knowledge/domains/authoring-guidelines.md` (1.13 → 1.14) — §3 and §6 point at the new rule; §6 now states why claim-level tagging matters.
- `knowledge/flow/convention-enforcement.md` (1.2 → 1.3) — §2 gains the rule as Judgement, with the reason.

**Verification.** `validate.ps1` passes clean. Grepped the whole repo afterwards for `extraction-procedure`, `SENSITIVE: severe` and both emoji: the only remaining occurrences are inside Version History rows and prior session-log turns, which are append-only records of what was once true and correctly left alone. No live prose reference to a non-existent feature remains anywhere in the template.

**Guest handling.** `familien-boe` read as declared guest, read-only. Only structural facts crossed into this log — heading positions and where tags sit — never content. Guest confirmed clean afterwards.

### Session close

Knowledge candidates: None — conventions.
Open flags: None.
Push status: Pending — pushing to `main` immediately after this turn.

STATUS: CHECKPOINT
Completed: Entry 6. Closed the interaction gap between §8, `authoring-guidelines.md` §6 and Step 4 Level 3 using the single sensitivity tier this template actually has, and repaired the eleven dangling references that had left `repo-mixing.md`'s sensitivity gate resolving to nothing for every fork but the one it was written from.
Next: Entry 7 — sessions asking permission to land on the default branch every time, in harness-assigned-branch environments. Also evaluate-and-choose.
Waiting for: Nothing.

---

## [Copilot] — Turn 43 | 2026-09-10

Entry 7: sessions ask permission to land on the default branch in every new session, in environments where a harness assigns a working branch.

**The finding is precise and correct, and this is the rare entry whose premise is entirely real here.** Every rule this template has on the subject — the branch Hard Constraint, the `sync-check.ps1` banner, the Standing Rule — states a *convention*: work on `main`, land finished work there. A harness meanwhile injects a *gate*: never push to a different branch without explicit permission. A session holding both goes looking for consent, finds a convention, and asks. It is behaving correctly; the repo had simply never written a sentence that reads as permission.

**Verified the entry's cost-saving diagnostic rather than taking it.** Read `scripts/pre-push-check.ps1`: it collects push refs from stdin and blocks only those where the branch is not `$defaultBranch`. So `--no-verify` is never needed to push to `main`, and the whole friction chain the fork observed — blocked push, denied bypass, question to the human — only arises when a session pushes its *assigned* branch instead of landing first. Making "land on main" unambiguous removes the chain rather than its last link.

**The design decision the entry does not address, and the one that mattered most.** Entry 7 says to ship the authorization as "a clearly-marked placeholder a fork fills in during setup." Taken literally that is unsafe: a session reading the *shape* of an authorization in an unfilled template would reasonably act on it, converting "ask the human" into "assume consent" for every fork that skipped setup — worse than the problem being solved. So absence is explicitly not consent. Where no authorization exists the banner says so in as many words and tells the session to ask, which is exactly today's behaviour, now stated rather than merely resulting.

**The authorization lives in a fork-owned file, not in the script.** Two reasons, both structural. The template cannot consent on a fork owner's behalf — only the person who owns a given repo can give that. And a fork editing `scripts/sync-check.ps1` to insert its owner's name would diverge from upstream permanently and conflict on every sync, for a one-line change; a separate file never conflicts. `.branch-authorization` is created on first use, reusing the precedent Entry 3 established for `upstream-feedback.md` and `repo-mixing.md` §9's mixing log rather than inventing a pattern.

**Four layers shipped:**
1. `scripts/sync-check.ps1` reads `.branch-authorization` and prints either the authorization — stating that it satisfies a harness requirement for explicit permission, that the session should not ask again, and the three things it does not cover — or an explicit statement that none is recorded. Highest leverage because this text reaches a session's context at session start, before `ROUTING.md` is read and before any harness instruction it would be weighed against.
2. `.claude/settings.json` gained a narrow `permissions.allow` block covering exactly the land-on-`main` sequence. Deliberately not a blanket `Bash(git push:*)`, which would pre-approve force-pushes and arbitrary branches and defeat both the pre-push hook and the force-push Hard Constraint.
3. `ROUTING.md` Hard Constraints gained the rule as consent rather than as a restatement of the convention, placed immediately after the branch constraint it completes.
4. `.github/copilot-instructions.md` mirrors it briefly, so the VS Code entry point reaches the same conclusion without reading `ROUTING.md`.

**Agreed with the entry's own rejection** of having the session-start hook check out `main` automatically. It fights the harness's branch tracking, and a hook that silently moves a session off the branch it was placed on is worse than a prompt. Developing on the assigned branch is fine; only the landing needed pre-authorization.

**Folded in the hook-ordering bug** — the handover's highest-value unfixed item, and now a self-conformance failure rather than only a bug. Turn 40 wrote into `Architecture.md` §6 step 10 that hooks must be activated only once PowerShell is present; `.claude/hooks/session-start.sh` did the opposite, activating `core.hooksPath` first and installing PowerShell after, with no verification. The install is now first and non-fatal under `set -e`, activation is conditional on an interpreter actually being available, and the else branch says plainly that hooks were left inactive rather than leaving a session to discover it through a 127 on its first commit.

**Two honest limitations, both stated rather than papered over.**
- Layer 2 depends on the permission classifier honouring project-level settings, which cannot be verified from inside a repo. It is friction reduction, not a guarantee.
- **This machine has no bash and no WSL, so `session-start.sh` could not be syntax-checked.** Reviewed by hand instead — and that review caught a real defect: my own edit had left the original sync-check block in place, duplicating it. `if`/`fi` now balance at 5/5 with one sync invocation and one `hooksPath` set. Worth recording that the one file this session could not mechanically verify is also the one where a mistake got through to review.

**Not done, deliberately: this repo's own `.branch-authorization` was not created.** Writing a consent statement in someone's name is not something to infer from "go ahead with entry 7". Asking.

**Files changed:** `scripts/sync-check.ps1`, `.claude/settings.json`, `.claude/hooks/session-start.sh`, `ROUTING.md` (1.23 → 1.24), `Architecture.md` (1.12 → 1.13, §6 gains step 11 and renumbers the old 11 to 12), `.github/copilot-instructions.md`.

**Verification.** `validate.ps1` clean. `.claude/settings.json` parses as valid JSON. Both banner states rendered and read back — from a temporary copy of the script with a different default-branch name, so no branch was created to test a branch warning — and the throwaway authorization fixture was deleted immediately, with absence re-confirmed afterwards.

### Session close

Knowledge candidates: None — workflow and configuration.
Open flags: None.
Push status: Pending — pushing to `main` immediately after this turn.

STATUS: CHECKPOINT
Completed: Entry 7. The repo can now state consent rather than only convention, without the template ever asserting consent on a fork owner's behalf and without an unfilled placeholder being mistakable for one. Also closed the session-start hook-ordering bug, which had become a contradiction of this repo's own newly-written rule.
Next: Entry 8 — every self-check the template defines is opportunistic, so none of them ever run. The largest and most debatable of the queue.
Waiting for: A decision on whether to record a `.branch-authorization` for this repo itself.

---

## [Copilot] — Turn 44 | 2026-09-10

The relayed queue's oldest entry — proactive document capture has no mechanical backstop — checked against the current repo rather than reimplemented. **It is already closed. No changes made.**

The handover flagged it as "probably already landed" by Turn 33 and asked for verification rather than a redo. Verified against the files themselves, not against Turn 33's own account of what it did, since a log entry claiming a change is not evidence the change is still there.

| The entry proposed | State in this repo |
|---|---|
| 1. Strengthen the `ROUTING.md` Standing Rule so classification re-runs on every qualifying upload, whatever question it arrives attached to | Present. The Standing Rule is titled "Classify every qualifying document upload — every time, not just the first," names the mid-conversation case explicitly, and states that answering the surface question well is not a substitute |
| 2. Consider a mechanical backstop | Considered and rejected, with the reasoning written into both `ROUTING.md` and `authoring-guidelines.md` §9.1: a hook can only inspect a diff, and a classification that never happened leaves no artifact to inspect |
| 3. Add a worked negative example | Present in §9.1 as a blockquote, built from the fork's own incident and generalized — including a "what should have happened instead" that names the required disclosure on both branches |

Both halves of the never-silent requirement survive intact, which is the part most likely to have been lost in a reword: a session must state the outcome even when the answer is "not a source," because a human who never hears "no" cannot tell that a session stopped checking.

One thing worth recording beyond the entry: it is also already registered in `knowledge/flow/convention-enforcement.md` §3 as **Judgement**, with the no-artifact-for-a-hook reason. That was added in Turn 38 for an unrelated reason, so the closure is corroborated by a second file written independently of the first.

**A gap in the mechanism itself, not in this entry.** All thirteen relayed entries still read `Status: Open` in the fork's own log, including the seven now closed here. Nothing carries status back downstream when a fix lands upstream, and `upstream-sync.md` §7 describes only the outbound direction. So a fork's log grows monotonically and steadily overstates what is outstanding — which is how a closed entry gets re-worked by a later session. Noted rather than fixed: the fix belongs in §7, and it is a design question about who owns the status field, not a correction.

### Session close

Knowledge candidates: None.
Open flags: None.
Push status: This turn changes no other file; pushing the log entry itself.

STATUS: CHECKPOINT
Completed: Verified the document-capture entry closed against the current text of both files it touches, rather than redoing work already landed, and recorded the evidence so the next session does not re-verify it.
Next: `validate.ps1`'s size and entry-count warnings read as hard thresholds, contradicting `authoring-guidelines.md` §8's own text — 20 of the fork's remaining 32 warnings.
Waiting for: Nothing.

---

## [Copilot] — Turn 45 | 2026-09-10

`scripts/validate.ps1`'s domain-heaviness warnings read as hard thresholds while the section they cite says the opposite.

**Confirmed the contradiction at source before touching it.** `authoring-guidelines.md` §8's split item says, in full: "There's no fixed size threshold — judge by whether a task ever needs the whole document versus consistently needing only one part of it." The warning it cited said `is 639 lines (over 600) -- consider whether it should split (authoring-guidelines.md section 8)`. A number, a fixed-sounding "over 600", and a bare pointer to a section whose actual content contradicts the framing.

**The sharpest part is that the caveat already existed and was in the wrong place.** The comment block directly above these checks has always said "These are lagging-indicator tripwires, not hard limits or errors." That comment is visible only to someone reading the script. Everyone the warning is aimed at reads the *output*. A correct rationale sitting where the audience never looks is functionally the same as no rationale — and the fork's own session, working from output alone, proposed splitting two domains purely because they were flagged. Reading §8 and asking the human established that both splits were wrong: those sections are genuinely interdependent, and splitting would have added cross-file friction for nothing.

**All three warnings now carry the test rather than citing it.** The size and Index-entry warnings state that the number is a proxy and give §8's actual question. The Executive Summary warning is different in kind and was rewritten differently: its cost is concrete rather than heuristic — Step 4 Level 3 loads that section on nearly every query, so detail there is paid for constantly — but its line count is still a proxy, so it now says to judge by content rather than length.

**No logic change.** The three thresholds still gate the same conditions; only the strings changed. Verified by measurement rather than by reading the diff: the fork produced exactly **20** heaviness warnings before and after, matching the count the entry itself reported.

**A problem the entry does not raise, and I did not fix.** These warnings cannot be suppressed. The fork's human correctly decided both flagged domains should stay whole — and that decision is recorded nowhere the check can see, so the warnings fire on every run forever and the next session is invited to make the same wrong proposal. Rewording lowers the odds of the first misread; it does nothing about recurrence.

The obvious fix is a marker in `description.md` recording that a split was assessed and declined. I did not build it, for two reasons. The entry explicitly scoped this as "a small wording change, no logic change," and overriding that on my own initiative is the failure mode this queue keeps documenting. More substantively: `description.md`'s Working Constraints would then carry three separate conventions invented in three separate turns — this one, Entry 6's sensitive-throughout declaration, and `repo-mixing.md` §6's mixing posture. Three undocumented markers in one field is its own design problem, and deciding how that field works deserves a deliberate answer rather than a third accretion. Recorded in `convention-enforcement.md` and raised to the human as a question.

**Files changed:**
- `scripts/validate.ps1` — three warning strings; the comment block now records why the text carries the rationale rather than the comment alone.
- `knowledge/flow/convention-enforcement.md` (1.3 → 1.4) — §3's heaviness row states both the fix and the unsuppressible-recurrence problem.

**Verification.** `validate.ps1` clean on this template, which ships no domain large enough to trip any of the three. Measured against the fork instead, where all 20 fire: count unchanged, text correct, and the reworded strings read as intended against real domains rather than a constructed fixture. Guest read-only throughout; nothing written to it.

### Session close

Knowledge candidates: None — tooling wording.
Open flags: None. One design question raised to the human, above.
Push status: Pending — pushing to `main` immediately after this turn.

STATUS: CHECKPOINT
Completed: Moved §8's real split test out of a source comment nobody reads and into the warning text itself, where the audience actually is, with no change to what fires.
Next: `turn-protocol.md` has no recovery convention for a turn-numbering slip. The fork has a live instance of it.
Waiting for: Nothing. Two questions outstanding and not blocking — whether to record a `.branch-authorization` here, and how `description.md`'s Working Constraints field should handle its now-three conventions.

---

## [Copilot] — Turn 46 | 2026-09-10

`turn-protocol.md` has no recovery convention for a turn-numbering slip, so the two rules that govern it close every route out and leave a session improvising.

**Reproduced the live instance rather than taking the entry's word.** Running the validator against the fork returns `Turn numbering breaks at 'Turn 79' -- expected Turn 78`. It was one of 12 errors there.

**The entry understates the problem in one respect and I widened the fix to match.** It frames this as a missing convention. The operative harm is that the finding is an **error nobody can ever clear**: renumbering a committed turn would edit a prior turn, append-only forbids that even against a direct human request, so the error is permanent by construction. A permanent error is not a neutral cost — it teaches whoever reads the output that errors in this repo are things you live with. The fork now carries two `TODO.md` items literally headed "Known, permanent `validate.ps1` finding — do not attempt to fix", which is that lesson already learned.

**So the fix is a severity split, not only documentation.** The two failure modes are not equally serious and had been treated identically:

| Failure | Severity | Why |
|---|---|---|
| Skipped number (79 where 78 was next) | **Warning** | Nothing is lost. No turn is missing, and every reference still resolves to exactly one turn. Uncorrectable once committed |
| Reused or out-of-order number | **Error** | "Turn 79" becomes ambiguous, and the never-reused guarantee is what stops two concurrent sessions colliding. Fixable before commit |

**Checked that downgrading the gap does not mask a deleted turn**, which was the obvious objection. It does not: deletion is caught by the separate append-only comparison against `HEAD`, which requires the new content to contain the old as a prefix, and that stays an error. The two checks cover different failures and the weakening is confined to the one that costs nothing.

**`turn-protocol.md` §1 gained "If you miscount"**, which says plainly that no compliant repair exists, then gives the response for each case. A session discovering this mid-incident otherwise has to derive it from two separate rules while being asked to just fix it — which is exactly when a session invents its own answer. It also generalises to any defect sealed into a committed turn, such as a missing STATUS line: note it in the next turn, never rewrite history to make a check pass.

**Measured effect.** The fork's turn-numbering error becomes a correctly-worded warning; its error count drops 12 → 11, and the finding it can never fix stops being counted among the ones it should.

**Files changed:**
- `scripts/validate.ps1` — severity split, with both messages naming what the reader should actually do.
- `knowledge/flow/turn-protocol.md` (1.2 → 1.3) — §1's new subsection.
- `knowledge/flow/convention-enforcement.md` (1.4 → 1.5) — §4's row now records two severities, and why.

**Verification, both branches with real controls.** Appending a turn numbered 5 after Turn 1 produced exactly one warning naming the skipped range; appending a second Turn 5 produced the warning plus one error, correctly identifying reuse. Both controls reverted, and the clean result returned. The template itself passes 0/0 throughout.

**Not done: the entry's option 3**, a cross-reference from `ROUTING.md`'s append-only Hard Constraint. `ROUTING.md` may not be updated silently, and a session hitting a numbering slip looks in `turn-protocol.md`, which now answers it. Proposed to the human as a one-sentence addition rather than made unilaterally.

**Observed in passing, not acted on** — the fork's own `validate.ps1` and `commit-push.ps1` now begin with a UTF-8 BOM. That is the fix considered and rejected here in Turn 39, because a PowerShell 7 session writing `-Encoding utf8` strips a BOM silently and the breakage returns on Windows only. Its next upstream sync brings the ASCII fix down and makes the BOM redundant. Guest is read-only; nothing was written to it.

### Session close

Knowledge candidates: None — protocol and tooling.
Open flags: None.
Push status: Pending — pushing to `main` immediately after this turn.

STATUS: CHECKPOINT
Completed: Turned an unfixable permanent error into an accurate warning, kept the failure that actually breaks something as an error, and wrote down the recovery convention a fork previously had to invent under pressure.
Next: Version History tables in frequently-loaded files need an archival mechanism — the fork-only mechanism several earlier entries wrongly assumed already existed here.
Waiting for: Nothing blocking. Three questions now open for the human: the `.branch-authorization`, the `description.md` Working Constraints field, and the one-sentence `ROUTING.md` cross-reference above.

---

## [Copilot] — Turn 47 | 2026-09-10

Version History archival: a documented exception letting rows be moved out of a live table rather than growing it forever. This is the mechanism Entries 2 and 3 both cited as already existing upstream when it did not — porting it makes those citations true rather than merely forgiven.

**Checked whether this template actually has the problem before porting a fix for it.** It does, mildly, and in exactly one place that matters:

| File | Version History rows | Share of file |
|---|---|---|
| `ROUTING.md` | **25** | 10% |
| `Architecture.md` | 14 | 7% |

`ROUTING.md` is already past the 20-row threshold the fork proposed, and it is the one file `ROUTING.md` Step 1 makes mandatory reading in every session — so its changelog is paid for on every load. The fork's own numbers were worse (14% and 46%), but the shape is the same and it is not hypothetical here.

**Ported as relocation, never deletion.** Rows past the most recent 20 may move verbatim into a paired `<basename>-history.md` beside the file, leaving a pointer line. The archive carries a `## Version History` section and deliberately no `Version X.Y | Date | Status` header, since a pure archive has no version of its own and a header there would trip the header-versus-latest-row check for nothing.

**The append-only rule is not weakened, and the check is what makes that true rather than the wording.** What must stay append-only is the archive and the live table *read together*. `validate.ps1` now, on finding a live table that shrank, looks for the paired file and accepts the change only if archive-plus-live still reconstructs the combined history at `HEAD`. Nothing lost, only redistributed.

**Two properties worth stating, because both are easy to get backwards:**
- **20 rows grants permission; it does not instruct.** No warning fires at 20, and none should — a file at 30 rows violates nothing. Adding a nag here would have recreated the unsuppressible-warning problem recorded one turn ago in Turn 45.
- **The live table then starts mid-sequence.** That is correct, and already tolerated: Turn 38 wrote the start-at-1.0 check to warn only on a first row *below* 1.0, explicitly anticipating archival. Half the accommodation for this mechanism was already here before the mechanism was.

**Verified on real content with three controls, not a fixture.** Performed an actual split on `Architecture.md` — four oldest rows relocated to a real archive file: validator clean, 0 errors 0 warnings. Then tampered with one word inside an archived row: correctly errored. Then deleted the archive entirely, so the rows were genuinely gone rather than moved: correctly errored. Both reverted; clean result returned; no stray archive file left behind.

That middle control is the one that matters. A check that merely noticed "a paired file exists" would pass a repo that had archived rows and then quietly edited them, which is deletion with extra steps.

**Files changed:**
- `scripts/validate.ps1` — `Get-PairedArchivePath` and `Get-CombinedHistoryRows`; the append-only check now recognises a verified split, and its error message names relocation as the sanctioned alternative to deleting rows.
- `MarkdownConventions.md` (1.9 → 1.10) — §2's new "Version History archival" subsection.
- `knowledge/flow/convention-enforcement.md` (1.5 → 1.6) — §2's append-only row records what the check actually verifies.

**Deliberately not done: `ROUTING.md` was not split**, although it is the file over threshold. Porting a mechanism and exercising it on the repo's most load-bearing document are separate decisions, and this one creates a new root-level file and edits `ROUTING.md`. Proposed to the human rather than taken.

### Session close

Knowledge candidates: None — conventions and tooling.
Open flags: None.
Push status: Pending — pushing to `main` immediately after this turn.

STATUS: CHECKPOINT
Completed: Ported Version History archival, verified with a real split plus two distinct failure controls, and closed the gap that made two earlier relayed entries cite an upstream mechanism that did not exist.
Next: Entry 9 — the template should ship a reusable fork health-check procedure. Then Entry 8, which needs a human decision.
Waiting for: Nothing blocking. Four open questions, all listed in the report.









