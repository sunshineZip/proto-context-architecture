# Fork Health Check

Version 1.1 | 2026-09-10 | Production

---

## Document Purpose

A one-time, whole-repo structural audit of a fork's own accumulated content — the layer between the per-domain Maintenance Pass and the upstream template sync, which neither of those covers. Run it on request; nothing triggers it automatically.

---

> **Routing check:** This is a procedure, not background reading. Do not start it without completing `ROUTING.md`'s Route steps and getting explicit human confirmation for this session.

> **Edit guard:** Changes to this file are system-layer work. Route to `projects/system/` and record the change in `session-log.md` before editing.

---

## Index

1. [What This Covers, and What It Does Not](#1-what-this-covers-and-what-it-does-not)
2. [Before You Start](#2-before-you-start)
3. [The Passes](#3-the-passes)
4. [The Causal Pass](#4-the-causal-pass)
5. [Output Contract](#5-output-contract)
6. [Version History](#version-history)

---

## 1. What This Covers, and What It Does Not

Three maintenance mechanisms exist, at three scopes, and the gap between the first two is where drift accumulates unseen:

| Mechanism | Scope |
|---|---|
| Maintenance Pass (`knowledge/domains/authoring-guidelines.md` §8) | One domain document |
| **This procedure** | **The whole fork's own content** |
| Upstream sync (`knowledge/flow/upstream-sync.md`) | Changes arriving from the template |

The middle row is the one that was missing. A fork two months old and in near-daily use ran this for the first time and found 59 issues, none hidden and none previously looked for. Roughly two-thirds turned out to be properties of the template rather than of that fork — which is the other reason to run it: what it finds is often not yours.

**Nothing schedules this.** It runs when a human asks. That is a real limitation, stated here rather than left to be discovered: a procedure whose trigger is "when things have visibly diverged" requires someone to have already noticed the thing the procedure exists to notice. Do not read the existence of this file as a claim that the audit happens on its own. This is true of every maintenance mechanism here, not just this one — `Architecture.md` §7 states the posture once and names what follows from it.

---

## 2. Before You Start

**Run `scripts/validate.ps1`. Do not read it and infer.** This is the single most important instruction here, and it is written this emphatically because it has failed twice for two different reasons.

Once, a session concluded PowerShell was unavailable when it was on `PATH`, read the script instead, and produced a defensible but incomplete analysis — actually running it showed that 56 of 69 warnings were noise from three checker defects, one of which was invisible from reading because it only manifests as a count discrepancy across files.

Separately, a session that *did* run it read a clean pass as evidence of conformance. It was not: the repo violated six of its own conventions at the time, and four of those were found only by checks written after the clean run. **A green result means the checks that exist passed. It says nothing about the conventions nothing checks** — see `knowledge/flow/convention-enforcement.md`, which maps exactly that.

So: run it, record the exact error and warning counts as your baseline, and if it genuinely cannot run, say so explicitly in the report rather than quietly substituting a read. Verify the interpreter is really missing before concluding that it is.

---

## 3. The Passes

**Phase 0 — Orient.** Read in full: `ROUTING.md`, `Architecture.md`, `MarkdownConventions.md`, `knowledge/domains/authoring-guidelines.md`, `knowledge/flow/operating-principles.md`, `knowledge/flow/routing-rules.md`. These define what "correct" means in this repo. Then take the validator baseline per §2.

**Phase 1 — Scope, and audit the checker itself.** Everything `validate.ps1` already checks is out of scope; do not re-report what it catches. But audit the checker on two axes:

- **Coverage.** Which stated conventions have nothing behind them? `convention-enforcement.md` already maps this — start there rather than re-deriving it, and report anything it has missed or that has changed.
- **Signal-to-noise.** Classify every warning it emits as real or not. A check whose output is mostly noise is a defect, not a working check. This is how the three orphan-section bugs were found.

**Phase 2 — Read everything, in full.** Every file under `knowledge/domains/`, `knowledge/flow/`, `projects/`, `library/`. Not excerpts. Cross-domain duplication is only visible if you have actually read both copies.

**Phase 3 — Findings.** At minimum look for:

- **Cross-domain duplication** — the same fact in two places rather than stated once and cross-referenced. Check parallel domains especially; they are usually created by copying.
- **Index and content divergence** — an entry naming a section that moved, or a description that no longer describes its section; an Executive Summary that no longer reflects what is operationally critical.
- **Stale claims** — time-sensitive content carrying no signal, deadlines and target dates silently passed, preconditions ("once X exists") already satisfied.
- **Token bloat** — prose that should be a table; an Executive Summary grown past what a time-constrained session needs. Measure in characters, not lines: one long bullet defeats a line-based threshold.
- **Split and retire candidates** — apply §8's actual test (does a task ever need the whole file?), never a size threshold. Record the outcome as a `Split assessed` declaration (`authoring-guidelines.md` §3) so the next session does not re-litigate it.
- **Routing accuracy** — does every domain and active project have exactly one routing row, at the right load level, with section references that resolve?
- **Stale projects** — concluded but never marked so; TODO items that read as already done, or listed both open and done; a project whose companion domain has moved on without it.
- **Behavioural-claim hedging** — unhedged trait claims that should be pattern-based, and confidence tags that contradict a hedge in the same sentence.
- **Link integrity beyond the validator** — resolve every markdown link from its own file's directory, excluding fenced and inline code, where examples are deliberately fictional.

**Phase 4 — the causal pass.** See §4. Do not skip it.

**Phase 5 — Output.** See §5.

---

## 4. The Causal Pass

This is where the value is, and it is the step most likely to be dropped for looking like extra work after the findings are already written down.

For each finding, ask: **what property of this repo let it arise, and then let it persist?** Group the answers into mechanisms and map every finding to the mechanism or mechanisms that explain it.

In the audit this procedure generalises, listing 50 symptoms produced a long to-do list. Asking the causal question collapsed them to nine mechanisms, with 48 of the 50 mapping to at least one — and made clear that fixing the 50 without the nine would simply regenerate them.

State the coverage honestly. If a finding has no systemic cause, say so rather than forcing it into a mechanism to make the mapping look complete.

Mechanisms worth testing for explicitly, because they recur:

- Duplication permitted with only a manual reconciliation step.
- Nothing aware of the current date.
- Rules stated without enforcement.
- Maintenance mechanisms that are opportunistic, and therefore never run.
- Content created by copying a sibling rather than from a template.
- A correction placed downstream of where a reader first meets the claim it corrects.

---

## 5. Output Contract

**This procedure is read-only. Produce a report; change nothing else.** Do not raise knowledge-update flags, do not edit `knowledge/`, do not fix anything you find. The audit and the repairs are separate pieces of work, and mixing them is how an audit quietly becomes an unreviewed rewrite.

Write one queue file to `projects/system/context/`, created on first use. Structure it so a later session can work a single item without loading the rest:

- **A compact checklist** — one line per item: ID, mechanical or judgement call, impact, approval gate, title.
- **Then one self-contained block per item** — exact file paths and sections, what is wrong, why it matters, the proposed fix, a done-condition, and any overlap with other items.
- **Every item's approval gate, stated explicitly** — knowledge-layer flag, system-layer routing, or project-layer — so a later session does not re-derive the edit ceremony per item.

**Mechanical** means objectively correct regardless of judgement. **Judgement call** means defensible but arguable; say plainly that these need human sign-off before anyone acts, per the correct-cautiously rule in `operating-principles.md` §2.

Two further constraints on the report itself:

- **Refer to sensitive content by location, never by quoting it.** A report is a new document with a new audience, and `MarkdownConventions.md` §8 applies to it as much as to the file it describes.
- **Report honestly what you could not verify.** Name it and say why. An audit that hides its own gaps is worse than a shorter one that admits them.

**Before proposing a template-level fix, check whether it is already known.** Much of what a fork finds is inherited rather than local. `knowledge/flow/convention-enforcement.md` §6 lists the open gaps this template already knows about, and `projects/system/session-log.md` records what has been fixed and why. Checking those first is cheaper than rediscovering them, and a finding that is genuinely template-level goes to `upstream-sync.md` §7 rather than being fixed locally.

---

## Version History

| Version | Date | Summary |
|---|---|---|
| 1.0 | 2026-09-10 | Initial creation. Generalises a one-time whole-repo audit run by the `familien-boe` fork, which produced 59 findings and nine root causes and whose relayed entries drove twelve changes to this template. Fills the gap between the per-domain Maintenance Pass and the upstream sync, which `authoring-guidelines.md` §8 had been pointing at `upstream-sync.md` to cover — a misdirection, since that file covers template drift rather than a fork's own. The embedded branch-authorization preamble from the source prompt was deliberately not carried over; that is handled by `.branch-authorization` and `ROUTING.md`'s Hard Constraints, and restating consent in a fifth place would be its own drift. See `projects/system/session-log.md` Turn 50. |
| 1.1 | 2026-09-10 | §1's "nothing schedules this" note now points at the new `Architecture.md` §7, which states the posture once for all five maintenance mechanisms rather than leaving each to state it alone. See `projects/system/session-log.md` Turn 52. |
