---
name: role-extensions
type: target-role-mapping
project: mid-target-fixture
updated: 2026-05-05
---

# Конкретные роли mid-target

- id: business-owner
  title: Бизнес-владелец продукта
  extends: [product-owner]
  agent_kind: human
  tool_categories: [issue-tracker, knowledge-base, chat]
  phases: [vision, requirements]
  alphas: [Opportunity, Stakeholders]
  interests: [рынок, ROI, стратегия]

- id: backend-developer
  title: Backend-разработчик
  extends: [developer]
  agent_kind: human
  tool_categories: [vcs, issue-tracker, chat]
  phases: [development, testing]
  alphas: [Software System, Work]
  interests: [API, производительность, надёжность]

- id: consistency-auditor
  title: Сквозной аудитор
  extends: [method-engineer]
  agent_kind: ai
  tool_categories: [knowledge-base, issue-tracker]
  phases: [сквозная]
  alphas: [Way of Working]
  interests: [согласованность артефактов]
  notes: AI-агент; запускается webhook'ом изменения артефакта
