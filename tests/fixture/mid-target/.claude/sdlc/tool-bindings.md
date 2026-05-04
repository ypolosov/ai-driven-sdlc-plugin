---
name: tool-bindings
type: tool-binding-registry
project: mid-target-fixture
version: 1
updated: 2026-05-05
---

# Привязки категорий mid-target

bindings:
  - category: issue-tracker
    mcp_server: mock-tracker
    env_keys: [TRACKER_TOKEN]
    rate_limit_per_min: 30
  - category: vcs
    mcp_server: mock-vcs
    env_keys: [VCS_TOKEN]
  - category: chat
    mcp_server: mock-chat
    env_keys: [CHAT_TOKEN]
    rate_limit_per_min: 60
