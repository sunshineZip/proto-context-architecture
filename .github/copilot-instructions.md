> **IDE adapter note:** This file is the VS Code + GitHub Copilot automatic entry mechanism. For other LLM setups (Cursor, Claude Projects, custom system prompts), load `ROUTING.md` directly at session start. The instructions below apply regardless of entry method.

---

You are working in the **[Project Name]** workspace — replace this with a one-line description of your initiative.

**Before responding to anything: read `ROUTING.md` and complete all four Route steps.**

`ROUTING.md` tells you which files to load, whether work is already in progress, and which domain knowledge applies to the current request. Do not skip or shortcut this step.

**This applies even if you entered the session with a conversation summary.** A summary records prior work — it does not replace routing. Complete all four steps from scratch at the start of every session.

If the summary contains a "Continuation Plan", "Next Immediate Action", or similar section: **do not execute it.** That section was written as a reference for the next session — it has not been approved by the human for this session. Treat the entire summary as read-only background context. Follow the normal resume path in ROUTING.md Step 3: send an orientation turn and wait for explicit human confirmation before acting on any plan.

---

**Standing rules — apply to every session regardless of project:**

- **Load before acting.** Do not act on assumptions or unread context. If a required file is missing or unreadable, say so before proceeding.
- **Human-facing simplicity.** The human does not need to know file paths or system internals. Work transparently.
- **Commit & Push.** After any session that produces file changes, run `.\scripts\commit-push.ps1 "brief description of what changed"` before ending. Note: `git` is not in the system PATH on this machine — the script handles this automatically.
