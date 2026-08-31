---
type: flow
---

# Repo Mixing

Version 1.1 | 2026-08-31 | Production

---

## Document Purpose

An **optional, opt-in** pattern for a person running more than one fork of this template — one per initiative — who wants a single session to deliberately draw on two or more of their own forks at once, without collapsing them into one repo or standing up a permanent link between them. Example: a "children's learning" fork and a "personal career" fork, mixed for one session to bring career-domain knowledge into a kids'-education project. Adopt what follows only if §2 describes your situation.

This is a different problem from the companion-repository pattern (`restricted-tier.md`): that one exists to enforce a hard access boundary between a public repo and one holding real third-party sensitive material. Repo mixing is about convenience between repos the *same person* already fully owns and can already read end to end — the problem here is routing discipline and sensitivity discipline, not access control.

---

> **Routing check:** This file describes a structural extension a fork adopts deliberately, not something any session should build unprompted. Do not create any of the structure below without explicit human confirmation — same Plan-first discipline as any other structural change.

> **Edit guard:** This file lives in the base template. Changes to it, in `proto-context-architecture` itself, are system-layer work — route to `projects/system/` and record the change in `session-log.md` before editing. A fork *adopting* this pattern is not editing this file; it is following the procedure it describes, across its own repos.

---

## Index

1. [Why This Exists](#1-why-this-exists)
2. [Should Your Forks Adopt This?](#2-should-your-forks-adopt-this)
3. [The Core Design: Home and Guest](#3-the-core-design-home-and-guest)
4. [The Hard Constraints](#4-the-hard-constraints)
5. [Declaring the Mix](#5-declaring-the-mix)
6. [What Guest Content Is Even Mixable — the Export Registry](#6-what-guest-content-is-even-mixable--the-export-registry)
7. [The Sensitivity Gate](#7-the-sensitivity-gate)
8. [Restate, Never Link](#8-restate-never-link)
9. [The Mixing Log](#9-the-mixing-log)
10. [Mounting Mechanics](#10-mounting-mechanics)
11. [Naming Collisions](#11-naming-collisions)
12. [Worked Example](#12-worked-example)
13. [Setup Checklist](#13-setup-checklist)
14. [Version History](#14-version-history)

---

## 1. Why This Exists

The base template assumes one repo = one `ROUTING.md` = one routing authority for a session (`Architecture.md` §4). That assumption holds even once someone runs several forks side by side, because nothing in the base design says what happens when a second fork's files are also sitting on disk. Left unaddressed, that gap produces real ambiguity the moment two forks are both reachable in one session: which `ROUTING.md`'s Hard Constraints govern, which repo's `session-log.md` gets the turn, which repo's branch-default policy applies, and — the sharpest problem — whether a fact tagged `[SENSITIVE: severe]`/⛔ in one fork's domain (written expecting it to never leave that fork) is safe to restate in a completely different fork with a different downstream audience.

That last problem is not hypothetical. A fork tracking children's education may eventually be shown to a school, a co-parent, or the children themselves; a fork tracking a parent's career may hold an employer's confidential internal data. The same person owns both, but "the same person can read it" and "it's fine for this content to end up in that fork's permanent, append-only session-log" are different questions. This document exists to answer both the routing-authority problem and the sensitivity-crossing problem with one procedure, instead of leaving each mixing session to improvise.

---

## 2. Should Your Forks Adopt This?

| Signal | What it suggests |
|---|---|
| You run one fork and have no plans to mix it with another | Don't adopt this — nothing here applies. |
| You occasionally want to paste a fact from one fork into another by hand, once in a while | Just do that. This document is for repeated, deliberate, in-session mixing, not a one-off copy-paste. |
| You run multiple forks that are each too large to fold into the other as a knowledge domain (per `Architecture.md` §6 step 4's normal "copy `example-domain/`" path), and you want to combine them for specific sessions on demand | Adopt this. |
| One of the forks you'd mix in holds content that would be a problem if it surfaced in the other fork's permanent record | Adopt this — §7's sensitivity gate is exactly for this case, and skipping this document is how that content ends up somewhere it shouldn't. |

The volume/reach test: would content really need to move from one fork into another's durable knowledge or session-log more than once? If it's genuinely a single fact, restate it by hand and move on — you don't need a documented procedure for that. If it's a recurring need across sessions, this is the pattern.

---

## 3. The Core Design: Home and Guest

Exactly one fork is **home** for a mixing session — it owns `ROUTING.md` Steps 1–4, its Hard Constraints govern the whole session, its `projects/[name]/session-log.md` receives the turns, and it is the only repo anything gets committed to. Every other fork present is a **guest** — read-only for that session, consulted for its knowledge, never written to.

This is a direct generalization of the single-authority principle `restricted-tier.md` §11 already states for a companion repo ("routing/processing logic isn't itself sensitive content... centralizing routing costs nothing") — extended here from an asymmetric access-gated pairing to a symmetric one between peer forks. The reasoning is the same either way: two live `ROUTING.md` files claiming authority over one session is not a state this system's routing discipline has any way to resolve, so it must never be allowed to arise. Home/guest is declared, not inferred (§5) — a session does not get to decide for itself which fork is "in charge" based on which one the request seems more about.

Home is a per-session choice, not a permanent designation. The same two forks can swap which is home from one session to the next, depending on which project the work actually lives in.

---

## 4. The Hard Constraints

Put these in home's own `ROUTING.md` Hard Constraints once adopted (adapt names, keep the structure):

- **A guest repo is read-only for the whole session.** No commit, no `session-log.md` turn, no knowledge-layer edit ever lands in a guest repo during a mixing session. If something belongs in the guest repo, say so and stop — that's a separate session with the guest as home, not an in-session write.
- **A guest repo's content does not cross into home's output — chat responses, session-log turns, or committed files — beyond what §6's export registry lists as mixable, and even then only after §7's sensitivity gate.** Untagged or unlisted guest content is not fair game just because it was technically readable once the guest repo was mounted.
- **Nothing from a guest repo is ever committed to home as a live cross-repo reference (a relative path into the guest's checkout, a submodule pointer, a "see `[guest-repo]/knowledge/domains/x`" citation meant to be resolved later).** See §8 — restate, don't link.
- **Home's own Hard Constraints govern the session in full**, including its branch-default policy, secret-handling pause-and-ask rule, and system-layer logging requirement. A guest repo's Hard Constraints are not binding on this session's actions — they're not even necessarily consistent with home's (different branch-default policy, different sensitivity-tag conventions) — but its Working Constraints on specific domains (§7) still describe what that content actually is and should still be read and honored when deciding what's safe to pull.

---

## 5. Declaring the Mix

At the start of a session that will mix repos, before Step 1 of home's `ROUTING.md` completes, state explicitly:

- Which fork is **home** for this session. Exactly one — never a set, never "whichever one turns out to matter most."
- Which fork(s) are **guest**, and roughly why each is being brought in (which project or topic it serves).

This is always a human statement, not something a session infers or self-assigns. The signal that a repo is *technically reachable* (mounted, cloned, sitting in the same workspace) is not the same signal as "declared for this mix" — a session with three forks checked out for unrelated reasons has zero guests until a human names one. If home isn't stated and more than one fork's files are reachable, ask which one is home before doing anything else — the same "ambiguous, ask one question" discipline `ROUTING.md` Step 2 already applies to an unmatched request. Do not guess home from whichever repo's directory the session happens to be sitting in; that's an artifact of how the environment mounted things, not a routing decision.

**With three or more forks present**, declare each guest individually rather than as a block — "guest: the career fork, for its leave-policy content; guest: the homelab fork, for its authentication-security domain" — not "the other two are guests." Two reasons this matters more as the guest count grows: first, §6's export registry and §7's sensitivity gate are evaluated per guest, against that guest's own domain scope and tagging conventions, which can differ fork to fork — a blanket declaration invites treating all guests as equally reviewed when they aren't. Second, a fork reachable in the session but never named as a guest stays exactly as off-limits as if it weren't mounted at all — being on disk is not itself a declaration, however many forks that turns out to be true of at once.

Once declared, Step 1's sync-check (`ROUTING.md` Step 1) should run for every mounted repo, home and guest alike — staleness in a guest is exactly as real a risk to trust as staleness in home, since Step 4 loads content from it the same way.

---

## 6. What Guest Content Is Even Mixable — the Export Registry

Not everything in a guest repo should be assumed fair game just because it's readable. Each fork that expects to ever be a guest should mark, in its own domain registry (`knowledge/domains/index.md` in the standard layout — the registry that actually plays this role if a fork's structure diverges, per §11), which domains are meant to be pulled into another of the same person's forks. A domain absent from this list is not mixable by default, the same way `restricted-tier.md` §4 treats an unnamed file as off-limits by default.

A minimal way to mark this without inventing new machinery: add a line to the domain's row, or to its `description.md` Working Constraints, stating a mixing posture — e.g. "Mixable into other forks: yes, ordinary content only" or "Mixable into other forks: no." Domains that were never written with any outside audience in mind (see `nikolaj-career-employment`'s own Working Constraint distinguishing itself from the health domains, which "are written expecting eventual third-party sharing") should default to **not mixable** until someone deliberately reviews and marks them otherwise — the same "not yet reviewed, not cleared" posture `extraction-procedure.md` §4.3 applies to untagged content generally.

---

## 7. The Sensitivity Gate

If the guest fork uses the two-tier sensitivity signal (`[SENSITIVE]`/🔒, `[SENSITIVE: severe]`/⛔ — `MarkdownConventions.md` §8, where a fork has adopted it), apply it at the point of pulling content across, the same way `extraction-procedure.md` §4 already governs handing content to an external recipient — mixing into another of your own forks is a lighter-stakes version of the same act (content leaving the repo it was written for), not a stakes-free one, because the two forks can have genuinely different downstream audiences.

- **`⛔ [SENSITIVE: severe]`** — never pulled across by default. If a task genuinely seems to need it, stop and name the specific claim to the human rather than deciding either way — same rule as `extraction-procedure.md` §4.1.
- **`🔒 [SENSITIVE]`** — pull across only what the specific task actually needs, not the whole section it's tagged in. Lean toward less; a follow-up question is always available, an already-restated fact in another fork's permanent session-log is not easily un-said.
- **Untagged content** — not automatically safe. Treat it as unreviewed, apply the same judgment as if it carried a tag, per `extraction-procedure.md` §4.3.

Where a guest fork has no sensitivity tagging at all (many forks won't), fall back to the base `ROUTING.md` Hard Constraint every fork already has: pause and ask before writing a secret, credential, or confidential detail into any tracked file — that gate doesn't go away just because the content is moving fork-to-fork instead of person-to-outsider.

---

## 8. Restate, Never Link

When mixing surfaces something durable enough to belong in home permanently — not just used in this session's conversation, but worth keeping — write it into home's own tracked files (a project's `context/`, or a domain's `knowledge.md` via the normal `[FLAG FOR KNOWLEDGE UPDATE]` gate), re-expressed in home's own words. Never leave a live pointer into the guest's checkout as the durable artifact.

This isn't a new rule invented for this document — it generalizes a constraint `hh-learning` already carries for exactly this pair of forks: *"Never duplicate health/daycare/household content from `familien-boe`. If a fact... is needed here, state it directly (re-confirmed, not copied as a live cross-reference) rather than linking into `familien-boe`, which stays a fully independent repo."* The reasoning generalizes past that one pair: a guest repo is not guaranteed to be mounted next to home on every future machine, for every future collaborator, or in every future session — a link that only sometimes resolves is worse than a restated fact that always does. Restating also forces the §7 sensitivity pass to actually happen at the point of writing, rather than being silently deferred by a link that "will get reviewed later, whenever someone follows it."

---

## 9. The Mixing Log

Once a mixing session has pulled anything durable into home (per §8), record that it happened — not the content itself — in home's `projects/system/mixing-log.md`. One row per **(session, guest, destination)** that produced a durable write, appended chronologically, never edited (same append-only spirit as `session-log.md`, though this file isn't subject to the turn-protocol machinery — a plain running table, mirroring `extraction-procedure.md` §6's log). Columns: date, guest repo, domains/sections drawn from, the home project or domain the content landed in, and a one-line note on any 🔒 content included or ⛔ content flagged-and-declined.

A session mixing more than one guest gets one row per guest that actually contributed a durable write, not one merged row — a guest that was declared but never ended up contributing anything durable doesn't get a row at all. This keeps the log answerable per-guest later ("what has ever crossed from the career fork specifically") without having to parse which part of a combined row came from where.

Create the file, with a header row, the first time this procedure actually produces a durable write — don't pre-create it speculatively. A session that only used guest content transiently in conversation, without writing anything durable into home, doesn't need a log entry.

---

## 10. Mounting Mechanics

Deliberately left environment-agnostic. Unlike the companion-repository pattern, there is no access-control reason here to couple the two repos structurally (no submodule requirement) — both are already fully readable by the same person, and a submodule pinned per pairing doesn't scale once someone runs three or four forks they mix in different combinations. What actually matters is only that Step 1 (§5) can tell more than one fork's files are present and ask which is home if that isn't already stated.

In practice, "mounting" is whatever gets both checkouts onto the same session's disk: a multi-root editor workspace, sibling clones in the same environment, or (as demonstrated live while drafting this document) an agent environment's own repo-attach mechanism. None of these needs to be codified here — Step 5's declaration is the actual mechanism; how the files got there first is incidental.

---

## 11. Naming Collisions

A guest fork's structure is not guaranteed to match home's — `familien-boe` uses the standard `knowledge/domains/[name]/` layout, while `hh-learning` (developed against the same template) uses fixed top-level areas (`children/`, `curriculum/`, `homeschool-compliance/`, ...) instead, because a generic domain folder was a worse fit for its subject matter. §6's export registry lives wherever a given fork's own domain/area index actually is — don't assume the standard path.

When citing guest content in home's own output (a chat response, a session-log turn, a restated fact's provenance note), qualify it with the source repo's name — `familien-boe:nikolaj-career-employment`, not just `nikolaj-career-employment` — since a bare domain name is not guaranteed unique once more than one fork is in play, and a future reader of home's session-log shouldn't have to guess which repo a name came from.

---

## 12. Worked Example

Home: a children's-learning fork (a project tracking "prepare the kids for school and their first few weeks"). Guest: a personal-career fork, brought in because that fork's career domain holds relevant material — a leave/flexibility policy that affects drop-off and pickup logistics, say, or a transferable skill worth folding into how a parent approaches teaching prep.

1. Declare the mix (§5): home is the learning fork, guest is the career fork, purpose is drop-off/pickup logistics for the first weeks of school.
2. Check the career fork's export registry (§6) for its career domain's mixing posture. If the domain's Working Constraints mark ordinary content as shareable but a specific appendix (e.g. an employer's confidential internal figures) as more sensitive, that split is the whole point of §7 — the leave-policy fact is very likely fine, the confidential appendix is very likely not, and they don't get the same treatment just because they live in the same domain file.
3. Pull across only what the stated purpose needs (§7's 🔒 handling) — the leave policy's practical effect on drop-off/pickup, not an unrelated performance-review narrative sitting in the same domain.
4. Restate it into the learning fork's own project `context/` (§8) in the learning fork's own words, sourced-but-not-linked back to the career fork.
5. Log the mixing session (§9) once anything durable actually landed.

Nothing here required merging the two forks, moving the career fork's content permanently into the learning fork, or building any new tooling — the procedure is the guardrail, not a system to stand up.

---

## 13. Setup Checklist

1. Decide which of your forks will ever act as home, and confirm each fork that might be a guest has (or is willing to build) an export registry entry per §6 for the domains it's willing to lend.
2. Add the Hard Constraints (§4) to each fork's own `ROUTING.md` — every fork that might ever be home needs them, since the constraint is about what a session does when it becomes home, not a property of the guest.
3. If any fork you'll mix already uses the two-tier sensitivity system (`MarkdownConventions.md` §8), nothing further is needed for §7 to apply — it reuses that tagging as-is. If a fork you'll mix has no sensitivity tagging at all, decide now whether to add it or to rely on the base secret/confidential-detail Hard Constraint as the fallback (§7, last paragraph).
4. Create `projects/system/mixing-log.md` in each fork that will ever be home, the first time §9 actually needs it — not before.
5. If any domain should default to **not mixable** (per §6's default-closed guidance for content never written with an outside-fork audience in mind), mark that explicitly rather than leaving it to be inferred later under time pressure.

---

## 14. Version History

| Version | Date | Summary |
|---|---|---|
| 1.0 | 2026-08-31 | Initial creation. Designed after a real cross-fork question — mixing a children's-learning fork with a personal-career fork for a specific session — grounded against two real forks (`familien-boe`, `hh-learning`) rather than written in the abstract: `hh-learning`'s existing "restate, don't link" convention for `familien-boe` content generalized into §8; `familien-boe`'s two-tier sensitivity system and `extraction-procedure.md` generalized into §6-7 and §9 rather than inventing a parallel mechanism; `restricted-tier.md` §11's single-routing-authority reasoning generalized from the access-gated case to the peer-fork case in §3. See `projects/system/session-log.md` Turn 31. |
| 1.1 | 2026-08-31 (later) | §5 clarified: home/guest is always an explicit human statement, never inferred from which repos happen to be mounted or reachable — and with three or more forks present, each guest is declared individually rather than as a block, since §6/§7 gating is evaluated per guest against that guest's own domain scope and tagging. §9's mixing log clarified to one row per (session, guest, destination) rather than one merged row per session, so a multi-guest session stays answerable per guest later. Prompted by a direct question on both points. See `projects/system/session-log.md` Turn 32. |
