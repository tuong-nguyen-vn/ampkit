#!/bin/bash
# Initialize a new ETA project folder
# Usage: ./init-eta-project.sh <project-slug>

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <project-slug>"
    echo "Example: $0 aicre-om-engine"
    exit 1
fi

PROJECT_SLUG="$1"
DATE_PREFIX=$(date +%Y%m%d)
PROJECT_DIR="plans/${DATE_PREFIX}-${PROJECT_SLUG}"

# Create directory structure
mkdir -p "${PROJECT_DIR}"

echo "Creating ETA project: ${PROJECT_DIR}"

# Create phase files
cat > "${PROJECT_DIR}/00-input.md" << 'EOF'
# Input: [Project Name]

**Source**: [filename or URL]
**Extracted**: [date]

---

## Raw Content

[Paste or extract content here]

---

## Key Points Identified

1. 
2. 
3. 

## Attachments Referenced

- [ ] 
- [ ] 

---

*Extracted by: ETA Architect*
EOF

cat > "${PROJECT_DIR}/01-clarify.md" << 'EOF'
# Clarifications: [Project Name]

## Questions & Answers

| # | Question | Answer | Impact on ETA |
|---|----------|--------|---------------|
| 1 | Tech stack? | | |
| 2 | Timeline? | | |
| 3 | Team size? | | |
| 4 | MVP or full? | | |
| 5 | Integrations? | | |

## Assumptions Made

1. 
2. 
3. 

## User Confirmation

- [ ] Confirmed by user on [date]

---

*Phase 1 complete*
EOF

cat > "${PROJECT_DIR}/02-research.md" << 'EOF'
# Research: [Project Name]

## Technology Evaluation

### Backend

| Option | Pros | Cons | Effort |
|--------|------|------|--------|
| | | | |
| | | | |

**Decision**: 

### Frontend

| Option | Pros | Cons | Effort |
|--------|------|------|--------|
| | | | |
| | | | |

**Decision**: 

### Database

| Option | Pros | Cons | Effort |
|--------|------|------|--------|
| | | | |
| | | | |

**Decision**: 

## External References

- [Link 1](url) - Summary
- [Link 2](url) - Summary

## Key Learnings

1. 
2. 
3. 

---

*Phase 2 complete*
EOF

cat > "${PROJECT_DIR}/03-scope.md" << 'EOF'
# Scope: [Project Name]

## ✅ In Scope

### Core Features

1. **Feature A** - Description
2. **Feature B** - Description
3. **Feature C** - Description

### Technical Requirements

1. 
2. 
3. 

## ❌ Out of Scope

| # | Feature | Reason | Phase |
|---|---------|--------|-------|
| 1 | | | Phase 2 |
| 2 | | | Future |

## ⚠️ Conditional

1. **[Feature]** - If [condition]

## Assumptions

1. Client provides [data/access]
2. Hosting on [platform]
3. No migration from [legacy system]

---

*Phase 3 complete*
EOF

cat > "${PROJECT_DIR}/04-estimation.md" << 'EOF'
# Estimation: [Project Name]

## Epic Breakdown

| Epic | Description | Hours | Resource | Priority |
|------|-------------|-------|----------|----------|
| E1 | | **h** | | P1 |
| E2 | | **h** | | P1 |
| E3 | | **h** | | P2 |
| E4 | | **h** | | P2 |
| **TOTAL** | | **h** | | |

---

## E1: [Epic Name] - h

| # | Task | Hours | Resource | Solution |
|---|------|-------|----------|----------|
| 1.1 | | **h** | | |
| 1.2 | | **h** | | |
| | **Epic Total** | **h** | | |

---

## E2: [Epic Name] - h

| # | Task | Hours | Resource | Solution |
|---|------|-------|----------|----------|
| 2.1 | | **h** | | |
| 2.2 | | **h** | | |
| | **Epic Total** | **h** | | |

---

## E3: [Epic Name] - h

| # | Task | Hours | Resource | Solution |
|---|------|-------|----------|----------|
| 3.1 | | **h** | | |
| 3.2 | | **h** | | |
| | **Epic Total** | **h** | | |

---

## E4: [Epic Name] - h

| # | Task | Hours | Resource | Solution |
|---|------|-------|----------|----------|
| 4.1 | | **h** | | |
| 4.2 | | **h** | | |
| | **Epic Total** | **h** | | |

---

## Resource Allocation

| Role | Hours | % |
|------|-------|---|
| Backend (BE) | h | % |
| Frontend (FE) | h | % |
| QA/Testing | h | % |
| DevOps | h | % |
| **Total** | **h** | 100% |

---

*Phase 4 complete*
EOF

cat > "${PROJECT_DIR}/05-risks.md" << 'EOF'
# Risks: [Project Name]

## Risk Register

| # | Risk | Impact | Likelihood | Mitigation | Buffer |
|---|------|--------|------------|------------|--------|
| R1 | | High/Med/Low | High/Med/Low | | +h |
| R2 | | | | | +h |
| R3 | | | | | +h |

## Buffer Calculation

| Type | Hours |
|------|-------|
| Base (15%) | +h |
| R1 adjustment | +h |
| R2 adjustment | +h |
| **Total Buffer** | **+h** |

## Final Hours

| Metric | Hours |
|--------|-------|
| Base estimate | h |
| Buffer | +h |
| **Total with buffer** | **h** |

## Open Questions

1. ❓ 
2. ❓ 
3. ❓ 

---

*Phase 5 complete*
EOF

# Create plan.md as index
cat > "${PROJECT_DIR}/plan.md" << EOF
---
title: "[Project Name]"
description: "[Brief description]"
status: in_progress
created: $(date +%Y-%m-%d)
---

# ETA: [Project Name]

## Overview

[Brief project description]

## Phases

| # | Phase | Status | File |
|---|-------|--------|------|
| 0 | Input Extraction | 🔴 | [00-input.md](./00-input.md) |
| 1 | Clarification | 🔴 | [01-clarify.md](./01-clarify.md) |
| 2 | Research | 🔴 | [02-research.md](./02-research.md) |
| 3 | Scope Definition | 🔴 | [03-scope.md](./03-scope.md) |
| 4 | Estimation | 🔴 | [04-estimation.md](./04-estimation.md) |
| 5 | Risk Assessment | 🔴 | [05-risks.md](./05-risks.md) |

**Legend:** 🔴 Not Started | 🟡 In Progress | 🟢 Complete

## Output

Final ETA report: \`docs/${DATE_PREFIX}-${PROJECT_SLUG}.md\`

---

*Created: $(date +%Y-%m-%d)*
EOF

echo ""
echo "✅ ETA project initialized: ${PROJECT_DIR}"
echo ""
echo "Files created:"
echo "  - ${PROJECT_DIR}/plan.md (index)"
echo "  - ${PROJECT_DIR}/00-input.md"
echo "  - ${PROJECT_DIR}/01-clarify.md"
echo "  - ${PROJECT_DIR}/02-research.md"
echo "  - ${PROJECT_DIR}/03-scope.md"
echo "  - ${PROJECT_DIR}/04-estimation.md"
echo "  - ${PROJECT_DIR}/05-risks.md"
echo ""
echo "Next steps:"
echo "  1. Extract input to 00-input.md"
echo "  2. Work through each phase"
echo "  3. Generate final report to docs/${DATE_PREFIX}-${PROJECT_SLUG}.md"
