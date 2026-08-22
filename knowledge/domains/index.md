# Domain Index

Version 1.3 | 2026-08-22 | Production

---

## Document Purpose

Registry of all knowledge domains in this context architecture. Add one entry per domain. The routing table in ROUTING.md Step 2 should have a corresponding row for each domain listed here.

> **Edit guard:** Adding or removing domains is system-layer work. Route to `projects/system/` and record the change in `session-log.md` before editing this file.

---

## Registered Domains

> Update `Last Updated` whenever a domain's `description.md` or `knowledge.md` changes materially. Update `References` whenever a `> **See also:**` cross-reference (authoring-guidelines.md §5) is added or removed — and check whether the referenced domain's row should list this one back. A reference that only points one way is a common source of silent drift as the domain family grows. Update `Status` when a domain is retired or reactivated — see § Retiring a Domain below; `scripts/validate.ps1` checks it stays consistent with the domain's own files.

| Domain | Folder | Status | Covers | Last Updated | References |
|---|---|---|---|---|---|
| Example Domain | `knowledge/domains/example-domain/` | Active | Placeholder domain showing the required structure — replace with your first real domain | 2026-08-11 | None |

---

## Cross-Domain Query Recipes

Named combinations of domains for recurring tasks that don't map to a single domain — e.g. a task that always needs two specific domains loaded together, in a specific order. Add an entry the second time a combination recurs; a one-off combination doesn't need one. Without this, the knowledge of which domains answer a cross-cutting question exists only as in-session judgement, and has to be re-derived every time.

| Task | Domains to load | Notes |
|---|---|---|
| *(e.g. "trace a request end-to-end")* | *(e.g. Domain A §2 + Domain B §1)* | *(load order, overlap, or anything non-obvious about the combination)* |

---

## Adding a Domain

1. Create `knowledge/domains/[domain-name]/description.md` — scope, constraints, when to load.
2. Create `knowledge/domains/[domain-name]/knowledge.md` — reference material with Index and Executive Summary.
3. Add a row to this index, with today's date under `Last Updated` and any cross-referenced domains under `References`.
4. Add a routing row in ROUTING.md Step 2.
5. Follow `knowledge/domains/authoring-guidelines.md` for content standards.
6. If this domain cross-references another (authoring-guidelines.md §5), check whether the referenced domain's row should reference this one back.
7. Grep the repo for stale mentions of this domain now that it exists — both scope-exclusion placeholder prose in other domains' `description.md` files (e.g. "[Topic] domain (not yet created)") and any plain-text references to a raw file this domain supersedes. Update each to a real link or domain reference. Do this now, not later — onboarding is the moment this is cheap to fix, since the session already knows exactly what changed; a later Maintenance Pass has to rediscover it (`authoring-guidelines.md` §8 has the backstop check for exactly the cases this misses).

---

## Retiring a Domain

Use when a domain has become permanently irrelevant — not simply quiet or slow-moving. Confirm with the human first; retiring is a structural, human-gated decision, same as adding a domain.

1. Set the Status field in both `description.md` and `knowledge.md` headers (`MarkdownConventions.md` §1) to `Retired`, bump each file's version, and add the retirement blockquote with today's date and a one-line reason.
2. Update this domain's row above: `Status` → `Retired`.
3. Do not remove the domain's folder or files, and do not remove `> See also:` cross-references from other domains that still point to it — a retired domain remains a valid historical reference.
4. Record the retirement in `projects/system/session-log.md` as a structural change (`ROUTING.md` Hard Constraints).
5. No `ROUTING.md` edit is needed — Step 4 already skips domains marked `Retired` in this index by default.

Reactivating a retired domain reverses steps 1–2 and is logged the same way.

---

## Version History

| Version | Date | Summary |
|---|---|---|
| 1.0 | 2026-06-29 | Initial creation. Placeholder example domain registered. |
| 1.1 | 2026-07-15 | Added `Last Updated` and `References` columns to the registry and a Cross-Domain Query Recipes section — addresses discovery staleness, asymmetric cross-references, and cross-cutting queries with no fixed home. |
| 1.2 | 2026-07-25 | Added a `Status` column (Active/Retired) to the registry and a "Retiring a Domain" procedure — archive-in-place, not delete, per `MarkdownConventions.md` §1. `scripts/validate.ps1` now checks this column stays consistent with each domain's own header Status. |
| 1.3 | 2026-08-22 | Added step 7 to "Adding a Domain" — grep the repo for stale mentions of the new domain (scope-exclusion placeholders in sibling `description.md` files, superseded raw-file references) at onboarding time, when it's cheap. Relayed via `[FLAG FOR UPSTREAM]`. See `projects/system/session-log.md` Turn 27. |
