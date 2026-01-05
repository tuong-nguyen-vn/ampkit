---
name: orchestrator
description: Plan and coordinate multi-agent bead execution. Use when starting a new epic, assigning tracks to agents, or monitoring parallel work progress.
---

# Orchestrator Skill: Autonomous Multi-Agent Coordination

This skill spawns and monitors parallel worker agents that execute beads autonomously.

**Prerequisite**: Run the `planning` skill first to generate `history/<feature>/execution-plan.md`.

---

## ⚠️ Critical Rule: Keep Orchestrator Context Clean

**The Orchestrator NEVER performs actual implementation work. It ONLY:**
- Reads execution plans
- Spawns worker subagents via `Task()`
- Monitors progress via Agent Mail
- Resolves cross-track blockers by messaging workers
- Announces completion

**ALL actual coding, file editing, testing, and implementation work MUST be delegated to Worker agents.**

This keeps the Orchestrator's context window clean and focused on coordination, preventing context overflow during long-running epics.

```
┌─────────────────────────────────────────────────────────────────┐
│  ORCHESTRATOR (This Agent)                                      │
│  ✅ Spawn workers     ✅ Monitor inbox    ✅ Send messages      │
│  ✅ Route blockers    ✅ Track progress   ✅ Announce complete  │
│  ❌ Edit files        ❌ Run tests        ❌ Write code         │
│  ❌ Debug issues      ❌ Install deps     ❌ Any implementation │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼ Task() delegates work
┌─────────────────────────────────────────────────────────────────┐
│  WORKERS (BlueLake, GreenCastle, RedStone, ...)                 │
│  ✅ Edit files        ✅ Run tests        ✅ Write code         │
│  ✅ Debug issues      ✅ Install deps     ✅ All implementation │
└─────────────────────────────────────────────────────────────────┘
```

## Agent Mail CLI

Agent Mail có thể được gọi qua CLI trực tiếp mà không cần MCP server:

```bash
# Alias ngắn gọn
am <command> '<json_args>'

# Hoặc tên đầy đủ
mcp-agent-mail <command> '<json_args>'
```

**Cài đặt CLI global:** Xem `docs/CLI_INSTALLATION.md` trong mcp_agent_mail repo.

---

## Architecture (Mode B: Autonomous)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              ORCHESTRATOR                                   │
│                              (This Agent)                                   │
├─────────────────────────────────────────────────────────────────────────────┤
│  1. Read execution-plan.md (from planning skill)                            │
│  2. Initialize Agent Mail                                                   │
│  3. Spawn worker subagents via Task()                                       │
│  4. Monitor progress via Agent Mail                                         │
│  5. Handle cross-track blockers                                             │
│  6. Announce completion                                                     │
└─────────────────────────────────────────────────────────────────────────────┘
           │
           │ Task() spawns parallel workers
           ▼
┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐
│  BlueLake        │  │  GreenCastle     │  │  RedStone        │
│  Track 1         │  │  Track 2         │  │  Track 3         │
│  [a → b → c]     │  │  [x → y]         │  │  [m → n → o]     │
├──────────────────┤  ├──────────────────┤  ├──────────────────┤
│  For each bead:  │  │  For each bead:  │  │  For each bead:  │
│  • Reserve files │  │  • Reserve files │  │  • Reserve files │
│  • Do work       │  │  • Do work       │  │  • Do work       │
│  • Report mail   │  │  • Report mail   │  │  • Report mail   │
│  • Next bead     │  │  • Next bead     │  │  • Next bead     │
└──────────────────┘  └──────────────────┘  └──────────────────┘
           │                   │                   │
           └───────────────────┼───────────────────┘
                               ▼
                    ┌─────────────────────┐
                    │     Agent Mail      │
                    │  ─────────────────  │
                    │  Epic Thread:       │
                    │  • Progress reports │
                    │  • Bead completions │
                    │  • Blockers         │
                    │                     │
                    │  Track Threads:     │
                    │  • Bead context     │
                    │  • Learnings        │
                    └─────────────────────┘
```

---

## Phase 1: Read Execution Plan

The planning skill outputs `history/<feature>/execution-plan.md` with:

- Track assignments (agent name, beads, file scope)
- Cross-track dependencies
- Key learnings from spikes

```bash
# Read the execution plan
Read("history/<feature>/execution-plan.md")
```

Extract:

- `EPIC_ID` - the epic bead id
- `TRACKS` - array of {agent_name, beads[], file_scope}
- `CROSS_DEPS` - any cross-track dependencies

---

## Phase 2: Initialize Agent Mail

### Option A: Via MCP Tools (trong agent context)

```python
ensure_project(human_key="<absolute-project-path>")

register_agent(
  project_key="<path>",
  name="<OrchestratorName>",
  program="amp",
  model="<model>",
  task_description="Orchestrator for <epic-id>"
)
```

### Option B: Via CLI (từ terminal hoặc Bash tool)

```bash
# Ensure project exists
am ensure_project '{"human_key": "<absolute-project-path>"}'

# Register orchestrator identity
am register_agent '{
  "project_key": "<path>",
  "name": "<OrchestratorName>",
  "program": "amp",
  "model": "<model>",
  "task_description": "Orchestrator for <epic-id>"
}'
```

---

## Phase 3: Spawn Worker Subagents

**Spawn all workers in parallel using Task tool:**

```python
# Spawn Track 1 Worker
Task(
  description="Worker BlueLake: Track 1 - <track-description>",
  prompt="""
You are agent BlueLake working on Track 1 of epic <epic-id>.

## Setup
1. Read /path/to/project/AGENTS.md for tool preferences
2. Load the worker skill: /skill worker

## Your Track
Beads to complete IN ORDER: <bead-a>, <bead-b>, <bead-c>
File scope: packages/sdk/**

## Protocol for EACH bead:

### Start Bead (choose MCP or CLI)

**Via MCP:**
1. register_agent(name="BlueLake", task_description="<bead-id>")
2. summarize_thread(thread_id="track:BlueLake:<epic-id>")
3. file_reservation_paths(paths=["packages/sdk/**"], reason="<bead-id>")

**Via CLI (Bash tool):**
```bash
am register_agent '{"project_key": "<path>", "name": "BlueLake", "task_description": "<bead-id>", "program": "amp", "model": "<model>"}'
am summarize_thread '{"project_key": "<path>", "thread_id": "track:BlueLake:<epic-id>"}'
am file_reservation_paths '{"project_key": "<path>", "agent_name": "BlueLake", "paths": ["packages/sdk/**"], "reason": "<bead-id>", "ttl_seconds": 3600, "exclusive": true}'
```

4. Claim: bd update <bead-id> --status in_progress

### Work on Bead
- Use preferred tools from AGENTS.md
- Check inbox periodically:
  - MCP: `fetch_inbox(agent_name="BlueLake")`
  - CLI: `am fetch_inbox '{"project_key": "<path>", "agent_name": "BlueLake", "include_bodies": true}'`
- If blocked, send message to epic thread with importance="high"

### Complete Bead

1. Close: bd close <bead-id> --reason "Summary of work"

2. Report to orchestrator:

**Via MCP:**
```python
send_message(
  to=["<OrchestratorName>"],
  thread_id="<epic-id>",
  subject="[<bead-id>] COMPLETE",
  body_md="Done: <summary>. Next: <next-bead-id>"
)
```

**Via CLI:**
```bash
am send_message '{
  "project_key": "<path>",
  "sender_name": "BlueLake",
  "to": ["<OrchestratorName>"],
  "thread_id": "<epic-id>",
  "subject": "[<bead-id>] COMPLETE",
  "body_md": "Done: <summary>. Next: <next-bead-id>"
}'
```

3. Save context for next bead:

**Via MCP:**
```python
send_message(
  to=["BlueLake"],
  thread_id="track:BlueLake:<epic-id>",
  subject="<bead-id> Complete - Context for next",
  body_md="## Learnings\\n- ...\\n## Gotchas\\n- ...\\n## Next bead notes\\n- ..."
)
```

**Via CLI:**
```bash
am send_message '{
  "project_key": "<path>",
  "sender_name": "BlueLake",
  "to": ["BlueLake"],
  "thread_id": "track:BlueLake:<epic-id>",
  "subject": "<bead-id> Complete - Context for next",
  "body_md": "## Learnings\\n- ...\\n## Gotchas\\n- ..."
}'
```

4. Release files:
   - MCP: `release_file_reservations()`
   - CLI: `am release_file_reservations '{"project_key": "<path>", "agent_name": "BlueLake"}'`

### Continue to Next Bead
- Loop back to "Start Bead" with next bead in track
- Read your track thread for context from previous bead

## When Track Complete

**Via MCP:**
```python
send_message(
  to=["<OrchestratorName>"],
  thread_id="<epic-id>",
  subject="[Track 1] COMPLETE",
  body_md="All beads done: <list>. Summary: ..."
)
```

**Via CLI:**
```bash
am send_message '{
  "project_key": "<path>",
  "sender_name": "BlueLake",
  "to": ["<OrchestratorName>"],
  "thread_id": "<epic-id>",
  "subject": "[Track 1] COMPLETE",
  "body_md": "All beads done: <list>. Summary: ..."
}'
```

Return a summary of all work completed.
"""
)

# Spawn Track 2 Worker (parallel)
Task(
  description="Worker GreenCastle: Track 2 - <track-description>",
  prompt="""
... (same structure, different track/beads/scope) ...
"""
)

# Spawn Track 3 Worker (parallel)
Task(
  description="Worker RedStone: Track 3 - <track-description>",
  prompt="""
... (same structure, different track/beads/scope) ...
"""
)
```

---

## Phase 4: Monitor Progress

While workers execute, monitor via:

### Check Epic Thread for Updates

**Via MCP:**
```python
search_messages(
  project_key="<path>",
  query="<epic-id>",
  limit=20
)
```

**Via CLI:**
```bash
am search_messages '{"project_key": "<path>", "query": "<epic-id>", "limit": 20}'
```

### Check for Blockers

**Via MCP:**
```python
fetch_inbox(
  project_key="<path>",
  agent_name="<OrchestratorName>",
  urgent_only=true,
  include_bodies=true
)
```

**Via CLI:**
```bash
am fetch_inbox '{"project_key": "<path>", "agent_name": "<OrchestratorName>", "urgent_only": true, "include_bodies": true}'
```

### Check Bead Status

```bash
bv --robot-triage --graph-root <epic-id> 2>/dev/null | jq '.quick_ref'
```

---

## Phase 5: Handle Cross-Track Issues

### If Worker Reports Blocker

**Via MCP:**
```python
reply_message(
  message_id=<blocker-msg-id>,
  body_md="Resolution: ..."
)
```

**Via CLI:**
```bash
am reply_message '{"project_key": "<path>", "message_id": <blocker-msg-id>, "sender_name": "<OrchestratorName>", "body_md": "Resolution: ..."}'
```

### If File Conflict

**Via MCP:**
```python
send_message(
  to=["<Holder>"],
  thread_id="<epic-id>",
  subject="File conflict resolution",
  body_md="<Worker> needs <files>. Can you release?"
)
```

**Via CLI:**
```bash
am send_message '{
  "project_key": "<path>",
  "sender_name": "<OrchestratorName>",
  "to": ["<Holder>"],
  "thread_id": "<epic-id>",
  "subject": "File conflict resolution",
  "body_md": "<Worker> needs <files>. Can you release?"
}'
```

---

## Phase 6: Epic Completion

When all workers report track complete:

### Verify All Done

```bash
bv --robot-triage --graph-root <epic-id> 2>/dev/null | jq '.quick_ref.open_count'
# Should be 0
```

### Send Completion Summary

**Via MCP:**
```python
send_message(
  to=["BlueLake", "GreenCastle", "RedStone"],
  thread_id="<epic-id>",
  subject="[<epic-id>] EPIC COMPLETE",
  body_md="""
## Epic Complete: <title>

### Track Summaries
- Track 1 (BlueLake): <summary>
- Track 2 (GreenCastle): <summary>
- Track 3 (RedStone): <summary>

### Deliverables
- <what was built>

### Learnings
- <key insights>
"""
)
```

**Via CLI:**
```bash
am send_message '{
  "project_key": "<path>",
  "sender_name": "<OrchestratorName>",
  "to": ["BlueLake", "GreenCastle", "RedStone"],
  "thread_id": "<epic-id>",
  "subject": "[<epic-id>] EPIC COMPLETE",
  "body_md": "## Epic Complete\\n\\n### Track Summaries\\n- Track 1: ...\\n- Track 2: ...\\n- Track 3: ..."
}'
```

### Close Epic

```bash
bd close <epic-id> --reason "All tracks complete"
```

---

## Worker Prompt Template

Use this template when spawning workers:

```
You are agent {AGENT_NAME} working on Track {N} of epic {EPIC_ID}.

## Setup
1. Read {PROJECT_PATH}/AGENTS.md for tool preferences
2. Load the worker skill

## Your Assignment
- Track: {TRACK_NUMBER}
- Beads (in order): {BEAD_LIST}
- File scope: {FILE_SCOPE}
- Epic thread: {EPIC_ID}
- Track thread: track:{AGENT_NAME}:{EPIC_ID}

## Agent Mail Access
You can use either MCP tools or CLI:
- MCP: Direct tool calls like `send_message(...)`, `fetch_inbox(...)`
- CLI: `am <command> '<json_args>'` via Bash tool

## Protocol
For EACH bead in your track:

1. START BEAD
   - Register: `am register_agent '{"project_key": "{PROJECT_PATH}", "name": "{AGENT_NAME}", ...}'`
   - Read context: `am summarize_thread '{"project_key": "{PROJECT_PATH}", "thread_id": "track:{AGENT_NAME}:{EPIC_ID}"}'`
   - Reserve files: `am file_reservation_paths '{"project_key": "{PROJECT_PATH}", "agent_name": "{AGENT_NAME}", "paths": ["{FILE_SCOPE}"], "reason": "{BEAD_ID}", "ttl_seconds": 3600, "exclusive": true}'`
   - Claim: bd update {BEAD_ID} --status in_progress

2. WORK
   - Implement the bead requirements
   - Use preferred tools from AGENTS.md
   - Check inbox: `am fetch_inbox '{"project_key": "{PROJECT_PATH}", "agent_name": "{AGENT_NAME}", "include_bodies": true}'`

3. COMPLETE BEAD
   - bd close {BEAD_ID} --reason "..."
   - Report: `am send_message '{"project_key": "{PROJECT_PATH}", "sender_name": "{AGENT_NAME}", "to": ["{ORCHESTRATOR}"], "thread_id": "{EPIC_ID}", "subject": "[{BEAD_ID}] COMPLETE", "body_md": "..."}'`
   - Save context: `am send_message '{"project_key": "{PROJECT_PATH}", "sender_name": "{AGENT_NAME}", "to": ["{AGENT_NAME}"], "thread_id": "track:{AGENT_NAME}:{EPIC_ID}", ...}'`
   - Release: `am release_file_reservations '{"project_key": "{PROJECT_PATH}", "agent_name": "{AGENT_NAME}"}'`

4. NEXT BEAD
   - Read track thread for context
   - Continue with next bead

## When Track Complete
- `am send_message '{"...", "subject": "[Track {N}] COMPLETE", ...}'`
- Return summary of all work

## Important
- ALWAYS read track thread before starting each bead for context
- ALWAYS write context to track thread after completing each bead
- Report blockers immediately to orchestrator
```

---

## CLI Quick Reference

| Action | CLI Command |
|--------|-------------|
| Ensure project | `am ensure_project '{"human_key": "<path>"}'` |
| Register agent | `am register_agent '{"project_key": "<path>", "name": "Agent", "program": "amp", "model": "claude", "task_description": "..."}'` |
| Send message | `am send_message '{"project_key": "<path>", "sender_name": "Agent", "to": ["Other"], "subject": "...", "body_md": "..."}'` |
| Fetch inbox | `am fetch_inbox '{"project_key": "<path>", "agent_name": "Agent", "include_bodies": true}'` |
| Search messages | `am search_messages '{"project_key": "<path>", "query": "keyword", "limit": 20}'` |
| Summarize thread | `am summarize_thread '{"project_key": "<path>", "thread_id": "thread-id"}'` |
| Reserve files | `am file_reservation_paths '{"project_key": "<path>", "agent_name": "Agent", "paths": ["src/**"], "ttl_seconds": 3600, "exclusive": true, "reason": "..."}'` |
| Release files | `am release_file_reservations '{"project_key": "<path>", "agent_name": "Agent"}'` |
| Reply message | `am reply_message '{"project_key": "<path>", "message_id": 123, "sender_name": "Agent", "body_md": "..."}'` |
| Health check | `am health_check '{}'` |

---

## Quick Reference

| Phase      | Action                                        |
| ---------- | --------------------------------------------- |
| Read Plan  | `Read("history/<feature>/execution-plan.md")` |
| Initialize | `am ensure_project`, `am register_agent`      |
| Spawn      | `Task()` for each track (parallel)            |
| Monitor    | `am fetch_inbox`, `am search_messages`        |
| Resolve    | `am reply_message` for blockers               |
| Complete   | Verify all done, send summary, close epic     |
