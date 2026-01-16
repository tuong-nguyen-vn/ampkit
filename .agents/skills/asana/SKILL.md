---
name: asana
description: Integrate with Asana for task management. Use when user references Asana task IDs, asks to read/update/create Asana tasks, sync task status, fetch task details, search tasks, list projects, or manage subtasks. Supports full CRUD operations on tasks and projects.
version: 1.1.0
---

# Asana Integration

Interact with Asana API for complete task management.

## Setup

1. Get Personal Access Token from https://app.asana.com/0/developer-console
2. Create `.env` file in this skill folder: `ASANA_PAT=your_token`

## Commands

### Tasks
```bash
python3 scripts/asana_api.py get-task <task_id>
python3 scripts/asana_api.py complete-task <task_id>
python3 scripts/asana_api.py incomplete-task <task_id>
python3 scripts/asana_api.py update-task <task_id> name "New name"
python3 scripts/asana_api.py update-task <task_id> notes "Description"
python3 scripts/asana_api.py update-task <task_id> due_on 2025-01-20
python3 scripts/asana_api.py assign-task <task_id> <user_gid>
python3 scripts/asana_api.py unassign-task <task_id>
python3 scripts/asana_api.py add-comment <task_id> "Comment text"
python3 scripts/asana_api.py create-task <project_id> "Task name"
```

### Subtasks
```bash
python3 scripts/asana_api.py get-subtasks <task_id>
python3 scripts/asana_api.py create-subtask <parent_task_id> "Subtask name"
```

### Projects & Search
```bash
python3 scripts/asana_api.py list-tasks <project_id>
python3 scripts/asana_api.py list-projects [workspace_id]
python3 scripts/asana_api.py search <workspace_id> "query"
```

### Users
```bash
python3 scripts/asana_api.py me
python3 scripts/asana_api.py list-users [workspace_id]
```

## Task ID Format

Extract from URL: `https://app.asana.com/0/PROJECT_ID/TASK_ID`
Or branch names: `feat/1212812747582922`

## References

- [API Reference](references/api_reference.md)
