# Domain Index

Version 1.0 | 2026-06-29 | Production

---

## Document Purpose

Registry of all knowledge domains in this context architecture. Add one entry per domain. The routing table in ROUTING.md Step 2 should have a corresponding row for each domain listed here.

> **Edit guard:** Adding or removing domains is system-layer work. Route to `projects/system/` and record the change in `session-log.md` before editing this file.

---

## Registered Domains

| Domain | Folder | Covers |
|---|---|---|
| Example Domain | `knowledge/domains/example-domain/` | Placeholder domain showing the required structure — replace with your first real domain |

---

## Adding a Domain

1. Create `knowledge/domains/[domain-name]/description.md` — scope, constraints, when to load.
2. Create `knowledge/domains/[domain-name]/knowledge.md` — reference material with Index and Executive Summary.
3. Add a row to this index.
4. Add a routing row in ROUTING.md Step 2.
5. Follow `knowledge/domains/authoring-guidelines.md` for content standards.

---

## Version History

| Version | Date | Summary |
|---|---|---|
| 1.0 | 2026-06-29 | Initial creation. Placeholder example domain registered. |
