---
type: project
project: system
---

# System — TODO

Version 1.4 | 2026-09-10 | Active

> **Routing check:** This is a task tracking file, not a work queue. Do not start work on any item here unless you have completed ROUTING.md routing and received explicit human confirmation for this session.

> **Push policy:** Nearly every change made while working in this project must be committed and pushed (`.\scripts\commit-push.ps1`) — see `ROUTING.md` Standing Rules for cadence guidance. If a push is deferred until a work segment finishes, flag it explicitly to the human before the turn ends; the human may end the session at any point.

---

## Open

### Carried forward from the 2026-09-10 template-audit session

The thirteen relayed findings from `familien-boe` are all closed (`session-log.md` Turns 34–54). These are what is genuinely outstanding after them. They live here rather than only in the session log because a session routed to this project loads this file, and reading 55 turns to find four open items is not a plan.

- [ ] **Relay the closed status back to `familien-boe`.** All thirteen entries in that fork's `projects/system/upstream-feedback.md` still read `Status: Open`. Under the lifecycle in `knowledge/flow/upstream-sync.md` §7 they should be `Relayed`, then `Landed` against commits `7e1dff6`–`e04109a`. Requires a session with that fork as home — it is a read-only guest from here (`repo-mixing.md` §4)
- [ ] **Decide whether §7's disclosure is enough on its own.** `Architecture.md` §7 records that maintenance here is human-triggered and names the cost. The alternative considered and parked on 2026-09-10 was per-domain staleness dates plus a session-start nudge. Revisit if the disclosure alone proves insufficient
- [ ] **Look at conventions that instruct forks to duplicate text.** `upstream-sync.md` §7 tells a fork to keep its own copy of the feedback-log rules, and nothing keeps that copy current — the 2026-09-10 lifecycle change made every existing fork's copy stale on the spot. §7 now says to refresh it, but the general shape is worth a harder look than one sentence
- [ ] **Decide whether `projects/[name]/context/` should get a template**, the way domains now do. Deferred from Turn 36: a fork has ten context files diverging from the markdown baseline three different ways, and this template ships none, so it means deciding whether every project carries an empty folder

### Fresh-fork setup

- [ ] Replace `knowledge/domains/example-domain/` with your first real knowledge domain
- [ ] Replace `projects/example-project/` with your first real initiative project
- [ ] Update ROUTING.md Step 2 routing table — replace placeholder rows with your domains and projects
- [ ] Update `.github/copilot-instructions.md` — replace `[Project Name]` with your initiative name
- [ ] Delete placeholder content once replaced (`example-domain/`, `example-project/`)
- [ ] Human validates all knowledge domain content before it is relied on in active projects

---

## Backlog — Context-Engineering / Industry-Tooling Exploration

Ambitions discussed 2026-08-18, motivated by comparing this repo against how the AI industry names and builds "context engineering" (RAG, vector search, MCP, agent memory services). Not started — none of this is scheduled, revisit individually whenever there's appetite. Rough priority order, highest first, reasoning summarized inline; see that session's conversation for the full comparison this was drawn from.

- [ ] **MCP server for proto.** Expose the routing table, domain loading, and flag-raising as MCP tools (`route_request`, `load_domain_section`, `raise_flag`, ...) so any MCP-compatible client can call proto's routing logic directly, instead of an LLM session interpreting `ROUTING.md` by reading it. Best-fit of everything on this list: it doesn't change how routing decisions get made, just adds a deterministic interface on top — the same "let code enforce it, not just a prompt" upgrade already applied via the pre-commit/pre-push hooks. See the self-hosting note below before standing one up.
- [ ] **Retrieval eval harness.** A small labeled set of cases — request text paired with the Step 2 project match and Step 4 domain/section match a human would expect — run automatically. Directly closes the "no eval harness" gap. Also the prerequisite for the next item: without a baseline, there's no honest way to say whether semantic search actually helps.
- [ ] **Opt-in semantic-search layer for Step 4.** Embed domain/section content into a lightweight local vector store as an additional, clearly-optional retrieval aid — the hand-curated Index stays ground truth, this never replaces it. Build after the eval harness above, so hand-curated vs. semantic routing can be compared on the same cases rather than added on faith. This is the one item on this list with real audit-trail tradeoffs if it's ever treated as more than an opt-in aid — keep it off by default.
- [ ] **(Separate practice project, not a change to proto itself) LangGraph / memory-as-a-service exploration.** Mem0/Zep/Letta integration, or a LangGraph reimplementation of the `ROUTING.md` steps as an executable graph. Deliberately scoped as its own standalone project that borrows proto's ideas rather than an edit to proto's files — both fight this template's audit-first, human-gated design harder than the three items above, and real forks (including a production one) depend on proto's stability as-is.

**On self-hosting the MCP server for other AI sessions to use, not just this one:** worth doing eventually, but scope the first version to personal or team hosting — a machine or server under your own control, used by your own sessions across your own forks — rather than a broadly-reachable public service. A publicly reachable server is real infrastructure (uptime, auth, rate limiting) and a real leak-surface risk for any fork that also holds a restricted-tier companion repo with genuinely sensitive content — a routing server has no business ever being the thing that exposes that. "Other AIs using it" in practice means it being configured as an MCP connector wherever those sessions run — that doesn't happen automatically just because a server exists somewhere. Start narrow, broaden only once the private version has proven itself.

---

## Done

- [x] System project created (2026-06-29)
