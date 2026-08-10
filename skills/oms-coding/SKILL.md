---
name: oms-coding
description: >
  任何代码改动/新增/删除/验证/交付任务。关键词：改/加/删/修/写/实现/重构/修bug/
  fix/add/remove/change/implement/refactor/debug。约束：不触发于纯对话/纯审查/纯问答。
  叠加 $oms-meta。后端项目同时加载 $oms-be-coding，前端项目同时加载 $oms-fe-coding。
---

# OhMySkills 通用编码执行规范

本 skill 是通用编码层，任何代码改动都触发。后端见 `$oms-be-coding`，前端见 `$oms-fe-coding`，对话见 `$oms-qa`，元规则见 `$oms-meta`。
领域 skill 的具体规则优先于本 skill 的通用规则。

## Always Read
1. `rules/code-quality.md` — 命名/函数/类型/注释/安全/依赖
2. `rules/sensitive.md` — 敏感边界（含 .env/密钥/破坏性命令）

## Session Discipline
每个新任务——同一会话的第 N 轮——必须重读本 SKILL.md、重新匹配 Common Tasks、重读对应必读文件。
检验：这次读的文件和 Common Tasks 里对应路由列的完全一致吗？

## Common Tasks
| 任务 | 必读 | 流程 |
|------|------|------|
| Fix bug（修缺陷） | `rules/debugging.md` + `rules/fix-strategy.md` | `workflows/fix-bug.md` |
| Add feature / 新增功能 | `rules/code-quality.md` + domain rules | `workflows/add-feature.md` |
| Refactor / 重构 | `rules/fix-strategy.md` + `rules/code-quality.md` | `workflows/add-feature.md` |
| 验证 / 交付 | `rules/verification.md` | `../oms-meta/workflows/task-closure.md` |
| Other | `rules/code-quality.md` + `rules/sensitive.md` | 按最接近的 workflow |

## Known Gotchas
- **禁止静默兜底**：不为"看起来能跑"加空 catch/默认值/判空/防御分支 → `references/gotchas.md#silent-fallback`
- **拒绝 mode 堆砌**：不用 bool/enum/字符串 mode 让一个函数承载多套本质不同的业务流程 → `references/gotchas.md#mode-bloat`
- **先读再改**：没读相关代码/相邻实现/测试就动手 → 必定漏约束
- **根因修复**：修问题本身，不绕过症状；过度 gate/mode/兼容层优先删除
- **交付报告**：改动文件、为什么这样改、验证结果、未做事项、风险边界

## Red Flags — STOP
- "这个 catch 只是以防万一" → 停，读 `rules/debugging.md` §禁止静默兜底
- "顺便格式化/重命名/升级依赖" → 停，撤销无关改动
- 任务声明"完成"但没跑验证 → 停，走 `../oms-meta/workflows/task-closure.md` 的 AAR
- "没报错所以没问题" → 停，读 `rules/verification.md` 确认成功标准
