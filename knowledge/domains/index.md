# Domain Index

Version 1.1 | 2026-07-15 | Production

---

## Document Purpose

Registry of all knowledge domains in this context architecture. Add one entry per domain. The routing table in ROUTING.md Step 2 should have a corresponding row for each domain listed here.

> **Edit guard:** Adding or removing domains is system-layer work. Route to `projects/system/` and record the change in `session-log.md` before editing this file.

---

## Registered Domains

> Update `Last Updated` whenever a domain's `description.md` or `knowledge.md` changes materially. Update `References` whenever a `> **See also:**` cross-reference (authoring-guidelines.md §5) is added or removed — and check whether the referenced domain's row should list this one back. A reference that only points one way is a common source of silent drift as the domain family grows.

| Domain | Folder | Covers | Last Updated | References |
|---|---|---|---|---|
| Example Domain | `knowledge/domains/example-domain/` | Placeholder domain showing the required structure — replace with your first real domain | 2026-06-29 | None |

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

---

## Version History

| Version | Date | Summary |
|---|---|---|
| 1.0 | 2026-06-29 | Initial creation. Placeholder example domain registered. |
| 1.1 | 2026-07-15 | Added `Last Updated` and `References` columns to the registry and a Cross-Domain Query Recipes section — addresses discovery staleness, asymmetric cross-references, and cross-cutting queries with no fixed home. |
