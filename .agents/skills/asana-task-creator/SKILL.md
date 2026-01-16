# asana-task-creator Skill

Create well-formatted Asana tasks with standardized title format and description template. Works with any project.

## Task Title Format

```
[{Project}][{Platform}] {Task Title}
```

**Project:** Any project name (e.g., KingmakerData, MyApp, ClientX)

**Platform options:**
- `API` - Backend/API tasks
- `FE` - Frontend tasks
- `DevOps` - Infrastructure/deployment tasks
- `QA` - Testing tasks
- `Mobile` - Mobile app tasks
- `Design` - UI/UX design tasks
- `Docs` - Documentation tasks

**Examples:**
- `[KingmakerData][API] Champion Role & Model Setup`
- `[MyApp][FE] User Dashboard Redesign`
- `[ClientX][DevOps] CI/CD Pipeline Setup`

## Task Description Template

```markdown
**Implementation Detail:**

- {Bullet point 1}
- {Bullet point 2}
- {Bullet point 3}

**Testing Checklist:**

- [ ] {Test case 1}
- [ ] {Test case 2}
- [ ] {Test case 3}

**Files:**
- `{file_path_1}`
- `{file_path_2}`

**Dependencies:**
- {Dependency task or blocker}

**Estimate:** {X}h
```

## Usage

### Create Single Task

```bash
python3 scripts/create_task.py \
  --project-id "1201181129344871" \
  --project-name "KingmakerData" \
  --platform "API" \
  --title "Champion Role & Model Setup" \
  --details "Add CHAMPION to USER_ROLES|Create Champion proxy model|Add parent_candidate FK" \
  --tests "Verify Champion role exists|Verify Champion can be created" \
  --files "api/apps/users/choices.py|api/apps/users/models.py" \
  --estimate "4h"
```

### Create Subtask

```bash
python3 scripts/create_task.py \
  --parent-id "1212613149794163" \
  --project-name "KingmakerData" \
  --platform "API" \
  --title "Champion Create API" \
  --details "Endpoint tạo Champion|Generate default password|Send welcome email" \
  --tests "Verify Champion created|Verify email sent" \
  --estimate "5h"
```

### Batch Create from JSON

```bash
python3 scripts/batch_create_tasks.py \
  --input tasks.json \
  --parent-id "1212613149794163"
```

**tasks.json format:**
```json
{
  "project_name": "KingmakerData",
  "parent_id": "1212613149794163",
  "subtasks": [
    {
      "platform": "API",
      "title": "Champion Role & Model Setup",
      "details": ["Add CHAMPION to USER_ROLES", "Create Champion proxy model"],
      "tests": ["Verify Champion role exists", "Verify model fields correct"],
      "files": ["api/apps/users/choices.py", "api/apps/users/models.py"],
      "dependencies": ["None"],
      "estimate": "4h"
    }
  ]
}
```

### Dry Run (Preview)

```bash
python3 scripts/batch_create_tasks.py --input tasks.json --parent-id "123" --dry-run
```

## Script Location

All scripts are in `scripts/` directory:
- `create_task.py` - Create single task/subtask
- `batch_create_tasks.py` - Batch create from JSON file

## Templates

Example templates in `templates/` directory for reference.

Base directory for this skill: file:///home/canhnguyen/.claude/skills/asana-task-creator
