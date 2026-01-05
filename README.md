# AmpKit

Bộ công cụ Skills cho AI Agent sử dụng [Amp](https://ampcode.com). Tập trung vào workflow planning và multi-agent orchestration với Beads task management system.

## 📦 Cài đặt

### Yêu cầu hệ thống

- **macOS** hoặc **Linux**
- **Python** >= 3.14
- **Git**
- **Homebrew** (macOS)

### 1. Cài đặt Beads

[Beads](https://github.com/steveyegge/beads) - Distributed, git-backed graph issue tracker cho AI agents.

```bash
# macOS
brew install steveyegge/beads/bd

# Linux/macOS (script)
curl -fsSL https://raw.githubusercontent.com/steveyegge/beads/main/scripts/install.sh | bash
```

Khởi tạo trong project:
```bash
bd init
```

### 2. Cài đặt Beads Viewer

[Beads Viewer (bv)](https://github.com/Dicklesworthstone/beads_viewer) - Terminal UI cho Beads với graph analytics, AI robot mode.

```bash
curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/beads_viewer/main/install.sh" | bash
```

Verify:
```bash
bv --version
```

### 3. Cài đặt MCP Agent Mail

[MCP Agent Mail](https://github.com/tuong-nguyen-vn/mcp_agent_mail) - Hệ thống messaging cho multi-agent coordination.

#### Cài đặt Python 3.14+

```bash
# macOS
brew install python@3.14

# Ubuntu/Debian
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install python3.14 python3.14-venv
```

#### Cài đặt uv package manager

```bash
# Script
curl -LsSf https://astral.sh/uv/install.sh | sh

# Hoặc Homebrew
brew install uv
```

#### Clone và setup

```bash
git clone https://github.com/tuong-nguyen-vn/mcp_agent_mail.git
cd mcp_agent_mail

# Tạo virtual environment
uv venv --python python3.14

# Activate
source .venv/bin/activate

# Cài dependencies
uv pip install -e .
```

#### Cài đặt global (chọn 1 trong 3)

**Option 1: Symlink (khuyến nghị)**
```bash
sudo ln -sf /path/to/mcp_agent_mail/.venv/bin/am /usr/local/bin/am
```

**Option 2: Add vào PATH**
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

## 🎯 Sử dụng với Amp

### Cài Skills vào Amp

Copy thư mục `skills/` vào config của Amp:

```bash
cp -r skills/* ~/.config/amp/skills/
```

### Các Skills có sẵn

| Skill | Mô tả |
|-------|-------|
| `planning` | Pipeline lập kế hoạch feature: Discovery → Synthesis → Verification → Decomposition → Track Planning |
| `file-beads` | Chuyển đổi plan thành Beads epics và issues với dependencies |
| `orchestrator` | Điều phối multi-agent bead execution |

### Workflow cơ bản

1. **Plan feature mới**
   ```
   @amp: Load skill planning và lập kế hoạch cho feature authentication
   ```

2. **Xem beads**
   ```bash
   bv                           # TUI interactive
   bv --robot-triage           # AI-friendly output
   bv --robot-plan             # Parallel execution tracks
   ```

3. **Multi-agent execution**
   ```
   @amp: Load skill orchestrator để bắt đầu execution
   ```

## 📚 Commands Reference

### Beads (bd)

```bash
bd ready                    # List tasks không bị block
bd create "Title" -p 0      # Tạo P0 task
bd dep add <child> <parent> # Link dependencies
bd show <id>                # Xem chi tiết task
bd close <id>               # Đóng task
```

### Beads Viewer (bv)

```bash
# TUI Mode
bv                          # Mở interactive viewer

# Robot Mode (cho AI agents)
bv --robot-triage           # Recommendations với scores
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
am ensure_project '{"project": "my-project"}'  # Tạo project
am register_agent '{"agent_id": "agent-1", "project": "my-project"}'
am send_message '{"from": "agent-1", "to": "agent-2", "subject": "...", "body": "..."}'
am fetch_inbox '{"agent_id": "agent-2"}'
```

## 📄 License

MIT
