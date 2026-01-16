# Agent Mail Message Templates for ETA

## Thread Naming Convention

| Thread Type | Format | Example |
|-------------|--------|---------|
| ETA Project | `eta:<project-slug>` | `eta:aicre-om-engine` |
| Phase-specific | `eta:<project-slug>:phase-<N>` | `eta:aicre-om-engine:phase-2` |

---

## Message Templates

### 1. Input Extraction Complete

**When**: After extracting content from PDF/image/document

```bash
am send_message \
  --project-key "<project-path>" \
  --sender-name "ETAArchitect" \
  --to '["ETAArchitect"]' \
  --thread-id "eta:<project-slug>" \
  --subject "[INPUT] <project-slug> - Requirements extracted" \
  --body-md "## Source
- File: <filename>
- Type: PDF/Image/Document
- Pages: X

## Key Requirements Identified

1. <requirement 1>
2. <requirement 2>
3. <requirement 3>

## Attachments Referenced

- [ ] <attachment 1>
- [ ] <attachment 2>

## Next Phase

Proceeding to clarification."
```

### 2. Clarification Complete

**When**: After user answers clarifying questions

```bash
am send_message \
  --project-key "<project-path>" \
  --sender-name "ETAArchitect" \
  --to '["ETAArchitect"]' \
  --thread-id "eta:<project-slug>" \
  --subject "[CLARIFY] <project-slug> - Questions resolved" \
  --body-md "## Clarifications Received

| Question | Answer |
|----------|--------|
| Tech stack? | React + Node |
| Timeline? | 2 months |
| Team size? | 2 developers |

## Assumptions Confirmed

1. <assumption 1>
2. <assumption 2>

## Next Phase

Proceeding to research."
```

### 3. Research Complete

**When**: After researching solutions and alternatives

```bash
am send_message \
  --project-key "<project-path>" \
  --sender-name "ETAArchitect" \
  --to '["ETAArchitect"]' \
  --thread-id "eta:<project-slug>" \
  --subject "[RESEARCH] <project-slug> - Solutions evaluated" \
  --body-md "## Technology Decisions

| Component | Choice | Reason |
|-----------|--------|--------|
| Backend | Node.js | Team expertise |
| Frontend | React | Client preference |
| Database | PostgreSQL | Relational data |

## Key Findings

1. <finding 1>
2. <finding 2>

## References

- [Link 1](url)
- [Link 2](url)

## Next Phase

Proceeding to scope definition."
```

### 4. Scope Defined

**When**: After defining in/out scope

```bash
am send_message \
  --project-key "<project-path>" \
  --sender-name "ETAArchitect" \
  --to '["ETAArchitect"]' \
  --thread-id "eta:<project-slug>" \
  --subject "[SCOPE] <project-slug> - Boundaries defined" \
  --body-md "## In Scope (X features)

1. Feature A
2. Feature B
3. Feature C

## Out of Scope (X items)

1. Feature X (Phase 2)
2. Feature Y (Budget)

## Assumptions (X items)

1. Assumption 1
2. Assumption 2

## Next Phase

Proceeding to estimation."
```

### 5. Estimation Complete

**When**: After creating epic/task breakdown

```bash
am send_message \
  --project-key "<project-path>" \
  --sender-name "ETAArchitect" \
  --to '["ETAArchitect"]' \
  --thread-id "eta:<project-slug>" \
  --subject "[ESTIMATE] <project-slug> - Hours calculated" \
  --body-md "## Epic Summary

| Epic | Hours | Resource |
|------|-------|----------|
| E1: Auth | 24h | BE |
| E2: Dashboard | 40h | FE |
| E3: API | 32h | BE |
| **Total** | **96h** | |

## Resource Breakdown

- Backend: 56h (58%)
- Frontend: 40h (42%)

## Next Phase

Proceeding to risk assessment."
```

### 6. Risks Assessed

**When**: After identifying risks and calculating buffer

```bash
am send_message \
  --project-key "<project-path>" \
  --sender-name "ETAArchitect" \
  --to '["ETAArchitect"]' \
  --thread-id "eta:<project-slug>" \
  --subject "[RISKS] <project-slug> - Buffer calculated" \
  --body-md "## Risk Summary

| Risk | Impact | Buffer |
|------|--------|--------|
| R1: API changes | High | +8h |
| R2: Scope creep | High | +16h |

## Buffer Calculation

- Base (15%): +14h
- Risk-specific: +24h
- **Total Buffer**: +38h

## Final Hours

- Base: 96h
- With Buffer: **134h**

## Next Phase

Compiling final report."
```

### 7. ETA Complete

**When**: After generating final report

```bash
am send_message \
  --project-key "<project-path>" \
  --sender-name "ETAArchitect" \
  --to '["ETAArchitect"]' \
  --thread-id "eta:<project-slug>" \
  --subject "[COMPLETE] <project-slug> - ETA Report Ready" \
  --body-md "## ETA Complete

**Final Report**: \`docs/<YYYYMMDD-project>.md\`

## Summary

| Metric | Value |
|--------|-------|
| Total Effort | **134h** (with buffer) |
| Duration | 3.5 weeks (1 dev) |
| Cost Range | $13,400 - $20,100 |

## Deliverables

- [x] Input extracted
- [x] Clarifications complete
- [x] Research documented
- [x] Scope defined
- [x] Estimation complete
- [x] Risks assessed
- [x] Final report generated

## Open Questions

1. ❓ <question 1>
2. ❓ <question 2>

## Next Steps

1. Client review
2. Sign-off
3. Start development"
```

---

## Fetching Context

### Summarize ETA Thread

```bash
am summarize_thread \
  --project-key "<project-path>" \
  --thread-id "eta:<project-slug>"
```

### Fetch Recent Messages

```bash
am fetch_inbox \
  --project-key "<project-path>" \
  --agent-name "ETAArchitect" \
  --include-bodies true
```

### Search ETA Messages

```bash
am search_messages \
  --project-key "<project-path>" \
  --query "<project-slug>" \
  --limit 20
```

---

## Quick Reference

| Phase | Subject Prefix | Purpose |
|-------|---------------|---------|
| Input | `[INPUT]` | Extracted requirements |
| Clarify | `[CLARIFY]` | Q&A results |
| Research | `[RESEARCH]` | Solution evaluation |
| Scope | `[SCOPE]` | Boundaries defined |
| Estimate | `[ESTIMATE]` | Hours calculated |
| Risks | `[RISKS]` | Buffer calculated |
| Complete | `[COMPLETE]` | Final report ready |
