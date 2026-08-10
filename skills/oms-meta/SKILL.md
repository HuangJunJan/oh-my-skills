---
name: oms-meta
primary: true
description: >
  任一 oms-* skill 生效时共同加载。触发于：代码/仓库检查、工具调用、时效事实核验、
  验证交付、敏感操作、skill 维护。关键词：搜、查、跑、验证、部署、发布。
---

# OhMySkills 元规则

本 skill 优先于其它 `oms-*`。它管跨任务、跨语言、跨平台的最高层规则。

## Always Read
1. `rules/priority.md` — 指令层级
2. `rules/evidence-integrity.md` — 证据与验证完整性

## Session Discipline
每个新任务——同一会话的第 N 轮——必须重读本 SKILL.md、重新匹配 Common Tasks、重读对应必读文件。
检验：这次读的文件和 Common Tasks 里对应路由列的完全一致吗？

## Common Tasks
| 任务 | 必读 | 流程 |
|------|------|------|
| 工具调用 / MCP / 浏览器 | `rules/tool-capability.md` | — |
| 时效事实核验（"最新/查一下"） | `rules/fact-checking.md` | — |
| 跨平台命令执行 | `rules/platform-baseline.md` | — |
| Skill 维护（新增/修改/拆分） | `rules/skill-maintenance.md` | — |
| 任何任务结束 | — | `workflows/task-closure.md` |
| 多子任务（≥3 个独立子任务） | `rules/priority.md` + `rules/evidence-integrity.md` | `workflows/subagent-driven.md` |
| 规则清退 / 废弃检测 | `rules/skill-maintenance.md` | `workflows/rule-deprecation.md` |
| Other | `rules/priority.md` + `rules/evidence-integrity.md` | — |

## Known Gotchas
- 不把"没有报错"当成功 → `rules/evidence-integrity.md`
- 不基于印象判断库/API 行为 → `rules/fact-checking.md`
- 不同 shell 语法不互译（PowerShell ≠ bash）→ `rules/platform-baseline.md`
- Skill 规则禁止复制到多份 → `rules/skill-maintenance.md`

## Red Flags — STOP
- 发现自己在说"应该没问题"/"看起来能跑" → 停，读 `rules/evidence-integrity.md`
- 工具不可用时手工模拟结果 → 停，读 `rules/tool-capability.md`
- 用 bash 语法在 PowerShell 里硬跑（或反过来）→ 停，读 `rules/platform-baseline.md`

## Core Principles
- **宿主优先**：所有 skill 先遵循宿主 agent 的安全、权限、沙箱规则
- **事实核验**：未读过的代码/未查过的接口/未见过的库行为 → 标为未确认
- **证据完整**：最终回复只报告真实完成的事
- **分层维护**：跨 skill 共用规则只保留在一个位置，其它用 `$oms-X` 引用
