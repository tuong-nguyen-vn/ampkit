---
name: eta-estimation
description: Create quick ballpark ETA reports for bidding. Use when estimating effort to win bids - focuses on solution approach and rough hours, NOT detailed task breakdowns. Target < 30 minutes per estimate.
---

# Ballpark ETA Skill

Fast, competitive estimates for winning bids. Solution-focused, not code-focused.

## Mission

```
┌─────────────────────────────────────────────────────────────────┐
│  🎯 GOAL: Quick estimate to WIN BIDS                            │
│                                                                 │
│  ✅ Research → Solution → Rough Hours → Cost Range              │
│  ❌ NOT: Detailed tasks, coding specs, exact hours              │
│                                                                 │
│  ⏱️ TARGET: < 30 minutes per estimate                           │
└─────────────────────────────────────────────────────────────────┘
```

---

## Workflow (5 Phases, ~35 min total)

```
📥 Phase 0: Extract & Analyze (5 min)
    ↓
❓ Phase 1: Clarification Questions (5 min)  ← ASK BEFORE ESTIMATE
    ↓
🔬 Phase 2: Research & Solution (15 min) ← MAIN FOCUS
    ↓
🧮 Phase 3: Ballpark Numbers (5 min)
    ↓
📄 Phase 4: Generate Report (5 min)
```

---

## Phase 0: Extract & Analyze (5 min)

### Step 0.1: Collect All Assets (Iterative)

**IMPORTANT:** Ask for assets repeatedly until user confirms "done" or "no more".

```
Loop:
  → "Do you have any additional assets? (PDF, images, mockups, docs, etc.)"
  → User provides asset OR confirms "no more"
  → If asset provided: process & ask again
  → If "no more": proceed to Step 0.2
```

**Ask template:**
```
I've received [X]. Do you have any additional assets to share?
- 📄 PDF/Word documents (SOW, specs, requirements)
- 🖼️ Images/Screenshots (mockups, designs, wireframes)
- 📝 Markdown/Text files (notes, user stories)
- 🔗 URLs (Figma, existing site, references)

Reply "done" or "no more" when you've shared everything.
```

### Step 0.2: Process & Cache Assets

For each asset, extract key info and cache to Agent Mail for context management:

| Input Type | Tool | Cache Strategy |
|------------|------|----------------|
| PDF | `skill("ai-multimodal")` | Extract summary → cache to AM |
| Image/Screenshot | `skill("ai-multimodal")` | Describe features → cache to AM |
| Text/Markdown | `Read` | Scan scope → cache key points |
| URL | `read_web_page` | Pull relevant sections → cache |

**Cache to Agent Mail** (prevents context overflow):

```bash
am send_message \
  --sender-name "ETAArchitect" \
  --to '["ETAArchitect"]' \
  --thread-id "eta:<project-slug>" \
  --subject "[ASSET] <asset-name>" \
  --body-md "<extracted summary from asset>"
```

### Step 0.3: Consolidate Requirements

Save consolidated input to `00-input.md`:

```markdown
# Input: <Project Name>

## Assets Received

| # | Type | Name | Summary |
|---|------|------|---------|
| 1 | PDF | requirements.pdf | Main SOW with 15 features |
| 2 | Image | mockup-dashboard.png | Dashboard with 4 widgets |
| 3 | Image | mockup-settings.png | Settings page layout |

## Key Requirements (extracted)

- Requirement 1
- Requirement 2
- Requirement 3

## Screens/Pages Identified

- [ ] Dashboard
- [ ] Settings
- [ ] ...

## Unknowns

- ?
- ?
```

### Quick Extraction (per asset type)

| Input Type | Tool | Action |
|------------|------|--------|
| PDF | `skill("ai-multimodal")` | Extract key requirements only |
| Image/Screenshot | `skill("ai-multimodal")` | Describe main features |
| Text/Markdown | `Read` | Scan for scope |
| URL | `read_web_page` | Pull relevant sections |

### Save to Project Folder

```bash
mkdir -p plans/$(date +%Y%m%d)-<project-slug>
```

---

## Phase 1: Clarification Questions (5 min)

**CRITICAL:** Ask questions BEFORE estimating to avoid scope creep and missed requirements.

### Analyze & Identify Gaps

After extracting requirements, analyze:

| Check | Look For |
|-------|----------|
| **Assets** | Are mockups/designs complete? Missing screens? |
| **Integrations** | Which third-party APIs? Auth providers? |
| **Data** | Data migration needed? Volume expectations? |
| **Users** | User roles? Permissions complexity? |
| **Platform** | Web only? Mobile? Responsive requirements? |
| **Timeline** | Hard deadline? Phased delivery? |

### Question Categories

Save to `00-clarifications.md`:

```markdown
# Clarification Questions: <Project Name>

## 🔴 Blockers (Must answer before estimate)

1. [Question that significantly affects scope/hours]
2. [Missing critical information]

## 🟡 Important (Affects estimate accuracy)

1. [Question about unclear requirement]
2. [Integration/API details needed]

## 🟢 Nice to Know (Won't block estimate)

1. [Preference questions]
2. [Future phase considerations]

## 📊 Impact on ETA

| Question | If Yes | If No |
|----------|--------|-------|
| Need mobile app? | +40-60h | - |
| Data migration? | +16-24h | - |
| Multi-language? | +20-30h | - |
```

### Example Questions by Domain

| Domain | Common Questions |
|--------|------------------|
| **Auth** | SSO required? Which providers? 2FA/MFA? |
| **Payments** | Which gateway? Subscription billing? Refunds? |
| **Data** | Expected volume? Real-time sync? Offline mode? |
| **UI/UX** | Design provided? Design system exists? Responsive? |
| **Integrations** | API docs available? Rate limits? Sandbox access? |

---

## Phase 2: Research & Solution (15 min) ← MAIN FOCUS

This is where you spend most time. Answer: **"How would we build this?"**

### Quick Research

| Need | Tool | Time |
|------|------|------|
| Similar projects | `web_search` | 3 min |
| Tech options | `web_search` | 3 min |
| Library docs | `skill("docs-seeker")` | 3 min |
| Architecture | `oracle` | 5 min |

### Solution Approach Template

Save to `01-research.md`:

```markdown
# Solution: <Project Name>

## Recommended Stack

| Layer | Choice | Why |
|-------|--------|-----|
| Backend | Node.js/Python/etc | [1 sentence] |
| Frontend | React/Vue/etc | [1 sentence] |
| Database | PostgreSQL/MongoDB | [1 sentence] |
| Hosting | AWS/Vercel/etc | [1 sentence] |

## Architecture (1 paragraph)

[How the pieces fit together. 3-5 sentences max.]

## Key Technical Decisions

1. **[Decision 1]**: [Approach] - [Why]
2. **[Decision 2]**: [Approach] - [Why]

## Alternatives Considered

| Option | Pros | Cons | Verdict |
|--------|------|------|---------|
| A | ... | ... | ✅ Selected |
| B | ... | ... | ❌ More complex |
```

---

## Phase 3: Ballpark Estimate (5 min)

### Epic-Level Sizing (NO task breakdown)

| Size | Hours Range | Examples |
|------|-------------|----------|
| **S** | 8-16h | Simple CRUD, basic UI, config |
| **M** | 16-40h | Auth, dashboard, standard API |
| **L** | 40-80h | Complex integration, AI features |
| **XL** | 80-160h | Full module, major subsystem |

### Quick Estimation

Save to `02-estimate.md`:

```markdown
# Estimate: <Project Name>

## ETA Breakdown

### E1: Authentication & Onboarding (24-32h)

| User Story | Task | Hours | Resource |
|------------|------|-------|----------|
| US1.1: As a user, I want to login | Setup auth module | 4h | BE |
| | Login API endpoint | 4h | BE |
| | Login UI form | 4h | FE |
| US1.2: As a user, I want to register | Register API | 4h | BE |
| | Register form | 4h | FE |
| | Email verification | 4-8h | BE |

### E2: Core Dashboard (48-64h)

| User Story | Task | Hours | Resource |
|------------|------|-------|----------|
| US2.1: As a user, I want to see overview | Dashboard layout | 8h | FE |
| | Data APIs | 8h | BE |
| US2.2: As a user, I want analytics | Charts components | 8h | FE |
| | Analytics API | 8-12h | BE |
| | Real-time updates | 16h | FS |

### E3: API Integrations (24-32h)

| User Story | Task | Hours | Resource |
|------------|------|-------|----------|
| US3.1: As a system, I need external data | Third-party API setup | 8h | BE |
| | Data sync service | 8-12h | BE |
| | Error handling | 8h | BE |

### E4: Admin & Settings (12-16h)

| User Story | Task | Hours | Resource |
|------------|------|-------|----------|
| US4.1: As admin, I want to manage users | User management UI | 4h | FE |
| | Admin APIs | 4h | BE |
| US4.2: As a user, I want to configure | Settings page | 4-8h | FS |

### E5: Testing & Polish (16-24h)

| User Story | Task | Hours | Resource |
|------------|------|-------|----------|
| US5.1: As QA, I need quality | Integration tests | 8h | BE |
| | E2E tests | 4-8h | FE |
| | Bug fixes & polish | 4-8h | FS |

---

## Summary

| Metric | Min | Max |
|--------|-----|-----|
| Base Hours | 124h | 168h |
| Buffer (20%) | +25h | +34h |
| **Total Hours** | **149h** | **202h** |
| Duration (1 dev) | 3.7 weeks | 5 weeks |
| Duration (2 devs) | 2 weeks | 2.5 weeks |

## Cost Estimate

| Rate | Min | Max |
|------|-----|-----|
| $100/hr | $14,900 | $20,200 |
| $125/hr | $18,625 | $25,250 |
| $150/hr | $22,350 | $30,300 |

## Resource Allocation

| Resource | Hours | % |
|----------|-------|---|
| BE | 80-100h | ~55% |
| FE | 40-56h | ~30% |
| FS | 24-46h | ~15% |
```

### Formula

```
Total = Σ(Epic hours) × 1.2 (buffer)
Duration = Total ÷ 40h/week
Cost = Total × rate
```

---

## Phase 4: Generate Report (5 min)

### Compile Final Ballpark ETA

Save to `docs/{YYYYMMDD-prj}.md`:

```markdown
# Ballpark ETA: [Project Name]

**Date:** YYYY-MM-DD
**Type:** Ballpark Estimate (for bidding)

---

## Solution Approach

[2-3 paragraphs describing recommended tech stack and architecture]

### Tech Stack

| Layer | Choice |
|-------|--------|
| Backend | ... |
| Frontend | ... |
| Database | ... |

---

## Effort Estimate

### E1: [Epic Name] (24-32h)

| User Story | Task | Hours | Resource |
|------------|------|-------|----------|
| US1.1: As a user, I want to... | Task title | 4h | BE |
| | Task title | 4h | BE |
| | Task title | 4h | FE |

### E2: [Epic Name] (48-64h)

| User Story | Task | Hours | Resource |
|------------|------|-------|----------|
| US2.1: As a user, I want to... | Task title | 8h | FE |
| | Task title | 8h | BE |

(Continue for all epics...)

---

## Summary

| Metric | Range |
|--------|-------|
| **Total Hours** | **150-200h** |
| **Duration** | **4-5 weeks** (1 dev) |
| **Cost** | **$18,000 - $25,000** |

### Resource Allocation

| Resource | Hours | % |
|----------|-------|---|
| BE | X-Xh | ~XX% |
| FE | X-Xh | ~XX% |
| FS | X-Xh | ~XX% |

---

## Key Risks

1. [Risk 1] - [Mitigation]
2. [Risk 2] - [Mitigation]
3. [Risk 3] - [Mitigation]

---

## Assumptions

1. Client provides [X]
2. Standard [Y] requirements
3. No [Z] complexity

---

## Open Questions

1. ❓ [Question needing client input]
2. ❓ [Question affecting scope]

---

## Next Steps

1. Client review & feedback
2. Scope confirmation
3. Contract & kickoff

---

*Ballpark estimate for bidding purposes. Detailed planning after project confirmation.*
```

---

## Quick Reference

### Time Budget

| Phase | Max Time |
|-------|----------|
| Extract | 5 min |
| Research | 15 min |
| Estimate | 5 min |
| Report | 5 min |
| **Total** | **30 min** |

### Epic Sizing Cheat Sheet

| Epic Type | Size | Hours |
|-----------|------|-------|
| Auth/Login | M | 24-32h |
| Dashboard | L | 48-64h |
| CRUD module | M | 20-30h |
| API integration | M-L | 24-48h |
| Payment | L | 40-60h |
| AI/ML feature | L-XL | 60-120h |
| Admin panel | M | 20-32h |
| Reports/Export | S-M | 12-24h |
| Testing | M | 16-24h |

### Cost Quick Calc

| Hours | $100/hr | $125/hr | $150/hr |
|-------|---------|---------|---------|
| 100h | $10,000 | $12,500 | $15,000 |
| 150h | $15,000 | $18,750 | $22,500 |
| 200h | $20,000 | $25,000 | $30,000 |
| 300h | $30,000 | $37,500 | $45,000 |

---

## DO NOT (Time Killers)

- ❌ Over-detailed task breakdown (sub-sub-tasks)
- ❌ Exact hour counts (use ranges like 4-8h)
- ❌ Code specifications
- ❌ Database schemas
- ❌ API endpoint lists
- ❌ Over-research (15 min max)
- ❌ Multiple revision rounds

---

## Principles

1. **Speed wins bids** - First reasonable estimate often wins
2. **Ranges are honest** - "100-140h" better than "120h"
3. **Solution sells** - Show you understand HOW to build it
4. **Risks show expertise** - Calling out risks builds trust
5. **20% buffer always** - Never bid without buffer

---

*Ballpark ETA = Win the bid first. Detailed planning comes after.*
