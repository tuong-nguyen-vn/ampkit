# AmpKit

A Skills toolkit for AI Agents using [Amp](https://ampcode.com). Focused on workflow planning and multi-agent orchestration with Beads task management system.

## 📦 Installation

### System Requirements

- **macOS** or **Linux**
- **Python** >= 3.14
- **Git**
- **Homebrew** (macOS)

### 1. Install Beads

[Beads](https://github.com/steveyegge/beads) - Distributed, git-backed graph issue tracker for AI agents.

```bash
# macOS
brew install steveyegge/beads/bd

# Linux/macOS (script)
curl -fsSL https://raw.githubusercontent.com/steveyegge/beads/main/scripts/install.sh | bash
```

Initialize in your project:
```bash
bd init
```

### 2. Install Beads Viewer

[Beads Viewer (bv)](https://github.com/Dicklesworthstone/beads_viewer) - Terminal UI for Beads with graph analytics and AI robot mode.

```bash
curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/beads_viewer/main/install.sh" | bash
```

Verify:
```bash
bv --version
```

### 3. Install MCP Agent Mail

[MCP Agent Mail](https://github.com/tuong-nguyen-vn/mcp_agent_mail) - Messaging system for multi-agent coordination.

#### Install Python 3.14+

```bash
# macOS
brew install python@3.14

# Ubuntu/Debian
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install python3.14 python3.14-venv
```

#### Install uv package manager

```bash
# Script
curl -LsSf https://astral.sh/uv/install.sh | sh

# Or Homebrew
brew install uv
```

#### Clone and setup

```bash
git clone https://github.com/tuong-nguyen-vn/mcp_agent_mail.git
cd mcp_agent_mail

# Create virtual environment
uv venv --python python3.14

# Activate
source .venv/bin/activate

# Install dependencies
uv pip install -e .
```

#### Global installation (choose 1 of 3)

**Option 1: Symlink (recommended)**
```bash
sudo ln -sf /path/to/mcp_agent_mail/.venv/bin/am /usr/local/bin/am
```

**Option 2: Add to PATH**
```bash
echo 'export PATH="/path/to/mcp_agent_mail/.venv/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

**Option 3: Shell alias**
```bash
echo 'alias am="/path/to/mcp_agent_mail/.venv/bin/am"' >> ~/.zshrc
source ~/.zshrc
```

#### Verify
```bash
am --help
```

## 🎯 Usage with Amp

### Install Skills to Amp

Copy the `skills/` directory to Amp config:

```bash
cp -r skills/* ~/.config/amp/skills/
```

### Available Skills

| Skill | Description |
|-------|-------------|
| `planning` | Feature planning pipeline: Discovery → Synthesis → Verification → Decomposition → Track Planning |
| `file-beads` | Convert plans into Beads epics and issues with dependencies |
| `orchestrator` | Coordinate multi-agent bead execution |

### Basic Workflow

1. **Plan a new feature**
   ```
   @amp: Load skill planning and create a plan for authentication feature
   ```

2. **View beads**
   ```bash
   bv                           # TUI interactive
   bv --robot-triage           # AI-friendly output
   bv --robot-plan             # Parallel execution tracks
   ```

3. **Multi-agent execution**
   ```
   @amp: Load skill orchestrator to start execution
   ```

## 📚 Commands Reference

### Beads (bd)

```bash
bd ready                    # List unblocked tasks
bd create "Title" -p 0      # Create P0 task
bd dep add <child> <parent> # Link dependencies
bd show <id>                # View task details
bd close <id>               # Close task
```

### Beads Viewer (bv)

```bash
# TUI Mode
bv                          # Open interactive viewer

# Robot Mode (for AI agents)
bv --robot-triage           # Recommendations with scores
bv --robot-plan             # Parallel execution tracks
bv --robot-insights         # Graph metrics
bv --robot-next             # Single next pick

# Export
bv --export-md              # Export Markdown
bv --export-graph out.html  # Interactive HTML graph
```

### Agent Mail (am)

```bash
am health_check '{}'                    # Check system
am ensure_project '{"project": "my-project"}'  # Create project
am register_agent '{"agent_id": "agent-1", "project": "my-project"}'
am send_message '{"from": "agent-1", "to": "agent-2", "subject": "...", "body": "..."}'
am fetch_inbox '{"agent_id": "agent-2"}'
```

## 📄 License

MIT
