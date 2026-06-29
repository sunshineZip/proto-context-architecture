# Project Types

Version 1.0 | 2026-06-29 | Production

---

## Document Purpose

Defines the standard project types and their default phase templates. Use these as the default routing baseline when starting a new project. Extend or replace templates for project types specific to your instance.

---

> **Routing check:** This file contains phase templates for already-approved work. If you have not completed README.md routing and received explicit human confirmation to proceed, stop and do that first.

---

## Project Types

| Type | Typical use | Default execution model |
|---|---|---|
| Multi-phase delivery | Any scoped initiative with measurable phase gates | Phase-driven, gate at each milestone |
| Development | New feature or capability delivery | Iterative build-review-test loop |
| Documentation | Knowledge capture, standards writing, domain authoring | Draft-review-approve-publish |
| General | Incidents, operational support, ad-hoc analysis | Flexible routing with lightweight intake |

---

## 1. Multi-phase Delivery Template

Use when a bounded initiative requires sequential phases with explicit approval gates between them. Adapt the phase list to fit the specific initiative.

**Default phases (customise as needed):**

1. Discovery and context gathering
2. Analysis and requirements
3. Design and planning
4. Implementation
5. Review and quality gate
6. Human testing and acceptance
7. Closure, documentation, and handoff

**Default progression:** each phase owner completes their deliverable, emits `STATUS: CHECKPOINT`, and waits for human confirmation before the next phase begins.

**Rework loop:** if review fails, emit `STATUS: RETURN TO PHASE [N]` with scope of required rework.

---

## 2. Development Template

Use for implementation work that does not require full multi-phase governance.

1. Intake and requirement clarification
2. Solution design
3. Implementation
4. Review
5. Human test and acceptance
6. Release notes and closure

**Default progression:**
- Intake: clarification with human as needed
- Design: plan before building
- Implementation: build per approved design
- Review: check against design before marking complete
- Test: human-led
- Closure: document what was built and any open items

**Rework loop:** `STATUS: RETURN TO PHASE [N]` → return to Implementation or Design

---

## 3. Documentation Template

Use for knowledge capture, process documentation, standards writing, or domain knowledge authoring.

1. Scope and outline agreement
2. Draft
3. Review
4. Approval and publish

**Default progression:**
- Scope: human confirms what the document should cover and who the audience is
- Draft: produce complete draft
- Review: human reviews and provides feedback
- Publish: apply feedback, finalise, commit

---

## 4. General Template

Use for incidents, operational support, ad-hoc analysis, and any task that does not fit the above types.

1. Intake — understand what is being asked and what done looks like
2. Execute — do the work
3. Verify — confirm output meets the intake definition
4. Close — document outcome and any open items

**Routing:** flexible. No fixed phase-owner sequence. Route based on STATUS signals and human direction.

---

## 5. Operational Template

Use for recurring operational tasks: health checks, maintenance verification, status reviews, and any session focused on the live state of a running system rather than delivering a new capability.

1. Intake — identify what is being checked and what sources are available
2. Assess — gather and interpret current state
3. Execute — resolve issues or document findings
4. Verify — confirm resolution or record unresolved items
5. Archive — append findings to the appropriate operational log

---

## Version History

| Version | Date | Summary |
|---|---|---|
| 1.0 | 2026-06-29 | Initial creation. Generic project templates adapted from NightCrew project-types.md. |
